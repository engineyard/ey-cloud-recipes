# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI=4
DESCRIPTION="Agent providing a command line utility for a convenient access to
the logentries.com logging infrastructure."
HOMEPAGE="https://logentries.com/"
PYTHON_COMPAT=( python{2_7,3_2} )

inherit eutils distutils-r1

AUTHOR=logentries

SRC_URI="https://github.com/logentries/le/tarball/v${PV} -> $P.tar.gz"
REVISION="b4cb54d"
S="${WORKDIR}/logentries-le-${REVISION}"
BUILD_DIR="${S}"
KEYWORDS="x86 amd64 mips ~ppc ~ppc-macos -ia64"
USE=""
DEPEND="dev-lang/python
    dev-python/simplejson
    app-crypt/gnupg
	dev-python/setuptools
	dev-python/python-exec"
RDEPEND="dev-python/python-exec"
LICENSE="GPL-2"
SLOT="0"
src_unpack() {
    unpack  ${A}
}

src_compile() {
	distutils-r1_python_compile
}
src_install() {
	    esetup.py install --compile -O2 --root=/var/tmp/portage/dev-util/le-1.4.25/image/
}
