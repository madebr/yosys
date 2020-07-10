circuit MyTop :
    module MyModule :
        input a: UInt
        wire myclock: Clock
        wire myreset: UInt<1>
        wire myinit: SInt
        reg myreg: SInt, myclock with: (reset => (myreset, myinit))
