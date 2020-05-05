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

#ifndef FIRRTL_FRONTEND_H
#define FIRRTL_FRONTEND_H

#include "kernel/yosys.h"
#include "frontends/ast/ast.h"
#include <stdio.h>
#include <stdint.h>
#include <list>

YOSYS_NAMESPACE_BEGIN

namespace FIRRTL_FRONTEND
{
	// lexer input stream
	extern std::istream *lexin;
	extern std::string current_filename;
}

YOSYS_NAMESPACE_END

// the usual bison/flex stuff
extern int frontend_firrtl_yydebug;
void frontend_firrtl_yyerror(char const *fmt, ...);
void frontend_firrtl_yyrestart(FILE *f);
int frontend_firrtl_yyparse(void);
int frontend_firrtl_yylex_destroy(void);
int frontend_firrtl_yyget_lineno(void);
void frontend_firrtl_yyset_lineno (int);

#endif
