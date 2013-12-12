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

arm () {
	echo "dir: arm"
	${git} "${DIR}/patches/arm/0001-deb-pkg-Simplify-architecture-matching-for-cross-bui.patch"
}

atmel_fixes () {
	echo "dir: atmel_fixes"
}

atmel_SAMA5D3 () {
	echo "pulling linux-3.10-at91"
	git pull ${GIT_OPTS} ${git_patchset} linux-3.10-at91

	#git checkout v3.10 -b tmp
	#git pull --no-edit git://github.com/RobertCNelson/linux.git linux-3.10-at91
	#git pull --no-edit git://github.com/linux4sam/linux-at91.git linux-3.10-at91
	#git rebase 399bfeeb75f5417754b4008a95292b590772d572

	#git format-patch -1 | grep 'ARM-at91-add-LUT-entry-to-at91sam9g45-resources.patch' ; rm -rf *.patch
	#0001-ARM-at91-add-LUT-entry-to-at91sam9g45-resources.patch
	#git format-patch -0 -o /opt/github/armv7_devel/patches/atmel_SAMA5/
	#git checkout master -f ; git branch -D tmp

	echo "dir: atmel_SAMA5D3"
}

arm
atmel_fixes
atmel_SAMA5D3

echo "patch.sh ran successful"
