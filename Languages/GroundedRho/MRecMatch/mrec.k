// MRec Matching

require "../grho.k"
require "../AlphaEquiv/alpha.k"
require "../AuxFun/auxfun.k"
require "../Match/match.k"
require "../StructuralEquiv/struct.k"

module MREC-SYNTAX
  import DOMAINS
  import STRUCT-SYNTAX

  syntax       Maps ::= Map
                      > Map ";" Maps [right]

// Rearranging BindSets & BvarSets
  syntax        Set ::= "#arrangeBinds(" Map ";" Set ")" [function]
                      | "#arrangeBvars(" Map ";" Set ")" [function]
// Active & Inactive Binds
  syntax        Set ::=   "#activeBindSet(" RecPat ")"                                  [function]
                      |   "#activeBindSet(" Int ";" Int ";" Set ";" ProcPat ";" Set ")" [function]
                      | "#inactiveBindSet(" RecPat ")"                                  [function]
// Possible bind matching maps
  syntax       Maps ::= "#matchBindMaps(" Set ")"                   [function]
                      | "#matchBindMaps(" Int ";;" Set  ")"         [function]
                      | "#matchBindMaps(" Int  ";" Int ";;" Set ")" [function]
  syntax       Maps ::= "#matchBindMaps(" MRecPat ";" MRecPat ")"   [function]
// Combine
  syntax        Map ::= "#combineMaps(" Map  ";;" Map  ")" [function]
  syntax       Maps ::= "#combineMaps(" Map  ";;" Maps ")" [function]
                      | "#combineMaps(" Maps ";;" Map  ")" [function]
                      | "#combineMaps(" Maps ";;" Maps ")" [function]
// Value Set of a Map
  syntax        Set ::= "#valueSet(" Map ")" [function]
  // Append Maps
  syntax       Maps ::= "#append(" Map  ";;" Map  ")" [function]
                      | "#append(" Map  ";;" Maps ")" [function]
                      | "#append(" Maps ";;" Map  ")" [function]
                      | "#append(" Maps ";;" Maps ")" [function]
// Checks a match for each matchBindMap
  syntax       Bool ::=   "#match(" Maps ";;" ProcPat ";" ProcPat ";" NamePats ";" Set ")" [function]
// checks that each BindPat has a match before doing #match
  syntax       Bool ::= "#matchif(" Set  ";;" ProcPat ";" ProcPat ";" NamePats ";" Set ")" [function]
// MultiRec matching
  syntax       Bool ::= "#matchMRec(" MRecPat ";" MRecPat ")" [function]

  syntax      KItem ::= Int | IndexedBinds | IndexedNames | IndexedSet

endmodule

module MREC
  import MREC-SYNTAX
  import ALPHA
  import AUXFUN
  import MATCH
  import SUB
  import STRUCT

  syntax KResult ::= Maps | Set | IndexedBinds | IndexedNames | IndexedSet

// #matchBindMaps turns a matchBindSet into a list of possible Bind matching maps
  rule #matchBindMaps( A:Set ) => #matchBindMaps(0;size(A);;A)
  // #matchBindMaps( current position ;; #matchBindSet )
    // IndexedSet phase: find Set with appropriate index
  rule #matchBindMaps( I:Int ;; SetItem( I     ; A:Set ) _:Set ) => #matchBindMaps(I;;A)
  rule #matchBindMaps( I:Int ;; SetItem( J:Int ; _:Set ) A:Set ) => #matchBindMaps(I;;A) requires I =/=Int J
    // after matching index: produce Maps with appropriate keys
  rule #matchBindMaps( _:Int ;; .Set ) => .Map
  rule #matchBindMaps( I:Int ;; SetItem( A:Int ) B:Set ) => I |-> A ; #matchBindMaps(I;;B)
  // #matchBindMaps( current position ; number of Binds ;; #matchBindSet )
  // create possible bind matching Maps for each position and combine all to form all possible bind matching Maps
  rule #matchBindMaps( I:Int ; I     ;; _:Set ) => .Map
  rule #matchBindMaps( I:Int ; J:Int ;; A:Set ) => #combineMaps(#matchBindMaps(I;;A);;#matchBindMaps(I +Int 1;J;;A)) requires I <Int J
  // #matchBindMaps( MRec ; MRec )
  rule #matchBindMaps( for( A:LbindPats ){ _:ProcPat } ; for( B:LbindPats ){ _:ProcPat } ) => #matchBindMaps(0;#length(A);;#matchBindSet(A;;B))
  rule #matchBindMaps( for( A:PbindPats ){ _:ProcPat } ; for( B:PbindPats ){ _:ProcPat } ) => #matchBindMaps(0;#length(A);;#matchBindSet(A;;B))
  rule #matchBindMaps( for( A:RbindPats ){ _:ProcPat } ; for( B:RbindPats ){ _:ProcPat } ) => #matchBindMaps(0;#length(A);;#matchBindSet(A;;B))
  rule #matchBindMaps( for( A:LbindPats _:Guard ){ _:ProcPat } ; for( B:LbindPats _:Guard ){ _:ProcPat } ) => #matchBindMaps(0;#length(A);;#matchBindSet(A;;B))
  rule #matchBindMaps( for( A:PbindPats _:Guard ){ _:ProcPat } ; for( B:PbindPats _:Guard ){ _:ProcPat } ) => #matchBindMaps(0;#length(A);;#matchBindSet(A;;B))
  rule #matchBindMaps( for( A:RbindPats _:Guard ){ _:ProcPat } ; for( B:RbindPats _:Guard ){ _:ProcPat } ) => #matchBindMaps(0;#length(A);;#matchBindSet(A;;B))

// #arrangeBinds( Map ; #bindSet ) -- rearranges bindSet according to given Map
  rule #arrangeBinds( _:Map ; .Set ) => .Set
  rule #arrangeBinds( A:Map ; SetItem( I:Int ; B:LbindPat ) C:Set ) => SetItem(#val(A;I);B) #arrangeBinds(A;C)
  rule #arrangeBinds( A:Map ; SetItem( I:Int ; B:PbindPat ) C:Set ) => SetItem(#val(A;I);B) #arrangeBinds(A;C)
  rule #arrangeBinds( A:Map ; SetItem( I:Int ; B:RbindPat ) C:Set ) => SetItem(#val(A;I);B) #arrangeBinds(A;C)
  // #arrangeBvars( Map ; #bvarSet ) -- rearranges bvarSet according to given Map
  rule #arrangeBvars( _:Map ; .Set ) => .Set
  rule #arrangeBvars( A:Map ; SetItem( I:Int ; B:NamePats ) C:Set ) => SetItem(#val(A;I);B) #arrangeBvars(A;C)

// Maps combine
  rule #combineMaps( A:Map ;;  .Map ) => A
  rule #combineMaps(  .Map ;; A:Map ) => A
  // if values are distinct, union the maps; otherwise return the Maps unit (.Map) which is then cleaned up
  rule #combineMaps( A:Map ;; B:Map )
    => #if intersectSet(#valueSet(A),#valueSet(B)) ==K .Set #then A B #else .Map #fi
       requires A =/=K .Map andBool B =/=K .Map
  // if either argument is a single Map, combine each of the other maps with it
  rule #combineMaps( A:Map ;; B:Map  ;  C:Maps ) => #combineMaps(A;;B) ; #combineMaps(A;;C)
  rule #combineMaps( A:Map ;  B:Maps ;; C:Map  ) => #combineMaps(A;;C) ; #combineMaps(B;;C)
  // if both arguments are proper Maps, combine the second argument Maps with the head and tail of the first arg and append
  rule #combineMaps( A:Map ;  B:Maps ;; C:Maps ) => #append(#combineMaps(A;;C);;#combineMaps(B;;C))
       requires notBool isMap(C)

// MRec matching predicate -- checks number of binds match, then #matchif
  // Linear
  rule #matchMRec( for( _:LbindPats ){ _:ProcPat } ; for( C:BindPats  ){ _:ProcPat } )
    => false requires notBool isLbindPats(C)
  rule #matchMRec( for( A:LbindPats ){ B:ProcPat } ; for( C:LbindPats ){ D:ProcPat } )
    => #length(A) ==Int #length(C) andBool
       #matchif(#matchBindSet(for(A){B};;for(C){D});;B;D;#bvar(A);#bvarSet(C;;0))
  // Peek
  rule #matchMRec( for( _:PbindPats ){ _:ProcPat } ; for( C:BindPats  ){ _:ProcPat } )
    => false requires notBool isPbindPats(C)
  rule #matchMRec( for( A:PbindPats ){ B:ProcPat } ; for( C:PbindPats ){ D:ProcPat } )
    => #length(A) ==Int #length(C) andBool
       #matchif(#matchBindSet(for(A){B};;for(C){D});;B;D;#bvar(A);#bvarSet(C;;0))
  // Repeat
  rule #matchMRec( for( _:RbindPats ){ _:ProcPat } ; for( C:BindPats  ){ _:ProcPat } )
    => false requires notBool isRbindPats(C)
  rule #matchMRec( for( A:RbindPats ){ B:ProcPat } ; for( C:RbindPats ){ D:ProcPat } )
    => #length(A) ==Int #length(C) andBool
       #matchif(#matchBindSet(for(A){B};;for(C){D});;B;D;#bvar(A);#bvarSet(C;;0))

  // TODO: change bvarSet to bvarMap
  // #matchif( matchBindSet ;; cont1 ; cont2 ; bvar1 ; bvarSet2 )
    // checks that each candidate bind matches, each to-be-matched bind is matched,
    // and then checks each bind matching arrangement for an indexed continuation match
  rule #matchif( A:Set ;; B:ProcPat ; C:ProcPat ; D:NamePats ; E:Set )
    => #checkMBS(A) andBool #checkMBS+(A) andBool
       #match(#matchBindMaps(A);;#sub(#mapify(0,0;D);B);C;#sub(#mapify(0,0;D);D);E)

  // #match( matchBindMaps ;; indexed cont1 ; cont2 ; indexed bvar1 ; bvarSet2 )
    // rearranges bvarSet2 according to each Map in matchBindMaps and checks for successful #match+
      // single Map --
  rule #match( A:Map ;; B:ProcPat ; C:ProcPat ; D:NamePats ; E:Set )
    => #match(B;#sub(D;#set2bvars(#arrangeBvars(A;E));C))
      // multiple Maps
  rule #match( A1:Map ; A2:Maps ;; B:ProcPat ; C:ProcPat ; D:NamePats ; E:Set )
    => #match(A1;;B;C;D;E) orBool #match(A2;;B;C;D;E)

// Active & Inactive Binds -- #[in]activeBindSet( bind number ; number of binds ; bindSet ; Cont ; bindSet )
  // partitions bindSet according to whether binding variables are used in the continuation
    // pass the function the RecPat and load up parameters
  rule #activeBindSet( A:RecPat ) => #activeBindSet(0;#length(#bind(A));#bindSet(A);#cont(A);#bindSet(A))
    // terminating cases
  rule #activeBindSet( I:Int ; I     ; _:Set ; _:ProcPat ; _:Set ) => .Set
  rule #activeBindSet( I:Int ; L:Int ;  .Set ; A:ProcPat ; B:Set ) => #activeBindSet(I +Int 1;L;B;A;B)
       requires I <Int L
    // if any listening variables of the bind are included in the free variables of the continuation, the bind is active
  rule #activeBindSet( I:Int ; L:Int ; SetItem( I ; A:LbindPat ) B:Set ; C:ProcPat ; D:Set )
    => #if intersectSet(#LV(A),#FV(C)) =/=K .Set
       #then SetItem(I;A) #activeBindSet(I +Int 1;L;D;C;D)
       #else #activeBindSet(I +Int 1;L;D;C;D) #fi
       requires I <Int L
  rule #activeBindSet( I:Int ; L:Int ; SetItem( I ; A:PbindPat ) B:Set ; C:ProcPat ; D:Set )
    => #if intersectSet(#LV(A),#FV(C)) =/=K .Set
       #then SetItem(I;A) #activeBindSet(I +Int 1;L;D;C;D)
       #else #activeBindSet(I +Int 1;L;D;C;D) #fi
       requires I <Int L
  rule #activeBindSet( I:Int ; L:Int ; SetItem( I ; A:RbindPat ) B:Set ; C:ProcPat ; D:Set )
    => #if intersectSet(#LV(A),#FV(C)) =/=K .Set
       #then SetItem(I;A) #activeBindSet(I +Int 1;L;D;C;D)
       #else #activeBindSet(I +Int 1;L;D;C;D) #fi
       requires I <Int L
  rule #activeBindSet( I:Int ; L:Int ; SetItem( J:Int ; _:LbindPat ) B:Set ; C:ProcPat ; D:Set )
    => #activeBindSet(I;L;B;C;D)
       requires I =/=Int J andBool I <Int L
  rule #activeBindSet( I:Int ; L:Int ; SetItem( J:Int ; _:PbindPat ) B:Set ; C:ProcPat ; D:Set )
    => #activeBindSet(I;L;B;C;D)
       requires I =/=Int J andBool I <Int L
  rule #activeBindSet( I:Int ; L:Int ; SetItem( J:Int ; _:RbindPat ) B:Set ; C:ProcPat ; D:Set )
    => #activeBindSet(I;L;B;C;D)
       requires I =/=Int J andBool I <Int L
  // inactiveBindSet
  rule #inactiveBindSet( A:RecPat ) => #bindSet(A) -Set #activeBindSet(A)

// Set of values of a Map
  rule #valueSet( .Map ) => .Set
  rule #valueSet( _:Int |-> A:Int B:Map ) => SetItem(A) #valueSet(B)

// append Maps
  rule #append(  .Map ;; A:Map  ) => A
  rule #append( A:Map ;;  .Map  ) => A
  rule #append( A:Map ;; B:Map  ) => A;B
  rule #append( A:Map ;; B:Maps ) => A;B
  rule #append( A:Map ;  B:Maps ;; C:Maps ) => A;#append(B;;C)

// Clean up Maps
  rule .Map  ; A:Maps => A [anywhere, structural]
  rule A:Map ;  .Map  => A [anywhere, structural]

endmodule
