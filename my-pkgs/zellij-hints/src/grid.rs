//! Styled-cell screen model parsed from pane content.
//!
//! The screen is a list of logical [`Line`]s, and each line stores the
//! **exact visual rows** it occupies on screen — no re-wrapping, ever. The
//! rows come straight from the pane viewport, which preserves wrapped-row
//! trailing spaces and wide-character layout.
//!
//! Two input paths (both produce the same `Screen`):
//! - [`Screen::from_viewport_with_ansi`] (primary): plain viewport rows
//!   (exact text and geometry — the source of truth) merged with an ANSI
//!   dump (`DumpScreen --ansi`) for colors and logical-line grouping.
//! - [`Screen::from_viewport_rows`] (monochrome fallback): rows grouped
//!   into logical lines with a full-width heuristic.

use crate::geometry::{char_display_width, Placement};
use vte::{Params, Parser, Perform};

#[derive(Clone, Copy, PartialEq, Eq, Debug, Default)]
pub enum Color {
    #[default]
    Default,
    Indexed(u8),
    Rgb(u8, u8, u8),
}

#[derive(Clone, Copy, PartialEq, Eq, Debug, Default)]
pub struct Style {
    pub fg: Color,
    pub bg: Color,
    pub bold: bool,
    pub italic: bool,
    pub underline: bool,
    /// Faint (SGR 2). Never set by parsing — used by the overlay renderer
    /// to dim non-match content.
    pub dim: bool,
}

impl Style {
    /// SGR escape that establishes this style from a clean slate.
    pub fn sgr(&self) -> String {
        let mut codes: Vec<String> = vec!["0".into()];
        if self.bold {
            codes.push("1".into());
        }
        if self.dim {
            codes.push("2".into());
        }
        if self.italic {
            codes.push("3".into());
        }
        if self.underline {
            codes.push("4".into());
        }
        match self.fg {
            Color::Default => {}
            Color::Indexed(i) => codes.push(format!("38;5;{i}")),
            Color::Rgb(r, g, b) => codes.push(format!("38;2;{r};{g};{b}")),
        }
        match self.bg {
            Color::Default => {}
            Color::Indexed(i) => codes.push(format!("48;5;{i}")),
            Color::Rgb(r, g, b) => codes.push(format!("48;2;{r};{g};{b}")),
        }
        format!("\x1b[{}m", codes.join(";"))
    }
}

#[derive(Clone, Copy, PartialEq, Eq, Debug)]
pub struct Cell {
    pub ch: char,
    pub style: Style,
}

impl Default for Cell {
    fn default() -> Self {
        Cell {
            ch: ' ',
            style: Style::default(),
        }
    }
}

/// One logical line of the pane: the exact visual rows it occupies,
/// top to bottom. Every row except the last is full wrapped content —
/// trailing spaces included, exactly as the terminal shows them. The last
/// row holds the line's content trimmed of trailing padding.
#[derive(Clone, Debug, Default)]
pub struct Line {
    pub rows: Vec<Vec<Cell>>,
}

impl Line {
    /// The line's text: its rows concatenated (wrapped rows joined without
    /// losing the spaces at wrap boundaries).
    pub fn text(&self) -> String {
        self.rows
            .iter()
            .flat_map(|r| r.iter().map(|c| c.ch))
            .collect()
    }

    /// Placement of every character of the line: `(row index within the
    /// line, display column)`. Wide characters advance by their width;
    /// zero-width characters share the previous character's placement.
    pub fn placements(&self) -> Vec<Placement> {
        let mut out = Vec::new();
        for (ri, row) in self.rows.iter().enumerate() {
            let mut col = 0usize;
            for cell in row {
                let w = char_display_width(cell.ch);
                if w == 0 {
                    let p = out.last().copied().unwrap_or((ri, 0));
                    out.push(p);
                    continue;
                }
                out.push((ri, col));
                col += w;
            }
        }
        out
    }
}

/// The pane as logical lines of styled cells.
#[derive(Clone, Debug, Default)]
pub struct Screen {
    pub lines: Vec<Line>,
}

impl Screen {
    /// Monochrome fallback from plain viewport rows. A row whose display
    /// width fills the pane and doesn't end in a space was almost certainly
    /// produced by line wrapping, so the row below continues it — matching
    /// then works across wraps even without the colored dump.
    pub fn from_viewport_rows(rows: &[String], width: usize) -> Screen {
        let mut lines: Vec<Line> = Vec::new();
        let mut cur: Vec<Vec<Cell>> = Vec::new();
        for row in rows {
            let cells: Vec<Cell> = row
                .chars()
                .map(|ch| Cell {
                    ch,
                    style: Style::default(),
                })
                .collect();
            // Compare display widths, not char counts: a fully-wrapped row
            // containing wide characters holds fewer chars than columns.
            let row_width: usize = cells.iter().map(|c| char_display_width(c.ch)).sum();
            let wrapped = width > 0
                && row_width == width
                && cells.last().is_some_and(|c| c.ch != ' ');
            cur.push(cells);
            if !wrapped {
                trim_trailing_spaces(cur.last_mut().expect("just pushed"));
                lines.push(Line {
                    rows: std::mem::take(&mut cur),
                });
            }
        }
        if !cur.is_empty() {
            lines.push(Line { rows: cur });
        }
        // Drop trailing all-blank lines (below where output ended).
        while lines.last().is_some_and(is_blank_line) {
            lines.pop();
        }
        Screen { lines }
    }

    /// Primary path: merge the plain viewport rows — the source of truth
    /// for text and geometry — with the ANSI dump, which contributes colors
    /// and logical-line grouping.
    ///
    /// The dump joins wrapped rows with no separator and trims trailing
    /// spaces from every row, so its text cannot be used for positions
    /// (a space at a wrap boundary is lost and the words glue together).
    /// Instead, each dump line is split back onto the viewport rows it
    /// covers: a row's dump content is always a prefix of that row (the
    /// dump only drops trailing plain spaces), so we look for a split that
    /// consumes the dump line exactly. Runs of spaces around row
    /// boundaries are invisible in the dump, so several splits can be
    /// consistent with the data — the search backtracks until one fits,
    /// and the ambiguity only ever affects style alignment, never the
    /// text: wrapped rows keep their full viewport text (lost spaces
    /// restored), the last row is trimmed to its dump content.
    ///
    /// Returns `None` when the dump doesn't line up with the rows (e.g.
    /// the pane produced output between the two captures) — callers fall
    /// back to [`Screen::from_viewport_rows`].
    pub fn from_viewport_with_ansi(viewport: &[String], dump: &[u8]) -> Option<Screen> {
        let dump_lines = parse_ansi_dump(dump);
        let rows: Vec<Vec<char>> = viewport.iter().map(|r| r.chars().collect()).collect();
        let mut lines: Vec<Line> = Vec::with_capacity(dump_lines.len());
        let mut rest: &[Vec<char>] = &rows;
        for dump_line in &dump_lines {
            let (line, used) = align_dump_line(dump_line, rest)?;
            lines.push(line);
            rest = &rest[used..];
        }
        // The dump trims trailing blank lines; any rows it doesn't cover
        // must be blank padding below where the output ended.
        if rest.iter().any(|r| r.iter().any(|&c| c != ' ')) {
            return None;
        }
        while lines.last().is_some_and(is_blank_line) {
            lines.pop();
        }
        Some(Screen { lines })
    }

    pub fn text_of_line(&self, idx: usize) -> String {
        self.lines.get(idx).map(|l| l.text()).unwrap_or_default()
    }
}

/// Parse an ANSI screen dump (`DumpScreen --ansi` output) into its logical
/// lines of styled cells: the dump emits `\n` only at canonical line
/// starts, so each parsed line is one logical line with its wrapped rows
/// concatenated and their trailing spaces missing. Only meaningful together
/// with the viewport rows — see [`Screen::from_viewport_with_ansi`].
fn parse_ansi_dump(bytes: &[u8]) -> Vec<Vec<Cell>> {
    let mut sink = GridSink::default();
    let mut parser = Parser::new();
    for &b in bytes {
        parser.advance(&mut sink, b);
    }
    sink.finish()
}

fn is_blank_line(line: &Line) -> bool {
    line.rows.iter().all(|r| r.iter().all(|c| c.ch == ' '))
}

fn trim_trailing_spaces(cells: &mut Vec<Cell>) {
    while cells.last().is_some_and(|c| c.ch == ' ') {
        cells.pop();
    }
}

/// Align one dump line onto the viewport rows it covers; returns the line
/// and the number of rows it consumed.
fn align_dump_line(dump: &[Cell], rows: &[Vec<char>]) -> Option<(Line, usize)> {
    if dump.is_empty() {
        // A blank dump line is one blank canonical row.
        let v = rows.first()?;
        if v.iter().any(|&c| c != ' ') {
            return None; // dump and viewport disagree
        }
        return Some((Line { rows: vec![Vec::new()] }, 1));
    }
    let mut line_rows: Vec<Vec<Cell>> = Vec::new();
    let used = consume_dump(dump, rows, &mut line_rows)?;
    Some((Line { rows: line_rows }, used))
}

/// Split `dump` across viewport rows, depth-first. Each row consumes `d`
/// cells of the dump, where `d` may be anywhere between the row's
/// trimmed length (all trailing spaces were dropped by the dump) and the
/// length of the common prefix (some trailing spaces were styled and thus
/// kept) — that range is where boundary spaces are ambiguous. The row
/// that exhausts the dump ends the logical line.
fn consume_dump(dump: &[Cell], rows: &[Vec<char>], out: &mut Vec<Vec<Cell>>) -> Option<usize> {
    let v = rows.first()?;
    let min_d = trailing_space_start(v);
    let max_d = common_prefix(dump, v);
    // Prefer consuming as much dump content as possible; backtrack if the
    // remaining rows can't explain the rest.
    for d in (min_d..=max_d).rev() {
        out.push(row_cells(v, &dump[..d]));
        if d == dump.len() {
            // Dump exhausted: this row ends the line. Everything past the
            // dump content is trailing padding (only spaces can be there).
            out.last_mut().expect("just pushed").truncate(d);
            return Some(1);
        }
        if let Some(more) = consume_dump(&dump[d..], &rows[1..], out) {
            return Some(1 + more);
        }
        out.pop();
    }
    None
}

/// Style the full viewport row `v` from the first `d` dump cells; cells
/// past the dump content (spaces the dump dropped) get the default style.
fn row_cells(v: &[char], styled: &[Cell]) -> Vec<Cell> {
    v.iter()
        .enumerate()
        .map(|(i, &ch)| Cell {
            ch,
            style: styled.get(i).map(|c| c.style).unwrap_or_default(),
        })
        .collect()
}

/// Char index where `v`'s trailing run of spaces starts.
fn trailing_space_start(v: &[char]) -> usize {
    let mut s = v.len();
    while s > 0 && v[s - 1] == ' ' {
        s -= 1;
    }
    s
}

/// Length of the common prefix of `dump` and `v`, compared by character.
fn common_prefix(dump: &[Cell], v: &[char]) -> usize {
    dump.iter()
        .zip(v)
        .take_while(|(d, &c)| d.ch == c)
        .count()
}

/// vte sink: raw ANSI bytes in, logical lines of styled cells out.
#[derive(Default)]
struct GridSink {
    lines: Vec<Vec<Cell>>,
    cur: Vec<Cell>,
    style: Style,
}

impl GridSink {
    fn finish(mut self) -> Vec<Vec<Cell>> {
        if !self.cur.is_empty() {
            self.lines.push(std::mem::take(&mut self.cur));
        }
        // A pane dump includes the whole viewport; everything below where the
        // output ended is blank. Trim it so it doesn't show as dead space.
        while self
            .lines
            .last()
            .is_some_and(|l| l.iter().all(|c| c.ch == ' '))
        {
            self.lines.pop();
        }
        self.lines
    }

    /// Interpret one SGR sequence into `self.style`. Handles the subset the
    /// dump can contain: reset, bold/italic/underline, fg/bg (basic,
    /// bright, 256-color and truecolor).
    fn sgr(&mut self, params: &Params) {
        // Flatten sub-params (`38:5:196` and `38;5;196` both work).
        let flat: Vec<u16> = params.iter().flat_map(|p| p.iter().copied()).collect();
        if flat.is_empty() {
            self.style = Style::default();
            return;
        }
        let mut i = 0;
        while i < flat.len() {
            match flat[i] {
                0 => self.style = Style::default(),
                1 => self.style.bold = true,
                3 => self.style.italic = true,
                4 => self.style.underline = true,
                22 => self.style.bold = false,
                23 => self.style.italic = false,
                24 => self.style.underline = false,
                30..=37 => self.style.fg = Color::Indexed((flat[i] - 30) as u8),
                39 => self.style.fg = Color::Default,
                90..=97 => self.style.fg = Color::Indexed((flat[i] - 90 + 8) as u8),
                40..=47 => self.style.bg = Color::Indexed((flat[i] - 40) as u8),
                49 => self.style.bg = Color::Default,
                100..=107 => self.style.bg = Color::Indexed((flat[i] - 100 + 8) as u8),
                38 | 48 => {
                    let is_fg = flat[i] == 38;
                    let color = match flat.get(i + 1) {
                        Some(5) => flat.get(i + 2).map(|v| Color::Indexed(*v as u8)),
                        Some(2) => match (flat.get(i + 2), flat.get(i + 3), flat.get(i + 4)) {
                            (Some(r), Some(g), Some(b)) => {
                                Some(Color::Rgb(*r as u8, *g as u8, *b as u8))
                            }
                            _ => None,
                        },
                        _ => None,
                    };
                    if let Some(c) = color {
                        if is_fg {
                            self.style.fg = c;
                        } else {
                            self.style.bg = c;
                        }
                    }
                    // Skip consumed params regardless of parse success.
                    match flat.get(i + 1) {
                        Some(5) => i += 2,
                        Some(2) => i += 4,
                        _ => {}
                    }
                }
                _ => {}
            }
            i += 1;
        }
    }
}

impl Perform for GridSink {
    fn print(&mut self, c: char) {
        self.cur.push(Cell {
            ch: c,
            style: self.style,
        });
    }

    fn execute(&mut self, byte: u8) {
        // In the dump, `\n` is a canonical line boundary. `\r` and other C0
        // controls carry no layout meaning for a line grid.
        if byte == b'\n' {
            self.lines.push(std::mem::take(&mut self.cur));
        }
    }

    fn csi_dispatch(&mut self, params: &Params, _i: &[u8], _ignore: bool, action: char) {
        if action == 'm' {
            self.sgr(params);
        }
        // Cursor movement sequences (CUP, CUU, EL, …) are not replayed: the
        // dump linearizes the viewport, and our wrap reconstruction ignores
        // them. Known limitation for apps that paint with cursor moves.
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn merge_restores_space_lost_at_wrap_boundary() {
        // Width 19. The logical line "see src/foo.rs and more" wraps with a
        // space in the last column; the dump drops that space, so its text
        // reads "…src/foo.rs andmore" (words glued). Merged back onto the
        // exact rows, the space survives and the dump's colors land on the
        // right cells.
        let viewport = vec!["see src/foo.rs and ".to_string(), "more".to_string()];
        let dump = b"see \x1b[38;5;2msrc/foo.rs\x1b[0m andmore\x1b[m";
        let screen = Screen::from_viewport_with_ansi(&viewport, dump).expect("aligns");
        assert_eq!(screen.lines.len(), 1);
        let line = &screen.lines[0];
        assert_eq!(line.rows.len(), 2);
        // Text comes from the viewport rows, not the dump.
        assert_eq!(line.text(), "see src/foo.rs and more");
        // Colors come from the dump: "src/foo.rs" (chars 4..14) is green.
        assert_eq!(line.rows[0][3].style.fg, Color::Default);
        assert_eq!(line.rows[0][4].style.fg, Color::Indexed(2));
        assert_eq!(line.rows[0][13].style.fg, Color::Indexed(2));
        assert_eq!(line.rows[0][14].style.fg, Color::Default);
        // The wrap-boundary space (dropped by the dump) is restored with
        // the default style.
        assert_eq!(line.rows[0][18].ch, ' ');
        assert_eq!(line.rows[0][18].style, Style::default());
        let row1_text: String = line.rows[1].iter().map(|c| c.ch).collect();
        assert_eq!(row1_text, "more");
    }

    #[test]
    fn merge_backtracks_over_boundary_space_runs() {
        // Width 5. Row 0 is "abc  " (wrapped, two trailing spaces); row 1
        // continues with " def". The dump is "abc" + " def" = "abc def":
        // greedily giving row 0 four dump cells leaves "def" for a row
        // that starts with a space — the merge must backtrack to d=3.
        let viewport = vec!["abc  ".to_string(), " def".to_string()];
        let dump = b"abc def\x1b[m";
        let screen = Screen::from_viewport_with_ansi(&viewport, dump).expect("aligns");
        assert_eq!(screen.lines.len(), 1);
        assert_eq!(screen.lines[0].text(), "abc   def"); // 3 spaces
        assert_eq!(screen.lines[0].rows.len(), 2);
    }

    #[test]
    fn merge_keeps_styled_trailing_spaces() {
        // Width 8. The row's trailing space is background-styled, so the
        // dump keeps it ("done" + SGR + " ") instead of trimming it; the
        // merge must attribute it to this row (d beyond the trimmed
        // length), not hand it to the next line.
        let viewport = vec!["done ".to_string(), "next".to_string()];
        let dump = b"done\x1b[48;5;4m \x1b[m\nnext\x1b[m";
        let screen = Screen::from_viewport_with_ansi(&viewport, dump).expect("aligns");
        assert_eq!(screen.lines.len(), 2);
        assert_eq!(screen.lines[0].text(), "done ");
        assert_eq!(screen.lines[0].rows[0][4].style.bg, Color::Indexed(4));
        assert_eq!(screen.lines[1].text(), "next");
    }

    #[test]
    fn merge_fails_when_dump_disagrees_with_rows() {
        // E.g. the pane produced output between the two captures.
        let viewport = vec!["hello world".to_string()];
        assert!(Screen::from_viewport_with_ansi(&viewport, b"goodbye\x1b[m").is_none());
    }

    #[test]
    fn merge_fails_when_rows_remain_below_unexplained_content() {
        let viewport = vec!["a/b.rs".to_string(), "c/d.rs".to_string()];
        // Dump only covers the first line — a truncated/partial capture.
        assert!(Screen::from_viewport_with_ansi(&viewport, b"a/b.rs\x1b[m").is_none());
    }

    #[test]
    fn merge_keeps_blank_lines_and_drops_trailing_blank_rows() {
        let viewport = vec![
            "a/b.rs".to_string(),
            "".to_string(),
            "c/d.rs".to_string(),
            "".to_string(),
        ];
        // Rows: canonical "a/b.rs", canonical blank, canonical "c/d.rs",
        // canonical blank → dump "a/b.rs\n\nc/d.rs\n".
        let dump = b"a/b.rs\n\nc/d.rs\n\x1b[m";
        let screen = Screen::from_viewport_with_ansi(&viewport, dump).expect("aligns");
        let texts: Vec<String> = screen.lines.iter().map(|l| l.text()).collect();
        assert_eq!(texts, vec!["a/b.rs".to_string(), String::new(), "c/d.rs".to_string()]);
    }

    #[test]
    fn viewport_rows_grouping_is_display_width_aware() {
        // Width 6. "漢字ab" is 4 chars but fills all 6 columns, so it was
        // wrapped and the row below continues the same logical line.
        let rows = vec!["漢字ab".to_string(), "cdef".to_string()];
        let screen = Screen::from_viewport_rows(&rows, 6);
        assert_eq!(screen.lines.len(), 1);
        assert_eq!(screen.lines[0].text(), "漢字abcdef");
        assert_eq!(screen.lines[0].rows.len(), 2);
    }

    #[test]
    fn placements_use_display_columns() {
        // 漢 and 字 are 2 columns wide: "src/x.rs" starts at column 5.
        let line = Line {
            rows: vec!["漢字 src/x.rs"
                .chars()
                .map(|ch| Cell {
                    ch,
                    style: Default::default(),
                })
                .collect()],
        };
        let placements = line.placements();
        assert_eq!(placements[0], (0, 0)); // 漢
        assert_eq!(placements[1], (0, 2)); // 字
        assert_eq!(placements[2], (0, 4)); // ' '
        assert_eq!(placements[3], (0, 5)); // 's' of src
        assert_eq!(placements[6], (0, 8)); // '/'
    }
}
