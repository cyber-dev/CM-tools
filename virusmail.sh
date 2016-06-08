#!/bin/bash -x

#Input---------------------------------
DN="cmv7local.jp"

#SetUp---------------------------------
TESTCASE=$1
NUMTIME=$2
HOST=$3
FMID=$4
TOID=$5
ARG=$#
COUNT=0
RETBAL=0
STS=0
SHNAME="`basename $0`"
LS="/bin/ls"
DATE="/bin/date"
ECHO="/bin/echo"
PS="/bin/ps"
GREP="/bin/grep"
EXPR="/usr/bin/expr"
MAILX="/bin/mailx"
ICONV="/usr/bin/iconv"
BASE64="/usr/bin/base64"

#Mail Assembly-------------------------
FM="${FMID}@`hostname`"
TO="${TOID}@${HOST}.${DN}"
CONTENTS="検証用VirusMail ${TESTCASE}"
MAKECONTENTS="`${ECHO} -e ${CONTENTS} | ${ICONV} -f utf-8 -t utf-8`"
SUBJECT="検証用VirusMail ${TESTCASE}"
HEAD="=?$OUTPUT?B?"
BODY="`${ECHO} "${SUBJECT}" | ${ICONV} -f utf-8 -t utf-8 | ${BASE64} | tr -d '\n'`"
TAIL="?="
MAKESUB="${HEAD}${BODY}${TAIL}"

#SPAM
SPAM="XJS*C4JDBQADN1.NSBN3*2IDNEN*GTUBE-STANDARD-ANTI-UBE-TEST-EMAIL*C.34X"
SPAMMAKE="`${ECHO} -e ${SPAM} | ${ICONV} -f utf-8 -t utf-8`"

#Test Assembly-----------------------------
SRCDIR="/NAS001/sharing/sh/test_virus"
ATTFILE="${SRCDIR}/${TESTCASE}/*"

#StartLabel & Funcshion----------------
STR_LBL()
{
        ${ECHO} "*****  ${SHNAME} start `${DATE} +'%Y/%m/%d %H:%M:%S'` *****"
}

PROC_CHK()
{
        ${PS} -ef | ${GREP} smtpd | \
        ${GREP} -v grep >/dev/null 2>&1
        RETBAL=$?
        if [ "${RETBAL}" -eq 0 ];then
                PROC_ERR
                END_LBL
        fi
}

ARG_CHK1()
{
        if [ ${ARG} -ne 5 ];then
                ARG_ERR1
                END_LBL
        fi
}

ARG_CHK2()
{
        case "$TESTCASE" in
                TC1[4-5])
                ARG_ERR2
                END_LBL;;
        esac
}

RETBAL_CHK()
{
        if [ ${RETBAL} -ne 0 ];then
                SENT_ERR
        else
                ${ECHO} "${TESTCASE}...Sent ${COUNT}_OK"
fi
}

SPAM_CHK()
{
        if [ ${TESTCASE} = SPAM ];then
                SPAM_SENT
        fi

}

SPAM_SENT()
{
        while [ ${COUNT} -ne ${NUMTIME} ];
        do
                COUNT=$(( COUNT + 1 ))
                SPAMSUB="TestMail SPAM-${COUNT}"
                echo "${SPAMMAKE}" | ${MAILX} -s \
                "${SPAMSUB}" -r "${FM}" "${TO}"
                RETBAL=$?
                RETBAL_CHK
        done
                END_LBL
}

ATTFILE_CHK()
{
        ${LS} ${ATTFILE} >/dev/null 2>&1
        RETBAL=$?
        if [ "${RETBAL}" -ne 0 ];then
                ATTFILE_ERR
                END_LBL
        fi
}

MAIL_SENT()
{
        while [ ${COUNT} -ne ${NUMTIME} ];
        do
                COUNT=$(( COUNT + 1 ))
                ${ECHO} ${MAKECONTENTS} | ${MAILX} -s "${MAKESUB}" \
                -a ${ATTFILE} -r "${FM}" "${TO}"
                RETBAL=$?
                RETBAL_CHK
        done
}

#EndLabel & ErrorFuncshion-------------

PROC_ERR()
{
        ${ECHO} "Process_ERROR!"
        ${ECHO} "stop the smtpd, start the postfix"
        STS=1
}

ARG_ERR1()
{
        ${ECHO} "Arguments_ERROR!"
        ${ECHO} "Please specify 5 arguments!"
        ${ECHO} "usage: [TC01-TC20 or SPAM] [NumTime] [HostName] [FromID] [ToID]"
        STS=2
}
ARG_ERR2()
{
        ${ECHO} "Arguments_ERROR!"
        ${ECHO} "Test [TC14-15] does not exist."
        ${ECHO} "usage: [TC01-TC20 or SPAM] [NumTime] [HostName] [FromID] [ToID]"
        STS=3
}

ATTFILE_ERR()
{
        ${ECHO} "There is no ${ATTFILE}"
        STS=4
}

SENT_ERR()
{
        ${ECHO} "Sent ${COUNT}_ERROR!"
        STS=5
}

END_LBL()
{
        if [ ${STS} -eq 0 ];then
                ${ECHO} "*****  ${SHNAME} NORMAL_END `${DATE} +'%Y/%m/%d %H:%M:%S'` *****"
                exit
        else
                ${ECHO} "*****  ${SHNAME} AB_NORMAL_END `${DATE} +'%Y/%m/%d %H:%M:%S'` *****"
                exit
        fi
}


#MAIM----------------------------------

STR_LBL
PROC_CHK
ARG_CHK1
ARG_CHK2
SPAM_CHK
ATTFILE_CHK
MAIL_SENT
END_LBL
