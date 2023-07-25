# RISC-V checking code generation using the bitmanip extension
## Getting started


### Build

To build and run this application locally from your command line:

```bash
# Clone this repository
git clone https://github.com/ALanovaya/riscv-check.git

# Go into the repository
cd riscv-check

# Run the script
./script.sh
```

## Description of project
This repository contains code for evaluating the code coverage of the bitmanip code generation for RISC-V architecture. The code generation is performed using a specific toolchain and compiler.

The repository includes a set of test cases that cover different aspects of bitmanip operations, such as bitwise logical operations, bit shifting, and bit counting. These test cases are designed to exercise various combinations of input values and edge cases to ensure comprehensive coverage.

The evaluation process involves compiling the test cases using the specified toolchain and compiler. The generated assembly code is then analyzed using a code coverage tool to determine the percentage of code that is executed during the tests.
The results of the code coverage analysis are presented in a report, which includes information on the percentage of code coverage for each test case and overall coverage metrics. This information can be used to identify areas of the code that have low coverage and may require further testing or optimization.
The repository also includes documentation on how to set up the evaluation environment, run the tests, and interpret the code coverage results. Additionally, it provides instructions on how to contribute to the evaluation process by adding new test cases or improving existing ones.
Overall, this repository aims to provide a comprehensive evaluation of the code coverage of the bitmanip code generation for RISC-V architecture, helping to ensure the quality and reliability of the generated code.

---

### Work with application
After running the script, you need to enter the path to the compiler that you want to check, then the path to the test directory and the bit depth on which the tests will run. After running the tests, a file will appear with the result of checking the search for instructions from the bitmanip extension at all possible compiler optimization levels.

## License

Distributed under the MIT License.