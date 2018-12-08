#!/bin/bash

THREAD=10
ROOTDIR="$(pwd)"
TMP_FIFO="/tmp/$.fifo"
KEY_PROJECT="<project"
KEY_NAME='name="'
KEY_PATH='path="'
BRANCH_PUPLIC="public"

DEFAULT_XML=".repo/manifest.xml"


mkfifo "${TMP_FIFO}"
exec 6<>"${TMP_FIFO}"
rm ${TMP_FIFO}


needToDo(){
    name=${1%\"}
    path=${2%\"}
    echo "name ->　$name"
    echo "path ->  $path"
    cd ${path}
    git checkout $BRANCH_PUPLIC
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
        echo ${line}
        if [[ "${line}" == ${KEY_PROJECT}* ]]
        then
            name=${line#*${KEY_NAME}}
            path=${line#*${KEY_PATH}}
            name_real=${name%${KEY_PATH}*}
            path_real=${path%/*}
            needToDo ${name_real} ${path_real}

        fi
        echo >&6
    }&
done < ${DEFAULT_XML}


wait
exec 6>&-
exit 0
