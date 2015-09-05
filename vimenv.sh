#!/bin/bash

if [[ $# -eq 1 ]] && ! [[ -d $1 ]] && [[ $1 -eq 0 ]]; then
    echo clear all
    rm -f cscope.files > /dev/null 2>&1
    rm -f cscope.in.out > /dev/null 2>&1
    rm -f cscope.out > /dev/null 2>&1
    rm -f cscope.po.out > /dev/null 2>&1
    rm -f tags > /dev/null 2>&1
    rm -f .project.vim > /dev/null 2>&1
    rm -f %*.txt > /dev/null 2>&1
    exit 0
fi

while [[ -n $1 ]]; do
    if [[ -d $1 ]]; then
        if [[ $# -eq 1 ]]; then
            addsrc.sh $1 1
        else
            addsrc.sh $1 0
        fi
    else
        echo $1 is not a directory
        exit 1
    fi
    shift
done

touch .project.vim
