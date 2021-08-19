#/bin/bash

# build/<branch_name>/<git SHA>
# build/main/abcd123
git tag build/$(git branch --show-current)/$(git rev-parse --short HEAD)
git push --tags
