#!/bin/bash

# This script:
#   - updates the local repo
#   - creates a deploy tag, by default for the last commit in main
#   - pushes the tag to Github, triggering a deploy
#
# By default, this deploys to "prod"
# To deploy to "canary", run: `./deploy.sh canary`

set -e

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

# Provide an alternative K8S_ENV, like "canary", as the first parameter
K8S_ENV=${1:-prod}

# Stash work, checkout main, and pull latest
echo "Stashing work, checking out main, and pulling latest"
git stash push
git checkout main
git pull --rebase --autostash

# This just tags a full SHA with a friendly "short" SHA tag, full SHA is deployed.
CURRENT_SHA=$(git rev-parse --short HEAD)
if ! confirm "Deploy latest SHA ($CURRENT_SHA) to $K8S_ENV?"; then
  echo -n "Enter $K8S_ENV deploy SHA (e.g. $CURRENT_SHA) > "
  read -r DEPLOY_SHA
else
  DEPLOY_SHA=$CURRENT_SHA
fi

TAG_NAME="deploy/$K8S_ENV/$DEPLOY_SHA"

if ! confirm "Confirm to deploy $DEPLOY_SHA to $K8S_ENV ($TAG_NAME)?"; then
  echo "Not deploying to $K8S_ENV ❌"
  exit 1
else
  echo "Deploying to $K8S_ENV... 🚀"
  git tag "$TAG_NAME" "$DEPLOY_SHA"
  git push origin --tags
fi

# Back to previous branch
echo "Checking out previous branch"
git checkout -
echo "If needed, run: git stash pop (gstp)"
