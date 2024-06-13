#!/bin/bash

# 指定编码
export LANG="zh_CN.UTF-8"
export LC_COLLATE="zh_CN.UTF-8"
export LC_CTYPE="zh_CN.UTF-8"
export LC_MESSAGES="zh_CN.UTF-8"
export LC_MONETARY="zh_CN.UTF-8"
export LC_NUMERIC="zh_CN.UTF-8"
export LC_TIME="zh_CN.UTF-8"
export LC_ALL=

FORMAT_MODULE=
# 项目名称
CurrentDir="$( pwd )"
echo $CurrentDir
project_name=`find . -name *.xcodeproj | awk -F "[/.]" '{print $(NF-1)}'`
project_path='./'
if [ -e "${project_path}/${project_name}.xcworkspace" ];then
    workspace_name="${project_name}.xcworkspace"
    echo "工程名：${workspace_name}"
else
    echo "no xcworkspace"
    exit 1
fi
myworkspace=${workspace_name}
myscheme="YMMDriver"
echo "-----myworkspace是：${myworkspace}, myscheme是：${myscheme}-----"

#获取OCLint要检测的路径
function getModule() {
    while read LINE
    do
        result=$(echo $LINE | grep ":path")
        if [[ "$result" != "" ]]
        then
            #去空格
            result=$(echo $result | sed 's/ //g')

            #获取路径
            result=$(echo ${result:4} | sed $'s/\'//g')
            result=$(echo ${result%,*})

            #拼接模块路径
            FORMAT_MODULE=$FORMAT_MODULE" -i "$result
        fi
    done < $CurrentDir/Podfile
    FORMAT_MODULE=$(echo $FORMAT_MODULE | sed 's/^[ \t]*//g')
}


# 检测依赖
command -v xcpretty >/dev/null 2>&1 || {
    echo >&2 "I require xcpretty but it's not installed.  Install：gem install xcpretty";
        exit
}
command -v oclint-json-compilation-database >/dev/null 2>&1 || {
    echo >&2 "I require oclint-json-compilation-database but it's not installed.  Install：brew install oclint";
        exit
}
    
#---------------检测模块-------------------------
getModule
if [ -z "$FORMAT_MODULE" ]; then
    echo '------OCLint检测的模块为空，请检查podfile！-------------'
    exit 0
else
    echo "------OCLint检测的模块为：${FORMAT_MODULE}-------------"
fi

# 清除上次编译数据
echo '-----清除上次编译数据derivedData-----'
# fix xcode 10 can not clean build cache in DerivedData
build_cache_dir="${PROJECT_TEMP_DIR}"
build_cache_dir=${build_cache_dir%/*}
build_cache_dir=${build_cache_dir%/*}
echo "build_cache_dir = ${build_cache_dir}"
sudo rm -rf "${build_cache_dir}"

#xcodebuild -workspace ${myworkspace} -scheme ${myscheme} clean

echo '-----开始编译-----'
# 生成编译数据
xcodebuild ARCHS=x86_64 \
ONLY_ACTIVE_ARCH=NO \
OBJROOT="${OBJROOT}/DependentBuilds" \
COMPILER_INDEX_STORE_ENABLE=NO \
-workspace ${myworkspace} -scheme ${myscheme} \
-sdk iphonesimulator \
-configuration Debug \
| xcpretty -r json-compilation-database -o compile_commands.json

if [ -f ./compile_commands.json ]
    then
    echo "-----编译数据生成完毕-----"
else
    echo "-----生成编译数据失败-----"
    exit 0
fi

echo '-----分析中-----'
oclint-json-compilation-database $FORMAT_MODULE
rm compile_commands.json
echo '-----分析完毕-----'
exit 0
