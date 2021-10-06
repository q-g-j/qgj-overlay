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
	if [ "$(basename -a `readlink -f /usr/src/linux` | grep -e "-rt[0-9]*$")" != "" ]; then
	        KERNEL_VERSION=$(basename -a `readlink -f /usr/src/linux` | sed s/linux-// | sed 's/\([0-9\.]-\)/\1rt-/')
	else
	        KERNEL_VERSION=$(basename -a `readlink -f /usr/src/linux` | sed s/linux-//)
	fi
	echo
	echo $KERNEL_VERSION
	echo

	sed -i "s/\$(shell uname -r)/$KERNEL_VERSION/g" Makefile
}
