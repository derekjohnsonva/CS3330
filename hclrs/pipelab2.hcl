# -*-sh-*- # this line enables partial syntax highlighting in emacs

######### The PC #############
register fF { pc:64 = 0; }



##### Stalling #####
wire loadUse:1;
loadUse = E_icode == MRMOVQ && E_dstM in {reg_srcA, reg_srcB};

stall_F = loadUse;
stall_D = loadUse;
bubble_E = loadUse;

########## Fetch #############
pc = F_pc;

f_icode = i10bytes[4..8];
f_ifun = i10bytes[0..4];
f_rA = i10bytes[12..16];
f_rB = i10bytes[8..12];


f_valC = [
	f_icode in { JXX } : i10bytes[8..72];
	1 : i10bytes[16..80];
];

wire offset:64, valP:64;
offset = [
	f_icode in { HALT, NOP, RET } : 1;
	f_icode in { RRMOVQ, OPQ, PUSHQ, POPQ } : 2;
	f_icode in { JXX, CALL } : 9;
	1 : 10;
];
valP = F_pc + offset;

f_pc = valP;
########## Decode #############
register fD {
    icode:4 = 1;  
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
d_valB = [
	reg_srcB == REG_NONE : 0;
	reg_srcB == m_dstM : m_valM;
	reg_srcB == W_dstM : W_valM;
	1 : reg_outputB;
];
d_valA = [
	reg_srcA == REG_NONE : 0;
	reg_srcA == m_dstM : m_valM;
	reg_srcA == W_dstM : W_valM;
	1 : reg_outputA;
];

d_dstM = [ 
	D_icode in {MRMOVQ} : D_rA;
	1: REG_NONE;
];

d_valC = D_valC;

########## Execute #############
register dE {
    icode:4 = 1;  
	rA:4 = REG_NONE;
	dstM:4 = REG_NONE;
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
	E_icode in { MRMOVQ, RMMOVQ } : operand1 + operand2;
	1 : 0;
];

### write to eM register ###
e_icode = E_icode;
e_rA = E_rA;
e_valA = E_valA;
e_valE = valE;
e_dstM = E_dstM;

########## Memory #############
register eM {
    icode:4 = 1;
	dstM:4 = REG_NONE;
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
m_valM = mem_output;
m_dstM = M_dstM;
########## Writeback #############
register mW {
    icode:4 = 1;
	dstM:4 = REG_NONE;
	rA:4 = REG_NONE;
	valM:64 = 0xBADBADBAD;
}
reg_dstM = [ 
	W_icode in {MRMOVQ} : W_rA;
	1: REG_NONE;
];
reg_inputM = [
	W_icode in {MRMOVQ} : W_valM;
        1: 0xBADBADBAD;
];


Stat = [
	W_icode == HALT : STAT_HLT;
	W_icode > 0xb : STAT_INS;
	1 : STAT_AOK;
];




