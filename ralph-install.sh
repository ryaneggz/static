#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/ryaneggz/ralph"
BRANCH="master"

if command -v unzip &>/dev/null; then
  curl -sLO "$REPO_URL/archive/refs/heads/$BRANCH.zip"
  unzip -q "$BRANCH.zip"
  mv "ralph-$BRANCH"/* "ralph-$BRANCH"/.[!.]* . 2>/dev/null || true
  rm -rf "ralph-$BRANCH" "$BRANCH.zip"
elif command -v git &>/dev/null; then
  git clone "$REPO_URL.git" . 2>/dev/null || git clone "$REPO_URL.git" .ralph
elif command -v curl &>/dev/null; then
  curl -sL "$REPO_URL/archive/refs/heads/$BRANCH.tar.gz" | tar xz --strip-components=1
elif command -v wget &>/dev/null; then
  wget -qO- "$REPO_URL/archive/refs/heads/$BRANCH.tar.gz" | tar xz --strip-components=1
else
  echo "Error: unzip, git, curl, or wget is required" >&2
  exit 1
fi

echo "Ralph installed successfully."
