update () {
 git co master
 git fetch --prune
 git pull
 destroy_merged_branches
}

destroy_merged_branches () {
   git branch --merged | grep -v "\*" | xargs -n 1 git branch -d
}

gitbydate () {
    git for-each-ref --sort=-committerdate refs/heads/ --format='%(refname)|%(committerdate)|%(authorname)' | sed 's/refs\/heads\///g' | column -t -s "|"
}

title () {
 echo -e '\033]2;'$*'\007'
}

#git branch
br () {
 givenName=$*
 branchName='ms-'${givenName// /-}
 git co -b $branchName
}

weather () {
 city=${*-brisbane} 
 curl "wttr.in/${city}"
}

agreplace () {
 from=$1
 to=$2
 echo "change ${from}, with ${to}"
 ag "${from}" --nogroup | awk '{print substr($1,1,index($1,":")-1);}' | xargs -I {} sed -i .bak -e 's/${from}/${to}/g' {}
}

function git-log() {
  git log -M40 --pretty=format:'%Cred%h%Creset%C(yellow)%d%Creset %s %C(green bold)- %an %C(black bold)%cd (%cr)%Creset' --abbrev-commit --date=short "$@"
}

# git log
function glg() {
  if [[ $# == 0 ]] && git rev-parse @{u} &> /dev/null; then
    git-log --graph @{u} HEAD
  else
    git-log --graph "$@"
  fi
}

# protect AWS secrets
# https://github.com/awslabs/git-secrets
# run this in every repo to prevent secrets leaking
function protect-secrets() {
  git secrets --install
  git secrets --register-aws
}
