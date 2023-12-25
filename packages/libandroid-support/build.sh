TERMUX_PKG_HOMEPAGE=https://github.com/termux/libandroid-support
TERMUX_PKG_DESCRIPTION="Library extending the Android C library (Bionic) for additional multibyte, locale and math support"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_VERSION=(31
		    3)
#TERMUX_PKG_REVISION=3
TERMUX_PKG_LICENSE_FILE="LICENSE.txt, wcwidth-${TERMUX_PKG_VERSION[1]}/LICENSE.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_SRCURL=(https://github.com/XniceCraft/libandroid-support/archive/refs/tags/v${TERMUX_PKG_VERSION[0]}.tar.gz
		   https://github.com/termux/wcwidth/archive/v${TERMUX_PKG_VERSION[1]}.tar.gz)
TERMUX_PKG_SHA256=(0f3691ceae15c89cd68ec961ef69d129c617acd0741c8fec3d5b7a97b42cdff2
		   d38062a53edb2545b9988be41bd8d217f803fa985158b7cadf95d804761dd1f6)
TERMUX_PKG_ESSENTIAL=true
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_PROVIDES="libutil"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DENABLE_LIBC=ON
-DENABLE_LIBM=ON
-D__ANDROID_API__=$TERMUX_PKG_API_LEVEL
"

termux_step_post_get_source() {
	cp wcwidth-${TERMUX_PKG_VERSION[1]}/wcwidth.c src/
}
