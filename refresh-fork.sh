#!/bin/zsh
# Pulls the latest upstream changes into this fork and rebuilds + reinstalls the
# local "Vorssaint (Developer)" build. Run this whenever you want to catch up
# with the upstream repo (vorssaint/vorssaint-utils), which updates near-daily.
#
# Strategy: MERGE upstream/main into your current branch (no history rewrite, no
# force-push needed). Your fork commits — including the "Personal fork" marker —
# stay on top. If upstream touched the same lines you did, the merge stops with a
# conflict for you to resolve, then re-run this script.
#
# Requires: a committed working tree (commit your changes first) and an
# `upstream` remote pointing at https://github.com/vorssaint/vorssaint-utils.git
set -euo pipefail
cd "$(dirname "$0")"

UPSTREAM_BRANCH="main"

if ! git remote get-url upstream >/dev/null 2>&1; then
    echo "✗ No 'upstream' remote. Add it once with:"
    echo "    git remote add upstream https://github.com/vorssaint/vorssaint-utils.git"
    exit 1
fi

if [[ -n "$(git status --porcelain)" ]]; then
    echo "✗ Working tree is dirty. Commit (or stash) your changes first, then re-run."
    echo "  Uncommitted changes would block the merge."
    git status --short
    exit 1
fi

echo "▸ Fetching upstream…"
git fetch upstream

CURRENT="$(git rev-parse --short HEAD)"
TARGET="$(git rev-parse --short upstream/$UPSTREAM_BRANCH)"
if [[ "$CURRENT" == "$TARGET" ]] || git merge-base --is-ancestor "upstream/$UPSTREAM_BRANCH" HEAD; then
    echo "✓ Already up to date with upstream/$UPSTREAM_BRANCH."
else
    echo "▸ Merging upstream/$UPSTREAM_BRANCH …"
    if ! git merge --no-edit "upstream/$UPSTREAM_BRANCH"; then
        echo "✗ Merge conflict. Resolve the listed files, 'git add' them,"
        echo "  'git commit', then re-run ./refresh-fork.sh to rebuild."
        exit 1
    fi
fi

echo "▸ Rebuilding and reinstalling the Developer build…"
./build.sh --dev --install

echo "✓ Done. Your fork is rebuilt from the latest upstream + your changes."
echo "  (Optional) push your updated fork:  git push origin $(git rev-parse --abbrev-ref HEAD)"
