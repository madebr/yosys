/*
 *  yosys -- Yosys Open SYnthesis Suite
 *
 *  Copyright (C) 2012  Clifford Wolf <clifford@clifford.at>
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
#include <list>
#include <stack>
#include <cstring>
#include "frontends/firrtl/firrtl_parser.tab.hh"
#include "kernel/log.h"

#define YYLEX_PARAM &yylval, &yylloc

USING_YOSYS_NAMESPACE
using namespace FIRRTL_FRONTEND;

YOSYS_NAMESPACE_BEGIN
namespace FIRRTL_FRONTEND {
	std::string current_filename;
	std::istream *lexin;
}
YOSYS_NAMESPACE_END

#define SET_AST_NODE_LOC(WHICH, BEGIN, END) \
    do { (WHICH)->location.first_line = (BEGIN).first_line; \
    (WHICH)->location.first_column = (BEGIN).first_column; \
    (WHICH)->location.last_line = (END).last_line; \
    (WHICH)->location.last_column = (END).last_column; } while(0)

#define SET_RULE_LOC(LHS, BEGIN, END) \
    do { (LHS).first_line = (BEGIN).first_line; \
    (LHS).first_column = (BEGIN).first_column; \
    (LHS).last_line = (END).last_line; \
    (LHS).last_column = (END).last_column; } while(0)

int frontend_firrtl_yylex(YYSTYPE *yylval_param, YYLTYPE *yyloc_param);

%}

%define api.prefix {frontend_firrtl_yy}
%define api.pure

/* The union is defined in the header, so we need to provide all the
 * includes it requires
 */
%code requires {
#include <string>
#include "frontends/firrtl/firrtl_frontend.h"
}

%union {
	std::string *string;
	bool boolean;
	int integer;
	char ch;
}

%token <string> TOK_CONSTVAL TOK_BASED_CONSTVAL TOK_NEG_DECIMAL_CONSTVAL TOK_DECIMAL_CONSTVAL
%token <string> TOK_ID TOK_QUOTED_STRING
%token TOK_CIRCUIT TOK_MODULE TOK_EXTMODULE TOK_INPUT TOK_OUTPUT TOK_UINT TOK_SINT TOK_CLOCK 
%token TOK_WIRE TOK_REG TOK_MEM TOK_INST TOK_NODE TOK_DATA_TYPE TOK_DEPTH TOK_READ_LATENCY
%token TOK_MUX TOK_RESET TOK_VALIDIF TOK_WITH TOK_ADD TOK_SUB TOK_MUL TOK_DIV TOK_MOD TOK_LT
%token TOK_LEQ TOK_GT TOK_GEQ TOK_EQ TOK_NEQ TOK_PAD TOK_ASUINT TOK_ASSINT TOK_SHL TOK_SHR
%token TOK_DSHL TOK_DSHR TOK_CVT TOK_NEG TOK_NOT TOK_AND TOK_OR TOK_XOR TOK_ANDR TOK_ORR
%token TOK_XORR TOK_CAT TOK_BITS TOK_HEAD TOK_TAIL
%token TOK_WRITE_LATENCY TOK_READ_UNDER_WRITE TOK_READER TOK_WRITER TOK_READWRITER

%type <string> identifier integral_number

// operator precedence
// TODO

%define parse.error verbose
%define parse.lac full

%debug
%locations

%%

circuit:
	TOK_CIRCUIT identifier ':' opt_info_attr TOK_INDENT opt_module_list TOK_DEDENT;

identifier:
	TOK_ID { $$ = $1; };

opt_info_attr:
	'@' '[' TOK_QUOTED_STRING ']' |
	/* empty */;

opt_module_list:
	opt_module_list opt_comma module |
	module |
	/* empty */;

module:
	TOK_MODULE identifier ':' opt_info_attr TOK_INDENT opt_port_list stmt TOK_DEDENT |
	TOK_EXTMODULE identifier ':' opt_info_attr opt_port_list;

opt_port_list:
	opt_port_list opt_comma port |	
	port |
	/* empty */;

opt_comma:
	',' |
	/* empty */;

port:
	port_dir identifier ':' type opt_info_attr;

port_dir:
	TOK_INPUT |
	TOK_OUTPUT;

type:
	TOK_UINT opt_width |
	TOK_SINT opt_width |
	TOK_CLOCK;
	/* TODO */

opt_width:
	'<' integral_number '>' |
	/* empty */;

stmt:
	opt_info_attr |
	stmt opt_info_attr |
	TOK_WIRE TOK_ID ':' type opt_info_attr |
	TOK_REG TOK_ID ':' type expr opt_reg_width_spec opt_info_attr |
	/* empty */;
	/* TODO */

expr:
	TOK_UINT opt_width '(' integral_number ')' |
	TOK_UINT opt_width '(' TOK_QUOTED_STRING ')' |
	TOK_SINT opt_width '(' integral_number ')' |
	TOK_SINT opt_width '(' TOK_QUOTED_STRING ')' |
	TOK_ID |
	expr '.' TOK_ID |
	expr '[' integral_number ']' |
	expr '[' expr ']' |
	TOK_MUX '(' expr opt_comma expr opt_comma expr ')' |
	TOK_VALIDIF '(' expr opt_comma expr ')' |
	primitive_op '(' opt_expr_list opt_comma opt_int_list ')' |
	;

opt_expr_list:
	opt_expr_list opt_comma expr |
	/* empty */;

opt_int_list:
	opt_int_list opt_comma integral_number |
	/* empty */;

primitive_op:
	TOK_ADD |
	TOK_SUB |
	TOK_MUL |
	TOK_DIV |
	TOK_MOD |
	TOK_LT |
	TOK_LEQ |
	TOK_GT |
	TOK_GEQ |
	TOK_EQ |
	TOK_NEQ |
	TOK_PAD |
	TOK_ASUINT |
	TOK_ASSINT |
	TOK_SHL |
	TOK_SHR |
	TOK_DSHL |
	TOK_DSHR |
	TOK_CVT |
	TOK_NEG |
	TOK_NOT |
	TOK_AND |
	TOK_OR |
	TOK_XOR |
	TOK_ANDR |
	TOK_ORR |
	TOK_XORR |
	TOK_CAT |
	TOK_BITS |
	TOK_HEAD |
	TOK_TAIL |
	TOK_BITS ;

opt_reg_width_spec:
	'(' TOK_WITH ':' '{' TOK_RESET '=' '>' '(' expr opt_comma expr ')' '}' ')' |
	/* empty */;

integral_number:
	TOK_CONSTVAL { $$ = $1; } |
	TOK_BASED_CONSTVAL { $$ = $1; } |
	TOK_DECIMAL_CONSTVAL { $$ = $1; } |
	TOK_NEG_DECIMAL_CONSTVAL { $$ = $1; };
