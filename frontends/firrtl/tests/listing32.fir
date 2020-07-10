circuit MyTop :
    module MyModule :
        input in: {flip a:UInt, b:UInt}
        output out: {flip a : UInt, b:UInt}
        wire w: {flip a:UInt, b:UInt}
        in.a is invalid
        out.b is invalid
        w.a is invalid
        w.b is invalid
