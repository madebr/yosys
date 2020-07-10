circuit MyTop :
    module MyModule :
        input a: UInt
        input b: UInt
        input c: UInt
        input d: UInt
        input c1: UInt <1>
        input c2: UInt <1>
        input c3: UInt <1>
        wire x: UInt
        when c1 :
            x <= a
        else :
            when c2 :
                x <= b
            else :
                when c3 :
                    x <= c
                else :
                    x <= d
