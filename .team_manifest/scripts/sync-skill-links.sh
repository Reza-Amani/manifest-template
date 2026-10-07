#!/usr/bin/env bash
# Rebuilds the gitignored .agents/skills discovery shim on macOS/Linux.
# One symlink per skill folder in .team_manifest/skills and .local_manifest/skills
# so tools find each skill as .agents/skills/<name>/SKILL.md. Safe to re-run;
# run it again after adding, renaming, or removing a skill, and after every clone.
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
shim="$root/.agents/skills"

[ -e "$root/.local_manifest" ] || { echo ".local_manifest is missing or is a dangling link under $root" >&2; exit 1; }

# Collect first so a duplicate name aborts before anything is changed.
names=()
srcs=()
for tree in .team_manifest .local_manifest; do
  [ -d "$root/$tree/skills" ] || continue
  for dir in "$root/$tree/skills"/*/; do
    [ -d "$dir" ] || continue
    dir="${dir%/}"
    name="$(basename "$dir")"
    if [ ! -f "$dir/SKILL.md" ]; then
      echo "warning: skipping $dir: no SKILL.md" >&2
      continue
    fi
    declared="$(head -n 20 "$dir/SKILL.md" | sed -n 's/^name:[[:space:]]*["'\'']\{0,1\}\([^"'\''[:space:]]*\).*$/\1/p' | head -n 1)"
    if [ -n "$declared" ] && [ "$declared" != "$name" ]; then
      echo "warning: $dir/SKILL.md: name '$declared' does not match folder '$name'; tools may not load it" >&2
    fi
    names+=("$name")
    srcs+=("$tree/skills/$name")
  done
done

dupes=""
for i in "${!names[@]}"; do
  for j in "${!names[@]}"; do
    [ "$i" -lt "$j" ] && [ "${names[$i]}" = "${names[$j]}" ] && dupes="$dupes ${names[$i]}"
  done
done
if [ -n "$dupes" ]; then
  echo "Skill folder names must be unique across .team_manifest and .local_manifest. Duplicates:$dupes" >&2
  exit 1
fi

mkdir -p "$shim"

# Remove only links this script owns: legacy local/team, manifest targets, or dangling.
for item in "$shim"/* "$shim"/.[!.]*; do
  [ -L "$item" ] || continue
  base="$(basename "$item")"
  target="$(readlink "$item")"
  case "$base:$target" in
    local:*|team:*|*/.team_manifest/skills*|*/.local_manifest/skills*) rm "$item" ;;
    *) [ -e "$item" ] || rm "$item" ;;
  esac
done

for i in "${!names[@]}"; do
  link="$shim/${names[$i]}"
  if [ -e "$link" ] || [ -L "$link" ]; then
    echo "warning: skipping ${names[$i]}: $link already exists and is not a manifest link" >&2
    continue
  fi
  ln -s "../../${srcs[$i]}" "$link"
  echo "linked ${names[$i]} -> ${srcs[$i]}"
done

echo "Done: ${#names[@]} skill(s) found."
