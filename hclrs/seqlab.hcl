
register pP {  
    # our own internal register. P_pc is its output, p_pc is its input.
	pc:64 = 0; # 64-bits wide; 0 is its default value.
} 

register cC {
     SF:1 = 0;
     ZF:1 = 1;
 }
# "pc" is a pre-defined input to the instruction memory and is the 
# address to fetch 6 bytes from (into pre-defined output "i10bytes").
pc = P_pc;

# we can define our own input/output "wires" of any number of 0<bits<=80
wire opcode:8, icode:4, ifun:4,rA:4, rB:4, valC:64, valE:64, conditionsMet:1;


opcode = i10bytes[0..8];   # first byte read from instruction memory
icode = opcode[4..8];      # top nibble of that byte
ifun = opcode[0..4];		   # bottom nibble of opcode. Used to declare function
rA = i10bytes[12..16];
rB = i10bytes[8..12];
valC = [
    icode == JXX : i10bytes[8..72];
    1            : i10bytes[16..80];
];

# Stat is a built-in output; STAT_HLT means "stop", STAT_AOK means 
# "continue".
Stat = [
	icode == HALT : STAT_HLT;
	# if opcode is greater than 11 it is invalid
	icode > 11    : STAT_INS;
	# Default to OK
	1             : STAT_AOK;
];

reg_inputE = [
    icode == IRMOVQ : valC;
    icode == RRMOVQ : reg_outputA;
	icode == OPQ    : valE;
    1               : valC;
];


reg_dstE = [
    icode in {IRMOVQ, OPQ} : rB;
	# for conditional move, check that the conditions were met.
	icode == CMOVXX && conditionsMet == 1 : rB;
    1 : REG_NONE;
];

reg_srcA = [
    icode in {CMOVXX, OPQ, RMMOVQ} : rA;
    1 : REG_NONE;
];

reg_srcB = [
    icode in {CMOVXX, OPQ, RMMOVQ} : rB;
    1 : REG_NONE;
];

mem_readbit = 0x0;

mem_writebit = [
	icode == RMMOVQ	 : 0x1;
	1				 : 0x0;
];

mem_input = [
	icode == RMMOVQ	 : reg_outputA;
	1				 : 0xBADBADBAD;
];

mem_addr = [
	icode == RMMOVQ  : valE;
	1				 : 0xBADBADBAD;
];


# This is acting as out ALU
valE = [
	icode == OPQ && ifun == ADDQ : reg_outputB + reg_outputA;
	icode == OPQ && ifun == SUBQ : reg_outputB - reg_outputA;
	icode == OPQ && ifun == ANDQ : reg_outputB & reg_outputA;
	icode == OPQ && ifun == XORQ : reg_outputB ^ reg_outputA;
	icode == RMMOVQ				 : reg_outputB + valC;
	1							 : 0xBADBADBAD
];
# Setting the condition codes
stall_C = (icode != OPQ);
c_ZF = (valE == 0);
c_SF = (valE >= 0x8000000000000000);

conditionsMet = [
	ifun == ALWAYS : 1;
	ifun == LE : C_SF || C_ZF;
	ifun == LT : C_SF;
	ifun == EQ : C_ZF;
	ifun == NE : !C_ZF;
	ifun == GE : !C_SF || C_ZF;
	ifun == GT : !C_SF && !C_ZF;
	1    	   : 0xBADBADBAD;
];

p_pc = [
	icode in {HALT, NOP} : P_pc + 1;
	icode in {RRMOVQ, OPQ, CMOVXX, PUSHQ, POPQ, OPQ}
                         : P_pc + 2; 
    icode in {JXX}       : valC;
	icode in {IRMOVQ, RMMOVQ, MRMOVQ,}
                         : P_pc + 10;
	1                    : P_pc + 0xBADBAD;
]
