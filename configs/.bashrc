# PROMPT COLOURS
BLACK='\[\e[0;30m\]'        # Black - Regular
RED='\[\e[0;31m\]'          # Red
GREEN='\[\e[0;32m\]'        # Green
YELLOW='\[\e[0;33m\]'       # Yellow
BLUE='\[\e[0;34m\]'         # Blue
PURPLE='\[\e[0;35m\]'       # Purple
CYAN='\[\e[0;36m\]'         # Cyan
WHITE='\[\e[0;37m\]'        # White
BLACK_BOLD='\[\e[1;30m\]'   # Black - Bold
RED_BOLD='\[\e[1;31m\]'     # Red - Bold
GREEN_BOLD='\[\e[1;32m\]'   # Green - Bold
YELLOW_BOLD='\[\e[1;33m\]'  # Yellow - Bold
BLUE_BOLD='\[\e[1;34m\]'    # Blue - Bold
PURPLE_BOLD='\[\e[1;35m\]'  # Purple - Bold
CYAN_BOLD='\[\e[1;36m\]'    # Cyan - Bold
WHITE_BOLD='\[\e[1;37m\]'   # White - Bold
RESET='\[\e[0m\]'           # Text Reset

alias ls='ls --color=auto'
alias ll='ls -lah'

if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
  . /etc/bash_completion
fi

git_branch() {
  local BRANCH=$(git symbolic-ref HEAD --short 2> /dev/null)
  if [ ! -z "${BRANCH}" ]; then
    echo "(${BRANCH})"
  fi
}

git_tag() {
  local TAG=$(git describe --exact-match --tags HEAD 2> /dev/null)
  if [ ! -z "${TAG}" ]; then
    echo "($TAG)"
  fi
}

export PS1="${RED_BOLD}\u${CYAN_BOLD}@${BLUE_BOLD}${HOSTNAME}${PURPLE_BOLD} \w ${YELLOW_BOLD}\$(git_branch)${GREEN_BOLD}\$(git_tag)${PURPLE_BOLD}\$${RESET} "
