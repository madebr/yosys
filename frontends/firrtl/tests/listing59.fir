circuit MyTop :
    module MyModule :
        wire clk:Clock
        wire halt:UInt<1>
        stop(clk,halt,42)
