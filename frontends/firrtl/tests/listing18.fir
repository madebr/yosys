circuit MyTop :
    module MyModule :
        input myinput: {flip a:UInt, b:UInt[2]}
        output myoutput: {flip a:UInt, b:UInt[3], c:UInt}
        myoutput <- myinput
