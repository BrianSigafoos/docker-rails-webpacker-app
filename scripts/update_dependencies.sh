#!/bin/bash
set -e

PREVIOUS_BRANCH=$(git branch --show-current)
NEW_BRANCH=update/$(date +%Y%m%d)
READABLE_DATE=$(date +%Y-%m-%d)

# Helper function to ask to confirm with y/n
confirm() {
    local PROMPT=$1
    [[ -z $PROMPT ]] && PROMPT="OK to continue?"
    local REPLY=
    while [[ ! $REPLY =~ ^[YyNn]$ ]]; do
        echo -n "$PROMPT (y/n) "
        read -r
    done
    # The result of this comparison is the return value of the function
    [[ $REPLY =~ ^[Yy]$ ]]
}

# Stash work, checkout main, and pull latest
echo "Stashing work, checking out main, pulling latest..."
git stash push
git checkout main
git pull --rebase --autostash

# New branch
git checkout -b $NEW_BRANCH

echo "Updating dependencies"

if confirm "Upgrade brew dependencies?"; then
  brew bundle
fi
bundle update
yarn upgrade --latest

echo "Committing changes"
git commit -a -m "Update dependencies $READABLE_DATE" --no-verify
git push

echo "Creating PR using GitHub CLI"
gh pr create --fill

# Back to previous branch
echo "Checking out previous branch"
git checkout $PREVIOUS_BRANCH
echo "If needed, run: git stash pop (gstp)"
