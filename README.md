# RISC-V checking code generation using the bitmanip extension
## Description
Bash script and test base for compiler analysis for RISC-V

## Getting started
### Run
To run the utility locally from your command line:

```bash
# Clone repository
git clone https://github.com/ALanovaya/riscv-check.git

# Go into the repository
cd riscv-check

# Run the script
./analyzer.sh -c <compiler> -t <test_directory> # basic way to run
```
### Usage
To view usage and possible options run
```bash
./analyzer.sh --help
```

## Results
After running the tests, a file will appear with the result of checking the search for instructions from the bitmanip extension at all possible compiler optimization levels. Also, if there are compiler errors or warnings, a separate file with compiler messages will be created.

## License

Distributed under the MIT License.