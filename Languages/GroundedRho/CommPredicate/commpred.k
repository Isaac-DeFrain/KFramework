// Comm predicate

require "../grho.k"
require "../AuxFun/auxfun.k"
require "../Match/match.k"
require "../StructuralEquiv/struct.k"

module COMMPRED-SYNTAX
  import GRHO-SYNTAX

// Set constructors
  syntax        Set ::= "#SendSet(" Proc  ")" [function] // constructs Send set
                      |  "#RecSet(" Proc  ")" [function] // constructs Receive set
                      | "#BindSet(" Bind  ")" [function] // constructs Bind set
                      | "#BindSet(" Binds ")" [function] // constructs set of Bind sets

// Flatten
  syntax        Set ::= "#flatten(" Set ")" [function]

// Set operations
  syntax        Set ::=          "#union(" Set ";" Set ")" [function] // counts occurreneces of equivalent elements
                      |       "#subtract(" Set ";" Set ")" [function] // subtracts occurrences & elements
                      | "#subtractWithin(" Set ";" Set ")" [function] // subtract Set from within Set( Set )

// Set relations
  syntax       Bool ::=     "#includedIn(" Set ";" Set ")" [function] // comparing Set & Set
                      |    "#includedIn+(" Set ";" Set ")" [function] // comparing Set & Set
                      | "#includedWithin(" Set ";" Set ")" [function] // comparing Set & Set( Set )

// Comm relation
  syntax       Bool ::= "#comm(" Proc ")" [function]

// Set elements
  syntax      KItem ::= Name ";" Name     ";;" Int // represents binding/listen in for( Name     <- Name ){ ... }
                      | Name ";" Names    ";;" Int // represents binding/listen in for( Names    <- Name ){ ... }
                      | Name ";" NamePat  ";;" Int // represents binding/listen in for( NamePat  <- Name ){ ... }
                      | Name ";" NamePats ";;" Int // represents binding/listen in for( NamePats <- Name ){ ... }
                      | Name ";" Proc     ";;" Int // represents channel & message in Name!(Proc)
                      | Name ";" Procs    ";;" Int // represents channel & message in Name!(Procs)
                      | Name ";" ProcPat  ";;" Int // represents channel & message in Name!(ProcPat)
                      | Name ";" ProcPats ";;" Int // represents channel & message in Name!(ProcPats)
//                      | Name ";" Name  ";;" Int ";;" Int // linear/peek/repeated receives???
//                      | Name ";" Names ";;" Int ";;" Int // linear/peek/repeated receives???
//                      | Name ";" Proc  ";;" Int ";;" Int // consumable & unconsumable sends???
//                      | Name ";" Procs ";;" Int ";;" Int // consumable & unconsumable sends???
//                      | Set ";;" Int                     // bind occurrences

endmodule

module COMMPRED
  import COMMPRED-SYNTAX
  import AUXFUN
  import MATCH
  import STRUCT

  syntax KResult ::= Set

//----------------
//--- Send Set ---
//----------------
// Send
  rule #SendSet( A:Name !  ( B:Procs ) ) => SetItem(A;B;;1) // consumable & unconsumable types???
  rule #SendSet( A:Name !  ( B:Proc  ) ) => SetItem(A;B;;1)
  rule #SendSet( A:Name !  (         ) ) => SetItem(A;EmptyP;;1)
  rule #SendSet( A:Name !! ( B:Procs ) ) => SetItem(A;B;;1) // consumable & unconsumable types???
  rule #SendSet( A:Name !! ( B:Proc  ) ) => SetItem(A;B;;1)
  rule #SendSet( A:Name !! (         ) ) => SetItem(A;EmptyP;;1)

// Par
  // count occurrences of equivalent sends
  rule #SendSet( A:Proc | B:Proc ) => #union(#SendSet(A);#SendSet(B)) requires notBool isPar(A)

// New???

  rule #SendSet( _:Proc ) => .Set [owise]

//-------------------
//--- Receive Set ---
//-------------------
// Rec -- TODO: add guarded
  rule #RecSet( for( A:Lbind  ){ _:Proc } ) => SetItem( #BindSet(A) )
  rule #RecSet( for( A:Pbind  ){ _:Proc } ) => SetItem( #BindSet(A) )
  rule #RecSet( for( A:Rbind  ){ _:Proc } ) => SetItem( #BindSet(A) )
  rule #RecSet( for( A:Lbinds ){ _:Proc } ) => SetItem( #BindSet(A) )
  rule #RecSet( for( A:Pbinds ){ _:Proc } ) => SetItem( #BindSet(A) )
  rule #RecSet( for( A:Rbinds ){ _:Proc } ) => SetItem( #BindSet(A) )

// Par
  // only includes one copy if there is more than one listen-equivalent receive
  rule #RecSet( A:Proc | B:Proc ) => #RecSet(A) #RecSet(B) requires notBool isPar(A)

// New?

  rule #RecSet( _:Proc ) => .Set [owise]

//----------------
//--- Bind Set ---
//----------------
  rule #BindSet( A:NamePats <- B:Name ) => SetItem(B;A;;1)
  rule #BindSet( A:NamePat  <- B:Name ) => SetItem(B;A;;1)
  rule #BindSet( A:Names    <- B:Name ) => SetItem(B;A;;1)
  rule #BindSet( A:Name     <- B:Name ) => SetItem(B;A;;1)
  rule #BindSet(            <- B:Name ) => SetItem(B;EmptyN;;1)
  rule #BindSet( A:NamePats <= B:Name ) => SetItem(B;A;;1)
  rule #BindSet( A:NamePat  <= B:Name ) => SetItem(B;A;;1)
  rule #BindSet( A:Names    <= B:Name ) => SetItem(B;A;;1)
  rule #BindSet( A:Name     <= B:Name ) => SetItem(B;A;;1)
  rule #BindSet(            <= B:Name ) => SetItem(B;EmptyN;;1)
  rule #BindSet( A:NamePats <! B:Name ) => SetItem(B;A;;1)
  rule #BindSet( A:NamePat  <! B:Name ) => SetItem(B;A;;1)
  rule #BindSet( A:Names    <! B:Name ) => SetItem(B;A;;1)
  rule #BindSet( A:Name     <! B:Name ) => SetItem(B;A;;1)
  rule #BindSet(            <! B:Name ) => SetItem(B;EmptyN;;1)

  rule #BindSet( A:Lbind ; B:Lbind  ) => #union(#BindSet(A);#BindSet(B))
  rule #BindSet( A:Lbind ; B:Lbinds ) => #union(#BindSet(A);#BindSet(B))
  rule #BindSet( A:Pbind ; B:Pbind  ) => #union(#BindSet(A);#BindSet(B))
  rule #BindSet( A:Pbind ; B:Pbinds ) => #union(#BindSet(A);#BindSet(B))
  rule #BindSet( A:Rbind ; B:Rbind  ) => #union(#BindSet(A);#BindSet(B))
  rule #BindSet( A:Rbind ; B:Rbinds ) => #union(#BindSet(A);#BindSet(B))

//-------------
//--- Union ---
//-------------
  rule #union(  .Set ; S:Set ) => S
  rule #union( S:Set ;  .Set ) => S

// Rec sets -- elements of the form: Name ; Name(s) ;; Int
  rule #union( SetItem( A:Name ; B:Name  ;; I:Int ) S:Set ; SetItem( C:Name ; D:Name  ;; J:Int ) T:Set )
    => #if #nameEq(A;C) andBool #nameEq(B;D) // count as equal receives with equivalent channels and listening names
       #then #union( S ; SetItem(C;D;;I +Int J) T )
       #else #union( S ; SetItem(A;B;;I) SetItem(C;D;;J) T )
       #fi
  rule #union( SetItem( A:Name ; B:Names ;; I:Int ) S:Set ; SetItem( C:Name ; D:Names ;; J:Int ) T:Set )
    => #if #nameEq(A;C) andBool #nameEqif(B;D) // count as equal receives with equivalent channels and listening names
       #then #union( S ; SetItem(C;D;;I +Int J) T )
       #else #union( S ; SetItem(A;B;;I) SetItem(C;D;;J) T )
       #fi
  rule #union( SetItem( A:Name ; B:Names ;; I:Int ) S:Set ; SetItem( C:Name ; D:Name  ;; J:Int ) T:Set )
    => #union( S ; SetItem(A;B;;I) SetItem(C;D;;J) T )
  rule #union( SetItem( A:Name ; B:Name  ;; I:Int ) S:Set ; SetItem( C:Name ; D:Names ;; J:Int ) T:Set )
    => #union( S ; SetItem(A;B;;I) SetItem(C;D;;J) T )

// Send sets -- elements of the form: Name ; Proc(s) ;; Int
  rule #union( SetItem( A:Name ; B:Proc  ;; I:Int ) S:Set ; SetItem( C:Name ; D:Proc  ;; J:Int ) T:Set )
    => #if #nameEq(A;C) andBool #struct(B;D)
       #then #union( S ; SetItem(C;D;;I +Int J) T )
       #else #union( S ; SetItem(A;B;;I) SetItem(C;D;;J) T )
       #fi
  rule #union( SetItem( A:Name ; B:Procs ;; I:Int ) S:Set ; SetItem( C:Name ; D:Procs ;; J:Int ) T:Set )
    => #if #nameEq(A;C) andBool #structif(B;D)
       #then #union( S ; SetItem(C;D;;I +Int J) T )
       #else #union( S ; SetItem(A;B;;I) SetItem(C;D;;J) T )
       #fi
  rule #union( SetItem( A:Name ; B:Procs ;; I:Int ) S:Set ; SetItem( C:Name ; D:Proc  ;; J:Int ) T:Set )
    => #union( S ; SetItem(A;B;;I) SetItem(C;D;;J) T )
  rule #union( SetItem( A:Name ; B:Proc  ;; I:Int ) S:Set ; SetItem( C:Name ; D:Procs ;; J:Int ) T:Set )
    => #union( S ; SetItem(A;B;;I) SetItem(C;D;;J) T )

//-------------------
//--- Included In ---
//-------------------
// for comparing Set & Set
  rule #includedIn(  _:Set ;  .Set ) => false
  rule #includedIn(   .Set ; _:Set ) => true
  rule #includedIn+( _:Set ;  .Set ) => true
  rule #includedIn+( A:Set ; B:Set ) => #includedIn(A;B) requires B =/=K .Set

// recursively or-branch inclusion down to the level of individual elements -- start with left args, then do right args
  // eliminating includees from left arg
    // ( { elem } Set1 ) in Set2 => { elem } in Set2 or Set1 in Set2
      // Proc message
  rule #includedIn(  SetItem( A:Name ; B:Proc  ;; I:Int ) S:Set ; T:Set )
    => #includedIn+( SetItem(A;B;;I) ; T ) orBool #includedIn+(S;T) requires S =/=K .Set
      // Procs message
  rule #includedIn(  SetItem( A:Name ; B:Procs ;; I:Int ) S:Set ; T:Set )
    => #includedIn+( SetItem(A;B;;I) ; T ) orBool #includedIn+(S;T) requires S =/=K .Set
  // eliminating includers from right arg
    // { elem1 } in ( { elem2 } Set ) => { elem1 } in { elem2 } or { elem1 } in Set
      // Proc message; listening for Name
  rule #includedIn(  SetItem( A:Name ; B:Proc  ;; I:Int ) ; SetItem( C:Name ; D:Name  ;; J:Int ) T:Set )
    => #includedIn+( SetItem(A;B;;I) ; SetItem(C;D;;J) ) orBool #includedIn+(SetItem(A;B;;I);T) requires notBool T <=Set .Set
      // Procs message; listening for Names
  rule #includedIn(  SetItem( A:Name ; B:Procs ;; I:Int ) ; SetItem( C:Name ; D:Names ;; J:Int ) T:Set )
    => #includedIn+( SetItem(A;B;;I) ; SetItem(C;D;;J) ) orBool #includedIn+(SetItem(A;B;;I);T) requires notBool T <=Set .Set
      // length mismatch
  rule #includedIn(  SetItem( A:Name ; B:Procs ;; I:Int ) ; SetItem( C:Name ; D:Name  ;; J:Int ) T:Set )
    => #includedIn+( SetItem(A;B;;I);T) requires T =/=K .Set
  rule #includedIn(  SetItem( A:Name ; B:Proc  ;; I:Int ) ; SetItem( C:Name ; D:Names ;; J:Int ) T:Set )
    => #includedIn+( SetItem(A;B;;I);T) requires T =/=K .Set

  // individual element inclusion
    // { elem1 } in { elem2 }
  rule #includedIn( SetItem( A:Name ; B:Proc  ;; _:Int ) ; SetItem( C:Name ; D:Name  ;; _:Int ) )
    => #nameEq(A;C) andBool #match(@B;D)
  rule #includedIn( SetItem( A:Name ; B:Procs ;; _:Int ) ; SetItem( C:Name ; D:Names ;; _:Int ) )
    => #nameEq(A;C) andBool #matchif(#quotes(B);D)
      // length mismatch
  rule #includedIn( SetItem( _:Name ; _:Procs ;; _:Int ) ; SetItem( _:Name ; _:Name  ;; _:Int ) ) => false
  rule #includedIn( SetItem( _:Name ; _:Proc  ;; _:Int ) ; SetItem( _:Name ; _:Names ;; _:Int ) ) => false

// #includedWithin predicate -- for comparing Set & Set( Set )
  rule #includedWithin( A:Set ;  .Set ) => false requires A =/=K .Set
  rule #includedWithin(  .Set ; _:Set ) => true
  rule #includedWithin( A:Set ; SetItem( B:Set ) C:Set ) => #includedIn+(A;B) orBool #includedWithin(A;C)

//----------------
//--- Subtract ---
//----------------
// trivial
  rule #subtract(  .Set ; A:Set ) => A
  rule #subtract( _:Set ;  .Set ) => .Set

// subtract SendSet from RecSet
  rule #subtract( SetItem( A:Name ; B:Proc  ;; I:Int ) S:Set ; SetItem( C:Name ; D:Name  ;; J:Int ) T:Set )
    => #if #includedIn(SetItem(A;B;;I);SetItem(C;D;;J))
       #then #if I <Int J
             #then #subtract(S; SetItem(C;D;;J -Int I) T )
             #else #subtract(S;T)
             #fi
       #else #if #includedIn(SetItem(A;B;;I);T)
             #then #subtract(S;#subtract(SetItem(A;B;;I);T) SetItem(C;D;;J))
             #else #subtract(S; SetItem(C;D;;J) T)
             #fi
       #fi
// subtract SendSet from RecSet
  rule #subtract( SetItem( A:Name ; B:Procs ;; I:Int ) S:Set ; SetItem( C:Name ; D:Names ;; J:Int ) T:Set )
    => #if #includedIn(SetItem(A;B;;I);SetItem(C;D;;J))
       #then #if I <Int J
             #then #subtract(S; SetItem(C;D;;J -Int I) T )
             #else #subtract(S;T)
             #fi
       #else #if #includedIn(SetItem(A;B;;I);T)
             #then #subtract(S;#subtract(SetItem(A;B;;I);T) SetItem(C;D;;J))
             #else #subtract(S; SetItem(C;D;;J) T)
             #fi
       #fi
  // length mismatch
  rule #subtract( SetItem( _:Name ; _:Procs ;; _:Int ) S:Set ; SetItem( C:Name ; D:Name  ;; J:Int ) T:Set )
    => #subtract(S; SetItem(C;D;;J) T )
  rule #subtract( SetItem( _:Name ; _:Proc  ;; _:Int ) S:Set ; SetItem( C:Name ; D:Names ;; J:Int ) T:Set )
    => #subtract(S; SetItem(C;D;;J) T )

//-----------------------
//--- Subtract Within ---
//-----------------------
  rule #subtractWithin(  .Set ; A:Set ) => A
  rule #subtractWithin( _:Set ;  .Set ) => .Set
  rule #subtractWithin( SetItem( A:Name ; B:Proc  ;; I:Int ) S:Set ; SetItem( C:Set ) T:Set )
    => #if #includedIn( SetItem(A;B;;I) ; C )
       #then #subtractWithin(S;SetItem(#subtract(SetItem(A;B;;I);C)) T )
       #else #if #includedWithin(SetItem(A;B;;I);T)
             #then #subtractWithin(S;SetItem(#subtractWithin(SetItem(A;B;;I);T)) SetItem(C) )
             #else #subtractWithin(S; SetItem(C) T )
             #fi
       #fi
  rule #subtractWithin( SetItem( A:Name ; B:Procs ;; I:Int ) S:Set ; SetItem( C:Set ) T:Set )
    => #if #includedIn( SetItem(A;B;;I) ; C )
       #then #subtractWithin(S;SetItem(#subtract(SetItem(A;B;;I);C)) T )
       #else #if #includedWithin(SetItem(A;B;;I);T)
             #then #subtractWithin(S;SetItem(#subtractWithin(SetItem(A;B;;I);T)) SetItem(C) )
             #else #subtractWithin(S; SetItem(C) T )
             #fi
       #fi

//-------------
//--- #comm ---
//-------------
  rule #comm( P:Proc ) => size(#flatten(#subtractWithin(#SendSet(P);#RecSet(P)))) <Int size(#RecSet(P))

  rule #flatten( .Set ) => .Set
  rule #flatten( SetItem( A:Set ) B:Set ) => A #flatten(B)

endmodule
