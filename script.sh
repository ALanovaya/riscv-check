#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 <compiler> <test_directory>"
    exit 1
fi

compiler=$1
test_directory=$2

cd $test_directory

for test_file in *.c; do
    $compiler -o ${test_file%.*} $test_file

    if [ $? -eq 0 ]; then
        echo "Test ${test_file%.*} compiled successfully"
        objdump -d ${test_file%.*} | grep -oP '(?<=<)[^>]+'    
    else
        echo "Compilation failed for test $test_file"
    fi
    
    echo ""
done