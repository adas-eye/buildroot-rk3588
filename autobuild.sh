#!/bin/bash

usage () {
	echo "Usage:"
	echo "$0 -n    Normal target build"
	echo "$0 -f    Full target rebuild"
}

submodule_update () {
	echo "Updating submodules..."
	git submodule init
        git submodule update --recursive
        echo "Submodule updating is done."
}

build_target () {
	rm last_build.log
	echo "Build target..."
	cd buildroot
	make BR2_EXTERNAL=../external rock5b_defconfig
	make -j8 > ../last_build.log 2>&1
	echo "Build is done. Please find logs in last_build.log file."
}

rebuild_target () {
	rm last_build.log
	echo "Fully rebuild target..."
	cd buildroot
	make BR2_EXTERNAL=../external rock5b_defconfig
	make clean all
	make -j8 > ../last_build.log 2>&1
	echo "Rebuild is done. Please find logs in last_build.log file."
}

if (( $# == 0 )); then
	echo "No flag is provided."
	usage
	exit 1
fi

while getopts fnh OPT
do
	case "${OPT}" in
		f) rebuild_target;;
		n) build_target;;
		h) usage;;
                ?) usage && exit 1;;
	esac
done
