#!/bin/sh
#
# Copyright (c) 2009-2014 Robert Nelson <robertcnelson@gmail.com>
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

. ${DIR}/version.sh
if [ -f ${DIR}/system.sh ] ; then
	. ${DIR}/system.sh
fi

git="git am"
#git_patchset=""
#git_opts

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

external_git () {
	git_tag=""
	echo "pulling: ${git_tag}"
	git pull ${git_opts} ${git_patchset} ${git_tag}
}

local_patch () {
	echo "dir: dir"
	${git} "${DIR}/patches/dir/0001-patch.patch"
}

#external_git
#local_patch

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

hlcdc_v3 () {
	echo "dir: hlcdc_v3"
	${git} "${DIR}/patches/hlcdc_v3/0001-mfd-add-atmel-hlcdc-driver.patch"
	${git} "${DIR}/patches/hlcdc_v3/0002-mfd-add-documentation-for-atmel-hlcdc-DT-bindings.patch"
	${git} "${DIR}/patches/hlcdc_v3/0003-pwm-add-support-for-atmel-hlcdc-pwm-device.patch"
	${git} "${DIR}/patches/hlcdc_v3/0004-pwm-add-DT-bindings-documentation-for-atmel-hlcdc-pw.patch"
	${git} "${DIR}/patches/hlcdc_v3/0005-drm-add-Atmel-HLCDC-Display-Controller-support.patch"
	${git} "${DIR}/patches/hlcdc_v3/0006-drm-add-DT-bindings-documentation-for-atmel-hlcdc-dc.patch"
	${git} "${DIR}/patches/hlcdc_v3/0007-ARM-AT91-dt-split-sama5d3-lcd-pin-definitions-to-mat.patch"
	${git} "${DIR}/patches/hlcdc_v3/0008-ARM-AT91-dt-add-alternative-pin-muxing-for-sama5d3-l.patch"
	${git} "${DIR}/patches/hlcdc_v3/0009-ARM-at91-dt-define-the-HLCDC-node-available-on-sama5.patch"
	${git} "${DIR}/patches/hlcdc_v3/0010-ARM-at91-dt-add-LCD-panel-description-to-sama5d3xdm..patch"
	${git} "${DIR}/patches/hlcdc_v3/0011-ARM-at91-dt-enable-the-LCD-panel-on-sama5d3xek-board.patch"
	${git} "${DIR}/patches/hlcdc_v3/0012-drm-atmel_hlcdc_dc.c-drm_irq_install-changed-in-v3.1.patch"
}

enable_spidev () {
	#debian@arm:~$ ls /dev/spi*
	#/dev/spidev32766.0
	echo "dir: examples"
	${git} "${DIR}/patches/examples/0001-sama5-spidev-example.patch"
}

#hlcdc
hlcdc_v3
#enable_spidev

packaging_setup () {
	cp -v "${DIR}/3rdparty/packaging/builddeb" "${DIR}/KERNEL/scripts/package"
	git commit -a -m 'packaging: sync with mainline' -s

	git format-patch -1 -o "${DIR}/patches/packaging"
}

packaging () {
	echo "dir: packaging"
	${git} "${DIR}/patches/packaging/0001-packaging-sync-with-mainline.patch"
	${git} "${DIR}/patches/packaging/0002-deb-pkg-install-dtbs-in-linux-image-package.patch"
	#${git} "${DIR}/patches/packaging/0003-deb-pkg-no-dtbs_install.patch"
}

#packaging_setup
#packaging
echo "patch.sh ran successful"
