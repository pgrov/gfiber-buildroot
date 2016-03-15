#############################################################
#
# iproute2
#
#############################################################

IPROUTE2_VERSION = v3.16.0
IPROUTE2_SITE = git://git.kernel.org/pub/scm/linux/kernel/git/shemminger/iproute2.git
IPROUTE2_TARGET_SBINS = ctstat genl ifstat ip lnstat nstat routef routel rtacct rtmon rtpr rtstat ss tc

# If both iproute2 and busybox are selected, make certain we win
# the fight over who gets to have their utils actually installed.
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
IPROUTE2_DEPENDENCIES += busybox
endif

# If we've got iptables enable xtables support for tc
ifeq ($(BR2_PACKAGE_IPTABLES),y)
IPROUTE2_DEPENDENCIES += iptables
endif

define IPROUTE2_CONFIGURE_CMDS
	cd $(@D) && CC="$(TARGET_CC)" CCOPTS="$(TARGET_CFLAGS) -D_GNU_SOURCE" ./configure
endef

define IPROUTE2_BUILD_CMDS
	# arpd needs berkeleydb
	$(SED) "/^TARGETS=/s: arpd : :" $(IPROUTE2_DIR)/misc/Makefile
	$(SED) 's/$$(CCOPTS)//' $(@D)/netem/Makefile
	$(MAKE) CC="$(TARGET_CC)" CCOPTS="$(TARGET_CFLAGS) -D_GNU_SOURCE" -C $(@D)
endef

define IPROUTE2_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) DESTDIR="$(TARGET_DIR)" SBINDIR=/sbin \
		DOCDIR=/usr/share/doc/iproute2-$(IPROUTE2_VERSION) \
		MANDIR=/usr/share/man install
	# Wants bash
	rm -f $(TARGET_DIR)/sbin/ifcfg
endef

define IPROUTE2_UNINSTALL_TARGET_CMDS
	rm -rf $(TARGET_DIR)/lib/tc
	rm -rf $(TARGET_DIR)/usr/lib/tc
	rm -rf $(TARGET_DIR)/etc/iproute2
	rm -rf $(TARGET_DIR)/var/lib/arpd
	rm -f $(addprefix $(TARGET_DIR)/sbin/, $(IPROUTE2_TARGET_SBINS))
endef

$(eval $(call GENTARGETS))
