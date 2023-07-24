#!/usr/bin/env bash

usage () { 
    echo -e "Usage: $0 [-c|--compiler <compiler>] [-t|--test-directory <test_directory>]\n[-b|--arch-bits <arch_bits> OPTIONAL. Set to 64 by default, can be 64 or 32]" ;
    exit 1;
}

arch_bits=64 # by default
extensions="gc_zba_zbb_zbc_zbs"

while [ $# -gt 0 ] ; do
    case $1 in
        -c|--compiler)
            compiler=$2
            shift
            shift
            ;;
        -t|--test-directory)
            test_directory=$2
            shift
            shift
            ;;
        -b|--arch-bits)
            arch_bits=$2
            shift
            shift
            ;;
        -h|--help)
            usage
            ;;
        -*)
            echo 1>&2 "Error: unknown option <$1>"
            usage
            ;;
        *)
            echo 1>&2 "Error. unknown parameter <$1>"
            usage
            ;;
    esac
done

if [ -z ${compiler+x} ] || [ -z ${test_directory+x} ] ; then
    echo 1>&2 "Error: the necessary parameters are not set"
    usage
fi

if [ $arch_bits -ne 32 ] && [ $arch_bits -ne 64 ] ; then
    echo 1>&2 "Error: arch_bits can only be 32 or 64"
    exit 1
fi

if ! command -v "$compiler" >/dev/null 2>&1 ; then
    echo 1>&2 "Error: command $compiler could not be found"
    exit 1
fi

if ! [ -e "$test_directory" ] ; then
    echo 1>&2 "Error: Directory $test_directory is not exist"
    exit 1
fi

if ! [ -d "$test_directory" ] ; then
    echo 1>&2 "Error: $test_directory is not a directory"
    exit 1
fi

arch="rv$arch_bits$extensions"
assembly_directory="assemblies" # hardcoded so far
mkdir -p $assembly_directory
declare -a opt_lvls=("O0" "O1" "O2" "O3")

for cur_instr_dir in "$test_directory"/* ; do
    
    instr_name=$(basename -- "$cur_instr_dir")

    if ! [ -d "$cur_instr_dir" ] ; then
        echo 1>&2 "Warning: $cur_instr_dir is not a directory. Ignored"
        continue
    fi
    
    echo "Instruction $instr_name:"

    for test_file in "$cur_instr_dir"/*.c; do
        
        asm_dir=$assembly_directory/${test_file#*/} # change first directory 
        mkdir -p $assembly_directory/"$instr_name"
    
        for i in {0..3} ; do

            cur_asm=${asm_dir%.*}-${opt_lvls[i]}.s # change extension and optimization level to filename
            
            $compiler -march="$arch" -S -"${opt_lvls[i]}" -o "$cur_asm" "$test_file"

        # if [ $? -eq 0 ]; then
        #     echo "Test ${test_file%.*} compiled successfully"
            
        #     objdump -d ${test_file%.*} | grep -oP '(?<=<)[^>]+'
        # fi

        done
    done
done

rm -rf $assembly_directory
