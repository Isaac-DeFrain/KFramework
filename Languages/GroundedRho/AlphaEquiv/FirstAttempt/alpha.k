// De Bruijn Index & Alpha Equivalence for Grounded Rho Calculus

/*
TODO:
 - how to handle several name listens & joins?
 - more tests for substitutions in continuations for listens on chan
 - create #mapify: function which computes the final deBruijn map of a Name
*/

require "../../grho.k"
require "../../Substitute/sub.k"

module ALPHA-SYNTAX
  import DOMAINS
  import GRHO-SYNTAX
  
  syntax       DBProc ::= "#deBruijn(" Int ";" Name  ";" Proc ";" Map ")" [function]
                        | "#deBruijn(" Int ";" Names ";" Proc ";" Map ")" [function]
  
  syntax         Proc ::= "#deBruijn(" Int ";" Proc ";" Map ")" [function]
                        | "new" Name  "in" "{" DBProc "}" [function]
                        | "new" Names "in" "{" DBProc "}" [function]
                        | "#dBound("   Int ";" Proc ";" Map ")" [function]
                        | Proc "#alpha" Proc
                        | "#mapify(" Name ")"
                        | "#mapify(" Proc ")"
                        | BoundProc

  syntax    BoundProc ::= "boundP(" Int ")"

  syntax         Name ::= "#deBruijn(" Int ";" Name ";" Map ")" [function]
                        | "#dBound("   Int ";" Name ";" Map ")" [function]
                        | BoundName

  syntax    BoundName ::= "boundN(" Int ")"

  syntax          Map ::= "#mapify(" Int ";" Name ";" Map ")" [function]
                        | "#mapify(" Int ";" Proc ";" Map ")" [function]

endmodule

module ALPHA
  import ALPHA-SYNTAX
  import AUXFUN
  import SUB

  configuration
  <T color="purple">
    <k> #deBruijn( 0 ; $PGM:Proc ; .Map ) </k>
  </T>

  syntax KResult ::= Proc | Name | Bool

// New Name Declarations - update mem map
  rule #deBruijn( I:Int ; new M:NameVar in { P:Proc } ; Mem:Map )
    => new boundN(I) in { #deBruijn( I +Int 1 ; P[ boundN(I) / M ] ; updateMap( Mem , M |-> boundN(I) ) ) }

  rule #deBruijn( I:Int ; new nv(M:NameVar , N:NameVar) in { P:Proc } ; Mem:Map )
    => new boundN(I) in { #deBruijn( I +Int 1 ; N ; P[ boundN(I) / M ] ; updateMap( Mem , M |-> boundN(I) ) ) }

  rule #deBruijn( I:Int ; new nv(M:NameVar , N:NameVars) in { P:Proc } ; Mem:Map )
    => new boundN(I) in { #deBruijn( I +Int 1 ; nv(N) ; P[ boundN(I) / M ] ; updateMap( Mem , M |-> boundN(I) ) ) }
  
  rule new A:NameVar in { #deBruijn( I:Int ; M:NameVar ; P:Proc ; Mem:Map ) } 
    => new nv(A , boundN(I)) in { #deBruijn( I +Int 1 ; P[ boundN(I) / M ] ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires notBool (M in keys(Mem))
  rule new A:NameVar in { #deBruijn( I:Int ; M:NameVar ; P:Proc ; Mem:Map ) } 
    => new nv(A , boundN(I)) in { #deBruijn( I +Int 1 ; P[ boundN(I) / Mem[M] ] ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires M in keys(Mem)

  rule new A:NameVar in { #deBruijn( I:Int ; nv(M:NameVar , N:NameVar) ; P:Proc ; Mem:Map ) } 
    => new nv(A , boundN(I)) in { #deBruijn( I +Int 1 ; N ; P[ boundN(I) / M ] ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires notBool (M in keys(Mem))
  rule new A:NameVar in { #deBruijn( I:Int ; nv(M:NameVar , N:NameVar) ; P:Proc ; Mem:Map ) } 
    => new nv(A , boundN(I)) in { #deBruijn( I +Int 1 ; N ; P[ boundN(I) / Mem[M] ] ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires M in keys(Mem)

  rule new A:NameVar in { #deBruijn( I:Int ; nv(M:NameVar , N:NameVars) ; P:Proc ; Mem:Map ) } 
    => new nv(A , boundN(I)) in { #deBruijn( I +Int 1 ; nv(N) ; P[ boundN(I) / M ] ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires notBool (M in keys(Mem))
  rule new A:NameVar in { #deBruijn( I:Int ; nv(M:NameVar , N:NameVars) ; P:Proc ; Mem:Map ) } 
    => new nv(A , boundN(I)) in { #deBruijn( I +Int 1 ; nv(N) ; P[ boundN(I) / Mem[M] ] ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires M in keys(Mem)  

  rule new A:NameVars in { #deBruijn( I:Int ; M:NameVar ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I)) in { #deBruijn( I +Int 1 ; P[ boundN(I) / M ] ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires notBool (M in keys(Mem))
  rule new A:NameVars in { #deBruijn( I:Int ; M:NameVar ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I)) in { #deBruijn( I +Int 1 ; P[ boundN(I) / Mem[M] ] ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires M in keys(Mem)

  rule new A:NameVars in { #deBruijn( I:Int ; nv(M:NameVar , N:NameVar) ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I)) in { #deBruijn( I +Int 1 ; N ; P[ boundN(I) / M ] ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires notBool (M in keys(Mem))
  rule new A:NameVars in { #deBruijn( I:Int ; nv(M:NameVar , N:NameVar) ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I)) in { #deBruijn( I +Int 1 ; N ; P[ boundN(I) / Mem[M] ] ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires M in keys(Mem)

  rule new A:NameVars in { #deBruijn( I:Int ; nv(M:NameVar , N:NameVars) ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I)) in { #deBruijn( I +Int 1 ; N ; P[ boundN(I) / M ] ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires notBool (M in keys(Mem))
  rule new A:NameVars in { #deBruijn( I:Int ; nv(M:NameVar , N:NameVars) ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I)) in { #deBruijn( I +Int 1 ; N ; P[ boundN(I) / Mem[M] ] ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires M in keys(Mem)

// Ground Terms
  rule #deBruijn( _:Int ; A:Ground ; _:Map ) => A
  rule #deBruijn( _:Int ; Nil ; _:Map ) => Nil
  rule #deBruijn( _:Int ; A:BoundName ; _:Map ) => A
  rule #deBruijn( _:Int ; A:BoundProc ; _:Map ) => A

// Parallel Composition
// Mem map propogates to both branchs
  rule #deBruijn( I:Int ; P:Proc | Q:Proc ; Mem:Map ) => #deBruijn(I;P;Mem) | #deBruijn(I;Q;Mem)

// Receives
  // variables become boundN with the appropriate index
  // previously boundN variables do not influence listening variables
  rule #deBruijn( I:Int ; for( Y:NameVar <- X:Name ){ P:Proc } ; Mem:Map ) 
    => for( boundN(I) <- #deBruijn(I;X;Mem) ){ #deBruijn( I +Int 1 ; P[ boundN(I) / Y] ; updateMap( Mem , Y |-> boundN(I) ) ) }

  // TODO: work on mem update
  // Continuation exit => Mem reset?
  rule #deBruijn( I:Int ; for( Y:Name <- X:Name ){ P:Proc } ; Mem:Map ) 
    => for( #dBound(I;Y;.Map) <- #deBruijn(I;X;Mem) ){ #deBruijn( I +Int 1 ; #sub(#dBound(I;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I;Y;.Map) ) ) }
  rule #deBruijn( I:Int ; for(   <- X:Name ){ P:Proc } ; Mem:Map ) => for(   <- #deBruijn(I;X;Mem) ){ #deBruijn( I +Int 1 ; P ; Mem ) }

  rule #deBruijn( I:Int ; for( Y:NameVar <= X:Name ){ P:Proc } ; Mem:Map ) 
    => for( boundN(I) <= #deBruijn(I;X;Mem) ){ #deBruijn( I +Int 1 ; P[ boundN(I) / Y] ; updateMap( Mem , Y |-> boundN(I) ) ) }
  rule #deBruijn( I:Int ; for( Y:NameVar <= X:Name ){ P:Proc } ; Mem:Map ) 
    => for( #dBound(I;Y;.Map) <= #deBruijn(I;X;Mem) ){ #deBruijn( I +Int 1 ; #sub(#dBound(I;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I;Y;.Map) ) ) }
  rule #deBruijn( I:Int ; for(   <= X:Name ){ P:Proc } ; Mem:Map ) => for(   <= #deBruijn(I;X;Mem) ){ #deBruijn( I +Int 1 ; P ; Mem ) }

  rule #deBruijn( I:Int ; for( Y:NameVar <! X:Name ){ P:Proc } ; Mem:Map ) 
    => for( boundN(I) <! #deBruijn(I;X;Mem) ){ #deBruijn( I +Int 1 ; P[ boundN(I) / Y] ; updateMap( Mem , Y |-> boundN(I) ) ) }
  rule #deBruijn( I:Int ; for( Y:NameVar <! X:Name ){ P:Proc } ; Mem:Map ) 
    => for( #dBound(I;Y;.Map) <! #deBruijn(I;X;Mem) ){ #deBruijn( I +Int 1 ; #sub(#dBound(I;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I;Y;.Map) ) ) }
  rule #deBruijn( I:Int ; for(   <! X:Name ){ P:Proc } ; Mem:Map ) => for(   <! #deBruijn(I;X;Mem) ){ #deBruijn( I +Int 1 ; P ; Mem ) }

// Sends
// index and map constant on name and proc
  rule #deBruijn( I:Int ; X:Name !  ( P:Proc ) ; Mem:Map ) => #deBruijn(I;X;Mem) !  ( #deBruijn(I;P;Mem) )
  rule #deBruijn( I:Int ; X:Name !! ( P:Proc ) ; Mem:Map ) => #deBruijn(I;X;Mem) !! ( #deBruijn(I;P;Mem) )

// Evals
// index is constant
  rule #deBruijn( I:Int ; * X:Name ; Mem:Map ) => * #deBruijn(I;X;Mem)

// Names
  rule #deBruijn( _:Int ; N:NameVar ; Mem:Map ) => N requires notBool (N in keys(Mem))
  rule #deBruijn( _:Int ; N:NameVar ; Mem:Map ) => Mem[N] requires N in keys(Mem)

  rule #deBruijn( _:Int ; P:ProcVar ; Mem:Map ) => P requires notBool (P in keys(Mem))
  rule #deBruijn( _:Int ; P:ProcVar ; Mem:Map ) => Mem[P] requires P in keys(Mem)

  // Quotes
  // index increases - this is not the desired semantics...
  rule #deBruijn( I:Int ; @ P:Proc ; Mem:Map ) => @ #deBruijn(I;P;Mem)

// Several Names
  // want to do something like #deBruijn(I;Y,Z) => #deBruijn(I;Y) , #deBruijn(I;Z) for several names
  // these name lists will only appear in listens, but can't make the appropriate substitutions in the continuation...
  
// Alpha Equivalence Predicate
  // checks synactic equality of De Bruijn index substituted terms
  rule #deBruijn( I:Int ; P:Proc #alpha Q:Proc ; Mem:Map) => #deBruijn(I;P;Mem) ==K #deBruijn(I;Q;Mem)

// Rule for deleting map from deBruijnified proc
//  rule #deBruijn( I:Int ; P:Proc ; )

// #dBound
  rule #dBound( I:Int ; _:NameVar   ; _:Map ) => boundN(I)
  rule #dBound( I:Int ; @ _:ProcVar ; _:Map ) => @ boundP(I)
  rule #dBound( I:Int ; _:ProcVar   ; _:Map ) => boundP(I)
  rule #dBound( I:Int ; * _:NameVar ; _:Map ) => * boundN(I)

// #mapify
  rule #deBruijn( I:Int ; #mapify( A:Name ) ; Mem:Map ) => #mapify(I;A;Mem)
  rule #deBruijn( I:Int ; #mapify( A:Proc ) ; Mem:Map ) => #mapify(I;A;Mem)

  rule #mapify( I:Int ; A:NameVar   ; Mem:Map ) => updateMap( Mem , A |-> boundN(I) )
  rule #mapify( _:Int ; _:BoundName ; Mem:Map ) => Mem
  rule #mapify( I:Int ; @ A:Proc    ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) ) // can .Map be used here?

  rule #mapify( _:Int ; Nil ; Mem:Map ) => Mem
  rule #mapify( _:Int ; _:Ground ; Mem:Map ) => Mem

  rule #mapify( I:Int ; A:ProcVar   ; Mem:Map ) => updateMap( Mem , A |-> boundP(I) )
  rule #mapify( _:Int ; _:BoundProc ; Mem:Map ) => Mem
  rule #mapify( I:Int ; * A:Name    ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) ) // can .Map be used here?

  rule #mapify( I:Int ; A:ProcVar ; Mem:Map ) => updateMap( Mem , A |-> boundN(I) )
  rule #mapify( I:Int ; * A:Name  ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) ) // can .Map be used here?

  rule #mapify( I:Int ; new A:Name in { B:Proc } ; Mem:Map ) 
    => updateMap( Mem , A |-> boundN(I) #mapify( I +Int 1 ; B[boundN(I) / A] ; Mem ) ) requires notBool (A in values(Mem))
  rule #mapify( I:Int ; new A:Name in { B:Proc } ; Mem:Map ) 
    => updateMap( Mem , A |-> boundN(I) #mapify( I +Int 1 ; B[boundN(I) / A] ; Mem ) ) requires A in values(Mem)

  rule #mapify( I:Int ; A:Proc | B:Proc ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) #mapify(I;B;Mem) )

  rule #mapify( I:Int ; A:Name ! ( B:Proc ) ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) #mapify(I;B;Mem) )

  rule #mapify( I:Int ; for( A:Name <- B:Name ){ C:Proc } ; Mem:Map ) => #mapify( I +Int 1 ; C ; Mem )

endmodule