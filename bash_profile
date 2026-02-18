# Load anything in the bashrc first
[[ -s ~/.bashrc ]] && source ~/.bashrc

function_exists() {
  command -v $1 > /dev/null
  return $?
}

# Some shells (such as zsh) do not have a `complete` keyword, so we need
# to make sure that `complete` exists as a shell built-in before calling it,
# or alternate shell users will get errors.
function_exists complete && complete -cf sudo

### Configure command line colors
export CLICOLOR=1

### export LSCOLORS=ExFxBxDxCxegedabagacad
export LSCOLORS=GxFxCxDxBxegedabagaced
alias ls='ls -GFh'

### Set color variables
BLACK="\[\e[0;30m\]"
DARK_GRAY="\[\e[1;30m\]"
RED="\[\e[0;31m\]"
YELLOW="\[\e[0;33m\]"
PURPLE="\[\e[1;34m\]"
BLUE="\[\e[0;34m\]"
LIGHT_BLUE="\[\e[1;34m\]"
GREEN="\[\e[0;32m\]"
LIGHT_GREEN="\[\e[1;32m\]"
CYAN="\[\e[0;36m\]"
LIGHT_CYAN="\[\e[1;36m\]"
LIGHT_RED="\[\e[1;31m\]"
PURPLE="\[\e[0;34m\]"
LIGHT_PURPLE="\[\e[1;35m\]"
BROWN="\[\e[0;33m\]"
LIGHT_GRAY="\[\e[0;37m\]"
WHITE="\[\e[1;37m\]"

### Basic directories
alias up="cd .."
alias h="pushd ~"

### Load script that allows for showing git branch in PS1
source ~/code/dotfiles/git-prompt.sh

### Load script that allows for git autocompletion
source ~/code/dotfiles/git-completion.bash

### Change command prompt display
NAME="nate"
#export PS1="${YELLOW}\W:${PURPLE}\$(__git_ps1)${RED} ${NAME}\$ "
export PS1="${YELLOW}\W:${PURPLE}\$(__git_ps1)${RED} ${NAME}\$ ${GREEN}"

### Git aliases
alias gs='git status'
alias ga='git add'
alias gb='git branch'
alias gc='git commit'
alias gd='git diff'
# git log all (vs. only current branch commits defined below)
alias gla='git log'
alias gco='git checkout'
alias gk='gitk --all&'
alias gx='gitx --all'
alias ghist='git hist'
alias gpom='git pull origin master'
alias Gpom=gpom
alias gcfl='git cfl'
alias gssb='git diff HEAD ^master'

# Rebase current branch onto updated master
grbm() {
  curr_branch=$(git branch --show-current);
  git checkout master && git pull origin master && git checkout $curr_branch && git rebase master;
}

# "Git update checkout" i.e. pull and fetch master then checkout a remote branch
guco() {
  git checkout master && git pull origin master && git fetch && git checkout $1;
}

### Log only current branch's commits
gl() {
 branch=$(git branch --show-current);
 git log $branch --not master;
}

### stashing stuff :D
alias gstash='git stash save'
alias gsl='git stash list'
gsa() { git stash apply stash@{$1}; }
gss() { git stash show stash@{$1}; }
gssp() { git stash show -p stash@{$1}; }
gsd() { git stash drop stash@{$1}; }
gsp() {
	if [ $# -ge 1 ]
	then
    	git stash pop stash@{$1};
	else
    	git stash pop
	fi
}

### Setup local branch to track remote
got() { git checkout --track -b $1 origin/$1; }

alias sbl="open -a Sublime\ Text\ 2"
alias prof="vim ~/.bash_profile"
alias r="source ~/.bash_profile"
alias mv='mv -i '

### GIT AUTOCOMPLETE MAGIC
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# ------------------------------------
# Docker alias and function
# ------------------------------------

# Get latest container ID
alias dl="docker ps -l -q"

# Get container process
alias dps="docker ps"

# Get process included stop container
alias dpa="docker ps -a"

# Get images
alias di="docker images"

# Get container IP
alias dip="docker inspect --format '{{ .NetworkSettings.IPAddress }}'"

# Run deamonized container, e.g., $dkd base /bin/echo hello
alias dkd="docker run -d -P"

# Run interactive container, e.g., $dki base /bin/bash
alias dki="docker run -i -t -P"

# Execute interactive container, e.g., $dex base /bin/bash
alias dex="docker exec -i -t"

# # Execute interactive container with bash, e.g., $dex base /bin/bash
# dbash() { docker exec -it=$1 bash; }

# Stop all containers
dstop() { docker stop $(docker ps -a -q); }

# # Remove all containers
drm() { docker rm $(docker ps -a -q); }

# Stop and Remove all containers
alias drmf='docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)'

# Stop and Remove only active containers
alias drma='docker stop $(docker ps -q) && docker rm $(docker ps -q)'

# Remove all images
dri() { docker rmi $(docker images -q); }

# Remove dangling images
drdi() { docker rmi $(docker images -f "dangling=true" -q); }

# Dockerfile build, e.g., $dbu tcnksm/test 
dbu() { docker build -t=$1 .; }

# Docker environment for default
denv() { eval "$(docker-machine env default)"; }

# Show all alias related docker
dalias() { alias | grep 'docker' | sed "s/^\([^=]*\)=\(.*\)/\1 => \2/"| sed "s/['|\']//g" | sort; }
 

# docker function to stop and remove all containers (force)
dkrm() {
  docker rm -f $(docker ps -a -q);
}

### Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

. "$HOME/.cargo/env"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="/Users/nate/.local/share/solana/install/active_release/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/nate/google-cloud-sdk/path.bash.inc' ]; then . '/Users/nate/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/nate/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/nate/google-cloud-sdk/completion.bash.inc'; fi

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

