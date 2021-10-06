# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

inherit eutils
DESCRIPTION="a daemon for transparent IP (Layer 3) proxy ARP bridging"

HOMEPAGE="http://www.hazard.maks.net/parprouted/"

SRC_URI="http://sources.buildroot.net/parprouted/parprouted-0.7.tar.gz"

LICENSE="GPL"

SLOT="0"

KEYWORDS="x86 amd64"

DEPEND="net-firewall/iptables"

RDEPEND="${DEPEND}"

S="${WORKDIR}/parprouted-0.7"

src_compile() {
	emake all || die
}
src_install() {
	dobin parprouted || die
}

