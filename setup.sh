#!/usr/bin/env bash
set -euo pipefail

echo "==> Setting up dotfiles..."

# ── Homebrew ─────────────────────────────────────────
if ! command -v brew &>/dev/null; then
  echo "==> Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# ── Brew Bundle ──────────────────────────────────────
if [ -f "$(dirname "$0")/Brewfile" ]; then
  echo "==> Installing packages from Brewfile..."
  brew bundle --file="$(dirname "$0")/Brewfile"
fi

# ── Stow ─────────────────────────────────────────────
echo "==> Symlinking dotfiles with stow..."
cd "$(dirname "$0")"
stow .

# ── TPM (Tmux Plugin Manager) ───────────────────────
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  echo "==> Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

# ── Secrets file ─────────────────────────────────────
if [ ! -f "$HOME/.secrets" ]; then
  echo "==> Creating ~/.secrets template..."
  cat > "$HOME/.secrets" << 'EOF'
# Add your secrets here (this file is NOT tracked by git)
# export ATLASSIAN_API_TOKEN="your-token-here"
# export AWS_ACCESS_KEY_ID="..."
# export AWS_SECRET_ACCESS_KEY="..."
EOF
  chmod 600 "$HOME/.secrets"
fi

echo "==> Done! Restart your terminal or run: source ~/.zshrc"
echo "==> Run 'prefix + I' inside tmux to install tmux plugins."
