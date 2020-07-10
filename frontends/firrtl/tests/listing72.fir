circuit MyTop :
    module MyModule :
        input in: UInt[3]
        input n: UInt<2>
        output out: UInt
        when eq(n, UInt(0)) :
            out <= in [0]
        else when eq(n, UInt(1)) :
            out <= in [1]
        else when eq(n, UInt(2)) :
            out <= in[2]
        else :
            out is invalid
