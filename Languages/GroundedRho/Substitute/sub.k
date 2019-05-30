// SUBSTITUTION FOR GRHO
/*
TODO:
 - add remaining features - Methods, Bundles, 
 - more testing
*/
/*
  This substitution function is needed to make distinct the notions of name variables and process variables.
  The builtin substitution does not make this distinction.
  E.g. we want the substitution (x!(\x))[@Nil / x] to result in @Nil!(\x) since we only substitute for x:NameVar, NOT \x:ProcVar
    the definitions of NameVar ::= Var and ProcVar ::= "\\" Var don't allow for this with the the builtin substitution
*/

require "domains.k"
require "../AuxFun/auxfun.k"
require "../Names_Variables/namevar.k"
require "../grho.k"

module SUB-SYNTAX
  import GRHO-SYNTAX
  import DOMAINS

  syntax   Proc ::= "#sub(" Proc  ";" Proc  ";" Proc ")"     [function, poly(0,3)]
                  | "#sub(" Procs ";" Procs ";" Proc ")"     [function, poly(0,3)]
                  | "#sub(" Name  ";" Name  ";" Proc ")"     [function, poly(0,3)]
                  | "#sub(" Names ";" Names ";" Proc ")"     [function, poly(0,3)]
                  | "#subRec("  Proc  ";" Proc  ";" Proc ")" [function]
                  | "#subRec("  Procs ";" Procs ";" Proc ")" [function]
                  | "#subRec("  Name  ";" Name  ";" Proc ")" [function]
                  | "#subRec("  Names ";" Names ";" Proc ")" [function]
                  | "#subChan(" Proc  ";" Proc  ";" Proc ")" [function]
                  | "#subChan(" Procs ";" Procs ";" Proc ")" [function]
                  | "#subChan(" Name  ";" Name  ";" Proc ")" [function]
                  | "#subChan(" Names ";" Names ";" Proc ")" [function]
                  | "#subNew("  Proc  ";" Proc  ";" New  ")" [function]
                  | "#subNew("  Procs ";" Procs ";" New  ")" [function]
                  | "#subNew("  Name  ";" Name  ";" New  ")" [function]
                  | "#subNew("  Names ";" Names ";" New  ")" [function]

  syntax   Name ::= "#sub(" Name  ";" Name  ";" Name ")"     [function]
                  | "#sub(" Names ";" Names ";" Name ")"     [function]
                  | "#sub(" Proc  ";" Proc  ";" Name ")"     [function]
                  | "#sub(" Procs ";" Procs ";" Name ")"     [function]
                  | "#sub(" Map   ";" Name  ")"              [function]

  syntax  Procs ::= "#sub(" Proc  ";" Proc  ";" Procs ")"    [function]
                  | "#sub(" Procs ";" Procs ";" Procs ")"    [function]
                  | "#sub(" Name  ";" Name  ";" Procs ")"    [function]
                  | "#sub(" Names ";" Names ";" Procs ")"    [function]
                  | "#sub(" Procs ";" Procs ")"              [function]

  syntax  Names ::= "#sub(" Proc  ";" Proc  ";" Names ")"    [function]
                  | "#sub(" Procs ";" Procs ";" Names ")"    [function]
                  | "#sub(" Name  ";" Name  ";" Names ")"    [function]
                  | "#sub(" Names ";" Names ";" Names ")"    [function]
                  | "#sub(" Names ";" Names ")"              [function]
/*
  syntax   Proc ::= "#subDB(" Proc  ";" Proc  ";" Proc ")"   [function]
                  | "#subDB(" Procs ";" Procs ";" Proc ")"   [function]
                  | "#subDB(" Name  ";" Name  ";" Proc ")"   [function]
                  | "#subDB(" Names ";" Names ";" Proc ")"   [function]
*/
  syntax  RhoKVPair ::= "#subKV(" Proc  ";" Proc  ";" RhoKVPair  ")" [function]
                      | "#subKV(" Procs ";" Procs ";" RhoKVPair  ")" [function]
                      | "#subKV(" Name  ";" Name  ";" RhoKVPair  ")" [function]
                      | "#subKV(" Names ";" Names ";" RhoKVPair  ")" [function]
  syntax RhoKVPairs ::= "#subKV(" Proc  ";" Proc  ";" RhoKVPairs ")" [function]
                      | "#subKV(" Procs ";" Procs ";" RhoKVPairs ")" [function]
                      | "#subKV(" Name  ";" Name  ";" RhoKVPairs ")" [function]
                      | "#subKV(" Names ";" Names ";" RhoKVPairs ")" [function]

// Map substitutions
  syntax       Name ::= "#sub(" Map ";" Name  ")" [function]
  syntax      Names ::= "#sub(" Map ";" Names ")" [function]
  syntax       Proc ::= "#sub(" Map ";" Proc  ")" [function]
  syntax      Procs ::= "#sub(" Map ";" Procs ")" [function]

endmodule

module SUB
  import SUB-SYNTAX
  import AUXFUN
  import NAMEVAR

  syntax KResult ::= Name | Names | Proc | Procs

// BoundName/Proc subs for ALPHA
  // requirements of #sub function on BoundNames/Procs for finishing De Bruijn index substitutions
  rule #sub( A:Name ; B:Name ;  C:BoundName ) =>  C requires notBool (isBoundName(A) andBool isBoundName(B))
  rule #sub( A:Proc ; B:Proc ;  C:BoundName ) =>  C requires notBool (isBoundProc(A) andBool isBoundProc(B))
  rule #sub( A:Name ; B:Name ; *C:BoundName ) => *C requires notBool (isBoundName(A) andBool isBoundName(B))
  rule #sub( A:Proc ; B:Proc ; *C:BoundName ) => *C requires notBool (isBoundProc(A) andBool isBoundProc(B))
  rule #sub( A:BoundName ; _:BoundName ;  _:BoundName ) =>  A
  rule #sub( A:BoundName ; _:BoundName ; *_:BoundName ) => *A
  rule #sub( A:BoundName ; _:BoundName ;  _:NameVar   ) =>  A
  rule #sub( A:BoundName ; _:BoundName ; *_:NameVar   ) => *A
  rule #sub( _:BoundName ; _:BoundName ;  C:ProcVar   ) =>  C
  rule #sub( _:BoundName ; _:BoundName ; @C:ProcVar   ) => @C
  rule #sub( _:BoundName ; _:BoundName ;  C:BoundProc ) =>  C
  rule #sub( _:BoundName ; _:BoundName ; @C:BoundProc ) => @C

  rule #sub( A:Name ; B:Name ;  C:BoundProc ) =>  C requires notBool (isBoundName(A) andBool isBoundName(B))
  rule #sub( A:Proc ; B:Proc ;  C:BoundProc ) =>  C requires notBool (isBoundProc(A) andBool isBoundProc(B))
  rule #sub( A:Name ; B:Name ; @C:BoundProc ) => @C requires notBool (isBoundName(A) andBool isBoundName(B))
  rule #sub( A:Proc ; B:Proc ; @C:BoundProc ) => @C requires notBool (isBoundProc(A) andBool isBoundProc(B))
  rule #sub( A:BoundProc ; _:BoundProc ;  _:BoundProc ) =>  A
  rule #sub( A:BoundProc ; _:BoundProc ; @_:BoundProc ) => @A
  rule #sub( A:BoundProc ; _:BoundProc ;  _:ProcVar   ) =>  A
  rule #sub( A:BoundProc ; _:BoundProc ; @_:ProcVar   ) => @A
  rule #sub( _:BoundProc ; _:BoundProc ;  C:NameVar   ) =>  C
  rule #sub( _:BoundProc ; _:BoundProc ; *C:NameVar   ) => *C
  rule #sub( _:BoundProc ; _:BoundProc ;  C:BoundName ) =>  C
  rule #sub( _:BoundProc ; _:BoundProc ; *C:BoundName ) => *C

//------------------------------------------------
//--- Substitute Proc for Proc in Proc or Name ---
//------------------------------------------------
  // trivial cases
  rule #sub( A:Proc ; A ; N:Name ) => N
  rule #sub( A:Proc ; A ; P:Proc ) => P
  rule #sub( _:Proc ; _:Proc ; G:Ground ) => G

  // sub Proc for ProcVar in ProcVar or NameVar
  rule #sub( A:Proc ; B:ProcVar ; C:ProcVar ) => A requires B ==K C
  rule #sub( A:Proc ; B:ProcVar ; C:ProcVar ) => C requires B =/=K C
  rule #sub( _:Proc ; _:ProcVar ; A:NameVar ) => A

  // sub Proc for *NameVar in NameVar or ProcVar
  rule #sub( A:Proc ; *B:NameVar ; C:NameVar ) => @A requires B ==K C
  rule #sub( A:Proc ; *B:NameVar ; C:NameVar ) =>  C requires B =/=K C
  rule #sub( _:Proc ; *_:NameVar ; A:ProcVar ) =>  A

  // sub Proc for Proc in @Proc
  rule #sub( A:Proc ; B:Proc ; @C:Proc ) => @ #sub(A;B;C)

  // sub Proc for Proc in *Name
  rule #sub( A:Proc ; B:Proc ; *C:Name ) => * #sub(A;B;C)

  // sub *Name for *Name in Proc
  rule #sub( *A:Name ; *B:Name ; C:Proc ) => #sub(A;B;C)

  // sub Proc for Proc in Send
  rule #sub( A:Proc ; B:Proc ; C:Name !  ( D:Proc  ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc ; C:Name !  ( D:Procs ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc ; C:Name !! ( D:Proc  ) ) => #sub(A;B;C) !! ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc ; C:Name !! ( D:Procs ) ) => #sub(A;B;C) !! ( #sub(A;B;D) )

  // sub Proc for Proc in Receive -- only substitute variables that DO NOT appear as binding variables
  rule #sub( A:Proc ; B:Proc ; C:Receive ) => #if (@B #in #bvar(C)) #then #subChan(A;B;C) #else #subRec(A;B;C) #fi
    // substitute free variables - in channel and continuation
  rule #subRec( A:Proc ; B:Proc ; for(         <- X:Name ){ P:Proc } ) => for(   <- #sub(A;B;X) ){ #sub(A;B;P) }
  rule #subRec( A:Proc ; B:Proc ; for( Y:Name  <- X:Name ){ P:Proc } ) => for( Y <- #sub(A;B;X) ){ #sub(A;B;P) }
  rule #subRec( A:Proc ; B:Proc ; for( Y:Names <- X:Name ){ P:Proc } ) => for( Y <- #sub(A;B;X) ){ #sub(A;B;P) }
  rule #subRec( A:Proc ; B:Proc ; for(         <= X:Name ){ P:Proc } ) => for(   <= #sub(A;B;X) ){ #sub(A;B;P) }
  rule #subRec( A:Proc ; B:Proc ; for( Y:Name  <= X:Name ){ P:Proc } ) => for( Y <= #sub(A;B;X) ){ #sub(A;B;P) }
  rule #subRec( A:Proc ; B:Proc ; for( Y:Names <= X:Name ){ P:Proc } ) => for( Y <= #sub(A;B;X) ){ #sub(A;B;P) }
  rule #subRec( A:Proc ; B:Proc ; for(         <! X:Name ){ P:Proc } ) => for(   <! #sub(A;B;X) ){ #sub(A;B;P) }
  rule #subRec( A:Proc ; B:Proc ; for( Y:Name  <! X:Name ){ P:Proc } ) => for( Y <! #sub(A;B;X) ){ #sub(A;B;P) }
  rule #subRec( A:Proc ; B:Proc ; for( Y:Names <! X:Name ){ P:Proc } ) => for( Y <! #sub(A;B;X) ){ #sub(A;B;P) }
    // guarded
  rule #subRec( A:Proc ; B:Proc ; for(         <- X:Name G:Guard ){ P:Proc } ) => for(   <- #sub(A;B;X) G){ #sub(A;B;P) }
  rule #subRec( A:Proc ; B:Proc ; for( Y:Name  <- X:Name G:Guard ){ P:Proc } ) => for( Y <- #sub(A;B;X) G){ #sub(A;B;P) }
  rule #subRec( A:Proc ; B:Proc ; for( Y:Names <- X:Name G:Guard ){ P:Proc } ) => for( Y <- #sub(A;B;X) G){ #sub(A;B;P) }
  rule #subRec( A:Proc ; B:Proc ; for(         <= X:Name G:Guard ){ P:Proc } ) => for(   <= #sub(A;B;X) G){ #sub(A;B;P) }
  rule #subRec( A:Proc ; B:Proc ; for( Y:Name  <= X:Name G:Guard ){ P:Proc } ) => for( Y <= #sub(A;B;X) G){ #sub(A;B;P) }
  rule #subRec( A:Proc ; B:Proc ; for( Y:Names <= X:Name G:Guard ){ P:Proc } ) => for( Y <= #sub(A;B;X) G){ #sub(A;B;P) }
  rule #subRec( A:Proc ; B:Proc ; for(         <! X:Name G:Guard ){ P:Proc } ) => for(   <! #sub(A;B;X) G){ #sub(A;B;P) }
  rule #subRec( A:Proc ; B:Proc ; for( Y:Name  <! X:Name G:Guard ){ P:Proc } ) => for( Y <! #sub(A;B;X) G){ #sub(A;B;P) }
  rule #subRec( A:Proc ; B:Proc ; for( Y:Names <! X:Name G:Guard ){ P:Proc } ) => for( Y <! #sub(A;B;X) G){ #sub(A;B;P) }
    // substitute free variables - only in channel
  rule #subChan( A:Proc ; B:Proc ; for(         <- X:Name ){ P:Proc } ) => for(   <- #sub(A;B;X) ){ P }
  rule #subChan( A:Proc ; B:Proc ; for( Y:Name  <- X:Name ){ P:Proc } ) => for( Y <- #sub(A;B;X) ){ P }
  rule #subChan( A:Proc ; B:Proc ; for( Y:Names <- X:Name ){ P:Proc } ) => for( Y <- #sub(A;B;X) ){ P }
  rule #subChan( A:Proc ; B:Proc ; for(         <= X:Name ){ P:Proc } ) => for(   <= #sub(A;B;X) ){ P }
  rule #subChan( A:Proc ; B:Proc ; for( Y:Name  <= X:Name ){ P:Proc } ) => for( Y <= #sub(A;B;X) ){ P }
  rule #subChan( A:Proc ; B:Proc ; for( Y:Names <= X:Name ){ P:Proc } ) => for( Y <= #sub(A;B;X) ){ P }
  rule #subChan( A:Proc ; B:Proc ; for(         <! X:Name ){ P:Proc } ) => for(   <! #sub(A;B;X) ){ P }
  rule #subChan( A:Proc ; B:Proc ; for( Y:Name  <! X:Name ){ P:Proc } ) => for( Y <! #sub(A;B;X) ){ P }
  rule #subChan( A:Proc ; B:Proc ; for( Y:Names <! X:Name ){ P:Proc } ) => for( Y <! #sub(A;B;X) ){ P }
    // guarded
  rule #subChan( A:Proc ; B:Proc ; for(         <- X:Name G:Guard ){ P:Proc } ) => for(   <- #sub(A;B;X) G){ P }
  rule #subChan( A:Proc ; B:Proc ; for( Y:Name  <- X:Name G:Guard ){ P:Proc } ) => for( Y <- #sub(A;B;X) G){ P }
  rule #subChan( A:Proc ; B:Proc ; for( Y:Names <- X:Name G:Guard ){ P:Proc } ) => for( Y <- #sub(A;B;X) G){ P }
  rule #subChan( A:Proc ; B:Proc ; for(         <= X:Name G:Guard ){ P:Proc } ) => for(   <= #sub(A;B;X) G){ P }
  rule #subChan( A:Proc ; B:Proc ; for( Y:Name  <= X:Name G:Guard ){ P:Proc } ) => for( Y <= #sub(A;B;X) G){ P }
  rule #subChan( A:Proc ; B:Proc ; for( Y:Names <= X:Name G:Guard ){ P:Proc } ) => for( Y <= #sub(A;B;X) G){ P }
  rule #subChan( A:Proc ; B:Proc ; for(         <! X:Name G:Guard ){ P:Proc } ) => for(   <! #sub(A;B;X) G){ P }
  rule #subChan( A:Proc ; B:Proc ; for( Y:Name  <! X:Name G:Guard ){ P:Proc } ) => for( Y <! #sub(A;B;X) G){ P }
  rule #subChan( A:Proc ; B:Proc ; for( Y:Names <! X:Name G:Guard ){ P:Proc } ) => for( Y <! #sub(A;B;X) G){ P }

  // sub Proc for Proc in Par -- apply after normalization
  rule #sub( A:Proc ; B:Proc ; C:Proc | D:Proc ) => #sub(A;B;C) | #sub(A;B;D)

// sub Proc for Proc in Collections
  // RhoList
  rule #sub( _:Proc ; _:Proc ; [ ] ) => [ ]
  rule #sub( A:Proc ; B:Proc ; [ C:Proc  ] ) => [ #sub(A;B;C) ]
  rule #sub( A:Proc ; B:Proc ; [ C:Proc , D:Proc  ] ) => [ #sub(A;B;C) , #sub(A;B;D) ]
  rule #sub( A:Proc ; B:Proc ; [ C:Proc , D:Procs ] ) => [ #sub(A;B;C) , #sub(A;B;D) ]

  // RhoMap
  rule #sub( _:Proc ; _:Proc ; { } ) => { }
  rule #sub( A:Proc ; B:Proc ; { C:RhoKVPair  } ) => { #subKV(A;B;C) }
  rule #sub( A:Proc ; B:Proc ; { C:RhoKVPair , D:RhoKVPair  } ) => { #subKV(A;B;C) , #subKV(A;B;D) }
  rule #sub( A:Proc ; B:Proc ; { C:RhoKVPair , D:RhoKVPairs } ) => { #subKV(A;B;C) , #subKV(A;B;D) }
    // RhoKVPairs
  rule #subKV( A:Proc ; B:Proc ; C:Proc : D:Proc ) => #sub(A;B;C) : #sub(A;B;D)
  rule #subKV( A:Proc ; B:Proc ; C:RhoKVPair , D:RhoKVPair ) => #subKV(A;B;C) , #subKV(A;B;D)
  rule #subKV( A:Proc ; B:Proc ; C:RhoKVPair , D:RhoKVPair ) => #subKV(A;B;C) , #subKV(A;B;D)

  // RhoSet
  rule #sub( _:Proc ; _:Proc ; Set( ) ) => Set( )
  rule #sub( A:Proc ; B:Proc ; Set( C:Proc  ) ) => Set( #sub(A;B;C) )
  rule #sub( A:Proc ; B:Proc ; Set( C:Proc , D:Proc  ) ) => Set( #sub(A;B;C) , #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc ; Set( C:Proc , D:Procs ) ) => Set( #sub(A;B;C) , #sub(A;B;D) )

  // RhoTuple
  rule #sub( _:Proc ; _:Proc ; ( ) ) => ( )
  rule #sub( A:Proc ; B:Proc ; tuple( C:Proc  ) ) => tuple( #sub(A;B;C) )
  rule #sub( A:Proc ; B:Proc ; tuple( C:Procs ) ) => tuple( #sub(A;B;C) )

// sub Proc for Proc in New
  rule #sub( A:Proc ; B:ProcVar ; P:New ) => #if (@B #in #dec(P)) #then P #else #subNew(A;B;P) #fi
/*
  rule #sub( A:Proc , B:Proc  ; C:Proc , D:Proc  ; P:New ) => #if (C #in #dec(P)) 
                                                              #then #sub(B;D;P) 
                                                              #else #sub(B;D;#subNew(A;C;P)) 
                                                              #fi
  rule #sub( A:Proc , B:Procs ; C:Proc , D:Procs ; P:New ) => #if (C #in #dec(P)) 
                                                              #then #sub(B;D;P) 
                                                              #else #sub(B;D;#subNew(A;C;P)) 
                                                              #fi
*/
  rule #subNew( A:Proc ; B:Proc ; new C:Name  in { D:Proc } ) => new C in { #sub(A;B;D) }
  rule #subNew( A:Proc ; B:Proc ; new C:Names in { D:Proc } ) => new C in { #sub(A;B;D) }

// Arithmetic Exps
  rule #sub( A:Proc ; B:Proc ; - C:AExp ) => - #sub(A;B;C)
  rule #sub( A:Proc ; B:Proc ; C:AExp *  D:AExp ) => #sub(A;B;C) *  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:AExp /  D:AExp ) => #sub(A;B;C) /  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:AExp +  D:AExp ) => #sub(A;B;C) +  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:AExp -  D:AExp ) => #sub(A;B;C) -  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:AExp %  D:AExp ) => #sub(A;B;C) %  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:AExp ++ D:AExp ) => #sub(A;B;C) ++ #sub(A;B;D)

// Boolean Exps
  rule #sub( A:Proc ; B:Proc ; not C:BExp ) => not #sub(A;B;C)
  rule #sub( A:Proc ; B:Proc ; C:BExp and D:BExp ) => #sub(A;B;C) and #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:BExp or  D:BExp ) => #sub(A;B;C) or  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:AExp <=  D:AExp ) => #sub(A;B;C) <=  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:AExp <   D:AExp ) => #sub(A;B;C) <   #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:AExp >=  D:AExp ) => #sub(A;B;C) >=  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:AExp >   D:AExp ) => #sub(A;B;C) >   #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:Name ==  D:Name ) => #sub(A;B;C) ==  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:Name !=  D:Name ) => #sub(A;B;C) !=  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:Proc ==  D:Proc ) => #sub(A;B;C) ==  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:Proc !=  D:Proc ) => #sub(A;B;C) !=  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:Proc matches D:Proc ) => #sub(A;B;C) matches #sub(A;B;D)

// sub Proc for Proc in Names
  rule #sub( A:Proc ; B:Proc ; C:Name , D:Name  ) => #sub(A;B;C) , #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:Name , D:Names ) => #sub(A;B;C) , #sub(A;B;D)

// sub Proc for Proc in Procs
  rule #sub( A:Proc ; B:Proc ; C:Proc , D:Proc  ) => #sub(A;B;C) , #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:Proc , D:Procs ) => #sub(A;B;C) , #sub(A;B;D)

// Several Procs sub
  // sub Procs for Procs in Name -- applies after #match predicate
  rule #sub( A:Proc , B:Proc  ; C:Proc , D:Proc  ; N:Name ) => #sub(B;D;#sub(A;C;N))
  rule #sub( A:Proc , B:Procs ; C:Proc , D:Procs ; N:Name ) => #sub(B;D;#sub(A;C;N))

// sub Procs for Procs in Names
  rule #sub( A:Procs ; B:Procs ; M:Name , N:Name  ) => #sub(A;B;M) , #sub(A;B;N)
  rule #sub( A:Procs ; B:Procs ; M:Name , N:Names ) => #sub(A;B;M) , #sub(A;B;N)

// sub Procs for Procs in Proc
  rule #sub( A:Proc , B:Proc  ; C:Proc , D:Proc  ; P:Proc ) => #sub(B;D;#sub(A;C;P))
  rule #sub( A:Proc , B:Procs ; C:Proc , D:Procs ; P:Proc ) => #sub(B;D;#sub(A;C;P))

// sub Procs for Procs in Procs
  rule #sub( A:Procs ; B:Procs ; P:Proc , Q:Proc  ) => #sub(A;B;P) , #sub(A;B;Q)
  rule #sub( A:Procs ; B:Procs ; P:Proc , Q:Procs ) => #sub(A;B;P) , #sub(A;B;Q)

//-----------------------
//--- Deeper Patterns ---
//-----------------------

// sub Send for Send in Proc or Name - sub Name for Name and Proc(s) for Proc(s) in Proc or Name
  rule #sub( A:Name ! ( ) ; B:Name ! ( ) ; C:Proc ) => #sub(A;B;C)
  rule #sub( A:Name ! ( B:Proc  ) ; C:Name ! ( D:Proc  ) ; P:Proc ) => #sub(B;D;#sub(A;C;P))
  rule #sub( A:Name ! ( B:Procs ) ; C:Name ! ( D:Procs ) ; P:Proc ) => #sub(B;D;#sub(A;C;P))
  rule #sub( A:Name ! ( ) ; B:Name ! ( ) ; C:Name ) => #sub(A;B;C)
  rule #sub( A:Name ! ( B:Proc  ) ; C:Name ! ( D:Proc  ) ; N:Name ) => #sub(B;D;#sub(A;C;N))
  rule #sub( A:Name ! ( B:Procs ) ; C:Name ! ( D:Procs ) ; N:Name ) => #sub(B;D;#sub(A;C;N))

// sub Receive for Receive in Proc or Name
  rule #sub( for(         <- A:Name ){ P:Proc } ; for(         <- B:Name ){ Q:Proc } ; R:Proc ) => #sub(P;Q;#sub(A;B;R))
  rule #sub( for( _:Name  <- A:Name ){ P:Proc } ; for( _:Name  <- B:Name ){ Q:Proc } ; R:Proc ) => #sub(P;Q;#sub(A;B;R))
  rule #sub( for( _:Names <- A:Name ){ P:Proc } ; for( _:Names <- B:Name ){ Q:Proc } ; R:Proc ) => #sub(P;Q;#sub(A;B;R))
  rule #sub( for(         <= A:Name ){ P:Proc } ; for(         <= B:Name ){ Q:Proc } ; R:Proc ) => #sub(P;Q;#sub(A;B;R))
  rule #sub( for( _:Name  <= A:Name ){ P:Proc } ; for( _:Name  <= B:Name ){ Q:Proc } ; R:Proc ) => #sub(P;Q;#sub(A;B;R))
  rule #sub( for( _:Names <= A:Name ){ P:Proc } ; for( _:Names <= B:Name ){ Q:Proc } ; R:Proc ) => #sub(P;Q;#sub(A;B;R))
  rule #sub( for(         <! A:Name ){ P:Proc } ; for(         <! B:Name ){ Q:Proc } ; R:Proc ) => #sub(P;Q;#sub(A;B;R))
  rule #sub( for( _:Name  <! A:Name ){ P:Proc } ; for( _:Name  <! B:Name ){ Q:Proc } ; R:Proc ) => #sub(P;Q;#sub(A;B;R))
  rule #sub( for( _:Names <! A:Name ){ P:Proc } ; for( _:Names <! B:Name ){ Q:Proc } ; R:Proc ) => #sub(P;Q;#sub(A;B;R))
  rule #sub( for(         <- A:Name ){ P:Proc } ; for(         <- B:Name ){ Q:Proc } ; N:Name ) => #sub(P;Q;#sub(A;B;N))
  rule #sub( for( _:Name  <- A:Name ){ P:Proc } ; for( _:Name  <- B:Name ){ Q:Proc } ; N:Name ) => #sub(P;Q;#sub(A;B;N))
  rule #sub( for( _:Names <- A:Name ){ P:Proc } ; for( _:Names <- B:Name ){ Q:Proc } ; N:Name ) => #sub(P;Q;#sub(A;B;N))
  rule #sub( for(         <= A:Name ){ P:Proc } ; for(         <= B:Name ){ Q:Proc } ; N:Name ) => #sub(P;Q;#sub(A;B;N))
  rule #sub( for( _:Name  <= A:Name ){ P:Proc } ; for( _:Name  <= B:Name ){ Q:Proc } ; N:Name ) => #sub(P;Q;#sub(A;B;N))
  rule #sub( for( _:Names <= A:Name ){ P:Proc } ; for( _:Names <= B:Name ){ Q:Proc } ; N:Name ) => #sub(P;Q;#sub(A;B;N))
  rule #sub( for(         <! A:Name ){ P:Proc } ; for(         <! B:Name ){ Q:Proc } ; N:Name ) => #sub(P;Q;#sub(A;B;N))
  rule #sub( for( _:Name  <! A:Name ){ P:Proc } ; for( _:Name  <! B:Name ){ Q:Proc } ; N:Name ) => #sub(P;Q;#sub(A;B;N))
  rule #sub( for( _:Names <! A:Name ){ P:Proc } ; for( _:Names <! B:Name ){ Q:Proc } ; N:Name ) => #sub(P;Q;#sub(A;B;N))

// sub Par for Par in Name or Proc
  rule #sub( A:Proc | B:Proc ; C:Proc | D:Proc ; N:Name ) => #sub(B;D;#sub(A;C;N)) requires notBool (isPar(A) orBool isPar(C))
  rule #sub( A:Proc | B:Proc ; C:Proc | D:Proc ; P:Proc ) => #sub(B;D;#sub(A;C;P))

// TODO: other productions


// sub Proc for Proc in Map
  rule #sub( _:Proc ; _:Proc ; .Map ) => .Map
  rule #sub( A:Proc ; B:Proc ; C:Proc |-> D:Proc E:Map ) => #sub(A;B;C) |-> #sub(A;B;D) #sub(A;B;E)
  rule #sub( A:Proc ; B:Proc ; C:Name |-> D:Name E:Map ) => #sub(A;B;C) |-> #sub(A;B;D) #sub(A;B;E)


//------------------------------------------------
//--- Substitute Name for Name in Name or Proc ---
//------------------------------------------------
  // trivial cases
  rule #sub( A:Name ; A ; N:Name ) => N
  rule #sub( A:Name ; A ; P:Proc ) => P
  rule #sub( _:Name ; _:Name ; G:Ground ) => G

  // sub Name for NameVar in NameVar or ProcVar
  rule #sub( A:Name ; B:NameVar ; C:NameVar ) => A requires B ==K C
  rule #sub( A:Name ; B:NameVar ; C:NameVar ) => C requires B =/=K C
  rule #sub( _:Name ; _:NameVar ; A:ProcVar ) => A

  // sub Name for @ProcVar in NameVar
  rule #sub( A:Name ; @B:ProcVar ; C:ProcVar ) => *A requires B ==K C
  rule #sub( A:Name ; @B:ProcVar ; C:ProcVar ) =>  C requires B =/=K C
  rule #sub( _:Name ; @_:ProcVar ; A:NameVar ) =>  A

  // sub Name for Name in @Proc
  rule #sub( A:Name ; B:Name ; @C:Proc ) => @ #sub(A;B;C)

  // sub Name for Name in *Name
  rule #sub( A:Name ; B:Name ; *C:Name ) => * #sub(A;B;C)

  rule #sub( A:NameVar ; @B:Proc ; C:Proc ) => #sub(*A;B;C)

// sub @Proc for @Proc in Name & Proc - drop quotes
  rule #sub( @A:Proc ; @B:Proc ; C:Name ) => #sub(A;B;C)
  rule #sub( @A:Proc ; @B:Proc ; C:Proc ) => #sub(A;B;C)

// sub Name for Name in Receive
  // no common free variables means no substitution
  // TODO: need to check if free variables in B coincide with free variables in continuation which are bound in Rec
  rule #sub( _:Name ;  B:Name    ; Rec:Receive ) => Rec requires intersectSet(#FV(B),intersectSet(#FV(#cont(Rec)),#BV(Rec))) <=Set .Set
  // common free variables means substitution
  rule #sub( A:Name ;  B:NameVar ; Rec:Receive ) => #if (B in #BV(Rec)) #then #subChan(A;B;Rec) #else #subRec(A;B;Rec) #fi
   //    requires notBool intersectSet(#FV(B),#BV(Rec)) <=Set .Set
  rule #sub( A:Name ; @B:ProcVar ; Rec:Receive ) => #if (B in #BV(Rec)) #then #subChan(*A;B;Rec) #else #subRec(*A;B;Rec) #fi
   //    requires notBool intersectSet(#FV(B),#BSV(Rec)) <=Set .Set
  // if name to substitute is free, then it is substituted in the channel and continuation
  rule #subRec( A:Name ; B:NameVar ; for(         <- Chan:Name ){ Cont:Proc } ) => for(   <- #sub(A;B;Chan) ){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:NameVar ; for( Y:Name  <- Chan:Name ){ Cont:Proc } ) => for( Y <- #sub(A;B;Chan) ){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:NameVar ; for( Y:Names <- Chan:Name ){ Cont:Proc } ) => for( Y <- #sub(A;B;Chan) ){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:NameVar ; for(         <= Chan:Name ){ Cont:Proc } ) => for(   <= #sub(A;B;Chan) ){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:NameVar ; for( Y:Name  <= Chan:Name ){ Cont:Proc } ) => for( Y <= #sub(A;B;Chan) ){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:NameVar ; for( Y:Names <= Chan:Name ){ Cont:Proc } ) => for( Y <= #sub(A;B;Chan) ){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:NameVar ; for(         <! Chan:Name ){ Cont:Proc } ) => for(   <! #sub(A;B;Chan) ){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:NameVar ; for( Y:Name  <! Chan:Name ){ Cont:Proc } ) => for( Y <! #sub(A;B;Chan) ){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:NameVar ; for( Y:Names <! Chan:Name ){ Cont:Proc } ) => for( Y <! #sub(A;B;Chan) ){ #sub(A;B;Cont) }
    // guarded
  rule #subRec( A:Name ; B:NameVar ; for(         <- X:Name G:Guard ){ Cont:Proc } ) => for(   <- #sub(A;B;X) G){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:NameVar ; for( Y:Name  <- X:Name G:Guard ){ Cont:Proc } ) => for( Y <- #sub(A;B;X) G){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:NameVar ; for( Y:Names <- X:Name G:Guard ){ Cont:Proc } ) => for( Y <- #sub(A;B;X) G){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:NameVar ; for(         <= X:Name G:Guard ){ Cont:Proc } ) => for(   <= #sub(A;B;X) G){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:NameVar ; for( Y:Name  <= X:Name G:Guard ){ Cont:Proc } ) => for( Y <= #sub(A;B;X) G){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:NameVar ; for( Y:Names <= X:Name G:Guard ){ Cont:Proc } ) => for( Y <= #sub(A;B;X) G){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:NameVar ; for(         <! X:Name G:Guard ){ Cont:Proc } ) => for(   <! #sub(A;B;X) G){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:NameVar ; for( Y:Name  <! X:Name G:Guard ){ Cont:Proc } ) => for( Y <! #sub(A;B;X) G){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:NameVar ; for( Y:Names <! X:Name G:Guard ){ Cont:Proc } ) => for( Y <! #sub(A;B;X) G){ #sub(A;B;Cont) }
  // if name to be substituted is bound, then it is only substituted in the channel
  rule #subChan( A:Name ; B:NameVar ; for( Y:Name  <- Chan:Name ){ Cont:Proc } ) => for( Y <- #sub(A;B;Chan) ){ Cont }
  rule #subChan( A:Name ; B:NameVar ; for( Y:Names <- Chan:Name ){ Cont:Proc } ) => for( Y <- #sub(A;B;Chan) ){ Cont }
  rule #subChan( A:Name ; B:NameVar ; for( Y:Name  <= Chan:Name ){ Cont:Proc } ) => for( Y <= #sub(A;B;Chan) ){ Cont }
  rule #subChan( A:Name ; B:NameVar ; for( Y:Names <= Chan:Name ){ Cont:Proc } ) => for( Y <= #sub(A;B;Chan) ){ Cont }
  rule #subChan( A:Name ; B:NameVar ; for( Y:Name  <! Chan:Name ){ Cont:Proc } ) => for( Y <! #sub(A;B;Chan) ){ Cont }
  rule #subChan( A:Name ; B:NameVar ; for( Y:Names <! Chan:Name ){ Cont:Proc } ) => for( Y <! #sub(A;B;Chan) ){ Cont }
    // guarded
  rule #subChan( A:Name ; B:NameVar ; for(         <- X:Name G:Guard ){ Cont:Proc } ) => for(   <- #sub(A;B;X) G){ Cont }
  rule #subChan( A:Name ; B:NameVar ; for( Y:Name  <- X:Name G:Guard ){ Cont:Proc } ) => for( Y <- #sub(A;B;X) G){ Cont }
  rule #subChan( A:Name ; B:NameVar ; for( Y:Names <- X:Name G:Guard ){ Cont:Proc } ) => for( Y <- #sub(A;B;X) G){ Cont }
  rule #subChan( A:Name ; B:NameVar ; for(         <= X:Name G:Guard ){ Cont:Proc } ) => for(   <= #sub(A;B;X) G){ Cont }
  rule #subChan( A:Name ; B:NameVar ; for( Y:Name  <= X:Name G:Guard ){ Cont:Proc } ) => for( Y <= #sub(A;B;X) G){ Cont }
  rule #subChan( A:Name ; B:NameVar ; for( Y:Names <= X:Name G:Guard ){ Cont:Proc } ) => for( Y <= #sub(A;B;X) G){ Cont }
  rule #subChan( A:Name ; B:NameVar ; for(         <! X:Name G:Guard ){ Cont:Proc } ) => for(   <! #sub(A;B;X) G){ Cont }
  rule #subChan( A:Name ; B:NameVar ; for( Y:Name  <! X:Name G:Guard ){ Cont:Proc } ) => for( Y <! #sub(A;B;X) G){ Cont }
  rule #subChan( A:Name ; B:NameVar ; for( Y:Names <! X:Name G:Guard ){ Cont:Proc } ) => for( Y <! #sub(A;B;X) G){ Cont }

// sub Name for Name in Send
  rule #sub( A:Name ; B:Name ; Chan:Name !  ( Msg:Proc  ) ) => #sub(A;B;Chan) !  ( #sub(A;B;Msg) )
  rule #sub( A:Name ; B:Name ; Chan:Name !  ( Msg:Procs ) ) => #sub(A;B;Chan) !  ( #sub(A;B;Msg) )
  rule #sub( A:Name ; B:Name ; Chan:Name !! ( Msg:Proc  ) ) => #sub(A;B;Chan) !! ( #sub(A;B;Msg) )
  rule #sub( A:Name ; B:Name ; Chan:Name !! ( Msg:Procs ) ) => #sub(A;B;Chan) !! ( #sub(A;B;Msg) )

// sub Name for Name in Par
  rule #sub( A:Name ; B:Name ; Left:Proc | Right:Proc ) => #sub(A;B;Left) | #sub(A;B;Right)

// sub Name for Name in Collections
  // RhoList
  rule #sub( _:Name ; _:Name ; [ ] ) => [ ]
  rule #sub( A:Name ; B:Name ; [ C:Proc ] ) => [ #sub(A;B;C) ]
  rule #sub( A:Name ; B:Name ; [ C:Proc , D:Proc  ] ) => [ #sub(A;B;C) , #sub(A;B;D) ]
  rule #sub( A:Name ; B:Name ; [ C:Proc , D:Procs ] ) => [ #sub(A;B;C) , #sub(A;B;D) ]

  // RhoMap
  rule #sub( _:Name ; _:Name ; { } ) => { }
  rule #sub( A:Name ; B:Name ; { C:RhoKVPair } ) => { #subKV(A;B;C) }
  rule #sub( A:Name ; B:Name ; { C:RhoKVPair , D:RhoKVPair  } ) => { #subKV(A;B;C) , #subKV(A;B;D) }
  rule #sub( A:Name ; B:Name ; { C:RhoKVPair , D:RhoKVPairs } ) => { #subKV(A;B;C) , #subKV(A;B;D) }
    // RhoKVPairs
  rule #subKV( A:Name ; B:Name ; C:Proc : D:Proc ) => #sub(A;B;C) : #sub(A;B;D)
  rule #subKV( A:Name ; B:Name ; C:RhoKVPair , D:RhoKVPair ) => #subKV(A;B;C) , #subKV(A;B;D)
  rule #subKV( A:Name ; B:Name ; C:RhoKVPair , D:RhoKVPair ) => #subKV(A;B;C) , #subKV(A;B;D)

  // RhoSet
  rule #sub( _:Name ; _:Name ; Set( ) ) => Set( )
  rule #sub( A:Name ; B:Name ; Set( C:Proc ) ) => Set( #sub(A;B;C) )
  rule #sub( A:Name ; B:Name ; Set( C:Proc , D:Proc  ) ) => Set( #sub(A;B;C) , #sub(A;B;D) )
  rule #sub( A:Name ; B:Name ; Set( C:Proc , D:Procs ) ) => Set( #sub(A;B;C) , #sub(A;B;D) )

  // RhoTuple
  rule #sub( _:Name ; _:Name ; ( ) ) => ( )
  rule #sub( A:Name ; B:Name ; tuple( C:Proc  ) ) => tuple( #sub(A;B;C) )
  rule #sub( A:Name ; B:Name ; tuple( C:Procs ) ) => tuple( #sub(A;B;C) )

  // sub Name for Name in New
  rule #sub( A:Name ; B:NameVar ; P:New ) => #if (B #in #dec(P)) #then P #else #subNew(A;B;P) #fi
/*
  rule #sub( A:Name , B:Name  ; C:Name , D:Name  ; P:New ) => #if (C #in #dec(P)) 
                                                              #then #sub(B;D;P) 
                                                              #else #sub(B;D;#subNew(A;C;P)) 
                                                              #fi
  rule #sub( A:Name , B:Names ; C:Name , D:Names ; P:New ) => #if (C #in #dec(P)) 
                                                              #then #sub(B;D;P) 
                                                              #else #sub(B;D;#subNew(A;C;P)) 
                                                              #fi
*/
  rule #subNew( A:Name ; B:Name ; new C:Name  in { D:Proc } ) => new C in { #sub(A;B;D) }
  rule #subNew( A:Name ; B:Name ; new C:Names in { D:Proc } ) => new C in { #sub(A;B;D) }

// Arithmetic Exps
  rule #sub( A:Name ; B:Name ; - C:AExp ) => - #sub(A;B;C)
  rule #sub( A:Name ; B:Name ; C:AExp *  D:AExp ) => #sub(A;B;C) *  #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:AExp /  D:AExp ) => #sub(A;B;C) /  #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:AExp +  D:AExp ) => #sub(A;B;C) +  #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:AExp -  D:AExp ) => #sub(A;B;C) -  #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:AExp %  D:AExp ) => #sub(A;B;C) %  #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:AExp ++ D:AExp ) => #sub(A;B;C) ++ #sub(A;B;D)

// Boolean Exps
  rule #sub( A:Name ; B:Name ; not C:BExp ) => not #sub(A;B;C)
  rule #sub( A:Name ; B:Name ; C:BExp and D:BExp ) => #sub(A;B;C) and #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:BExp or  D:BExp ) => #sub(A;B;C) or  #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:AExp <=  D:AExp ) => #sub(A;B;C) <=  #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:AExp <   D:AExp ) => #sub(A;B;C) <   #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:AExp >=  D:AExp ) => #sub(A;B;C) >=  #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:AExp >   D:AExp ) => #sub(A;B;C) >   #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:Name ==  D:Name ) => #sub(A;B;C) ==  #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:Name !=  D:Name ) => #sub(A;B;C) !=  #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:Proc ==  D:Proc ) => #sub(A;B;C) ==  #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:Proc !=  D:Proc ) => #sub(A;B;C) !=  #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:Proc matches D:Proc ) => #sub(A;B;C) matches #sub(A;B;D)

// Condtionals
  rule #sub( A:Name ; B:Name ; if (C:BExp) D:Proc   ) => if (#sub(A;B;C)) #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:IfThen else D:Proc ) => #sub(A;B;C) else #sub(A;B;D)

// sub Names for Names in Name or Proc
  rule #sub( A:Name , B:Name  ; C:Name , D:Name  ; N:Name ) => #sub(B;D;#sub(A;C;N))
  rule #sub( A:Name , B:Names ; C:Name , D:Names ; N:Name ) => #sub(B;D;#sub(A;C;N))
  rule #sub( A:Name , B:Name  ; C:Name , D:Name  ; P:Proc ) => #sub(B;D;#sub(A;C;P))
  rule #sub( A:Name , B:Names ; C:Name , D:Names ; P:Proc ) => #sub(B;D;#sub(A;C;P))

// sub Name for Name in Names or Procs
  rule #sub( A:Name ; B:Name ; C:Name , D:Name  ) => #sub(A;B;C) , #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:Name , D:Names ) => #sub(A;B;C) , #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:Proc , D:Proc  ) => #sub(A;B;C) , #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:Proc , D:Procs ) => #sub(A;B;C) , #sub(A;B;D)

// sub Names for Names in Names
  rule #sub( A:Names ; B:Names ; M:Name , N:Name  ) => #sub(A;B;M) , #sub(A;B;N)
  rule #sub( A:Names ; B:Names ; M:Name , N:Names ) => #sub(A;B;M) , #sub(A;B;N)

// sub Name for Name in Map
  rule #sub( _:Name ; _:Name ; .Map ) => .Map
  rule #sub( A:Name ; B:Name ; C:Proc |-> D:Proc M:Map ) => #sub(A;B;C) |-> #sub(A;B;D) #sub(A;B;M)
  rule #sub( A:Name ; B:Name ; C:Name |-> D:Name M:Map ) => #sub(A;B;C) |-> #sub(A;B;D) #sub(A;B;M)

//-------------------------
//--- Map substitutions ---
//-------------------------
  // if no variables are map keys, then no substitution happens
  rule #sub( M:Map ; N:Name ) => N requires intersectSet(#FV(N),keys(M)) <=Set .Set
  rule #sub( M:Map ; A:Name , B:Name  ) => A , #sub(M;B) requires intersectSet(#FV(A),keys(M)) <=Set .Set
  rule #sub( M:Map ; A:Name , B:Names ) => A , #sub(M;B) requires intersectSet(#FV(A),keys(M)) <=Set .Set
  // if variables appear as map keys, substitute value for key
  rule #sub( Key:Name |-> Val:Name M:Map ; N:Name  ) => #sub(M;#sub(Val;Key;N))
  rule #sub( Key:Name |-> Val:Name M:Map ; N:Names ) => #sub(M;#sub(Val;Key;N))
  rule #sub( Key:Proc |-> Val:Proc M:Map ; N:Name  ) => #sub(M;#sub(Val;Key;N))
  rule #sub( Key:Proc |-> Val:Proc M:Map ; N:Names ) => #sub(M;#sub(Val;Key;N))

  // if no variables are map keys, then no substitution happens
  rule #sub( M:Map ; P:Proc ) => P requires intersectSet(#FV(P),keys(M)) <=Set .Set
  rule #sub( M:Map ; A:Proc , B:Proc  ) => A , #sub(M;B) requires intersectSet(#FV(A),keys(M)) <=Set .Set
  rule #sub( M:Map ; A:Proc , B:Procs ) => A , #sub(M;B) requires intersectSet(#FV(A),keys(M)) <=Set .Set
  // if variables appear as map keys, substitute value for key
  rule #sub( Key:Name |-> Val:Name M:Map ; P:Proc  ) => #sub(M;#sub(Val;Key;P))
  rule #sub( Key:Name |-> Val:Name M:Map ; P:Procs ) => #sub(M;#sub(Val;Key;P))
  rule #sub( Key:Proc |-> Val:Proc M:Map ; P:Proc  ) => #sub(M;#sub(Val;Key;P))
  rule #sub( Key:Proc |-> Val:Proc M:Map ; P:Procs ) => #sub(M;#sub(Val;Key;P))


  rule   @ * N:Name => N  [anywhere, structural]
  rule   * @ P:Proc => P  [anywhere, structural]

endmodule