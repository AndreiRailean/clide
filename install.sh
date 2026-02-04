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

update_conf_old(){
	# Define the lines to be added
	PATH_LINE='export PATH="$PATH:$HOME/.clide"'
	INIT_LINE='eval "$(clide shell-init)"'

	# Detect the target config file
	case "$SHELL" in
		*/zsh)  CONF_FILE="$HOME/.zshrc" ;;
		*/bash) CONF_FILE="$HOME/.bashrc" ;;
		*)      CONF_FILE="$HOME/.profile" ;;
	esac

	echo "📝 Updating $CONF_FILE..."

	# Create file if it doesn't exist
	touch "$CONF_FILE"

	# Function to append if line is missing
	append_if_missing() {
		local line="$1"
		local file="$2"
		if ! grep -Fq "$line" "$file"; then
			echo "$line" >> "$file"
			return 0
		else
			echo "   (Already present in $file, skipping...)"
			return 1
		fi
	}

	append_if_missing "$PATH_LINE" "$CONF_FILE"
	append_if_missing "$INIT_LINE" "$CONF_FILE"
}

update_conf(){
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

# Detect config file
case "$SHELL" in
	*/zsh)  CONF_FILE="$HOME/.zshrc" ;;
	*/bash) CONF_FILE="$HOME/.bashrc" ;;
	*)      CONF_FILE="$HOME/.profile" ;;
esac

echo "📝 Updating $CONF_FILE..."

# 1. Remove existing block if it exists (allows for clean re-installs/updates)
# This uses a temporary file to safely edit
if grep -q "$CLIDE_BLOCK_START" "$CONF_FILE"; then
	echo "   Found existing Clide block. Updating..."
	sed -i.bak "/$CLIDE_BLOCK_START/,/$CLIDE_BLOCK_END/d" "$CONF_FILE"
fi

# 2. Append the new block
echo "$CLIDE_CONFIG" >> "$CONF_FILE"

echo "✨ Config block updated in $CONF_FILE"

}

echo "Do you want to automatically update your $CONFI_FILE?"
read -p "(y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
	update_conf
fi


echo ""
echo "✨ Installation complete! Restart your terminal or run:"
echo "   source $CONF_FILE"

