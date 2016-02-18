# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/eselect-php/Attic/eselect-php-0.7.0.ebuild,v 1.3 2013/04/10 13:25:36 olemarkus dead $

EAPI=5

#inherit depend.apache

DESCRIPTION="PHP eselect module"
HOMEPAGE="http://www.gentoo.org"
SRC_URI="http://dev.gentoo.org/~olemarkus/eselect-php/eselect-php-${PV}.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="fpm apache2"

DEPEND=">=app-admin/eselect-1.2.4"

#		!<dev-lang/php-5.3.23-r1:5.3
#		!<dev-lang/php-5.4.13-r1:5.4
#		!<dev-lang/php-5.5.0_beta1-r2:5.5
#		"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

#want_apache

src_install() {
	mv eselect-php-${PV} php.eselect
	insinto /usr/share/eselect/modules/
	doins php.eselect

#	if use apache2 ; then
#		insinto "${APACHE_MODULES_CONFDIR#${EPREFIX}}"
#		newins "${FILESDIR}/70_mod_php5.conf-apache2" \
#			"70_mod_php5.conf"
#	fi

#	if use fpm ; then
#		dodir "/etc/init.d"
#		insinto "/etc/init.d"
#		newinitd "${FILESDIR}/php-fpm.init" "php-fpm"
#	fi
}
