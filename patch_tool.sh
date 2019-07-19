#!/bin/bash

THREAD=10
ROOTDIR="$(pwd)"
TMP_FIFO="/tmp/$.fifo"
BRANCH_PUPLIC="public"
DEFAULT_LIST="./repo/project.list"


mkfifo "${TMP_FIFO}"
exec 6<>"${TMP_FIFO}"
rm ${TMP_FIFO}


needToDo(){
    path=${1}
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
        needToDo ${line}
        echo >&6
    }&
done < ${DEFAULT_XML}


wait
exec 6>&-
exit 0
