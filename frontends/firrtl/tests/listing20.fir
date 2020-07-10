circuit MyTop :
    module MyModule :
        input a: UInt
        input b: UInt
        output myport1 : UInt
        output myport2 : UInt
        myport1 <= a
        myport1 <= b
        myport2 <= a
