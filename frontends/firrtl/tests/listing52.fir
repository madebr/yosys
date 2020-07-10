circuit MyTop :
    module MyModule :
        input a: UInt
        wire x: {a:UInt, b:UInt}
        wire y: UInt
        wire c: UInt<1>
        wire w: {a:UInt, b:UInt}
        w.a <= mux(c, y, x.a)
        w.b <= x.b
