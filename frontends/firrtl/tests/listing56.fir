circuit MyTop :
    module WoMem :
        input w: {data: T, mask: M, addr: UInt<N>, en : UInt<1>, clk : Clock}
