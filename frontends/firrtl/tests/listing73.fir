circuit MyTop :
    module MyModule :
        input in: UInt
        input default: UInt[3]
        input n: UInt<2>
        output out: UInt[3]
        out <= default
        out[n] <= in
