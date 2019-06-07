// Comm predicate

require "../../GroundedRho/grho.k"
require "../../GroundedRho/AuxFun/auxfun.k"
require "../../GroundedRho/Match/match.k"
require "../../GroundedRho/StructuralEquiv/struct.k"

module COMM-SYNTAX
  import GRHO-SYNTAX

  syntax        Set ::= "#SendSet(" Proc  ")"              [function]
                      | "#RecSet("  Proc  ")"              [function]
                      | "#BindSet(" Bind  ")"              [function]
                      | "#BindSet(" Binds ")"              [function]
                      | "#flatten(" Set   ")"              [function]
                      | "#union("   Set ";" Set ")"        [function]
                      | "#subtract("       Set ";" Set ")" [function]
                      | "#subtractWithin(" Set ";" Set ")" [function]

  syntax       Bool ::= "#comm(" Proc ")"                  [function]
                      | "#includedIn("     Set ";" Set ")" [function] // comparing Set & Set
                      | "#includedWithin(" Set ";" Set ")" [function] // comparing Set & Set( Set )

  syntax      KItem ::= Name ";" Name  ";;" Int
                      | Name ";" Names ";;" Int
                      | Name ";" Proc  ";;" Int
                      | Name ";" Procs ";;" Int
//                      | Name ";" Proc  ";;" Int ";;" Int
//                      | Name ";" Procs ";;" Int ";;" Int
//                      | Set ";;" Int

endmodule

module COMM
  import COMM-SYNTAX
  import AUXFUN
  import MATCH
  import STRUCT

//----------------
//--- Send Set ---
//----------------
  rule #SendSet( A:Name !  ( B:Procs ) ) => SetItem(A;B;;1) // SetItem(A;B;1;;0)???
  rule #SendSet( A:Name !  ( B:Proc  ) ) => SetItem(A;B;;1)
  rule #SendSet( A:Name !  (         ) ) => SetItem(A;EmptyP;;1)
  rule #SendSet( A:Name !! ( B:Procs ) ) => SetItem(A;B;;1) // SetItem(A;B;1;;1)???
  rule #SendSet( A:Name !! ( B:Proc  ) ) => SetItem(A;B;;1)
  rule #SendSet( A:Name !! (         ) ) => SetItem(A;EmptyP;;1)

  rule #SendSet( A:Proc | B:Proc ) => #union(#SendSet(A);#SendSet(B)) requires notBool isPar(A)

// New???

  rule #SendSet( _:Proc ) => .Set [owise]

//-------------------
//--- Receive Set ---
//-------------------
  rule #RecSet( for( A:Lbind  ){ _:Proc } ) => SetItem( #BindSet(A) )
  rule #RecSet( for( A:Pbind  ){ _:Proc } ) => SetItem( #BindSet(A) )
  rule #RecSet( for( A:Rbind  ){ _:Proc } ) => SetItem( #BindSet(A) )
  rule #RecSet( for( A:Lbind ; B:Lbind  ){ P:Proc } ) => SetItem( #union(#BindSet(A);#BindSet(B)) )
  rule #RecSet( for( A:Lbind ; B:Lbinds ){ P:Proc } ) => SetItem( #union(#BindSet(A);#BindSet(B)) )
  rule #RecSet( for( A:Pbinds ){ P:Proc } ) => SetItem( #BindSet(A) )
  rule #RecSet( for( A:Pbind ; B:Pbind  ){ P:Proc } ) => SetItem( #union(#BindSet(A);#BindSet(B)) )
  rule #RecSet( for( A:Pbind ; B:Pbinds ){ P:Proc } ) => SetItem( #union(#BindSet(A);#BindSet(B)) )
  rule #RecSet( for( A:Rbinds ){ P:Proc } ) => SetItem( #BindSet(A) )
  rule #RecSet( for( A:Rbind ; B:Rbind  ){ P:Proc } ) => SetItem( #union(#BindSet(A);#BindSet(B)) )
  rule #RecSet( for( A:Rbind ; B:Rbinds ){ P:Proc } ) => SetItem( #union(#BindSet(A);#BindSet(B)) )

  // only includes one copy if there is more than one listen-equivalent receive
  rule #RecSet( A:Proc | B:Proc ) => #RecSet(A) #RecSet(B) requires notBool isPar(A)

// New?

  rule #RecSet( _:Proc ) => .Set [owise]

//----------------
//--- Bind Set ---
//----------------
  rule #BindSet( A:Names <- B:Name ) => SetItem(B;A;;1)
  rule #BindSet( A:Name  <- B:Name ) => SetItem(B;A;;1)
  rule #BindSet(         <- B:Name ) => SetItem(B;EmptyN;;1)
  rule #BindSet( A:Names <= B:Name ) => SetItem(B;A;;1)
  rule #BindSet( A:Name  <= B:Name ) => SetItem(B;A;;1)
  rule #BindSet(         <= B:Name ) => SetItem(B;EmptyN;;1)
  rule #BindSet( A:Names <! B:Name ) => SetItem(B;A;;1)
  rule #BindSet( A:Name  <! B:Name ) => SetItem(B;A;;1)
  rule #BindSet(         <! B:Name ) => SetItem(B;EmptyN;;1)

  rule #BindSet( A:Lbind ; B:Lbind  ) => #union(#BindSet(A);#BindSet(B))
  rule #BindSet( A:Lbind ; B:Lbinds ) => #union(#BindSet(A);#BindSet(B))
  rule #BindSet( A:Pbind ; B:Pbind  ) => #union(#BindSet(A);#BindSet(B))
  rule #BindSet( A:Pbind ; B:Pbinds ) => #union(#BindSet(A);#BindSet(B))
  rule #BindSet( A:Rbind ; B:Rbind  ) => #union(#BindSet(A);#BindSet(B))
  rule #BindSet( A:Rbind ; B:Rbinds ) => #union(#BindSet(A);#BindSet(B))

  rule #union(  .Set ; S:Set ) => S
  rule #union( S:Set ;  .Set ) => S
  // Rec sets
  rule #union( SetItem( A:Name ; B:Name  ;; I:Int ) S:Set ; SetItem( C:Name ; D:Name  ;; J:Int ) T:Set )
    => #if #nameEq(A;C) andBool #match(B;D)
       #then #union( S ; SetItem(C;D;;I +Int J) T )
       #else #union( S ; SetItem(A;B;;I) SetItem(C;D;;J) T )
       #fi
  rule #union( SetItem( A:Name ; B:Names ;; I:Int ) S:Set ; SetItem( C:Name ; D:Names ;; J:Int ) T:Set )
    => #if #nameEq(A;C) andBool #matchif(B;D)
       #then #union( S ; SetItem(C;D;;I +Int J) T )
       #else #union( S ; SetItem(A;B;;I) SetItem(C;D;;J) T )
       #fi
  rule #union( SetItem( A:Name ; B:Names ;; I:Int ) S:Set ; SetItem( C:Name ; D:Name  ;; J:Int ) T:Set )
    => #union( S ; SetItem(A;B;;I) SetItem(C;D;;J) T )
  rule #union( SetItem( A:Name ; B:Name  ;; I:Int ) S:Set ; SetItem( C:Name ; D:Names ;; J:Int ) T:Set )
    => #union( S ; SetItem(A;B;;I) SetItem(C;D;;J) T )
  // Send sets
  rule #union( SetItem( A:Name ; B:Proc  ;; I:Int ) S:Set ; SetItem( C:Name ; D:Proc  ;; J:Int ) T:Set )
    => #if #nameEq(A;C) andBool #match(B;D)
       #then #union( S ; SetItem(C;D;;I +Int J) T )
       #else #union( S ; SetItem(A;B;;I) SetItem(C;D;;J) T )
       #fi
  rule #union( SetItem( A:Name ; B:Procs ;; I:Int ) S:Set ; SetItem( C:Name ; D:Procs ;; J:Int ) T:Set )
    => #if #nameEq(A;C) andBool #matchif(B;D)
       #then #union( S ; SetItem(C;D;;I +Int J) T )
       #else #union( S ; SetItem(A;B;;I) SetItem(C;D;;J) T )
       #fi
  rule #union( SetItem( A:Name ; B:Procs ;; I:Int ) S:Set ; SetItem( C:Name ; D:Proc  ;; J:Int ) T:Set )
    => #union( S ; SetItem(A;B;;I) SetItem(C;D;;J) T )
  rule #union( SetItem( A:Name ; B:Proc  ;; I:Int ) S:Set ; SetItem( C:Name ; D:Procs ;; J:Int ) T:Set )
    => #union( S ; SetItem(A;B;;I) SetItem(C;D;;J) T )

// Included In predicate -- for comparing Set & Set
  rule #includedIn( _:Set ; .Set ) => true
  // recursively branch inclusion to individual elements
  rule #includedIn( SetItem( A:Name ; B:Proc  ;; I:Int ) S:Set ; T:Set )
    => #includedIn( SetItem(A;B;;I) ; T ) orBool #includedIn(S;T) requires notBool S <=Set .Set
  rule #includedIn( SetItem( A:Name ; B:Procs ;; I:Int ) S:Set ; T:Set )
    => #includedIn( SetItem(A;B;;I) ; T ) orBool #includedIn(S;T) requires notBool S <=Set .Set
  // recursively branch inclusion to individual elements
  rule #includedIn( SetItem( A:Name ; B:Proc  ;; I:Int ) ; SetItem( C:Name ; D:Name  ;; J:Int ) T:Set )
    => #includedIn( SetItem(A;B;;I) ; SetItem(C;D;;J) ) orBool #includedIn(SetItem(A;B;;I);T) requires notBool T <=Set .Set
  rule #includedIn( SetItem( A:Name ; B:Procs ;; I:Int ) ; SetItem( C:Name ; D:Names ;; J:Int ) T:Set )
    => #includedIn( SetItem(A;B;;I) ; SetItem(C;D;;J) ) orBool #includedIn(SetItem(A;B;;I);T) requires notBool T <=Set .Set
  rule #includedIn( SetItem( A:Name ; B:Procs ;; I:Int ) ; SetItem( C:Name ; D:Name  ;; J:Int ) T:Set )
    => #includedIn( SetItem(A;B;;I);T) requires notBool T <=Set .Set
  rule #includedIn( SetItem( A:Name ; B:Proc  ;; I:Int ) ; SetItem( C:Name ; D:Names ;; J:Int ) T:Set )
    => #includedIn( SetItem(A;B;;I);T) requires notBool T <=Set .Set

  // individual element inclusion
  rule #includedIn( SetItem( A:Name ; B:Proc  ;; _:Int ) ; SetItem( C:Name ; D:Name  ;; _:Int ) )
    => #nameEq(A;C) andBool #match(@B;D)
  rule #includedIn( SetItem( A:Name ; B:Procs ;; _:Int ) ; SetItem( C:Name ; D:Names ;; _:Int ) )
    => #nameEq(A;C) andBool #matchif(#quotes(B);D)
  rule #includedIn( SetItem( _:Name ; _:Procs ;; _:Int ) ; SetItem( _:Name ; _:Name  ;; _:Int ) ) => false
  rule #includedIn( SetItem( _:Name ; _:Proc  ;; _:Int ) ; SetItem( _:Name ; _:Names ;; _:Int ) ) => false

// Included Within predicate -- for comparing Set & Set( Set )
  rule #includedWithin( _:Set ; .Set ) => true
  rule #includedWithin( A:Set ; SetItem( B:Set ) C:Set ) => #includedIn(A;B) orBool #includedWithin(A;C)

// Subtract
  rule #subtract(  .Set ; A:Set ) => A
  rule #subtract( _:Set ;  .Set ) => .Set
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
  rule #subtract( SetItem( _:Name ; _:Procs ;; _:Int ) S:Set ; SetItem( C:Name ; D:Name  ;; J:Int ) T:Set )
    => #subtract(S; SetItem(C;D;;J) T )
  rule #subtract( SetItem( _:Name ; _:Proc  ;; _:Int ) S:Set ; SetItem( C:Name ; D:Names ;; J:Int ) T:Set )
    => #subtract(S; SetItem(C;D;;J) T )

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