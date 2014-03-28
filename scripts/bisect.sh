#!/bin/sh -e
#
# Copyright (c) 2012 Robert Nelson <robertcnelson@gmail.com>
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

DIR=$PWD

if [ ! -f ${DIR}/patches/bisect_defconfig ] ; then
	cp ${DIR}/patches/defconfig ${DIR}/patches/bisect_defconfig
fi

cp -v ${DIR}/patches/bisect_defconfig ${DIR}/patches/defconfig

cd ${DIR}/KERNEL/
git bisect start
git bisect good v3.14-rc6
git bisect bad v3.14-rc8
git bisect good 708f04d2abf4e90abee61d9ffb1f165038017ecf
git bisect good c27f0872a3448c46e561e226b5b97f77187b06d2
git bisect bad 774868c7094d35b4518be3d0e654de000a5d11fc
git bisect good 55ae26b7953f0de851559b155800cd3b6f433164
git bisect bad 084c6c5013af3c62f1c344435214496f5ac999f2
git bisect good 08edb33c4e1b810011f21d7705811b7b9a0535f0
git bisect bad f656d46bbb2d3ecdb71c998ccf657dccea8d19a9


git describe
cd ${DIR}/
