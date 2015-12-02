##devkitARM for Android


###Download : http://pan.baidu.com/s/1mgyD2R2

###android需要做的装备
	1.手机已经root
	2.安装busybox或c4droid
	3.终端模拟器(Android Terminal Emulator)
	4.root explorer 
	
###终端模拟器(Android Terminal Emulator)
	busybox把工具安装在/system/xbin/
	利用root explorer把/devkitpro复制到/system/xbin/
	把c4droid的make复制到/system/xbin
	打开终端模拟器，执行
		export DEVKITPRO=/system/xbin/devkitpro
		export DEVKITARM=$DEVKITPRO/devkitARM
		export PATH=$DEVKITARM/bin:$PATH
	查看版本
		arm-none-eabi-gcc -v
	跳转到gba例子执行
		cd <gba-examples>/graphics/ansi_console
		make

###c4droid
	busybox把工具安装在/system/xbin/
	利用root explorer把/devkitpro复制到/system/xbin/
	c4droid设置中改变
		"自动运行命令"
		删除    export CC ...
		删除    export CXX ...
		删除    export CFLAGS,CXXFLAGS ....
		结尾添加 
			export DEVKITPRO=/system/xbin/devkitpro
			export DEVKITARM=$DEVKITPRO/devkitARM
			export PATH=$DEVKITARM/bin:$PATH 
			su
	c4droiad 菜单“终端模拟器”
		make
	 
###下载GBA模拟器运行
	