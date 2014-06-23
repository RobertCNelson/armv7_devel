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

hlcdc () {
	echo "dir: hlcdc"
	${git} "${DIR}/patches/hlcdc/0001-mfd-add-atmel-hlcdc-driver.patch"
	${git} "${DIR}/patches/hlcdc/0002-pwm-add-support-for-atmel-hlcdc-pwm-device.patch"
	${git} "${DIR}/patches/hlcdc/0003-drm-add-Atmel-HLCDC-Display-Controller-support.patch"
	${git} "${DIR}/patches/hlcdc/0004-ARM-at91-dt-split-sama5d3-lcd-pin-definitions-to-mat.patch"
	${git} "${DIR}/patches/hlcdc/0005-ARM-at91-dt-define-the-HLCDC-node-available-on-sama5.patch"
	${git} "${DIR}/patches/hlcdc/0006-ARM-at91-dt-add-LCD-panel-description-to-sama5d3xdm..patch"
	${git} "${DIR}/patches/hlcdc/0007-ARM-at91-dt-enable-the-LCD-panel-on-sama5d3xek-board.patch"
	${git} "${DIR}/patches/hlcdc/0008-atmel-hlcdc-build-fix.patch"
}

enable_spidev () {
	#debian@arm:~$ ls /dev/spi*
	#/dev/spidev32766.0
	echo "dir: examples"
	${git} "${DIR}/patches/examples/0001-sama5-spidev-example.patch"
}

fixes
atmel_SAMA5D3
hlcdc

#enable_spidev

echo "patch.sh ran successful"
