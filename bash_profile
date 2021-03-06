### Put psql on the path
##PATH=$PATH:/Library/PostgreSQL/9.3/bin
PATH=$PATH:/usr/local/opt/postgresql@9.5/bin

### Put play on the path
export PATH=$PATH:/Users/nlevine/lendup/play-1.2.6.7

## play home for gradle
export PLAY_HOME=/Users/nlevine/lendup/play-1.2.6.7

### Put ~/bin on the path
export PATH=~/bin:$PATH

# Put pear on the path
export PATH=$PATH:/Users/nlevine/pear/bin

export PATH="/usr/local/sbin:$PATH"

### JENV

export JENV_ROOT="/usr/local/var/jenv"
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

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
alias ldc="cd /Users/nlevine/lendup/play-1.2.6.7/ldc"
alias lu="cd ~/lendup"

### Load script that allows for showing git branch in PS1
source /Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-prompt.sh

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
alias go='git checkout'
alias gk='gitk --all&'
alias gx='gitx --all'
alias gh='git hist'
alias gpom='git push origin master'

### Log only current branch's commits
gl() {
  branch=$(git symbolic-ref HEAD);
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
alias prof="sbl ~/.bash_profile"
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
# drm() { docker rm $(docker ps -a -q); }

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

### Run LendUp Play Server Shortcuts
alias playrun="../play run --%nlevine"
alias playtest="../play test --%test-unit"
alias playnight="../play run --%nightwatch"

## Apply database evolutions
evol() { 
if [ $# -ge 1 ]
  then
      ../play evolutions:apply --%test-unit
  else
      ../play evolutions:apply --%nlevine
  fi
}

### Sync Dependencies
alias deps="../play dependencies --sync"

# function for nightwatch testing; accepts path to test
function nt() {
  cd ~/lendup/play-1.2.6.7/ldc/selenium-tests/nightwatch;
  ./node_modules/.bin/nightwatch -c nightwatch.json -t $1;
}

# Build lendup frontend assets
alias buildfe="cd ~/lendup/play-1.2.6.7/ldc/client && ./node_modules/.bin/gulp dev"

#Pull provider documents from S3 bucket
alias provider="./scripts/get_provider_docs.py --action pull --execute"

# AWS CLI Bash Tab-Completions
complete -C aws_completer aws

### Java exports & Functions

export JAVA6_HOME=$(/usr/libexec/java_home -v 1.6)

java6 () {
    export JAVA_HOME=$(/usr/libexec/java_home -v 1.6)
}

java7 () {
    export JAVA_HOME=$(/usr/libexec/java_home -v 1.7)
}

java8 () {
    export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
}
### Default to java 6
java6

### Build Done Script for Jenkins

function build_done {
  while true
  do
    if [ 'null' != `curl -s "https://jenkins.gameofloans.com/job/LDC-MasterMerge/${2}/api/json" -H "Cookie: ${1}" | jq '.result'` ]
    then
      osascript -e 'display notification "Build done"'
      break
    else
      sleep 15
    fi
  done
}

### Jenkins Setup
export JENKINS_USER=natelevine
export JENKINS_TOKEN=25391e21fccfaecb66aa2e4022c859c7
export JENKINS_MODE=1

### Annoying play server grep query
alias gp='ps -A | grep play'
alias pk='pkill -9 -f play-1.2'

### Save known SSH keys
ssh-add -A 2>/dev/null;

### Start PSQL
alias spsql="pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start"

### Virtualenv setup
export WORKON_HOME=$HOME/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh

## Heroku pipeline release (lendup)
export JENKINS_USER=natelevine
export JENKINS_TOKEN=b135ca7d7516a7ac0a703bdb74fc21f6

export GITHUB_TOKEN=399354431b83e5453c8dac3d9ea5175fea402727

## Start ChromeDriver
alias cdriver="chromedriver --url-base=/wd/hub"

## Checkup Checks
export CHECKUP_CHECKS_HOME=/Users/nlevine/lendup/checkup-checks/checks
export VIRTUALENVWRAPPER_SCRIPT=/usr/local/bin/virtualenvwrapper.sh
