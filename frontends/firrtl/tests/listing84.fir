circuit Foo :
     module Foo :
       input a: UInt
       skip
     module Bar :
      input a: UInt<1>
      output b: UInt<1>
      when a:
          b <= a
      else:
        b <= not(a)
