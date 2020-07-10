circuit MyTop :
    module MyModule :
        input a: UInt
        output b: UInt
        b <= a
    module Top :
        input a: UInt
        inst myinstance of myModule
