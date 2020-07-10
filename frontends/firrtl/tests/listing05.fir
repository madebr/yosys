circuit MyTop :
    module MyMem :
        ; FIXME: can this be split among multiple lines?
        input r1: {flip data: {real: SInt <16>, imag: SInt<16>}, addr: UInt<8>, en : UInt<1>, clk : Clock}
        input r2: {flip data: {real: SInt <16>, imag: SInt<16>},addr: UInt<8>, en: UInt<1>,clk : Clock}
        input w: {data: {real: SInt<16>, imag: SInt<16>}, mask: {real: UInt<1>, imag: UInt<1>}, addr: UInt<8>, en: UInt<1>, clk: Clock}
    ;    input r1: {flip data: {real: SInt <16>,
    ;               imag: SInt<16>},
    ;               addr: UInt<8>,
    ;               en : UInt<1>,
    ;               clk : Clock}
    ;    input r2: {flip data: {real: SInt <16>,
    ;               imag: SInt<16>},
    ;               addr: UInt<8>,
    ;               en: UInt<1>,clk : Clock}
    ;    input w: {data: {real: SInt<16>, imag: SInt<16>},
    ;              mask: {real: UInt<1>, imag: UInt<1>},
    ;              addr: UInt<8>,
    ;              en: UInt<1>,
    ;              clk: Clock}
;
