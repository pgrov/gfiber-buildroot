BCM_APPS_SITE=repo://vendor/broadcom/AppLibs
BCM_APPS_DEPENDENCIES=linux bcm_bseav bcm_nexus
BCM_APPS_CONFIGURE_CMDS=ln -sf $(@D) $(BUILD_DIR)/AppLibs
BCM_APPS_POST_EXTRACT_HOOKS=BCM_REMOVE_PATCH_REJECTS
BCM_APPS_INSTALL_STAGING=YES
BCM_APPS_INSTALL_TARGET=YES

define BCM_REMOVE_PATCH_REJECTS
	find $(@D) -name '*.rej' -exec rm \{\} \;
endef

BCM_APPS_APPLIB_TARGETS=$(BCM_OBJS-y)

BCM_OBJS-$(BR2_PACKAGE_BCM_APP_REFSW)       += refsw
BCM_OBJS-$(BR2_PACKAGE_BCM_APP_AVAHI)       += avahi
BCM_OBJS-$(BR2_PACKAGE_BCM_APP_OSAPI)       += osapi
BCM_OBJS-$(BR2_PACKAGE_BCM_APP_NETAPP)      += netapp
BCM_OBJS-$(BR2_PACKAGE_BCM_APP_DLNA)        += dlna
BCM_OBJS-$(BR2_PACKAGE_BCM_APP_DVB)         += dvb
BCM_OBJS-$(BR2_PACKAGE_BCM_APP_DIRECTFB)    += directfb

ifeq ($(BR2_PACKAGE_BCM_APP_DIRECTFB),y)
BCM_APPS_DEPENDENCIES += bcm_rockford libpng jpeg zlib freetype
endif

BCM_OBJS-$(BR2_PACKAGE_BCM_APP_STAGECRAFT)  += stagecraft
BCM_OBJS-$(BR2_PACKAGE_BCM_APP_ARGO)        += argo
BCM_OBJS-$(BR2_PACKAGE_BCM_APP_COVERFLOW3D) += coverflow3d
BCM_OBJS-$(BR2_PACKAGE_BCM_APP_BMC)         += bmc
BCM_OBJS-$(BR2_PACKAGE_BCM_APP_BROWSER)     += browser
BCM_OBJS-$(BR2_PACKAGE_BCM_APP_GSTREAMER)   += gstreamer
BCM_OBJS-$(BR2_PACKAGE_BCM_APP_ALSA)        += alsa
BCM_OBJS-$(BR2_PACKAGE_BCM_APP_PLAYBACK_IP) += playback_ip
BCM_OBJS-$(BR2_PACKAGE_BCM_APP_DTCP_IP)     += dtcp_ip
BCM_OBJS-$(BR2_PACKAGE_BCM_APP_QT)          += qt
BCM_OBJS-$(BR2_PACKAGE_BCM_APP_LIBCURL)     += libcurl
BCM_OBJS-$(BR2_PACKAGE_BCM_APP_SQLITE)      += sqlite
BCM_OBJS-$(BR2_PACKAGE_BCM_APP_LIBXML2)     += libxml2
BCM_OBJS-$(BR2_PACKAGE_BCM_APP_PIXMAN)      += pixman
BCM_OBJS-$(BR2_PACKAGE_BCM_APP_LIBXSLT)     += libxslt
BCM_OBJS-$(BR2_PACKAGE_BCM_APP_FONTCONFIG)  += fontconfig
BCM_OBJS-$(BR2_PACKAGE_BCM_APP_CAIRO)       += cairo
BCM_OBJS-$(BR2_PACKAGE_BCM_APP_ICU)         += icu
BCM_OBJS-$(BR2_PACKAGE_BCM_APP_ZLIB)        += zlib
BCM_OBJS-$(BR2_PACKAGE_BCM_APP_LIBPNG)      += libpng
BCM_OBJS-$(BR2_PACKAGE_BCM_APP_JPEG)        += jpeg

include package/bcm_common/bcm_common.mk

ifeq (y,$(BR2_PACKAGE_BCM_APP_NETFLIX))
BCM_APPS_APPLIB_TARGETS += directfb
BCM_APPS_DEPENDENCIES += openssl expat curl
endif

define BCM_APPS_BUILD_APPS
	$(BCM_MAKE_ENV) $(MAKE1) $(BCM_MAKEFLAGS) -C $(@D)/common $(BCM_APPS_APPLIB_TARGETS)
endef

ifeq ($(BR2_PACKAGE_BCM_APP_NETFLIX),y)
define BCM_APPS_BUILD_NETFLIX
	$(BCM_MAKE_ENV) NEXUS=$(BCM_NEXUS_DIR) $(MAKE1) $(NETFLIX_MAKEFLAGS) -C $(@D)/thirdparty/netflix/3.x all
endef
endif

define BCM_APPS_BUILD_CMDS
	$(BCM_APPS_BUILD_APPS)
	$(BCM_APPS_BUILD_NETFLIX)
endef

define BCM_APPS_INSTALL_TARGET_CMDS
	$(BCM_MAKE_ENV) $(MAKE1) $(BCM_MAKEFLAGS) -C $(@D)/common bundle
	$(TAR) -xf $(@D)/target/97425*.mipsel-linux*release.*tgz -C $(TARGET_DIR)
endef

define BCM_APPS_INSTALL_STAGING_CMDS
	$(BCM_MAKE_ENV) $(MAKE1) $(BCM_MAKEFLAGS) -C $(@D)/common bundle
	$(TAR) -xf $(@D)/target/97425*.mipsel-linux*release.*tgz -C $(STAGING_DIR)
endef

$(eval $(call GENTARGETS,package,bcm_apps))
