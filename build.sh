#!/bin/sh

set -ex

. /bin/build_env.sh

check_env DIR_RESULT
check_env DIR_BINUTILS
check_env DIR_GCC
check_env DIR_LINUX
check_env DIR_NEWLIB
check_env DIR_GLIBC
check_env DIR_MUSL

check_env PRE_NEWLIB
check_env PRE_GLIBC
check_env PRE_MUSL

check_env TARGET_NEWLIB
check_env TARGET_GLIBC
check_env TARGET_MUSL

check_env VER_BINUTILS
check_env PKG_BINUTILS
check_env VER_GDB
check_env PKG_GDB
check_env VER_GCC
check_env PKG_GCC
check_env VER_LINUX
check_env PKG_LINUX
check_env VER_NEWLIB
check_env PKG_NEWLIB
check_env VER_GLIBC
check_env PKG_GLIBC
check_env VER_MUSL
check_env PKG_MUSL

build_binutils()
{
	cd /${DIR_BINUTILS}
	mkdir -p .src
	cd .src
	cp -a ../* ./
	./src-release.sh -x binutils
	./src-release.sh -x gdb
	cd ../

	DEBIAN=debian_binutils \
	PROJ=riscv64-binutils \
	PROJ_ORG=binutils \
	VER=${VER_BINUTILS} \
	./pkg_script/ubuntu_package.sh

	DEBIAN=debian_gdb \
	PROJ=riscv64-gdb \
	PROJ_ORG=gdb \
	VER=${VER_GDB} \
	./pkg_script/ubuntu_package.sh

	cd /${DIR_BINUTILS}/pkg_${PKG_TARGET}
	dpkg -i ${PRE_NEWLIB}-binutils_${PKG_BINUTILS}_amd64.deb
	dpkg -i ${PRE_GLIBC}-binutils_${PKG_BINUTILS}_amd64.deb
	dpkg -i ${PRE_MUSL}-binutils_${PKG_BINUTILS}_amd64.deb
	dpkg -i ${PRE_NEWLIB}-gdb_${PKG_GDB}_amd64.deb
	dpkg -i ${PRE_GLIBC}-gdb_${PKG_GDB}_amd64.deb
	dpkg -i ${PRE_MUSL}-gdb_${PKG_GDB}_amd64.deb
	cp ${PRE_NEWLIB}-binutils_${PKG_BINUTILS}_amd64.deb /${DIR_RESULT}/
	cp ${PRE_GLIBC}-binutils_${PKG_BINUTILS}_amd64.deb  /${DIR_RESULT}/
	cp ${PRE_MUSL}-binutils_${PKG_BINUTILS}_amd64.deb   /${DIR_RESULT}/
	cp ${PRE_NEWLIB}-gdb_${PKG_GDB}_amd64.deb /${DIR_RESULT}/
	cp ${PRE_GLIBC}-gdb_${PKG_GDB}_amd64.deb  /${DIR_RESULT}/
	cp ${PRE_MUSL}-gdb_${PKG_GDB}_amd64.deb   /${DIR_RESULT}/
	rm -rf /${DIR_BINUTILS}/pkg_${PKG_TARGET}

	cd /${DIR_RESULT}
	tar_package.sh ${PRE_NEWLIB}-binutils_${PKG_BINUTILS}_amd64.deb ${TARGET_NEWLIB}
	tar_package.sh ${PRE_GLIBC}-binutils_${PKG_BINUTILS}_amd64.deb  ${TARGET_GLIBC}
	tar_package.sh ${PRE_MUSL}-binutils_${PKG_BINUTILS}_amd64.deb   ${TARGET_MUSL}
	tar_package.sh ${PRE_NEWLIB}-gdb_${PKG_GDB}_amd64.deb ${TARGET_NEWLIB}
	tar_package.sh ${PRE_GLIBC}-gdb_${PKG_GDB}_amd64.deb  ${TARGET_GLIBC}
	tar_package.sh ${PRE_MUSL}-gdb_${PKG_GDB}_amd64.deb   ${TARGET_MUSL}
}

build_gcc_stage1()
{
	cd /${DIR_GCC}
	DEBIAN=debian_stage1 \
	PROJ=riscv64-gcc-stage1 \
	VER=${VER_GCC} \
	./pkg_script/ubuntu_package.sh

	cd /${DIR_GCC}/pkg_${PKG_TARGET}
	dpkg -i ${PRE_NEWLIB}-gcc-stage1_${PKG_GCC}_amd64.deb
	dpkg -i ${PRE_GLIBC}-gcc-stage1_${PKG_GCC}_amd64.deb
	dpkg -i ${PRE_MUSL}-gcc-stage1_${PKG_GCC}_amd64.deb
	cp ${PRE_NEWLIB}-gcc-stage1_${PKG_GCC}_amd64.deb /${DIR_RESULT}/
	cp ${PRE_GLIBC}-gcc-stage1_${PKG_GCC}_amd64.deb  /${DIR_RESULT}/
	cp ${PRE_MUSL}-gcc-stage1_${PKG_GCC}_amd64.deb   /${DIR_RESULT}/
	rm -rf /${DIR_GCC}/pkg_${PKG_TARGET}

	cd /${DIR_RESULT}
	tar_package.sh ${PRE_NEWLIB}-gcc-stage1_${PKG_GCC}_amd64.deb ${TARGET_NEWLIB}
	tar_package.sh ${PRE_GLIBC}-gcc-stage1_${PKG_GCC}_amd64.deb  ${TARGET_GLIBC}
	tar_package.sh ${PRE_MUSL}-gcc-stage1_${PKG_GCC}_amd64.deb   ${TARGET_MUSL}
}

build_linux_headers()
{
	cd /${DIR_LINUX}
	DEBIAN=debian_headers \
	PROJ=riscv64-linux-headers \
	VER=${VER_LINUX} \
	./pkg_script/ubuntu_package.sh

	cd /${DIR_LINUX}/pkg_${PKG_TARGET}
	dpkg -i ${PRE_GLIBC}-headers_${PKG_LINUX}_amd64.deb
	dpkg -i ${PRE_MUSL}-headers_${PKG_LINUX}_amd64.deb
	cp ${PRE_GLIBC}-headers_${PKG_LINUX}_amd64.deb  /${DIR_RESULT}/
	cp ${PRE_MUSL}-headers_${PKG_LINUX}_amd64.deb   /${DIR_RESULT}/
	rm -rf /${DIR_LINUX}/pkg_${PKG_TARGET}

	cd /${DIR_RESULT}
	tar_package.sh ${PRE_GLIBC}-headers_${PKG_LINUX}_amd64.deb  ${TARGET_GLIBC}
	tar_package.sh ${PRE_MUSL}-headers_${PKG_LINUX}_amd64.deb   ${TARGET_MUSL}
}

build_newlib()
{
	cd /${DIR_NEWLIB}
	PROJ=riscv64-newlib \
	VER=${VER_NEWLIB} \
	./pkg_script/ubuntu_package.sh

	cd /${DIR_NEWLIB}/pkg_${PKG_TARGET}
	dpkg -i ${PRE_NEWLIB}-newlib_${PKG_NEWLIB}_amd64.deb
	cp ${PRE_NEWLIB}-newlib_${PKG_NEWLIB}_amd64.deb /${DIR_RESULT}/
	rm -rf /${DIR_NEWLIB}/pkg_${PKG_TARGET}

	cd /${DIR_RESULT}
	tar_package.sh ${PRE_NEWLIB}-newlib_${PKG_NEWLIB}_amd64.deb ${TARGET_NEWLIB}
}

build_glibc()
{
	cd /${DIR_GLIBC}
	PROJ=riscv64-glibc \
	VER=${VER_GLIBC} \
	./pkg_script/ubuntu_package.sh

	cd /${DIR_GLIBC}/pkg_${PKG_TARGET}
	dpkg -i ${PRE_GLIBC}_${PKG_GLIBC}_amd64.deb
	cp ${PRE_GLIBC}_${PKG_GLIBC}_amd64.deb /${DIR_RESULT}/
	rm -rf /${DIR_GLIBC}/pkg_${PKG_TARGET}

	cd /${DIR_RESULT}
	tar_package.sh ${PRE_GLIBC}_${PKG_GLIBC}_amd64.deb ${TARGET_GLIBC}
}

build_musl()
{
	cd /${DIR_MUSL}
	PROJ=riscv64-musl \
	VER=${VER_MUSL} \
	./pkg_script/ubuntu_package.sh

	cd /${DIR_MUSL}/pkg_${PKG_TARGET}
	dpkg -i ${PRE_MUSL}_${PKG_MUSL}_amd64.deb
	cp ${PRE_MUSL}_${PKG_MUSL}_amd64.deb /${DIR_RESULT}/
	rm -rf /${DIR_MUSL}/pkg_${PKG_TARGET}

	cd /${DIR_RESULT}
	tar_package.sh ${PRE_MUSL}_${PKG_MUSL}_amd64.deb ${TARGET_MUSL}
}

build_gcc_stage2()
{
	apt-get purge -y \
	${PRE_NEWLIB}-gcc-stage1 \
	${PRE_GLIBC}-gcc-stage1 \
	${PRE_MUSL}-gcc-stage1

	cd /${DIR_GCC}
	DEBIAN=debian_stage2 \
	PROJ=riscv64-gcc \
	VER=${VER_GCC} \
	./pkg_script/ubuntu_package.sh

	cd /${DIR_GCC}/pkg_${PKG_TARGET}
	dpkg -i ${PRE_NEWLIB}-gcc_${PKG_GCC}_amd64.deb
	dpkg -i ${PRE_GLIBC}-gcc_${PKG_GCC}_amd64.deb
	dpkg -i ${PRE_MUSL}-gcc_${PKG_GCC}_amd64.deb
	cp ${PRE_NEWLIB}-gcc_${PKG_GCC}_amd64.deb /${DIR_RESULT}/
	cp ${PRE_GLIBC}-gcc_${PKG_GCC}_amd64.deb  /${DIR_RESULT}/
	cp ${PRE_MUSL}-gcc_${PKG_GCC}_amd64.deb   /${DIR_RESULT}/
	rm -rf /${DIR_GCC}/pkg_${PKG_TARGET}

	cd /${DIR_RESULT}
	tar_package.sh ${PRE_NEWLIB}-gcc_${PKG_GCC}_amd64.deb ${TARGET_NEWLIB}
	tar_package.sh ${PRE_GLIBC}-gcc_${PKG_GCC}_amd64.deb  ${TARGET_GLIBC}
	tar_package.sh ${PRE_MUSL}-gcc_${PKG_GCC}_amd64.deb   ${TARGET_MUSL}
}

build_tarball()
{
	cd /${DIR_RESULT}
	for i in *.tar.gz; do tar xf ${i}; done
	tar cf ${TARGET_NEWLIB}.tar.gz ${TARGET_NEWLIB}
	tar cf ${TARGET_GLIBC}.tar.gz ${TARGET_GLIBC}
	tar cf ${TARGET_MUSL}.tar.gz ${TARGET_MUSL}
	rm -rf ${TARGET_NEWLIB}
	rm -rf ${TARGET_GLIBC}
	rm -rf ${TARGET_MUSL}
}

BUILD_TARGET=${1}

if test "x${BUILD_TARGET}" = "x"; then
	echo "Please specify build target from"
	echo "  binutils, gcc_stage1, gcc_stage2, linux-headers, newlib, glibc, musl"
	exit 1
fi

case ${BUILD_TARGET} in
	binutils)
		build_binutils;;
	gcc_stage1)
		build_gcc_stage1;;
	gcc_stage2)
		build_gcc_stage2;;
	linux-headers)
		build_linux_headers;;
	newlib)
		build_newlib;;
	glibc)
		build_glibc;;
	musl)
		build_musl;;
	tarball)
		build_tarball;;
esac
