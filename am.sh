#!/bin/bash

function usage() {
cat<<USAGE
        bash am.sh SRC_DIR PATCH_DIR
USAGE
}
if [[ -z $1 ]] || [[ -z $2 ]]
then
    usage
    exit 1
fi
echo "src dir = $1"
echo "patch dir = $2"

SRC_DIR=$1
PATCH_DIR=$2
ROOT_DIR=$(pwd)
patchs=$(ls  ${PATCH_DIR})
for patch in $(ls ${PATCH_DIR})
do
    patch_file=${PATCH_DIR}/$patch
    echo -e "INFO: now git am ${patch_file}"
    cd ${SRC_DIR}
    git am ${patch_file}
    if [[ $? -ne 0 ]]
    then
        git am --abort
        echo "######################################"
        echo -e "ERROR: Faild to am ${patch_file}"
        echo "#####################################"
        break
    else
        rm ${patch_file}
    fi
    cd ${ROOT_DIR}
done
