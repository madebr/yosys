circuit MyTop :
    module MyModule :
        input a: UInt
        input valid: UInt<1>
        output c: UInt
        c <= validif(valid, a)
