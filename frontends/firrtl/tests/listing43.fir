circuit MyTop :
    module MyModule :
        input a: UInt
        input b: UInt
        input en: UInt<1>
        input clk: Clock
        when en :
            reg myreg1 : UInt, clk
            myreg1 <= a
        else :
            reg myreg2 : UInt, clk
            myreg2 <= b
