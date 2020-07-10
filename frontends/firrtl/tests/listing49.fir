circuit MyTop :
    module MyModule :
        wire x: {a:UInt, b:UInt}
        wire y: {a:UInt, b:UInt}
        wire c: UInt<1>
        wire w: {a:UInt, b:UInt}
        w <= x
        when c :
            w <= y
