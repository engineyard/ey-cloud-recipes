# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libpcre/libpcre-8.32.ebuild,v 1.4 2014/04/29 19:28:59 vapier Exp $

EAPI="4"

inherit eutils multilib libtool flag-o-matic toolchain-funcs

DESCRIPTION="Perl-compatible regular expression library"
HOMEPAGE="http://www.pcre.org/"
MY_P="pcre-${PV/_rc/-RC}"
if [[ ${PV} != *_rc* ]] ; then
	# Only the final releases are available here.
	SRC_URI="mirror://sourceforge/pcre/${MY_P}.tar.bz2
		ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/${MY_P}.tar.bz2"
else
	SRC_URI="ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/Testing/${MY_P}.tar.bz2"
fi

LICENSE="BSD"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~x86-interix ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="bzip2 +cxx +jit libedit pcre16 +readline +recursion-limit static-libs unicode zlib"
REQUIRED_USE="readline? ( !libedit )
	libedit? ( !readline )"

RDEPEND="bzip2? ( app-arch/bzip2 )
	zlib? ( sys-libs/zlib )
	libedit? ( dev-libs/libedit )
	readline? ( sys-libs/readline )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	userland_GNU? ( >=sys-apps/findutils-4.4.0 )"

S=${WORKDIR}/${MY_P}

src_prepare() {
	local pc
	for pc in *.pc.in ; do
		echo "Libs.private: @PTHREAD_CFLAGS@" >> ${pc} #454478
	done
	sed -i -e "s:-lpcre ::" libpcrecpp.pc.in || die
	elibtoolize
}

src_configure() {
	econf \
		--with-match-limit-recursion=$(usex recursion-limit 8192 MATCH_LIMIT) \
		$(use_enable bzip2 pcregrep-libbz2) \
		$(use_enable cxx cpp) \
		$(use_enable jit) $(use_enable jit pcregrep-jit) \
		$(use_enable pcre16) \
		$(use_enable libedit pcretest-libedit) \
		$(use_enable readline pcretest-libreadline) \
		$(use_enable static-libs static) \
		$(use_enable unicode utf) $(use_enable unicode unicode-properties) \
		$(use_enable zlib pcregrep-libz) \
		--enable-pcre8 \
		--enable-shared \
		--htmldir="${EPREFIX}"/usr/share/doc/${PF}/html \
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
}

src_install() {
	emake DESTDIR="${D}" install
	gen_usr_ldscript -a pcre
	prune_libtool_files
}

pkg_preinst() {
	preserve_old_lib /$(get_libdir)/libpcre.so.0
}

pkg_postinst() {
	preserve_old_lib_notify /$(get_libdir)/libpcre.so.0
}
