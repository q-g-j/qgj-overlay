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

	KERNEL_VERSION=$(cat /usr/src/linux/include/config/kernel.release)

	sed -i "s/\$(shell uname -r)/$KERNEL_VERSION/g" Makefile

	cd ${S}
	cp ${FILESDIR}/*.h .
	sed -i 's|#include <net/ipx.h>|#include "../ipx.h"|' core/rtw_br_ext.c
}
