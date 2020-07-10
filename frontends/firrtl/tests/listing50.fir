circuit MyTop :
    module MyModule :
        wire x: {a:UInt, b:UInt}
        wire y: {a:UInt, b:UInt}
        wire c: UInt<1>
        wire w: {a:UInt, b:UInt}
        w.a <= mux(c, y.a, x.a)
        w.b <= mux(c, y.b, x.b)
