circuit MyTop :
    module RWMem :
        input rw: {wmode:UInt<1>, flip rdata: UInt, wdata: UInt, wmask: UInt, addr: UInt<256>, en : UInt<1>, clk : Clock}
        ;input rw: {wmode:UInt<1>, flip rdata: T, wdata: T, wmask: M, addr: UInt<N>, en : UInt<1>, clk : Clock}
        skip
