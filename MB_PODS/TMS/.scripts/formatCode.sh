#!/bin/bash
currentShellDir="$( cd "$( dirname "$0"  )" && pwd  )"
preDir=$(dirname ${currentShellDir})
formatDir=$currentShellDir/spacecommander/format-objc-file.sh

#子函数getdir
function codeFormat()
{
    #遍历文件夹及其子文件夹内所有文件
    for element in `ls $1`
    do
        file=$1"/"$element
        if [ -d $file ]
        then
            curDicName=${file##*/}
            if [ "$curDicName" != $"Example" ]&&[ "$curDicName" != $"Pods" ]&&[ "$curDicName" != $"Resource" ]&&[ "$curDicName" != $"Pods" ]; then
                codeFormat $file
            fi
        else
            if [ "${file##*.}"x = "m"x ]||[ "${file##*.}"x = "h"x ];then
                echo $file
                $formatDir $file
            fi
        fi
    done
}

echo "------------管道-------------"
cat $preDir/Podfile | while read LINE
do
    result=$(echo $LINE | grep ":path")
    if [[ "$result" != "" ]]
    then
        #去空格
        result=$(echo $result | sed 's/ //g')
        #去除注释
        result=${result%#*}

        #获取路径
        result=$(echo ${result#*>} | sed $'s/\'//g')
        #相对路径变换为绝对路径
        if [[ $result == *$"../"*  ]]; then
            result=${result#*/}
            rootDir=$(dirname ${preDir})
            result="$rootDir/$result"
        fi
        echo "绝对路径：$result"
        codeFormat $result
    fi
done
