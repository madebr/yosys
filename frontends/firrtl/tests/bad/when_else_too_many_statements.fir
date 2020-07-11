circuit MyCircuit:
    module MyModule:
        input a: UInt<1>
        output a: UInt<1>
        when a: skip skip else:
            b<=UInt(1)
