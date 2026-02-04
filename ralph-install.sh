#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/ryaneggz/ralph"
BRANCH="master"

TMP_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

if command -v unzip &>/dev/null; then
  curl -sL "$REPO_URL/archive/refs/heads/$BRANCH.zip" -o "$TMP_DIR/ralph.zip"
  unzip -q "$TMP_DIR/ralph.zip" -d "$TMP_DIR"
  SRC_DIR="$TMP_DIR/ralph-$BRANCH"

elif command -v git &>/dev/null; then
  git clone --depth=1 --branch "$BRANCH" "$REPO_URL.git" "$TMP_DIR/ralph"
  SRC_DIR="$TMP_DIR/ralph"

elif command -v curl &>/dev/null; then
  curl -sL "$REPO_URL/archive/refs/heads/$BRANCH.tar.gz" \
    | tar xz -C "$TMP_DIR"
  SRC_DIR="$TMP_DIR/ralph-$BRANCH"

elif command -v wget &>/dev/null; then
  wget -qO- "$REPO_URL/archive/refs/heads/$BRANCH.tar.gz" \
    | tar xz -C "$TMP_DIR"
  SRC_DIR="$TMP_DIR/ralph-$BRANCH"

else
  echo "Error: unzip, git, curl, or wget is required" >&2
  exit 1
fi

# Copy everything EXCEPT README.md into project root
rsync -a \
  --exclude='README.md' \
  --exclude='README.txt' \
  --exclude='README.md.*' \
  "$SRC_DIR"/ .

echo "Ralph installed successfully."
