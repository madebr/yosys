circuit MyTop :
    module MyModule :
        wire pred : UInt<1>
        wire a: SInt
        wire b: SInt
        node mynode = mux(pred, a, b)
