circuit MyTop :
    module MyModule :
        input a: UInt
        wire pred : UInt<1>
        wire a: SInt
        wire b: SInt
        node mynode = mux(pred, a, b)
