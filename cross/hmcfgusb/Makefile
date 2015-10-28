PKG_NAME = hmcfgusb
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_GIT_HASH = 7c54cb5
PKG_DIST_SITE = https://git.zerfleddert.de/git/hmcfgusb
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

DEPENDS = cross/libusb

HOMEPAGE = https://github.com/JSurf/hmcfgusb
COMMENT  =
LICENSE  = MIT

CONFIGURE_TARGET = noop
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myCompile
myCompile:
	$(RUN) $(MAKE)

.PHONY: myInstall
myInstall:
	install -d $(STAGING_INSTALL_PREFIX)/bin/
	install -d $(STAGING_INSTALL_PREFIX)/etc/udev/rules.d/
	install -m 0755 $(WORK_DIR)/$(PKG_DIR)/hmland $(STAGING_INSTALL_PREFIX)/bin/hmland
	install -m 0755 $(WORK_DIR)/$(PKG_DIR)/flash-hmcfgusb $(STAGING_INSTALL_PREFIX)/bin/
	install -m 0755 $(WORK_DIR)/$(PKG_DIR)/flash-ota $(STAGING_INSTALL_PREFIX)/bin/
	install -m 0755 $(WORK_DIR)/$(PKG_DIR)/hmsniff $(STAGING_INSTALL_PREFIX)/bin/
	install -m 0644 $(WORK_DIR)/$(PKG_DIR)/hmcfgusb.rules $(STAGING_INSTALL_PREFIX)/etc/udev/rules.d/
