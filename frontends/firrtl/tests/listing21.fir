circuit MyTop :
    module MyModule :
        input portx : {b:UInt, c: UInt}
        input porty : UInt
        output myport : {b:UInt, c: UInt}
        myport <= portx
        myport.b <= porty
