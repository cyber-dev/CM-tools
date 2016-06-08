#!/bin/bash

#SetUp
SRH_DIR=$1
SRH_FILE=$2
SRH_SV=$3
SRC_DIR="/NAS001/sharing/sh/src_files"
TMP_DIR="${SRC_DIR}/tmp"
HOST_FILE="${SRC_DIR}/hosts.txt"
SRC_FILE="${TMP_DIR}/tmp.txt"
CM_LINE=`grep -ne '-cm-' ${HOST_FILE} | awk -F ':' '{print $1}'`
MB_LINE=`grep -ne '-mb-' ${HOST_FILE} | awk -F ':' '{print $1}'`
MG_LINE=`grep -ne '-mg-' ${HOST_FILE} | awk -F ':' '{print $1}'`

#Function
TMP_CHK()
{
        if [ ! -e ${TMP_DIR} ];then
                mkdir ${TMP_DIR}
        fi
}

SORCE_CHK()
{
       if [ ! -e ${SRC_FILE} ];then
               touch ${SRC_FILE}
       fi
}

HOST_MAKE()
{
        case "$SRH_SV" in
        "cm")
                sed -e "${MB_LINE}",\$d ${HOST_FILE} | sed -e "${CM_LINE}d" \
                > ${SRC_FILE};;
        "mb")
                sed -e "${CM_LINE},${MB_LINE}d" ${HOST_FILE} | sed -e '/-mg-/,/$s/d' \
                > ${SRC_FILE};;
        "mg")
                sed -e "${CM_LINE},${MG_LINE}d" ${HOST_FILE} \
                > ${SRC_FILE};;
          * )
                echo "${SRH_SV}_ERROR"
                exit 1
        esac
}

HOST_READ()
{
        while read HOST
        do
                echo "-${HOST}-"
                /usr/bin/ssh -n ${HOST} "find ${SRH_DIR} -name ${SRH_FILE} -type f \
                -exec md5sum {} \;"
        done < ${SRC_FILE}
}

TMP_RM()
{
        if [ ! -e ${SRC_FILE} ];then
                exit 0
        else
                rm ${SRC_FILE}
                exit 0
        fi
}

#Main
TMP_CHK
SORCE_CHK
HOST_MAKE
HOST_READ
TMP_RM
