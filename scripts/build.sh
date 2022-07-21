#/bin/bash
set -e

# build/<branch_name>/<git SHA>
# build/main/abcd123
# This just tags a full SHA with a friendly "short" SHA tag, full SHA is built.
git tag build/$(git branch --show-current)/$(git rev-parse --short HEAD)
git push --tags
