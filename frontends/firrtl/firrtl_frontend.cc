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

#include "kernel/yosys.h"
#include "libs/sha1/sha1.h"
#include "frontends/firrtl/firrtl_frontend.h"

YOSYS_NAMESPACE_BEGIN
using namespace FIRRTL_FRONTEND;

struct FirrtlFrontend : public Frontend {
	FirrtlFrontend() : Frontend("firrtl", "read modules from FIRRTL file") { }
	void help() YS_OVERRIDE
	{
		//   |---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|
		log("\n");
		log("    read_firrtl [options] [filename]\n");
		log("\n");
		log("Load modules from a (Lo)FIRRTL file to the current design.\n");
		log("\n");
		log("    -yydebug\n");
		log("        enable parser debug output\n");
		log("\n");
		log("\n");
	}
	void execute(std::istream *&f, std::string filename, std::vector<std::string> args, RTLIL::Design *design) YS_OVERRIDE
	{
		frontend_firrtl_yydebug = false;

		size_t argidx;
		for (argidx = 1; argidx < args.size(); argidx++) {
			std::string arg = args[argidx];
			if (arg == "-yydebug") {
				frontend_firrtl_yydebug = true;
				continue;
			}
			break;
		}
		extra_args(f, filename, args, argidx);

		log_header(design, "Executing FIRRTL frontend: %s\n", filename.c_str());

		lexin = f;
		current_filename = filename;

		frontend_firrtl_yyset_lineno(1);
		frontend_firrtl_yyrestart(NULL);
		frontend_firrtl_yyparse();
		frontend_firrtl_yylex_destroy();

		//TODO FIXME do postprocessing

		log("Successfully finished FIRRTL frontend.\n");
	}
} FirrtlFrontend;

YOSYS_NAMESPACE_END

// the yyerror function used by bison to report parser errors
void frontend_firrtl_yyerror(char const *fmt, ...)
{
	va_list ap;
	char buffer[1024];
	char *p = buffer;
	va_start(ap, fmt);
	p += vsnprintf(p, buffer + sizeof(buffer) - p, fmt, ap);
	va_end(ap);
	p += snprintf(p, buffer + sizeof(buffer) - p, "\n");
	YOSYS_NAMESPACE_PREFIX log_file_error(YOSYS_NAMESPACE_PREFIX FIRRTL_FRONTEND::current_filename,
			frontend_firrtl_yyget_lineno(), "%s", buffer);
	exit(1);
}
