#!/bin/bash
cd $BUILDDIR

for archive in $hostarchives
do
	dir=$(echo $archive | sed -e 's/\(.*\)\.tar\.bz2/\1/' )
	cd $BUILDDIR/$dir
	if [ ! -f configured ]; then
		CXXFLAGS='--sysroot=G:/android/android-toolchain-arm/android-15/sysroot -O2' CFLAGS='--sysroot=G:/android/android-toolchain-arm/android-15/sysroot -O2' LDFLAGS=$ldflags ./configure --prefix=$prefix --disable-dependency-tracking \
			$CROSS_PARAMS || { echo "error configuring $archive"; exit 1; }
		touch configured
	fi
	if [ ! -f built ]; then
		$MAKE || { echo "error building $dir"; exit 1; }
		touch built
	fi
	if [ ! -f installed ]; then
		$MAKE install || { echo "error installing $dir"; exit 1; }
		touch installed
	fi
done
