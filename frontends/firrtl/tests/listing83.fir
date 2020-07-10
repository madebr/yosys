circuit MyTop :
    module MyModule :
        input in$a: UInt<1>
        input in$b$0: UInt<2>
        input in$b$1: UInt<2>
        input in$b$2: UInt<2>
        input clk: Clock
        output out: UInt <2>
        wire c: UInt <1>
        c <= in$a
        reg r$0: UInt <2 > , clk
        reg r$1: UInt <2 > , clk
        reg r$2: UInt <2 > , clk
        r$0 <= in$b$0
        r$1 <= mux(c, in$a, in$b$1)
        r$2 <= in$b$2
        out <= r$0
