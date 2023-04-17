# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2020-2023 Roman Stratiienko (r.stratiienko@gmail.com)

$(call inherit-product, glodroid/configuration/common/device-common.mk)

# Audio
$(call inherit-product, glodroid/devices-community/gd_rpi4/audio/device.mk)

# Firmware
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/firmware/brcmfmac43455-sdio.clm_blob:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/brcm/brcmfmac43455-sdio.clm_blob \
    $(LOCAL_PATH)/firmware/brcmfmac43455-sdio.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/brcm/brcmfmac43455-sdio.bin \
    $(LOCAL_PATH)/firmware/brcmfmac43455-sdio.txt:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/brcm/brcmfmac43455-sdio.txt \
    $(LOCAL_PATH)/firmware/brcmfmac43456-sdio.clm_blob:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/brcm/brcmfmac43456-sdio.clm_blob \
    $(LOCAL_PATH)/firmware/brcmfmac43456-sdio.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/brcm/brcmfmac43456-sdio.bin \
    $(LOCAL_PATH)/firmware/brcmfmac43456-sdio.txt:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/brcm/brcmfmac43456-sdio.txt \
    $(LOCAL_PATH)/firmware/LICENCE.broadcom_bcm43xx:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/brcm/LICENCE.broadcom_bcm43xx \
    $(LOCAL_PATH)/firmware/BCM4345C0.hcd:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/brcm/BCM4345C0.hcd \
    $(LOCAL_PATH)/firmware/BCM4345C5.hcd:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/brcm/BCM4345C5.hcd \

# Disable suspend. During running some VTS device suspends, which sometimes causes kernel to crash in WIFI driver and reboot.
PRODUCT_COPY_FILES += \
    glodroid/configuration/common/no_suspend.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/no_suspend.rpi4.rc \

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/etc/power.rpi4.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/power.rpi4.rc \
    $(LOCAL_PATH)/etc/uevent.device.rc:$(TARGET_COPY_OUT_VENDOR)/etc/uevent.device.rc \

# drm_hwcomposer
# RPI4's hardware doesn't have hardware CTM support, while GPU is slow
# to handle the whole composition. Ignore CTM instead.
PRODUCT_VENDOR_PROPERTIES += vendor.hwc.drm.ctm=DRM_OR_IGNORE

# Checked by android.opengl.cts.OpenGlEsVersionTest#testOpenGlEsVersion. Required to run correct set of dEQP tests.
# 196609 == 0x00030001 == GLES v3.1
PRODUCT_VENDOR_PROPERTIES += \
    ro.opengles.version=196609

# Camera
PRODUCT_PACKAGES += ipa_rpi.so ipa_rpi.so.sign

LIBCAMERA_CFGS := $(wildcard glodroid/vendor/libcamera/src/ipa/raspberrypi/data/*json)
PRODUCT_COPY_FILES += $(foreach cfg,$(LIBCAMERA_CFGS),$(cfg):$(TARGET_COPY_OUT_VENDOR)/etc/libcamera/ipa/raspberrypi/$(notdir $(cfg))$(space))

# Codecs
PRODUCT_VENDOR_PROPERTIES += \
    persist.ffmpeg_codec2.v4l2.h264=true \
    persist.ffmpeg_codec2.v4l2.h265=true \
    persist.ffmpeg_codec2.rank.audio=16 \
    persist.ffmpeg_codec2.rank.video=128 \

# Vulkan
PRODUCT_PACKAGES += \
    vulkan.broadcom

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.vulkan.level-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_0_3.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version.xml \
    frameworks/native/data/etc/android.software.vulkan.deqp.level-2022-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.vulkan.deqp.level.xml \

PRODUCT_VENDOR_PROPERTIES +=    \
    ro.hardware.vulkan=broadcom \

# It is the only way to set ro.hwui.use_vulkan=true
#TARGET_USES_VULKAN = true
