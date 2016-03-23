# File contains useful code for ~/.bashrc files

#######################################################################
# Copy and paste using terminal
#######################################################################
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'

#######################################################################
# Open tmux with proper color schemes enabled
#######################################################################
alias tmux='tmux -2'

#######################################################################
# View public IP address
#######################################################################
alias publicip='wget -qO - http://ipecho.net/plain ; echo'

#######################################################################
# Set command to include git branch in my prompt
#######################################################################
function parse_git_branch () {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

BOLD_GREEN="\[$(tput bold)\]\[\033[38;5;10m\]"
BOLD_BLUE="\[$(tput bold)\]\[\033[38;5;115m\]"
BOLD_YELLOW="\[$(tput bold)\]\[\033[38;5;226m\]"
NO_COLOR="\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;15m\]"
ENDING="\[$(tput sgr0)\]"

PS1_USER_HOST="${BOLD_GREEN}\u@\h"
PS1_GIT_BRANCH="${BOLD_YELLOW}\$(parse_git_branch)${NO_COLOR} "
PS1_ENDING="${BOLD_BLUE}\w${NO_COLOR} ${BOLD_BLUE}\$${NO_COLOR} ${ENDING}"

PS1="${PS1_USER_HOST}${PS1_GIT_BRANCH}${PS1_ENDING}"