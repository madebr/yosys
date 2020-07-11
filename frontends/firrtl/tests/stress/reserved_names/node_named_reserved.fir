circuit MyCircuit:
    module circuit:
        input a: UInt<1>
        wire w1: UInt<1>
        wire w2: UInt<1>
        node wire = mux(a, w1, w2)
