# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Universal configuration library parser"
HOMEPAGE="https://github.com/vstakhov/libucl"

SRC_URI="https://github.com/vstakhov/libucl/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

LICENSE="BSD-2"
SLOT="0"

IUSE="lua +regex sign urls +utils"

DEPEND="!!dev-libs/ucl
	lua? ( >=dev-lang/lua-5.1:= )
	urls? ( net-misc/curl )
	sign? ( dev-libs/openssl:0 )
"
BDEPEND="${DEPEND}
	virtual/pkgconfig
"
RDEPEND="${DEPEND}"

DOCS=( README.md doc/api.md )

src_prepare() {
	eapply_user
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		"$(use_enable lua)"
		"$(use_enable regex)"
		"$(use_enable sign signatures)"
		"$(use_enable urls)"
		"$(use_enable utils)"
	)
	econf "${myeconfargs}"
}

src_install() {
	default
	use lua && DOCS+=( doc/lua_api.md )
	einstalldocs
	# no .a's it seems
	use static || find "${ED}" -name "*.la" -delete
}
