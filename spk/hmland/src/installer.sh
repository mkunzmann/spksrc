#!/bin/sh

# Package
PACKAGE="hmland"
DNAME="hmland"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PATH="${INSTALL_DIR}/bin:${PATH}"
CFG_FILE="${INSTALL_DIR}/etc/${PACKAGE}"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"
USER="${PACKAGE}"
GROUP="users"

SERVICETOOL="/usr/syno/bin/servicetool"
FWPORTS="/var/packages/${PACKAGE}/scripts/${PACKAGE}.sc"

SYNO_GROUP="sc-utilities"
SYNO_GROUP_DESC="SynoCommunity's utilities related group"

syno_group_create ()
{
    # Create syno group (Does nothing when group already exists)
    synogroup --add ${SYNO_GROUP} ${USER} > /dev/null
    # Set description of the syno group
    synogroup --descset ${SYNO_GROUP} "${SYNO_GROUP_DESC}"

    # Add user to syno group (Does nothing when user already in the group)
    addgroup ${USER} ${SYNO_GROUP}
}

syno_group_remove ()
{
    # Remove user from syno group
    delgroup ${USER} ${SYNO_GROUP}

    # Check if syno group is empty
    if ! synogroup --get ${SYNO_GROUP} | grep -q "0:"; then
        # Remove syno group
        synogroup --del ${SYNO_GROUP} > /dev/null
    fi
}

preinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        #if [ ! -d "${wizard_download_dir}" ]; then
        #    echo "Download directory ${wizard_download_dir} does not exist."
        #    exit 1
        #fi
        #if [ -n "${wizard_watch_dir}" -a ! -d "${wizard_watch_dir}" ]; then
        #    echo "Watch directory ${wizard_watch_dir} does not exist."
        #    exit 1
        #fi
        #if [ -n "${wizard_incomplete_dir}" -a ! -d "${wizard_incomplete_dir}" ]; then
        #    echo "Incomplete directory ${wizard_incomplete_dir} does not exist."
        #    exit 1
        #fi
        echo "noop"
    fi

    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Install busybox stuff
    ${INSTALL_DIR}/bin/busybox --install ${INSTALL_DIR}/bin

    #Create var
    mkdir ${INSTALL_DIR}/var

    # Create user
    adduser -h ${INSTALL_DIR}/var -g "${DNAME} User" -G ${GROUP} -s /bin/sh -S -D ${USER}

    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        # Edit the configuration according to the wizard
        echo "PORT=${wizard_port}" > ${CFG_FILE}
        # sed -i -e "s|@download_dir@|${wizard_download_dir:=/volume1/downloads}|g" ${CFG_FILE}
        # sed -i -e "s|@username@|${wizard_username:=admin}|g" ${CFG_FILE}
        # sed -i -e "s|@password@|${wizard_password:=admin}|g" ${CFG_FILE}
        echo "noop"
    fi

    syno_group_create

    # Correct the files ownership
    chown -R ${USER}:root ${SYNOPKG_PKGDEST}

    # Add firewall config
    ${SERVICETOOL} --install-configure-file --package ${FWPORTS} >> /dev/null

    exit 0
}

preuninst ()
{
    # Stop the package
    ${SSS} stop > /dev/null

    # Remove the user (if not upgrading)
    if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ]; then
        syno_group_remove

        delgroup ${USER} ${GROUP}
        deluser ${USER}
    fi

    # Remove firewall config
    if [ "${SYNOPKG_PKG_STATUS}" == "UNINSTALL" ]; then
        ${SERVICETOOL} --remove-configure-file --package ${PACKAGE}.sc >> /dev/null
    fi

    exit 0
}

postuninst ()
{
    # Remove link
    rm -f ${INSTALL_DIR}

    exit 0
}

preupgrade ()
{
    # Stop the package
    ${SSS} stop > /dev/null

    # Save some stuff
    rm -fr ${TMP_DIR}/${PACKAGE}
    mkdir -p ${TMP_DIR}/${PACKAGE}
    mv ${INSTALL_DIR}/var ${TMP_DIR}/${PACKAGE}/

    exit 0
}

postupgrade ()
{
    # Restore some stuff
    rm -fr ${INSTALL_DIR}/var
    mv ${TMP_DIR}/${PACKAGE}/var ${INSTALL_DIR}/
    rm -fr ${TMP_DIR}/${PACKAGE}

    exit 0
}
