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
    echo "Error: Directory $tests_directory does not exist"
    exit 1
fi

if ! [ -d "$tests_directory" ] ; then
    echo "Error: $tests_directory is not a directory"
    exit 1
fi

assembly_directory="assemblies" # hardcoded so far
mkdir -p $assembly_directory

platform=$(uname)

optimization_flags=(
    "-O0"
    "-O1"
    "-O2"
    "-O3"
)

output_file="results.txt"
echo "" > $output_file

for cur_instr_dir in "$tests_directory"/* ; do
    
    instr_name=$(basename -- "$cur_instr_dir")

    if ! [ -d "$cur_instr_dir" ] ; then
        echo "Warning: $cur_instr_dir is not a directory. Ignored"
        continue
    fi

    echo "Instruction $instr_name:" >> $output_file

    for test_file in "$cur_instr_dir"/*.c; do
        
        asm_dir=$assembly_directory/${test_file#*/} # change first directory 
        mkdir -p $assembly_directory/"$instr_name"
    
        for flag in "${optimization_flags[@]}"; do
            if [ "$platform" == "Linux" ]; then
                $compiler -march="rv64gc_zba_zbb_zbc_zbs" -S -o "$asm_dir" "$flag" "$test_file-$flag"
	    elif [ "$platform" == "Darwin" ]; then
                $compiler -march="rv64gc_zba_zbb_zbc_zbs" -S -o "$asm_dir" "$flag" "$test_file-$flag"
	    elif [[ "$platform" == *CYGWIN* || "$platform" == *MINGW* ]]; then
                $compiler -march="rv64gc_zba_zbb_zbc_zbs" -S -o "$asm_dir" "$flag" "$test_file-$flag"
            else
                echo "Error: Unsupported platform"
                exit 1
            fi

            if [ $? -eq 0 ]; then
                echo "Test ${test_file%.*} compiled successfully with optimization flag $flag" >> $output_file
                if [ "$platform" == "Linux" ]; then
                    objdump -d "$asm_dir" | grep -oP "(?<=<)[^>]+" | grep "$instr_name" | while read -r line; do
        		if [ "$line" == "$instr_name" ] && ! nm -D "$asm_dir" | grep -q "\<$instr_name\>"; then
            			echo "$line" >> $output_file
        		fi
    		done
	    	elif [ "$platform" == "Darwin" ]; then
    			otool -tv "$asm_dir" | grep -oP "(?<=<)[^>]+" | grep "$instr_name" | while read -r line; do
        		if [ "$line" == "$instr_name" ] && ! nm -gU "$asm_dir" | grep -q "\<$instr_name\>"; then
            			echo "$line" >> $output_file
        		fi
    		done    
		elif [[ "$platform" == *CYGWIN* || "$platform" == *MINGW* ]]; then
    			objdump -d "$asm_dir" | grep -oP "(?<=<)[^>]+" | grep "$instr_name" | while read -r line; do
        		if [ "$line" == "$instr_name" ]; then
            			echo "$line" >> $output_file
        		fi
    	    	done
		fi
            fi
        done
    done
done

# rm -rf $assembly_directory