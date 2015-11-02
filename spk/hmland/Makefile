SPK_NAME = hmland
SPK_VERS = 0.101
SPK_REV = 3
SPK_ICON = src/hmland.png
DSM_UI_DIR = app

DEPENDS = cross/busybox cross/libusb cross/hmcfgusb

MAINTAINER = SynoCommunity
DESCRIPTION = HMLAND is an application, which emulates the HomeMatic LAN configuration adapter-protocol to make it possible to use the HM-CFG-USB in Fhem or as a lan configuration tool for the CCU or the HomeMatic windows configuration software, also supporting devices using AES-signing like KeyMatic. The HM-CFG-USB can be used to send and receive BidCoS-Packets to control HomeMatic home automation devices like remote controllable sockets, switches, sensors, ...
#DESCRIPTION = HMLAND is an application, which emulates the HomeMatic LAN configuration adapter-protocol
ADMIN_PORT =
RELOAD_UI =
DISPLAY_NAME = hmland
CHANGELOG = "Make log dir configurable"

HOMEPAGE = http://git.zerfleddert.de/cgi-bin/gitweb.cgi/hmcfgusb
LICENSE  =

WIZARDS_DIR = src/wizard/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = hmland_extra_install

BUSYBOX_CONFIG = usrmng
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: hmland_extra_install
hmland_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 72 ; \
	do \
	    convert $(SPK_ICON) -thumbnail $${size}x$${size} \
	            $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
