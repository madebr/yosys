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

//%code top {
//#include "firrtl_internal.h"
//}

%code {

#include "frontends/firrtl/firrtl_internal.h"
#include "frontends/firrtl/firrtl_lexer.h"

#include <cstring>

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

}


%code requires {
/* Dependencies of the argument(s) of yyparse */
#include "frontends/firrtl/firrtl_frontend.h"

/* Dependencies of the value type */
#include <string>
}

%code provides {
YOSYS_NAMESPACE_BEGIN

namespace FIRRTL_FRONTEND
{
	const char *token_name(int);
}

YOSYS_NAMESPACE_END
}

%union {
	std::string *string;
}

%token TOK_INDENT TOK_DEDENT
%token TOK_CIRCUIT TOK_MODULE TOK_EXTMODULE TOK_INPUT TOK_OUTPUT
%token TOK_UINT TOK_SINT TOK_FIXED TOK_CLOCK TOK_ANALOG
%token TOK_SHIFTLEFT TOK_SHIFTRIGHT
%token TOK_FLIP
%token TOK_CONNECT TOK_PARTIAL TOK_DEFINE
%token TOK_WHEN TOK_ELSE TOK_SKIP
%token TOK_MUX TOK_VALIDIF
%token TOK_NODE
%token TOK_WIRE TOK_IS TOK_INVALID
%token TOK_REG TOK_WITH TOK_RESET
%token TOK_ATTACH

%token TOK_MEM
/* This effectively makes depth, reader, writer ... reserved keywords. Do we want this? */
%token TOK_DEPTH TOK_DATA_TYPE TOK_READ_LATENCY TOK_WRITE_LATENCY TOK_READ_UNDER_WRITE TOK_READER TOK_WRITER TOK_READWRITER
%token TOK_UNDEFINED TOK_OLD TOK_NEW
%token TOK_INST TOK_OF

/* Are the tokens for these functions needed? */
%token TOK_STOP TOK_PRINTF

%token TOK_ADD TOK_SUB TOK_MUL TOK_DIV TOK_REM
%token TOK_LT TOK_LEQ TOK_EQ TOK_NEQ TOK_GT TOK_GEQ
%token TOK_PAD TOK_ASUINT TOK_ASSINT TOK_ASFIXED TOK_ASCLOCK
%token TOK_SHL TOK_SHR TOK_DSHL TOK_DSHR TOK_CVT TOK_NEG TOK_NOT
%token TOK_AND TOK_OR TOK_XOR TOK_ANDR TOK_ORR TOK_XORR
%token TOK_CAT TOK_BITS TOK_HEAD TOK_TAIL
%token TOK_INCP TOK_DECP TOK_SETP

/* FIXME: change type: base + value */
%token <string> TOK_INT
//%token <string> TOK_CONSTVAL TOK_BASED_CONSTVAL TOK_NEG_DECIMAL_CONSTVAL TOK_DECIMAL_CONSTVAL
%token <string> TOK_ID TOK_QUOTED_STRING

%destructor { delete $$; } <string>

// operator precedence
// TODO

%no-lines
%define api.prefix {frontend_firrtl_yy}
%define api.pure full
%param { firrlt_scanner_t lexer }

%define parse.error verbose
%verbose
%define parse.lac full
//%param { Yosys::FIRRTL_FRONTEND::firrtl_state_t *state }

%debug
%locations

// FIXME: Allow no conflicts! IMPORTANT!!!!!
//%expect 0

%start circuit

%%

circuit:
	TOK_CIRCUIT TOK_ID ':' opt_info_attr TOK_INDENT module_list_opt TOK_DEDENT ;

opt_info_attr:
	'@' '[' TOK_QUOTED_STRING ']' |
	%empty ;

module_list_opt:
	module_list |
	TOK_SKIP ;

module_list:
	module_list module |
	module ;

module:
	TOK_MODULE TOK_ID ':' opt_info_attr TOK_INDENT module_body TOK_DEDENT |
	TOK_EXTMODULE TOK_ID ':' opt_info_attr TOK_INDENT extmodule_body TOK_DEDENT ;

module_body:
	port_list stmts ; // module requires at least one port + one statement

extmodule_body:
	port_list ;

port_list:
	port_list port |
	port ;

port:
	port_dir TOK_ID ':' type opt_info_attr;

port_dir:
	TOK_INPUT |
	TOK_OUTPUT ;

type:
	TOK_UINT opt_width |
	TOK_SINT opt_width |
	TOK_FIXED opt_width opt_binary_point |
	TOK_CLOCK |
	TOK_ANALOG opt_width |
	'{' fields '}' |
	type '[' TOK_INT ']' ; //FIXME: type unfinished! (argument is int

fields:
	fields ',' field |
	field ;

field:
	opt_flip TOK_ID ':' type ;

opt_flip:
	TOK_FLIP |
	%empty ;

opt_binary_point:
	TOK_SHIFTLEFT TOK_INT TOK_SHIFTRIGHT |
	%empty ;

opt_width:
	'<' TOK_INT '>' |
	%empty ;

/* Better name for stmts? */
stmts:
	stmt stmts_opt ;

stmts_opt:
	stmts_opt stmt |
	%empty ;

stmt:
	TOK_WIRE TOK_ID ':' type opt_info_attr |
	TOK_REG TOK_ID ':' type ',' expr opt_reg_with_spec opt_info_attr |
	TOK_MEM TOK_ID ':' opt_info_attr TOK_INDENT mem_properties TOK_DEDENT |
	TOK_INST TOK_ID TOK_OF TOK_ID opt_info_attr |
	TOK_NODE TOK_ID '=' expr opt_info_attr |
	expr TOK_CONNECT expr opt_info_attr |
	expr TOK_PARTIAL expr opt_info_attr |
	expr TOK_IS TOK_INVALID opt_info_attr |
	TOK_ATTACH '(' expr_varargs ')' opt_info_attr |
	stmt_when |
	TOK_STOP '(' expr ',' expr ',' TOK_INT ')' opt_info_attr |
	TOK_PRINTF '(' expr ',' expr ',' TOK_QUOTED_STRING opt_expr_varargs_comma ')' opt_info_attr |
	TOK_SKIP opt_info_attr ;
	/* TODO */

stmt_when:
	TOK_WHEN expr ':' opt_info_attr cond_body opt_else ;

cond_body: /* use midrules for context? Or do this at postprocessing? */
	TOK_INDENT stmts TOK_DEDENT |
	stmt ;

opt_else:
	TOK_ELSE ':' cond_body |
	TOK_ELSE stmt_when |
	%empty ;

expr_varargs:
	expr_varargs ',' expr |
	expr ;

opt_expr_varargs_comma:
	',' expr_varargs |
	%empty ;

int_varargs:
	int_varargs ',' TOK_INT |
	TOK_INT ;

opt_int_varargs_comma:
	',' int_varargs |
	%empty ;

expr:
	TOK_UINT opt_width '(' TOK_INT ')' |
	TOK_UINT opt_width '(' TOK_QUOTED_STRING ')' |
	TOK_SINT opt_width '(' TOK_INT ')' |
	TOK_SINT opt_width '(' TOK_QUOTED_STRING ')' |
	TOK_ID |
	expr '.' TOK_ID |
	expr '[' TOK_INT ']' |
	expr '[' expr ']' |
	TOK_MUX '(' expr ',' expr ',' expr ')' |
	TOK_VALIDIF '(' expr ',' expr ')' |
	primitive_op '(' expr_varargs opt_int_varargs_comma ')' ;

mem_properties:
	mem_properties mem_property |
	mem_property ;

mem_property:
	TOK_DATA_TYPE TOK_DEFINE type |
	TOK_DEPTH TOK_DEFINE TOK_INT |
	TOK_READ_LATENCY TOK_DEFINE TOK_INT |
	TOK_WRITE_LATENCY TOK_DEFINE TOK_INT |
	TOK_READ_UNDER_WRITE TOK_DEFINE mem_ruw |
	TOK_READER TOK_DEFINE TOK_ID |
	TOK_WRITER TOK_DEFINE TOK_ID |
	TOK_READWRITER TOK_DEFINE TOK_ID ;

mem_ruw:
	TOK_OLD |
	TOK_NEW |
	TOK_UNDEFINED ;

primitive_op:
	TOK_ADD |
	TOK_SUB |
	TOK_MUL |
	TOK_DIV |
	TOK_REM |
	TOK_LT |
	TOK_LEQ |
	TOK_GT |
	TOK_GEQ |
	TOK_EQ |
	TOK_NEQ |
	TOK_PAD |
	TOK_ASUINT |
	TOK_ASSINT |
	TOK_ASFIXED |
	TOK_ASCLOCK |
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
	TOK_INCP |
	TOK_DECP |
	TOK_SETP ;

opt_reg_with_spec:
	TOK_WITH ':' '(' TOK_RESET TOK_DEFINE '(' expr ',' expr ')' ')' |
	%empty ;

%%

YOSYS_NAMESPACE_BEGIN

namespace FIRRTL_FRONTEND {

const char *token_name(int token) {
	return yytname[yytranslate[token]];
}

}

YOSYS_NAMESPACE_END
