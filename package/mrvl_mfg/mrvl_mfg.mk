MRVL_MFG_SITE=repo://vendor/marvell/manufacturing
MRVL_MFG_INSTALL_TARGET=YES
MRVL_MFG_DEPENDENCIES=linux

MRVL_MFG_MAKE_ENV = \
	$(TARGET_MAKE_ENV) \
	$(LINUX_MAKE_FLAGS) \
	KLIB_BUILD=$(LINUX_DIR) \
	KLIB=$(TARGET_DIR)

define MRVL_MFG_BUILD_CMDS
	$(MRVL_MFG_MAKE_ENV) $(MAKE) -C $(LINUX_DIR) M=$(@D)/ZOMG/wlan_src
endef

$(eval $(call GENTARGETS))
