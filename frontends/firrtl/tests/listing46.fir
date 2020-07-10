circuit MyTop :
    module MyModule :
        input a: UInt
        wire a: UInt
        wire b: UInt
        wire c: UInt<1>
        wire w: UInt
        w <= mux(c, b, a)
