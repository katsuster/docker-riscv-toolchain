#!/bin/sh

if test "x${1}" = "x"; then
	echo "Please specify *.deb file"
	exit 1
fi
if test "x${2}" = "x"; then
	echo "Please specify target arch name (ex. riscv64-unknown-elf)"
	exit 1
fi

set -ex

DEB=${1}
TARGET=${2}
TARBALL=`echo ${DEB} | sed -e 's/_amd64\.deb$/.tar.gz/g'`
DIR_TMP=__tmptmp

echo "DEB:    ${DEB}"
echo "TARGET: ${TARGET}"

rm -rf ${DIR_TMP}
mkdir -p ${DIR_TMP}

cp ${DEB} ${DIR_TMP}
cd ${DIR_TMP}
ar x ${DEB}
if [ -f data.tar.xz ]; then
	tar xf data.tar.xz
elif [ -f data.tar.zst ]; then
	tar xf data.tar.zst
fi
mv opt/riscv ${TARGET}
tar cf ${TARBALL} ${TARGET}
mv ${TARBALL} ../
cd ../

rm -rf ${DIR_TMP}
