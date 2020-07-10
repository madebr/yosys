circuit MyTop :
    module MyModule :
        wire clk:Clock
        wire condition:UInt<1>
        wire a:UInt
        wire b:UInt
        printf(clk, condition, "a in hex: %x, b in decimal:%d.\n", a, b)
