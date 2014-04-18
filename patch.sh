#!/bin/sh
#
# Copyright (c) 2009-2013 Robert Nelson <robertcnelson@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# Split out, so build_kernel.sh and build_deb.sh can share..

git="git am"

git_patchset="git://github.com/RobertCNelson/linux.git"
if [ -f ${DIR}/system.sh ] ; then
	. ${DIR}/system.sh
	if [ "${GIT_OVER_HTTP}" ] ; then
		git_patchset="https://github.com/RobertCNelson/linux.git"
	fi
fi

if [ "${RUN_BISECT}" ] ; then
	git="git apply"
fi

echo "Starting patch.sh"

git_add () {
	git add .
	git commit -a -m 'testing patchset'
}

start_cleanup () {
	git="git am --whitespace=fix"
}

cleanup () {
	if [ "${number}" ] ; then
		git format-patch -${number} -o ${DIR}/patches/
	fi
	exit
}

fixes () {
	echo "dir: fixes"
#	${git} "${DIR}/patches/fixes/0001-Revert-ARM-at91-fix-network-interface-ordering-for-s.patch"
}

atmel_SAMA5D3 () {
	echo "dir: atmel_SAMA5D3"
}

drm () {
	echo "dir: drm"
	${git} "${DIR}/patches/drm/0001-atmel-drm-added-drm-driver-for-the-atmel-hlcd-contro.patch"
	${git} "${DIR}/patches/drm/0002-atmel-drm-dt-Added-DT-entry-for-the-atmel-hlcdc-foun.patch"
	${git} "${DIR}/patches/drm/0003-atmel-dt-Add-supports-for-the-lcdc-support-on-the-sa.patch"
	${git} "${DIR}/patches/drm/0004-atmel-drm-crtc-fb-crtc-primary-fb.patch"
	${git} "${DIR}/patches/drm/0005-atmel-dt-Add-supports-for-the-lcdc-support-on-the-sa.patch"
}

enable_spidev () {
	#debian@arm:~$ ls /dev/spi*
	#/dev/spidev32766.0
	echo "dir: examples"
	${git} "${DIR}/patches/examples/0001-sama5-spidev-example.patch"
}

fixes
atmel_SAMA5D3
drm

#enable_spidev

echo "patch.sh ran successful"
