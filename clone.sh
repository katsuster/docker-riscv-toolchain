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

check_env VER_BINUTILS
check_env VER_GDB
check_env VER_GCC
check_env VER_LINUX
check_env VER_NEWLIB
check_env VER_GLIBC
check_env VER_MUSL

check_env REPO_URL

cd /

git clone --depth 1 --branch riscv-binutils-${VER_BINUTILS} \
	${REPO_URL}/${DIR_BINUTILS}
git clone --depth 1 --branch riscv-gcc-${VER_GCC} \
	${REPO_URL}/${DIR_GCC}
git clone --depth 1 --branch riscv-linux-headers-${VER_LINUX} \
	${REPO_URL}/${DIR_LINUX}
git clone --depth 1 --branch riscv-newlib-${VER_NEWLIB} \
	${REPO_URL}/${DIR_NEWLIB}
git clone --depth 1 --branch riscv-glibc-${VER_GLIBC} \
	${REPO_URL}/${DIR_GLIBC}
git clone --depth 1 --branch riscv-musl-${VER_MUSL} \
	${REPO_URL}/${DIR_MUSL}

mkdir ${DIR_RESULT}
