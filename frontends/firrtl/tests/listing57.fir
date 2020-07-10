circuit MyTop :
    module RWMem :
        input rw: {wmode:UInt<1>, flip rdata: T, wdata: T, wmask: M, addr: UInt<N>, en : UInt<1>, clk : Clock}
