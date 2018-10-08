#!/bin/bash

FOLDER=$1

cd $FOLDER

DIR=$(find . -name .git -type d -prune)

ERROR=()
bold=$(tput bold)
normal=$(tput sgr0)

git_update() {
    git config http.sslVerify false
    BRANCH=$(git rev-parse --abbrev-ref HEAD)
    if [[ "$BRANCH" == "develop" ]]
    then
        if [[ -n "$(git status --porcelain)" ]]
        then
            echo "${bold}There are changes in $1${normal}"
            ERROR+=("${bold}There are changes in $1${normal}")

        else
            echo "${bold}Pulling $1${normal}"
            git pull
        fi
    elif [[ "$BRANCH" == "master" ]]
    then
        if [[ -n "$(git status --porcelain)" ]]
        then
            echo "${bold}There are changes in $1${normal}"
            ERROR+=("${bold}There are changes in $1${normal}")
        else
            echo "${bold}Pulling $1${normal}"
            git pull
        fi
    else
        echo "${bold}$BRANCH is checked-out in $1${normal}"
        ERROR+=("${bold}$BRANCH is checked-out in $1${normal}")
    fi
}

for i in ${DIR[@]}
do
    clean_dir=${i%????}
    cd $clean_dir
    git_update $clean_dir
    cd $FOLDER
done

printf "\n"

if [ ! -z "$ERROR" ]
then
    echo "The following branchs could not be updated:"
fi

for i in "${ERROR[@]}"
do
    echo $i
done