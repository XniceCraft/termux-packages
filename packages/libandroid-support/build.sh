TERMUX_PKG_HOMEPAGE=https://github.com/termux/libandroid-support
TERMUX_PKG_DESCRIPTION="Library extending the Android C library (Bionic) for additional multibyte, locale and math support"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_VERSION=(30
		    3)
#TERMUX_PKG_REVISION=3
TERMUX_PKG_LICENSE_FILE="LICENSE.txt, wcwidth-${TERMUX_PKG_VERSION[1]}/LICENSE.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_SRCURL=(https://github.com/XniceCraft/libandroid-support/archive/refs/tags/v${TERMUX_PKG_VERSION[0]}.tar.gz
		   https://github.com/termux/wcwidth/archive/v${TERMUX_PKG_VERSION[1]}.tar.gz)
TERMUX_PKG_SHA256=(9b00d48eb05d41a794a92d71bd92bd79ac6b4dc7d420161439bd8038ddfd842f
		   d38062a53edb2545b9988be41bd8d217f803fa985158b7cadf95d804761dd1f6)
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_ESSENTIAL=true
TERMUX_PKG_AUTO_UPDATE=false

termux_step_post_get_source() {
	cp wcwidth-${TERMUX_PKG_VERSION[1]}/wcwidth.c src/
}

termux_step_make() {
	local c_file
	local cxx_file

	mkdir -p objects
	for c_file in $(find src/musl-ctype src/musl-multibyte -type f -iname \*.c); do
		$CC $CPPFLAGS $CFLAGS -std=c99 -DNULL=0 -fPIC -Iinclude \
			-c $c_file -o ./objects/$(basename "$c_file").o
	done
	if [ $TERMUX_PKG_API_LEVEL -lt 24 ]; then
		for c_file in $(find src/bionic -type f -iname \*.c); do
	                $CC $CPPFLAGS $CFLAGS -fPIC -Iinclude \
	                        -c $c_file -o ./objects/$(basename "$c_file").o
	        done

		for cxx_file in $(find src/bionic -type f -iname \*.cpp); do
			$CXX $CPPFLAGS $CXXFLAGS -std=c++11 -fPIC -Iinclude\
				-c $cxx_file -o ./objects/$(basename "$cxx_file").o
		done
		if [ $TERMUX_PKG_API_LEVEL -lt 23 ] && [ "${TERMUX_ARCH}" == "aarch64" ]; then
			$CXX $CPPFLAGS $CXXFLAGS -c src/bionic/include/arch-arm64/___rt_sigqueueinfo.S -o ___rt_sigqueueinfo.o
		fi
	fi

	cd objects
	ar rcu ../libandroid-support.a *.o
	if [ $TERMUX_PKG_API_LEVEL -lt 24 ]; then
		$CXX $LDFLAGS -l:libc++_static.a -shared -o ../libandroid-support.so *.o
	else
		$CC $LDFLAGS -shared -o ../libandroid-support.so *.o
	fi
}

termux_step_make_install() {
	install -Dm600 libandroid-support.a $TERMUX_PREFIX/lib/libandroid-support.a
	install -Dm600 libandroid-support.so $TERMUX_PREFIX/lib/libandroid-support.so
}
