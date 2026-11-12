# Omarchy paths and user-installed tools.
[[ -r /usr/share/omarchy/default/bash/env-bootstrap ]] && source /usr/share/omarchy/default/bash/env-bootstrap
export PATH="$HOME/.local/bin:$PATH"
export EDITOR=nvim

# Oh My Zsh settings recovered from the old SSD.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="af-magic"
plugins=(git vi-mode)
source "$ZSH/oh-my-zsh.sh"
source "$HOME/.config/zsh/aliases.zsh"

# Tool completions and directory navigation.
compdef _files uv=run
(( $+commands[zoxide] )) && eval "$(zoxide init zsh --cmd cd)"

# Include optional user-installed binaries without old-home absolute paths.
[[ -d "$HOME/.opencode/bin" ]] && export PATH="$HOME/.opencode/bin:$PATH"
[[ -r "$HOME/.local/bin/env" ]] && source "$HOME/.local/bin/env"

# bun completions
[ -s "/home/nagarete-arch-5/.bun/_bun" ] && source "/home/nagarete-arch-5/.bun/_bun"

source "$HOME/.config/shell/tools.sh"
