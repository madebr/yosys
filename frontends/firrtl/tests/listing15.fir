circuit MyTop :
    module MyModule :
        ; FIXME: can this be split among multiple lines?
        output a : {real: {word:UInt<32>, valid:UInt<1>, flip ready:UInt<1>}, imag: {word:UInt<1>, valid:UInt<1>, flip ready:UInt<1>}}
