# SPDX-FileCopyrightText: 2026 Alper Çelik <alper@alper-celik.dev>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

# Loaded by every `direnv` evaluation (stdlib), so it runs for every project
# with an .envrc — including each git worktree of one.
#
# sccache hashes the absolute paths it is given, so two checkouts of the same
# repo would otherwise never share cached rlibs. Normalizing the hash to the
# worktree root makes `target/` and `src/...` paths identical across worktrees
# (measured: the second worktree hits on its dependencies).
if git rev-parse --show-toplevel >/dev/null 2>&1; then
  export SCCACHE_BASEDIRS="$(git rev-parse --show-toplevel)"
else
  export SCCACHE_BASEDIRS="$PWD"
fi
