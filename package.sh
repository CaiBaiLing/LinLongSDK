#!/bin/bash

if test -n "$1"
then
   git tag $1
   git push --tags
   pod package LTAPI.podspec --force --no-mangle
   mv ./LTAPI-"$1" ./SDKPage   
else
   echo -e "缺少参数 请在运行指令后加版本号例如 ./package.sh \"0.1.1\""　
   echo -e "当前git版本号为:"
   git tag
fi


