#############################################################
#
# libjsoncpp
#
#############################################################

LIBJSONCPP_VERSION = 0.6.0-rc2
LIBJSONCPP_SOURCE = jsoncpp-src-$(LIBJSONCPP_VERSION).tar.gz
LIBJSONCPP_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/project/jsoncpp/jsoncpp/$(LIBJSONCPP_VERSION)
LIBJSONCPP_DIR = $(BUILD_DIR)/libjsoncpp-$(LIBJSONCPP_VERSION)
LIBJSONCPP_INSTALL_STAGING = YES
LIBJSONCPP_AUTORECONF = YES
HOST_LIBJSONCPP_INSTALL_STAGING = YES
HOST_LIBJSONCPP_AUTORECONF = YES

define LIBJSONCPP_FIX_INCLUDE_PATH
	ln -s $(LIBJSONCPP_DIR)/include/jsoncpp/json $(LIBJSONCPP_DIR)/src/lib_json
endef

define HOST_LIBJSONCPP_FIX_INCLUDE_PATH
	ln -s $(HOST_LIBJSONCPP_DIR)/include/jsoncpp/json $(HOST_LIBJSONCPP_DIR)/src/lib_json
endef

LIBJSONCPP_POST_PATCH_HOOKS += LIBJSONCPP_FIX_INCLUDE_PATH
HOST_LIBJSONCPP_POST_PATCH_HOOKS += HOST_LIBJSONCPP_FIX_INCLUDE_PATH

$(eval $(call AUTOTARGETS))
$(eval $(call AUTOTARGETS,host))

