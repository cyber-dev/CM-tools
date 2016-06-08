#!/bin/bash -x

case ${1} in
      "postfix" ) ps -ef | grep smtpd | grep -v grep  >/dev/null 2>&1
                  RETBAL=$?
                        if [ "${RETBAL}" -eq 0 ];then
                                echo "It will stop [smtpd]....."
                                /webmail/tools/m2kctrl -s smtpd -c stop
                                echo "It will start [postfix]....."
                                service postfix start
                                exit
                        fi

                  ps -ef | grep postfix | grep -v grep  >/dev/null 2>&1
                  RETBAL=$?
                        if [ "${RETBAL}" -ne 0 ];then
                                echo "It will start [postfix]....."
                                service postfix start
                                exit
                        fi;;

        "smtpd" ) ps -ef | grep postfix | grep -v grep >/dev/null 2>&1
                  RETBAL=$?
                        if [ "${RETBAL}" -eq 0 ];then
                                echo "It will stop [postfix]....."
                                service postfix stop
                                echo "It will start [smtpd]....."
                                /webmail/tools/m2kctrl -s smtpd -c start
                        fi

                  ps -ef | grep smtpd | grep -v grep  >/dev/null 2>&1
                  RETBAL=$?
                        if [ "${RETBAL}" -ne 0 ];then
                                echo "It will start [smtpd]....."
                                /webmail/tools/m2kctrl -s smtpd -c start
                                exit
                        fi;;

              * ) echo "usage:[postfix | smtpd]"
                  exit;;
esac
