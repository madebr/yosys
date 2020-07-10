circuit MyTop :
    module MyModule :
        input a: UInt
        mem mymem :
            data-type => {real:SInt<16>, imag:SInt<16>}
            depth => 256
            reader => r1
            reader => r2
            writer => w
            read-latency => 0
            write-latency => 1
            read-under-write => blah
