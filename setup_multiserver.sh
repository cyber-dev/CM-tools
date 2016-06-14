#!/bin/bash
NAS_DIR="
/webmail/agent
/webmail/etc
/webmail/folder_bak
/webmail/httpd/data/filedownload
/webmail/mqueue/res
/webmail/mqueue/stat
/webmail/public
/webmail/sessions
/webmail/tmp /webmail/usr
"

setupMultiserver(){
RC=`df -h | grep /mnt/storage > /dev/null ; echo $?`
if [ ${RC} -eq 0 ]; then
  for SHARE_DIR in ${NAS_DIR}
  do
    LINK_DIR_NAME=`echo ${SHARE_DIR} | awk -F/ '{print $NF}'`
    if [ ! -L ${SHARE_DIR} -a -d ${SHARE_DIR} -a ! -e /mnt/storage/${LINK_DIR_NAME} ] ; then
      mv -bf ${SHARE_DIR} /mnt/storage/
      wait
      sudo -u webmail ln -s /mnt/storage/${LINK_DIR_NAME} ${SHARE_DIR}
    elif [ ! -L ${SHARE_DIR} -a -d ${SHARE_DIR} -a -e /mnt/storage/${LINK_DIR_NAME} ]; then
      if [ ! -e /mnt/storage/00_old/${HOST} ]; then
        sudo -u webmail mkdir -p /mnt/storage/00_old/${HOST}
        wait
      fi
      mv -bf ${SHARE_DIR} /mnt/storage/00_old/${HOST}/
      wait
      sudo -u webmail ln -s /mnt/storage/${LINK_DIR_NAME} ${SHARE_DIR}
    elif [ ! -e ${SHARE_DIR} -a -e /mnt/storage/${LINK_DIR_NAME} ]; then
      sudo -u webmail ln -s /mnt/storage/${LINK_DIR_NAME} ${SHARE_DIR}
    fi
  done
fi
}

setupMultiserver
