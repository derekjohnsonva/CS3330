---
title: HCLRS
...

You can [download `hclrs.tar` here](files/hclrs.tar).

# Using HCLRS

## Setup

When you first untar `hclrs.tar` (with `tar xvf hclrs.tar`{.bash}), enter the `hclrs` directory and run `make`{.bash} with no arguments.

If you get any error messages, see [Installation of C](ownc.html) from lab 0. If you are on Windows, see the sections below.

### Recompiling HCLRS

The distribution we have supplied includes a precompiled binary of the HCL interpreter for Linux (64- and 32-bit) and OS X (64- and 32-bit). We have not tested the OS X binaries. To instaed compile the HCL interpreter yourself, follow the instructions [here](https://rustup.rs/) to install an implementation of the programming language Rust, then run `make compile-hclrs`.

### Windows Binaries 

There are also Windows binaries in the two .zip files in the `tools` directory.

### Updating HCLRS binaries

You can run the command `make update-hclrs` to download new copies of the HCLRS binaries from the instructor's website.
This command will require you to have the tool `curl` installed.

## Checking `.hcl` for errors

To test `tiny.hcl` for compilation errors, run

````bash
./hclrs --check tiny.hcl
````

## Running `.hcl` on `.yo`

To test `tiny.hcl` on `y86/alu.yo`, 

1.  Make sure you are in the `hcl2d` directory; the Makefile depends on this
2.  Make sure `tiny.hcl` is also in the `hcl2d` directory
3.  Run

    ````bash
    ./hclrs tiny.hcl y86/alu.yo
    ````

4.  You can also give `./hclrs` various flags, like `-q` and `-i`; running `./hclrs`{.bash} with no arguments will list the permitted flags.


## Turning a `.ys` into `.yo`

To turn `toy.ys` into `toy.yo`,

1.  Make sure you are in either the `hcl2d` directory or the `hcl2d/y86`; the Makefile depends on this
2.  Run `make toy.yo`{.bash}



## Seeing what a `.yo` file is *supposed* to do

In the `tools` folder is a program called `yis`; running this on a `yo` file will show a summary of its correct results.

````bash
./tools/yis y86/alu.yo
````



# Our flavor of HCL

We use a variant of HCL we created that is similar to, but not the same as, the book's variant.

Like the book's flavor, our HCL has muxes with `[ condition : value; ]` syntax; comparisons (`==`, `<`, etc), boolean (`&&`, `!`, `||`) and set membership (`x in {y,z}`) operators.

Unlike the book's flavor, we declare things differently:

*   You can define as many constants as you want; e.g. `const PI = 3;`
*   Wires are declared with a particular bit width, like `wire tmp:4;`, not with "int".
*   Wires cannot be intialized on the same line they are declared.
*   You can use binary (e.g. `0b01010011`) as well as decimal and hex.  Unlike decimal and hex, binary numbers have a width which must match the width of the wires they are assigned to, so

        wire tmp:4;
        tmp = 0b10;   # this is an ERROR; two-bit value does not match 4-bit destination
        tmp = 0b0010; # this is OK - a four-bit value into a four-bit destination
        tmp = 2;      # this is also OK - decimal does not have bit-width
        tmp = 0x0002; # this is also OK - hexadecimal does not have bit-width

*   Expressions have widths based on their operands and the operation

        wire tmp:4;
        tmp = 0b11110 + 1; # this is an ERROR: 0b11110 + 1 is 5 bits wide, since 0b10 is 5 bits wide
        tmp = 0x2 + 1; # this is OK: neither 0x2 or 1 have bit widths, so 0x2 + 1 doesn't either
        tmp = (0b111 ^ 0b1100); # this an ERROR: 0b111 is 3 bits, and 0b1100 is 4 bits.
                                # there is no width tmp could have to make this compile
        tmp = ((0b1110 ^ 0b0011) == 2); # this an ERROR: == has a 1-bit wide output
        tmp = 33 | 0b1110; # this an OK: 0b1110 is 4 bits wide and 33 has no width, so the result is 4 bits wide
                           # the extra bits in 33 are silently truncatd


*   You can define your own register banks
    *   `register fE { hi:3 = 2; there:5 = 0; }` defines a register bank.
        -   It contains two registers, `hi` (3 bits wide) and `there` (five bits wide).
        -   `fE` gives the input and output names; they must be a lowercase letter and an uppercase letter
        -   `f_hi = 5;` puts `5` on the input wire for register `hi`
        -   `... = E_hi;` reads the output wire from register `hi`
        -   If you set `bubble_E = true`, inputs are ignored and `hi` will be set to `2`, `there` to `0`
        -   If you set `stall_E = true`, inputs are ignored and outputs will remain as-is

Unlike the book's flavor, we also have more operators:
  
*   A bit-slicing operator: if tmp = 0b010111 then `tmp[1..4]` is 0b011 and `tmp[0..1]` is the low-order bit of tmp (a `1`).  Index 0 is the low-order bit.
*   You can concatenate fixed-width values (wires, registers, binary literals, and the result of the slice operator); for example `(0b0101 .. 0b01101)` is 0b010101101.  The parentheses are required.
*   You can include C math operators in your expressions

Order of code usually does not matter: all statements are executed in parallel and shuffling the order of lines in your code does not change your code's meaning.
As an exception to this rule, the cases of a mux are evaluated in order,
so `[ x==1 : 3; true : 4 ]` will have different values if `x` is `1` than if it is not,
but `[ true: 4; x==1 : 3 ]` will always evaluate to `4`, no matter the value of `x`.
Similarly, non-commutative operators like `-` and `<=` have the same order-dependent meaning in HCLRS that they have in C.

# Built-in functionality of the simulators

Part of the goal of this flavor of HCL was to give greater freedom to re-wire what in the textbook author's version was built-in functionality.
However, we still provide hard-wired some components, such as memory and the register file.

## View 1: Wires and constants

This section and the following section contain the same information, but presented in a different way.

The simulator provides the following built-in signals and constants, as can be verified by inspecting the first few lines of `tools/hcl2d.d`:

    ###################### begin builtin signals ##########################

    ### constants:

    const STAT_BUB = 0b000, STAT_AOK = 0b001, STAT_HLT = 0b010;  # expected behavior
    const STAT_ADR = 0b011, STAT_INS = 0b100, STAT_PIP = 0b110;  # error conditions

    const REG_RAX = 0b0000, REG_RCX = 0b0001, REG_RDX = 0b0010, REG_RBX = 0b0011;
    const REG_RSP = 0b0100, REG_RBP = 0b0101, REG_RSI = 0b0110, REG_RDI = 0b0111;
    const REG_R8  = 0b1000, REG_R9  = 0b1001, REG_R10 = 0b1010, REG_R11 = 0b1011;
    const REG_R12 = 0b1100, REG_R13 = 0b1101, REG_R14 = 0b1110, REG_NONE= 0b1111;

    # icodes; see figure 4.2
    const HALT   = 0b0000, NOP    = 0b0001, RRMOVQ = 0b0010, IRMOVQ = 0b0011;
    const RMMOVQ = 0b0100, MRMOVQ = 0b0101, OPQ    = 0b0110, JXX    = 0b0111;
    const CALL   = 0b1000, RET    = 0b1001, PUSHQ  = 0b1010, POPQ   = 0b1011;
    const CMOVXX = RRMOVQ;

    # ifuns; see figure 4.3
    const ALWAYS = 0b0000, LE   = 0b0001, LT   = 0b0010, EQ   = 0b0011;
    const NE     = 0b0100, GE   = 0b0101, GT   = 0b0110;
    const ADDQ   = 0b0000, SUBQ = 0b0001, ANDQ = 0b0010, XORQ = 0b0011;

    ### fixed-functionality inputs (things you should assign to in your HCL)

    wire Stat:3;              # should be one of the STAT_... constants
    wire pc:64;               # put the address of the next instruction into this

    wire reg_srcA:4, reg_srcB:4;         # use to pick which program registers to read from
    wire reg_dstE:4, reg_dstM:4;         # use to pick which program registers to write to
    wire reg_inputE:64, reg_inputM:64;   # use to provide values to write to program registers

    wire mem_writebit:1, mem_readbit:1;  # set at most one of these two to 1 to access memory
    wire mem_addr:64;                    # if accessing memory, put the address accessed here
    wire mem_input:64;                   # if writing to memory, put the value to write here

    ### fixed-functionality outputs (things you should use but not assign to)

    wire i10bytes:80;                    # output value of instruction read; linked to pc
    wire reg_outputA:64, reg_outputB:64; # values from registers; linked to reg_srcA and reg_srcB
    wire mem_output:64;                  # value read from memory; linked to mem_readbit and mem_addr

    ####################### end builtin signals ###########################

Because these are provided, they cannot be redeclared in your files but can (and should) be used to interact with the register file, memory system, and to tell the simulator when to halt your program.


## View 2: provided components

This section and the preceding section contain the same information, but presented in a different way.

There are several built-in components; they have built-in names and you have to use those names to interact with them.
We do not use the same names as the textbook in part because the book sometimes uses the same name for 2+ things.
For example, the book uses `valM` to be both the output of data memory *and* one of the write-inputs to the register file.
The block above lists all of our names; we repeat them below by component.

Instruction Memory
:   The input to the instruction memory is called `pc`.
    `pc` is a 64-bit number and is treated as containing a memory address from which to read an instruction.
    
    The output of the instruction memory is called `i10bytes`.
    `i10bytes` is an 80-bit number and contains the little-endian value read from memory at the address specified in `pc`.
    
    Typically we want to split out parts of `i10bytes`.
    We do this with the "slice" operator:
     
        wire icode:4;
        icode = i10bytes[4..8];
    
    The bits are numbered from 0 (least-significant byte) to 79 (most significant byte).
    `i10bytes[4..8]` selects bits 4, 5, 6, and 7 and returns them as a 4-bit number.
    
    The book does not refer to `i10bytes` by any name, and uses `pc` to mean several things, including what we are using it to mean here.

Data Memory
:   The data memory has four inputs and one output.
    
    Inputs:
    
    `mem_readbit`
    :   A 1-bit value.  0 means don't read, 1 means do read.
        It is an error for both `mem_readbit` and `mem_writebit` to be set to 1 at the same time.
    
    `mem_writebit`
    :   A 1-bit value.  0 means don't write, 1 means do write.
        It is an error for both `mem_readbit` and `mem_writebit` to be set to 1 at the same time.
    
    `mem_addr`
    :   A 64-bit value which should contain a memory address if either `mem_readbit` or `mem_writebit` is 1.
        It is the address at which memory is read or written.
    
    `mem_input`
    :   A 64-bit value which will be written (in little-endian) to `mem_addr` if and only if `mem_writebit` is 1.
    
    Outputs:
    
    `mem_output`
    :   A 64-bit value read (in little-endian) from `mem_addr` if `mem_readbit` was 1;
        or the number 0x0000000000000000 if `mem_readbit` was 0.
    
    The book refers to `mem_addr` as just "addr", `mem_input` as "data", and `mem_output` as "valM".
    Note that they (confusingly) also use "valM" as the name of an input to the Register File.

Register File
:   The register file has six inputs and two outputs.
    These represent two "read ports" (called A and B to match the book's naming)
    and two "write ports" (called E and M to match the book's naming).
    
    Read Ports:
    
    Inputs `reg_srcA` and `reg_srcB`
    :   4-bit inputs containing a register number to read from.
    
    Outputs `reg_outputA` and `reg_outputB`
    :   64-bit values containing the contents of the registers named in `reg_srcA` and `reg_srcB`, respectively.
        Thus, if `reg_srcA` is `REG_RSP` then `reg_outputA` will be the value stored in `%rsp`.
        
        If a source was `REG_NONE`, the corresponding output will be the number 0x0000000000000000.
    
    Write Ports:
    
    Inputs `reg_dstE` and `reg_dstM`
    :   4-bit inputs containing a register number to write to.
        `REG_NONE` means "don't write".
    
    Inputs `reg_inputE` and `reg_inputM`
    :   64-bit values to be stored in the registers named in `reg_dstE` and `reg_dstM`, respectively.
        Thus, if `reg_dstE` is `REG_RSP` then the value from `reg_inputE` will be the stored into `%rsp`.

    These names are related to the names in the book as follows:
    
    - The book does not have `reg_` prefixes; we added them because students were getting confused which signals were attached to what.
    - The book calls both `inputX` and `outputX` just "valX"; we distinguish between inputs and outputs for clarity.
    
    Note that the book (confusingly) uses "valM" as both the name of an input to the Register File and the name of an output from the Data Memory.
    It also uses "valE" as both the name of an input to the Register File and the name of an output from the ALU.


Status
:   The status block has a single input named `Stat`.
    It should be set to one of the named constants beginning `STAT_`.
    Notably, `Stat = STAT_AOK` means "keep running;" any other value means "stop running" (possibly with an error).
    
    The book also calls this `Stat`.

ALU, Condition Codes, and register to store the PC
:   The book has several components "built-in" (shown in blue in their pictures) that we'll let you implement yourself.
    These include the ALU, the condition codes, and the register that stores the current program counter.

# Less-common Options

## Running code the hard way


If you don't have `make` (e.g., because you are running in Windows), then you will need to compile things manually:

1.  go to the tools directory

2.  run your C compiler to make `yas` and `yis`, as e.g.

    ````bash
    gcc -O2 yas.c isa.c yas-grammar.c -o yas
    gcc -O2 yis.c isa.c               -o yis
    ````

3.  choose the appropriate precompiled copy of HCLRS from the .tar.gz and .zip archives in the tools directory for your 
    When you find the archive, extract the `hclrs` executable from it. (On OS X and Linux, it will not have any extension.)

    If you do not find a precompiled version of HCLRS for your platform, first install `rustup` as described on [this website](https://rustup.rs/). Then, install [git](https://git-scm.org/). Then run:

    ````bash
    git clone -b cs3330-current https://github.com/woggle/hclrs.git ./tools/hclrs-src
    ````
    
    to extract the HCLRS source code to `tools/hclrs-src`. Go to that directory, then run:

    ````bash
    cargo build --release
    ````

    Then copy the executable `target/release/hclrs` to the base directory.


# License and Copyright

`yis`, `yas`, and most of the provided `.ys` files are from 

> Y86 Tools (Student Distribution)    
> Copyright (c) 2002, 2010, 2015 R. Bryant and D. O'Hallaron,
> All rights reserved. May not be used, modified, or copied without permission.

Permission to distribute unmodified versions of these sources was obtained by Luther Tychonievich from the authors in July 2014 and renewed August 2015.  That permission does not extend to you; you may obtain them, but not redistribute them without first obtaining permission from the copyright holders.

The provided `.yo` files were generated by `yas` from the `.ys` files and I believe that they fall under the same copyright and distribution rules.

----

`hclrs` is original to this package

> Copyright (c) 2017 Charles Reiss
> Released into the public domain.  
> Attribution is appreciated but not required.

----

`hclrs` makes use of the [lalrpop](https://github.com/nikomatsakis/lalrpop) parser library by Niko Matsaksi, which
is available undr the MIT and Apache 2.0 licenses.

`hclrs` makes use of the [extprim](https://github.com/kennytm/extprim) math library by kennytm, which is available
under the MIT and Apache 2.0 licenses.

`hclrs` makes use of various parts of the Rust standard library, which is available under the MIT and Apache 2.0 licenses






