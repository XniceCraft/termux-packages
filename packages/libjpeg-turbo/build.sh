TERMUX_PKG_HOMEPAGE=https://libjpeg-turbo.virtualgl.org
TERMUX_PKG_DESCRIPTION="Library for reading and writing JPEG image files"
TERMUX_PKG_LICENSE="IJG, BSD 3-Clause, ZLIB"
TERMUX_PKG_LICENSE_FILE="README.ijg, LICENSE.md"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.0.1"
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/libjpeg-turbo/${TERMUX_PKG_VERSION}/libjpeg-turbo-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=22429507714ae147b3acacd299e82099fce5d9f456882fc28e252e4579ba2a75
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BREAKS="libjpeg-turbo-dev"
TERMUX_PKG_REPLACES="libjpeg-turbo-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DWITH_JPEG8=1"

termux_step_pre_configure() {
	# SOVERSION suffix is needed for SONAME of shared libs to avoid conflict
	# with system ones (in /system/lib64 or /system/lib):
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DCMAKE_SYSTEM_NAME=Linux"
}

termux_step_post_massage() {
	# Check if SONAME is properly set:
	if ! readelf -d lib/libjpeg.so | grep -q '(SONAME).*\[libjpeg\.so\.'; then
		termux_error_exit "SONAME for libjpeg.so is not properly set."
	fi
}
