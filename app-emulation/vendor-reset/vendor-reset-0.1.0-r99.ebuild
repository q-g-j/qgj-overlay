# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-mod

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/gnif/vendor-reset.git"
	EGIT_BRANCH="master"
	inherit git-r3
else
	KEYWORDS="~amd64"
	SRC_URI="https://github.com/gnif/vendor-reset/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="Linux kernel vendor specific hardware reset module"
HOMEPAGE="https://github.com/gnif/vendor-reset"
LICENSE="GPL-2"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/Fix-5.11-build.patch" )

pkg_setup() {
	local CONFIG_CHECK="FTRACE KPROBES PCI_QUIRKS KALLSYMS FUNCTION_TRACER"
	linux-mod_pkg_setup
}

src_prepare() {
        default
	VERSION=$(cat /usr/src/linux/Makefile | grep "^VERSION = " | sed 's/VERSION = //')
	PATCHLEVEL=$(cat /usr/src/linux/Makefile | grep "^PATCHLEVEL = " | sed 's/PATCHLEVEL = //')
	SUBLEVEL=$(cat /usr/src/linux/Makefile | grep "^SUBLEVEL = " | sed 's/SUBLEVEL = //')
	EXTRAVERSION=$(cat /usr/src/linux/Makefile | grep "^EXTRAVERSION = " | sed 's/EXTRAVERSION = //')
	KERNEL_VERSION="${VERSION}.${PATCHLEVEL}.${SUBLEVEL}${EXTRAVERSION}"
	sed -i "s/\$(shell uname -r)/$KERNEL_VERSION/" Makefile
}

src_compile() {
	set_arch_to_kernel
	emake \
		DESTDIR="${ED}" \
		INSTALL_MOD_PATH="${ED}"
}

src_install() {
	set_arch_to_kernel
	emake \
		DESTDIR="${ED}" \
		INSTALL_MOD_PATH="${ED}" \
		install

	insinto /etc/modules-load.d/
	newins "${FILESDIR}"/modload.conf vendor-reset.conf
}
