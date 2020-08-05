#!/bin/bash

THREAD=10
ROOTDIR="$(pwd)"
TMP_FIFO="/tmp/$.fifo"
BRANCH_PUPLIC="public"
DEFAULT_LIST=".repo/project.list"

DEFAULT_PATCH_DIR=~/Android/Patch/EP33

mkfifo "${TMP_FIFO}"
exec 6<>"${TMP_FIFO}"
rm ${TMP_FIFO}


needToDo(){
    path=${1}
    # echo "path ->  $path"
    cd ${path}
    # git checkout $BRANCH_PUPLIC
    if [[ $(git log -1 | grep yanfeng) != "" ]]
    then
        echo "$path"
        patchdir=${DEFAULT_PATCH_DIR}/${path}
        mkdir -p ${patchdir}
        patchnum=$(git log --oneline --author="lee"|wc -l)
        commitline=$(($patchnum +1))
        commitid=$(git log --oneline | awk '{print $1}'| sed -n "${commitline}p")
        # git log --oneline $commitid -1
        git format-patch $commitid -o ${patchdir}
        echo $commitid

    fi
    cd ${ROOTDIR}

}
for ((i=0;i<${THREAD};i++));
do
    echo
done >&6

while read line
do
    read -u6
    {
        # echo ${line}
        needToDo ${line}
        echo >&6
    }&
done < ${DEFAULT_LIST}


wait
exec 6>&-
exit 0

