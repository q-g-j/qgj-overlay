# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="LookingGlass"
MY_PV="B2"
MY_P="${MY_PN}-${MY_PV}"

inherit cmake git-r3

EGIT_COMMIT="76710ef20120432a4a9aab1949fde71c0de93781"

DESCRIPTION="A low latency KVM FrameRelay implementation for guests with VGA PCI Passthrough"
HOMEPAGE="https://looking-glass.hostfission.com https://github.com/gnif/LookingGlass/"
EGIT_REPO_URI="https://github.com/gnif/${MY_PN}"

EGIT_SUBMODULES=( '*' )

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="dev-libs/libconfig:0=
	dev-libs/nettle:=[gmp]
	media-libs/freetype:2
	media-libs/fontconfig:1.0
	media-libs/libsdl2
	media-libs/sdl2-ttf
	virtual/glu"
DEPEND="${RDEPEND}
	app-emulation/spice-protocol"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/looking-glass-1_beta2"

CMAKE_USE_DIR="${S}"/client


src_prepare() {
	default
	# Respect FLAGS
	sed -i -e '/CMAKE_C_FLAGS/s/-O3 -march=native //' \
		-e "/git/s/git describe --always --long --dirty --abbrev=10 --tags/echo ${MY_PV}/" \
		client/CMakeLists.txt || die "sed failed for FLAGS and COMMAND"

	if ! use debug ; then
		sed -i '/CMAKE_C_FLAGS/s/-g //' \
		client/CMakeLists.txt || die "sed failed for debug"
	fi

	cmake_src_prepare
}

src_install() {
	einstalldocs

	dobin "${BUILD_DIR}"/looking-glass-client
}
