circuit MyTop :
    module MyModule :
        input myinput: {flip a:UInt, b:UInt[2]}
        output myoutput: {flip a:UInt, b:UInt[3], c:UInt}
        myinput.a <- myoutput.a
        myoutput.b[0] <- myinput.b[0]
        myoutput.b[1] <- myinput.b[1]
