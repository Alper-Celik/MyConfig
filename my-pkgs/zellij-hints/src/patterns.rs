//! Pattern set: URLs and file paths (v1 scope), overlap resolution by
//! priority, trailing-punctuation trimming.
//!
//! Priority order (highest first): URL → diff paths (`diff --git`, `+++ b/`,
//! `--- a/`) → path with optional `:line[:col]`. The first match to claim a
//! span wins; lower-priority matches overlapping it are dropped.
//!
//! Pattern shapes are adapted from tmux-thumbs (MIT, © 2019 Ferran Basora)
//! and the kitty hints kitten.

use crate::grid::Screen;
use regex::Regex;
use std::ops::Range;

#[derive(Clone, Copy, PartialEq, Eq, Debug, Hash)]
pub enum MatchKind {
    Url,
    Path,
}

impl MatchKind {
    /// Parse a comma-separated enable list, e.g. `"url"`, `"path,url"`,
    /// `"all"` (default when empty/unrecognized).
    pub fn parse_list(spec: &str) -> Vec<MatchKind> {
        let mut kinds = Vec::new();
        for part in spec.split(',') {
            match part.trim() {
                "url" => kinds.push(MatchKind::Url),
                "path" => kinds.push(MatchKind::Path),
                "all" => return vec![MatchKind::Url, MatchKind::Path],
                _ => {}
            }
        }
        if kinds.is_empty() {
            vec![MatchKind::Url, MatchKind::Path]
        } else {
            kinds
        }
    }
}

/// A pattern match on a logical line, after trailing/leading punctuation
/// trimming of the copied text.
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct Match {
    pub kind: MatchKind,
    /// Text to copy (trimmed).
    pub text: String,
    /// Logical line index.
    pub line: usize,
    /// Char index of the (trimmed) match start within the logical line.
    pub char_start: usize,
}

struct Compiled {
    kind: MatchKind,
    regex: Regex,
    /// 1-based capture group holding the text to use; 0 = whole match.
    group: usize,
}

// Leading punctuation never starts a real URL/path (kitty strips it too).
// `.` is deliberately NOT stripped — `./relative` paths start with it.
const LEADING_PUNCT: &str = "([{\"'";
const TRAILING_PUNCT: &str = ".,:;)]}\"'";

/// Compiled v1 pattern set, in priority order.
pub struct PatternSet {
    patterns: Vec<Compiled>,
}

impl PatternSet {
    pub fn new(kinds: &[MatchKind]) -> PatternSet {
        let mut patterns = Vec::new();

        // URL: schemes + scp-style git@host:path.
        let url = r"(?:https?|git|ssh|ftp|file)://\S+|git@[\w.\-]+:[\w.\-/]+";

        // Diff paths: capture the useful side, strip the a/ b/ prefix.
        let diff_git = r"diff --git a/\S+ b/(\S+)";
        let diff_b = r"\+\+\+ b/(\S+)";
        let diff_a = r"--- a/(\S+)";

        // Path with optional :line[:col]. Must contain a `/` (bare filenames
        // are out of scope for v1). First alternative (with line suffix) is
        // preferred by leftmost-first alternation. Segments are word chars
        // plus . - _ @ ~ [ ]; a leading ~/ ../ ./ or plain segment counts.
        let path_re =
            r"(?:(?:~|\.{1,2})?/|[\w.\-@~\[\]]+/)[\w.\-@~\[\]+/]*(?::\d+(?::\d+)?)?";

        if kinds.contains(&MatchKind::Url) {
            patterns.push(Compiled {
                kind: MatchKind::Url,
                regex: Regex::new(url).unwrap(),
                group: 0,
            });
        }
        if kinds.contains(&MatchKind::Path) {
            for (re, group) in [(diff_git, 1), (diff_b, 1), (diff_a, 1), (path_re, 0)] {
                patterns.push(Compiled {
                    kind: MatchKind::Path,
                    regex: Regex::new(re).unwrap(),
                    group,
                });
            }
        }
        PatternSet { patterns }
    }

    /// Find matches on all lines, resolving overlaps by priority
    /// (first pattern to claim a span wins).
    pub fn find(&self, screen: &Screen) -> Vec<Match> {
        let mut out = Vec::new();
        for line_idx in 0..screen.lines.len() {
            out.extend(self.find_in_line(line_idx, &screen.text_of_line(line_idx)));
        }
        out
    }

    fn find_in_line(&self, line: usize, text: &str) -> Vec<Match> {
        // Byte index of each char start → char index conversion.
        let char_starts: Vec<usize> = text.char_indices().map(|(b, _)| b).collect();
        let to_char = |byte: usize| char_starts.partition_point(|&b| b < byte);

        let mut accepted: Vec<Match> = Vec::new();
        let mut claimed: Vec<Range<usize>> = Vec::new(); // byte ranges

        // Highest priority first; within one regex captures_iter is
        // already non-overlapping and leftmost.
        for p in &self.patterns {
            for caps in p.regex.captures_iter(text) {
                let whole = caps.get(0).expect("whole match");
                let raw = whole.range();
                // A lower-priority match inside an already-claimed span
                // (e.g. the path inside a URL) is dropped.
                if claimed.iter().any(|c| raw.start < c.end && c.start < raw.end) {
                    continue;
                }
                let group = if p.group == 0 {
                    raw.clone()
                } else {
                    caps.get(p.group).map(|g| g.range()).unwrap_or_else(|| raw.clone())
                };

                // Trim punctuation off both ends of the group text.
                let raw_text = &text[group.clone()];
                let lead = raw_text
                    .chars()
                    .take_while(|c| LEADING_PUNCT.contains(*c))
                    .count();
                let body: &str = &raw_text[lead..];
                let body_len = body.chars().count();
                let trail = body
                    .chars()
                    .rev()
                    .take_while(|c| TRAILING_PUNCT.contains(*c))
                    .count();
                let kept_chars = body_len - trail;
                if kept_chars == 0 {
                    continue;
                }
                let text_kept: String = body.chars().take(kept_chars).collect();

                // Claim the full raw match so sub-matches of lower-priority
                // patterns can't take the leftover pieces.
                claimed.push(raw);

                let start_byte = group.start + raw_text[..lead].len();
                accepted.push(Match {
                    kind: p.kind,
                    text: text_kept,
                    line,
                    char_start: to_char(start_byte),
                });
            }
        }
        accepted
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::grid::Line;

    fn screen(lines: &[&str]) -> Screen {
        Screen {
            lines: lines
                .iter()
                .map(|l| {
                    Line {
                        rows: vec![l
                            .chars()
                            .map(|ch| crate::grid::Cell {
                                ch,
                                style: Default::default(),
                            })
                            .collect()],
                    }
                })
                .collect(),
        }
    }

    fn find_one(lines: &[&str]) -> Vec<Match> {
        PatternSet::new(&[MatchKind::Url, MatchKind::Path]).find(&screen(lines))
    }

    #[test]
    fn url_wins_over_path_inside_it() {
        let ms = find_one(&["see https://x.y/z/file.rs now"]);
        assert_eq!(ms.len(), 1);
        assert_eq!(ms[0].kind, MatchKind::Url);
        assert_eq!(ms[0].text, "https://x.y/z/file.rs");
    }

    #[test]
    fn path_with_line_and_col() {
        let ms = find_one(&["error at src/main.rs:12:5 did you mean"]);
        assert_eq!(ms.len(), 1);
        assert_eq!(ms[0].text, "src/main.rs:12:5");
        assert_eq!(ms[0].kind, MatchKind::Path);
        assert_eq!(ms[0].char_start, "error at ".chars().count());
    }

    #[test]
    fn path_variants() {
        for (line, expect) in [
            ("run ~/notes/todo.md now", "~/notes/todo.md"),
            ("open ./build/output.log plz", "./build/output.log"),
            ("cat /usr/local/bin/tool", "/usr/local/bin/tool"),
            ("edit ../lib/helper.rs ok", "../lib/helper.rs"),
        ] {
            let ms = find_one(&[line]);
            assert_eq!(ms.len(), 1, "line: {line}");
            assert_eq!(ms[0].text, expect, "line: {line}");
        }
    }

    #[test]
    fn bare_filename_without_slash_is_not_matched() {
        // v1 scope: paths must contain a `/`.
        assert!(find_one(&["error in main.rs:12"]).is_empty());
    }

    #[test]
    fn trailing_punctuation_is_trimmed() {
        for (line, expect) in [
            ("see (https://x.y/z) ok", "https://x.y/z"),
            ("go to https://x.y/z.", "https://x.y/z"),
            ("fix src/main.rs:12:5:", "src/main.rs:12:5"),
            ("see ~/notes/todo.md,", "~/notes/todo.md"),
        ] {
            let ms = find_one(&[line]);
            assert_eq!(ms.len(), 1, "line: {line}");
            assert_eq!(ms[0].text, expect, "line: {line}");
        }
    }

    #[test]
    fn diff_headers_capture_path_without_prefix() {
        let ms = find_one(&["diff --git a/src/lib.rs b/src/lib.rs"]);
        assert_eq!(ms.len(), 1);
        assert_eq!(ms[0].text, "src/lib.rs");

        let ms = find_one(&["+++ b/src/lib.rs"]);
        assert_eq!(ms[0].text, "src/lib.rs");

        let ms = find_one(&["--- a/src/lib.rs"]);
        assert_eq!(ms[0].text, "src/lib.rs");
    }

    #[test]
    fn scp_style_git_url() {
        let ms = find_one(&["clone git@github.com:foo/bar.git plz"]);
        assert_eq!(ms.len(), 1);
        assert_eq!(ms[0].kind, MatchKind::Url);
        assert_eq!(ms[0].text, "git@github.com:foo/bar.git");
    }

    #[test]
    fn multiple_matches_on_one_line() {
        let ms = find_one(&["src/a.rs and src/b.rs"]);
        assert_eq!(ms.len(), 2);
        assert_eq!(ms[0].text, "src/a.rs");
        assert_eq!(ms[1].text, "src/b.rs");
    }

    #[test]
    fn path_inside_git_url_is_not_double_matched() {
        // git@host:path claims the whole span; the bare path pattern
        // must not add a second match for `foo/bar.git`.
        let ms = find_one(&["git@github.com:foo/bar.git"]);
        assert_eq!(ms.len(), 1);
    }

    #[test]
    fn url_word_boundary() {
        // `wordhttps://...` — the URL regex has no lookbehind, so this does
        // match mid-word; accepted for v1 (same as tmux-thumbs).
        let ms = find_one(&["foohttps://x.y/z"]);
        assert_eq!(ms.len(), 1);
        assert_eq!(ms[0].text, "https://x.y/z");
    }
}
