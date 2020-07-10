circuit MyTop :
    module MyModule :
        input in: {a :UInt<1>, b: UInt<2>[3]}
        input clk: Clock
        output out: UInt
        wire c: UInt
        c <= in.a
        reg r: UInt[3], clk
        r <= in.b
        when c :
            r[1] <= in.a
        out <= r[0]
