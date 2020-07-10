circuit MyTop :
    module MyModule :
        input a: UInt
        mem mymem :
            data-type => {real:SInt <16>, imag:SInt<16>}
            depth => 256
            reader => r1
            reader => r2
            writer => w
            read-latency => 0
            write-latency => 1
            read-under-write => undefined
        mem mymem_new :
            data-type => {real:SInt <16>, imag:SInt<16>}
            depth => 256
            reader => r1
            reader => r2
            writer => w
            read-latency => 0
            write-latency => 1
            read-under-write => new
        mem mymem_old :
            data-type => {real:SInt <16>, imag:SInt<16>}
            depth => 256
            reader => r1
            reader => r2
            writer => w
            read-latency => 0
            write-latency => 1
            read-under-write => old
        mem mymem_old :
            data-type => {real:SInt <16>, imag:SInt<16>}
            depth => 256
            reader => r1
            reader => r2
            writer => w
            read-latency => 0
            write-latency => 1
            read-under-write => old

;FIXME/CHECK: data-type read-latency write-latency read-under-write: can id's contain dash'es?
;FIXME/CHECK: depth/reader/writer/undefined: should they become keywords or not?
