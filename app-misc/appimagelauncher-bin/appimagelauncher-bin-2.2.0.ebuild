# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg-utils

DESCRIPTION="AppImage desktop integration tool - binary package"
HOMEPAGE="https://github.com/TheAssassin/AppImageLauncher"
SRC_URI="https://github.com/TheAssassin/AppImageLauncher/releases/download/v2.2.0/appimagelauncher_2.2.0-travis995.0f91801.bionic_amd64.deb"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	app-arch/libarchive
	app-arch/zstd
	dev-libs/libgcrypt
	dev-libs/openssl
	dev-qt/qtwidgets:5
	dev-util/gtk-update-icon-cache
	gnome-base/librsvg
	media-libs/freetype
	net-misc/curl
	sys-apps/systemd
	sys-fs/fuse
	x11-libs/libXpm
"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack appimagelauncher_2.2.0-travis995.0f91801.bionic_amd64.deb
	mkdir ${WORKDIR}/appimagelauncher-bin-2.2.0
	cd ${WORKDIR}/appimagelauncher-bin-2.2.0
	unpack ${WORKDIR}/data.tar.xz

	sed -i 's/LXQt/X-LXQt/' usr/share/applications/appimagelaunchersettings.desktop

	echo /opt/appimagelauncher/lib/x86_64-linux-gnu/appimagelauncher > appimagelauncher.conf
}

src_install() {
	exeinto /opt/appimagelauncher/bin
	doexe usr/bin/*

	insinto /usr/share
	doins -r usr/share/applications
	doins -r usr/share/icons
	doins -r usr/share/man
	doins -r usr/share/mime

	insinto /opt/appimagelauncher/share
	doins -r usr/share/appimagelauncher

	insinto /usr/lib
	doins -r usr/lib/systemd
	doins -r usr/lib/binfmt.d

	insinto /opt/appimagelauncher/lib/x86_64-linux-gnu/appimagelauncher
	doins  usr/lib/x86_64-linux-gnu/appimagelauncher/lib*

	exeinto /opt/appimagelauncher/lib/x86_64-linux-gnu/appimagelauncher
	doexe usr/lib/x86_64-linux-gnu/appimagelauncher/binfmt-bypass
	doexe usr/lib/x86_64-linux-gnu/appimagelauncher/update
	doexe usr/lib/x86_64-linux-gnu/appimagelauncher/remove

	insinto /etc/ld.so.conf.d
	doins appimagelauncher.conf

	dosym /opt/appimagelauncher/bin/AppImageLauncher /usr/bin/AppImageLauncher
	dosym /opt/appimagelauncher/bin/AppImageLauncherSettings /usr/bin/AppImageLauncherSettings
	dosym /opt/appimagelauncher/bin/ail-cli /usr/bin/ail-cli
	dosym /opt/appimagelauncher/bin/appimagelauncherd /usr/bin/appimagelauncherd

	dosym /usr/bin/gtk-update-icon-cache /usr/bin/gtk-update-icon-cache-3.0
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update

	echo
	echo
	elog "To enable AppImage file association, reboot or run as root:"
	elog "    systemctl restart systemd-binfmt"
	elog ""
	elog "Run the following command as any user that wants to use AppImageLauncher (not as root):"
	elog "    systemctl --user enable --now appimagelauncherd"
	elog ""
	elog "Usage:"
	elog "Just execute an AppImage file (from terminal or file browser) and the integration"
	elog "assistant window should pop up."
	echo
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
