# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit linux-mod

DESCRIPTION="Realtek 88x2bu module for Linux kernel"
HOMEPAGE="https://github.com/morrownr/88x2bu"

SRC_URI="https://github.com/morrownr/88x2bu/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

DEPEND="virtual/linux-sources"

S="${WORKDIR}/88x2bu-${PV}"

MODULE_NAMES="88x2bu(net/wireless)"
BUILD_TARGETS="all"

src_prepare() {
	default

	VERSION=$(cat /usr/src/linux/Makefile | grep "^VERSION = " | sed 's/VERSION = //')
	PATCHLEVEL=$(cat /usr/src/linux/Makefile | grep "^PATCHLEVEL = " | sed 's/PATCHLEVEL = //')
	SUBLEVEL=$(cat /usr/src/linux/Makefile | grep "^SUBLEVEL = " | sed 's/SUBLEVEL = //')
	EXTRAVERSION=$(cat /usr/src/linux/Makefile | grep "^EXTRAVERSION = " | sed 's/EXTRAVERSION = //')
	KERNEL_VERSION="${VERSION}.${PATCHLEVEL}.${SUBLEVEL}${EXTRAVERSION}"

	sed -i "s/\$(shell uname -r)/$KERNEL_VERSION/g" Makefile

	cd ${S}
	cp ${FILESDIR}/*.h .
	sed -i 's|#include <net/ipx.h>|#include "../ipx.h"|' core/rtw_br_ext.c
}
