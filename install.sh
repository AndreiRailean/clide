#!/bin/bash
set -e

CLIDE_DIR="$HOME/.clide"
REPO_URL="https://github.com/AndreiRailean/clide"

echo "🚀 Installing CLIDE..."

if [ -d "$CLIDE_DIR" ]; then
	echo "Updating existing installation..."
	git -C "$CLIDE_DIR" pull origin main
else
	echo "Cloning CLIDE into $CLIDE_DIR..."
	git clone "$REPO_URL" "$CLIDE_DIR"
fi

# Ensure clide is executable
chmod +x "$CLIDE_DIR/clide"

# Detect config file
case "$SHELL" in
	*/zsh)  CONF_FILE="$HOME/.zshrc" ;;
	*/bash) CONF_FILE="$HOME/.bashrc" ;;
	*)      CONF_FILE="$HOME/.profile" ;;
esac

	# Define the block content
	CLIDE_BLOCK_START="# >>> clide initialize >>>"
	CLIDE_BLOCK_END="# <<< clide initialize <<<"

	# We use a variable for the content to keep it clean
	CLIDE_CONFIG=$(cat <<EOF
$CLIDE_BLOCK_START
# !! Contents within this block are managed by 'clide install' !!
export PATH="\$PATH:\$HOME/.clide"
eval "\$(clide shell-init)"
$CLIDE_BLOCK_END
EOF
)

# 1. Check if a clide block already exists
if grep -q "$CLIDE_BLOCK_START" "$CONF_FILE"; then
    # Extract the existing block into a temporary variable
    # This grabs everything between the start and end markers
    EXISTING_BLOCK=$(sed -n "/$CLIDE_BLOCK_START/,/$CLIDE_BLOCK_END/p" "$CONF_FILE")

    # 2. Compare the existing block to the new $CLIDE_CONFIG
    if [[ "$EXISTING_BLOCK" == "$CLIDE_CONFIG" ]]; then
        echo "✅ Config in $CONF_FILE is already up to date."
        SHOULD_UPDATE="n"
    else
        echo "⚠️  Your clide config in $CONF_FILE is out of date."
        SHOULD_UPDATE="prompt"
    fi
else
    echo "✨ No clide config found in $CONF_FILE."
    SHOULD_UPDATE="prompt"
fi

# 3. Conditional Prompt
if [[ "$SHOULD_UPDATE" == "prompt" ]]; then
    read -p "Do you want to update your $CONF_FILE? (y/n) " -n 1 -r </dev/tty
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Remove old and append new
        [[ "$(uname)" == "Darwin" ]] && sed -i '' "/$CLIDE_BLOCK_START/,/$CLIDE_BLOCK_END/d" "$CONF_FILE" || sed -i "/$CLIDE_BLOCK_START/,/$CLIDE_BLOCK_END/d" "$CONF_FILE"
        echo "$CLIDE_CONFIG" >> "$CONF_FILE"
        echo "🚀 Config updated!"
    fi
fi

echo ""
echo "✨ Installation complete! Restart your terminal or run:"
echo "   source $CONF_FILE"

