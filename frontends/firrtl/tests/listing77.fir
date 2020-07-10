circuit MyTop :
    module MyModule :
        input a: UInt
        input b: UInt
        input sel: UInt<1>
        output c: UInt
        c <= mux(sel, a, b)
