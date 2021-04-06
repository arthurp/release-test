#!/bin/bash

git status --porcelain | grep "^." > /dev/null
if [ $? -eq 0 ]; then
  git stash push --include-untracked --message "Auto-stash for gh-pages update"
  STASHED=yes
else
  STASHED=""
fi

git switch main
make clean
make html

HASH="$(git rev-parse HEAD)"

git switch gh-pages

cp -a _build/html/* .

git status

git add .
git commit -m "Updating gh-pages to main @ $HASH"

git switch main

if [ "$STASHED" ]; then
  git stash pop
fi
