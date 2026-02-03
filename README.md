# CLIDE 🚀

*CLIDE* (Containerised Lightweight IDE) is a language-agnostic, portable development environment that runs entirely inside Docker. It brings your personal Neovim, Tmux, and shell configurations to any project folder with a single command, ensuring a consistent experience across Ruby, Node, Python, and more.

##✨ Features
- Language Agnostic: Automatically detects your project type (Ruby, Node, Python) and pulls the appropriate official Docker base image.
- Persistent Sessions: Powered by a background Docker service and Tmux; detach from a session and re-attach later exactly where you left off.
- Non-Root & Secure: Automatically syncs your host's UID/GID so files created in the container are owned by you, not root.
- Resource Aware: Built-in safeguards for CPU and Memory usage to keep your host system snappy.
- Zero-Config Workflow: Drop into any folder and type clide start.

## 🛠 Prerequisites
- Docker Desktop or Docker Engine with the Compose plugin.
- A terminal with bash or zsh.

## 🚀 Installation
1. **Clone the repository:**
```bash
git clone git@github.com:AndreiRailean/clide.git ~/.clide
```

2. **Add to your PATH:**
Add the following to your ~/.zshrc or ~/.bashrc:
```bash
export PATH="$PATH:$HOME/.clide"
```

3. **Reload your shell:**
```bash
source ~/.zshrc
```

## 📖 Usage

### 🚀 Quick Start
1. `cd` into your project.
2. `clide init` (Creates `.base-image`).
3. `clide start` (Launches environment).

### Start an Environment
Navigate to any project folder and run:
```bash
clide start
```

If no `.base-image` file exists, CLIDE will auto-detect your project type, create the file, and launch your custom Neovim/Tmux environment.

### Stop an Environment
To stop the background container for the current project:
```bash
clide stop
```

To stop all active CLIDE containers across your system:
```bash
clide stop -a
```

### System Health
Check if your system meets the requirements and see current project context:
```bash
clide check
```

## ⚙️ Configuration

### Changing the Language
CLIDE reads a `.base-image` file in your project root. You can manually set this to any Debian-based official image:
```text
# filename: .base-image
python:3.11-slim
```

### Customising your IDE
Edit the files in the `configs/` directory of the CLIDE repo:
- `init.lua`: Your Neovim configuration.
- `.tmux.conf`: Your Tmux layout and shortcuts.
- `.bash_aliases`: Your custom shell shortcuts.
- `tmux-start.sh`: Define your default pane layout.

CLIDE will detect changes to these files and automatically rebuild your image on the next start.

## 📂 Project State
To keep the container stateless but preserve your editor history, CLIDE creates a `.clide-state/` folder inside your project directory. This stores:
- Neovim undo history
- Swap files
- Search/Command history
Note: It is recommended to add `.clide-state/` and `.base-image` to your global Gitignore.

## 🤝 Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

---
**Built with ❤️ for developers who love their dotfiles but hate environment drift.**
---
