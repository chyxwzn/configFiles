#!/bin/bash

if [[ $# != 1 ]]; then
    echo "Usage: $0 hosts file"
    exit 1
fi
hosts_file=$1
sed -i -e '/google\./!d' $hosts_file
