PRISM_SITE=repo://vendor/google/platform

PRISM_INSTALL_STAGING=YES
PRISM_INSTALL_TARGET=YES
PRISM_INSTALL_IMAGES=YES

PRISM_DEPENDENCIES=python py-setuptools host-py-yaml host-py-mox

define PRISM_BUILD_CMDS
	CC="$(TARGET_CC) $(TARGET_CFLAGS)" \
	$(MAKE) -C $(@D)/cmds && \
	TARGETPYTHONPATH=$(TARGET_PYTHONPATH) \
	HOSTDIR=$(HOST_DIR) \
	$(MAKE) -C $(@D)/sfmodule
endef

define PRISM_TEST_CMDS
	HOSTPYTHONPATH=$(HOST_PYTHONPATH) \
	HOSTDIR=$(HOST_DIR) \
	$(MAKE) -C $(@D)/sfmodule test
endef

define PRISM_INSTALL_TARGET_CMDS
	$(call GENIMAGEVERSION,prism)
	DESTDIR=$(TARGET_DIR) $(MAKE) -C $(@D)/cmds install && \
	TARGETPYTHONPATH=$(TARGET_PYTHONPATH) \
	HOSTDIR=$(HOST_DIR) \
	DESTDIR=$(TARGET_DIR) $(MAKE) -C $(@D)/sfmodule install
endef

$(eval $(call GENTARGETS))
