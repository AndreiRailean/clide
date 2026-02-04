# CLIDE 🚀

**CLIDE** (Containerised Lightweight IDE) is a language-agnostic, portable development environment that runs entirely inside Docker. It brings your personal Neovim, Tmux, and shell configurations to any project folder with a single command, ensuring a consistent experience across Ruby, Node, Python, and more.

## How it works
CLIDE launches a docker container, mounts the current working directory under `/app` and starts a **tmux** session with 2 panes. Docker container runs in the background, which allows tmux sessions to be detached and re-attached. It also comes with neovim pre-installed so you can jump in to edit files and run scripts in an isolated container environment.

CLIDE defaults to a few base images, but can easily be configured to run on any debian-based image if you need complex multi-language setups.

## ✨ Features
- Language Agnostic: Automatically detects your project type (Ruby, Node, Python) and pulls the appropriate official Docker base image.
- Persistent Sessions: Powered by a background Docker service and Tmux; detach from a session and re-attach later exactly where you left off.
- Non-Root & Secure: Automatically syncs your host's UID/GID so files created in the container are owned by you, not root.
- Resource Aware: Built-in safeguards for CPU and Memory usage to keep your host system snappy.
- Zero-Config Workflow: Drop into any folder and type clide start.

## Commands
```
Usage: clide <command> [options]

Commands:
  init        Initialise a project (creates .base-image)
  start       Launch or re-attach to the IDE for this project
  stop        Stop the container for the current directory
  stop -a     Stop ALL active CLIDE containers
  stop [name] Stop a specific container by name
  list        List all currently running CLIDE environments
  check       Run system diagnostics and check project context
  update      Pull the latest CLIDE code and rebuild images
  clean       Prune orphaned Docker networks and volumes
  shell-init  Initialise shell autocompletion with auto-detected shell
  shell-init [shell]  Initialise shell autocompletion with supplied shell (zsh or bash)
  version     Show the current CLIDE version
```

## 🛠 Prerequisites
- Docker Desktop or Docker Engine with the Compose plugin.
- A terminal with bash or zsh.

## 🚀 Installation

### Automatic
Run an interactive installer in your terminal
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/AndreiRailean/clide/main/install.sh)"
```

### Manual
1. **Clone the repository:**
```bash
git clone git@github.com:AndreiRailean/clide.git ~/.clide
```

2. **Add to your PATH:**
Add the following to your ~/.zshrc or ~/.bashrc:
```bash
export PATH="$PATH:$HOME/.clide"
eval "$(clide shell-init)

```
This add `clide` tool to your shell and enables shell completions for it

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

If no `.base-image` file exists, CLIDE will recommend you to run `clide init`, which auto-detect your project type, create the file, and be ready to launch your custom Neovim/Tmux environment.

### Stop an Environment
To stop the background container for the current project:
```bash
clide stop
```

To stop all active CLIDE containers across your system:
```bash
clide stop -a
```

To stop a specific container, specify it's name
```bash
clide stop clide-ruby-latest-myproj-c6a5
```

### List all running CLIDE containers
```bash
clide list
```
Use the list to decide if you need to stop a container by name. This command can be ran from any location.

### System Health
Check if your system meets the requirements and see current project context:
```bash
clide check
```

### Updates
CLIDE will check for updates every 6 hours and will present you with a notice that a new version is available
If you wish to update to latest version, run
```bash
clide update
```

### 🗑 Removal
To remove CLIDE and clean up your shell configuration:
```bash
clide uninstall
```
You will get a few prompts to confirm and all traces of clide will be removed from your system

## Security
Verify integrity of files by comparing the checksums
```bash
cat checksum.txt | shasum -a 256 --check
```

## ⚙️ Configuration

### Project Root
Presence of `.base-image` file determines the project root. You can start CLIDE from any subfolder of a project and it will traverse up to start or re-attach a container at project root.

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
