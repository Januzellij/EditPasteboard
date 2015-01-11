ARCHS = armv7 arm64
TARGET = :clang
PACKAGE_VERSION = $(THEOS_PACKAGE_BASE_VERSION)
TWEAK_NAME = EditPasteboard
EditPasteboard_FILES = Listener.m
EditPasteboard_FRAMEWORKS = UIKit
EditPasteboard_CFLAGS = -fobjc-arc
EditPasteboard_LDFLAGS = -lactivator
include theos/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

