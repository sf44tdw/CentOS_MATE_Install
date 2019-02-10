#!/bin/bash
LOGFILE_DATEPART=`date "+%Y%m%d_%H%M%S"`
LOGFILE_NAME="mate_install.${LOGFILE_DATEPART}.log"
LOGFILE_PATH="${HOME}/${LOGFILE_NAME}"
chmod 700 mate_backend.sh
./mate_backend.sh 2>&1 | tee "${LOGFILE_PATH}"
echo  >> "${LOGFILE_PATH}"
echo "RETURN CODE = ${?}" >> "${LOGFILE_PATH}"
