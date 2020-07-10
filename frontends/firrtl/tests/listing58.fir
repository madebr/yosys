circuit MyTop :
    module MyModule :
        input a: UInt
        output b: UInt
        b <= a
    module Top :
        inst myinstance of myModule
