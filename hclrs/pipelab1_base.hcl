########## the PC and condition codes registers #############
register fF { pc:64 = 0; }


########## Fetch #############
pc = F_pc;

wire icode:4, ifun:4, rA:4, rB:4, valC:64;

icode = i10bytes[4..8];
ifun = i10bytes[0..4];
rA = i10bytes[12..16];
rB = i10bytes[8..12];

valC = [
	icode in { JXX } : i10bytes[8..72];
	1 : i10bytes[16..80];
];

wire offset:64, valP:64;
offset = [
	icode in { HALT, NOP, RET } : 1;
	icode in { RRMOVQ, OPQ, PUSHQ, POPQ } : 2;
	icode in { JXX, CALL } : 9;
	1 : 10;
];
valP = F_pc + offset;


########## Decode #############

# source selection
reg_srcA = [
	icode in {RRMOVQ} : rA;
	1 : REG_NONE;
];


########## Execute #############



########## Memory #############




########## Writeback #############


# destination selection
reg_dstE = [
	icode in {IRMOVQ, RRMOVQ} : rB;
	1 : REG_NONE;
];

reg_inputE = [ # unlike book, we handle the "forwarding" actions (something + 0) here
	icode == RRMOVQ : reg_outputA;
	icode in {IRMOVQ} : valC;
        1: 0xBADBADBAD;
];


########## PC and Status updates #############

Stat = [
	icode == HALT : STAT_HLT;
	icode > 0xb : STAT_INS;
	1 : STAT_AOK;
];

f_pc = valP;



