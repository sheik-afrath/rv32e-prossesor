# 32-bit RISC-V RV32E Processor Core

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A simple, single-cycle 32-bit processor that implements the RV32E instruction set architecture. This project was built from scratch in Verilog and serves as a practical demonstration of fundamental computer architecture concepts.

---

## 📖 Table of Contents

* [About The Project](#about-the-project)
* [Architecture Overview](#architecture-overview)
* [Implemented Components](#implemented-components)
* [Instruction Set Support](#instruction-set-support)
* [Directory Structure](#directory-structure)
* [Getting Started](#getting-started)
    * [Prerequisites](#prerequisites)
    * [Simulation](#simulation)

## 🎯 About The Project

This repository contains the Verilog source code for a functional 32-bit processor based on the RISC-V (RV32E) ISA. The RV32E is an "embedded" profile of the RISC-V architecture, featuring 16 general-purpose registers (`x0`-`x15`). This project implements a single-cycle datapath, where each instruction is executed in one clock cycle.

The primary goal of this project is to demonstrate a clear and educational implementation of a CPU's core components and their interactions.

## 🏛️ Architecture Overview

The processor follows a classic single-cycle design, which is composed of five main stages that execute in a single clock cycle:

1.  **Instruction Fetch:** The Program Counter (PC) provides the address to the Instruction Memory, which fetches the current instruction.
2.  **Instruction Decode:** The fetched instruction is decoded to extract the opcode, register numbers (rs1, rs2, rd), and immediate values. The control signals for the datapath are generated in this stage.
3.  **Execute:** The Arithmetic Logic Unit (ALU) performs the operation specified by the instruction, using operands from the register file or the immediate value.
4.  **Memory Access:** This stage is simplified as the design does not implement a separate data memory for load/store operations.
5.  **Write Back:** The result from the ALU is written back to the Register File.



## 🛠️ Implemented Components

The processor is built from the following modular Verilog files:

* **`rv32e_main.v`:** The top-level module that connects all the components of the processor.
* **`program_counter.v`:** A 32-bit register that holds the address of the current instruction. It increments by 4 bytes each cycle or updates to a branch target.
* **`Imem.v`:** A simple ROM that acts as the instruction memory, pre-loaded with a test program.
* **`insDecoder.v`:** Decodes the 32-bit instruction and generates control signals for the ALU and immediate values.
* **`register_file.v`:** Manages the 16 general-purpose 32-bit registers (`x0` to `x15`), with `x0` hardwired to zero.
* **`ALU.v`:** The Arithmetic Logic Unit that performs all computations, including addition, subtraction, logical operations, and comparisons for branches.
* **`rv32e_tb.v`:** The testbench used to simulate the processor and verify its functionality.

## ✨ Instruction Set Support

The ALU and instruction decoder currently support a subset of the RV32E ISA, including:

* **R-Type:** `ADD`, `SUB`, `AND`, `OR`, `XOR`, `SLL`, `SRL`, `SRA`, `SLT`
* **I-Type:** `ADDI`, `ANDI`, `ORI`, `XORI`, `SLLI`, `SRLI`, `SRAI`, `SLTI`
* **B-Type:** `BEQ`, `BNE`, `BLT`, `BGE`

## 📁 Directory Structure
