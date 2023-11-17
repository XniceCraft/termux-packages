TERMUX_PKG_HOMEPAGE=https://libcxx.llvm.org/
TERMUX_PKG_DESCRIPTION="C++ Standard Library"
TERMUX_PKG_LICENSE="NCSA"
TERMUX_PKG_MAINTAINER="@termux"
# Version should be equal to TERMUX_NDK_{VERSION_NUM,REVISION} in
# scripts/properties.sh
TERMUX_PKG_VERSION=21e
TERMUX_PKG_SRCURL=https://dl.google.com/android/repository/android-ndk-r${TERMUX_PKG_VERSION}-linux-x86_64.zip
TERMUX_PKG_SHA256=ad7ce5467e18d40050dc51b8e7affc3e635c85bd8c59be62de32352328ed467e
TERMUX_PKG_ESSENTIAL=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_make_install() {
	$TERMUX_ELF_CLEANER --api-level=$TERMUX_PKG_API_LEVEL toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/"${TERMUX_HOST_PLATFORM}"/libc++_shared.so
	install -m700 -t "$TERMUX_PREFIX"/lib \
		toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/"${TERMUX_HOST_PLATFORM}"/libc++_shared.so
	ln -sf libc++_shared.so "$TERMUX_PREFIX"/lib/libc++.so
}
