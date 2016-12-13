#############################################################
#
# tcpdump
#
#############################################################
# Copyright (C) 2001-2003 by Erik Andersen <andersen@codepoet.org>
# Copyright (C) 2002 by Tim Riker <Tim@Rikers.org>

TCPDUMP_VERSION = 4.6.2
TCPDUMP_SITE = http://www.tcpdump.org/release
TCPDUMP_SOURCE = tcpdump-$(TCPDUMP_VERSION).tar.gz
TCPDUMP_CONF_ENV = ac_cv_linux_vers=2 cross_compiling=y td_cv_buggygetaddrinfo=cross
TCPDUMP_CONF_OPT = --without-crypto \
		   --enable-ipv6 \
		   $(if $(BR2_PACKAGE_TCPDUMP_SMB),--enable-smb,--disable-smb)

TCPDUMP_DEPENDENCIES = zlib libpcap

# make install installs an unneeded extra copy of the tcpdump binary
define TCPDUMP_REMOVE_DUPLICATED_BINARY
	rm -f $(TARGET_DIR)/usr/sbin/tcpdump.$(TCPDUMP_VERSION)
endef

TCPDUMP_POST_INSTALL_TARGET_HOOKS += TCPDUMP_REMOVE_DUPLICATED_BINARY

$(eval $(call AUTOTARGETS))
