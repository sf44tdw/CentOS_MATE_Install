#!/bin/bash
LOGFILE_DATEPART=`date "+%Y%m%d_%H%M%S"`"
LOGFILE_NAME="mate_install.${LOGFILE_DATEPART}"
chmod 700 mate_backend.sh
./mate_backend.sh 2>&1 | tee "${LOGFILE_NAME}"
echo  >> "${LOGFILE_NAME}"
echo "RETURN CODE = ${?}" >> "${LOGFILE_NAME}"
