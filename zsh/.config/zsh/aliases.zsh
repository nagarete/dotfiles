# Personal aliases recovered from the old SSD.
# Preserve the old paru preference when paru is available.
if (( $+commands[paru] )); then
  alias yay="paru"
fi
alias python="python3"
alias oc="opencode"
alias oc2="opencode2"
alias snaplist="sudo snapper --config root list && sudo snapper --config home list"
