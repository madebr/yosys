circuit MyTop :
    module MyModule :
        input clk: Clock
        input num: UInt
        input den: UInt
        wire quot: Uint
        wire den: Uint
        wire o: UInt
        quot <= div(num, den)
        rest <= rem(num, den)
        o <= add(mul(den, div(num, den)),rem(num,den)))
        printf(clk, neq(num, o), "ERROR! num(=%d) != quot(=%d) * den(=%d) + rest(=%d)\n", num, quot, den, rest);
