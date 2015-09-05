#!/bin/bash

if [[ $# -lt 1 ]]; then
    echo "Usage: `basename $0` directory update

        directory: source directory
        update: update cscope database(default: 0)"
    exit
fi

src_dir=$1
if [[ $# == 2 ]]; then
    update=$2
else
    update=0
fi

ag -l --nocolor --cc --cpp --java -g "" ${src_dir} >> cscope.files

if [[ ${update} == 1 ]]; then
    # Generate cscope database & tags
    cscope -bkq -i cscope.files
    ctags --fields=+ialS --extra=+q -L cscope.files
fi
