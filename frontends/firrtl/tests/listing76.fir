circuit MyTop :
    module MyModule :
        input in: UInt
        input default: UInt[2][2]
        input n: UInt <1>
        input m: UInt <1>
        output out: UInt[2][2]
        out <= default
        when and(eq(n, UInt(0)), eq(m, UInt(0))) :
            out[0][0] <= in
        else when and(eq (n, UInt(0)), eq(m, UInt(1))) :
            out[0][1] <= in
        else when and(eq (n, UInt(1)), eq(m, UInt(0))) :
            out[1][0] <= in
        else when and(eq (n, UInt(1)), eq(m, UInt(1))) :
            out[1][1] <= in
