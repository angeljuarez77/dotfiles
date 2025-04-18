# Prompt {{{
BLUE=%F{019}
WHITE=%F{015}
USERNAME='%n'
MILITARY_TIME='%T'
NUMBER_OF_FOLDERS_TO_DISPLAY='%3'

PROMPT="$WHITE$USERNAME@$MILITARY_TIME $BLUE$NUMBER_OF_FOLDERS_TO_DISPLAY~ $WHITE$ "
# }}}
# Z Plug {{{
source ~/.zplug/init.zsh
zplug "jeffreytse/zsh-vi-mode"
zplug load
# }}}
# Exports {{{
export EDITOR="nvim"
export HOMEBREW_CASK_OPTS="--no-quarantine"
export LUA_PATH="~/.config/nvim/lua/configs/?.lua"
# }}}
# Aliases {{{
alias so="source ~/.zshrc"
alias ls="ls -Gf"
alias ll="ls -alGf"
alias tree="tree -IC node_modules"
alias .="cd ../"
alias ..="cd ../../"
alias ...="cd ../../../"
alias ....="cd ../../../../"
alias .....="cd ../../../../../"
alias ......="cd ../../../../../../"
alias .......="cd ../../../../../../../"
alias ........="cd ../../../../../../../../"
alias .........="cd ../../../../../../../../../"
alias ..........="cd ../../../../../../../../../../"
alias ...........="cd ../../../../../../../../../../../"
alias ............="cd ../../../../../../../../../../../../"
alias .............="cd ../../../../../../../../../../../../../"
alias ..............="cd ../../../../../../../../../../../../../../"
alias ...............="cd ../../../../../../../../../../../../../../../"
alias ................="cd ../../../../../../../../../../../../../../../../"
alias .................="cd ../../../../../../../../../../../../../../../../../"
alias ..................="cd ../../../../../../../../../../../../../../../../../../"
alias ...................="cd ../../../../../../../../../../../../../../../../../../../"
alias ....................="cd ../../../../../../../../../../../../../../../../../../../../"
alias .....................="cd ../../../../../../../../../../../../../../../../../../../../../"
# }}}
# NVM {{{
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# }}}
