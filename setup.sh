#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
PACKAGES="bash git vim inputrc tmux claude codex"

echo "==> Dotfiles directory: $DOTFILES_DIR"

# --- Install dependencies ---
echo "==> Installing dependencies..."
if command -v apt &>/dev/null; then
  sudo apt update
  sudo apt install -y stow tmux vim git
elif command -v brew &>/dev/null; then
  brew install stow tmux vim git
else
  echo "No supported package manager found (apt or brew). Install stow, tmux, vim, git manually."
  exit 1
fi

# --- Pre-create directories that stow should NOT replace wholesale ---
# Without this, stow would symlink ~/.claude -> dotfiles/claude/.claude
# which would put runtime files (cache, history, etc.) in the dotfiles repo.
mkdir -p "$HOME/.claude"
mkdir -p "$HOME/.codex"
mkdir -p "$HOME/.config/tmux"

# --- Stow packages ---
echo "==> Stowing dotfiles..."
cd "$DOTFILES_DIR"
for pkg in $PACKAGES; do
  echo "    Stowing $pkg"
  stow --target="$HOME" --restow "$pkg"
done

# --- Install TPM ---
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  echo "==> Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
else
  echo "==> TPM already installed"
fi

# --- Install tmux-which-key ---
if [ ! -d "$HOME/.tmux/plugins/tmux-which-key" ]; then
  echo "==> Installing tmux-which-key..."
  git clone --recursive https://github.com/alexwforsythe/tmux-which-key "$HOME/.tmux/plugins/tmux-which-key"
else
  echo "==> tmux-which-key already installed"
fi

# --- Symlink which-key config ---
echo "==> Configuring tmux-which-key..."
ln -sf "$DOTFILES_DIR/tmux/.config/tmux/which-key.yaml" \
   "$HOME/.tmux/plugins/tmux-which-key/config.yaml"

# --- Install remaining TPM plugins ---
echo "==> Installing TPM plugins..."
"$HOME/.tmux/plugins/tpm/bin/install_plugins"

# --- Create .bash_profile.local template if it doesn't exist ---
if [ ! -f "$HOME/.bash_profile.local" ]; then
  echo "==> Creating ~/.bash_profile.local template..."
  cat > "$HOME/.bash_profile.local" << 'LOCALEOF'
# Machine-specific config (not tracked in dotfiles repo)
# Uncomment and edit as needed:

# ### Homebrew (macOS)
# eval "$(/opt/homebrew/bin/brew shellenv)"

# ### Cargo/Rust
# . "$HOME/.cargo/env"

# ### NVM
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# ### Bun
# export BUN_INSTALL="$HOME/.bun"
# export PATH="$BUN_INSTALL/bin:$PATH"

# ### Claude Code MCP servers
# export GITHUB_MCP_TOKEN="ghp_..."
# export EXA_API_KEY="..."
LOCALEOF
else
  echo "==> ~/.bash_profile.local already exists, skipping"
fi

# --- Claude Code MCP servers ---
if command -v claude &>/dev/null; then
  echo "==> Setting up Claude Code MCP servers..."
  # User-scope servers (available across all projects)
  # These require env vars set in ~/.bash_profile.local:
  #   GITHUB_MCP_TOKEN, EXA_API_KEY
  if [ -n "$GITHUB_MCP_TOKEN" ]; then
    claude mcp add --scope user --transport http github https://api.githubcopilot.com/mcp/ \
      -e "Authorization=Bearer $GITHUB_MCP_TOKEN" 2>/dev/null && echo "    Added github MCP" || echo "    github MCP already configured"
  else
    echo "    Skipping github MCP (set GITHUB_MCP_TOKEN in ~/.bash_profile.local)"
  fi
  claude mcp add --scope user --transport http grep https://mcp.grep.app 2>/dev/null \
    && echo "    Added grep MCP" || echo "    grep MCP already configured"
  if [ -n "$EXA_API_KEY" ]; then
    claude mcp add --scope user exa -- npx -y exa-mcp-server 2>/dev/null \
      && echo "    Added exa MCP" || echo "    exa MCP already configured"
  else
    echo "    Skipping exa MCP (set EXA_API_KEY in ~/.bash_profile.local)"
  fi
  echo "    Note: project-scope MCP servers (postgres, linear) belong in each project's .mcp.json"
else
  echo "==> Claude Code not installed, skipping MCP setup"
  echo "    Install: curl -fsSL https://claude.ai/install.sh | bash"
fi

echo ""
echo "==> Done! Open a new terminal or run: source ~/.bash_profile"
