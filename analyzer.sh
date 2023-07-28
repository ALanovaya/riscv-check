#!/usr/bin/env bash

usage () { 
    echo "Usage: $0 {-c|--compiler <compiler>} {-t|--test-directory <test_directory>}"
}

help () {
    echo "Description: utility for evaluating code generation coverage by running tests from the required directory for different compilers"
    echo
    usage
    echo
    echo "Optional:"
    echo "[-b|--arch-bits <arch_bits>] Set to 64 by default, can be 64 or 32"
    echo "[-o|--output <directory>] The directory where all compiled files will be located. Set to \"compiled\" by default"
    echo "[-s|--save] Enables saving a directory with compiled files. It is not saved by default"
    echo -e "[-l|--log <filename>] The file in which the results of the script will be writed (the contents of the file will be overwritten). Set to \"results.txt\" by default"
}

arch_bits=64 # by default
clang_flag="" # empty if compiler is gcc
assembly_directory="compiled" # by default
delete_assembly_dir=true # by default
extensions="gc_zba_zbb_zbc_zbs"
output_file="results.txt" # by default
error_log="compilation-errors-log.txt" # by default
temp="temp.txt" # for saving compiler errors

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
        -o|--output)
            assembly_directory=$2
            shift
            shift
            ;;
        -s|--save)
            delete_assembly_dir=false
            shift
            ;;
        -l|--log)
            output_file=$2
            shift
            shift
            ;;
        -h|--help)
            help
            exit 1
            ;;
        -*)
            echo 1>&2 "Error: unknown option <$1>"
            usage
            exit 1
            ;;
        *)
            echo 1>&2 "Error: unknown parameter <$1>"
            usage
            exit 1
            ;;
    esac
done

if [ -z ${compiler+x} ] || [ -z ${test_directory+x} ] ; then
    echo 1>&2 "Error: the necessary parameters are not set"
    usage
    exit 1
fi

if [ "$arch_bits" -ne 32 ] && [ "$arch_bits" -ne 64 ] ; then
    echo 1>&2 "Error: arch_bits can only be 32 or 64"
    exit 1
fi

if ! command -v "$compiler" >/dev/null 2>&1 ; then
    echo 1>&2 "Error: command $compiler could not be found"
    exit 1
fi

if ! [ -e "$test_directory" ] ; then
    echo 1>&2 "Error: Directory $test_directory does not exist"
    exit 1
fi

if ! [ -d "$test_directory" ] ; then
    echo 1>&2 "Error: $test_directory is not a directory"
    exit 1
fi

case "$compiler" in
    *"clang"*)
        clang_flag="--target=riscv$arch_bits"
        ;;
esac

arch="rv$arch_bits$extensions"
mkdir -p "$assembly_directory"

optimization_flags=(
    "-O0"
    "-O1"
    "-O2"
    "-O3"
)

echo -n > "$output_file"
echo -n > "$error_log"
echo -n > "$temp"

instr_number=1

for cur_instr_dir in "$test_directory"/* ; do
    
    instr_name=$(basename -- "$cur_instr_dir")

    if ! [ -d "$cur_instr_dir" ] ; then
        echo 1>&2 "Warning: $cur_instr_dir is not a directory. Ignored"
        continue
    fi

    echo "$instr_number. Instruction $instr_name" >> "$output_file"
    instr_only_for_64=true

    for test_file in "$cur_instr_dir"/*.c; do
        
        file_for_64=true
        cur_filename=$(basename -- "$test_file" .c)
        if [ "${cur_filename##*-}" = "32" ] && [ "${cur_filename##*-}" != "$cur_filename" ] ; then
            file_for_64=false
        fi
        
        if [ "$file_for_64" = true ] && [ "$arch_bits" = 32 ] ; then 
            continue
        fi
        if [ "$file_for_64" = false ] && [ "$arch_bits" = 64 ] ; then 
            continue
        fi
        
        instr_only_for_64=false
        was_warning=false

        asm_dir=$assembly_directory/${test_file#*/} # change first directory 
        mkdir -p "$assembly_directory"/"$instr_name"
    
        generated=""
        not_generated=""

        echo -n "Test ${test_file##*/}: " >> "$output_file"

        for flag in "${optimization_flags[@]}"; do

            cur_asm=${asm_dir%.*}$flag.s # change extension and optimization level to filename

            if [ -z "$clang_flag" ] ; then
                compile_command="$compiler -march=$arch -S -o $cur_asm $flag $test_file"
            else 
                compile_command="$compiler -march=$arch -S -o $cur_asm $flag $clang_flag $test_file"
            fi

            if eval "$compile_command" > $temp 2>&1 ; then
                              
                string=$(grep "$instr_name" "$cur_asm")
                find_instr=false
                prev_word=""

                for word in $string ; do 
                    if [ "$word" = "$instr_name" ] && [ "$prev_word" != ".globl" ] ; then
                        find_instr=true
                        break
                    fi
                    prev_word="$word"
                done
                 
                if [ "$find_instr" = true ] ; then
                    if [ -z "$generated" ] ; then
                        generated=${flag}
                    else
                        generated="${generated}, ${flag}"
                    fi
                else 
                    if [ -z "$not_generated" ] ; then
                        not_generated=${flag}
                    else
                        not_generated="${not_generated}, ${flag}"
                    fi
                fi

                if [ -s "$temp" ] && [ "$was_warning" = false ]; then
                    was_warning=true
                    echo "Compilation ended with warnings. You can see the \"$error_log\" file for more." >> "$output_file"
                    {
                        echo -e "$instr_number. Instruction $instr_name; test ${test_file##*/}; Compilation ended with warnings, command:"
                        echo "$compile_command"
                        echo "Compiler messages:"
                        cat $temp
                        echo
                    } >> "$error_log"
                fi

            else
                error_string="Compilation error when trying\n$compile_command"
                {
                    echo -e "$error_string"
                    echo "You can see the \"$error_log\" file for more."
                
                } >> "$output_file"
                {
                    echo -e "$instr_number. Instruction $instr_name; test ${test_file##*/}; $error_string"
                    echo "Error messages:"
                    cat $temp
                    echo
                } >> "$error_log"
                break

            fi
        done

        if [ -n "$not_generated" ] ; then 
            echo -n "\"$instr_name\" was NOT generated with $not_generated. " >> "$output_file"
        fi
        if [ -n "$generated" ] ; then
            echo -n "\"$instr_name\" was generated with $generated." >> "$output_file"
        fi
        if [ -n "$not_generated" ] || [ -n "$generated" ] ; then
            echo >> "$output_file"
        fi

    done
    
    if [ "$instr_only_for_64" = true ] ; then 
        echo "This instruction is for 64-bit architectures only." >> "$output_file"
    fi
    echo >> "$output_file"
    instr_number=$((instr_number + 1))

done

if [ "$delete_assembly_dir" = true ] ; then
    rm -rf "$assembly_directory"
fi

if ! [ -s "$error_log" ] ; then 
    rm -f "$error_log"
fi

rm -f "$temp"

echo "Done. The results are written to \"$output_file\"."
