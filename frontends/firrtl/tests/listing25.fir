circuit MyTop :
    module MyModule :
        output a: UInt
        input b: UInt
        output c: UInt
        input d: UInt
        a <= b
        skip
        c <= d
