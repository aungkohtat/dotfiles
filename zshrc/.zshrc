# ── Environment ─────────────────────────────────────
typeset -U PATH  # deduplicate PATH entries automatically
export GOPATH="$HOME/go"
export BUN_INSTALL="$HOME/.bun"
export XDG_CONFIG_HOME="$HOME/.config"
export NIX_CONF_DIR=$HOME/.config/nix
export KUBECONFIG=~/.kube/config
export LANG=en_US.UTF-8
export EDITOR=/opt/homebrew/bin/nvim
export STARSHIP_CONFIG=~/.config/starship/starship.toml

path=(
  $HOME/.local/bin
  $HOME/repos/scripts
  $BUN_INSTALL/bin
  /opt/homebrew/bin
  /run/current-system/sw/bin
  ${GOPATH}/bin
  $HOME/.cargo/bin
  $HOME/.vimpkg/bin
  /usr/local/bin
  /usr/bin
  /bin
  /usr/sbin
  /sbin
  $path
)

# ── Nix ─────────────────────────────────────────────
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

# ── Completion ──────────────────────────────────────
setopt prompt_subst
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
autoload bashcompinit && bashcompinit
autoload -Uz compinit
compinit
# lazy-load kubectl completion (faster shell startup)
kubectl() {
  unfunction kubectl
  source <(command kubectl completion zsh)
  command kubectl "$@"
}
complete -C '/usr/local/bin/aws_completer' aws

# ── Plugins ─────────────────────────────────────────
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '^w' autosuggest-execute
bindkey '^e' autosuggest-accept
bindkey '^u' autosuggest-toggle
bindkey '^L' vi-forward-word
bindkey '^k' up-line-or-search
bindkey '^j' down-line-or-search

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval "$(atuin init zsh)"
eval "$(direnv hook zsh)"

# ── Television ──────────────────────────────────────
if command -v tv &>/dev/null; then
  alias tvk="tv k8s-pods"
  alias tvg="tv git-log"
  alias tva="tv aws-instances"
  alias tvd="tv docker-containers"
  alias tvr="tv git-repos"
fi

### FZF ###
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow'
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--color=border:#313244,label:#cdd6f4"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# bun completions
[ -s "/Users/aungkohtet/.bun/_bun" ] && source "/Users/aungkohtet/.bun/_bun"

# VI Mode!!!
bindkey jj vi-cmd-mode

# ── Aliases: Git ────────────────────────────────────
alias gc="git commit -m"
alias gca="git commit -a -m"
alias gp="git push origin HEAD"
alias gpu="git pull origin"
alias gst="git status"
alias glog="git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit"
alias gdiff="git diff"
alias gco="git checkout"
alias gb='git branch'
alias gba='git branch -a'
alias gadd='git add'
alias ga='git add -p'
alias gcoall='git checkout -- .'
alias grm='git remote'
alias gre='git reset'

# ── Aliases: Docker ─────────────────────────────────
alias dco="docker compose"
alias dps="docker ps"
alias dpa="docker ps -a"
alias dl="docker ps -l -q"
alias dx="docker exec -it"

# ── Aliases: Terraform ──────────────────────────────
alias tf='terraform'
alias tfi='terraform init'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfd='terraform destroy'
alias tfv='terraform validate'
alias tff='terraform fmt'
alias tfo='terraform output'
alias tfs='terraform state'
alias tfpo='terraform plan -out=tfplan'
alias tfao='terraform apply tfplan'
alias tfaa='terraform apply -auto-approve'
alias tfda='terraform destroy -auto-approve'
alias tfsl='terraform state list'
alias tfss='terraform state show'
alias tfsm='terraform state mv'
alias tfsr='terraform state rm'
alias tfw='terraform workspace'
alias tfwl='terraform workspace list'
alias tfws='terraform workspace select'
alias tfwn='terraform workspace new'
alias tfiu='terraform init -upgrade'
alias tfir='terraform init -reconfigure'
alias tffr='terraform fmt -recursive'
alias tfver='terraform version'
alias tfr='terraform refresh'
alias tfc='terraform console'
alias tfg='terraform graph | dot -Tpng > graph.png'

# tfenv
alias tfei='tfenv install'
alias tfeu='tfenv use'
alias tfel='tfenv list'

# tflint
alias tfl='tflint'
alias tflr='tflint --recursive'
alias tfli='tflint --init'

# trivy
alias tfscan='trivy config .'
alias tfscanf='trivy config --severity HIGH,CRITICAL .'

# infracost
alias tfcost='infracost breakdown --path .'
alias tfcostd='infracost diff --path .'

# terraform-docs
alias tfdoc='terraform-docs markdown table . > README.md'
alias tfdocp='terraform-docs markdown table .'

# ── Aliases: AWS ────────────────────────────────────
alias av='aws-vault'
alias ave='aws-vault exec'
alias avl='aws-vault list'
alias ava='aws-vault add'
alias avr='aws-vault remove'
alias avs='aws-vault exec -- aws sts get-caller-identity'
alias assume='granted'

# ── Aliases: K8S ────────────────────────────────────
alias k="kubectl"
alias ka="kubectl apply -f"
alias kg="kubectl get"
alias kd="kubectl describe"
alias kdel="kubectl delete"
alias kl="kubectl logs -f"
alias kgpo="kubectl get pod"
alias kgd="kubectl get deployments"
alias kc="kubectx"
alias kns="kubens"
alias ke="kubectl exec -it"
alias kcns='kubectl config set-context --current --namespace'

# ── Aliases: General ────────────────────────────────
alias la=tree
alias cat=bat
alias cl='clear'
alias v="$HOME/.nix-profile/bin/nvim"
alias http="xh"
alias nm="nmap -sC -sV -oN nmap"
alias mat='osascript -e "tell application \"System Events\" to key code 126 using {command down}" && tmux neww "cmatrix"'
alias rr='ranger'
alias devops='tmux neww "top"'

# Dirs
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# Eza
alias l="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"
alias ltree="eza --tree --level=2 --icons --git"

# ── Functions ───────────────────────────────────────
cx() { cd "$@" && l; }
fcd() { cd "$(fd --type d --hidden --follow | fzf)" && l; }
f() { echo "$(fd --type f --hidden --follow | fzf)" | pbcopy; }
fv() { nvim "$(fd --type f --hidden --follow | fzf)"; }

function ranger {
	local IFS=$'\t\n'
	local tempfile="$(mktemp -t tmp.XXXXXX)"
	local ranger_cmd=(
		command
		ranger
		--cmd="map Q chain shell echo %d > "$tempfile"; quitall"
	)

	${ranger_cmd[@]} "$@"
	if [[ -f "$tempfile" ]] && [[ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]]; then
		cd -- "$(cat "$tempfile")" || return
	fi
	command rm -f -- "$tempfile" 2>/dev/null
}

# SEC STUFF
alias gobust='gobuster dir --wordlist ~/security/wordlists/diccnoext.txt --wildcard --url'
alias dirsearch='python dirsearch.py -w db/dicc.txt -b -u'
alias massdns='~/hacking/tools/massdns/bin/massdns -r ~/hacking/tools/massdns/lists/resolvers.txt -t A -o S bf-targets.txt -w livehosts.txt -s 4000'
alias server='python -m http.server 4445'
alias tunnel='ngrok http 4445'
alias fuzz='ffuf -w ~/hacking/SecLists/content_discovery_all.txt -mc all -u'
alias gf='~/go/src/github.com/tomnomnom/gf/gf'

# ── Secrets (must be near end) ──────────────────────
# Atlassian token and other API keys loaded from ~/.secrets
[ -f ~/.secrets ] && source ~/.secrets

# ── Ryan Standup Logger ──────────────────────────────
_standup_log_cmd() {
    local cmd
    cmd=$(fc -ln -1 2>/dev/null | sed 's/^[[:space:]]*//')
    [[ -z "$cmd" ]] && return
    [[ "$cmd" =~ ^(ls|ll|la|cd|pwd|clear|cl|exit|history|cat|echo|man|help)$ ]] && return
    local log="$HOME/.openclaw/workspace/logs/terminal-activity.log"
    mkdir -p "$(dirname "$log")"
    echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) | $(pwd) | $cmd" >> "$log"
}
precmd_functions+=(_standup_log_cmd)
# ── End Ryan Standup Logger ─────────────────────────

# Terraform Cloud API token (from terraform login)
export TFE_TOKEN="REDACTED"

alias gam="/Users/aungkohtet/bin/gam7/gam"
export SQUADCAST_REFRESH_TOKEN="your-api-key-here"
