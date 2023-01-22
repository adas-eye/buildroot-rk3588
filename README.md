# buildroot-rk3588

This repository is for Buildroot build for ROCK 5B based on RK3588 CPU [Official product page radxa](https://wiki.radxa.com/Rock5) <br>
Since there is no original Buildroot support, this repository has been created to support Buildroot for RK3588 CPU

Based on the latest version of Buildroot 2022.08.x , Rockhip Uboot x.x.x , Rockhip Kernel stable-5.10.x


# Important note
This repository includes submodules (via ssh links) from private repositories, you need to add SSH keys to your GitHub account to build locally on your PC.


### Depends
In order to use Buildroot, you need to have a Linux distribution installed on your workstation. Any reasonably recent Linux distribution (Ubuntu, Debian) will work fine.

Then, you need to install a small set of packages, as described in the [Buildroot manual System requirements section.](https://buildroot.org/downloads/manual/manual.html#requirement)

For Debian/Ubuntu distributions, the following command allows to install the necessary packages:

```bash
# TODO: need to check all depends
$ sudo apt install debianutils sed make binutils build-essential gcc g++ bash patch gzip bzip2 perl tar cpio unzip rsync file bc git
```

### Manual build

Clone thhe repository and pull all submodules:

```bash
# clone repo
git clone git@github.com:Military-Vehicle-Detection/buildroot-rk3588.git

# clone submodule
cd buildroot-rk3588
git submodule init
git submodule update --recursive
```

Configure and build rock5b target:

```bash
cd buildroot
make BR2_EXTERNAL=../external rock5b_defconfig
make -j8

# NOTE: for minimum print log during build run brmake utility 
utils/brmake
```

If the build was successful, you will find `sdcard.img` in the output/image folder which is ready to be written to an EMMC or SD card.
If you need full rebuild of target:

```bash
cd buildroot
make BR2_EXTERNAL=../external rock5b_defconfig
make clean all
make -j8
```

### Auto build

You can use "autobuild.sh" script with:

```bash
-n        normal target build
-f        full target rebuild
```

### Configure buildoot

```bash
cd buildroot
make menuconfig

# after select new packages for build need start new build
make -j8
```

### Configure linux kernel 

```bash
cd buildroot
make linux-menuconfig

# after select new packages for build need start new build
# for full rebuild linux make command: make linux-build
make -j8
```


## How to flash image (SD Card)
Insert your sd card into your drive and check dev name by "lsblk" command.
Example of "lsblk" usage:

```bash
sda      8:0    0 931,5G  0 disk
├─sda1   8:1    0   549M  0 part
├─sda2   8:2    0 419,5G  0 part /media/mykyta/589AA01A9A9FF32C
├─sda3   8:3    0   513M  0 part /boot/efi
├─sda4   8:4    0     1K  0 part
└─sda5   8:5    0   511G  0 part /var/snap/firefox/common/host-hunspell
                                 /
sdb      8:16   0 238,5G  0 disk
├─sdb1   8:17   0   499M  0 part
├─sdb2   8:18   0   100M  0 part
├─sdb3   8:19   0    16M  0 part
├─sdb4   8:20   0 237,2G  0 part /media/mykyta/EE10EF5D10EF2B73
└─sdb5   8:21   0   677M  0 part
sdc      8:32   0 447,1G  0 disk
└─sdc1   8:33   0 447,1G  0 part /media/mykyta/5EB1A59E171C5DF6
sdd      8:48   0 953,9G  0 disk
└─sdd1   8:49   0 953,9G  0 part /media/mykyta/external_ssd
```

Make sure sd card isn't mounted. Write the "sdcard.img" image to the disk.
In the command line execute:

```bash
cd buildroot
sudo dd if=output/images/sdcard.img of=/dev/sdx
```

Remember that the mounting point "/dev/sdx" of your SD card may be different on your distribution.
Once done, plug the SD Card into the Rock 5B and power the card. You will see the bootloader running normally
and you will be presented to login screen where the default user is root, no password needed.

## How to use SDK

You can download SDK for developing SW from jobs GitHub Actions or build SDK locally:

1. Download SDK from CI/CD

![alt text](https://github.com/Military-Vehicle-Detection/buildroot-rk3588/blob/bsp/doc/images/ScreenShot%202022-11-20%20%D0%B2%2014.01.39.png)

2. Unpack file to local folder, example `/opt/sdk`

```bash
# NOTE: for unpack to /opt folder need root access
cd ~/Downloads
sudo tar -xvf aarch64-buildroot-linux-gnu_sdk-buildroot.tar.gz -C /opt
```

3. Run relocate script `relocate-sdk.sh`

![alt text](https://github.com/Military-Vehicle-Detection/buildroot-rk3588/raw/bsp/doc/images/sdk.png)

4. Get SDK environment from file `environment-setup`

![alt text](https://github.com/Military-Vehicle-Detection/buildroot-rk3588/raw/bsp/doc/images/env.png)

5. Check SDK environment, compiler, cflags, etc

![alt text](https://github.com/Military-Vehicle-Detection/buildroot-rk3588/raw/bsp/doc/images/gcc.png)

## How to use SDK via IDE: Clion, VSCode, QTcreator, etc

For easy coding, it's better to use IDE.

### Clion

An example of how you can integrate the SDK into the CLion development environment:

1. Install IDE, you can download from https://www.jetbrains.com/clion/
2. Create C or C++ hello-world application
3. Go to settings tab: File->Settings

![alt text](https://github.com/Military-Vehicle-Detection/buildroot-rk3588/raw/bsp/doc/images/clion/1.png)

4. Create new settings for cross-compiler 

![alt text](https://github.com/Military-Vehicle-Detection/buildroot-rk3588/raw/bsp/doc/images/clion/2.png)
![alt text](https://github.com/Military-Vehicle-Detection/buildroot-rk3588/raw/bsp/doc/images/clion/3.png)

5. Change cmake settings: system compiller to cross-compiler 
![alt text](https://github.com/Military-Vehicle-Detection/buildroot-rk3588/raw/bsp/doc/images/clion/4.png)
![alt text](https://github.com/Military-Vehicle-Detection/buildroot-rk3588/raw/bsp/doc/images/clion/5.png)

6. Build hello-world application 

### Qt Creator

An example of how you can integrate the SDK into the CLion development environment:

1. Install IDE, you can download:
 - From official site: https://www.qt.io/download-qt-installer
 - (Ubuntu, Debian) in terminal execute command:
```bash
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install qtcreator 
```

2. Go to settings tab: "Tools" -> "Options":

![alt text](https://github.com/Military-Vehicle-Detection/buildroot-rk3588/raw/update_readme/doc/images/qt_creator/1.png)

3. Go to the section "Devices" of the dialog and "Add" -> "Generic Linux Device":

![alt text](https://github.com/Military-Vehicle-Detection/buildroot-rk3588/raw/update_readme/doc/images/qt_creator/2.png)

4. Go to the section "Kits" and click on the tab "Compilers" and then:
 - on "Add -> GCC" -> "C" and configure:

![alt text](https://github.com/Military-Vehicle-Detection/buildroot-rk3588/raw/update_readme/doc/images/qt_creator/3.png)

 - on "Add -> GCC" -> "C++" and configure:
 
![alt text](https://github.com/Military-Vehicle-Detection/buildroot-rk3588/raw/update_readme/doc/images/qt_creator/4.png)

5. Click on the tab "Debuggers" and click on "Add" and configure:

![alt text](https://github.com/Military-Vehicle-Detection/buildroot-rk3588/raw/update_readme/doc/images/qt_creator/5.png)

6. Click on the tab "Qt Versions" and click on "Add" and configure:

![alt text](https://github.com/Military-Vehicle-Detection/buildroot-rk3588/raw/update_readme/doc/images/qt_creator/6.png)

7. Click on the tab "Kits" and click on "Add" and configure:

![alt text](https://github.com/Military-Vehicle-Detection/buildroot-rk3588/raw/update_readme/doc/images/qt_creator/7.png)

To configure "Environment" click on "Change...":

![alt text](https://github.com/Military-Vehicle-Detection/buildroot-rk3588/raw/update_readme/doc/images/qt_creator/8.png)

And add lines below (from "environment-setup" SDK file):
```bash
AR=aarch64-buildroot-linux-gnu-gcc-ar
AS=aarch64-buildroot-linux-gnu-as
LD=aarch64-buildroot-linux-gnu-ld
NM=aarch64-buildroot-linux-gnu-gcc-nm
CC=aarch64-buildroot-linux-gnu-gcc
GCC=aarch64-buildroot-linux-gnu-gcc
CPP=aarch64-buildroot-linux-gnu-cpp
CXX=aarch64-buildroot-linux-gnu-g++
FC=aarch64-buildroot-linux-gnu-gfortran
F77=aarch64-buildroot-linux-gnu-gfortran
RANLIB=aarch64-buildroot-linux-gnu-gcc-ranlib
READELF=aarch64-buildroot-linux-gnu-readelf
STRIP=aarch64-buildroot-linux-gnu-strip
OBJCOPY=aarch64-buildroot-linux-gnu-objcopy
OBJDUMP=aarch64-buildroot-linux-gnu-objdump
AR_FOR_BUILD=/usr/bin/ar
AS_FOR_BUILD=/usr/bin/as
CC_FOR_BUILD=/usr/bin/gcc
GCC_FOR_BUILD=/usr/bin/gcc
CXX_FOR_BUILD=/usr/bin/g++
LD_FOR_BUILD=/usr/bin/ld
CPPFLAGS_FOR_BUILD=-I$SDK_PATH/include
CFLAGS_FOR_BUILD=-O2 -I$SDK_PATH/include
CXXFLAGS_FOR_BUILD=-O2 -I$SDK_PATH/include
LDFLAGS_FOR_BUILD=-L$SDK_PATH/lib -Wl,-rpath,$SDK_PATH/lib
FCFLAGS_FOR_BUILD=
DEFAULT_ASSEMBLER=aarch64-buildroot-linux-gnu-as
DEFAULT_LINKER=aarch64-buildroot-linux-gnu-ld
CPPFLAGS=-D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
CFLAGS=-D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64  -Os -g0 -D_FORTIFY_SOURCE=1
CXXFLAGS=-D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64  -Os -g0 -D_FORTIFY_SOURCE=1
LDFLAGS=
FCFLAGS= -Os -g0
FFLAGS= -Os -g0
PKG_CONFIG=pkg-config
STAGING_DIR=$SDK_PATH/aarch64-buildroot-linux-gnu/sysroot
INTLTOOL_PERL=/usr/bin/perl
ARCH=arm64
CROSS_COMPILE=aarch64-buildroot-linux-gnu-
CONFIGURE_FLAGS=--target=aarch64-buildroot-linux-gnu --host=aarch64-buildroot-linux-gnu --build=x86_64-pc-linux-gnu --prefix=/usr --exec-prefix=/usr --sysconfdir=/etc --localstatedir=/var --program-prefix=
PATH=$SDK_PATH/bin:$SDK_PATH/sbin:$PATH
KERNELDIR=/home/mykyta/work/buildroot-rk3588/buildroot/output/build/linux-custom/
```

![alt text](https://github.com/Military-Vehicle-Detection/buildroot-rk3588/raw/bsp/doc/images/qt_creator/9.png)

8. Create new "Non-Qt project" -> "Plain C++ Application" and use new "Kit" for current project to build&run.

## How to debug app via gdb and ssh

### Clion: GDB

Full instructions: https://www.jetbrains.com/help/clion/remote-debug.html

1. Go to build configuration and add 
![alt text](https://github.com/Military-Vehicle-Detection/buildroot-rk3588/raw/bsp/doc/images/clion/6.png)

2. Create new Debug/Run configuration, you can change debug folder, environment variable, etc. 

![alt text](https://github.com/Military-Vehicle-Detection/buildroot-rk3588/raw/bsp/doc/images/clion/11.png)

3. Create new SSH credentials for your target

![alt text](https://github.com/Military-Vehicle-Detection/buildroot-rk3588/raw/bsp/doc/images/clion/7.png)

4. Run debug button, enjoy 

### Clion: Upload executions file via SSH

Yuo can uoload executions file via ssh: example command `scp <path_to_file> root@192.x.x.x:<path_to_upload>`

![alt text](https://github.com/Military-Vehicle-Detection/buildroot-rk3588/raw/bsp/doc/images/clion/9.png)

After you connect to the console target via ssh or UART and you can run your application

![alt text](https://github.com/Military-Vehicle-Detection/buildroot-rk3588/raw/bsp/doc/images/clion/10.png)


TODO: need to update for QT creator and VSCode


## How to build C/C++ hello-world app for target

1. If you want to build out of external package app you can CMake to build 
your hello world app. Firts be sure you install this utility (Ubuntu, Debian):
```bash
sudo apt-get install cmake
```

2. In your hello-world app create "CMakeLists.txt" file with content below:
```bash
# Usage example:
# $ mkdir build && cd build && cmake -DTOOLCHAIN_PATH=/opt .. && make

cmake_minimum_required(VERSION 3.5)

project(untitled LANGUAGES C)

set(CMAKE_SYSTEM_NAME Linux )
set(CPU_ENDIAN "little")
set(CMAKE_SYSTEM_PROCESSOR aarch64 )
set(RK3588_TOOLCHAIN "/opt/aarch64-buildroot-linux-gnu_sdk-buildroot/" CACHE STRING ${TOOLCHAIN_PATH})
set(CMAKE_SYSROOT ${RK3588_TOOLCHAIN}/aarch64-buildroot-linux-gnu/sysroot)
set(CMAKE_C_COMPILER ${RK3588_TOOLCHAIN}/usr/bin/aarch64-buildroot-linux-gnu-gcc)
set(CMAKE_CXX_COMPILER ${RK3588_TOOLCHAIN}/usr/bin/aarch64-buildroot-linux-gnu-g++)
set(CMAKE_AR ${RK3588_TOOLCHAIN}/usr/bin/aarch64-buildroot-linux-gnu-ar)
set(CMAKE_STRIP ${RK3588_TOOLCHAIN}/usr/bin/aarch64-buildroot-linux-gnu-strip)
set(TARGET_ARCH LINUX)
# where is the target environment
SET(CMAKE_FIND_ROOT_PATH ${CMAKE_SYSROOT})
# search for programs in the build host directories
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# for libraries and headers in the target directories
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
SET(CMAKE_CXX_FLAGS "-Wno-error=deprecated-declarations")

add_executable(untitled main.c)
```

Also you can find example of CMakeLists.txt with library linking and headers including here:
```bash
buildroot-rk3588/external/app/vision_console/CMakeLists.txt
```
## How to add new packages for build image

Example based on vision_cli&vision_console package:

1. Your package should contain not only sources, but adiitional information for buildroot of 
where source files are located, how to compile and install your app. In our case:

Information about external package used by buildroot (package directory):
```bash
buildroot-rk3588/external/package/vision_cli/
```

Application sources:
```bash
buildroot-rk3588/external/app/vision_console/
```

2. In package directory "vision_cli" you should provide 2 files:

- Config.in file:
For the package to be displayed in the configuration tool,
you need to create a Config file "Config.in" in your package directory.

Example from "vision_cli" package:
```bash
config BR2_PACKAGE_VISION_CLI
	bool "vision_cli"
	depends on BR2_PACKAGE_QT5
	depends on BR2_PACKAGE_OPENCV4
	help
	  Test app for testing and debugging neural network using Rockchip NPU
```

More information about "*.mk" file you can find in buildroot manual:
https://buildroot.org/downloads/manual/manual.html#writing-rules-config-in

- *.mk file:
This file describes how to downloads, configures, compiles and installs the package. 

Example from "vision_cli" package:
```bash
################################################################################
#
# vision app console version
#
################################################################################

VISION_CLI_SITE = $(BR2_EXTERNAL_RK3588_PATH)/app/vision_console
VISION_CLI_SITE_METHOD = local
VISION_CLI_LICENSE = Apache-2.0
VISION_CLI_LICENSE_FILES = LICENSE.md

VISION_CLI_INSTALL_STAGING = YES
VISION_CLI_INSTALL_TARGET = NO

VISION_CLI_DEPENDENCIES = libglib2 host-pkgconf

VISION_CLI_TARGET_INSTALL_DIR = $(TARGET_DIR)

$(eval $(cmake-package))
#$(eval $(host-generic-package))
```
More information about "Config.in" file you can find in buildroot manual:
https://buildroot.org/downloads/manual/manual.html#writing-rules-mk

3. Update "external.mk" and "Config.in" files in the root of buildroot-rk3588:
```bash
buildroot-rk3588/external.mk
buildroot-rk3588/Config.in
```
Those files used to define package recipes or other custom configuration options or make logic.

Example of "vision_cli" package integration:
- In external.mk add line below:
```bash
include $(sort $(wildcard $(BR2_EXTERNAL_RK3588_PATH)/package/vision_cli/*.mk))
```

- In Config.in add lines below:
```bash
menuconfig BR2_PACKAGE_MILITARY
       bool "Military application"

if BR2_PACKAGE_MILITARY        

menu "Test packages"
       source "$BR2_EXTERNAL_RK3588_PATH/package/vision_cli/Config.in"
endmenu

menu "Debug packages"  
# add source here 

endmenu

menu "Relese packages" 
# add source here 

endmenu
endif
```

4. Update defconfig file used for our target ROCK 5B:
```bash
buildroot-rk3588/external/configs/rock5b_defconfig
```

With package information.
Example:
```bash
BR2_PACKAGE_MILITARY=y
BR2_PACKAGE_VISION_CLI=y
```

5. Create new repository for your package and push your changes to it.
After that you can update ".gitmodules" file of "buildroot-rk3588" repository
to add information about new package.
Example:
```bash
[submodule "external/app/vision_console"]
       path = external/app/vision_console
       url = git@github.com:Military-Vehicle-Detection/vision_console.git
```

6. Finally you can run in terminal commands below to update submodules
and build target with new integrated package:
```bash
cd buildroot-rk3588
git submodule init
git submodule update --recursive

cd buildroot
make BR2_EXTERNAL=../external rock5b_defconfig
make -j8
```
