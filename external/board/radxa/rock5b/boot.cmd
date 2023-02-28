echo "set power delivery"
charge
charge_pd

echo "loading boot vars"
setenv load_addr $ramdisk_addr_r
echo "load from: ${devtype} ${devnum} ${load_addr} vars.txt"
load ${devtype} ${devnum} ${load_addr} vars.txt
env import -t ${load_addr} ${filesize}

echo "Setting boot args"
if test ${devnum} = "1"; then 
	setenv mmc_type 0
elif test ${devnum} = "0"; then 
	setenv mmc_type 1
else  echo "Failed detect mmc type"
fi
echo "mmc_type: ${mmc_type}"

setenv bootargs "root=/dev/mmcblk${mmc_type}p2 earlyprintk console=ttyS2,115200n8 rw rootwait"
echo "bootargs: ${bootargs}"

fatload mmc ${devnum}:${distro_bootpart} ${fdt_addr_r} ${fdtfile}
fatload mmc ${devnum}:${distro_bootpart} ${kernel_addr_r} Image

# append overlays as required
setenv overlay_error "false"
fdt addr ${fdt_addr_r}
fdt resize 65536
for overlay_file in ${overlays}; do
  echo "loading overlay ${overlay_file}"
	if fatload mmc ${devnum}:${distro_bootpart} ${load_addr} rockchip/overlays/${overlay_file}.dtbo; then
		echo "Applying kernel provided DT overlay ${overlay_file}.dtbo"
		fdt apply ${load_addr} || setenv overlay_error "true"
	fi
done
if test "${overlay_error}" = "true"; then
	echo "Error applying DT overlays, restoring original DT"
  fatload mmc ${devnum}:${distro_bootpart} ${fdt_addr_r} ${fdtfile}
fi

echo booting linux ...
booti ${kernel_addr_r} - ${fdt_addr_r}
