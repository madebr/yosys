circuit MyCircuit:
    module MyModule:
        input cnd: UInt<1>
        input clk: Clock
        printf(clk, cnd, "this is text
")
