circuit MyCircuit:
    module MyModule:
        input i: UInt<1>
        output o: UInt<1>
        when i:
        o <= UInt("1")
        else:
        o <= UInt("0")
