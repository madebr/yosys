circuit MyTop :
    module MyModule :
        input a: UInt
        wire x: Analog<2>
        wire y: Analog<2>
        wire z: Analog<2>
        attach(x, y )      ; binary attach
        attach(z, y, x )    ; attach all three signals
