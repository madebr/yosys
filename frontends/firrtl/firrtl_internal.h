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

#ifndef FIRRTL_INTERNAL_H
#define FIRRTL_INTERNAL_H

#include "frontends/firrtl/firrtl_parser.tab.hh"

// definition by flex
//   int frontend_firrtl_yylex_init(firrlt_scanner_t *lexer);
//   void frontend_firrtl_yyset_extra(Yosys::FIRRTL_FRONTEND::firrtl_state_t *state, firrlt_scanner_t scanner);
//   void frontend_firrtl_yyset_extra(Yosys::FIRRTL_FRONTEND::firrtl_state_t *state, firrlt_scanner_t scanner);
//   int frontend_firrtl_yylex_destroy (firrlt_scanner_t lexer);
//   extern int frontend_firrtl_yylex(FRONTEND_FIRRTL_YYSTYPE *yylval_param, FRONTEND_FIRRTL_YYLTYPE *yylloc_param, firrlt_scanner_t lexer);
//


// functions required by bison
void frontend_firrtl_yyerror(FRONTEND_FIRRTL_YYLTYPE *, Yosys::FIRRTL_FRONTEND::firrtl_state_t *, char const *fmt, ...);

YOSYS_NAMESPACE_BEGIN

namespace FIRRTL_FRONTEND
{
	struct firrtl_state_t {
		// lexer input stream
		std::istream *lexin = nullptr;

		// filename of current file
		std::string current_filename;

		// lexer string literal buffer
		std::string lex_buf_string_literal;

		// lexer number of dedent tokens left to emit
		unsigned nb_dedent_tokens{};

		// lexer need to emit an indent token?
		bool indent_token;

		// lexer indentation stack
		std::vector<int> indent_stack;

		// lexer location states
		FRONTEND_FIRRTL_YYLTYPE real_location;
		FRONTEND_FIRRTL_YYLTYPE old_location;

	};
}

YOSYS_NAMESPACE_END




//extern int frontend_firrtl_yydebug;
//void frontend_firrtl_yyrestart(FILE *f);
//int frontend_firrtl_yyparse(void);
//int frontend_firrtl_yylex_destroy(void);
//int frontend_firrtl_yyget_lineno(void);
//void frontend_firrtl_yyset_lineno (int);

#endif
