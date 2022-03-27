# qsharp-samples

This directory contains example Q# programs taken from the [Q# libraries](https://github.com/Microsoft/QuantumKatas/), [Q# Katas](https://github.com/Microsoft/QuantumKatas/), and Q# coding contents ([used in the evaluation of Silq](https://github.com/eth-sri/silq)).
Our intention is to use these programs as a test suite for code that manipulates Q# programs.
The sources for these programs are included in the `submodules` directory. The `copy.sh` script copies and renames select files from the `submodules` directory to the `Libraries`, `Katas`, and `Contests` directories. 

See [github.com/ebraminio/awesome-qsharp](https://github.com/ebraminio/awesome-qsharp) for a complete list of resources for programming with Q#.

## TODOs

* When we copy the quantum libraries we flatten the directory structure, which breaks namespaces and may have drop files with the same name in different directories. We should probably preserve the internal directory structure instead.
* Add scripts to collect statistics on Q# code (e.g., how often are different language features are used?).
