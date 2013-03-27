#!/bin/bash
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
#git="git am --whitespace=fix"

if [ -f ${DIR}/system.sh ] ; then
	source ${DIR}/system.sh
fi

if [ "${RUN_BISECT}" ] ; then
	git="git apply"
fi

echo "Starting patch.sh"

git_add () {
	git add .
	git commit -a -m 'testing patchset'
}

cleanup () {
	git format-patch -${number} -o ${DIR}/patches/
	exit
}

arm () {
	echo "dir: arm"
	${git} "${DIR}/patches/arm/0001-deb-pkg-Simplify-architecture-matching-for-cross-bui.patch"
}

atmel_fixes () {
	echo "dir: atmel_fixes"
	${git} "${DIR}/patches/atmel_fixes/0001-ARM-at91-move-non-DT-Kconfig-to-Kconfig.non_dt.patch"
	${git} "${DIR}/patches/atmel_fixes/0002-ARM-at91-rename-board-dt-to-more-specific-name-board.patch"
	${git} "${DIR}/patches/atmel_fixes/0003-ARM-at91-renamme-rm9200-dt-file.patch"
}

atmel_SAMA5D3 () {
	echo "dir: atmel_SAMA5D3"
	${git} "${DIR}/patches/atmel_SAMA5D3/0001-ARM-at91-change-name-template-in-AT91_SOC_START-macr.patch"
	${git} "${DIR}/patches/atmel_SAMA5D3/0002-ARM-at91-add-AT91_SAM9_TIME-entry-to-select-at91sam9.patch"
	${git} "${DIR}/patches/atmel_SAMA5D3/0003-ARM-at91-introduce-the-core-type-choice-to-split-ARM.patch"
	${git} "${DIR}/patches/atmel_SAMA5D3/0004-ARM-at91-introduce-SAMA5-support.patch"
	${git} "${DIR}/patches/atmel_SAMA5D3/0005-ARM-at91-dt-add-device-tree-files-for-SAMA5D3-family.patch"
	${git} "${DIR}/patches/atmel_SAMA5D3/0006-ARM-at91-add-defconfig-for-SAMA5.patch"
}

arm
atmel_fixes
atmel_SAMA5D3

echo "patch.sh ran successful"
