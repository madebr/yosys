circuit MyTop :
    module MyModule :
        input a: UInt
        wire a: UInt
        wire c: UInt<1>
        wire w: UInt
        w <= validif(c, a)
