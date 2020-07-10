circuit MyCircuit:
    module MyModule:
        input a: UInt
        wire clk: Clock
        wire cond: UInt<1>
        printf(clk, cond, "")
        printf(clk, cond, "a string with all possible args:\n")
        printf(clk, cond, "binary: %b\n", i)
        printf(clk, cond, "decimal: %d\n", i)
        printf(clk, cond, "hexadecimal: %x\n", i)
        printf(clk, cond, "a percent: %%\n")
        printf(clk, cond, "some\ttabs\twhy\tnot?")
        printf(clk, cond, "A \"string\" with \"a lot of double quotes\"")
        printf(clk, cond, "A \'string\' with \'a lot of single quotes\'")
