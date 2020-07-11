circuit MyTop :
    module WoMem :
        input w: {data: UInt, mask: UInt, addr: UInt<256>, en : UInt<1>, clk : Clock}
        ;input w: {data: T, mask: M, addr: UInt<N>, en : UInt<1>, clk : Clock}
        skip
