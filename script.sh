#!/usr/bin/env bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 <compiler> <test_directory>"
    exit 1
fi

compiler=$1
tests_directory=$2

if ! command -v "$compiler" >/dev/null 2>&1 ; then
    echo "Error: command $compiler could not be found"
    exit 1
fi

if ! [ -e "$tests_directory" ] ; then
    echo "Error: Directory $tests_directory is not exist"
    exit 1
fi

if ! [ -d "$tests_directory" ] ; then
    echo "Error: $tests_directory is not a directory"
    exit 1
fi

assembly_directory="assemblies" # hardcoded so far
mkdir -p $assembly_directory

for cur_instr_dir in "$tests_directory"/* ; do
    instr_name=$(basename -- "$cur_instr_dir")

    if ! [ -d "$cur_instr_dir" ] ; then
        echo "Warning: $cur_instr_dir is not a directory. Ignored"
        continue
    fi

    echo "Instruction $instr_name:"

    for test_file in "$cur_instr_dir"/*.c; do
        cur_asm=${test_file%.*}.s # change extension
        cur_asm=$assembly_directory/${cur_asm#*/} # change first directory 
        
        mkdir -p $assembly_directory/"$instr_name"

        $compiler -march="rv64gc_zba_zbb_zbc_zbs" -S -o "$cur_asm" "$test_file"

        # if [ $? -eq 0 ]; then
        #     echo "Test ${test_file%.*} compiled successfully"
            
        #     objdump -d ${test_file%.*} | grep -oP '(?<=<)[^>]+'
        # fi
    done
done

rm -rf $assembly_directory