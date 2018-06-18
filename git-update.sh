#!/bin/bash

FOLDER=$1

cd $FOLDER

DIR=(*)
ERROR=()
bold=$(tput bold)
normal=$(tput sgr0)

for i in "${DIR[@]}"
do
    cd $i
    BRANCH=$(git rev-parse --abbrev-ref HEAD)
    if [[ "$BRANCH" == "develop" ]]
    then
        if [[ -n "$(git status --porcelain)" ]]
        then
            echo "${bold}There are changes in $i${normal}"
            ERROR+=("${bold}There are changes in $i${normal}")

        else
            echo "${bold}Pulling $i${normal}"
            git pull
        fi
    elif [[ "$BRANCH" == "master" ]]
    then
        if [[ -n "$(git status --porcelain)" ]]
        then
            echo "${bold}There are changes in $i${normal}"
            ERROR+=("${bold}There are changes in $i${normal}")
        else
            echo "${bold}Pulling $i${normal}"
            git pull
        fi
    else
        echo "${bold}$BRANCH is checked-out in $i${normal}"
        ERROR+=("${bold}$BRANCH is checked-out in $i${normal}")
    fi
    cd ..
done

printf "\n"
echo "The following branchs could not be updated:"
for i in "${ERROR[@]}"
do
    echo $i
done