circuit MyCircuit:
    module MyModule:
        output o: {a: UInt, b: UInt, c: UInt}
        input i: {a: UInt, b: UInt}
        o < - i
