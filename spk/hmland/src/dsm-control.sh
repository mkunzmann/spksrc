#!/bin/sh

# Package
PACKAGE="hmland"
DNAME="hmland"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PYTHON_DIR="/usr/local/python"
PATH="${INSTALL_DIR}/bin:${PYTHON_DIR}/bin:${PATH}"
USER="${PACKAGE}"
HMLAND="${INSTALL_DIR}/bin/${PACKAGE}"
PID_FILE="${INSTALL_DIR}/${PACKAGE}.pid"
#LOGFILE="${INSTALL_DIR}/var/${PACKAGE}.log"

. ${INSTALL_DIR}/etc/${PACKAGE}

start_daemon ()
{
    su - ${USER} -c "PATH=${PATH} ${HMLAND} -p ${PORT} -d -L ${LOGFILE}"
    echo "$(pidof ${PACKAGE})" > ${PID_FILE}
}

stop_daemon ()
{
    kill `cat ${PID_FILE}`
    wait_for_status 1 20 || kill -9 `cat ${PID_FILE}`
    rm -f ${PID_FILE}
}

daemon_status ()
{
    if [ -f ${PID_FILE} ] && kill -0 `cat ${PID_FILE}` > /dev/null 2>&1; then
        return
    fi
    rm -f ${PID_FILE}
    return 1
}

wait_for_status ()
{
    counter=$2
    while [ ${counter} -gt 0 ]; do
        daemon_status
        [ $? -eq $1 ] && return
        let counter=counter-1
        sleep 1
    done
    return 1
}

log() {
    echo "${LOGFILE}"
    exit 0
}


case $1 in
    start)
        if daemon_status; then
            echo ${DNAME} is already running
            exit 0
        else
            echo Starting ${DNAME} ...
            start_daemon
            exit $?
        fi
        ;;
    stop)
        if daemon_status; then
            echo Stopping ${DNAME} ...
            stop_daemon
            exit $?
        else
            echo ${DNAME} is not running
            exit 0
        fi
        ;;
    restart)
        stop_daemon
        start_daemon
        exit $?
        ;;
    status)
        if daemon_status; then
            echo ${DNAME} is running
            exit 0
        else
            echo ${DNAME} is not running
            exit 1
        fi
        ;;
    log)
        log
        ;;
    *)
        exit 1
        ;;
esac
