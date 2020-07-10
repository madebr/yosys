circuit MyTop :
    module MyModule :
        wire a: UInt
        wire c: UInt<1>
        wire w: UInt
        w is invalid
        when c :
            w <= a
