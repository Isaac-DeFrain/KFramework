// MRec Matching

require "../grho.k"
require "../AlphaEquiv/alpha.k"
require "../AuxFun/auxfun.k"
require "../Match/match.k"
require "../SpatialType/spatial.k"
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
  // syntax        Set ::=   "#activeBindSet(" RecPat ")"                                  [function]
  //                     |   "#activeBindSet(" Int ";" Int ";" Set ";" ProcPat ";" Set ")" [function]
  //                     | "#inactiveBindSet(" RecPat ")"                                  [function]

  // SendSet
  syntax         Set ::=      "#sendSet(" Send ")"        [function, klabel(sendSet)]
                       | "#addNameSpace(" Set ";" Set ")" [function, klabel(addNameSpace)]
                       |  "#addTypeSend(" Set ";" Set ")" [function, klabel(addTypeSend)]
                       |      "#addSend(" Set ";" Set ")" [function, klabel(addSend)]
  // RecSet
  syntax         Set ::=  "#recSet(" Receive ")"     [function, klabel(recSet)]
                       | "#addBind(" Set ";" Set ")" [function, klabel(addBind)]
                       |  "#addRec(" Set ";" Set ")" [function, klabel(addRec)]
  // enumerated bindSet
  syntax         Set ::= "#enumBindSet(" Receive ")" [function, klabel(enumBindSetRec)]
                       | "#enumBindSet(" Bind    ")" [function, klabel(enumBindSetBind)]
                       | "#enumBindSet(" Binds   ")" [function, klabel(enumBindSetBinds)]

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

//--------------------
//--- Par Matching ---
//--------------------
  // Par matching works by establishing 2 sets to determine if they match & how variables are bound
  // these functions apply to the to-be-matched Par pattern
  syntax        Set ::=       "#varSet(" ProcPat ")"         [function, klabel(varSet)]
                      |       "#varSet(" ProcPat ";" Int ")" [function, klabel(varSet)]
                      | "#mustMatchSet(" ProcPat ")"         [function, klabel(mustMatchSet)]
                      |          "#add(" Set ";" Set ")"     [function, klabel(addEnum)]
                      |        "#minus(" Set ";" Set ")"     [function, klabel(minusSet)]

  syntax       Proc ::= "#leadVar(" Set ")" [function, klabel(leadVar)]

  syntax       Bool ::= "#matchSet(" Set ";" Set ")"                         [function, klabel(matchSet)]
                      | "#matchSet(" Set ";" Set ";" Set ";" Int ";" Int ")" [function, klabel(auxMatchSet)]
                      | "#matchPar(" ParPat ";" ParPat ")"                   [function, klabel(matchPar)]

  syntax        Set ::= "#matchMinus(" Set ";" Set ")" [function, klabel(matchMinus)]

  syntax        Int ::= "#enum(" Set ")" [function, klabel(enum)]

  // sort testing
  syntax       Bool ::= "#isEvalVar(" Proc ")" [function]
  syntax       Bool ::= "#isProcVar(" Proc ")" [function]
  syntax       Bool ::= "#isQuotePat(" K ")" [function]
  syntax       Bool ::= "#isNamePat(" K ")" [function]

  syntax      KItem ::= Int | IndexedBinds | IndexedNames | IndexedSet
                      | SendSetElem | NameSpaceElem
                      |  RecSetElem | BindSetElem

endmodule

module MREC
  import MREC-SYNTAX
  import ALPHA
  import AUXFUN
  import MATCH
  import SUB
  import SPATIAL
  import STRUCT

  syntax KResult ::= Maps | Set | IndexedBinds | IndexedNames | IndexedSet
                   | SendSetElem | NameSpaceElem
                   |  RecSetElem | BindSetElem

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
    => for(A){B} ==K for(C){D} orBool (#length(A) ==Int #length(C) andBool
       #matchif(#matchBindSet(for(A){B};;for(C){D});;B;D;#bvar(A);#bvarSet(C;;0)))
  // Peek
  rule #matchMRec( for( _:PbindPats ){ _:ProcPat } ; for( C:BindPats  ){ _:ProcPat } )
    => false requires notBool isPbindPats(C)
  rule #matchMRec( for( A:PbindPats ){ B:ProcPat } ; for( C:PbindPats ){ D:ProcPat } )
    => for(A){B} ==K for(C){D} orBool (#length(A) ==Int #length(C) andBool
       #matchif(#matchBindSet(for(A){B};;for(C){D});;B;D;#bvar(A);#bvarSet(C;;0)))
  // Repeat
  rule #matchMRec( for( _:RbindPats ){ _:ProcPat } ; for( C:BindPats  ){ _:ProcPat } )
    => false requires notBool isRbindPats(C)
  rule #matchMRec( for( A:RbindPats ){ B:ProcPat } ; for( C:RbindPats ){ D:ProcPat } )
    => for(A){B} ==K for(C){D} orBool (#length(A) ==Int #length(C) andBool
       #matchif(#matchBindSet(for(A){B};;for(C){D});;B;D;#bvar(A);#bvarSet(C;;0)))

  // TODO: change bvarSet to bvarMap?
  // #matchif( matchBindSet ;; cont1 ; cont2 ; bvar1 ; bvarSet2 )
    // checks that each candidate bind matches, each to-be-matched bind is matched,
    // and then checks each bind matching arrangement for an indexed continuation match
  rule #matchif( A:Set ;; B:ProcPat ; C:ProcPat ; D:NamePats ; E:Set )
    => #checkMBS(A) andBool #checkMBS+(A) andBool
       #match(#matchBindMaps(A);;#sub(#mapify(D);B);C;#sub(#mapify(D);D);E)

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
  // rule #activeBindSet( A:RecPat ) => #activeBindSet(0;#length(#bind(A));#bindSet(A);#cont(A);#bindSet(A))
  //   // terminating cases
  // rule #activeBindSet( I:Int ; I     ; _:Set ; _:ProcPat ; _:Set ) => .Set
  // rule #activeBindSet( I:Int ; L:Int ;  .Set ; A:ProcPat ; B:Set ) => #activeBindSet(I +Int 1;L;B;A;B)
  //      requires I <Int L
  //   // if any listening variables of the bind are included in the free variables of the continuation, the bind is active
  // rule #activeBindSet( I:Int ; L:Int ; SetItem( I ; A:LbindPat ) B:Set ; C:ProcPat ; D:Set )
  //   => #if intersectSet(#LV(A),#FV(C)) =/=K .Set
  //      #then SetItem(I;A) #activeBindSet(I +Int 1;L;D;C;D)
  //      #else #activeBindSet(I +Int 1;L;D;C;D) #fi
  //      requires I <Int L
  // rule #activeBindSet( I:Int ; L:Int ; SetItem( I ; A:PbindPat ) B:Set ; C:ProcPat ; D:Set )
  //   => #if intersectSet(#LV(A),#FV(C)) =/=K .Set
  //      #then SetItem(I;A) #activeBindSet(I +Int 1;L;D;C;D)
  //      #else #activeBindSet(I +Int 1;L;D;C;D) #fi
  //      requires I <Int L
  // rule #activeBindSet( I:Int ; L:Int ; SetItem( I ; A:RbindPat ) B:Set ; C:ProcPat ; D:Set )
  //   => #if intersectSet(#LV(A),#FV(C)) =/=K .Set
  //      #then SetItem(I;A) #activeBindSet(I +Int 1;L;D;C;D)
  //      #else #activeBindSet(I +Int 1;L;D;C;D) #fi
  //      requires I <Int L
  // rule #activeBindSet( I:Int ; L:Int ; SetItem( J:Int ; _:LbindPat ) B:Set ; C:ProcPat ; D:Set )
  //   => #activeBindSet(I;L;B;C;D)
  //      requires I =/=Int J andBool I <Int L
  // rule #activeBindSet( I:Int ; L:Int ; SetItem( J:Int ; _:PbindPat ) B:Set ; C:ProcPat ; D:Set )
  //   => #activeBindSet(I;L;B;C;D)
  //      requires I =/=Int J andBool I <Int L
  // rule #activeBindSet( I:Int ; L:Int ; SetItem( J:Int ; _:RbindPat ) B:Set ; C:ProcPat ; D:Set )
  //   => #activeBindSet(I;L;B;C;D)
  //      requires I =/=Int J andBool I <Int L
  // // inactiveBindSet
  // rule #inactiveBindSet( A:RecPat ) => #bindSet(A) -Set #activeBindSet(A)

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

//--------------------
//--- Par Matching ---
//--------------------
// collects all EvalVar/ProcVar appearing in Par pattern
// returns indexedSet of variables
  rule #varSet( A:ProcPat ) => .Set
       requires notBool (isParPat(A) orBool isEvalVar(A) orBool isProcVar(A))
  rule #varSet( A:ProcPat ) => SetItem(0;A)
       requires isEvalVar(A) orBool isProcVar(A)
  // #varSet: ProcVar x index --> IndexSet
  rule #varSet( A:ParPat ) => #varSet(A;0)
  rule #varSet( A:ProcPat ; I:Int ) => SetItem(I;A)
       requires isEvalVar(A) orBool isProcVar(A)
  rule #varSet( A:ProcPat ; I:Int ) => .Set
       requires notBool (isParPat(A) orBool isEvalVar(A) orBool isProcVar(A))
  rule #varSet( A:ProcPat | B:ProcPat ; I:Int )
    => #if isEvalVar(A) orBool isProcVar(A)
       #then SetItem(I;A) #varSet(B;I +Int 1)
       #else #varSet(B;I) #fi
       requires notBool isParPat(A)
  // rule #hasLeadVar( A:Set ) => A =/=K .Set
  rule #leadVar( SetItem( I:Int ; A:Proc ) _:Set ) => A requires I ==Int 0
  rule #leadVar( SetItem( I:Int ; A:Proc ) B:Set ) => #leadVar(B) requires I =/=Int 0
  rule #isEvalVar( A:Proc ) => isEvalVar(A)

// terms in mustMatchSet must be matched by components of the candidate Par
// nonProcVar terms
// enumerated set of patterns to match
  rule #mustMatchSet( A:ProcPat ) => .Set requires isEvalVar(A) orBool isProcVar(A)
  rule #mustMatchSet( A:ProcPat ) => SetItem(1;A)
       requires notBool (isParPat(A) orBool isEvalVar(A) orBool isProcVar(A))
  rule #mustMatchSet( A:ProcPat | B:ProcPat )
    => #add(#mustMatchSet(A);#mustMatchSet(B))
       requires notBool isParPat(A)

//------------
//--- #add ---
//------------
  // #add: add enumSet elem to enumSet
  rule #add( A:Set ;  .Set ) => A
  rule #add(  .Set ; A:Set ) => A
  rule #add( SetItem( M:Int ; A:ProcPat ) ; SetItem( N:Int ; B:ProcPat ) C:Set )
    => SetItem(M +Int N;B) C requires #structEq(A;B)
  rule #add( SetItem( M:Int ; A:ProcPat ) ; SetItem( N:Int ; B:ProcPat ) C:Set )
    => #add(SetItem(M;A);C) SetItem(N;B) requires notBool #structEq(A;B)

  // #add: add nameSendSetElem to nameSendSet
  rule #addNameSpace( A:Set ;  .Set ) => A
  rule #addNameSpace(  .Set ; A:Set ) => A
  rule #addNameSpace( SetItem( A:Name ; B:Set ) ; SetItem( C:Name ; D:Set ) E:Set )
    => SetItem(C;#addTypeSend(B;D)) E requires #nameEq(A;C)
  rule #addNameSpace( SetItem( A:Name ; B:Set ) ; SetItem( C:Name ; D:Set ) E:Set )
    => #addNameSpace(SetItem(A;B);E) SetItem(C;D) requires notBool #nameEq(A;C)
  // #add: add typeSendSetElem to typeSendSet
  rule #addTypeSend( A:Set ;  .Set ) => A
  rule #addTypeSend(  .Set ; A:Set ) => A
  rule #addTypeSend( SetItem( A:NamePats ; B:Set ) ; SetItem( C:NamePats ; D:Set ) E:Set )
    => SetItem(C;#addSend(B;D)) E requires #nameEqif(A;C)
  rule #addTypeSend( SetItem( A:NamePats ; B:Set ) ; SetItem( C:NamePats ; D:Set ) E:Set )
    => #addTypeSend(SetItem(A;B);E) SetItem(C;D) requires notBool #nameEqif(A;C)
  // #add: add nameTypeEnumSendSetElem to nameTypeEnumSendSet
  rule #addSend( A:Set ;  .Set ) => A
  rule #addSend(  .Set ; A:Set ) => A
  rule #addSend( SetItem( M:Int ; A:Names ; I:Int ) ; SetItem( N:Int ; B:Names ; J:Int ) E:Set )
    => SetItem(M +Int N;B;I) E requires #nameEqif(A;B) andBool I ==Int J
  rule #addSend( SetItem( M:Int ; A:Names ; I:Int ) ; SetItem( N:Int ; B:Names ; J:Int ) E:Set )
    => #addSend(SetItem(M;A;I);E) SetItem(N;B;J) requires notBool (#nameEqif(A;B) andBool I ==Int J)

  // #add: add enumBindSet elem to enumBindSet -- for building the enumBindSet
  rule #addBind( A:Set ;  .Set ) => A
  rule #addBind(  .Set ; A:Set ) => A
  rule #addBind( SetItem( M:Int ; A:Name ; B:NamePats ) ; SetItem( N:Int ; C:Name ; D:NamePats ) E:Set )
    => SetItem(M +Int N;A;B) E requires #nameEq(A;C) andBool #nameEqif(B;D)
  rule #addBind( SetItem( M:Int ; A:Name ; B:NamePats ) ; SetItem( N:Int ; C:Name ; D:NamePats ) E:Set )
    => #addBind(SetItem(M;A;B);E) SetItem(N;C;D) requires notBool (#nameEq(A;C) andBool #nameEqif(B;D))
  // #add: add enumRecSet elem to enumRecSet
  rule #addRec( A:Set ;  .Set ) => A
  rule #addRec(  .Set ; A:Set ) => A
  rule #addRec( SetItem( M:Int ; A:Set ; B:Proc ; C:BExp ; I:Int ) ; SetItem( N:Int ; D:Set ; E:Proc ; F:BExp ; J:Int ) G:Set )
    => SetItem(M +Int N;A;B;C;I) G requires A ==K D andBool #structEq(B;E) andBool #structEq(C;F) andBool I ==Int J
  rule #addRec( SetItem( M:Int ; A:Set ; B:Proc ; C:BExp ; I:Int ) ; SetItem( N:Int ; D:Set ; E:Proc ; F:BExp ; J:Int ) G:Set )
    => #addRec(SetItem(M;A;B;C;I);G) SetItem(N;D;E;F;J)
       requires notBool (A ==K D andBool #structEq(B;E) andBool #structEq(C;F) andBool I ==Int J)

// #matchSet: checks if candidate's parSet matches pattern's mustMatchSet
// #matchSet( indexedSet of normalized Par ; #mustMatchSet of ParPat )
  // if no patterns to match - all good
  rule #matchSet( A:Set ;  .Set ) => true
  // otherwise - set it up for comparison
  // if all 3rd arg elements are matched, then the Pars match, otherwise not
  rule #matchSet( A:Set ; B:Set ) => #matchSet(A;.Set;B;0;size(A))
  // trivial cases
    // once all patterns have been matched - great!
  rule #matchSet( _:Set ; _:Set ; .Set ; _:Int ; _:Int ) => true
    // if we run out of Par components to match the patterns, we better not have any patterns left to match
  rule #matchSet(  .Set ;  .Set ; A:Set ; _:Int ; _:Int ) => A ==K .Set
  // nontrivial cases
    // #matchSet( indexed parSet ; temp holder for other indices ; enumerated ParPatSet ; current index ; stop index )
    // index matches => increase index and subtract matching element
  rule #matchSet( SetItem( I:Int ; A:ProcPat ) B:Set ; C:Set ; D:Set ; I ; M:Int )
    => #matchSet(B C;.Set;#minus(SetItem(I;A);D);I +Int 1;M) requires I <=Int M
    // index doesn't match => set aside until index matches
  rule #matchSet( SetItem( I:Int ; A:ProcPat ) B:Set ; C:Set ; D:Set ; J:Int ; M:Int )
    => #matchSet(B;SetItem(I;A) C;D;J;M) requires J <=Int M andBool I =/=Int J
    // start over with increased current index
  rule #matchSet( .Set ; A:Set ; B:Set ; J:Int ; M:Int )
    => #matchSet(A;.Set;B;J +Int 1;M) requires J <=Int M andBool A =/=K .Set
  // after all Par components have been checked for a matching pattern - are there any patterns left?
  rule #matchSet( _:Set ; _:Set ; A:Set ; M:Int ; N:Int ) => A ==K .Set requires M ==Int N

// Par matching
  rule #matchPar( A:ParPat ; B:ParPat ) => #matchSet(#indexSet(#par2pats(A));#mustMatchSet(B))

// Par substitution -- #sub( A:ParPat ; B:ParPat )
  // Assuming #match(A;B) == true
  // 1. subs from mustMatchSet
  // 2. reamining Procs (matchMinus( #setify(A) ; #mustMatchSet(B) )) are bound to 0th variable in varSet(B) (varMap??)
  // 3. all other variables in varSet are bound to Nil

//--------------
//--- #minus ---
//--------------
  // Set x Set --> Elem x Set
  rule #matchMinus( A:Set ; SetItem( N:Int ; B:ProcPat ) C:Set ) => #matchMinus(#matchMinus(A;SetItem(N;B));C)
       requires C =/=K .Set
  // Elem x Set --> Set
  rule #matchMinus( SetItem( M:Int ; A:ProcPat ) B:Set ; SetItem( N:Int ; C:ProcPat ) )
    => #if #match(A;C)
       #then #if M >Int N
             #then SetItem(M -Int N;A) B
             #else #if M ==Int N
                   #then B
                   #else #matchMinus(B;SetItem(N -Int M;C)) #fi #fi
       #else SetItem(M;A) #matchMinus(B;SetItem(N;C)) #fi

// #minus: subtracts matched indexed patterns from mustMatchSet
  rule #minus( _:Set ; .Set ) => .Set
  rule #minus( SetItem( I:Int ; A:ProcPat ) ; SetItem( N:Int ; B:ProcPat ) C:Set )
    => #if #match(A;B)
       #then #if N >Int 1 #then SetItem(N -Int 1;B) C #else C #fi
       #else SetItem(N;B) #minus(SetItem(I;A);C) #fi

// #minus: subtracts
  // rule #minus( SetItem( M:Int ; A:Send ) ; SetItem( N:Int ; B:Name ; C:NamePats ) )
  //   => #if #nameEq(#chan(A);B) andBool #match(#quotes(#msg(A));C)
  //      #then #if N ==Int 1
  //            #then #if M ==Int 1
  //                  #then .Set
  //                  #else SetItem(M -Int 1;A) #fi
  //            #else #if M ==Int 1
  //                  #then SetItem(N -Int 1;B;C)
  //                  #else SetItem(M -Int 1;A) SetItem(N -Int 1;B;C) #fi
  //      #else #if M ==Int 1
  //            #then SetItem(N -Int 1;B;C)
  //            #else SetItem(M -Int 1;A) SetItem(N -Int 1;B;C) #fi
  //      #fi

// #enum: enumerates elements in an enumSet
  rule #enum( .Set ) => 0
  rule #enum( SetItem( N:Int ; _:ProcPat ) A:Set ) => N +Int #enum(A)

// Enumerated Bind Set
  // from Binds
  rule #enumBindSet( A:Lbind ) => SetItem(1;#chan(A);#bvar(A))
  rule #enumBindSet( A:Pbind ) => SetItem(1;#chan(A);#bvar(A))
  rule #enumBindSet( A:Rbind ) => SetItem(1;#chan(A);#bvar(A))
  rule #enumBindSet( A:Lbind & B:Lbind  ) => #addBind(#enumBindSet(A);#enumBindSet(B))
  rule #enumBindSet( A:Lbind & B:Lbinds ) => #addBind(#enumBindSet(A);#enumBindSet(B))
  rule #enumBindSet( A:Pbind & B:Pbind  ) => #addBind(#enumBindSet(A);#enumBindSet(B))
  rule #enumBindSet( A:Pbind & B:Pbinds ) => #addBind(#enumBindSet(A);#enumBindSet(B))
  rule #enumBindSet( A:Rbind & B:Rbind  ) => #addBind(#enumBindSet(A);#enumBindSet(B))
  rule #enumBindSet( A:Rbind & B:Rbinds ) => #addBind(#enumBindSet(A);#enumBindSet(B))
  // from Receive
  rule #enumBindSet( for( A:Lbind  ){ _:Proc } ) => #enumBindSet(A) [structural]
  rule #enumBindSet( for( A:Pbind  ){ _:Proc } ) => #enumBindSet(A) [structural]
  rule #enumBindSet( for( A:Rbind  ){ _:Proc } ) => #enumBindSet(A) [structural]
  rule #enumBindSet( for( A:Lbinds ){ _:Proc } ) => #enumBindSet(A) [structural]
  rule #enumBindSet( for( A:Pbinds ){ _:Proc } ) => #enumBindSet(A) [structural]
  rule #enumBindSet( for( A:Rbinds ){ _:Proc } ) => #enumBindSet(A) [structural]
  rule #enumBindSet( for( A:Lbind  _:Guard ){ _:Proc } ) => #enumBindSet(A) [structural]
  rule #enumBindSet( for( A:Pbind  _:Guard ){ _:Proc } ) => #enumBindSet(A) [structural]
  rule #enumBindSet( for( A:Rbind  _:Guard ){ _:Proc } ) => #enumBindSet(A) [structural]
  rule #enumBindSet( for( A:Lbinds _:Guard ){ _:Proc } ) => #enumBindSet(A) [structural]
  rule #enumBindSet( for( A:Pbinds _:Guard ){ _:Proc } ) => #enumBindSet(A) [structural]
  rule #enumBindSet( for( A:Rbinds _:Guard ){ _:Proc } ) => #enumBindSet(A) [structural]

// SendSet
  rule #sendSet( A:Send )
    => SetItem( #chan(A) ; SetItem( #quotes(#spatialType(#msg(A))) ; SetItem( 1 ; #quotes(#msg(A)) ; #stype(A) ) ) )

// RecSet
  rule #recSet( A:Receive ) => SetItem( 1 ; #enumBindSet(A) ; #cont(A) ; #guard(A) ; #rtype(A) )

//----------
// #comm: sendMultiSet x recSet ---> Bool
  // rule #comm(  .Set ; A:Set ) => false requires A ==K .Set // binds remain, but no sends to match
  // rule #comm( _:Set ;  .Set ) => true                      // all binds have been matched
  // rule #commMinus( SetItem( M:Int ; A:Send ) B:Set ; SetItem( N:Int ; C:Name ; D:NamePats ) E:Set )
  //   => #commMinus( SetItem(M;A) ; SetItem(N;C;D) ) andBool
  //   => #if #nameEq(#chan(A);C) andBool #match(#msg(A);D)
  //      #then #if M ==Int 1 #then #comm(C;SetItem(N))


  rule  #isNamePat( A:K ) => isNamePat(A)
  rule #isQuotePat( A:K ) => isQuotePat(A)

endmodule
