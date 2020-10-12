
########## Fetch #############
    ## cC is the register for condition codes ##
register cC {
    SF:1 = 0;
    ZF:1 = 1;
}
register fF { predPc:64 = 0; }
wire valP:64, valC:64,offset:64, stat:3, icode:4;

icode = i10bytes[4..8];
### PC increment ###
offset = [
	icode in { HALT, NOP, RET } : 1;
	icode in { CMOVXX, OPQ, PUSHQ, POPQ } : 2;
	icode in { JXX, CALL } : 9;
	1 : 10;
];
valP = F_predPc + offset;
### update valC ### 
valC = [
	icode in { JXX } : i10bytes[8..72];
	1 : i10bytes[16..80];
];
### Predict PC ###
f_predPc = valP;
pc = F_predPc;

### write to fD register ###
stat = [
        icode == HALT : STAT_HLT;
        icode > 0xb : STAT_INS;
        1 : STAT_AOK;
];
f_stat = stat;
f_icode = icode;
f_ifun = i10bytes[0..4];
f_rA = i10bytes[12..16];
f_rB = i10bytes[8..12];

f_valC = valC;
f_valP = valP;
### Handle Stalling ###
stall_F = [
    stat == STAT_HLT ||
        D_stat == STAT_HLT ||
        E_stat == STAT_HLT ||
        M_stat == STAT_HLT : true;
    1 : false;
];

########## Decode #############
wire dstE:4, dstM:4;
register fD {
    stat:3 = STAT_AOK;
    icode:4 = 0;  
    ifun:4 = 0;
    rA:4 = REG_NONE;
    rB:4 = REG_NONE;
    valC:64 = 0xBADBADBAD;
    valP:64 = 0xBADBADBAD;
}
reg_srcA = [
    D_icode in {CMOVXX, OPQ} : D_rA;
    1 : REG_NONE;
];

reg_srcB = [
    D_icode in {OPQ} : D_rB;
    1 : REG_NONE;
];

dstE = [
    D_icode in {IRMOVQ, CMOVXX, OPQ} : D_rB;
    1 : REG_NONE;
];

dstM = [
    1 : REG_NONE;
];

### Write to dE register ###
d_valA = [
    reg_srcA == E_dstE  : aluOut;
    reg_srcA == M_dstE  : M_valE;
    reg_srcA == W_dstE  : W_valE;
    D_icode in {CMOVXX, OPQ} : reg_outputA;
    1 : 0xBADBADBAD;
];
d_valB = [
    reg_srcB == E_dstE  : aluOut;
    reg_srcB == M_dstE  : M_valE;
    reg_srcB == W_dstE  : W_valE;
    D_icode in {OPQ} : reg_outputB;
    1 : 0xBADBADBAD;
];
d_stat = D_stat;
d_icode = D_icode;
d_ifun = D_ifun;
d_valC = D_valC;
d_dstE = dstE;
d_dstM = dstM;


########## Execute #############
register dE {
    stat:3 = STAT_AOK;
    icode:4 = 0;  
    ifun:4 = 0;
    valC:64 = 0xBADBADBAD;
    valA:64 = 0xBADBADBAD;
    valB:64 = 0xBADBADBAD;
    dstE:4 = REG_NONE;
    dstM:4 = REG_NONE;
}
wire aluOut:64, conditionsMet:1;
### ALU ###
aluOut = [
    E_icode in {IRMOVQ} : E_valC;
    E_icode in {CMOVXX} : E_valA;
    E_icode == OPQ && E_ifun == ADDQ : E_valB + E_valA;
	E_icode == OPQ && E_ifun == SUBQ : E_valB - E_valA;
	E_icode == OPQ && E_ifun == ANDQ : E_valB & E_valA;
	E_icode == OPQ && E_ifun == XORQ : E_valB ^ E_valA;
    1 : 0xBADBADBAD;
];

### Set condition Codes ###
stall_C = (E_icode != OPQ);
c_ZF = (aluOut == 0);
c_SF = (aluOut >= 0x8000000000000000);

### conditions for conditional Jump ###
conditionsMet = [
	E_ifun == ALWAYS : 1;
	E_ifun == LE : C_SF || C_ZF;
	E_ifun == LT : C_SF;
	E_ifun == EQ : C_ZF;
	E_ifun == NE : !C_ZF;
	E_ifun == GE : !C_SF || C_ZF;
	E_ifun == GT : !C_SF && !C_ZF;
	1    	   : 0xBADBADBAD;
];

### Write to eM register ###
e_stat = E_stat;
e_icode = E_icode;
e_cndSf = c_SF;
e_cndZf = c_ZF;
e_dstE = [
    E_icode == CMOVXX && conditionsMet != 1 : REG_NONE;
    1 : E_dstE;
];
e_dstM = E_dstM;
e_valE = aluOut;

########## Memory #############
register eM {
    stat:3 = STAT_AOK;
    icode:4 = 0;
    cndSf:1 = 0;
    cndZf:1 = 1;
    valE:64 = 0xBADBADBAD;  
    dstE:4 = REG_NONE;
    dstM:4 = REG_NONE;
}

### Write to mW register ###
m_stat = M_stat;
m_icode = M_icode;
m_valE = M_valE;
m_dstE = M_dstE;
m_dstM = M_dstM;

########## Writeback #############
register mW {
    stat:3 = STAT_AOK;
    icode:4 = 0;
    valE:64 = 0xBADBADBAD;  
    dstE:4 = REG_NONE;
    dstM:4 = REG_NONE;
}
### REgister Writeback ###
reg_dstE = W_dstE;
reg_inputE = W_valE;

########## PC and Status updates #############

Stat = W_stat; 



