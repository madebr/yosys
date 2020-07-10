circuit MyTop :
    module MyModule :
        input en: UInt<1>
        input a: UInt
        wire w: UInt
        when en :
            w <= a
