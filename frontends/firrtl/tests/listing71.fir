circuit MyTop :
    module MyModule :
        input in: UInt[3]
        input n: UInt<2>
        output out: UInt
        out <= in[n]
