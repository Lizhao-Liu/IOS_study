#!/bin/bash

# $1:path $2:url $3:branche
function update_flutter_app() {
    cd $1
    # 获取branch名
    branch=`git name-rev --name-only HEAD`
    if [[ $3 == $branch ]]
    then
        echo 'git pull for '$3
        git stash
        git pull
    else
        echo 'git clone for '$3
        rm -rf $1
        cd ~/
        git clone --single-branch --branch $3 $2 $1 --depth 1
        cd $1 && chmod -R 775 * 
    fi
}

update_flutter_app $@