#!/bin/sh

set -ex

check_env()
{
	_t=`eval "echo \\${\${1}}"`

	if test "x${_t}" = "x"; then
		echo "Please set ${1}"
		exit 1
	fi
}

check_env PKG_TARGET
check_env SECT

export DIR_RESULT=result
export DIR_BINUTILS=binutils-gdb
export DIR_GCC=riscv-gcc
export DIR_LINUX=linux-headers
export DIR_NEWLIB=newlib-cygwin
export DIR_GLIBC=glibc
export DIR_MUSL=musl

export PRE_NEWLIB=riscv64
export PRE_GLIBC=riscv64-linux-glibc
export PRE_MUSL=riscv64-linux-musl
export TARGET_NEWLIB=riscv64-unknown-elf
export TARGET_GLIBC=riscv64-unknown-linux-gnu
export TARGET_MUSL=riscv64-unknown-linux-musl

export VER_BINUTILS=2.39
export PKG_BINUTILS=2.39-1
export VER_GDB=13.0.50.20220805
export PKG_GDB=13.0.50-1
export VER_GCC=12.0.1-rvv
export PKG_GCC=12.0.1-rvv-3
export VER_LINUX=5.10.0
export PKG_LINUX=5.10.0-3
export VER_NEWLIB=4.1.0
export PKG_NEWLIB=4.1.0-1
export VER_GLIBC=2.36
export PKG_GLIBC=2.36-1
export VER_MUSL=1.2.3
export PKG_MUSL=1.2.3-1

export REPO_URL=https://github.com/katsuster
