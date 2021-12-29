# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="A ibrary to allow GLib based applications access to snapd"
HOMEPAGE="https://github.com/snapcore/snapd-glib"
LICENSE="LGPL-3"

SRC_URI="https://github.com/snapcore/snapd-glib/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

IUSE="doc +qt"

DEPEND="
	doc? ( dev-util/gtk-doc )
	qt? ( dev-qt/qtcore dev-qt/qtgui )
"

SLOT="0"

src_configure() {
	local emesonargs=(
		-Ddocs=$(usex doc true false)
		-Dqt-bindings=$(usex qt true false)
		-Dqml-bindings=$(usex qt true false)
		-Dvala-bindings=false
	)
        meson_src_configure
}
