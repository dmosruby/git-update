#!/bin/bash

FOLDER=$1

cd $FOLDER

DIR=(*)
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
        else
            git pull
        fi
    elif [[ "$BRANCH" == "master" ]]
    then
        if [[ -n "$(git status --porcelain)" ]]
        then
            echo "${bold}There are changes in $i${normal}"
        else
            git pull
        fi
    fi
    cd ..
done