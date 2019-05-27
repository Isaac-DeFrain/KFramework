// De Bruijn Index & Alpha Equisubence for Grounded Rho Calculus
// Need to call #deBruijn(0;$PGM;.Map) at the beginning of program execution

/*
TODO:
 - how to handle listens with several names & joins? -- Mem subues for several Names/Procs in #dBound
 - more tests for substitutions in continuations for listens on chan
 - create #mapify: function which computes the final deBruijn map of a Name
 - add remaining productions - GuardedRecs, Nonlinear Recs, MultiRecs, Conditional, MultiRecs, Collections, Bundles, 
*/

require "../grho.k"
require "../Substitute/sub.k"

module ALPHA-SYNTAX
  import DOMAINS
  import GRHO-SYNTAX

// Top level Procs
  syntax         Proc ::= "#deBruijn(" Int ";" Proc  ";" Map ")" [function, poly(0,2)]
                        | "#dBound("   Int ";" Proc  ";" Map ")" [function]
                        | "new" Name  "in" "{" DBProc "}"        [function]
                        | "new" Names "in" "{" DBProc "}"        [function]

  // New name declarations
  syntax       DBProc ::= "#deBruijn(" Int ";" Name  ";" Proc ";" Map ")" [function]
                        | "#deBruijn(" Int ";" Names ";" Proc ";" Map ")" [function]

  syntax        Procs ::= "#deBruijn(" Int ";" Procs ";" Map ")" [function]
                        | "#dBound("   Int ";" Procs ";" Map ")" [function]

// Nested Procs
  syntax         Proc ::= "#deBruijn(" Int "," Int ";" Proc  ";" Map ")" [function, poly(0,2)]
                        | "#dBound("   Int "," Int ";" Proc  ";" Map ")" [function]

  syntax       DBProc ::= "#deBruijn(" Int "," Int ";" Name  ";" Proc ";" Map ")" [function]
                        | "#deBruijn(" Int "," Int ";" Names ";" Proc ";" Map ")" [function]

  syntax        Procs ::= "#deBruijn(" Int "," Int  ";" Procs ";" Map ")" [function]
                        | "#dBound("   Int "," Int  ";" Procs ";" Map ")" [function]

// Top level Names
  syntax         Name ::= "#deBruijn(" Int ";" Name  ";" Map ")" [function]
                        | "#dBound("   Int ";" Name  ";" Map ")" [function]

  syntax        Names ::= "#deBruijn(" Int ";" Names ";" Map ")" [function]
                        | "#dBound("   Int ";" Names ";" Map ")" [function]

// Nested Names
  syntax         Name ::= "#deBruijn(" Int "," Int ";" Name  ";" Map ")" [function]
                        | "#dBound("   Int "," Int ";" Name  ";" Map ")" [function]

  syntax        Names ::= "#deBruijn(" Int "," Int ";" Names ";" Map ")" [function]
                        | "#dBound("   Int "," Int ";" Names ";" Map ")" [function]

// Top level Map updates
  syntax          Map ::= "#mapify(" Name ")"
                        | "#mapify(" Proc ")"
                        | "#mapify(" Int ";" Name  ";" Map ")" [function]
                        | "#mapify(" Int ";" Names ";" Map ")" [function]
                        | "#mapify(" Int ";" Proc  ";" Map ")" [function]
                        | "#mapify(" Int ";" Procs ";" Map ")" [function]

// Nested Map updates
  syntax          Map ::= "#mapify(" Int "," Int ";" Name  ";" Map ")" [function]
                        | "#mapify(" Int "," Int ";" Names ";" Map ")" [function]
                        | "#mapify(" Int "," Int ";" Proc  ";" Map ")" [function]
                        | "#mapify(" Int "," Int ";" Procs ";" Map ")" [function]

// Alpha equisubence predicate
  syntax         Bool ::= Proc "#alpha" Proc [function]
/*
// For proper typing
  syntax          Par ::= "#deBruijn(" Int ";" Par ";" Map ")" [function]
                        | "#dBound("   Int ";" Par ";" Map ")" [function]
                        | "#deBruijn(" Int "," Int ";" Par ";" Map ")" [function]
                        | "#dBound("   Int "," Int ";" Par ";" Map ")" [function]

  syntax         AExp ::= "#deBruijn(" Int ";" AExp ";" Map ")" [function]
                        | "#dBound("   Int ";" AExp ";" Map ")" [function]
                        | "#deBruijn(" Int "," Int ";" AExp ";" Map ")" [function]
                        | "#dBound("   Int "," Int ";" AExp ";" Map ")" [function]

  syntax         BExp ::= "#deBruijn(" Int ";" BExp ";" Map ")" [function]
                        | "#dBound("   Int ";" BExp ";" Map ")" [function]
                        | "#deBruijn(" Int "," Int ";" BExp ";" Map ")" [function]
                        | "#dBound("   Int "," Int ";" BExp ";" Map ")" [function]
*/
endmodule

module ALPHA
  import ALPHA-SYNTAX
  import SUB

// Must be taken out so we can import into GRHO
//  configuration
//  <T color="purple">
//    <k> #deBruijn( 0 ; $PGM:Proc ; .Map ) </k>
//  </T>

  syntax KResult ::= Name | Names | Proc | Procs | Bool

//----------------------------
//--- Top Level Constructs ---
//----------------------------

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
    => new A , boundN(I) in { #deBruijn( I +Int 1 ; #sub(boundN(I);#sub(Mem;M);P) ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires M in keys(Mem)

  rule new A:Name in { #deBruijn( I:Int ; M:Name , N:Name ; P:Proc ; Mem:Map ) } 
    => new A , boundN(I) in { #deBruijn( I +Int 1 ; N ; #sub(boundN(I);M;P) ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires notBool (M in keys(Mem))
  rule new A:Name in { #deBruijn( I:Int ; M:Name , N:Name ; P:Proc ; Mem:Map ) } 
    => new A , boundN(I) in { #deBruijn( I +Int 1 ; N ; #sub(boundN(I);#sub(Mem;M);P) ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires M in keys(Mem)

  rule new A:Name in { #deBruijn( I:Int ; M:Name , N:Names ; P:Proc ; Mem:Map ) } 
    => new A , boundN(I) in { #deBruijn( I +Int 1 ; N ; #sub(boundN(I);M;P) ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires notBool (M in keys(Mem))
  rule new A:Name in { #deBruijn( I:Int ; M:Name , N:Names ; P:Proc ; Mem:Map ) } 
    => new A , boundN(I) in { #deBruijn( I +Int 1 ; N ; #sub(boundN(I);#sub(Mem;M);P) ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires M in keys(Mem)

  rule new A:Names in { #deBruijn( I:Int ; M:Name ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I)) in { #deBruijn( I +Int 1 ; #sub(boundN(I);M;P) ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires notBool (M in keys(Mem))
  rule new A:Names in { #deBruijn( I:Int ; M:Name ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I)) in { #deBruijn( I +Int 1 ; #sub(boundN(I);#sub(Mem;M);P) ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires M in keys(Mem)

  rule new A:Names in { #deBruijn( I:Int ; M:Name , N:Name ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I)) in { #deBruijn( I +Int 1 ; N ; #sub(boundN(I);M;P) ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires notBool (M in keys(Mem))
  rule new A:Names in { #deBruijn( I:Int ; M:Name , N:Name ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I)) in { #deBruijn( I +Int 1 ; N ; #sub(boundN(I);#sub(Mem;M);P) ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires M in keys(Mem)

  rule new A:Names in { #deBruijn( I:Int ; M:Name , N:Names ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I)) in { #deBruijn( I +Int 1 ; N ; #sub(boundN(I);M;P) ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires notBool (M in keys(Mem))
  rule new A:Names in { #deBruijn( I:Int ; M:Name , N:Names ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I)) in { #deBruijn( I +Int 1 ; N ; #sub(boundN(I);#sub(Mem;M);P) ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires M in keys(Mem)

// Ground & bound terms
  rule #deBruijn( _:Int ; A:Ground    ; _:Map ) => A
  rule #deBruijn( _:Int ; A:BoundName ; _:Map ) => A
  rule #deBruijn( _:Int ; A:BoundProc ; _:Map ) => A

// Parallel Composition
// Mem map propogates to both branchs
  rule #deBruijn( I:Int ; P:Proc | Q:Proc ; Mem:Map ) => #deBruijn(I;P;Mem) | #deBruijn(I;Q;Mem)

// Receives
//-- TODO: listen for multiple names & listens on complex names like @Proc for general Proc
  // listening variables become boundN(I) with the appropriate index and are guarded during De Bruijn indexing
  // linear
    // no listening variables
  rule #deBruijn( I:Int ; for(   <- X:Name ){ P:Proc } ; Mem:Map ) => for(   <- #deBruijn(I;X;Mem) ){ #deBruijn( I +Int 1 ; P ; Mem ) }
    // listening for NameVars
  rule #deBruijn( I:Int ; for( Y:NameVar <- X:Name ){ P:Proc } ; Mem:Map ) 
    => for( #dBound(I;Y;.Map) <- #deBruijn(I;X;Mem) ){ #deBruijn( I +Int 1 ; #sub(#dBound(I;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I;Y;.Map) ) ) }
    requires notBool (Y in keys(Mem))
  rule #deBruijn( I:Int ; for( Y:NameVar <- X:Name ){ P:Proc } ; Mem:Map ) 
    => for( #dBound(I;Y;.Map) <- #deBruijn(I;X;Mem) ){ #deBruijn( I +Int 1 ; #sub(#dBound(I;Y;.Map);#sub(Mem;Y);P) ; updateMap( Mem , #mapify(I;Y;.Map) ) ) }
    requires Y in keys(Mem)
    // listening for @ProcVars
  rule #deBruijn( I:Int ; for( @Y:ProcVar <- X:Name ){ P:Proc } ; Mem:Map ) 
    => for( #dBound(I;@Y;.Map) <- #deBruijn(I;X;Mem) ){ #deBruijn( I +Int 1 ; #sub(#dBound(I;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I;Y;.Map) ) ) }
    requires notBool (Y in keys(Mem))
  rule #deBruijn( I:Int ; for( @Y:ProcVar <- X:Name ){ P:Proc } ; Mem:Map ) 
    => for( #dBound(I;@Y;.Map) <- #deBruijn(I;X;Mem) ){ #deBruijn( I +Int 1 ; #sub(#dBound(I;Y;.Map);#sub(Mem;Y);P) ; updateMap( Mem , #mapify(I;Y;.Map) ) ) }
    requires Y in keys(Mem)
    // listening for @Proc for general Proc -- free variables in Proc are bound in the continuation
  rule #deBruijn( I:Int ; for( @Y:Proc <- X:Name ){ P:Proc } ; Mem:Map ) 
    => for( #dBound(I;@Y;.Map) <- #deBruijn(I;X;Mem) ){ #deBruijn( I +Int 1 ; #sub(#mapify(I;Y;.Map);P) ; updateMap( Mem , #mapify(I;Y;.Map) ) ) }
    requires notBool isProcVar(Y)

    // several Name listens -- TODO: resolve subues in Mem
  rule #deBruijn( I:Int ; for( Y:Names <- X:Name ){ P:Proc } ; Mem:Map ) 
    => for( #dBound(I;Y;.Map) <- #deBruijn(I;X;Mem) ){ 
            #deBruijn( I +Int #length(Y) ; #sub(#dBound(I;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I;Y;.Map) ) ) }
//    requires notBool (Y in keys(Mem))
//  rule #deBruijn( I:Int ; for( Y:Name , Z:Name <- X:Name ){ P:Proc } ; Mem:Map ) 
//    => for( #dBound(I;Y;.Map) , #dBound(I +Int 1;Z;.Map) <- #deBruijn(I;X;Mem) ){ 
//            #deBruijn( I +Int s ; #sub(#dBound(I;Y;.Map);#sub(Mem;Y);P) ; updateMap( Mem , #mapify(I;Y;.Map) ) ) }
//    requires Y in keys(Mem)

  // repeated
  rule #deBruijn( I:Int ; for( Y:Name <= X:Name ){ P:Proc } ; Mem:Map ) 
    => for( #dBound(I;Y;.Map) <= #deBruijn(I;X;Mem) ){ #deBruijn( I +Int 1 ; #sub(#dBound(I;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I;Y;.Map) ) ) }
    requires notBool (Y in keys(Mem))
  rule #deBruijn( I:Int ; for( Y:Name <= X:Name ){ P:Proc } ; Mem:Map ) 
    => for( #dBound(I;Y;.Map) <= #deBruijn(I;X;Mem) ){ #deBruijn( I +Int 1 ; #sub(#dBound(I;Y;.Map);#sub(Mem;Y);P) ; updateMap( Mem , #mapify(I;Y;.Map) ) ) }
    requires Y in keys(Mem)
  rule #deBruijn( I:Int ; for(   <= X:Name ){ P:Proc } ; Mem:Map ) => for(   <= #deBruijn(I;X;Mem) ){ #deBruijn( I +Int 1 ; P ; Mem ) }

  // peek
  rule #deBruijn( I:Int ; for( Y:Name <! X:Name ){ P:Proc } ; Mem:Map ) 
    => for( #dBound(I;Y;.Map) <! #deBruijn(I;X;Mem) ){ #deBruijn( I +Int 1 ; #sub(#dBound(I;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I;Y;.Map) ) ) }
    requires notBool (Y in keys(Mem))
  rule #deBruijn( I:Int ; for( Y:Name <! X:Name ){ P:Proc } ; Mem:Map ) 
    => for( #dBound(I;Y;.Map) <! #deBruijn(I;X;Mem) ){ #deBruijn( I +Int 1 ; #sub(#dBound(I;Y;.Map);#sub(Mem;Y);P) ; updateMap( Mem , #mapify(I;Y;.Map) ) ) }
    requires Y in keys(Mem)
  rule #deBruijn( I:Int ; for(   <! X:Name ){ P:Proc } ; Mem:Map ) => for(   <! #deBruijn(I;X;Mem) ){ #deBruijn( I +Int 1 ; P ; Mem ) }

// Sends
// index and map constant on name and proc
  rule #deBruijn( I:Int ; X:Name !  ( P:Proc  ) ; Mem:Map ) => #deBruijn(I;X;Mem) !  ( #deBruijn(I;P;Mem) )
  rule #deBruijn( I:Int ; X:Name !  ( P:Procs ) ; Mem:Map ) => #deBruijn(I;X;Mem) !  ( #deBruijn(I;P;Mem) )
  rule #deBruijn( I:Int ; X:Name !! ( P:Proc  ) ; Mem:Map ) => #deBruijn(I;X;Mem) !! ( #deBruijn(I;P;Mem) )
  rule #deBruijn( I:Int ; X:Name !! ( P:Procs ) ; Mem:Map ) => #deBruijn(I;X;Mem) !! ( #deBruijn(I;P;Mem) )

// Esubs -- goes inside
  rule #deBruijn( I:Int ; * X:Name ; Mem:Map ) => * #deBruijn(I;X;Mem)

// Variables
  // NameVars -- nothing happens if NameVar is free w.r.t. Mem
  rule #deBruijn( _:Int ; N:NameVar ; Mem:Map ) => N requires notBool (N in keys(Mem))
  // if NameVar is bound w.r.t. Mem, replace it with its subue
  rule #deBruijn( _:Int ; N:NameVar ; Mem:Map ) => #sub(Mem;N) requires N in keys(Mem)

  // ProcVars -- nothing happens if ProcVar is free w.r.t. Mem
  rule #deBruijn( _:Int ; P:ProcVar ; Mem:Map ) => P requires notBool (P in keys(Mem))
  // if ProcVar is bound w.r.t. Mem, replace it with its subue
  rule #deBruijn( _:Int ; P:ProcVar ; Mem:Map ) => #sub(Mem;P) requires P in keys(Mem)

// Collections
  // RhoList
  rule #deBruijn( _:Int ; [ ] ; _:Map ) => [ ]
  rule #deBruijn( I:Int ; [ P:Proc  ] ; Mem:Map ) => [#deBruijn(I;P;Mem)]
  rule #deBruijn( I:Int ; [ P:Procs ] ; Mem:Map ) => [#deBruijn(I;P;Mem)]

  // RhoMap

  // RhoSet
  rule #deBruijn( _:Int ; Set( ) ; _:Map ) => Set( )
  rule #deBruijn( I:Int ; Set( P:Proc  ) ; Mem:Map ) => Set(#deBruijn(I;P;Mem))
  rule #deBruijn( I:Int ; Set( P:Procs ) ; Mem:Map ) => Set(#deBruijn(I;P;Mem))

  // RhoTuple
  rule #deBruijn( _:Int ; ( ) ; _:Map ) => ( )
  rule #deBruijn( I:Int ; tuple( P:Proc  ) ; Mem:Map ) => tuple(#deBruijn(I;P;Mem))
  rule #deBruijn( I:Int ; tuple( P:Procs ) ; Mem:Map ) => tuple(#deBruijn(I;P;Mem))

// Quotes -- goes inside (like eval)
  rule #deBruijn( I:Int ; @ P:Proc ; Mem:Map ) => @ #deBruijn(I;P;Mem)

// TODO: add these productions to nested section
// Arithmetic Exps
  rule #deBruijn( I:Int ; - A:AExp ; Mem:Map ) => - #deBruijn(I;A;Mem)
  rule #deBruijn( I:Int ; A:AExp *  B:AExp ; Mem:Map ) => #deBruijn(I;A;Mem) *  #deBruijn(I;B;Mem)
  rule #deBruijn( I:Int ; A:AExp /  B:AExp ; Mem:Map ) => #deBruijn(I;A;Mem) /  #deBruijn(I;B;Mem)
  rule #deBruijn( I:Int ; A:AExp +  B:AExp ; Mem:Map ) => #deBruijn(I;A;Mem) +  #deBruijn(I;B;Mem)
  rule #deBruijn( I:Int ; A:AExp -  B:AExp ; Mem:Map ) => #deBruijn(I;A;Mem) -  #deBruijn(I;B;Mem)
  rule #deBruijn( I:Int ; A:AExp %  B:AExp ; Mem:Map ) => #deBruijn(I;A;Mem) %  #deBruijn(I;B;Mem)
  rule #deBruijn( I:Int ; A:AExp ++ B:AExp ; Mem:Map ) => #deBruijn(I;A;Mem) ++ #deBruijn(I;B;Mem)

// Boolean Exps
  rule #deBruijn( I:Int ; not A:BExp ; Mem:Map ) => not #deBruijn(I;A;Mem)
  rule #deBruijn( I:Int ; A:BExp and B:BExp ; Mem:Map ) => #deBruijn(I;A;Mem) and #deBruijn(I;B;Mem)
  rule #deBruijn( I:Int ; A:BExp or  B:BExp ; Mem:Map ) => #deBruijn(I;A;Mem) or  #deBruijn(I;B;Mem)
  rule #deBruijn( I:Int ; A:AExp <=  B:AExp ; Mem:Map ) => #deBruijn(I;A;Mem) <=  #deBruijn(I;B;Mem)
  rule #deBruijn( I:Int ; A:AExp <   B:AExp ; Mem:Map ) => #deBruijn(I;A;Mem) <   #deBruijn(I;B;Mem)
  rule #deBruijn( I:Int ; A:AExp >=  B:AExp ; Mem:Map ) => #deBruijn(I;A;Mem) >=  #deBruijn(I;B;Mem)
  rule #deBruijn( I:Int ; A:AExp >   B:AExp ; Mem:Map ) => #deBruijn(I;A;Mem) >   #deBruijn(I;B;Mem)
  rule #deBruijn( I:Int ; A:Name ==  B:Name ; Mem:Map ) => #deBruijn(I;A;Mem) ==  #deBruijn(I;B;Mem)
  rule #deBruijn( I:Int ; A:Name !=  B:Name ; Mem:Map ) => #deBruijn(I;A;Mem) !=  #deBruijn(I;B;Mem)
  rule #deBruijn( I:Int ; A:Proc ==  B:Proc ; Mem:Map ) => #deBruijn(I;A;Mem) ==  #deBruijn(I;B;Mem)
  rule #deBruijn( I:Int ; A:Proc ==  B:Proc ; Mem:Map ) => #deBruijn(I;A;Mem) !=  #deBruijn(I;B;Mem)
  rule #deBruijn( I:Int ; A:Proc matches B:Proc ; Mem:Map ) => #deBruijn(I;A;Mem) matches #deBruijn(I;B;Mem)

// TODO: Other productions...

// Several Names
  // Lists of to-be-bound Names will only appear in listens (the Name declarations in New are dealt with separately)...
  // need to make the appropriate substitutions in the continuation too...
  // want to do something like 
  rule #deBruijn( I:Int ; Y:Name , Z:Name  ; Mem:Map ) => #deBruijn(I;Y;Mem) , #deBruijn(I +Int 1;Z;updateMap(Mem,#mapify(I;Y;Mem)))
  rule #deBruijn( I:Int ; Y:Name , Z:Names ; Mem:Map ) => #deBruijn(I;Y;Mem) , #deBruijn(I +Int 1;Z;updateMap(Mem,#mapify(I;Y;Mem)))

// Several Procs
  // Lists of to-be-bound Procs appear in Collections and Sends...
  // want to do something like
  rule #deBruijn( I:Int ; Y:Proc , Z:Proc  ; Mem:Map ) => #deBruijn(I;Y;Mem) , #deBruijn(I +Int 1;Z;updateMap(Mem,#mapify(I;Y;Mem)))
  rule #deBruijn( I:Int ; Y:Proc , Z:Procs ; Mem:Map ) => #deBruijn(I;Y;Mem) , #deBruijn(I +Int 1;Z;updateMap(Mem,#mapify(I;Y;Mem)))

//-------------------------
//--- Nested Constructs ---
//-------------------------

// New Name Declarations - update mem map
  rule #deBruijn( I:Int , J:Int ; new M:Name in { P:Proc } ; Mem:Map )
    => new boundN(I) in { #deBruijn( I,J +Int 1 ; #sub(boundN(I,J);M;P) ; updateMap( Mem , M |-> boundN(I,J) ) ) }

  rule #deBruijn( I:Int , J:Int ; new M:Name , N:Name in { P:Proc } ; Mem:Map )
    => new boundN(I) in { #deBruijn( I,J +Int 1 ; N ; #sub(boundN(I,J);M;P) ; updateMap( Mem , M |-> boundN(I,J) ) ) }

  rule #deBruijn( I:Int , J:Int ; new M:Name , N:Names in { P:Proc } ; Mem:Map )
    => new boundN(I) in { #deBruijn( I,J +Int 1 ; N ; #sub(boundN(I,J);M;P) ; updateMap( Mem , M |-> boundN(I,J) ) ) }
  
  rule new A:Name in { #deBruijn( I:Int , J:Int ; M:Name ; P:Proc ; Mem:Map ) } 
    => new A , boundN(I) in { #deBruijn( I,J +Int 1 ; #sub(boundN(I,J);M;P) ; updateMap( Mem , M |-> boundN(I,J) ) ) }
       requires notBool (M in keys(Mem))
  rule new A:Name in { #deBruijn( I:Int , J:Int ; M:Name ; P:Proc ; Mem:Map ) } 
    => new A , boundN(I) in { #deBruijn( I,J +Int 1 ; #sub(boundN(I,J);#sub(Mem;M);P) ; updateMap( Mem , M |-> boundN(I,J) ) ) }
       requires M in keys(Mem)

  rule new A:Name in { #deBruijn( I:Int , J:Int ; M:Name , N:Name ; P:Proc ; Mem:Map ) } 
    => new A , boundN(I) in { #deBruijn( I,J +Int 1 ; N ; #sub(boundN(I,J);M;P) ; updateMap( Mem , M |-> boundN(I,J) ) ) }
       requires notBool (M in keys(Mem))
  rule new A:Name in { #deBruijn( I:Int , J:Int ; M:Name , N:Name ; P:Proc ; Mem:Map ) } 
    => new A , boundN(I) in { #deBruijn( I,J +Int 1 ; N ; #sub(boundN(I,J);#sub(Mem;M);P) ; updateMap( Mem , M |-> boundN(I,J) ) ) }
       requires M in keys(Mem)

  rule new A:Name in { #deBruijn( I:Int , J:Int ; M:Name , N:Names ; P:Proc ; Mem:Map ) } 
    => new A , boundN(I) in { #deBruijn( I,J +Int 1 ; N ; #sub(boundN(I,J);M;P) ; updateMap( Mem , M |-> boundN(I,J) ) ) }
       requires notBool (M in keys(Mem))
  rule new A:Name in { #deBruijn( I:Int , J:Int ; M:Name , N:Names ; P:Proc ; Mem:Map ) } 
    => new A , boundN(I) in { #deBruijn( I,J +Int 1 ; N ; #sub(boundN(I,J);#sub(Mem;M);P) ; updateMap( Mem , M |-> boundN(I,J) ) ) }
       requires M in keys(Mem)

  rule new A:Names in { #deBruijn( I:Int , J:Int ; M:Name ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I)) in { #deBruijn( J,I +Int 1 ; #sub(boundN(J,I);M;P) ; updateMap( Mem , M |-> boundN(J,I) ) ) }
       requires notBool (M in keys(Mem))
  rule new A:Names in { #deBruijn( I:Int , J:Int ; M:Name ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I)) in { #deBruijn( J,I +Int 1 ; #sub(boundN(J,I);#sub(Mem;M);P) ; updateMap( Mem , M |-> boundN(J,I) ) ) }
       requires M in keys(Mem)

  rule new A:Names in { #deBruijn( I:Int , J:Int ; M:Name , N:Name ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I)) in { #deBruijn( J,I +Int 1 ; N ; #sub(boundN(J,I);M;P) ; updateMap( Mem , M |-> boundN(J,I) ) ) }
       requires notBool (M in keys(Mem))
  rule new A:Names in { #deBruijn( I:Int , J:Int ; M:Name , N:Name ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I)) in { #deBruijn( J,I +Int 1 ; N ; #sub(boundN(J,I);#sub(Mem;M);P) ; updateMap( Mem , M |-> boundN(J,I) ) ) }
       requires M in keys(Mem)

  rule new A:Names in { #deBruijn( I:Int , J:Int ; M:Name , N:Names ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I)) in { #deBruijn( J,I +Int 1 ; N ; #sub(boundN(J,I);M;P) ; updateMap( Mem , M |-> boundN(J,I) ) ) }
       requires notBool (M in keys(Mem))
  rule new A:Names in { #deBruijn( I:Int , J:Int ; M:Name , N:Names ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I)) in { #deBruijn( J,I +Int 1 ; N ; #sub(boundN(J,I);#sub(Mem;M);P) ; updateMap( Mem , M |-> boundN(J,I) ) ) }
       requires M in keys(Mem)

// Ground & bound terms
  rule #deBruijn( _:Int , _:Int ; A:Ground    ; _:Map ) => A
  rule #deBruijn( _:Int , _:Int ; A:BoundName ; _:Map ) => A
  rule #deBruijn( _:Int , _:Int ; A:BoundProc ; _:Map ) => A

// Parallel Composition
// Mem map propogates to both branchs
  rule #deBruijn( I:Int , J:Int ; P:Proc | Q:Proc ; Mem:Map ) => #deBruijn(I,J;P;Mem) | #deBruijn(I,J;Q;Mem)

// Receives -- TODO: listen for multiple names 
  // listening variables become boundN(I) with the appropriate index and are guarded during De Bruijn indexing
  // linear
  rule #deBruijn( I:Int , J:Int ; for( Y:Name <- X:Name ){ P:Proc } ; Mem:Map ) 
    => for( #dBound(I,J;Y;.Map) <- #deBruijn(I,J;X;Mem) ){ #deBruijn( I,J +Int 1 ; #sub(#dBound(I,J;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I,J;Y;.Map) ) ) }
    requires notBool (Y in keys(Mem))
  rule #deBruijn( I:Int , J:Int ; for( Y:Name <- X:Name ){ P:Proc } ; Mem:Map ) 
    => for( #dBound(I,J;Y;.Map) <- #deBruijn(I,J;X;Mem) ){ #deBruijn( I,J +Int 1 ; #sub(#dBound(I,J;Y;.Map);#sub(Mem;Y);P) ; updateMap( Mem , #mapify(I,J;Y;.Map) ) ) }
    requires Y in keys(Mem)
  rule #deBruijn( I:Int , J:Int ; for(   <- X:Name ){ P:Proc } ; Mem:Map ) => for(   <- #deBruijn(I,J;X;Mem) ){ #deBruijn( I,J +Int 1 ; P ; Mem ) }

    // several Name listens -- TODO: resolve subues in Mem
  rule #deBruijn( I:Int , J:Int ; for( Y:Names <- X:Name ){ P:Proc } ; Mem:Map ) 
    => for( #dBound(I,J;Y;.Map) <- #deBruijn(I,J;X;Mem) ){ 
            #deBruijn( I,J +Int #length(Y) ; #sub(#dBound(I,J;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I,J;Y;.Map) ) ) }
//    requires notBool (Y in keys(Mem))
//  rule #deBruijn( I:Int ; for( Y:Name , Z:Name <- X:Name ){ P:Proc } ; Mem:Map ) 
//    => for( #dBound(I;Y;.Map) , #dBound(I +Int 1;Z;.Map) <- #deBruijn(I;X;Mem) ){ 
//            #deBruijn( I +Int s ; #sub(#dBound(I;Y;.Map);#sub(Mem;Y);P) ; updateMap( Mem , #mapify(I;Y;.Map) ) ) }
//    requires Y in keys(Mem)

  // repeated
  rule #deBruijn( I:Int , J:Int ; for( Y:Name <= X:Name ){ P:Proc } ; Mem:Map ) 
    => for( #dBound(I,J;Y;.Map) <= #deBruijn(I,J;X;Mem) ){ #deBruijn( I,J +Int 1 ; #sub(#dBound(I,J;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I,J;Y;.Map) ) ) }
    requires notBool (Y in keys(Mem))
  rule #deBruijn( I:Int , J:Int ; for( Y:Name <= X:Name ){ P:Proc } ; Mem:Map ) 
    => for( #dBound(I,J;Y;.Map) <= #deBruijn(I,J;X;Mem) ){ #deBruijn( I,J +Int 1 ; #sub(#dBound(I,J;Y;.Map);#sub(Mem;Y);P) ; updateMap( Mem , #mapify(I,J;Y;.Map) ) ) }
    requires Y in keys(Mem)
  rule #deBruijn( I:Int , J:Int ; for(        <= X:Name ){ P:Proc } ; Mem:Map ) => for(   <= #deBruijn(I,J;X;Mem) ){ #deBruijn( I,J +Int 1 ; P ; Mem ) }

  // peek
  rule #deBruijn( I:Int , J:Int ; for( Y:Name <! X:Name ){ P:Proc } ; Mem:Map ) 
    => for( #dBound(I,J;Y;.Map) <! #deBruijn(I,J;X;Mem) ){ #deBruijn( I,J +Int 1 ; #sub(#dBound(I,J;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I,J;Y;.Map) ) ) }
    requires notBool (Y in keys(Mem))
  rule #deBruijn( I:Int , J:Int ; for( Y:Name <! X:Name ){ P:Proc } ; Mem:Map ) 
    => for( #dBound(I,J;Y;.Map) <! #deBruijn(I,J;X;Mem) ){ #deBruijn( I,J +Int 1 ; #sub(#dBound(I,J;Y;.Map);#sub(Mem;Y);P) ; updateMap( Mem , #mapify(I,J;Y;.Map) ) ) }
    requires Y in keys(Mem)
  rule #deBruijn( I:Int , J:Int ; for(        <! X:Name ){ P:Proc } ; Mem:Map ) => for(   <! #deBruijn(I,J;X;Mem) ){ #deBruijn( I,J +Int 1 ; P ; Mem ) }

// Sends
// index and map constant on name and proc
  rule #deBruijn( I:Int , J:Int ; X:Name !  ( P:Proc  ) ; Mem:Map ) => #deBruijn(I,J;X;Mem) !  ( #deBruijn(I,J;P;Mem) )
  rule #deBruijn( I:Int , J:Int ; X:Name !  ( P:Procs ) ; Mem:Map ) => #deBruijn(I,J;X;Mem) !  ( #deBruijn(I,J;P;Mem) )
  rule #deBruijn( I:Int , J:Int ; X:Name !! ( P:Proc  ) ; Mem:Map ) => #deBruijn(I,J;X;Mem) !! ( #deBruijn(I,J;P;Mem) )
  rule #deBruijn( I:Int , J:Int ; X:Name !! ( P:Procs ) ; Mem:Map ) => #deBruijn(I,J;X;Mem) !! ( #deBruijn(I,J;P;Mem) )

// Esubs -- goes inside
  rule #deBruijn( I:Int , J:Int ; * X:Name ; Mem:Map ) => * #deBruijn(I,J;X;Mem)

// Variables
  // NameVars -- nothing happens if NameVar is free w.r.t. Mem
  rule #deBruijn( _:Int , _:Int ; N:NameVar ; Mem:Map ) => N requires notBool (N in keys(Mem))
  // if NameVar is bound w.r.t. Mem, replace it with its subue
  rule #deBruijn( _:Int , _:Int ; N:NameVar ; Mem:Map ) => #sub(Mem;N) requires N in keys(Mem)

  // ProcVars -- nothing happens if ProcVar is free w.r.t. Mem
  rule #deBruijn( _:Int , _:Int ; P:ProcVar ; Mem:Map ) => P requires notBool (P in keys(Mem))
  // if ProcVar is bound w.r.t. Mem, replace it with its subue
  rule #deBruijn( _:Int , _:Int ; P:ProcVar ; Mem:Map ) => #sub(Mem;P) requires P in keys(Mem)

// Collections
  // RhoList
  rule #deBruijn( _:Int , _:Int ; [ ] ; _:Map ) => [ ]
  rule #deBruijn( I:Int , J:Int ; [ P:Proc  ] ; Mem:Map ) => [#deBruijn(I,J;P;Mem)]
  rule #deBruijn( I:Int , J:Int ; [ P:Procs ] ; Mem:Map ) => [#deBruijn(I,J;P;Mem)]

  // RhoMap

  // RhoSet
  rule #deBruijn( _:Int , _:Int ; Set( ) ; _:Map ) => Set( )
  rule #deBruijn( I:Int , J:Int ; Set( P:Proc  ) ; Mem:Map ) => Set(#deBruijn(I,J;P;Mem))
  rule #deBruijn( I:Int , J:Int ; Set( P:Procs ) ; Mem:Map ) => Set(#deBruijn(I,J;P;Mem))

  // RhoTuple
  rule #deBruijn( _:Int , _:Int ; ( ) ; _:Map ) => ( )
  rule #deBruijn( I:Int , J:Int ; tuple( P:Proc  ) ; Mem:Map ) => tuple(#deBruijn(I,J;P;Mem))
  rule #deBruijn( I:Int , J:Int ; tuple( P:Procs ) ; Mem:Map ) => tuple(#deBruijn(I,J;P;Mem))

// Quotes -- goes inside (like eval)
  rule #deBruijn( I:Int , J:Int ; @ P:Proc ; Mem:Map ) => @ #deBruijn(I,J;P;Mem)

// Several Names
  // Lists of to-be-bound Names will only appear in listens (the Name declarations in New are dealt with separately)...
  // need to make the appropriate substitutions in the continuation too...
  // want to do something like 
  rule #deBruijn( I:Int , J:Int ; Y:Name , Z:Name  ; Mem:Map ) => #deBruijn(I,J;Y;Mem) , #deBruijn(I,J +Int 1;Z;updateMap(Mem,#mapify(I,J;Y;Mem)))
  rule #deBruijn( I:Int , J:Int ; Y:Name , Z:Names ; Mem:Map ) => #deBruijn(I,J;Y;Mem) , #deBruijn(I,J +Int 1;Z;updateMap(Mem,#mapify(I,J;Y;Mem)))

// Several Procs
  // Lists of to-be-bound Procs appear in Collections and Sends...
  // want to do something like
  rule #deBruijn( I:Int , J:Int ; Y:Proc , Z:Proc  ; Mem:Map ) => #deBruijn(I,J;Y;Mem) , #deBruijn(I,J +Int 1;Z;updateMap(Mem,#mapify(I,J;Y;Mem)))
  rule #deBruijn( I:Int , J:Int ; Y:Proc , Z:Procs ; Mem:Map ) => #deBruijn(I,J;Y;Mem) , #deBruijn(I,J +Int 1;Z;updateMap(Mem,#mapify(I,J;Y;Mem)))

//--------------
//--- #alpha ---
//--------------

// Alpha Equisubence Predicate
  // checks synactic equality of De Bruijn index substituted terms
//  rule #deBruijn(I:Int ; P:Proc #alpha Q:Proc ; Mem:Map) => #deBruijn(I;P;Mem) ==K #deBruijn(I;Q;Mem)
  rule P:Proc #alpha Q:Proc => #deBruijn(0;P;.Map) ==K #deBruijn(0;Q;.Map)

//---------------
//--- #dBound ---
//---------------

// TODO: finish writing/testing semantics for general Procs
// TODO: Mem subues for several Names/Procs

// Name
  rule #dBound( I:Int ; _:NameVar ; _:Map   ) => boundN(I)
  rule #dBound( I:Int ; @P:Proc   ; Mem:Map ) => @ #dBound(I;P;Mem)

  // several Names
  rule #dBound( I:Int ; A:Name , B:Name  ; Mem:Map ) => #dBound(I;A;Mem) , #dBound( I +Int 1 ;B;Mem)
  rule #dBound( I:Int ; A:Name , B:Names ; Mem:Map ) => #dBound(I;A;Mem) , #dBound( I +Int 1 ;B;Mem)

// Proc
  rule #dBound( _:Int ; G:Ground  ; _:Map   ) => G
  rule #dBound( I:Int ; _:ProcVar ; _:Map   ) => boundP(I)
  rule #dBound( I:Int ; *N:Name   ; Mem:Map ) => * #dBound(I;N;Mem)

  // Send
  rule #dBound( I:Int ; A:Name ! ( B:Proc  ) ; Mem:Map ) => #dBound(I;A;Mem) ! ( #dBound(I;B;Mem) )
  rule #dBound( I:Int ; A:Name ! ( B:Procs ) ; Mem:Map ) => #dBound(I;A;Mem) ! ( #dBound(I;B;Mem) )

  // Receive -- increase nesting index for bound Names
  rule #dBound( I:Int ; for(        <- X:Name ){ P:Proc } ; Mem:Map ) => for(   <- #dBound(I;X;Mem) ){ #dBound(I;P;Mem) }
  rule #dBound( I:Int ; for( Y:Name <- X:Name ){ P:Proc } ; Mem:Map ) 
    => for( #dBound(1,I;Y;.Map) <- #dBound(I;X;Mem) ){ #deBruijn(1,I +Int 1;#sub(#dBound(1,I;Y;.Map);Y;P); updateMap( Mem , #mapify(I;X;Mem) ) ) }

  // Par
  rule #dBound( I:Int ; A:Proc | B:Proc  ; Mem:Map ) => #dBound(I;A;Mem) | #dBound(I +Int 1;B;Mem) requires notBool isPar(A)

  // several Procs -- increase index for each name (if not already bound)
  rule #dBound( I:Int ; A:Proc , B:Proc  ; Mem:Map ) => #dBound(I;A;Mem) , #dBound(I +Int 1;B;Mem)
  rule #dBound( I:Int ; A:Proc , B:Procs ; Mem:Map ) => #dBound(I;A;Mem) , #dBound(I +Int 1;B;Mem)

// Nested
  // Name
  rule #dBound( I:Int , J:Int ; _:NameVar ; _:Map   ) => boundN(I,J)
  rule #dBound( I:Int , J:Int ; @P:Proc   ; Mem:Map ) => @ #dBound(I,J;P;Mem)

    // several Names
  rule #dBound( I:Int , J:Int ; A:Name , B:Name  ; Mem:Map ) => #dBound(I,J;A;Mem) , #dBound( I,J +Int 1;B;Mem)
  rule #dBound( I:Int , J:Int ; A:Name , B:Names ; Mem:Map ) => #dBound(I,J;A;Mem) , #dBound( I,J +Int 1;B;Mem)

  // Proc
  rule #dBound( _:Int , _:Int ; G:Ground  ; _:Map   ) => G
  rule #dBound( I:Int , J:Int ; _:ProcVar ; _:Map   ) => boundP(I,J)
  rule #dBound( I:Int , J:Int ; *N:Name   ; Mem:Map ) => * #dBound(I,J;N;Mem)

    // Send
  rule #dBound( I:Int , J:Int ; A:Name ! ( B:Proc  ) ; Mem:Map ) => #dBound(I,J;A;Mem) ! ( #dBound(I,J;B;Mem) )
  rule #dBound( I:Int , J:Int ; A:Name ! ( B:Procs ) ; Mem:Map ) => #dBound(I,J;A;Mem) ! ( #dBound(I,J;B;Mem) )

    // Receive -- increase nesting index for bound Names
  rule #dBound( I:Int , J:Int ; for(   <- X:Name ){ P:Proc } ; Mem:Map ) => for(   <- #dBound(I,J;X;Mem) ){ #dBound(I,J;P;Mem) }

    // several Names
  rule #dBound( I:Int , J:Int ; A:Proc , B:Proc  ; Mem:Map ) => #dBound(I,J;A;Mem) , #dBound(I,J +Int 1;B;Mem)
  rule #dBound( I:Int , J:Int ; A:Proc , B:Procs ; Mem:Map ) => #dBound(I,J;A;Mem) , #dBound(I,J +Int 1;B;Mem)

//---------------
//--- #mapify ---
//---------------
// returns De Bruijn index map for a given Int, Name or Proc, and Map

// Name
  rule #mapify( I:Int ; A:NameVar   ; Mem:Map ) => updateMap( Mem , A |-> boundN(I) )
  rule #mapify( _:Int ; _:BoundName ; Mem:Map ) => Mem
  rule #mapify( I:Int ; @ A:Proc    ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) ) // can .Map be used here?


  // several Names
  rule #mapify( I:Int ; A:Name , B:Name  ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) #mapify(I +Int 1;B;Mem) )
  rule #mapify( I:Int ; A:Name , B:Names ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) #mapify(I +Int 1;B;Mem) )

// Proc
  rule #mapify( _:Int ; _:Ground    ; Mem:Map ) => Mem
  rule #mapify( I:Int ; A:ProcVar   ; Mem:Map ) => updateMap( Mem , A |-> boundP(I) )
  rule #mapify( _:Int ; _:BoundProc ; Mem:Map ) => Mem
  rule #mapify( I:Int ; * A:Name    ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) ) // can .Map be used here?

  // several Procs
  rule #mapify( I:Int ; A:Proc , B:Proc  ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) #mapify(I +Int 1;B;Mem) )
  rule #mapify( I:Int ; A:Proc , B:Procs ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) #mapify(I +Int 1;B;Mem) )

  // New
  rule #mapify( I:Int ; new A:Name in { B:Proc } ; Mem:Map ) 
    => updateMap( Mem , A |-> boundN(I) #mapify( I +Int 1 ; #sub(boundN(I);A;B) ; Mem ) ) requires notBool (A in values(Mem))
  rule #mapify( I:Int ; new A:Name in { B:Proc } ; Mem:Map ) 
    => updateMap( Mem , A |-> boundN(I) #mapify( I +Int 1 ; #sub(boundN(I);A;B) ; Mem ) ) requires A in values(Mem)

  // Par
  rule #mapify( I:Int ; A:Proc | B:Proc ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) #mapify(I +Int 1;B;Mem) )

  // Send
  rule #mapify( I:Int ; A:Name ! ( B:Proc ) ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) #mapify(I;B;Mem) )

  // Receive -- TODO: more testing
  rule #mapify( I:Int ; for(   <- X:Name ){ P:Proc } ; Mem:Map ) => #mapify(I +Int 1;P;updateMap(Mem,#mapify(I;X;Mem)))
    // sub @Nil for bound variable so no binding is recorded
  rule #mapify( I:Int ; for(         Y:Name  <- X:Name ){ P:Proc } ; Mem:Map ) => #mapify(I +Int 1;#sub(@Nil;Y;P);updateMap(Mem,#mapify(I;X;Mem)))
  rule #mapify( I:Int ; for( Y:Name, Z:Name  <- X:Name ){ P:Proc } ; Mem:Map ) => #mapify(I +Int 1;for(Z<-X){#sub(@Nil;Y;P)};updateMap(Mem,#mapify(I;X;Mem)))
  rule #mapify( I:Int ; for( Y:Name, Z:Names <- X:Name ){ P:Proc } ; Mem:Map ) => #mapify(I +Int 1;for(Z<-X){#sub(@Nil;Y;P)};updateMap(Mem,#mapify(I;X;Mem)))

  rule #mapify( I:Int ; for(                 <= X:Name ){ P:Proc } ; Mem:Map ) => #mapify(I +Int 1;P;updateMap(Mem,#mapify(I;X;Mem)))
  rule #mapify( I:Int ; for(         Y:Name  <= X:Name ){ P:Proc } ; Mem:Map ) => #mapify(I +Int 1;#sub(@Nil;Y;P);updateMap(Mem,#mapify(I;X;Mem)))
  rule #mapify( I:Int ; for( Y:Name, Z:Name  <= X:Name ){ P:Proc } ; Mem:Map ) => #mapify(I +Int 1;for(Z<=X){#sub(@Nil;Y;P)};updateMap(Mem,#mapify(I;X;Mem)))
  rule #mapify( I:Int ; for( Y:Name, Z:Names <= X:Name ){ P:Proc } ; Mem:Map ) => #mapify(I +Int 1;for(Z<=X){#sub(@Nil;Y;P)};updateMap(Mem,#mapify(I;X;Mem)))

  rule #mapify( I:Int ; for(                 <! X:Name ){ P:Proc } ; Mem:Map ) => #mapify(I +Int 1;P;updateMap(Mem,#mapify(I;X;Mem)))
  rule #mapify( I:Int ; for(         Y:Name  <! X:Name ){ P:Proc } ; Mem:Map ) => #mapify(I +Int 1;#sub(@Nil;Y;P);updateMap(Mem,#mapify(I;X;Mem)))
  rule #mapify( I:Int ; for( Y:Name, Z:Name  <! X:Name ){ P:Proc } ; Mem:Map ) => #mapify(I +Int 1;for(Z<!X){#sub(@Nil;Y;P)};updateMap(Mem,#mapify(I;X;Mem)))
  rule #mapify( I:Int ; for( Y:Name, Z:Names <! X:Name ){ P:Proc } ; Mem:Map ) => #mapify(I +Int 1;for(Z<!X){#sub(@Nil;Y;P)};updateMap(Mem,#mapify(I;X;Mem)))

// Nested #mapify
  // Name
  rule #mapify( I:Int , J:Int ; A:NameVar   ; Mem:Map ) => updateMap( Mem , A |-> boundN(I,J) )
  rule #mapify( _:Int , _:Int ; _:BoundName ; Mem:Map ) => Mem
  rule #mapify( I:Int , J:Int ; @ A:Proc    ; Mem:Map ) => updateMap( Mem , #mapify(I,J;A;Mem) ) // can .Map be used here?


    // several Names
  rule #mapify( I:Int , J:Int ; A:Name , B:Name  ; Mem:Map ) => updateMap( Mem , #mapify(I,J;A;Mem) #mapify(I,J +Int 1;B;Mem) )
  rule #mapify( I:Int , J:Int ; A:Name , B:Names ; Mem:Map ) => updateMap( Mem , #mapify(I,J;A;Mem) #mapify(I,J +Int 1;B;Mem) )

  // Proc
  rule #mapify( _:Int , _:Int ; _:Ground    ; Mem:Map ) => Mem
  rule #mapify( I:Int , J:Int ; A:ProcVar   ; Mem:Map ) => updateMap( Mem , A |-> boundP(I,J) )
  rule #mapify( _:Int , _:Int ; _:BoundProc ; Mem:Map ) => Mem
  rule #mapify( I:Int , J:Int ; * A:Name    ; Mem:Map ) => updateMap( Mem , #mapify(I,J;A;Mem) ) // can .Map be used here?

    // several Procs
  rule #mapify( I:Int , J:Int ; A:Proc , B:Proc  ; Mem:Map ) => updateMap( Mem , #mapify(I,J;A;Mem) #mapify(I,J +Int 1;B;Mem) )
  rule #mapify( I:Int , J:Int ; A:Proc , B:Procs ; Mem:Map ) => updateMap( Mem , #mapify(I,J;A;Mem) #mapify(I,J +Int 1;B;Mem) )

    // New
  rule #mapify( I:Int , J:Int ; new A:Name in { B:Proc } ; Mem:Map ) 
    => updateMap( Mem , A |-> boundN(I,J) #mapify( I,J +Int 1 ; #sub(boundN(I,J);A;B) ; Mem ) ) requires notBool (A in values(Mem))

  rule #mapify( I:Int , J:Int ; new A:Name in { B:Proc } ; Mem:Map ) 
    => updateMap( Mem , A |-> boundN(I,J) #mapify( I,J +Int 1 ; #sub(boundN(I,J);A;B) ; Mem ) ) requires A in values(Mem)

    // Par
  rule #mapify( I:Int , J:Int ; A:Proc | B:Proc ; Mem:Map ) => updateMap( Mem , #mapify(I,J;A;Mem) #mapify(I,J +Int 1;B;Mem) )

    // Send
  rule #mapify( I:Int , J:Int ; A:Name ! ( B:Proc ) ; Mem:Map ) => updateMap( Mem , #mapify(I,J;A;Mem) #mapify(I,J +Int 1;B;Mem) )

    // Receive -- TODO: more testing
  rule #mapify( I:Int , J:Int ; for(                 <- X:Name ){ P:Proc } ; Mem:Map ) => #mapify(I +Int 1;P;updateMap(Mem,#mapify(I,J;X;Mem)))
  rule #mapify( I:Int , J:Int ; for(         Y:Name  <- X:Name ){ P:Proc } ; Mem:Map ) => #mapify(I,J +Int 1;#sub(@Nil;Y;P);updateMap(Mem,#mapify(I,J;X;Mem)))
  rule #mapify( I:Int , J:Int ; for( Y:Name, Z:Name  <- X:Name ){ P:Proc } ; Mem:Map ) => #mapify(I,J +Int 1;for(Z<-X){#sub(@Nil;Y;P)};updateMap(Mem,#mapify(I,J;X;Mem)))
  rule #mapify( I:Int , J:Int ; for( Y:Name, Z:Names <- X:Name ){ P:Proc } ; Mem:Map ) => #mapify(I,J +Int 1;for(Z<-X){#sub(@Nil;Y;P)};updateMap(Mem,#mapify(I,J;X;Mem)))

  rule #mapify( I:Int , J:Int ; for(                 <= X:Name ){ P:Proc } ; Mem:Map ) => #mapify(I,J +Int 1;P;updateMap(Mem,#mapify(I,J;X;Mem)))
  rule #mapify( I:Int , J:Int ; for(         Y:Name  <= X:Name ){ P:Proc } ; Mem:Map ) => #mapify(I,J +Int 1;#sub(@Nil;Y;P);updateMap(Mem,#mapify(I,J;X;Mem)))
  rule #mapify( I:Int , J:Int ; for( Y:Name, Z:Name  <= X:Name ){ P:Proc } ; Mem:Map ) => #mapify(I,J +Int 1;for(Z<=X){#sub(@Nil;Y;P)};updateMap(Mem,#mapify(I,J;X;Mem)))
  rule #mapify( I:Int , J:Int ; for( Y:Name, Z:Names <= X:Name ){ P:Proc } ; Mem:Map ) => #mapify(I,J +Int 1;for(Z<=X){#sub(@Nil;Y;P)};updateMap(Mem,#mapify(I,J;X;Mem)))

  rule #mapify( I:Int , J:Int ; for(                 <! X:Name ){ P:Proc } ; Mem:Map ) => #mapify(I,J +Int 1;P;updateMap(Mem,#mapify(I,J;X;Mem)))
  rule #mapify( I:Int , J:Int ; for(         Y:Name  <! X:Name ){ P:Proc } ; Mem:Map ) => #mapify(I,J +Int 1;#sub(@Nil;Y;P);updateMap(Mem,#mapify(I,J;X;Mem)))
  rule #mapify( I:Int , J:Int ; for( Y:Name, Z:Name  <! X:Name ){ P:Proc } ; Mem:Map ) => #mapify(I,J +Int 1;for(Z<!X){#sub(@Nil;Y;P)};updateMap(Mem,#mapify(I,J;X;Mem)))
  rule #mapify( I:Int , J:Int ; for( Y:Name, Z:Names <! X:Name ){ P:Proc } ; Mem:Map ) => #mapify(I,J +Int 1;for(Z<!X){#sub(@Nil;Y;P)};updateMap(Mem,#mapify(I,J;X;Mem)))

  rule   @ * N:Name => N  [anywhere, structural]
  rule   * @ P:Proc => P  [anywhere, structural]

endmodule