circuit MyTop :
    module MyModule :
        input a: UInt
        input b: UInt
        input c: UInt<1>
        input e: UInt
        input f: UInt
        when c : a <= b else :
            e <= f
