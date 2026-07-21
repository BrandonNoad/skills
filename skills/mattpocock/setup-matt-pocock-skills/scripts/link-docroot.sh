#!/usr/bin/env bash
#
# Create the personal doc root `.brandonnoad/` as a symlink into the repo's
# shared git dir, so every worktree shares the same files and nothing lands in
# the committed tree. Idempotent — safe to run in every worktree.
#
#   .brandonnoad  ->  <git-common-dir>/brandonnoad
#
# `git rev-parse --git-common-dir` returns the MAIN .git even from a linked
# worktree, so the symlink target and the exclude both land in the shared
# location automatically.
set -euo pipefail

common_dir="$(git rev-parse --git-common-dir 2>/dev/null)" || {
  echo "link-docroot: not inside a git repository" >&2
  exit 1
}
common_dir="$(cd "$common_dir" && pwd)"          # normalise to absolute

real="$common_dir/brandonnoad"
mkdir -p "$real"

toplevel="$(git rev-parse --show-toplevel)"
link="$toplevel/.brandonnoad"

if [ -L "$link" ]; then
  :                                              # already a symlink; leave it
elif [ -e "$link" ]; then
  echo "link-docroot: $link exists and is not a symlink; leaving it alone" >&2
  exit 1
else
  ln -s "$real" "$link"
fi

# Surface the personal overview as a gitignored CLAUDE.local.md that Claude Code
# auto-loads. It's a symlink to the shared doc root, so the content is the same
# across every worktree. The target may not exist until `setup` writes it; a
# dangling symlink is harmless until then.
claude_local="$toplevel/CLAUDE.local.md"
if [ -L "$claude_local" ]; then
  :
elif [ -e "$claude_local" ]; then
  echo "link-docroot: $claude_local exists and is not a symlink; leaving it alone" >&2
else
  ln -s ".brandonnoad/CLAUDE.md" "$claude_local"
fi

# Exclude both from git via the shared info/exclude (covers all worktrees,
# uncommitted, invisible to teammates).
excl="$common_dir/info/exclude"
mkdir -p "$(dirname "$excl")"
touch "$excl"
for pat in '.brandonnoad' 'CLAUDE.local.md'; do
  grep -qxF "$pat" "$excl" || printf '%s\n' "$pat" >> "$excl"
done

echo "link-docroot: ready  $link -> $real"
echo "link-docroot: ready  $claude_local -> .brandonnoad/CLAUDE.md"
