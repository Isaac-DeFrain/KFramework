// Methods

require "../grho.k"
require "../AuxFun/auxfun.k"
require "../StructuralEquiv/struct.k"
// other requirements

module METHOD-SYNTAX
  import GRHO-SYNTAX

endmodule

module METHOD
  import METHOD-SYNTAX
  import AUXFUN
  import STRUCT

  syntax KResult ::= Proc

// All Procs and arguments are ordered before being evaluated

// add (set): RhoSet
  rule A:RhoSet .add(  ) => A
  rule A:RhoSet .add( B:Proc ) => #order(#set2rho(#rho2set(A) SetItem(B)))

// contains (map & set): Bool
  rule A:RhoMap .contains( B:Proc ) => B in keys(#rho2map(A))
  rule A:RhoSet .contains( B:Proc ) => B in #rho2set(A)

// delete (map & set): RhoMap/RhoSet
  rule A:RhoMap .delete( B:Proc ) => #order(#map2rho(#rho2map(A)[B <- undef]))
  rule A:RhoSet .delete( B:Proc ) => #order(#set2rho(#rho2set(A) -Set SetItem(B)))

// diff (map & set): RhoMap/RhoSet
  rule A:RhoMap .diff( B:RhoMap ) => #order(#map2rho(removeAll(#rho2map(A),keys(#rho2map(B)))))
  rule A:RhoSet .diff( B:RhoSet ) => #order(#set2rho(#rho2set(A) -Set #rho2set(B)))

// get (map): Proc
  rule A:RhoMap .get( B:Proc ) => A.getOrElse(B,Nil)
//getOrElse (map): Proc
  rule { }.getOrElse( _:Proc , A:Proc ) => A
  rule A:RhoMap .getOrElse( B:Proc , C:Proc ) =>
       #if B in keys(#rho2map(A)) #then #rho2map(A)[B] #else C #fi
       requires notBool isEmptyMap(A)

// interpolate (string): String
  rule A:String .interpolate( B:RhoMap ) => #interpolate(A;B)

// length (list & string): Int
  rule A:RhoList .length( ) => #length A
  rule A:String  .length( ) => lengthString(A)

// keys (map): RhoSet
  rule A:RhoMap .keys( ) => #order(#set2rho(keys(#rho2map(A))))

// nth (list & tuple): Proc
  rule A:RhoList  .nth( I:Int ) => #rho2map(A)[I]
  rule A:RhoTuple .nth( I:Int ) =>
       #if I <Int #length A andBool I >=Int 0 #then #rho2map(A)[I] #else Nil #fi

// set (map): RhoMap
  rule A:RhoMap .set( B:Proc , C:Proc ) => #order(#map2rho(updateMap(#rho2map(A),B|->C)))

// size (map & set): Int
  rule A:RhoMap .size( ) => #size(A)
  rule A:RhoSet .size( ) => #size(A)

// slice (list & string): RhoList/String
  rule A:String .slice( I:Int , J:Int ) => substrString(A,I,J)

  rule _:EmptyList .slice( _:Int , _:Int ) => [ ]
  rule _:RhoList   .slice( I:Int , J:Int ) => [ ] requires I >=Int J
  rule A:RhoList   .slice( I:Int , J:Int ) => A.slice(0,J) requires I <=Int 0
  rule A:RhoList   .slice( I:Int , J:Int ) => A.slice(I,#length A -Int 1) requires J >=Int #length A
  rule [ A:Procs ] .slice( I:Int , J:Int ) => #slice(A;I;J;0;) [owise]

// union (map & set): RhoMap/RhoSet
  rule A:RhoMap .union( B:RhoMap ) => #order(#map2rho(#rho2map(A) #rho2map(B)))
  rule A:RhoSet .union( B:RhoSet ) => #order(#set2rho(#rho2set(A) #rho2set(B)))

// toByteArray

// hexToBtyes

// toUtf8Bytes

// Unimplemented
// append (list, map, set, string, GByteArray): RhoList/RhoMap/RhoSet/String/...
//  rule A:RhoList .append( B:RhoList ) => #concat(A;B)
//  rule A:RhoList .append( B:RhoList , C:Procs ) => #concat(A;B).append(C)
// TODO: map, set, string

// values: RhoMap ---> RhoSet
//  rule A:RhoMap .values( ) => #values(A)

// confine -- semantics: confine communication channels?

// iterate (list)
// rule _:EmptyList .iterate( _:Proc ) => Nil
// rule [ A:Proc  ] .iterate( B:Proc ) => new !C:VarDec in { @B!(*!C) | @B!(A,false) }
// rule [ A:Proc , B:Procs ] .iterate( C:Proc ) => new !D:VarDec in { @C!(*!D) | @C!(A,true) | for(_ <- !D){[B].iterate(C)} }
/*
  Sequential listen:
    for(x,ack << chan){P(x)}
 => for(ack <- chan){
      ack!() |
      new left in {
        for(_ <= left){
          for(v,@{keepGoing /\ Bool} <- chan){
            P(v) | if (keepGoing) {left!()} else {Nil}
          }
        }
      }
    }
*/

//------------------
//--- Structural ---
//------------------
// Nil = unit of |
  rule Nil       | A:ProcPat => A [anywhere, structural]
  rule A:ProcPat | Nil       => A [anywhere, structural]
// @* = Id_NamePat & *@ = Id_ProcPat
  rule @ * A:NamePat => A [anywhere, structural]
  rule * @ A:ProcPat => A [anywhere, structural]
// ~~ = Id_ProcPat
  rule ~ ~ A:ProcPat => A [anywhere, structural]

endmodule
