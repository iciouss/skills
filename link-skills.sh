#!/usr/bin/env bash

# Export standard system paths so fzf subshells can find commands like 'ls' or 'cat'
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

# Central skills directory
REPO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SKILLS_DIR="$REPO_DIR/skills"
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"
SCRIPT_PATH="$REPO_DIR/$SCRIPT_NAME"
TARGET_DIR="./.claude/skills"

# Files/folders to exclude
EXCLUDE_PATTERN="^\..*$"

get_available_skills() {
    ls -1 "$SKILLS_DIR" | grep -vE "$EXCLUDE_PATTERN"
}

skill_description() {
    local item="$1" target=""
    if [ -f "$SKILLS_DIR/$item" ]; then
        target="$SKILLS_DIR/$item"
    elif [ -d "$SKILLS_DIR/$item" ]; then
        for candidate in "$item/SKILL.md" "$item/README.md" "$item/$item.md"; do
            if [ -f "$SKILLS_DIR/$candidate" ]; then
                target="$SKILLS_DIR/$candidate"
                break
            fi
        done
    fi
    local desc=""
    if [ -n "$target" ]; then
        desc=$(sed -n '/^---$/,/^---$/p' "$target" | grep -m1 -i '^description:' | sed -E 's/^description:[[:space:]]*["'\'']?//; s/["'\'']?$//')
    fi
    [ -z "$desc" ] && desc="No description provided"
    echo "$desc"
}

# True if a skill is currently linked into TARGET_DIR
is_installed() {
    [ -L "$TARGET_DIR/$1" ]
}

# Strip the "[x] " checkbox prefix back off a rendered label
parse_skill_name() {
    sed -E 's/^\[.\] //; s/[[:space:]]+$//' <<< "$1"
}

# Print the checklist from the precomputed description cache (fast: no per-skill subprocesses)
render_list() {
    local tmp_dir="$1" max_len=0 item desc mark
    while IFS=$'\t' read -r item _; do
        (( ${#item} > max_len )) && max_len=${#item}
    done < "$tmp_dir/.desc"

    while IFS=$'\t' read -r item desc; do
        [ -z "$item" ] && continue
        mark=" "
        [ -f "$tmp_dir/$item" ] && mark="x"
        printf "[%s] %-${max_len}s  │ %s\n" "$mark" "$item" "$desc"
    done < "$tmp_dir/.desc"
}

# --- Internal modes used by fzf's reload bindings. Each does its state change
# then reprints the list in the same subprocess, so there's a single reload
# per keystroke instead of a separate execute-silent+reload race. ---

if [ "$1" = "--render" ]; then
    render_list "$2"
    exit 0
fi

if [ "$1" = "--toggle-render" ]; then
    tmp_dir="$2"
    item=$(parse_skill_name "$3")
    if [ -f "$tmp_dir/$item" ]; then
        rm -f "$tmp_dir/$item"
    else
        touch "$tmp_dir/$item"
    fi
    render_list "$tmp_dir"
    exit 0
fi

if [ "$1" = "--select-all-render" ]; then
    tmp_dir="$2"
    while IFS=$'\t' read -r item _; do
        [ -n "$item" ] && touch "$tmp_dir/$item"
    done < "$tmp_dir/.desc"
    render_list "$tmp_dir"
    exit 0
fi

if [ "$1" = "--deselect-all-render" ]; then
    tmp_dir="$2"
    rm -f "$tmp_dir"/* 2>/dev/null
    render_list "$tmp_dir"
    exit 0
fi

# --- Main interactive flow ---

# Runtime check for fzf
if ! command -v fzf &> /dev/null; then
    echo "Error: 'fzf' command not found."
    exit 1
fi

AVAILABLE_SKILLS=$(get_available_skills)

if [ -z "$AVAILABLE_SKILLS" ]; then
    echo "No available skills found in $SKILLS_DIR"
    exit 1
fi

# Create a temporary directory to track selection state
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

# Precompute descriptions once so each keystroke's reload only redraws checkboxes
: > "$TMP_DIR/.desc"
while IFS= read -r item; do
    [ -z "$item" ] && continue
    printf '%s\t%s\n' "$item" "$(skill_description "$item")" >> "$TMP_DIR/.desc"
done <<< "$AVAILABLE_SKILLS"

# Pre-select skills that are already installed, so the picker reflects reality
while IFS= read -r item; do
    is_installed "$item" && touch "$TMP_DIR/$item"
done <<< "$AVAILABLE_SKILLS"

fzf --disabled \
    --prompt="" \
    --delimiter="  │ " \
    --header="⚡ Manage skills in .claude/skills/
[SPACE] Toggle | [CTRL-A] Select All | [CTRL-D] Deselect All | [ENTER] Confirm | [ESC] Cancel" \
    --bind "space:reload-sync($SCRIPT_PATH --toggle-render \"$TMP_DIR\" {1})" \
    --bind "ctrl-a:reload-sync($SCRIPT_PATH --select-all-render \"$TMP_DIR\")" \
    --bind "ctrl-d:reload-sync($SCRIPT_PATH --deselect-all-render \"$TMP_DIR\")" \
    --bind "j:down,k:up,change:clear-query" \
    --preview '
        skill=$(echo {1} | sed -E "s/^\[.\] //; s/[[:space:]]+$//")
        p="'"$SKILLS_DIR"'/$skill"
        if [ -d "$p" ]; then
            if [ -f "$p/SKILL.md" ]; then cat "$p/SKILL.md";
            elif [ -f "$p/README.md" ]; then cat "$p/README.md";
            else ls -la "$p"; fi
        elif [ -f "$p" ]; then
            cat "$p"
        fi
    ' \
    --preview-window=right:50%:wrap \
    --height=70% \
    --layout=reverse \
    --border < <("$SCRIPT_PATH" --render "$TMP_DIR") > /dev/null
FZF_EXIT=$?

if [ $FZF_EXIT -ne 0 ]; then
    echo "Cancelled. No changes made."
    exit 0
fi

mkdir -p "$TARGET_DIR"

# Apply: link newly selected skills, unlink deselected ones that were installed
echo ""
CHANGED=0
while IFS= read -r item; do
    [ -z "$item" ] && continue
    dest="$TARGET_DIR/$item"
    if [ -f "$TMP_DIR/$item" ]; then
        if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$SKILLS_DIR/$item" ]; then
            continue
        fi
        if [ -e "$dest" ] && [ ! -L "$dest" ]; then
            echo "  ⚠ Skipped:  $item ($dest already exists and is not a symlink)"
            continue
        fi
        # Remove any existing symlink first — ln -sf on a symlinked directory
        # would otherwise nest the new link inside the old target on macOS.
        rm -f "$dest"
        ln -s "$SKILLS_DIR/$item" "$dest"
        echo "  ✔ Linked:   $item"
        CHANGED=1
    else
        if [ -L "$dest" ]; then
            rm -f "$dest"
            echo "  ✘ Unlinked: $item"
            CHANGED=1
        fi
    fi
done <<< "$AVAILABLE_SKILLS"

[ "$CHANGED" -eq 0 ] && echo "No changes."
echo ""