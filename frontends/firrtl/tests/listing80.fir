circuit MyTop :
    module MyModule :
        input a: UInt
        input b: UInt
        wire c: UInt
        wire d: UInt
        wire e: UInt
        wire f: Clock
        c <= add(a, b)
        d <= shl(a, 3)
        e <= bits(a, 7, 4)
        f <= asClock(x)
