# RhoSON -- Rholang Structural Object Notation

`rhoson.k` defines a function `#kind` from Names and Procs to "structural type" RhoMaps, think AST.

E.g. `#kind( @1!(Nil,true) ) ==> { "send" : { "linear" : { "chan" : { "quote" : { "int" : 1 } } , "msg" : { 0 : { "nil" : Nil } , 1 : { "bool" : true } } } } }`

See `/tests` for more examples.