#!/bin/bash

if [[ $# -lt 1 ]]; then
    echo "Usage: `basename $0` directory update

        directory: source directory
        update: update tags(default: 0)"
    exit
fi

src_dir=$1
if [[ $# == 2 ]]; then
    update=$2
else
    update=0
fi

rg -g "" --files --color never ${src_dir} >> ctags.files

if [[ ${update} == 1 ]]; then
    # Generate tags
    ctags --fields=+ialS --extra=+q -L ctags.files
fi
