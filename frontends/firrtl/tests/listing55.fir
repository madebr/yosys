circuit MyTop :
    module RoMem :
        input r: {flip data: {real: SInt <16>, imag: SInt<16>}, addr: UInt<8>, en : UInt<1>, clk : Clock}
        skip
