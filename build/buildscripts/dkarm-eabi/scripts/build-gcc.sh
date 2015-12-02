#!/bin/sh
#---------------------------------------------------------------------------------

#---------------------------------------------------------------------------------
# build and install binutils
#---------------------------------------------------------------------------------

mkdir -p $target/binutils
cd $target/binutils

##
if [ ! -f configured-binutils ]
then
	#CFLAGS=$cflags LDFLAGS=$ldflags 
	CFLAGS="$cflags --sysroot=$NDK_TOOLCHAIN/android-15/sysroot" CPPFLAGS="$cflags --sysroot=$NDK_TOOLCHAIN/android-15/sysroot" CXXFLAGS="$cflags --sysroot=$NDK_TOOLCHAIN/android-15/sysroot" LDFLAGS="$ldflags --sysroot=$NDK_TOOLCHAIN/android-15/sysroot" CFLAGS_FOR_TARGET="-O2" CXXFLAGS_FOR_TARGET="-O2" LDFLAGS_FOR_TARGET="" \
	../../binutils-$BINUTILS_VER/configure \
    --prefix=$prefix --target=$target --disable-nls --disable-dependency-tracking --disable-werror \
	--enable-lto --enable-plugins --enable-poison-system-directories \
	$CROSS_PARAMS \
        || { echo "Error configuring binutils"; exit 1; }
	touch configured-binutils
fi

if [ ! -f built-binutils ]
then
  $MAKE || { echo "Error building binutils"; exit 1; }
  touch built-binutils
fi

if [ ! -f installed-binutils ]
then
  $MAKE install || { echo "Error installing binutils"; exit 1; }
  touch installed-binutils
fi
cd $BUILDDIR

#---------------------------------------------------------------------------------
# build and install just the c compiler
#---------------------------------------------------------------------------------
mkdir -p $target/gcc
cd $target/gcc
NDK_TOOLCHAIN='G:/android/android-toolchain-arm'

if [ ! -f configured-gcc ]
then
	CFLAGS="$cflags --sysroot=$NDK_TOOLCHAIN/android-15/sysroot" CPPFLAGS="$cflags --sysroot=$NDK_TOOLCHAIN/android-15/sysroot" CXXFLAGS="$cflags --sysroot=$NDK_TOOLCHAIN/android-15/sysroot" LDFLAGS="$ldflags --sysroot=$NDK_TOOLCHAIN/android-15/sysroot" CFLAGS_FOR_TARGET="-O2" CXXFLAGS_FOR_TARGET="-O2" LDFLAGS_FOR_TARGET="" ../../gcc-$GCC_VER/configure \
		--host=arm-linux-androideabi\
		--enable-languages=c,c++\
		--with-gnu-as --with-gnu-ld --with-gcc \
		--with-march=armv4t\
		--enable-poison-system-directories \
		--enable-interwork --enable-multilib \
		--disable-dependency-tracking \
		--enable-threads --disable-win32-registry --disable-nls --disable-debug\
		--disable-libmudflap --disable-libssp --disable-libgomp \
		--disable-libstdcxx-pch \
		--target=$target \
		--with-newlib \
		--with-headers=../../newlib-$NEWLIB_VER/newlib/libc/include \
		--prefix=$prefix \
		--enable-lto $plugin_ld\
		--with-bugurl="http://wiki.devkitpro.org/index.php/Bug_Reports" --with-pkgversion="devkitARM release 44" \
		$CROSS_PARAMS \
		|| { echo "Error configuring gcc"; exit 1; }
	touch configured-gcc
fi

if [ ! -f built-gcc ]
then
	$MAKE all-gcc || { echo "Error building gcc stage1"; exit 1; }
	touch built-gcc
fi

if [ ! -f installed-gcc ]
then
	$MAKE install-gcc || { echo "Error installing gcc"; exit 1; }
	touch installed-gcc
fi


unset CFLAGS
cd $BUILDDIR


##编译newlib?
##从devkitARM复制过来
#---------------------------------------------------------------------------------
# build and install newlib
#---------------------------------------------------------------------------------
mkdir -p $target/newlib
cd $target/newlib

if [ ! -f configured-newlib ]
then
	../../newlib-$NEWLIB_VER/configure \
	--disable-newlib-supplied-syscalls \
	--enable-newlib-mb \
	--target=$target \
	--prefix=$prefix \
	|| { echo "Error configuring newlib"; exit 1; }
	touch configured-newlib
fi

if [ ! -f built-newlib ]
then
	$MAKE || { echo "Error building newlib"; exit 1; }
	touch built-newlib
fi


if [ ! -f installed-newlib ]
then
	$MAKE install || { echo "Error installing newlib"; exit 1; }
	touch installed-newlib
fi

#---------------------------------------------------------------------------------
# build and install the final compiler
#---------------------------------------------------------------------------------

cd $BUILDDIR

cd $target/gcc

if [ ! -f built-stage2 ]
then
	$MAKE all || { echo "Error building gcc stage2"; exit 1; }
	touch built-stage2
fi

if [ ! -f installed-stage2 ]
then
	$MAKE install || { echo "Error installing gcc stage2"; exit 1; }
	touch installed-stage2
fi

rm -fr $prefix/$target/sys-include

cd $BUILDDIR

##删除gdb
#---------------------------------------------------------------------------------
# build and install the debugger
#---------------------------------------------------------------------------------
# mkdir -p $target/gdb
# cd $target/gdb

# PLATFORM=`uname -s`

# if [ ! -f configured-gdb ]
# then
	# CFLAGS="$cflags" LDFLAGS="$ldflags" ../../gdb-$GDB_VER/configure \
	# --disable-nls --prefix=$prefix --target=$target --disable-werror \
	# --disable-dependency-tracking \
	# $CROSS_PARAMS \
	# || { echo "Error configuring gdb"; exit 1; }
	# touch configured-gdb
# fi

# if [ ! -f built-gdb ]
# then
	# $MAKE || { echo "Error building gdb"; exit 1; }
	# touch built-gdb
# fi

# if [ ! -f installed-gdb ]
# then
	# $MAKE install || { echo "Error installing gdb"; exit 1; }
	# touch installed-gdb
# fi

