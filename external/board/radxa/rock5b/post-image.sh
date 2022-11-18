#!/bin/sh
########################################################################
#
# Description : post-image script
#
# Authors     : Vitaliy Nimych
#
# Version     : 001
#
# Notes       : TODO: need to make check execution status 'mkimage'
#
########################################################################

RKBIN=${BR2_EXTERNAL_RK3588_PATH}/rkbin
RKCHIP_LOADER=$2
RKCHIP=$2

echo $(pwd)
echo "BR2_EXTERNAL_RK3588_PATH: ${BR2_EXTERNAL_RK3588_PATH}"

# copy uboot variable file over
echo "copy uboot variable file over"
cp -a ${BR2_EXTERNAL_RK3588_PATH}/board/radxa/rock5b/vars.txt ${BINARIES_DIR}/


# copy overlays over
linuxDir=`find ${BASE_DIR}/build -name 'vmlinux' -type f | xargs dirname`
mkdir -p ${BINARIES_DIR}/rockchip/overlays
if [ -d ${linuxDir}/arch/arm64/boot/dts/rockchip/overlay ]; then
  cp -a ${linuxDir}/arch/arm64/boot/dts/rockchip/overlay/*.dtbo ${BINARIES_DIR}/rockchip/overlays
fi

ubootName=`find ${BASE_DIR}/build -name 'uboot-*' -type d`
boardDir=`dirname $_`

currentDir=`pwd`

# echo creating uboot.img
# echo "cd uboot: ${ubootName}"

# cd ${ubootName}; ./make.sh;

# cd ${currentDir}
# cp ${ubootName}/uboot.img ${BINARIES_DIR}/u-boot.itb

# to take rockchip-bsp's boot loaders, rather then generating our own ...
echo creating idbloader.img
${ubootName}/tools/mkimage -n rk3588 -T rksd -d ${RKBIN}/bin/rk35/rk3588_ddr_lp4_2112MHz_lp5_2736MHz_v1.08.bin:$ubootName/spl/u-boot-spl.bin ${BINARIES_DIR}/idbloader.img

# Generate the uboot script
echo creating boot.scr
echo "BR2_EXTERNAL_RK3588_PATH: ${BR2_EXTERNAL_RK3588_PATH}"
${ubootName}/tools/mkimage -C none -A arm -T script -n 'flatmax load script' -d ${BR2_EXTERNAL_RK3588_PATH}/board/radxa/rock5b/boot.cmd ${BINARIES_DIR}/boot.scr
#
# #make the trust image
# echo creating trust.img
# ${boardDir}/mkRK3588Trust.sh ${BINARIES_DIR} ${RKBIN} trust.img

# Put the device trees into the correct location
mkdir -p ${BINARIES_DIR}/rockchip; cp -a ${BINARIES_DIR}/*.dtb ${BINARIES_DIR}/rockchip
${BASE_DIR}/../support/scripts/genimage.sh -c ${BR2_EXTERNAL_RK3588_PATH}/board/radxa/rock5b/genimage.cfg

echo
echo
echo compilation done
echo
echo
