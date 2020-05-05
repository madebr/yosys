/*
 *  yosys -- Yosys Open SYnthesis Suite
 *
 *  Copyright (C) 2020  Alberto Gonzalez <boqwxp@airmail.cc>
 *
 *  Permission to use, copy, modify, and/or distribute this software for any
 *  purpose with or without fee is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 *  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 *  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 *  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 *  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 *  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 */

%{

#ifdef __clang__
// bison generates code using the 'register' storage class specifier
#pragma clang diagnostic ignored "-Wdeprecated-register"
#endif

#include "kernel/log.h"
#include "firrtl_parser.tab.hh"

USING_YOSYS_NAMESPACE
using namespace FIRRTL_FRONTEND;

#define YYSTYPE FRONTEND_FIRRTL_YYSTYPE
#define YYLTYPE FRONTEND_FIRRTL_YYLTYPE

YOSYS_NAMESPACE_BEGIN
namespace FIRRTL_FRONTEND {
	std::vector<std::string> fn_stack;
	std::vector<int> ln_stack;
	YYLTYPE real_location;
	YYLTYPE old_location;

}
YOSYS_NAMESPACE_END

#define YY_INPUT(buf,result,max_size) \
	result = readsome(*FIRRTL_FRONTEND::lexin, buf, max_size)

#define YY_USER_ACTION \
       old_location = real_location; \
       real_location.first_line = real_location.last_line; \
       real_location.first_column = real_location.last_column; \
       for(int i = 0; yytext[i] != '\0'; ++i){ \
               if(yytext[i] == '\n') { \
                       real_location.last_line++; \
                       real_location.last_column = 1; \
               } \
               else { \
                       real_location.last_column++; \
               } \
       } \
    (*yylloc) = real_location;

#define YY_BREAK \
    (*yylloc) = old_location; \
    break;

#undef YY_BUF_SIZE
#define YY_BUF_SIZE 65536

extern int frontend_firrtl_yylex(YYSTYPE *yylval_param, YYLTYPE *yyloc_param);

%}

%option yylineno
%option noyywrap
%option nounput
%option bison-locations
%option bison-bridge
%option prefix="frontend_firrtl_yy"

%x COMMENT
%x STRING

%%

<INITIAL>; {
	BEGIN(COMMENT);
}

<COMMENT>. {}
<COMMENT>\n { BEGIN(INITIAL); }

<INITIAL>\" { BEGIN(STRING); }
<STRING>[^\"]*\" {
	yylval->string = new std::string(yytext, strlen(yytext) - 1);
	BEGIN(INITIAL);
}

"b""-"?[01_]+ {
	yylval->string = new std::string(yytext);
	return TOK_BASED_CONSTVAL;
}

"o""-"?[0-7_]+ {
	yylval->string = new std::string(yytext);
	return TOK_BASED_CONSTVAL;
}

"x""-"?[0-9A-F_]+ {
	yylval->string = new std::string(yytext);
	return TOK_BASED_CONSTVAL;
}

"-"[0-9]+ {
	yylval->string = new std::string(yytext);
	return TOK_NEG_DECIMAL_CONSTVAL;
}

[0-9]+ {
	yylval->string = new std::string(yytext);
	return TOK_DECIMAL_CONSTVAL;
}

"circuit" { return TOK_CIRCUIT; }
"module" { return TOK_MODULE; }
"extmodule" { return TOK_EXTMODULE; }
"input" { return TOK_INPUT; }
"output" { return TOK_OUTPUT; }
"wire" { return TOK_WIRE; }
"reg" { return TOK_REG; }
"mem" { return TOK_MEM; }
"inst" { return TOK_INST; }
"data-type" { return TOK_DATA_TYPE; }
"depth" { return TOK_DEPTH; }
"read-latency" { return TOK_READ_LATENCY; }
"write-latency" { return TOK_WRITE_LATENCY; }
"read-under-write" { return TOK_READ_UNDER_WRITE; }
"node" { return TOK_NODE; }
"mux" { return TOK_MUX; }
"validif" { return TOK_VALIDIF; }
"with" { return TOK_WITH; }
"reset" { return TOK_RESET; }
"UInt" { return TOK_UINT; }
"SInt" { return TOK_SINT; }
"Clock" { return TOK_CLOCK; }
"add" { return TOK_ADD; }
"sub" { return TOK_SUB; }
"mul" { return TOK_MUL; }
"div" { return TOK_DIV; }
"mod" { return TOK_MOD; }
"lt" { return TOK_LT; }
"leq" { return TOK_LEQ; }
"gt" { return TOK_GT; }
"geq" { return TOK_GEQ; }
"eq" { return TOK_EQ; }
"neq" { return TOK_NEQ; }
"pad" { return TOK_PAD; }
"asUInt" { return TOK_ASUINT; }
"asSInt" { return TOK_ASSINT; }
"shl" { return TOK_SHL; }
"shr" { return TOK_SHR; }
"dshl" { return TOK_DSHL; }
"dshr" { return TOK_DSHR; }
"cvt" { return TOK_CVT; }
"neg" { return TOK_NEG; }
"not" { return TOK_NOT; }
"andr" { return TOK_ANDR; }
"and" { return TOK_AND; }
"orr" { return TOK_ORR; }
"or" { return TOK_OR; }
"xorr" { return TOK_XORR; }
"xor" { return TOK_XOR; }
"cat" { return TOK_CAT; }
"bits" { return TOK_BITS; }
"head" { return TOK_HEAD; }
"tail" { return TOK_TAIL; }

[a-zA-Z_][a-zA-Z0-9_]* {
	yylval->string = new std::string(yytext);
	return TOK_ID;
}

"," {}
<INITIAL>. { return *yytext; }
<*>. { BEGIN(INITIAL); return *yytext; }

%%

// this is a hack to avoid the 'yyinput defined but not used' error msgs
void *frontend_firrtl_avoid_input_warnings() {
	return (void*)&yyinput;
}

