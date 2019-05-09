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
                        | "#val(" Map ";" Proc ")" [function]
                        | BoundProc

  syntax    BoundProc ::= "boundP(" Int ")"

  syntax         Name ::= "#deBruijn(" Int ";" Name  ";" Map ")" [function]
                        | "#dBound("   Int ";" Name  ";" Map ")" [function]
                        | "#val(" Map ";" Name ")" [function]
                        | BoundName

  syntax        Names ::= "#dBound("   Int ";" Names ";" Map ")" [function]

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

// requirements of #sub function on BoundNames/Procs for finishing De Bruijn index substitutions
  rule #sub( _:Name ; _:NameVar ;  B:BoundName ) =>  B
  rule #sub( _:Proc ; _:ProcVar ;  B:BoundName ) =>  B
  rule #sub( _:Name ; _:NameVar ; *B:BoundName ) => *B
  rule #sub( _:Proc ; _:ProcVar ; *B:BoundName ) => *B
  rule #sub( A:BoundName ; B:BoundName ;  C:BoundName ) =>  A requires B ==K C
  rule #sub( A:BoundName ; B:BoundName ;  C:BoundName ) =>  C requires B =/=K C
  rule #sub( A:BoundName ; B:BoundName ; *C:BoundName ) => *A requires B ==K C
  rule #sub( A:BoundName ; B:BoundName ; *C:BoundName ) => *C requires B =/=K C

  rule #sub( _:Name ; _:NameVar ;  B:BoundProc ) =>  B
  rule #sub( _:Proc ; _:ProcVar ;  B:BoundProc ) =>  B
  rule #sub( _:Name ; _:NameVar ; @B:BoundProc ) => @B
  rule #sub( _:Proc ; _:ProcVar ; @B:BoundProc ) => @B

// for using a value of Mem map directly as a Name or Proc in #sub function
  rule #val( Mem:Map ; N:Name ) => Mem[N]
  rule #val( Mem:Map ; P:Proc ) => Mem[P]

// New Name Declarations - update mem map
  rule #deBruijn( I:Int ; new M:Name in { P:Proc } ; Mem:Map )
    => new boundN(I) in { #deBruijn( I +Int 1 ; #sub(boundN(I);M;P) ; updateMap( Mem , M |-> boundN(I) ) ) }

  rule #deBruijn( I:Int ; new M:Name , N:Name in { P:Proc } ; Mem:Map )
    => new boundN(I) in { #deBruijn( I +Int 1 ; N ; #sub(boundN(I);M;P) ; updateMap( Mem , M |-> boundN(I) ) ) }

  rule #deBruijn( I:Int ; new M:Name , N:Names in { P:Proc } ; Mem:Map )
    => new boundN(I) in { #deBruijn( I +Int 1 ; N ; #sub(boundN(I);M;P) ; updateMap( Mem , M |-> boundN(I) ) ) }
  
  rule new A:Name in { #deBruijn( I:Int ; M:Name ; P:Proc ; Mem:Map ) } 
    => new A , boundN(I) in { #deBruijn( I +Int 1 ; #sub(boundN(I);M;P) ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires notBool (M in keys(Mem))
  rule new A:Name in { #deBruijn( I:Int ; M:Name ; P:Proc ; Mem:Map ) } 
    => new A , boundN(I) in { #deBruijn( I +Int 1 ; #sub(boundN(I);#val(Mem;M);P) ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires M in keys(Mem)

  rule new A:Name in { #deBruijn( I:Int ; M:Name , N:Name ; P:Proc ; Mem:Map ) } 
    => new A , boundN(I) in { #deBruijn( I +Int 1 ; N ; #sub(boundN(I);M;P) ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires notBool (M in keys(Mem))
  rule new A:Name in { #deBruijn( I:Int ; M:Name , N:Name ; P:Proc ; Mem:Map ) } 
    => new A , boundN(I) in { #deBruijn( I +Int 1 ; N ; #sub(boundN(I);#val(Mem;M);P) ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires M in keys(Mem)

  rule new A:Name in { #deBruijn( I:Int ; M:Name , N:Names ; P:Proc ; Mem:Map ) } 
    => new A , boundN(I) in { #deBruijn( I +Int 1 ; N ; #sub(boundN(I);M;P) ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires notBool (M in keys(Mem))
  rule new A:Name in { #deBruijn( I:Int ; M:Name , N:Names ; P:Proc ; Mem:Map ) } 
    => new A , boundN(I) in { #deBruijn( I +Int 1 ; N ; #sub(boundN(I);#val(Mem;M);P) ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires M in keys(Mem)

  rule new A:Names in { #deBruijn( I:Int ; M:Name ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I)) in { #deBruijn( I +Int 1 ; #sub(boundN(I);M;P) ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires notBool (M in keys(Mem))
  rule new A:Names in { #deBruijn( I:Int ; M:Name ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I)) in { #deBruijn( I +Int 1 ; #sub(boundN(I);#val(Mem;M);P) ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires M in keys(Mem)

  rule new A:Names in { #deBruijn( I:Int ; M:Name , N:Name ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I)) in { #deBruijn( I +Int 1 ; N ; #sub(boundN(I);M;P) ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires notBool (M in keys(Mem))
  rule new A:Names in { #deBruijn( I:Int ; M:Name , N:Name ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I)) in { #deBruijn( I +Int 1 ; N ; #sub(boundN(I);#val(Mem;M);P) ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires M in keys(Mem)

  rule new A:Names in { #deBruijn( I:Int ; M:Name , N:Names ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I)) in { #deBruijn( I +Int 1 ; N ; #sub(boundN(I);M;P) ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires notBool (M in keys(Mem))
  rule new A:Names in { #deBruijn( I:Int ; M:Name , N:Names ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I)) in { #deBruijn( I +Int 1 ; N ; #sub(boundN(I);#val(Mem;M);P) ; updateMap( Mem , M |-> boundN(I) ) ) }
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
  // listening variables become boundN with the appropriate index and are guarded during De Bruijn indexing
  // linear
  rule #deBruijn( I:Int ; for( Y:Name <- X:Name ){ P:Proc } ; Mem:Map ) 
    => for( #dBound(I;Y;.Map) <- #deBruijn(I;X;Mem) ){ #deBruijn( I +Int 1 ; #sub(#dBound(I;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I;Y;.Map) ) ) }
    requires notBool (Y in keys(Mem))
  rule #deBruijn( I:Int ; for( Y:Name <- X:Name ){ P:Proc } ; Mem:Map ) 
    => for( #dBound(I;Y;.Map) <- #deBruijn(I;X;Mem) ){ #deBruijn( I +Int 1 ; #sub(#dBound(I;Y;.Map);#val(Mem;Y);P) ; updateMap( Mem , #mapify(I;Y;.Map) ) ) }
    requires Y in keys(Mem)
  rule #deBruijn( I:Int ; for(   <- X:Name ){ P:Proc } ; Mem:Map ) => for(   <- #deBruijn(I;X;Mem) ){ #deBruijn( I +Int 1 ; P ; Mem ) }

  // repeated
  rule #deBruijn( I:Int ; for( Y:Name <= X:Name ){ P:Proc } ; Mem:Map ) 
    => for( #dBound(I;Y;.Map) <= #deBruijn(I;X;Mem) ){ #deBruijn( I +Int 1 ; #sub(#dBound(I;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I;Y;.Map) ) ) }
    requires notBool (Y in keys(Mem))
  rule #deBruijn( I:Int ; for( Y:Name <= X:Name ){ P:Proc } ; Mem:Map ) 
    => for( #dBound(I;Y;.Map) <= #deBruijn(I;X;Mem) ){ #deBruijn( I +Int 1 ; #sub(#dBound(I;Y;.Map);#val(Mem;Y);P) ; updateMap( Mem , #mapify(I;Y;.Map) ) ) }
    requires Y in keys(Mem)
  rule #deBruijn( I:Int ; for(   <= X:Name ){ P:Proc } ; Mem:Map ) => for(   <= #deBruijn(I;X;Mem) ){ #deBruijn( I +Int 1 ; P ; Mem ) }

  // peek
  rule #deBruijn( I:Int ; for( Y:Name <! X:Name ){ P:Proc } ; Mem:Map ) 
    => for( #dBound(I;Y;.Map) <! #deBruijn(I;X;Mem) ){ #deBruijn( I +Int 1 ; #sub(#dBound(I;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I;Y;.Map) ) ) }
    requires notBool (Y in keys(Mem))
  rule #deBruijn( I:Int ; for( Y:Name <! X:Name ){ P:Proc } ; Mem:Map ) 
    => for( #dBound(I;Y;.Map) <! #deBruijn(I;X;Mem) ){ #deBruijn( I +Int 1 ; #sub(#dBound(I;Y;.Map);#val(Mem;Y);P) ; updateMap( Mem , #mapify(I;Y;.Map) ) ) }
    requires Y in keys(Mem)
  rule #deBruijn( I:Int ; for(   <! X:Name ){ P:Proc } ; Mem:Map ) => for(   <! #deBruijn(I;X;Mem) ){ #deBruijn( I +Int 1 ; P ; Mem ) }

// Sends
// index and map constant on name and proc
  rule #deBruijn( I:Int ; X:Name !  ( P:Proc ) ; Mem:Map ) => #deBruijn(I;X;Mem) !  ( #deBruijn(I;P;Mem) )
  rule #deBruijn( I:Int ; X:Name !! ( P:Proc ) ; Mem:Map ) => #deBruijn(I;X;Mem) !! ( #deBruijn(I;P;Mem) )

// Evals
// index and map are constant
  rule #deBruijn( I:Int ; * X:Name ; Mem:Map ) => * #deBruijn(I;X;Mem)

// Variables
  // NameVars
  rule #deBruijn( _:Int ; N:NameVar ; Mem:Map ) => N requires notBool (N in keys(Mem))
  rule #deBruijn( _:Int ; N:NameVar ; Mem:Map ) => #val(Mem;N) requires N in keys(Mem)

  // ProcVars
  rule #deBruijn( _:Int ; P:ProcVar ; Mem:Map ) => P requires notBool (P in keys(Mem))
  rule #deBruijn( _:Int ; P:ProcVar ; Mem:Map ) => #val(Mem;P) requires P in keys(Mem)

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
  rule #dBound( I:Int ; A:Name , B:Name  ; Mem:Map ) => #dBound(I;A;Mem) , #dBound( I +Int 1 ;B;Mem)
  rule #dBound( I:Int ; A:Name , B:Names ; Mem:Map ) => #dBound(I;A;Mem) , #dBound( I +Int 1 ;B;Mem)

  rule #dBound( I:Int ; _:ProcVar   ; _:Map ) => boundP(I)
  rule #dBound( I:Int ; * _:NameVar ; _:Map ) => * boundN(I)

// #mapify
  rule #deBruijn( I:Int ; #mapify( A:Name ) ; Mem:Map ) => #mapify(I;#deBruijn(I;A;Mem);Mem)
  rule #deBruijn( I:Int ; #mapify( A:Proc ) ; Mem:Map ) => #mapify(I;#deBruijn(I;A;Mem);Mem)

  rule #mapify( I:Int ; A:NameVar   ; Mem:Map ) => updateMap( Mem , A |-> boundN(I) )
  rule #mapify( _:Int ; _:BoundName ; Mem:Map ) => Mem
  rule #mapify( I:Int ; @ A:Proc    ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) ) // can .Map be used here?

  rule #mapify( _:Int ; Nil ; Mem:Map ) => Mem
  rule #mapify( _:Int ; _:Ground ; Mem:Map ) => Mem

  rule #mapify( I:Int ; A:ProcVar   ; Mem:Map ) => updateMap( Mem , A |-> boundP(I) )
  rule #mapify( _:Int ; _:BoundProc ; Mem:Map ) => Mem
  rule #mapify( I:Int ; * A:Name    ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) ) // can .Map be used here?

  rule #mapify( I:Int ; new A:Name in { B:Proc } ; Mem:Map ) 
    => updateMap( Mem , A |-> boundN(I) #mapify( I +Int 1 ; B[boundN(I) / A] ; Mem ) ) requires notBool (A in values(Mem))
  rule #mapify( I:Int ; new A:Name in { B:Proc } ; Mem:Map ) 
    => updateMap( Mem , A |-> boundN(I) #mapify( I +Int 1 ; B[boundN(I) / A] ; Mem ) ) requires A in values(Mem)

  rule #mapify( I:Int ; A:Proc | B:Proc ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) #mapify(I;B;Mem) )

  rule #mapify( I:Int ; A:Name ! ( B:Proc ) ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) #mapify(I;B;Mem) )

  rule #mapify( I:Int ; for( A:Name <- B:Name ){ C:Proc } ; Mem:Map ) => #mapify( I +Int 1 ; C ; Mem )

endmodule