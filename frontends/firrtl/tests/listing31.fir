circuit MyTop :
    module MyModule :
        input in: {flip a:UInt, b:UInt}
        output out: {flip a : UInt, b:UInt}
        wire w: {flip a:UInt, b:UInt}
        in is invalid
        out is invalid
        w is invalid
