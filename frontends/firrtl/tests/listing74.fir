circuit MyTop :
    module MyModule :
        input in: UInt
        input default: UInt[3]
        input n: UInt<2>
        output out: UInt[3]
        out <= default
        when eq(n, UInt(0)) :
            out[0] <= in
        else when eq(n, UInt(1)) :
            out[1] <= in
        else when eq(n, UInt(2)) :
            out[2] <= in
