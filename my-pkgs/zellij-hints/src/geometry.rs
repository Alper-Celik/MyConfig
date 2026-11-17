//! On-screen geometry: display-column math (wide and zero-width
//! characters) and the column-indexed layout of a visual row for
//! rendering.

use crate::grid::{Cell, Style};
use unicode_width::UnicodeWidthChar;

/// Display width of a character in terminal columns (0 for combining marks
/// and controls, 1 for most, 2 for CJK/emoji).
pub fn char_display_width(c: char) -> usize {
    c.width().unwrap_or(0)
}

/// Where a character sits on screen: `(visual_row, column)` within the
/// block of rows that one logical line occupies. Columns are *display*
/// columns — they diverge from cell indexes whenever a row contains wide
/// characters.
pub type Placement = (usize, usize);

/// One display column of a rendered row: the glyph printed there and its
/// style. `text` holds a base character plus any zero-width characters
/// attached to it.
#[derive(Clone, Debug, PartialEq, Eq, Default)]
pub struct Glyph {
    pub text: String,
    pub style: Style,
}

impl Glyph {
    /// Display width of this glyph (that of its base character).
    pub fn width(&self) -> usize {
        self.text
            .chars()
            .next()
            .map(char_display_width)
            .unwrap_or(0)
    }
}

/// Lay one visual row of cells into `width` display columns.
///
/// The result is column-indexed: a wide character occupies its column and
/// leaves `None` (a continuation) in the following one, zero-width
/// characters are appended to the previous glyph's text, and columns past
/// the row's content are `None` (blank). Emitters print a plain space for
/// `None` slots, so a row never emits more columns than it occupies —
/// everything after it stays in place.
pub fn lay_row(cells: &[Cell], width: usize) -> Vec<Option<Glyph>> {
    let mut out: Vec<Option<Glyph>> = vec![None; width];
    let mut col = 0usize;
    let mut last: Option<usize> = None; // column of the last glyph started
    for cell in cells {
        let w = char_display_width(cell.ch);
        if w == 0 {
            // Zero-width chars (combining marks) attach to the preceding
            // glyph in this row; a row-leading one has nowhere to go.
            if let Some(c) = last {
                if let Some(Some(glyph)) = out.get_mut(c) {
                    glyph.text.push(cell.ch);
                }
            }
            continue;
        }
        if col + w > width {
            break; // a wide char that doesn't fit the last column
        }
        out[col] = Some(Glyph {
            text: cell.ch.to_string(),
            style: cell.style,
        });
        last = Some(col);
        col += w;
    }
    out
}

#[cfg(test)]
mod tests {
    use super::*;

    fn cells(s: &str) -> Vec<Cell> {
        s.chars()
            .map(|ch| Cell {
                ch,
                style: Default::default(),
            })
            .collect()
    }

    #[test]
    fn lay_row_indexes_by_display_column() {
        // 漢 and 字 are 2 columns wide: 4 cells fill 6 columns, with a
        // `None` continuation after each wide glyph.
        let laid = lay_row(&cells("漢字ab"), 6);
        assert_eq!(laid.len(), 6);
        assert_eq!(laid[0].as_ref().unwrap().text, "漢");
        assert_eq!(laid[0].as_ref().unwrap().width(), 2);
        assert!(laid[1].is_none()); // continuation of 漢
        assert_eq!(laid[2].as_ref().unwrap().text, "字");
        assert!(laid[3].is_none()); // continuation of 字
        assert_eq!(laid[4].as_ref().unwrap().text, "a");
        assert_eq!(laid[5].as_ref().unwrap().text, "b");
    }

    #[test]
    fn lay_row_pads_short_rows_with_blank_columns() {
        let laid = lay_row(&cells("ab"), 6);
        assert_eq!(laid.len(), 6);
        assert_eq!(laid[0].as_ref().unwrap().text, "a");
        assert!(laid[2..].iter().all(|s| s.is_none()));
    }

    #[test]
    fn lay_row_stops_when_a_wide_char_doesnt_fit() {
        // Second 漢 would need columns 2–3 of a 2-column row.
        let laid = lay_row(&cells("漢漢"), 2);
        assert_eq!(laid.len(), 2);
        assert_eq!(laid[0].as_ref().unwrap().text, "漢");
        assert!(laid[1].is_none());
    }

    #[test]
    fn lay_row_attaches_zero_width_chars_to_previous_glyph() {
        // 'e' + combining acute (U+0301, zero width) + 'a' — written with
        // escapes so the source can't accidentally hold precomposed é.
        let laid = lay_row(&cells("\u{65}\u{301}a"), 10);
        assert_eq!(laid.len(), 10);
        assert_eq!(laid[0].as_ref().unwrap().text, "\u{65}\u{301}");
        assert_eq!(laid[1].as_ref().unwrap().text, "a");
    }
}
