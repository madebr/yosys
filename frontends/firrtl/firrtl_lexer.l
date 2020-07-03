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

%top {
#include "frontends/firrtl/firrtl_parser.tab.hh"

#define YYSTYPE FRONTEND_FIRRTL_YYSTYPE
#define YYLTYPE FRONTEND_FIRRTL_YYLTYPE

#define yyscan_t firrlt_scanner_t
}

%{

#ifdef __clang__
// bison generates code using the 'register' storage class specifier
#pragma clang diagnostic ignored "-Wdeprecated-register"
#endif

#include "frontends/firrtl/firrtl_internal.h"
#include "kernel/log.h"

USING_YOSYS_NAMESPACE
using namespace FIRRTL_FRONTEND;

#define YYSTYPE FRONTEND_FIRRTL_YYSTYPE
#define YYLTYPE FRONTEND_FIRRTL_YYLTYPE
/*#define YY_EXTRA_TYPE  FIRRTL_FRONTEND::firrtl_state_t **/

#define YY_INPUT(buf, result, max_size) \
	do { \
		result = readsome(*yyextra->lexin, buf, max_size); \
	} while (0)

#define YY_USER_ACTION \
	yyextra->old_location = yyextra->real_location; \
	yyextra->real_location.first_line = yyextra->real_location.last_line; \
	yyextra->real_location.first_column = yyextra->real_location.last_column; \
	for(int i = 0; yytext[i] != '\0'; ++i){ \
		if (yytext[i] == '\n') { \
			yyextra->real_location.last_line++; \
			yyextra->real_location.last_column = 1; \
		} else { \
			yyextra->real_location.last_column++; \
		} \
	} \
	(*yylloc) = yyextra->real_location;

#define YY_BREAK \
    (*yylloc) = yyextra->old_location; \
    break;

// On initialization, make sure the indentation stack contains one item with zero level
#define YY_USER_INIT do { \
		yyextra->lex_buf_string_literal = ""; \
		yyextra->nb_dedent_tokens = 0; \
		yyextra->indent_token = false; \
		yyextra->indent_stack.resize(0); \
		yyextra->indent_stack.push_back(0); \
		yyextra->old_location = {1, 0, 1, 0}; \
		yyextra->real_location = {1, 0, 1, 0}; \
	} while (0)

#undef YY_BUF_SIZE
#define YY_BUF_SIZE 65536

%}

%option yylineno
%option bison-locations
%option bison-bridge
%option noyywrap
%option prefix="frontend_firrtl_yy"
%option reentrant
%option extra-type="::Yosys::FIRRTL_FRONTEND::firrtl_state_t *"

%x CODE
%x COMMENT
%x STRING

%%

%{
	if (yyextra->nb_dedent_tokens > 0) {
		yyextra->nb_dedent_tokens--;
		return TOK_DEDENT;
	}
	if (yyextra->indent_token) {
		yyextra->indent_token = false;
		return TOK_INDENT;
	}

	log_assert(yyextra->nb_dedent_tokens == 0);
	log_assert(!yyextra->indent_token);
	log_assert(yyextra->indent_stack.size() > 0);
%}

<INITIAL>{
[ ]*. {
	// Initial whitespace in document
	unput(yytext[yyleng-1]);
	if ((yyleng > 1) && (yytext[yyleng-1] != '\n')) {
		yyextra->indent_stack.push_back(yyleng-1);
	}
	BEGIN(CODE);
}
}

<COMMENT>{
\n { unput('\n'); BEGIN(CODE); }
.* { /* ignore comment body */ }
}


<CODE>{
; { BEGIN(COMMENT); }
\" { BEGIN(STRING); yyextra->lex_buf_string_literal.clear(); }
}


<STRING>{
\n {
	frontend_firrtl_yyerror(yylloc, yyextra, "Unexpected newline in string literal");
}
\" {
	BEGIN(CODE);
	yylval->string = new std::string(yyextra->lex_buf_string_literal);
	return TOK_QUOTED_STRING;
}
\\[nt\"]        { yyextra->lex_buf_string_literal += yytext; }
[^"\\\n]+          { yyextra->lex_buf_string_literal += yytext; }
.               { frontend_firrtl_yyerror(yylloc, yyextra, "Unsupported character"); }
<<EOF>> {
	frontend_firrtl_yyerror(yylloc, yyextra, "Unterminated string literal");
}
}


<CODE>{


\n[ ]*.? {
	if (yyleng != 1) {
		unput(yytext[yyleng-1]);
		if (yytext[yyleng-1] != '\n') {
			const int new_indentation_count = yyleng - 2;
			log_assert(new_indentation_count >= 0);


			int indent_pos = yyextra->indent_stack.size();
			do {
				--indent_pos;
			} while (yyextra->indent_stack[indent_pos] > new_indentation_count);

			const int nb_dedent = yyextra->indent_stack.size() - indent_pos - 1;
			const bool need_indent = yyextra->indent_stack[indent_pos] < new_indentation_count;

			yyextra->indent_stack.resize(yyextra->indent_stack.size() - nb_dedent);
			if (need_indent) {
				yyextra->indent_stack.push_back(new_indentation_count);
			}
			yyextra->nb_dedent_tokens = nb_dedent;
			yyextra->indent_token = need_indent;

			if (yyextra->nb_dedent_tokens) {
				--yyextra->nb_dedent_tokens;
				return TOK_DEDENT;
			}
			if (yyextra->indent_token) {
				yyextra->indent_token = false;
				return TOK_INDENT;
			}
		}
	}
}


[ ]+ {
	/* Ignore whitespace */
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

"circuit" {
	if (yyextra->indent_stack.size() > 1) {
		frontend_firrtl_yyerror(yylloc, yyextra, "circuit keyword cannot be indented");
	}
	return TOK_CIRCUIT;
}
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

"when" { return TOK_WHEN; }
"else" { return TOK_ELSE; }
"skip" { return TOK_SKIP; }

[a-zA-Z_][a-zA-Z0-9_$]* {
	yylval->string = new std::string(yytext);
	return TOK_ID;
}

. { return *yytext; }

<<EOF>> {
	if (yyextra->nb_dedent_tokens > 0) {
		--yyextra->nb_dedent_tokens;
		return TOK_DEDENT;
	}
	if (yyextra->indent_stack.size() > 1) {
		yyextra->indent_stack.pop_back();
		return TOK_DEDENT;
	}
	return 0;
}

}

%%

// this is a hack to avoid the 'yyinput defined but not used' error msgs
void *frontend_firrtl_avoid_input_warnings() {
	return (void*)&yyinput;
}
