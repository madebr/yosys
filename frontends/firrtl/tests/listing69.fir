circuit MyTop :
    module MyModule :
        input in: UInt
        output out: {a:UInt, b:UInt}
        out.a <= in
