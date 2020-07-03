
GENFILES += frontends/firrtl/firrtl_parser.tab.cc
GENFILES += frontends/firrtl/firrtl_parser.tab.hh
GENFILES += frontends/firrtl/firrtl_parser.output
GENFILES += frontends/firrtl/firrtl_lexer.cc
GENFILES += frontends/firrtl/firrtl_lexer.h

frontends/firrtl/firrtl_parser.tab.cc: frontends/firrtl/firrtl_parser.y
	$(Q) mkdir -p $(dir $@)
	$(P) $(BISON) -o $@ -d -r all -b frontends/firrtl/firrtl_parser $<

frontends/firrtl/firrtl_parser.tab.hh: frontends/firrtl/firrtl_parser.tab.cc

frontends/firrtl/firrtl_lexer.cc: frontends/firrtl/firrtl_lexer.l
	$(Q) mkdir -p $(dir $@)
	$(P) $(FLEX) -o frontends/firrtl/firrtl_lexer.cc --header-file=frontends/firrtl/firrtl_lexer.h $<

frontends/firrtl/firrtl_lexer.h: frontends/firrtl/firrtl_lexer.l

frontends/firrtl/firrtl_parser.tab.o: CXXFLAGS += -DYYMAXDEPTH=10000000

OBJS += frontends/firrtl/firrtl_parser.tab.o
OBJS += frontends/firrtl/firrtl_lexer.o
OBJS += frontends/firrtl/firrtl_frontend.o

