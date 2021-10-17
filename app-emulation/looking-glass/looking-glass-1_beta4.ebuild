# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="LookingGlass"
MY_PV="B4"
MY_P="${MY_PN}-${MY_PV}"

CMAKE_MAKEFILE_GENERATOR=emake

inherit cmake git-r3

EGIT_COMMIT="2973319bff80bf1531265bdbec6707bdda3f40eb"

DESCRIPTION="A low latency KVM FrameRelay implementation for guests with VGA PCI Passthrough"
HOMEPAGE="https://looking-glass.hostfission.com https://github.com/gnif/LookingGlass/"
EGIT_REPO_URI="https://github.com/gnif/${MY_PN}"

EGIT_SUBMODULES=( '*' )

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug winhost"

RDEPEND="dev-libs/libconfig:0=
	dev-libs/nettle:=[gmp]
	media-libs/freetype:2
	media-libs/fontconfig:1.0
	media-libs/libsdl2
	media-libs/sdl2-ttf
	virtual/glu"
DEPEND="${RDEPEND}
	app-emulation/spice-protocol"
BDEPEND="virtual/pkgconfig
	winhost? ( cross-x86_64-w64-mingw32/gcc )"

S="${WORKDIR}/looking-glass-1_beta4"

src_prepare() {
	default

	CMAKE_USE_DIR="${S}"/client
	# Respect FLAGS
	sed -i -e '/CMAKE_C_FLAGS/s/-O3 -march=native //' \
		-e "/git/s/git describe --always --long --dirty --abbrev=10 --tags/echo ${MY_PV}/" \
		client/CMakeLists.txt || die "sed failed for FLAGS and COMMAND"

	if ! use debug ; then
		sed -i '/CMAKE_C_FLAGS/s/-g //' \
		client/CMakeLists.txt || die "sed failed for debug"
	fi
	cmake_src_prepare

	if use winhost; then
		CMAKE_USE_DIR="${S}"/host
		# Respect FLAGS
		sed -i -e '/CMAKE_C_FLAGS/s/-O3 -march=native //' \
			-e "/git/s/git describe --always --long --dirty --abbrev=10 --tags/echo ${MY_PV}/" \
			host/CMakeLists.txt || die "sed failed for FLAGS and COMMAND"

		if ! use debug ; then
			sed -i '/CMAKE_C_FLAGS/s/-g //' \
			host/CMakeLists.txt || die "sed failed for debug"
		fi
		cmake_src_prepare
	fi
}

src_configure() {
	CLIENT_DIR="${S}"/client
	CLIENT_BUILD_DIR=${WORKDIR}/${P}_build_client

	mkdir -p ${CLIENT_BUILD_DIR}
	cd ${CLIENT_BUILD_DIR}
	cmake ${CLIENT_DIR}

	if use winhost; then
		HOST_DIR="${S}"/host
		HOST_BUILD_DIR=${WORKDIR}/${P}_build_host

		mkdir -p ${HOST_BUILD_DIR}
		cd ${HOST_BUILD_DIR}
		cmake  -DCMAKE_TOOLCHAIN_FILE="${CMAKE_USE_DIR}"/toolchain-mingw64.cmake ${HOST_DIR}
	fi
}

src_compile() {
	cd ${CLIENT_BUILD_DIR}
	cmake --build .

	if use winhost; then
		cd ${HOST_BUILD_DIR}
		cmake --build .
	fi
}

src_install() {
	einstalldocs

	dobin "${CLIENT_BUILD_DIR}"/looking-glass-client

        if use winhost ; then
                insinto /usr/share/"${PN}"
                doins "${HOST_BUILD_DIR}"/looking-glass-host.exe
        fi
}
