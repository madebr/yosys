circuit MyTop :
    module MyModule :
        input in: UInt
        output out: UInt[10]
        out[4] <= in
