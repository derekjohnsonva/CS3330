/* Grammar for Y86-64 Assembler */
 #include "yas.h"

Instr         rrmovq|cmovle|cmovl|cmove|cmovne|cmovge|cmovg|rmmovq|mrmovq|irmovq|addq|subq|andq|xorq|jmp|jle|jl|je|jne|jge|jg|call|ret|pushq|popq|"."byte|"."word|"."long|"."quad|"."pos|"."align|halt|nop|iaddq
Letter        [a-zA-Z]
Digit         [0-9]
Ident         {Letter}({Letter}|{Digit}|_)*
Hex           [0-9a-fA-F]
Blank         [ \t]
Newline       [\n\r]
Return        [\r]
Char          [^\n\r]
Reg           %rax|%rcx|%rdx|%rbx|%rsi|%rdi|%rsp|%rbp|%r8|%r9|%r10|%r11|%r12|%r13|%r14

%x ERR COM NEWLINE INLINE
%%

<INITIAL,NEWLINE>{Char}*{Return}*       { save_line(yytext); yyless(0); BEGIN INLINE; } /* Snarf input line */
<INITIAL,NEWLINE>{Newline}              { save_line(""); yyless(0); BEGIN INLINE; } /* Snarf empty input line */
<INLINE>{
    #{Char}*{Return}*{Newline}      {finish_line(); lineno++; BEGIN NEWLINE;}
    "//"{Char}*{Return}*{Newline}   {finish_line(); lineno++; BEGIN NEWLINE;}
    "/*"{Char}*{Return}*{Newline}   {finish_line(); lineno++; BEGIN NEWLINE;}
    {Blank}*{Return}*{Newline}      {finish_line(); lineno++; BEGIN NEWLINE;}
    <<EOF>>                         {finish_line(); lineno++; yyterminate();}
}

<INLINE>{
    {Blank}+          ;
    "$"+              ;
    {Instr}           add_instr(yytext);
    {Reg}             add_reg(yytext);
    [-]?{Digit}+      add_num(atoll(yytext));
    "0"[xX]{Hex}+     add_num(atollh(yytext));
    [():,]            add_punct(*yytext);
    {Ident}           add_ident(yytext);
    {Char}            {; BEGIN ERR;}
}
<ERR>{Char}*{Newline} {fail("Invalid line"); lineno++; BEGIN NEWLINE;}
%%

unsigned int atoh(const char *s)
{
    return(strtoul(s, NULL, 16));
}
