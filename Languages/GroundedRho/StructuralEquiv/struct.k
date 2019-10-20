// Structural & Name Equivalence for Rholang

/*
TODO:
 - Patterns!!!
 - Normalize before checking structural equiv (then notBool isPar(...) and notBool isEval(...) can be removed)
 - make #structEq(A;B) == #match(A;B) andBool #match(B;A)
*/

require "../grho.k"
require "../AlphaEquiv/alpha.k"
require "../AuxFun/auxfun.k"
require "../Match/match.k"

module STRUCT-SYNTAX
  import DOMAINS
  import GRHO-SYNTAX

// Structural equivalence relation
  syntax        Bool ::=   "#structEq(" ProcPats ";" ProcPats ")" [function]
                       | "#structEqif(" ProcPats ";" ProcPats ")" [function]

  syntax        Bool ::=   "#structEq(" Map ";" Map ")" [function]
                       |   "#structEq(" Set ";" Set ")" [function]
                       | "#structEqif(" Map ";" Map ")" [function]
                       | "#structEqif(" Set ";" Set ")" [function]

  syntax        Bool ::= "#structEq(" RhoKVPairs ";" RhoKVPairs ")" [function]
  syntax        Bool ::= "#structEq(" RhoKVPats  ";" RhoKVPats  ")" [function]

// Name equivalence relation
  syntax        Bool ::=   "#nameEq(" NamePats ";" NamePats ")" [function]
                       | "#nameEqif(" NamePats ";" NamePats ")" [function]

// Comm Predicate
  syntax        Bool ::= "#matchComm(" Send ";;" AnyBind  ")" [function]
  syntax        Bool ::= "#matchComm(" Send ";;" AnyBinds ")" [function]

// Normalization functions
  syntax         Int ::=  "#parCount(" ProcPat ";" ProcPat  ")" [function]
  syntax     ProcPat ::= "#parRemove(" ProcPat ";" ProcPat  ")" [function]
                       |   "#parnorm(" ProcPat ")"              [function]
  syntax         Set ::=    "#setify(" ProcPat ")"              [function]

// Unary Ordering
  syntax        Proc ::= "#order(" Proc    ")" [function, poly(0,1)]
  syntax        Name ::= "#order(" Name    ")" [function]
  syntax     ProcPat ::= "#order(" ProcPat ")" [function]
  syntax     NamePat ::= "#order(" NamePat ")" [function]

  syntax        Proc ::= "#orderEach(" Proc     ")" [function, poly(0,1)]
  syntax       Procs ::=     "#order(" Procs    ")" [function]
                       | "#orderEach(" Procs    ")" [function]
  syntax        Name ::= "#orderEach(" Name     ")" [function]
  syntax       Names ::=     "#order(" Names    ")" [function]
                       | "#orderEach(" Names    ")" [function]
  syntax     ProcPat ::= "#orderEach(" ProcPat  ")" [function]
  syntax    ProcPats ::=     "#order(" ProcPats ")" [function]
                       | "#orderEach(" ProcPats ")" [function]
  syntax     NamePat ::= "#orderEach(" NamePat  ")" [function]
  syntax    NamePats ::=     "#order(" NamePats ")" [function]
                       | "#orderEach(" NamePats ")" [function]

  syntax   RhoKVPair ::= "#order(" RhoKVPair ")" [function]

  syntax  RhoKVPairs ::=     "#order(" RhoKVPairs ")" [function]
                       | "#orderEach(" RhoKVPairs ")" [function]

  syntax    RhoKVPat ::= "#order(" RhoKVPat ")" [function]

  syntax   RhoKVPats ::=     "#order(" RhoKVPats ")" [function]
                       | "#orderEach(" RhoKVPats ")" [function]

// Binary Ordering
  syntax        Bool ::=   "#order(" ProcPats  ";" ProcPats ")" [function]
                       |   "#order(" NamePats  ";" NamePats ")" [function]
                       | "#orderif(" ProcPats  ";" ProcPats ")" [function]
                       | "#orderif(" NamePats  ";" NamePats ")" [function]

  // subexpression ordering
    // BindPats
  syntax    LbindPat ::= "#order(" LbindPat   ")" [function]
  syntax   GLbindPat ::= "#order(" GLbindPat  ")" [function]
  syntax   LbindPats ::= "#order(" LbindPats  ")" [function]
  syntax  GLbindPats ::= "#order(" GLbindPats ")" [function]
  syntax    PbindPat ::= "#order(" PbindPat   ")" [function]
  syntax   GPbindPat ::= "#order(" GPbindPat  ")" [function]
  syntax   PbindPats ::= "#order(" PbindPats  ")" [function]
  syntax  GPbindPats ::= "#order(" GPbindPats ")" [function]
  syntax    RbindPat ::= "#order(" RbindPat   ")" [function]
  syntax   GRbindPat ::= "#order(" GRbindPat  ")" [function]
  syntax   RbindPats ::= "#order(" RbindPats  ")" [function]
  syntax  GRbindPats ::= "#order(" GRbindPats ")" [function]

  syntax        Bool ::=   "#order(" BindPat  ";;" BindPat  ")" [function]
                       |   "#order(" BindPat  ";;" BindPats ")" [function]
                       |   "#order(" BindPats ";;" BindPat  ")" [function]
                       |   "#order(" BindPats ";;" BindPats ")" [function]
                       | "#orderif(" BindPats ";;" BindPats ")" [function]

    // RhoKVPats
  syntax        Bool ::=   "#order(" RhoKVPats ";;" RhoKVPats  ")" [function]
                       | "#orderif(" RhoKVPats ";;" RhoKVPats  ")" [function]

// Reordering -- TODO: change to Pats
  syntax     ProcPat ::= "#reorder(" ProcPat  ")"                            [function]
  syntax    ProcPats ::= "#reorder(" ProcPats ")"                            [function]
                       | "#reorder("         ";;"          ";;" ProcPats ")" [function]
                       | "#reorder("         ";;" ProcPats ";;" ProcPats ")" [function]
                       | "#reorder(" ProcPat ";;" ProcPats ";;" ProcPats ")" [function]
                       | "#reorder(" ProcPat ";;" ProcPats ";;"          ")" [function]
                       | "#reorder("         ";;" ProcPats ";;"          ")" [function]

  syntax     NamePat ::= "#reorder(" NamePat  ")"                            [function]
  syntax    NamePats ::= "#reorder(" NamePats ")"                            [function]
                       | "#reorder("         ";;"          ";;" NamePats ")" [function]
                       | "#reorder("         ";;" NamePats ";;" NamePats ")" [function]
                       | "#reorder(" NamePat ";;" NamePats ";;" NamePats ")" [function]
                       | "#reorder(" NamePat ";;" NamePats ";;"          ")" [function]
                       | "#reorder("         ";;" NamePats ";;"          ")" [function]

  // Binds
  syntax    LbindPat ::= "#reorder(" LbindPat   ")"                             [function]
  syntax   GLbindPat ::= "#reorder(" GLbindPat  ")"                             [function]
  syntax  GLbindPats ::= "#reorder(" GLbindPats ")"                             [function]
  syntax   LbindPats ::= "#reorder(" LbindPats  ")"                             [function]
                       | "#reorder("          ";;"           ";;" LbindPats ")" [function]
                       | "#reorder("          ";;" LbindPat  ";;" LbindPat  ")" [function]
                       | "#reorder("          ";;" LbindPat  ";;" LbindPats ")" [function]
                       | "#reorder("          ";;" LbindPats ";;" LbindPat  ")" [function]
                       | "#reorder("          ";;" LbindPats ";;" LbindPats ")" [function]
                       | "#reorder(" LbindPat ";;" LbindPat  ";;" LbindPat  ")" [function]
                       | "#reorder(" LbindPat ";;" LbindPat  ";;" LbindPats ")" [function]
                       | "#reorder(" LbindPat ";;" LbindPats ";;" LbindPat  ")" [function]
                       | "#reorder(" LbindPat ";;" LbindPats ";;" LbindPats ")" [function]
                       | "#reorder(" LbindPat ";;" LbindPat  ";;"           ")" [function]
                       | "#reorder(" LbindPat ";;" LbindPats ";;"           ")" [function]
                       | "#reorder("          ";;" LbindPats ";;"           ")" [function]
  syntax    PbindPat ::= "#reorder(" PbindPat   ")"                             [function]
  syntax   GPbindPat ::= "#reorder(" GPbindPat  ")"                             [function]
  syntax  GPbindPats ::= "#reorder(" GPbindPats ")"                             [function]
  syntax   PbindPats ::= "#reorder(" PbindPats  ")"                             [function]
                       | "#reorder("          ";;"           ";;" PbindPats ")" [function]
                       | "#reorder("          ";;" PbindPat  ";;" PbindPat  ")" [function]
                       | "#reorder("          ";;" PbindPat  ";;" PbindPats ")" [function]
                       | "#reorder("          ";;" PbindPats ";;" PbindPat  ")" [function]
                       | "#reorder("          ";;" PbindPats ";;" PbindPats ")" [function]
                       | "#reorder(" PbindPat ";;" PbindPat  ";;" PbindPat  ")" [function]
                       | "#reorder(" PbindPat ";;" PbindPat  ";;" PbindPats ")" [function]
                       | "#reorder(" PbindPat ";;" PbindPats ";;" PbindPat  ")" [function]
                       | "#reorder(" PbindPat ";;" PbindPats ";;" PbindPats ")" [function]
                       | "#reorder(" PbindPat ";;" PbindPat  ";;"           ")" [function]
                       | "#reorder(" PbindPat ";;" PbindPats ";;"           ")" [function]
                       | "#reorder("          ";;" PbindPats ";;"           ")" [function]
  syntax    RbindPat ::= "#reorder(" RbindPat   ")"                             [function]
  syntax   GRbindPat ::= "#reorder(" GRbindPat  ")"                             [function]
  syntax  GRbindPats ::= "#reorder(" GRbindPats ")"                             [function]
  syntax   RbindPats ::= "#reorder(" RbindPats  ")"                             [function]
                       | "#reorder("          ";;"           ";;" RbindPats ")" [function]
                       | "#reorder("          ";;" RbindPat  ";;" RbindPat  ")" [function]
                       | "#reorder("          ";;" RbindPat  ";;" RbindPats ")" [function]
                       | "#reorder("          ";;" RbindPats ";;" RbindPat  ")" [function]
                       | "#reorder("          ";;" RbindPats ";;" RbindPats ")" [function]
                       | "#reorder(" RbindPat ";;" RbindPat  ";;" RbindPat  ")" [function]
                       | "#reorder(" RbindPat ";;" RbindPat  ";;" RbindPats ")" [function]
                       | "#reorder(" RbindPat ";;" RbindPats ";;" RbindPat  ")" [function]
                       | "#reorder(" RbindPat ";;" RbindPats ";;" RbindPats ")" [function]
                       | "#reorder(" RbindPat ";;" RbindPat  ";;"           ")" [function]
                       | "#reorder(" RbindPat ";;" RbindPats ";;"           ")" [function]
                       | "#reorder("          ";;" RbindPats ";;"           ")" [function]

// TODO: reorder bind patterns semantics
  // unguarded
  syntax    LbindPat ::= "#reorder(" LbindPat   ")" [function]
  syntax   LbindPats ::= "#reorder(" LbindPats  ")" [function]
  syntax   GLbindPat ::= "#reorder(" GLbindPat  ")" [function]
  syntax  GLbindPats ::= "#reorder(" GLbindPats ")" [function]
  syntax    PbindPat ::= "#reorder(" PbindPat   ")" [function]
  syntax   PbindPats ::= "#reorder(" PbindPats  ")" [function]
  syntax   GPbindPat ::= "#reorder(" GPbindPat  ")" [function]
  syntax  GPbindPats ::= "#reorder(" GPbindPats ")" [function]
  syntax    RbindPat ::= "#reorder(" RbindPat   ")" [function]
  syntax   RbindPats ::= "#reorder(" RbindPats  ")" [function]
  syntax   GRbindPat ::= "#reorder(" GRbindPat  ")" [function]
  syntax  GRbindPats ::= "#reorder(" GRbindPats ")" [function]

  // RhoKVPats
  syntax    RhoKVPat ::= "#reorder(" RhoKVPat   ")"                                [function]
  syntax   RhoKVPats ::= "#reorder(" RhoKVPats  ")"                                [function]
                       | "#reorder("           ";;"            ";;" RhoKVPats  ")" [function]
                       | "#reorder("           ";;" RhoKVPats  ";;" RhoKVPats  ")" [function]
                       | "#reorder(" RhoKVPat  ";;" RhoKVPats  ";;" RhoKVPats  ")" [function]
                       | "#reorder(" RhoKVPat  ";;" RhoKVPats  ";;"            ")" [function]
                       | "#reorder("           ";;" RhoKVPats  ";;"            ")" [function]

/*
  // #chanRelSet: Receive/RecPat/Bind[Pat][s] -> set of seta of related channel indices
  syntax         Set ::= "#chanRelSet(" Receive  ")" [function]
                       | "#chanRelSet(" RecPat   ")" [function]
  syntax         Set ::= "#chanRelSet(" Bind     ")" [function]
                       | "#chanRelSet(" Binds    ")" [function]
                       | "#chanRelSet(" BindPat  ")" [function]
                       | "#chanRelSet(" BindPats ")" [function]
  // recursively checks relations with first Bind
  syntax         Set ::= "#chanRelSet(" Bind     ";;" Bind     ";;" Int ";" Int ")" [function]
                       | "#chanRelSet(" Bind     ";;" Binds    ";;" Int ";" Int ")" [function]
                       | "#chanRelSet(" BindPat  ";;" Bind     ";;" Int ";" Int ")" [function]
                       | "#chanRelSet(" BindPat  ";;" Binds    ";;" Int ";" Int ")" [function]
                       | "#chanRelSet(" Bind     ";;" BindPat  ";;" Int ";" Int ")" [function]
                       | "#chanRelSet(" Bind     ";;" BindPats ";;" Int ";" Int ")" [function]
                       | "#chanRelSet(" BindPat  ";;" BindPat  ";;" Int ";" Int ")" [function]
                       | "#chanRelSet(" BindPat  ";;" BindPats ";;" Int ";" Int ")" [function]
  // recursively checks all Bind relations
  syntax         Set ::= "#chanRelSet(" Bind     ";;" Bind     ";;" Int ";" Int ";" Int ")" [function]
                       | "#chanRelSet(" Bind     ";;" Binds    ";;" Int ";" Int ";" Int ")" [function]
                       | "#chanRelSet(" BindPat  ";;" Bind     ";;" Int ";" Int ";" Int ")" [function]
                       | "#chanRelSet(" BindPat  ";;" Binds    ";;" Int ";" Int ";" Int ")" [function]
                       | "#chanRelSet(" Bind     ";;" BindPat  ";;" Int ";" Int ";" Int ")" [function]
                       | "#chanRelSet(" Bind     ";;" BindPats ";;" Int ";" Int ";" Int ")" [function]
                       | "#chanRelSet(" BindPat  ";;" BindPat  ";;" Int ";" Int ";" Int ")" [function]
                       | "#chanRelSet(" BindPat  ";;" BindPats ";;" Int ";" Int ";" Int ")" [function]
                       | "#chanRelSet("          ";;" Binds    ";;" Int ";" Int ";" Int ")" [function]
                       | "#chanRelSet("          ";;" BindPats ";;" Int ";" Int ";" Int ")" [function]
  // chanRelSet union
  syntax         Set ::= "#unionCRS(" Set ";" Set ")" [function]
*/
// Translation to built-ins -- other half in AuxFun
  syntax        List ::= "#rho2list(" ListPat  ")" [function]
  syntax         Map ::=  "#rho2map(" ListPat  ")" [function]
                       |  "#rho2map(" MapPat   ")" [function]
                       |  "#rho2map(" TuplePat ")" [function]
  syntax         Set ::=  "#rho2set(" SetPat   ")" [function]

  syntax         Map ::= "#indexMap(" Int ";" ProcPats ")" [function]

  // Seq inclusion: Map & Set
  syntax        Bool ::= "#SeqSetIn(" Set ";" Set ")" [function] // structural equivalence Set inclusion
                       | "#SeqMapIn(" Map ";" Map ")" [function] // structural equivalence Map inclusion

// seq of left arg against all right arg Procs
  syntax        Bool ::=    "#structEqs(" ProcPat ";" ProcPats ")" [function]
// seq of left arg against all keys of RhoKVPairs
  syntax        Bool ::= "#key_structEq(" ProcPat ";" RhoKVPats ")" [function]
                       | "#key_structEq(" ProcPat ";" Map       ")" [function]

  syntax        Bool ::= "#isPar(" ProcPat ")" [function]

  syntax       KItem ::= IndexedSet | IndexedProcs | ProcPat

endmodule

module STRUCT
  import STRUCT-SYNTAX
  import ALPHA
  import AUXFUN
  import MATCH

  syntax KResult ::= Proc | Procs | Name | Names | Bool | Int | List | Map | Set | IndexedSet
                   | Lbind | Lbinds | Pbind | Pbinds | Rbind | Rbinds
                   | LbindPat  | LbindPats  | PbindPat | PbindPats | RbindPat | RbindPats
                   | RhoKVPair | RhoKVPairs | RhoKVPat | RhoKVPats

  rule #isPar( A:ProcPat ) => isPar(A)

// counts number of structurally eq appearances of a nonPar Proc in a Par
// first arg intended to be nonPar, second arg is intended to be Par (enforced by #setify)
  // single-Proc Par i.e. a nonPar Proc
  rule #parCount( *A:Var     ; *B:NamePat )
    => #if A ==K B #then 1 #else 0 #fi
  rule #parCount( *A:Var     ;  B:ProcPat )
    => 0 requires notBool isEvalVar(B)
  rule #parCount( *A:Var     ;  B:ProcPat | C:ProcPat )
    => #parCount(*A;C) requires notBool (isEvalVar(B) orBool isParPat(B))
  rule #parCount(  A:ProcPat ;  B:ProcPat )
    => #if isProcVar(A)
       #then #if A ==K B #then 1 #else 0 #fi
       #else #if #structEq(A;B) #then 1 #else 0 #fi #fi
       requires notBool (isEvalVar(A) orBool isParPat(B))
  // multi-Proc Par
  rule #parCount( A:ProcPat ; B:ProcPat | C:ProcPat )
    => #if isProcVar(A)
       #then #if A ==K B #then 1 +Int #parCount(A;C) #else #parCount(A;C) #fi
       #else #if #structEq(A;B) #then 1 +Int #parCount(A;C) #else #parCount(A;C) #fi #fi
       requires notBool (isEvalVar(A) orBool isParPat(B))

// traverses Par removing structurally eq nonPar Procs
// first arg intended to be nonPar, second arg is intended to be Par (enforced by #setify)
  // single-Proc Par i.e. a nonPar Proc
  rule #parRemove( A:ProcPat ; B:ProcPat )
    => #if isProcVar(A)
       #then #if A ==K B #then Nil #else B #fi
       #else #if #structEq(A;B) #then Nil #else B #fi #fi
       requires notBool (isEvalVar(A) orBool isParPat(B))
  rule #parRemove( *A:Var ; *B:NamePat )
    => #if A ==K B #then Nil #else *B #fi
  rule #parRemove( *A:Var ;  B:ProcPat )
    => Nil requires notBool (isEvalVar(B) orBool isParPat(B))
  rule #parRemove( *A:Var ;  B:ProcPat | C:ProcPat )
    => #parRemove(*A;C) requires notBool (isEvalVar(B) orBool isParPat(B))
  // multi-Proc Par
  rule #parRemove( A:ProcPat ; B:ProcPat | C:ProcPat )
    => #if isProcVar(A)
       #then #if A ==K B #then #parRemove(A;C) #else B | #parRemove(A;C) #fi
       #else #if #structEq(A;B) #then #parRemove(A;C) #else B | #parRemove(A;C) #fi #fi
       requires notBool (isEvalVar(A) orBool isParPat(B))

// computes par set of a Proc
  // par set of a nonPar Proc contains only one appearance of that Proc
  rule #setify( A:ProcPat ) => SetItem(1;#order(A)) requires notBool isParPat(A)
  rule #setify( A:ProcPat | B:ProcPat )
    => #if #parCount(A;B) >Int 0
       #then SetItem(1 +Int #parCount(A;B);#order(A)) (#setify(#parRemove(A;B)) -Set SetItem(1;Nil))
       #else SetItem(1;#order(A)) (#setify(B) -Set SetItem(1;Nil))
       #fi requires notBool isParPat(A)

  // Par normalization
  rule #parnorm( A:ParPat  ) => #pats2par(#reorder(#orderEach(#par2pats(A))))
  rule #parnorm( A:ProcPat ) => A requires notBool isParPat(A)

//-------------------
//--- Unary Order ---
//-------------------
//  Returns least order term structurally equivalent to input
  // OrderEach
  rule #orderEach( A:NamePat ) => #order(A)
  rule #orderEach( A:NamePat , B:NamePats ) => #order(A) , #orderEach(B)
  rule #orderEach( A:ProcPat ) => #order(A)
  rule #orderEach( A:ProcPat , B:ProcPats ) => #order(A) , #orderEach(B)

  // TODO: finish unary order
  rule #order( @A:ProcPat ) => @#order(A)
  rule #order(  A:Var     ) => A

  rule #order(   A:Var      :: B:NamePat ) =>    A  :: #order(B)
  rule #order( (@A:ProcVar) :: B:NamePat ) =>  (@A) :: #order(B)
  rule #order(   A:ProcVar  :: B:ProcPat ) =>    A  :: #order(B)
  rule #order( (*A:Var)     :: B:ProcPat ) =>  (*A) :: #order(B)

  rule #order( A:ProcPat ) => A [owise] // to be removed once definition is completed
  rule #order( A:Ground  ) => A

// RecPat
  rule #order( A:RecPat ) => for(#reorder(#gbind(A))){#order(#cont(A))}

// SendPat
  rule #order( A:NamePat !  ( ) ) => #order(A)! ( )
  rule #order( A:NamePat !! ( ) ) => #order(A)!!( )
  rule #order( A:NamePat !  ( B:ProcPats ) ) => #order(A)! ( #orderEach(B) )
  rule #order( A:NamePat !! ( B:ProcPats ) ) => #order(A)!!( #orderEach(B) )

// ParPat
  rule #order( A:ParPat ) => #parnorm(A)

// CollectionPat
  // ListPat
  rule #order( [            ] ) => [ ]
  rule #order(  EmptyListPat  ) => EmptyListPat
  rule #order( [ A:ProcPats ] ) => [ #orderEach(A) ]
  rule #order( [ A:ProcPats ... B:ProcVar ] ) => [ #orderEach(A) ... B ]
  // MapPat
  rule #order( {         } ) => { }
  rule #order( EmptyMapPat ) => EmptyMapPat
  rule #order( A:MapPat    ) => { #orderEach(#map2KVs(#rho2map(A))) }
       requires notBool (isEmptyMap(A) orBool A ==K EmptyMapPat)
  // SetPat
  rule #order(   Set(    ) ) => Set( )
  rule #order( EmptySetPat ) => EmptySetPat
  rule #order( A:SetPat    ) => Set( #orderEach(#set2procs(#rho2set(A))) )
       requires notBool (isEmptySet(A) orBool A ==K EmptySetPat)
  rule #order( Set( A:ProcPats ... B:ProcVar ) ) => Set(  )
  // TuplePat
  rule #order( ( A:ProcPats ,) ) => ( #orderEach(A) ,)

// BindPats
  rule #order( <-  A:NamePat ) => <-  #order(A)
  rule #order( <=  A:NamePat ) => <=  #order(A)
  rule #order( <<- A:NamePat ) => <<- #order(A)
  rule #order( A:LbindPat ) => #orderEach(#bvar(A)) <-  #order(#chan(A))
       requires notBool isEmptyLbind(A)
  rule #order( A:PbindPat ) => #orderEach(#bvar(A)) <<- #order(#chan(A))
       requires notBool isEmptyPbind(A)
  rule #order( A:RbindPat ) => #orderEach(#bvar(A)) <=  #order(#chan(A))
       requires notBool isEmptyRbind(A)

  rule #order( A:LbindPat & B:LbindPat  ) => #order(A) & #order(B)
  rule #order( A:LbindPat & B:LbindPats ) => #order(A) & #order(B)
  rule #order( A:PbindPat & B:PbindPat  ) => #order(A) & #order(B)
  rule #order( A:PbindPat & B:PbindPats ) => #order(A) & #order(B)
  rule #order( A:RbindPat & B:RbindPat  ) => #order(A) & #order(B)
  rule #order( A:RbindPat & B:RbindPats ) => #order(A) & #order(B)

// Reorder to Order
  rule #reorder( A:LbindPat ) => #order(A)
  rule #reorder( A:PbindPat ) => #order(A)
  rule #reorder( A:RbindPat ) => #order(A)

// Patterns -- TODO: continue
  rule #order( A:SimplePat     ) => A
  rule #order( A:SimpleNamePat ) => A

//--------------------
//--- Binary Order ---
//--------------------
//   Think of #order( A:K ; B:K ) as order(A) <= order(B)
//   for some monotone increasing function order(_): K -> Real

  // check length first
  rule #orderif( A:ProcPats   ; B:ProcPats  ) => #length(A) ==Int #length(B) andBool #order(A;B)
  rule #orderif( A:NamePats   ; B:NamePats  ) => #length(A) ==Int #length(B) andBool #order(A;B)
  rule #orderif( A:RhoKVPats ;; B:RhoKVPats ) => #length(A) ==Int #length(B) andBool #order(A;;B)

  // Lexicographical Order
  rule #order( A:ProcPat , B:ProcPats ; C:ProcPat , D:ProcPats )
    => #if #order(A;C)
       #then #if #order(C;A)
             #then #order(B;D)
             #else true #fi
       #else false #fi

  rule #order( A:NamePat , B:NamePats ; C:NamePat , D:NamePats )
    => #if #order(A;C)
       #then #if #order(C;A)
             #then #order(B;D)
             #else true #fi
       #else false #fi

  // RhoKVPairs
  rule #order( A:RhoKVPat , B:RhoKVPats ;; C:RhoKVPat , D:RhoKVPats )
    => #if #order(A;;C)
       #then #if #order(C;;A)
             #then #order(B;;D)
             #else true #fi
       #else false #fi

  // BindPats
  rule #order( A:LbindPat & B:LbindPat  ;; C:LbindPat & D:LbindPat  )
    => #if #order(A;;C)
       #then #if #order(C;;A)
             #then #order(B;;D)
             #else true #fi
       #else false #fi
  rule #order( A:LbindPat & B:LbindPats ;; C:LbindPat & D:LbindPats )
    => #if #order(A;;C)
       #then #if #order(C;;A)
             #then #order(B;;D)
             #else true #fi
       #else false #fi
  rule #order( A:PbindPat & B:PbindPat  ;; C:PbindPat & D:PbindPat  )
    => #if #order(A;;C)
       #then #if #order(C;;A)
             #then #order(B;;D)
             #else true #fi
       #else false #fi
  rule #order( A:PbindPat & B:PbindPats ;; C:PbindPat & D:PbindPats )
    => #if #order(A;;C)
       #then #if #order(C;;A)
             #then #order(B;;D)
             #else true #fi
       #else false #fi
  rule #order( A:RbindPat & B:RbindPat  ;; C:RbindPat & D:RbindPat  )
    => #if #order(A;;C)
       #then #if #order(C;;A)
             #then #order(B;;D)
             #else true #fi
       #else false #fi
  rule #order( A:RbindPat & B:RbindPats ;; C:RbindPat & D:RbindPats )
    => #if #order(A;;C)
       #then #if #order(C;;A)
             #then #order(B;;D)
             #else true #fi
       #else false #fi

// Reflexivity
  rule #order( A:ProcPats ; A ) => true

  // Ground
    // Nil
  rule #order( A:ProcPat ; Nil       ) => A ==K Nil
  rule #order( Nil       ; _:ProcPat ) => true
    // Bool
  rule #order( _:Bool    ; A:ProcPat ) => true
       requires notBool (A ==K Nil orBool isBool(A))
  rule #order( A:ProcPat ; _:Bool    ) => false
       requires notBool (A ==K Nil orBool isBool(A))
  rule #order( true   ; A:Bool ) => A
  rule #order( false  ; _:Bool ) => true
    // Int
  rule #order( _:Int     ; A:ProcPat ) => true
       requires notBool (A ==K Nil orBool isBool(A) orBool isInt(A))
  rule #order( A:ProcPat ; _:Int     ) => false
       requires notBool (A ==K Nil orBool isBool(A) orBool isInt(A))
  rule #order( I:Int  ; J:Int  ) => I <=Int J
    // String
  rule #order( _:String  ; A:ProcPat ) => true
       requires notBool (A ==K Nil orBool isBool(A) orBool isInt(A)
         orBool isString(A))
  rule #order( A:ProcPat ; _:String  ) => false
       requires notBool (A ==K Nil orBool isBool(A) orBool isInt(A)
         orBool isString(A))
  rule #order( A:String ; B:String ) => #set2procs(#procs2set(A,B)) ==K (A,B)
    // Unforgeable
  rule #order( _:Unforgeable ; A:ProcPat     ) => true
       requires notBool (A ==K Nil orBool isBool(A) orBool isInt(A)
         orBool isString(A) orBool isUnforgeable(A))
  rule #order( A:ProcPat     ; _:Unforgeable ) => false
       requires notBool (A ==K Nil orBool isBool(A) orBool isInt(A)
         orBool isString(A) orBool isUnforgeable(A))
  rule #order( unforgeable( I:Int ) ; unforgeable( J:Int ) ) => I <=Int J
    // Uri
  rule #order( _:Uri     ; A:ProcPat ) => true
       requires notBool (A ==K Nil orBool isBool(A) orBool isInt(A)
         orBool isString(A) orBool isUnforgeable(A) orBool isUri(A))
  rule #order( A:ProcPat ; _:Uri     ) => false
       requires notBool (A ==K Nil orBool isBool(A) orBool isInt(A)
         orBool isString(A) orBool isUnforgeable(A) orBool isUri(A))
  rule #order( A:Uri ; B:Uri ) => #set2procs(#procs2set(A,B)) ==K (A,B)

  // Variables -- use as Id and map to string for comparison
  rule #order( \(_:Var)  ; A:ProcPat ) => true
       requires notBool (A ==K Nil orBool isGround(A) orBool isProcVar(A))
  rule #order( A:ProcPat ; \(_:Var)  ) => false
       requires notBool (A ==K Nil orBool isGround(A) orBool isProcVar(A))
  rule #order( \A:Id ; \B:Id )
    => #set2procs(#procs2set(Id2String(A),Id2String(B))) ==K (Id2String(A),Id2String(B))
    // Eval
  rule #order( *_:Var    ; A:ProcPat ) => true
       requires notBool (A ==K Nil orBool isGround(A) orBool isProcVar(A)
           orBool isEval(A))
  rule #order( A:ProcPat ; *_:Var    ) => false
       requires notBool (A ==K Nil orBool isGround(A) orBool isProcVar(A)
           orBool isEval(A))
  rule #order( *A:Id ; *B:Id )
    => #set2procs(#procs2set(Id2String(A),Id2String(B))) ==K (Id2String(A),Id2String(B))

  // VarRef
  rule #order( _:VarRef  ; A:ProcPat ) => true
       requires notBool (A ==K Nil orBool isGround(A) orBool isProcVar(A)
           orBool isEval(A) orBool isVarRef(A))
  rule #order( A:ProcPat ; _:VarRef  ) => false
       requires notBool (A ==K Nil orBool isGround(A) orBool isProcVar(A)
           orBool isEval(A) orBool isVarRef(A))
  rule #order( = *A:Id ; = *B:Id ) => #order(A;B)
  rule #order( = \A:Id ; = \B:Id ) => #order(A;B)

  // NewPat
  rule #order( _:NewPat  ; A:ProcPat ) => true
       requires notBool (A ==K Nil orBool isGround(A) orBool isProcVar(A)
           orBool isEval(A) orBool isVarRef(A) orBool isNew(A))
  rule #order( A:ProcPat ; _:NewPat  ) => false
       requires notBool (A ==K Nil orBool isGround(A) orBool isProcVar(A)
           orBool isEval(A) orBool isVarRef(A) orBool isNew(A))
  rule #order( new A:VarDecs in { B:ProcPat } ; new C:VarDecs in { D:ProcPat } )
    => #if #orderif(A;C)
       #then #if #order(C;A)
             #then #order(B;D)
             #else true #fi
       #else false #fi

 // Receive: Binds , Guard , Cont
  rule #order( A:RecPat ; B:RecPat )
    => #if #order(#bind(A);;#bind(B))
       #then #if #order(#bind(B);;#bind(A))
             #then #if #order(#guard(A);#guard(B))
                   #then #if #order(#guard(B);#guard(A))
                         #then #order(#cont(A);#cont(B))
                         #else true #fi
                   #else false #fi
             #else true #fi
       #else false #fi

  rule #order( _:RecPat ; A:ProcPat ) => true
       requires notBool (A ==K Nil orBool isGround(A) orBool isProcVar(A)
           orBool isEval(A) orBool isVarRef(A) orBool isNewPat(A)
           orBool isRecPat(A))
  rule #order( A:ProcPat ; _:RecPat ) => false
       requires notBool (A ==K Nil orBool isGround(A) orBool isProcVar(A)
           orBool isEval(A) orBool isVarRef(A) orBool isNewPat(A)
           orBool isRecPat(A))

  // Binds: lexicographical order by Type , length , Chans , bvars
  rule #order( A:BindPat ;; B:BindPat )
    => #if #rtype(A) <=Int #rtype(B)
       #then #if #rtype(A) ==Int #rtype(B)
             #then #if #lislen(A) <=Int #lislen(B)
                   #then #if #lislen(A) ==Int #lislen(B)
                         #then #if #order(#chan(A);#chan(B))
                               #then #if #order(#chan(B);#chan(A))
                                     #then #order(#bvar(A);#bvar(B))
                                     #else true #fi
                               #else false #fi
                         #else true #fi
                   #else false #fi
             #else true #fi
       #else false #fi

  // Send: lexicographical order by Type , # of msgs , Chan , Msg
  rule #order( A:SendPat ; B:SendPat )
    => #if #stype(A) <=Int #stype(B)
       #then #if #stype(A) ==Int #stype(B)
             #then #if #msglen(A) <=Int #msglen(B)
                   #then #if #msglen(A) ==Int #msglen(B)
                         #then #if #order(#chan(A);#chan(B))
                               #then #if #order(#chan(B);#chan(A))
                                     #then #order(#msg(A);#msg(B))
                                     #else true #fi
                               #else false #fi
                         #else true #fi
                   #else false #fi
             #else true #fi
       #else false #fi

  rule #order( _:SendPat ; A:ProcPat ) => true
       requires notBool (A ==K Nil orBool isGround(A) orBool isProcVar(A)
           orBool isEval(A) orBool isVarRef(A) orBool isNewPat(A)
           orBool isRecPat(A) orBool isSendPat(A))
  rule #order( A:ProcPat ; _:SendPat ) => false
       requires notBool (A ==K Nil orBool isGround(A) orBool isProcVar(A)
           orBool isEval(A) orBool isVarRef(A) orBool isNewPat(A)
           orBool isRecPat(A) orBool isSendPat(A))

// TODO
  // MethodProc: Proc . Method ( Args ) dictionary order by Method , Args , Proc
  // Exp: BExp < AExp <StringExp
  // Matching: dictionary order by # of MatchCases, Proc, MatchCases
  // Contract: dictionary order by Chan , NamePat
  // Bundle:  < 0 < - < + and #order(Proc;Proc)
  // Conditional: dictionary order by BExp , then Proc [, else Proc]

  // Collection: List < Map < Set < Tuple -- TODO: add other patterns
    // ListPat
  rule #order( _:ListPat ; A:CollectionPat ) => true  requires notBool isListPat(A)
  rule #order( A:CollectionPat ; _:ListPat ) => false requires notBool isListPat(A)
  rule #order( [ ] ; A:ListPat ) => true
  rule #order( A:ListPat ; [ ] ) => false requires A =/=K [ ]
  rule #order( [ A:ProcPats ] ; [ B:ProcPats ] ) => #orderif(A;B)
    // MapPat
  rule #order( _:MapPat ; A:CollectionPat ) => true
       requires notBool (isListPat(A) orBool isMapPat(A))
  rule #order( A:CollectionPat ; _:MapPat ) => false
       requires notBool (isListPat(A) orBool isMapPat(A))
  rule #order( { } ; A:MapPat ) => true
  rule #order( A:MapPat ; { } ) => false requires A =/=K { }
  rule #order( { A:RhoKVPats } ; { B:RhoKVPats } ) => #orderif(A;;B)
    // RhoKVPairs
  rule #order( A:ProcPat : B:ProcPat  ;; C:ProcPat : D:ProcPat  )
    => #if #order(A;C)
       #then #if #order(C;A)
             #then #order(B;D)
             #else true #fi
       #else false #fi
  rule #order( A:RhoKVPat , B:RhoKVPats ;; C:RhoKVPat , D:RhoKVPats )
    => #if #order(A;;C)
       #then #if #order(C;;A)
             #then #order(B;;D)
             #else true #fi
       #else false #fi


  rule #order( @A:ProcPat ; @B:ProcPat ) => #order( A; B)
  rule #order( @A:ProcPat ;  B:Var     ) => #order( A;*B)
  rule #order(  A:Var     ; @B:ProcPat ) => #order(*A; B)
  rule #order(  A:Id      ;  B:Id      )
    => #set2procs(#procs2set(Id2String(A),Id2String(B))) ==K (Id2String(A),Id2String(B))

// ParPat
  rule #order( A:ProcPat | B:ProcPat ; C:ProcPat | D:ProcPat )
    => #if #order(A;C)
       #then #if #order(C;A)
             #then #order(B;D)
             #else true #fi
       #else false #fi

// Reorder
  // check order of left arg against all middle args and insert,
  // then move the head of the right arg list to the left arg and repeat

  //--- Procs ---
  rule #reorder( A:ParPat ) => #parnorm(A)

    // #reorder( Proc[s] )
  rule #reorder( A:Proc  ) => A requires notBool isPar(A)
  rule #reorder( A:Procs ) => #reorder( ;; ;;A) requires notBool isProc(A)

    // #reorder( ;; ;; Procs )
  rule #reorder( ;; ;; A:Proc , B:Procs ) => #reorder( ;;A;;B)

    // #reorder( ;; Procs ;; )
  rule #reorder( ;; A:Procs ;;  ) => A

    // #reorder( ;; Proc[s] ;; Proc[s] )
  rule #reorder( ;; A:Proc           ;; B:Proc           ) => #reorder(B;;A  ;; )
  rule #reorder( ;; A:Proc           ;; B:Proc , C:Procs ) => #reorder(B;;A  ;;C)
  rule #reorder( ;; A:Proc , B:Procs ;; C:Proc           ) => #reorder(C;;A,B;; )
  rule #reorder( ;; A:Proc , B:Procs ;; C:Proc , D:Procs ) => #reorder(C;;A,B;;D)

    // #reorder( Proc ;; Proc[s] ;; )
  rule #reorder( A:Proc ;; B:Proc ;; ) => #if #order(A;B) #then A,B #else B,A #fi
  rule #reorder( A:Proc ;; B:Proc , C:Procs ;; ) => #if #order(A;B)
                                                    #then #append(A;B,C)
                                                    #else #append(B;#reorder(A;;C;; )) #fi

    // #reorder( Proc ;; Proc[s] ;; Proc[s] )
  rule #reorder( A:Proc ;; B:Proc  ;; C:Proc           ) => #reorder(C;;#reorder(A;;B;; );; )
  rule #reorder( A:Proc ;; B:Proc  ;; C:Proc , D:Procs ) => #reorder(C;;#reorder(A;;B;; );;D)
  rule #reorder( A:Proc ;; B:Procs ;; C:Proc           ) => #reorder(C;;#reorder(A;;B;; );; )
  rule #reorder( A:Proc ;; B:Procs ;; C:Proc , D:Procs ) => #reorder(C;;#reorder(A;;B;; );;D)

  //--- Names ---
    // #reorder( Name[s] )
  rule #reorder( A:Name  ) => A
  rule #reorder( A:Names ) => #reorder( ;; ;;A) requires notBool isName(A)

    // #reorder( ;; ;; Names )
  rule #reorder( ;; ;; A:Name , B:Names ) => #reorder( ;;A;;B)

    // #reorder( ;; Names ;; )
  rule #reorder( ;; A:Names ;;  ) => A

    // #reorder( ;; Name[s] ;; Name[s] )
  rule #reorder( ;; A:Name           ;; B:Name           ) => #reorder(B;;A  ;; )
  rule #reorder( ;; A:Name           ;; B:Name , C:Names ) => #reorder(B;;A  ;;C)
  rule #reorder( ;; A:Name , B:Names ;; C:Name           ) => #reorder(C;;A,B;; )
  rule #reorder( ;; A:Name , B:Names ;; C:Name , D:Names ) => #reorder(C;;A,B;;D)

    // #reorder( Name ;; Name[s] ;; )
  rule #reorder( A:Name ;; B:Name ;; ) => #if #order(A;B) #then A,B #else B,A #fi
  rule #reorder( A:Name ;; B:Name , C:Names ;; ) => #if #order(A;B)
                                                      #then #append(A;B,C)
                                                      #else #append(B;#reorder(A;;C;; )) #fi

    // #reorder( Name ;; Name[s] ;; Name[s] )
  rule #reorder( A:Name ;; B:Name  ;; C:Name           ) => #reorder(C;;#reorder(A;;B;; );; )
  rule #reorder( A:Name ;; B:Name  ;; C:Name , D:Names ) => #reorder(C;;#reorder(A;;B;; );;D)
  rule #reorder( A:Name ;; B:Names ;; C:Name           ) => #reorder(C;;#reorder(A;;B;; );; )
  rule #reorder( A:Name ;; B:Names ;; C:Name , D:Names ) => #reorder(C;;#reorder(A;;B;; );;D)

  // Binds
    // Lbinds
    // #reorder( Lbind[s] )
  rule #reorder( A:Lbind  ) => A
  rule #reorder( A:Lbinds ) => #reorder( ;; ;;A)

    // #reorder( ;; ;; Lbinds )
  rule #reorder( ;; ;; A:Lbind & B:Lbind  ) => #reorder( ;;A;;B)
  rule #reorder( ;; ;; A:Lbind & B:Lbinds ) => #reorder( ;;A;;B)

    // #reorder( ;; Lbinds ;; )
  rule #reorder( ;; A:Lbinds ;;  ) => A

    // #reorder( ;; Lbind[s] ;; Lbind[s] )
  rule #reorder( ;; A:Lbind  ;; B:Lbind            ) => #reorder(B;;A;; )
  rule #reorder( ;; A:Lbind  ;; B:Lbind & C:Lbind  ) => #reorder(B;;A;;C)
  rule #reorder( ;; A:Lbind  ;; B:Lbind & C:Lbinds ) => #reorder(B;;A;;C)
  rule #reorder( ;; A:Lbinds ;; C:Lbind            ) => #reorder(C;;A;; )
  rule #reorder( ;; A:Lbinds ;; C:Lbind & D:Lbind  ) => #reorder(C;;A;;D)
  rule #reorder( ;; A:Lbinds ;; C:Lbind & D:Lbinds ) => #reorder(C;;A;;D)

    // #reorder( Lbind ;; Lbind[s] ;; )
  rule #reorder( A:Lbind ;; B:Lbind ;; ) => #if #order(A;;B) #then A&B #else B&A #fi
  rule #reorder( A:Lbind ;; B:Lbind & C:Lbind  ;; ) => #if #order(A;;B)
                                                       #then #append(A;;B&C)
                                                       #else #append(B;;#reorder(A;;C;; )) #fi
  rule #reorder( A:Lbind ;; B:Lbind & C:Lbinds ;; ) => #if #order(A;;B)
                                                       #then #append(A;;B&C)
                                                       #else #append(B;;#reorder(A;;C;; )) #fi

    // #reorder( Lbind ;; Lbind[s] ;; Lbind[s] )
  rule #reorder( A:Lbind ;; B:Lbind  ;; C:Lbind            ) => #reorder(C;;#reorder(A;;B;; );; )
  rule #reorder( A:Lbind ;; B:Lbind  ;; C:Lbind & D:Lbind  ) => #reorder(C;;#reorder(A;;B;; );;D)
  rule #reorder( A:Lbind ;; B:Lbind  ;; C:Lbind & D:Lbinds ) => #reorder(C;;#reorder(A;;B;; );;D)
  rule #reorder( A:Lbind ;; B:Lbinds ;; C:Lbind            ) => #reorder(C;;#reorder(A;;B;; );; )
  rule #reorder( A:Lbind ;; B:Lbinds ;; C:Lbind & D:Lbind  ) => #reorder(C;;#reorder(A;;B;; );;D)
  rule #reorder( A:Lbind ;; B:Lbinds ;; C:Lbind & D:Lbinds ) => #reorder(C;;#reorder(A;;B;; );;D)

    // Pbinds
    // #reorder( Pbind[s] )
  rule #reorder( A:Pbind  ) => A
  rule #reorder( A:Pbinds ) => #reorder( ;; ;;A)

    // #reorder( ;; ;; Pbinds )
  rule #reorder( ;; ;; A:Pbind & B:Pbind  ) => #reorder( ;;A;;B)
  rule #reorder( ;; ;; A:Pbind & B:Pbinds ) => #reorder( ;;A;;B)

    // #reorder( ;; Pbinds ;; )
  rule #reorder( ;; A:Pbinds ;;  ) => A

    // #reorder( ;; Pbind[s] ;; Pbind[s] )
  rule #reorder( ;; A:Pbind  ;; B:Pbind            ) => #reorder(B;;A;; )
  rule #reorder( ;; A:Pbind  ;; B:Pbind & C:Pbind  ) => #reorder(B;;A;;C)
  rule #reorder( ;; A:Pbind  ;; B:Pbind & C:Pbinds ) => #reorder(B;;A;;C)
  rule #reorder( ;; A:Pbinds ;; C:Pbind            ) => #reorder(C;;A;; )
  rule #reorder( ;; A:Pbinds ;; C:Pbind & D:Pbind  ) => #reorder(C;;A;;D)
  rule #reorder( ;; A:Pbinds ;; C:Pbind & D:Pbinds ) => #reorder(C;;A;;D)

    // #reorder( Pbind ;; Pbind[s] ;; )
  rule #reorder( A:Pbind ;; B:Pbind ;; ) => #if #order(A;;B) #then A&B #else B&A #fi
  rule #reorder( A:Pbind ;; B:Pbind & C:Pbind  ;; ) => #if #order(A;;B)
                                                       #then #append(A;;B&C)
                                                       #else #append(B;;#reorder(A;;C;; )) #fi
  rule #reorder( A:Pbind ;; B:Pbind & C:Pbinds ;; ) => #if #order(A;;B)
                                                       #then #append(A;;B&C)
                                                       #else #append(B;;#reorder(A;;C;; )) #fi

    // #reorder( Pbind ;; Pbind[s] ;; Pbind[s] )
  rule #reorder( A:Pbind ;; B:Pbind  ;; C:Pbind            ) => #reorder(C;;#reorder(A;;B;; );; )
  rule #reorder( A:Pbind ;; B:Pbind  ;; C:Pbind & D:Pbind  ) => #reorder(C;;#reorder(A;;B;; );;D)
  rule #reorder( A:Pbind ;; B:Pbind  ;; C:Pbind & D:Pbinds ) => #reorder(C;;#reorder(A;;B;; );;D)
  rule #reorder( A:Pbind ;; B:Pbinds ;; C:Pbind            ) => #reorder(C;;#reorder(A;;B;; );; )
  rule #reorder( A:Pbind ;; B:Pbinds ;; C:Pbind & D:Pbind  ) => #reorder(C;;#reorder(A;;B;; );;D)
  rule #reorder( A:Pbind ;; B:Pbinds ;; C:Pbind & D:Pbinds ) => #reorder(C;;#reorder(A;;B;; );;D)

    // Rbinds
    // #reorder( Rbind[s] )
  rule #reorder( A:Rbind  ) => A
  rule #reorder( A:Rbinds ) => #reorder( ;; ;;A)

    // #reorder( ;; ;; Rbinds )
  rule #reorder( ;; ;; A:Rbind & B:Rbind  ) => #reorder( ;;A;;B)
  rule #reorder( ;; ;; A:Rbind & B:Rbinds ) => #reorder( ;;A;;B)

    // #reorder( ;; Rbinds ;; )
  rule #reorder( ;; A:Rbinds ;;  ) => A

    // #reorder( ;; Rbind[s] ;; Rbind[s] )
  rule #reorder( ;; A:Rbind  ;; B:Rbind            ) => #reorder(B;;A;; )
  rule #reorder( ;; A:Rbind  ;; B:Rbind & C:Rbind  ) => #reorder(B;;A;;C)
  rule #reorder( ;; A:Rbind  ;; B:Rbind & C:Rbinds ) => #reorder(B;;A;;C)
  rule #reorder( ;; A:Rbinds ;; C:Rbind            ) => #reorder(C;;A;; )
  rule #reorder( ;; A:Rbinds ;; C:Rbind & D:Rbind  ) => #reorder(C;;A;;D)
  rule #reorder( ;; A:Rbinds ;; C:Rbind & D:Rbinds ) => #reorder(C;;A;;D)

    // #reorder( Rbind ;; Rbind[s] ;; )
  rule #reorder( A:Rbind ;; B:Rbind ;; ) => #if #order(A;;B) #then A&B #else B&A #fi
  rule #reorder( A:Rbind ;; B:Rbind & C:Rbind  ;; ) => #if #order(A;;B)
                                                       #then #append(A;;B&C)
                                                       #else #append(B;;#reorder(A;;C;; )) #fi
  rule #reorder( A:Rbind ;; B:Rbind & C:Rbinds ;; ) => #if #order(A;;B)
                                                       #then #append(A;;B&C)
                                                       #else #append(B;;#reorder(A;;C;; )) #fi

    // #reorder( Rbind ;; Rbind[s] ;; Rbind[s] )
  rule #reorder( A:Rbind ;; B:Rbind  ;; C:Rbind            ) => #reorder(C;;#reorder(A;;B;; );; )
  rule #reorder( A:Rbind ;; B:Rbind  ;; C:Rbind & D:Rbind  ) => #reorder(C;;#reorder(A;;B;; );;D)
  rule #reorder( A:Rbind ;; B:Rbind  ;; C:Rbind & D:Rbinds ) => #reorder(C;;#reorder(A;;B;; );;D)
  rule #reorder( A:Rbind ;; B:Rbinds ;; C:Rbind            ) => #reorder(C;;#reorder(A;;B;; );; )
  rule #reorder( A:Rbind ;; B:Rbinds ;; C:Rbind & D:Rbind  ) => #reorder(C;;#reorder(A;;B;; );;D)
  rule #reorder( A:Rbind ;; B:Rbinds ;; C:Rbind & D:Rbinds ) => #reorder(C;;#reorder(A;;B;; );;D)


//------------------------------
//--- Structural Equivalence ---
//------------------------------
  rule #structEq( A:Proc    ; A ) => true
  rule #structEq( A:ProcPat ; A ) => true

  // indexes arguments & checks par set equality -- Note: at least one arg is a Par
  // #setify turns nonPar Proc P into the one element set: SetItem(P  , 1)
  // #setify turns Par P1 | ... | PM into the indexed set: SetItem(P1 , n1) ... SetItem(PM,)
  rule #structEq( A:Proc ; B:Proc ) => #setify(#deBruijn(A)) ==K #setify(#deBruijn(B))
       requires isPar(A) orBool isPar(B)
  rule #structEq( A:Proc , B:Procs ; C:Proc , D:Procs ) => #structEq(A;C) andBool #structEq(B;D)

  // if length is not the same, two Proc lists cannot be structurally equivalent
  rule #structEqif( A:Procs    ; B:Procs    ) => #length(A) ==Int #length(B) andBool #structEq(A;B)
  rule #structEqif( A:Procs    ; B:ProcPats ) => false requires notBool isProcs(B)
  rule #structEqif( A:ProcPats ; B:Procs    ) => false requires notBool isProcs(A)

// Ground
  rule #structEq( A:Ground ; B:Ground ) => A ==K B
  rule #structEq( _:Ground ; B:Proc   ) => false requires notBool isGround(B)
  rule #structEq( A:Proc   ; _:Ground ) => false requires notBool isGround(A)

// Send
  rule #structEq( A:Send ; B:Send ) => #stype(A) ==Int #stype(B) andBool
       #nameEq(#chan(A);#chan(B)) andBool #structEqif(#msg(A);#msg(B))
  rule #structEq( A:Proc ; _:Send ) => false requires notBool (isSend(A) orBool isPar(A))
  rule #structEq( _:Send ; A:Proc ) => false requires notBool (isSend(A) orBool isPar(A))

// Receive -- checks equivalence of listening variables, channels, (Guard), and continuations
  // UGSRec
  rule #structEq( A:UGSRec ; B:UGSRec ) => #rtype(A) ==Int #rtype(B)   andBool  //same receive type
       #nameEqif(#bvar(A);#bvar(B)) andBool #nameEq(#chan(A);#chan(B)) andBool  //same listening variable & channel types
       #structEq(#sub(#mapify(0,0;#bvar(A));#cont(A));#sub(#mapify(0,0;#bvar(A));#sub(#bvar(A);#bvar(B);#cont(B))))
  // GSRec
  rule #structEq( A:GSRec ; B:GSRec ) =>  #rtype(A) ==Int #rtype(B)    andBool
       #nameEqif(#bvar(A);#bvar(B)) andBool #nameEq(#chan(A);#chan(B)) andBool
       #structEq(#sub(#mapify(0,0;#bvar(A));#guard(A));#sub(#mapify(0,0;#bvar(A));#sub(#bvar(A);#bvar(B);#guard(B)))) andBool
       #structEq(#sub(#mapify(0,0;#bvar(A));#cont(A));#sub(#mapify(0,0;#bvar(A));#sub(#bvar(A);#bvar(B);#cont(B))))

  // UGMRec -- TODO
  // GMRec -- TODO
// Contract -- TODO
// Invocation -- TODO

// Eval -- TODO: finish
  rule #structEq( *A:Name ; *B:Name ) => #nameEq(A;B)

// ProcVar -- TODO: test
  rule #structEq( _:ProcVar ; _:ProcVar ) => true
  rule #structEq( _:ProcVar ; A:Proc    ) => false requires notBool isProcVar(A)
  rule #structEq( A:Proc    ; _:ProcVar ) => false requires notBool isProcVar(A)

// New -- TODO
// VarRef -- TODO
// TypedProc -- TODO
// MethodProc -- TODO
// Match -- TODO
// Select -- TODO
// Conditional -- TODO

// Collection
  // RhoList
  rule #structEq( [ A:ProcPats ] ; [ B:ProcPats ] ) => #structEqif(A;B)
  rule #structEq(   A:ProcPat    ;   _:ListPat    ) => false requires notBool isListPat(A)
  rule #structEq(   _:ListPat    ;   A:ProcPat    ) => false requires notBool isListPat(A)
  // RhoMap
  rule #structEq( A:MapPat  ; B:MapPat  ) => #structEq(#rho2map(A);#rho2map(B))
  rule #structEq( A:ProcPat ; _:MapPat  ) => false requires notBool isMapPat(A)
  rule #structEq( _:MapPat  ; A:ProcPat ) => false requires notBool isMapPat(A)
  // RhoSet
  rule #structEq( A:SetPat  ; B:SetPat  ) => #structEq(#rho2set(A);#rho2set(B))
  rule #structEq( A:ProcPat ; _:SetPat  ) => false requires notBool isSetPat(A)
  rule #structEq( _:SetPat  ; A:ProcPat ) => false requires notBool isSetPat(A)
  // RhoTuple
  rule #structEq( ( A:ProcPats ,) ; ( B:ProcPats ,) ) => #structEqif(A;B)
  rule #structEq(   A:ProcPat     ; _:TuplePat      ) => false requires notBool isTuplePat(A)
  rule #structEq(   _:TuplePat    ; A:ProcPat       ) => false requires notBool isTuplePat(A)

// Expressions
  // AExp
  rule #structEq( - A:AExp ; - B:AExp ) => #structEq(A;B)
  rule #structEq( A:AExp % B:AExp ; C:AExp % D:AExp )
    => (#structEq(A;C) andBool #structEq(B;D)) orBool (#structEq(A;D) andBool #structEq(B;C))
  rule #structEq( A:AExp * B:AExp ; C:AExp * D:AExp )
    => (#structEq(A;C) andBool #structEq(B;D)) orBool (#structEq(A;D) andBool #structEq(B;C))
  rule #structEq( A:AExp / B:AExp ; C:AExp / D:AExp )
    => (#structEq(A;C) andBool #structEq(B;D)) orBool (#structEq(A;D) andBool #structEq(B;C))
  rule #structEq( A:AExp + B:AExp ; C:AExp + D:AExp )
    => (#structEq(A;C) andBool #structEq(B;D)) orBool (#structEq(A;D) andBool #structEq(B;C))
  rule #structEq( A:AExp - B:AExp ; C:AExp - D:AExp )
    => (#structEq(A;C) andBool #structEq(B;D)) orBool (#structEq(A;D) andBool #structEq(B;C))

  // BExp -- TODO: finish
  rule #structEq( not A:BExp ; not B:BExp ) => #structEq(A;B)
  rule #structEq( A:BExp and B:BExp ; C:BExp and D:BExp )
    => (#structEq(A;C) andBool #structEq(B;D)) orBool (#structEq(A;D) andBool #structEq(B;C))
  rule #structEq( A:BExp or  B:BExp ; C:BExp or  D:BExp )
    => (#structEq(A;C) andBool #structEq(B;D)) orBool (#structEq(A;D) andBool #structEq(B;C))
  rule #structEq( A:AExp <=  B:AExp ; C:AExp <=  D:AExp )
    => (#structEq(A;C) andBool #structEq(B;D)) orBool (#structEq(A;D) andBool #structEq(B;C))
  rule #structEq( A:AExp <   B:AExp ; C:AExp <=  D:AExp )
    => (#structEq(A;C) andBool #structEq(B;D)) orBool (#structEq(A;D) andBool #structEq(B;C))
  rule #structEq( A:AExp >=  B:AExp ; C:AExp <=  D:AExp )
    => (#structEq(A;C) andBool #structEq(B;D)) orBool (#structEq(A;D) andBool #structEq(B;C))
  rule #structEq( A:AExp >   B:AExp ; C:AExp <=  D:AExp )
    => (#structEq(A;C) andBool #structEq(B;D)) orBool (#structEq(A;D) andBool #structEq(B;C))
  rule #structEq( A:Proc ==  B:Proc ; C:Proc ==  D:Proc )
    => (#structEq(A;C) andBool #structEq(B;D)) orBool (#structEq(A;D) andBool #structEq(B;C))
  rule #structEq( A:Proc !=  B:Proc ; C:Proc !=  D:Proc )
    => (#structEq(A;C) andBool #structEq(B;D)) orBool (#structEq(A;D) andBool #structEq(B;C))
  rule #structEq( A:Name ==  B:Name ; C:Name ==  D:Name )
    => (#nameEq(A;C) andBool #nameEq(B;D)) orBool (#nameEq(A;D) andBool #nameEq(B;C))
  rule #structEq( A:Name !=  B:Name ; C:Name !=  D:Name )
    => (#nameEq(A;C) andBool #nameEq(B;D)) orBool (#nameEq(A;D) andBool #nameEq(B;C))
  rule #structEq( A:ProcPat matches B:ProcPat ; C:ProcPat matches D:ProcPat ) => #structEq(A;C) andBool #structEq(B;D)

  // List & String expressions -- TODO


//----------------------------------------
//--- Set & Map Structural Equivalence ---
//----------------------------------------
// Structural equivalence of Maps & Sets
  rule #structEq( A:Set ; B:Set ) => #SeqSetIn(A;B) andBool #SeqSetIn(B;A)
  rule #structEq( A:Map ; B:Map ) => #SeqMapIn(A;B) andBool #SeqMapIn(B;A)

// Structural equivalence Set inclusion
  // left arg empty Set
  rule #SeqSetIn(  .Set ; _:Set ) => true
  // right arg empty Set
  rule #SeqSetIn( A:Set ;  .Set ) => false requires A =/=K .Set

// TODO: normalize each element so this can become syntactic equality
  // #SeqSetIn( {e} S:Set ; T:Set ) => #SeqSetIn({e};T) and #SeqSetIn(S;T)
  // each element of the left arg Set must be contained in the right arg Set
  // and-branch over all left arg Set elements:
  rule #SeqSetIn( SetItem( A:Proc ) S:Set ; T:Set )
    => #SeqSetIn( SetItem(A);T) andBool #SeqSetIn(S;T)
       requires S =/=K .Set andBool T =/=K .Set

  // #SeqSetIn( {e} ; {e'} T:Set ) => #SeqSetIn({e};{e'}) or #SeqSetIn({e};T)
  // left arg Set element is contained in right arg Set if there's at least one struct equiv right arg Set element
  // or-brach over right arg Set elements:
  rule #SeqSetIn( SetItem( A:Proc ) ; SetItem( B:Proc ) T:Set )
    => #SeqSetIn(SetItem(A);SetItem(B)) orBool #SeqSetIn(SetItem(A);T)
       requires T =/=K .Set
  rule #SeqSetIn( SetItem( A:Proc ) ; SetItem( B:Proc ) ) => #structEq(A;B)

// Structural equivalence Map inclusion
  // left arg empty Map
  rule #SeqMapIn(  .Map ; _:Map ) => true
  // right arg empty Map
  rule #SeqMapIn( A:Map ;  .Map ) => false requires A =/=K .Map
// TODO: normalize each element so this can become syntactic equality
  rule #SeqMapIn( A:Proc |-> B:Proc M:Map ; N:Map )
    => #SeqMapIn( A |-> B;N) andBool #SeqMapIn(M;N)
       requires M =/=K .Map andBool N =/=K .Map
  rule #SeqMapIn( A:Proc |-> B:Proc ; C:Proc |-> D:Proc N:Map ) // struct equiv of keys and values
    => #SeqMapIn(A|->B;C|->D) orBool #SeqMapIn(A|->B;N)
       requires N =/=K .Map
  rule #SeqMapIn( A:Proc |-> B:Proc ; C:Proc |-> D:Proc ) => #structEq(A;C) andBool #structEq(B;D)

//------------------------
//--- Name Equivalence ---
//------------------------
// Name equivalence == symmetric name matching
  rule #nameEq( A:NamePat ; A ) => true
  rule #nameEq( A:NamePat ; B:NamePat ) => #match(A;B) andBool #match(B;A)

  // several Names
  rule #nameEq( A:NamePat , B:NamePats ; C:NamePat , D:NamePats ) => #nameEq(A;C) andBool #nameEq(B;D)

  // check length
  rule #nameEqif( A:NamePats ; B:NamePats ) => #length(A) ==Int #length(B) andBool #nameEq(A;B)
//  rule #nameEqif( A:Names    ; B:NamePats ) => false
//  rule #nameEqif( A:NamePats ; B:Names    ) => false

//-----------------
//--- Built-ins ---
//-----------------
// #rho2list -- throws [Error] Internal: Uncaught exception thrown of type AssertionError.
// direct RhoList to List translation
  rule #rho2list( [ ] ) => .List
  rule #rho2list( [ A:ProcPat ] ) => ListItem(A)
  rule #rho2list( [ A:ProcPat , B:ProcPats ] ) => ListItem(A) #rho2list([B])

// #rho2map
  // RhoList -- produces Map with position keys
  rule #rho2map( [ ] ) => .Map
  rule #rho2map( [ A:ProcPats ] ) => #indexMap(0;A)
  rule #indexMap( I:Int ; A:ProcPat ) => I |-> A
  rule #indexMap( I:Int ; A:ProcPat , B:ProcPats ) => I |-> A #indexMap(I +Int 1;B)

  // RhoTuple -- produces Map with position keys
  rule #rho2map( ( A:ProcPats ,) ) => #indexMap(0;A)

  // RhoMap -- produces Map with a unique key-value pair for each structurally equivalent key
  rule #rho2map( { } ) => .Map
  rule #rho2map( { A:ProcPat : B:ProcPat } ) => A |-> B
  rule #rho2map( { A:ProcPat : B:ProcPat , C:RhoKVPats } )
    => #if #key_structEq(A;C)
       #then #rho2map({C})
       #else A |-> B #rho2map({C}) #fi

// #rho2set
  rule #rho2set( Set( ) ) => .Set
  rule #rho2set( Set( A:ProcPat ) ) => SetItem(A)
  rule #rho2set( Set( A:ProcPat , B:ProcPats ) )
    => #if #structEqs(A;B)
       #then #rho2set(Set(B)) // if #structEq(A;C) for some C in B, discard A
       #else SetItem(A) #rho2set(Set(B)) #fi // otherwise keep A and traverse remaining set

  // #key_structEq( key ; RhoKVPat/Map )
  rule #key_structEq( A:ProcPat ; B:ProcPat :   _:ProcPat ) => #structEq(A;B)
  rule #key_structEq( A:ProcPat ; B:ProcPat |-> _:ProcPat ) => #structEq(A;B)
  rule #key_structEq( A:ProcPat ;  .Map ) => false
  // #key_structEq( key ; RhoKVPairs/Map )
  rule #key_structEq( A:ProcPat ; B:ProcPat : _:ProcPat , C:RhoKVPats ) => #structEq(A;B) orBool #key_structEq(A;C)
  rule #key_structEq( A:ProcPat ; B:ProcPat |-> _:ProcPat C:Map ) => #structEq(A;B) orBool #key_structEq(A;C)

  // checks if 1st arg is structurally equivalent to any of the 2nd args
  rule #structEqs( A:ProcPat ; B:ProcPat              ) => #structEq(A;B)
  rule #structEqs( A:ProcPat ; B:ProcPat , C:ProcPats ) => #structEq(A;B) orBool #structEqs(A;C)

//------------------
//--- #matchComm ---
//------------------
// TODO: include 1) Binds, 2) GBinds, & 3) BoolExp???
  rule #matchComm( S:Send ;; B:Bind )
    => #nameEq(#chan(S);#chan(B)) andBool #matchif(#quotes(#msg(S));#bvar(B))
  rule #matchComm( S:Send ;; B:GBind )
    => #nameEq(#chan(S);#chan(B)) andBool #matchif(#quotes(#msg(S));#bvar(B))
       andBool #subGuard(#msg(S);#bvar(B);#guard(B))
/*
//-----------------------------
//--- Channel Relations Set ---
//-----------------------------
  rule #chanRelSet( _:SRec    ) => .Set
  rule #chanRelSet( _:SRecPat ) => .Set
  rule #chanRelSet( A:Bind & B:Bind  ) => #chanRelSet(A;;B;;0;1;0)
  rule #chanRelSet( A:Bind & B:Binds ) => #chanRelSet(A;;B;;0;1;0)
  rule #chanRelSet( A:MRec    ) => #chanRelSet( ;;#bind(A);;0;1;0) // initially check 0th bind against all others
  rule #chanRelSet( A:MRecPat ) => #chanRelSet( ;;#bind(A);;0;1;0)

  // first arg Bind is checked against other Bind(s) for channel relations
  // after checking each, throw it away and repeat for the next Bind
  // TODO: optimization oppurtunity: if #FV(#chan) = .Set, move on to next bind
    // Lbinds
  rule #chanRelSet( ;; A:Lbind &  B:Lbind  ;; I:Int ; J:Int ; L:Int ) => #chanRelSet(A;;B;;I;J;L) // only called with I=0,J=1
  rule #chanRelSet( ;; A:Lbind &  B:Lbinds ;; I:Int ; J:Int ; L:Int ) => #chanRelSet(A;;B;;I;J;L) // only called with I=0,J=1
      // Ith Bind fixed, traverse succeeding Binds
  rule #chanRelSet(    A:Lbind ;; B:Lbind  ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then .Set
       #else SetItem(I;SetItem(J)) #fi
  rule #chanRelSet( A:Lbind ;; B:Lbind & C:Lbind  ;; I:Int ; J:Int ) // think: A is the Ith bind, B is the Jth bind in original
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
  rule #chanRelSet( A:Lbind ;; B:Lbind & C:Lbinds ;; I:Int ; J:Int)
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
      // recursively generates chanRelSet for each Bind
  rule #chanRelSet( A:Lbind ;; B:Lbind ;; I:Int ; J:Int ; _:Int ) => #chanRelSet(A;;B;;I;J)
  rule #chanRelSet( A:Lbind ;; B:Lbind & C:Lbind  ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))
  rule #chanRelSet( A:Lbind ;; B:Lbind & C:Lbinds ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))
    // LbindPats
  rule #chanRelSet( ;; A:LbindPat &  B:Lbind     ;; I:Int ; J:Int ; L:Int ) => #chanRelSet(A;;B;;I;J;L)
  rule #chanRelSet( ;; A:Lbind    &  B:LbindPat  ;; I:Int ; J:Int ; L:Int ) => #chanRelSet(A;;B;;I;J;L)
  rule #chanRelSet( ;; A:LbindPat &  B:LbindPat  ;; I:Int ; J:Int ; L:Int ) => #chanRelSet(A;;B;;I;J;L)
  rule #chanRelSet( ;; A:LbindPat &  B:Lbinds    ;; I:Int ; J:Int ; L:Int ) => #chanRelSet(A;;B;;I;J;L)
  rule #chanRelSet( ;; A:Lbind    &  B:LbindPats ;; I:Int ; J:Int ; L:Int ) => #chanRelSet(A;;B;;I;J;L)
  rule #chanRelSet( ;; A:LbindPat &  B:LbindPats ;; I:Int ; J:Int ; L:Int ) => #chanRelSet(A;;B;;I;J;L)
  // Ith Bind[Pat] fixed, traverse succeeding Bind[Pat][s]
  // CRS( Bind[Pat] ;; Bind[Pat] ;; Int ; Int )
  rule #chanRelSet( A:Lbind    ;; B:LbindPat ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then .Set
       #else SetItem(I;SetItem(J)) #fi
  rule #chanRelSet( A:LbindPat ;; B:Lbind    ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then .Set
       #else SetItem(I;SetItem(J)) #fi
  rule #chanRelSet( A:LbindPat ;; B:LbindPat ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then .Set
       #else SetItem(I;SetItem(J)) #fi
  // CRS( Bind[Pat] ;; Bind[Pat]s ;; Int ; Int )
  rule #chanRelSet( A:Lbind    ;; B:LbindPat & C:Lbind     ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
  rule #chanRelSet( A:Lbind    ;; B:Lbind    & C:LbindPat  ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
  rule #chanRelSet( A:Lbind    ;; B:LbindPat & C:LbindPat  ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
  rule #chanRelSet( A:LbindPat ;; B:Lbind    & C:Lbind     ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
  rule #chanRelSet( A:LbindPat ;; B:LbindPat & C:Lbind     ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
  rule #chanRelSet( A:LbindPat ;; B:Lbind    & C:LbindPat  ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
  rule #chanRelSet( A:LbindPat ;; B:LbindPat & C:LbindPat  ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
  rule #chanRelSet( A:Lbind    ;; B:LbindPat & C:Lbinds    ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
  rule #chanRelSet( A:Lbind    ;; B:Lbind    & C:LbindPats ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
  rule #chanRelSet( A:Lbind    ;; B:LbindPat & C:LbindPats ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
  rule #chanRelSet( A:LbindPat ;; B:Lbind    & C:Lbinds    ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
  rule #chanRelSet( A:LbindPat ;; B:Lbind    & C:LbindPats ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
  rule #chanRelSet( A:LbindPat ;; B:LbindPat & C:Lbinds    ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
  rule #chanRelSet( A:LbindPat ;; B:LbindPat & C:LbindPats ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
  // recursively generates chanRelSet for each Bind[Pat]
  rule #chanRelSet( A:Lbind    ;; B:LbindPat ;; I:Int ; J:Int ; _:Int ) => #chanRelSet(A;;B;;I;J)
  rule #chanRelSet( A:LbindPat ;; B:Lbind    ;; I:Int ; J:Int ; _:Int ) => #chanRelSet(A;;B;;I;J)
  rule #chanRelSet( A:LbindPat ;; B:LbindPat ;; I:Int ; J:Int ; _:Int ) => #chanRelSet(A;;B;;I;J)
  rule #chanRelSet( A:Lbind    ;; B:LbindPat & C:Lbind     ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))
  rule #chanRelSet( A:Lbind    ;; B:Lbind    & C:LbindPat  ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))
  rule #chanRelSet( A:Lbind    ;; B:LbindPat & C:LbindPat  ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))
  rule #chanRelSet( A:LbindPat ;; B:Lbind    & C:Lbind     ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))
  rule #chanRelSet( A:LbindPat ;; B:LbindPat & C:Lbind     ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))
  rule #chanRelSet( A:LbindPat ;; B:Lbind    & C:LbindPat  ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))
  rule #chanRelSet( A:LbindPat ;; B:LbindPat & C:LbindPat  ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))
  rule #chanRelSet( A:Lbind    ;; B:LbindPat & C:Lbinds    ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))
  rule #chanRelSet( A:Lbind    ;; B:Lbind    & C:LbindPats ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))
  rule #chanRelSet( A:Lbind    ;; B:LbindPat & C:LbindPats ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))
  rule #chanRelSet( A:LbindPat ;; B:Lbind    & C:Lbinds    ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))
  rule #chanRelSet( A:LbindPat ;; B:LbindPat & C:Lbinds    ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))
  rule #chanRelSet( A:LbindPat ;; B:Lbind    & C:LbindPats    ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))
  rule #chanRelSet( A:LbindPat ;; B:LbindPat & C:LbindPats ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))

    // Pbinds
  rule #chanRelSet( ;; A:Pbind &  B:Pbind  ;; I:Int ; J:Int ; L:Int ) => #chanRelSet(A;;B;;I;J;L)
  rule #chanRelSet( ;; A:Pbind &  B:Pbinds ;; I:Int ; J:Int ; L:Int ) => #chanRelSet(A;;B;;I;J;L)
  // Ith Bind fixed, traverse succeeding Binds
  rule #chanRelSet(    A:Pbind ;; B:Pbind  ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then .Set
       #else SetItem(I;SetItem(J)) #fi
  rule #chanRelSet( A:Pbind ;; B:Pbind & C:Pbind  ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
  rule #chanRelSet( A:Pbind ;; B:Pbind & C:Pbinds ;; I:Int ; J:Int)
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
  // recursively generates chanRelSet for each Bind
  rule #chanRelSet( A:Pbind ;; B:Pbind ;; I:Int ; J:Int ; _:Int ) => #chanRelSet(A;;B;;I;J)
  rule #chanRelSet( A:Pbind ;; B:Pbind & C:Pbind  ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))
  rule #chanRelSet( A:Pbind ;; B:Pbind & C:Pbinds ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))
    // PbindPats
  rule #chanRelSet( ;; A:PbindPat &  B:Pbind     ;; I:Int ; J:Int ; L:Int ) => #chanRelSet(A;;B;;I;J;L)
  rule #chanRelSet( ;; A:Pbind    &  B:PbindPat  ;; I:Int ; J:Int ; L:Int ) => #chanRelSet(A;;B;;I;J;L)
  rule #chanRelSet( ;; A:PbindPat &  B:PbindPat  ;; I:Int ; J:Int ; L:Int ) => #chanRelSet(A;;B;;I;J;L)
  rule #chanRelSet( ;; A:PbindPat &  B:Pbinds    ;; I:Int ; J:Int ; L:Int ) => #chanRelSet(A;;B;;I;J;L)
  rule #chanRelSet( ;; A:Pbind    &  B:PbindPats ;; I:Int ; J:Int ; L:Int ) => #chanRelSet(A;;B;;I;J;L)
  rule #chanRelSet( ;; A:PbindPat &  B:PbindPats ;; I:Int ; J:Int ; L:Int ) => #chanRelSet(A;;B;;I;J;L)
  // Ith Bind[Pat] fixed, traverse succeeding Bind[Pat][s]
  // CRS( Bind[Pat] ;; Bind[Pat] ;; Int ; Int )
  rule #chanRelSet( A:Pbind    ;; B:PbindPat ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then .Set
       #else SetItem(I;SetItem(J)) #fi
  rule #chanRelSet( A:PbindPat ;; B:Pbind    ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then .Set
       #else SetItem(I;SetItem(J)) #fi
  rule #chanRelSet( A:PbindPat ;; B:PbindPat ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then .Set
       #else SetItem(I;SetItem(J)) #fi
  // CRS( Bind[Pat] ;; Bind[Pat]s ;; Int ; Int )
  rule #chanRelSet( A:Pbind    ;; B:PbindPat & C:Pbind     ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
  rule #chanRelSet( A:Pbind    ;; B:Pbind    & C:PbindPat  ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
  rule #chanRelSet( A:Pbind    ;; B:PbindPat & C:PbindPat  ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
  rule #chanRelSet( A:PbindPat ;; B:Pbind    & C:Pbind     ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
  rule #chanRelSet( A:PbindPat ;; B:PbindPat & C:Pbind     ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
  rule #chanRelSet( A:PbindPat ;; B:Pbind    & C:PbindPat  ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
  rule #chanRelSet( A:PbindPat ;; B:PbindPat & C:PbindPat  ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
  rule #chanRelSet( A:Pbind    ;; B:PbindPat & C:Pbinds    ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
  rule #chanRelSet( A:Pbind    ;; B:Pbind    & C:PbindPats ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
  rule #chanRelSet( A:Pbind    ;; B:PbindPat & C:PbindPats ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
  rule #chanRelSet( A:PbindPat ;; B:Pbind    & C:Pbinds    ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
  rule #chanRelSet( A:PbindPat ;; B:Pbind    & C:PbindPats ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
  rule #chanRelSet( A:PbindPat ;; B:PbindPat & C:Pbinds    ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
  rule #chanRelSet( A:PbindPat ;; B:PbindPat & C:PbindPats ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
  // recursively generates chanRelSet for each Bind[Pat]
  rule #chanRelSet( A:Pbind    ;; B:PbindPat ;; I:Int ; J:Int ; _:Int ) => #chanRelSet(A;;B;;I;J)
  rule #chanRelSet( A:PbindPat ;; B:Pbind    ;; I:Int ; J:Int ; _:Int ) => #chanRelSet(A;;B;;I;J)
  rule #chanRelSet( A:PbindPat ;; B:PbindPat ;; I:Int ; J:Int ; _:Int ) => #chanRelSet(A;;B;;I;J)
  rule #chanRelSet( A:Pbind    ;; B:PbindPat & C:Pbind     ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))
  rule #chanRelSet( A:Pbind    ;; B:Pbind    & C:PbindPat  ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))
  rule #chanRelSet( A:Pbind    ;; B:PbindPat & C:PbindPat  ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))
  rule #chanRelSet( A:PbindPat ;; B:Pbind    & C:Pbind     ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))
  rule #chanRelSet( A:PbindPat ;; B:PbindPat & C:Pbind     ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))
  rule #chanRelSet( A:PbindPat ;; B:Pbind    & C:PbindPat  ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))
  rule #chanRelSet( A:PbindPat ;; B:PbindPat & C:PbindPat  ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))
  rule #chanRelSet( A:Pbind    ;; B:PbindPat & C:Pbinds    ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))
  rule #chanRelSet( A:Pbind    ;; B:Pbind    & C:PbindPats ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))
  rule #chanRelSet( A:Pbind    ;; B:PbindPat & C:PbindPats ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))
  rule #chanRelSet( A:PbindPat ;; B:Pbind    & C:Pbinds    ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))
  rule #chanRelSet( A:PbindPat ;; B:PbindPat & C:Pbinds    ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))
  rule #chanRelSet( A:PbindPat ;; B:Pbind    & C:PbindPats    ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))
  rule #chanRelSet( A:PbindPat ;; B:PbindPat & C:PbindPats ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))

    // Rbinds
  rule #chanRelSet( ;; A:Rbind &  B:Rbind  ;; I:Int ; J:Int ; L:Int ) => #chanRelSet(A;;B;;I;J;L)
  rule #chanRelSet( ;; A:Rbind &  B:Rbinds ;; I:Int ; J:Int ; L:Int ) => #chanRelSet(A;;B;;I;J;L)
  // Ith Bind fixed, traverse succeeding Binds
  rule #chanRelSet(    A:Rbind ;; B:Rbind  ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then .Set
       #else SetItem(I;SetItem(J)) #fi
  rule #chanRelSet( A:Rbind ;; B:Rbind & C:Rbind  ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
  rule #chanRelSet( A:Rbind ;; B:Rbind & C:Rbinds ;; I:Int ; J:Int)
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
  // recursively generates chanRelSet for each Bind
  rule #chanRelSet( A:Rbind ;; B:Rbind ;; I:Int ; J:Int ; _:Int ) => #chanRelSet(A;;B;;I;J)
  rule #chanRelSet( A:Rbind ;; B:Rbind & C:Rbind  ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))
  rule #chanRelSet( A:Rbind ;; B:Rbind & C:Rbinds ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))
    // RbindPats
  rule #chanRelSet( ;; A:RbindPat &  B:Rbind     ;; I:Int ; J:Int ; L:Int ) => #chanRelSet(A;;B;;I;J;L)
  rule #chanRelSet( ;; A:Rbind    &  B:RbindPat  ;; I:Int ; J:Int ; L:Int ) => #chanRelSet(A;;B;;I;J;L)
  rule #chanRelSet( ;; A:RbindPat &  B:RbindPat  ;; I:Int ; J:Int ; L:Int ) => #chanRelSet(A;;B;;I;J;L)
  rule #chanRelSet( ;; A:RbindPat &  B:Rbinds    ;; I:Int ; J:Int ; L:Int ) => #chanRelSet(A;;B;;I;J;L)
  rule #chanRelSet( ;; A:Rbind    &  B:RbindPats ;; I:Int ; J:Int ; L:Int ) => #chanRelSet(A;;B;;I;J;L)
  rule #chanRelSet( ;; A:RbindPat &  B:RbindPats ;; I:Int ; J:Int ; L:Int ) => #chanRelSet(A;;B;;I;J;L)
  // Ith Bind[Pat] fixed, traverse succeeding Bind[Pat][s]
  // CRS( Bind[Pat] ;; Bind[Pat] ;; Int ; Int )
  rule #chanRelSet( A:Rbind    ;; B:RbindPat ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then .Set
       #else SetItem(I;SetItem(J)) #fi
  rule #chanRelSet( A:RbindPat ;; B:Rbind    ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then .Set
       #else SetItem(I;SetItem(J)) #fi
  rule #chanRelSet( A:RbindPat ;; B:RbindPat ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then .Set
       #else SetItem(I;SetItem(J)) #fi
  // CRS( Bind[Pat] ;; Bind[Pat]s ;; Int ; Int )
  rule #chanRelSet( A:Rbind    ;; B:RbindPat & C:Rbind     ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
  rule #chanRelSet( A:Rbind    ;; B:Rbind    & C:RbindPat  ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
  rule #chanRelSet( A:Rbind    ;; B:RbindPat & C:RbindPat  ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
  rule #chanRelSet( A:RbindPat ;; B:Rbind    & C:Rbind     ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
  rule #chanRelSet( A:RbindPat ;; B:RbindPat & C:Rbind     ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
  rule #chanRelSet( A:RbindPat ;; B:Rbind    & C:RbindPat  ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
  rule #chanRelSet( A:RbindPat ;; B:RbindPat & C:RbindPat  ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
  rule #chanRelSet( A:Rbind    ;; B:RbindPat & C:Rbinds    ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
  rule #chanRelSet( A:Rbind    ;; B:Rbind    & C:RbindPats ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
  rule #chanRelSet( A:Rbind    ;; B:RbindPat & C:RbindPats ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
  rule #chanRelSet( A:RbindPat ;; B:Rbind    & C:Rbinds    ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
  rule #chanRelSet( A:RbindPat ;; B:Rbind    & C:RbindPats ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
  rule #chanRelSet( A:RbindPat ;; B:RbindPat & C:Rbinds    ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
  rule #chanRelSet( A:RbindPat ;; B:RbindPat & C:RbindPats ;; I:Int ; J:Int )
    => #if intersectSet(#FV(#chan(A)),#FV(#chan(B))) ==K .Set
       #then #chanRelSet(A;;C;;I;J +Int 1)
       #else #unionCRS(SetItem(I;SetItem(J));#chanRelSet(A;;C;;I;J +Int 1)) #fi
  // recursively generates chanRelSet for each Bind[Pat]
  rule #chanRelSet( A:Rbind    ;; B:RbindPat ;; I:Int ; J:Int ; _:Int ) => #chanRelSet(A;;B;;I;J)
  rule #chanRelSet( A:RbindPat ;; B:Rbind    ;; I:Int ; J:Int ; _:Int ) => #chanRelSet(A;;B;;I;J)
  rule #chanRelSet( A:RbindPat ;; B:RbindPat ;; I:Int ; J:Int ; _:Int ) => #chanRelSet(A;;B;;I;J)
  rule #chanRelSet( A:Rbind    ;; B:RbindPat & C:Rbind     ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))
  rule #chanRelSet( A:Rbind    ;; B:Rbind    & C:RbindPat  ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))
  rule #chanRelSet( A:Rbind    ;; B:RbindPat & C:RbindPat  ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))
  rule #chanRelSet( A:RbindPat ;; B:Rbind    & C:Rbind     ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))
  rule #chanRelSet( A:RbindPat ;; B:RbindPat & C:Rbind     ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))
  rule #chanRelSet( A:RbindPat ;; B:Rbind    & C:RbindPat  ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))
  rule #chanRelSet( A:RbindPat ;; B:RbindPat & C:RbindPat  ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))
  rule #chanRelSet( A:Rbind    ;; B:RbindPat & C:Rbinds    ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))
  rule #chanRelSet( A:Rbind    ;; B:Rbind    & C:RbindPats ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))
  rule #chanRelSet( A:Rbind    ;; B:RbindPat & C:RbindPats ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))
  rule #chanRelSet( A:RbindPat ;; B:Rbind    & C:Rbinds    ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))
  rule #chanRelSet( A:RbindPat ;; B:RbindPat & C:Rbinds    ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))
  rule #chanRelSet( A:RbindPat ;; B:Rbind    & C:RbindPats    ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))
  rule #chanRelSet( A:RbindPat ;; B:RbindPat & C:RbindPats ;; I:Int ; J:Int ; L:Int )
    => #unionCRS(#chanRelSet(A;;B&C;;I;J);#chanRelSet(B;;C;;I +Int 1;I +Int 2;L))

// Channel relation set union
  rule #unionCRS( S:Set ;  .Set ) => S
  rule #unionCRS(  .Set ; S:Set ) => S
  rule #unionCRS( SetItem( I:Int ; .Set ) ; S:Set ) => S
  rule #unionCRS( S:Set ; SetItem( I:Int ; .Set ) ) => S
  // if indices match, union inside
  rule #unionCRS( SetItem( I:Int ; A:Set ) ; SetItem( I ; C:Set ) ) => SetItem(I;A C)
  // if indices do not match, union outside
  rule #unionCRS( SetItem( I:Int ; A:Set ) ; SetItem( J:Int ; C:Set ) D:Set ) => SetItem(I;A) SetItem(J;C) D requires I =/=Int J
*/
// TODO: add #getOrElse(RhoMap;Proc;Proc)

//---//---//---//---//---//---//---//---//---//
// Extension of ==K to Name[Pat]s & Proc[Pat]s
  rule ( A:Name    , B:Names    ) ==K ( C:Name    , D:Names    ) => A ==K C andBool B ==K D [structural]
  rule ( A:Name    , B:NamePats ) ==K ( C:Name    , D:NamePats ) => A ==K C andBool B ==K D [structural]
  rule ( A:NamePat , B:Names    ) ==K ( C:NamePat , D:Names    ) => A ==K C andBool B ==K D [structural]
  rule ( A:NamePat , B:NamePats ) ==K ( C:NamePat , D:NamePats ) => A ==K C andBool B ==K D [structural]
  rule ( A:Proc    , B:Procs    ) ==K ( C:Proc    , D:Procs    ) => A ==K C andBool B ==K D [structural]
  rule ( A:Proc    , B:ProcPats ) ==K ( C:Proc    , D:ProcPats ) => A ==K C andBool B ==K D [structural]
  rule ( A:ProcPat , B:Procs    ) ==K ( C:ProcPat , D:Procs    ) => A ==K C andBool B ==K D [structural]
  rule ( A:ProcPat , B:ProcPats ) ==K ( C:ProcPat , D:ProcPats ) => A ==K C andBool B ==K D [structural]

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
