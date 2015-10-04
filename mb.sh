#!/bin/sh

LOADER_FILE=
PKG_FILE=
DRIVER_FILE=
ROOTFS_FILE=

function print_usage()
{
    echo "Usage: "`basename $0`" filetype [select_mode]"
    echo    "filetype:"
    echo    "    0	loader file"
    echo    "    1	pkg file"
    echo    "    2	loader and pkg file"
    echo    "    3	driver ko file"
    echo    "    4	rootfs file"
    echo    "select_mode:(default 0)"
    echo    "    0	exit after trying to send for the first time"
    echo    "    1	never exit and wait for the file been updated"
    echo    "example: "`basename $0`" 3 1"
}

if [[ $# == 0 ]] || ! (echo -n $1 | grep -q -e "^[0-4]") || [[ $# == 2 && $2 != 0 && $2 != 1 ]]; then
    print_usage
    exit 1
else
    filetype=$1
    if [[ $# == 2 ]]; then
        select_mode=$2
    else
        select_mode=0
    fi
fi

case $filetype in
    0 )
        LOADER_FILE=`find . -maxdepth 1 -name "*secure*\.bin" -type f -printf %P`
        ;;
    1 )
        PKG_FILE=`find . -maxdepth 1 -name "*upgrade_loader*\.pkg" -type f -printf %P`
        ;;
    2 )
        LOADER_FILE=`find . -maxdepth 1 -name "*secure*\.bin" -type f -printf %P`
        PKG_FILE=`find . -maxdepth 1 -name "*upgrade_loader*\.pkg" -type f -printf %P`
        ;;
    3 )
        DRIVER_FILE="driver.ko"
        ;;
    4 )
        ROOTFS_FILE="rootfs.bin"
        ;;
esac

if [[ $select_mode == 0 ]]; then
    for file in $LOADER_FILE $PKG_FILE $DRIVER_FILE $ROOTFS_FILE; do
        if [[ -f "$file" ]]; then
            echo
            echo `date`
            echo "mtk_build -x . -o $file"
            mtk_build -x . -o $file
        fi
    done
else
    last_update_time=0
    update_time=0
    while (true)
    do
        for file in $LOADER_FILE $PKG_FILE $DRIVER_FILE $ROOTFS_FILE; do
            if [[ -f "$file" ]]; then
                update_time=`stat -c %Y $file`
                if [[ $update_time > $last_update_time ]]; then
                    echo
                    echo `date`
                    echo "mtk_build -x . -o $file"
                    mtk_build -x . -o $file
                fi
            fi
        done
        last_update_time=$update_time
        sleep 10
    done
fi
