#!/usr/bin/env bash
# manenos.sh — Wraps dev.sh for personal projects
# Usage: manenos.sh
DIR="$HOME/Desktop/mine/manenos"
exec "$(dirname "$0")/dev.sh" "Manenos" "$DIR"
