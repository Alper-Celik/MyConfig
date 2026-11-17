//! Prefix-free label generation (tmux-thumbs scheme, adapted).
//!
//! With ≤|alphabet| matches every label is a single letter. Beyond that, the
//! *last* single letters are converted into two-letter prefixes (`z` → `za`,
//! `zb`, …; then `y` → `ya`, …) until there are enough labels. A converted
//! letter is no longer a label itself, so no label is ever a prefix of
//! another — typing is unambiguous and Backspace always has a well-defined
//! effect. Shortest labels sit at the front so callers hand them to the
//! matches nearest the cursor.
//!
//! Default 26-letter alphabet: ≤26 matches → 1 key; ≤676 → 2 keys; beyond
//! that extra matches stay unlabeled (676 is already extreme for one screen).

/// Generate `count` labels from `alphabet`. Returns fewer if the alphabet
/// can't support that many (2-letter cap → |alphabet|² max).
pub fn generate(count: usize, alphabet: &[char]) -> Vec<String> {
    // Deduplicate while preserving order.
    let mut letters: Vec<char> = Vec::new();
    for &c in alphabet {
        if !letters.contains(&c) {
            letters.push(c);
        }
    }
    if count == 0 || letters.is_empty() {
        return Vec::new();
    }
    // A one-letter alphabet can produce at most one prefix-free label
    // ("a" excludes "aa", "aa" excludes "a" — either way, just one).
    if letters.len() == 1 {
        return vec![letters[0].to_string()];
    }

    let mut singles: Vec<String> = letters.iter().map(|c| c.to_string()).collect();
    if count <= singles.len() {
        singles.truncate(count);
        return singles;
    }

    // Convert trailing singles into two-letter prefixes until we have enough.
    let mut two_char: Vec<String> = Vec::new();
    while singles.len() + two_char.len() < count {
        let Some(prefix) = singles.pop() else {
            break; // every letter is already a prefix: capacity exhausted
        };
        for &c in &letters {
            if singles.len() + two_char.len() >= count {
                break;
            }
            two_char.push(format!("{prefix}{c}"));
        }
    }

    let mut labels: Vec<String> = Vec::with_capacity(singles.len() + two_char.len());
    labels.extend(singles);
    labels.extend(two_char);
    labels
}

#[cfg(test)]
mod tests {
    use super::*;

    const ALPHA: &[char] = &[
        'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r',
        's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
    ];

    fn is_prefix_free(labels: &[String]) -> bool {
        for (i, a) in labels.iter().enumerate() {
            for (j, b) in labels.iter().enumerate() {
                if i != j && b.starts_with(a) {
                    return false;
                }
            }
        }
        true
    }

    #[test]
    fn few_matches_get_single_letters() {
        assert_eq!(generate(0, ALPHA), Vec::<String>::new());
        assert_eq!(generate(1, ALPHA), vec!["a"]);
        assert_eq!(generate(3, ALPHA), vec!["a", "b", "c"]);
        let full = generate(26, ALPHA);
        assert_eq!(full.len(), 26);
        assert_eq!(full.last().unwrap(), "z");
    }

    #[test]
    fn beyond_alphabet_uses_two_keys() {
        let labels = generate(27, ALPHA);
        assert_eq!(labels.len(), 27);
        // 25 singles + the first two children of the popped last letter.
        assert_eq!(labels[24], "y");
        assert_eq!(labels[25], "za");
        assert_eq!(labels[26], "zb");
        assert!(is_prefix_free(&labels));
    }

    #[test]
    fn second_prefix_letter_kicks_in_early() {
        // 52 > 26 + 26: the last single ('z') fills all 26 children and 'y'
        // contributes one more.
        let labels = generate(52, ALPHA);
        assert_eq!(labels.len(), 52);
        assert_eq!(labels[23], "x");
        assert_eq!(labels[24], "za");
        assert_eq!(labels[25], "zb");
        assert_eq!(labels[26], "zc");
        // 'y' children come after all 26 'z' children.
        assert_eq!(labels[50], "ya");
        assert_eq!(labels[51], "yb");
        assert!(is_prefix_free(&labels));
    }

    #[test]
    fn prefix_free_at_boundaries_and_capacity_cap() {
        let capacity = ALPHA.len() * ALPHA.len(); // 676
        for n in [25, 26, 27, 30, 51, 52, 100, 500, 675, 676, 677, 700] {
            let labels = generate(n, ALPHA);
            let expect = n.min(capacity);
            assert_eq!(labels.len(), expect, "n={n}");
            assert!(is_prefix_free(&labels), "n={n}");
            assert!(
                labels.iter().all(|l| l.chars().count() <= 2),
                "n={n}"
            );
        }
    }

    #[test]
    fn tiny_alphabet() {
        let alpha: Vec<char> = "ab".chars().collect();
        // Capacity 2×2=4; asking for 5 caps at 4, and every single is
        // consumed as a prefix so all labels are two chars.
        let labels = generate(5, &alpha);
        assert_eq!(labels.len(), 4);
        assert!(is_prefix_free(&labels));
        assert!(labels.iter().all(|l| l.chars().count() == 2));
        assert!(labels.contains(&"ba".to_string()));
        assert!(labels.contains(&"aa".to_string()));
    }

    #[test]
    fn single_letter_alphabet_yields_one_label() {
        let alpha: Vec<char> = "aaaa".chars().collect(); // dedups to one
        assert_eq!(generate(3, &alpha), vec!["a"]);
    }

    #[test]
    fn duplicates_in_alphabet_are_deduped() {
        let alpha: Vec<char> = "aababc".chars().collect();
        assert_eq!(generate(3, &alpha), vec!["a", "b", "c"]);
    }
}
