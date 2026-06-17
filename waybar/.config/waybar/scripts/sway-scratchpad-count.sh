#!/usr/bin/env bash
set -euo pipefail

tree_json="$(swaymsg -t get_tree 2>/dev/null)" || exit 1

count="$(
  printf '%s' "$tree_json" |
    python3 -c '
import json
import sys

tree = json.load(sys.stdin)
total = 0
stack = [tree]

while stack:
    node = stack.pop()
    if node.get("name") == "__i3_scratch":
        total += len(node.get("floating_nodes", []))

    stack.extend(node.get("nodes", []))
    stack.extend(node.get("floating_nodes", []))

print(total)
'
)"

if [[ "${1:-}" == "--has-windows" ]]; then
  (( count > 0 ))
  exit
fi

printf '%s\n' "$count"
