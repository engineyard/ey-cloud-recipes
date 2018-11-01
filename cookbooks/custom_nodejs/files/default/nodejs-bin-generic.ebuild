# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit pax-utils versionator

DESCRIPTION="Ebuild for static binary build of nodejs"
HOMEPAGE="http://nodejs.org"
SRC_URI="http://nodejs.org/dist/v${PV}/node-v${PV}-linux-x64.tar.gz"

LICENSE="Apache-1.1 Apache-2.0 BSD BSD-2 MIT"
SLOT="$(get_version_component_range 1-3)"
KEYWORDS="~amd64"
IUSE=""

DEPEND="app-admin/eselect-nodejs"
RDEPEND="${DEPEND}"

S="${WORKDIR}/node-v${PV}-linux-x64"
INSTALL_DIR="/opt/nodejs/${PV}"

src_install() {

        # Installation of node modules
        # doins is not used here since it uses a very
        # basic install command which doen't keep binary permissions
        # mkdir is needed as copy doesn't directly deal with the
        # various ebuild helper functions
        mkdir -p "${D}/${INSTALL_DIR}"
        cp -a "${S}/lib" "${D}/${INSTALL_DIR}/"

        # Install of node header files with symlinks from
        # source node ebuild
        insinto ${INSTALL_DIR}/include
        doins -r include/node

        dodir ${INSTALL_DIR}/include/node/deps/{v8,uv}
        dosym . ${INSTALL_DIR}/include/node/src
        for var in deps/{uv,v8}/include; do
                dosym ../.. ${INSTALL_DIR}/include/node/${var}
        done

        # Man install
        insinto ${INSTALL_DIR}/
        doins -r share

        # Node needs pax marking
        into ${INSTALL_DIR}/
        pax-mark -m bin/node
        dobin bin/node
        dosym ${INSTALL_DIR}/bin/node ${INSTALL_DIR}/bin/node-waf

        # Symlink for npm + execute permissions
        fperms 0755 ${INSTALL_DIR}/lib/node_modules/npm/bin/npm-cli.js
        dosym ${INSTALL_DIR}/lib/node_modules/npm/bin/npm-cli.js \
                ${INSTALL_DIR}/bin/npm
}