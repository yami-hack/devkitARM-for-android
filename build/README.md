##构建交叉编译器

###编译环境
####Msys环境
	下载mingw或者msys2，安装，并且设置系统环境

####ndk环境
	我使用的版本是android-ndk-r10d
	1,设置环境变量
		NDK_ROOT=<android-ndk-r10d>
	2.打开"msys2"或者 "cmd ->bash" 
	3.执行
		sh $NDK_ROOT/build/tools/make-standalone-toolchain.sh --ndk-dir=$NDK_ROOT --install-dir=<install-dir>/android-toolchain-arm/android-15 --platform=android-15 --toolchain=arm-linux-androideabi-4.8 --system=windows-x86_64
	4,回车，等待， 时间蛮久的

####编译ndk版本的gmp,mpfr,mpc
	我使用的版本号分别是， gmp-6.0.0, mpfr-3.1.3, mpc-1.0
	用“msys2”或者“cmd ->bash" 跳到跳到gmp源码目录下
	执行
		export TOOLCHAIN_HOME=<install-dir>/android-toolchain-arm/android-15
		export PATH=$TOOLCHAIN_HOME/bin:$PATH
	2.构造配置文件,并且等待，(时间蛮久的)
		./configure --prefix=$TOOLCHAIN_HOME/sysroot/usr --host=arm-linux-androideabi CFLAGS=' --sysroot=<install-dir>/android-toolchain-arm/android-15/sysroot -O2' CPPFLAGS='--sysroot=<install-dir>/android-toolchain-arm/android-15/sysroot -O2' --enable-static --disable-shared
	注：出现错误时查看config.log文件，是缺少什么，或者什么信息
	3.生成，
		make
	注，出现错误时，修改Makefile，
	4,安装，
		make install
	其他mpfr,mpc编译类型gmp，
	注，编译他们的顺序是  gmp > mpfr-> gmp
	
###编译devkitARM
	打开msys2或者cmd >bash
	跳到buildscripts下，执行
		sh build-devkit.sh
		...
		...
	注：源码的安装包可以从devkitpro下载后在放到buildscripts下，这样可以剩下很多时间，也能解决msys2或bash工具的缺少
	构造过程会出现诸如预处理生成失败，或者执行程序生成失败，这是注意构造脚本的
		CFLAGS=' --sysroot=<install-dir>/android-toolchain-arm/android-15/sysroot -O2'
		CXXFLAGS=' --sysroot=<install-dir>/android-toolchain-arm/android-15/sysroot -O2'
		CPPFLAGS='--sysroot=<install-dir>/android-toolchain-arm/android-15/sysroot'
		LDFLAGS='--sysroot=<install-dir>/android-toolchain-arm/android-15/sysroot'
	如果是make失败，用文本编辑器打开那个源码目录的Makefile，查看CFLAGS CXXFLAGS 再查看其他信息
	如果是源码编译失败原因
		包括 strtold 
			(解决方法，在<install-dir>/android-toolchain-arm/android-15/sysroot/include/    的stdlib.h) 添加
				#define strtold(optr,nptr)  (long double)strtod(optr,nptr)
			或者自己实现一个
		typedef __kernel_caddr_t xx..；
			错误，注释这行，编译通过后，会再出现一次失败，在把这行取消注视
		还会出现符号重定义，只要把android-toolchain-arm的错误头文件重定义符号注视了，就可以了
		剩下的错误自己解决
	
	
		
	
	
	