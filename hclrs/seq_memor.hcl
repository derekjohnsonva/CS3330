# -*-sh-*- # this line enables partial syntax highlighting in emacs

######### The PC #############
register fF { pc:64 = 0; }


########## Fetch #############
pc = F_pc;

f_icode = i10bytes[4..8];
f_ifun = i10bytes[0..4];
f_rA = i10bytes[12..16];
f_rB = i10bytes[8..12];


f_valC = [
	icode in { JXX } : i10bytes[8..72];
	1 : i10bytes[16..80];
];

wire offset:64;
offset = [
	icode in { HALT, NOP, RET } : 1;
	icode in { RRMOVQ, OPQ, PUSHQ, POPQ } : 2;
	icode in { JXX, CALL } : 9;
	1 : 10;
];
f_valP = F_pc + offset;

f_pc = f_valP;
########## Decode #############
register fD {
    icode:4 = 0;  
    ifun:4 = 0;
    rA:4 = REG_NONE;
    rB:4 = REG_NONE;
    valC:64 = 0xBADBADBAD;
}

reg_srcA = [
	D_icode in {RMMOVQ} : D_rA;
	1 : REG_NONE;
];
reg_srcB = [
	D_icode in {RMMOVQ, MRMOVQ} : D_rB;
	1 : REG_NONE;
];

### write to dE reg ###
d_icode = D_icode;
d_rA = D_rA;
d_valB = reg_outputB;
d_valA = reg_outputA;
d_valC = D_valC;

########## Execute #############
register dE {
    icode:4 = 0;  
	rA:4 = REG_NONE;
    valB:64 = 0xBADBADBAD;
    valA:64 = 0xBADBADBAD;
	valC:64 = 0xBADBADBAD;
}
wire operand1:64, operand2:64;

operand1 = [
	E_icode in { MRMOVQ, RMMOVQ } : E_valC;
	1: 0;
];
operand2 = [
	E_icode in { MRMOVQ, RMMOVQ } : E_valB;
	1: 0;
];

wire valE:64;

valE = [
	icode in { MRMOVQ, RMMOVQ } : operand1 + operand2;
	1 : 0;
];

### write to eM register ###
e_icode = E_icode;
e_rA = E_rA;
e_valA = E_valA;
e_valE = valE;

########## Memory #############
register eM {
    icode:4 = 0;
	rA:4 = REG_NONE;
	valA:64 = 0xBADBADBAD;
	valE:64 = 0xBADBADBAD;
}
mem_readbit = M_icode in { MRMOVQ };
mem_writebit = M_icode in { RMMOVQ };
mem_addr = [
	M_icode in { MRMOVQ, RMMOVQ } : M_valE;
        1: 0xBADBADBAD;
];
mem_input = [
	M_icode in { RMMOVQ } : M_valA;
        1: 0xBADBADBAD;
];
m_icode = M_icode;
m_rA = M_rA;
m_memOutput = mem_output;
########## Writeback #############
register mW {
    icode:4 = 0;
	rA:4 = REG_NONE;
	memOutput:64 = 0xBADBADBAD;
}
reg_dstM = [ 
	W_icode in {MRMOVQ} : W_rA;
	1: REG_NONE;
];
reg_inputM = [
	W_icode in {MRMOVQ} : W_memOutput;
        1: 0xBADBADBAD;
];


Stat = [
	W_icode == HALT : STAT_HLT;
	W_icode > 0xb : STAT_INS;
	1 : STAT_AOK;
];




