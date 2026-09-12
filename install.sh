#!/usr/bin/env bash

SKILLS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TARGET_SCRIPT="$SKILLS_DIR/link-skills.py"

# 1. Check if uv is installed
if ! command -v uv &> /dev/null; then
    echo "⚠️  Warning: 'uv' is not installed."
    echo "Please install uv before using the wizard:"
    echo "  - macOS: brew install uv"
    echo "  - Other: https://docs.astral.sh/uv/getting-started/installation/"
    echo ""
fi

# 2. Ensure link-skills.py exists and is executable
if [ -f "$TARGET_SCRIPT" ]; then
    chmod +x "$TARGET_SCRIPT"
else
    echo "Error: Could not find $TARGET_SCRIPT"
    exit 1
fi

# 3. Detect active shell configuration file
if [[ "$SHELL" == *"zsh"* ]] && [ -f "$HOME/.zshrc" ]; then
    CONFIG_FILE="$HOME/.zshrc"
elif [[ "$SHELL" == *"bash"* ]] && [ -f "$HOME/.bashrc" ]; then
    CONFIG_FILE="$HOME/.bashrc"
elif [ -f "$HOME/.zshrc" ]; then
    CONFIG_FILE="$HOME/.zshrc"
elif [ -f "$HOME/.bashrc" ]; then
    CONFIG_FILE="$HOME/.bashrc"
else
    echo "Error: Neither ~/.zshrc nor ~/.bashrc was found."
    exit 1
fi

ALIAS_CMD="alias skill-wizard=\"$TARGET_SCRIPT\""

# 4. Add alias if missing
if grep -q "alias skill-wizard=" "$CONFIG_FILE"; then
    echo "⚡ Alias 'skill-wizard' is already installed in $CONFIG_FILE"
else
    echo "" >> "$CONFIG_FILE"
    echo "# Claude Skill Wizard" >> "$CONFIG_FILE"
    echo "$ALIAS_CMD" >> "$CONFIG_FILE"
    echo "✔ Successfully added 'skill-wizard' alias to $CONFIG_FILE"
fi

echo ""
echo "To finish, run:"
echo "  source $CONFIG_FILE"