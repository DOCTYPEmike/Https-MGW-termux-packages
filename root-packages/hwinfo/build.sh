TERMUX_PKG_HOMEPAGE=https://github.com/openSUSE/hwinfo
TERMUX_PKG_DESCRIPTION="Hardware detection tool from openSUSE"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=21.74
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/openSUSE/hwinfo/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=e826865af657c4966c37c8e915499dc148ff6df4879d3d86f71885defee8335c
TERMUX_PKG_DEPENDS="libandroid-shmem, libuuid, libx86emu"
TERMUX_PKG_BREAKS="hwinfo-dev"
TERMUX_PKG_REPLACES="hwinfo-dev"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	sed -i -E '/^SUBDIRS\s*=/d' Makefile
	echo -e '\n$(LIBHD):\n\t$(MAKE) -C src' >> Makefile
	echo -e '\t$(CC) -shared $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) \' >> Makefile
	echo -e '\t\t-Wl,--whole-archive $(LIBHD) -Wl,--no-whole-archive \' >> Makefile
	echo -e '\t\t-Wl,-soname=$(LIBHD_SONAME) -o $(LIBHD_SO) $(SO_LIBS)' >> Makefile
}

termux_step_configure() {
	echo 'touch changelog' > git2log
	LDFLAGS+=" -landroid-shmem"
        export HWINFO_VERSION="$TERMUX_PKG_VERSION"
}
