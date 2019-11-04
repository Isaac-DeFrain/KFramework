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

  syntax        Bool ::=   "#structEq(" RhoKVPats ";" RhoKVPats ")" [function]
                       | "#structEqif(" RhoKVPats ";" RhoKVPats ")" [function]

  syntax        Bool ::=   "#structEq(" Map ";" Map ")" [function]
                       |   "#structEq(" Set ";" Set ")" [function]
                       | "#structEqif(" Map ";" Map ")" [function]
                       | "#structEqif(" Set ";" Set ")" [function]

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
  syntax        Proc ::= "#order(" Proc     ")" [function, poly(0,1)]
  syntax        Name ::= "#order(" Name     ")" [function]
  syntax     ProcPat ::= "#order(" ProcPat  ")" [function]
  syntax     NamePat ::= "#order(" NamePat  ")" [function]
  syntax    ProcPats ::= "#order(" ProcPats ")" [function]
  syntax    NamePats ::= "#order(" NamePats ")" [function]
  // RhoMap
  syntax   RhoKVPair ::= "#order(" RhoKVPair  ")" [function]
  syntax  RhoKVPairs ::= "#order(" RhoKVPairs ")" [function]
  syntax    RhoKVPat ::= "#order(" RhoKVPat   ")" [function]
  syntax   RhoKVPats ::= "#order(" RhoKVPats  ")" [function]
  // Match
  syntax   MatchCase ::= "#order(" MatchCase  ")" [function]
  syntax  MatchCases ::= "#order(" MatchCases ")" [function]
  syntax    MCasePat ::= "#order(" MCasePat   ")" [function]
  syntax   MCasePats ::= "#order(" MCasePats  ")" [function]
  // Select
  syntax      Branch ::= "#order(" Branch     ")" [function]
  syntax    Branches ::= "#order(" Branches   ")" [function]
  syntax   BranchPat ::= "#order(" BranchPat  ")" [function]
  syntax  BranchPats ::= "#order(" BranchPats ")" [function]
  // Interpolation
  syntax  InterpMaps ::= "#order(" InterpMaps ")" [function]

// Binary Ordering
  syntax        Bool ::=   "#order(" ProcPats  ";" ProcPats ")" [function]
                       |   "#order(" NamePats  ";" NamePats ")" [function]
                       | "#orderif(" ProcPats  ";" ProcPats ")" [function]
                       | "#orderif(" NamePats  ";" NamePats ")" [function]

    // RhoKVPats
  syntax        Bool ::=   "#order(" RhoKVPats ";;" RhoKVPats  ")" [function]
                       | "#orderif(" RhoKVPats ";;" RhoKVPats  ")" [function]

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

// Reordering
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

  // Binds -- TODO: add guards
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

  // BranchPats
  syntax   BranchPat ::= "#reorder(" BranchPat  ")"                                [function]
  syntax  BranchPats ::= "#reorder(" BranchPats ")"                                [function]
                       | "#reorder("           ";;"            ";;" BranchPats ")" [function]
                       | "#reorder("           ";;" BranchPats ";;" BranchPats ")" [function]
                       | "#reorder(" BranchPat ";;" BranchPats ";;" BranchPats ")" [function]
                       | "#reorder(" BranchPat ";;" BranchPats ";;"            ")" [function]
                       | "#reorder("           ";;" BranchPats ";;"            ")" [function]

// Translation to built-ins -- other half in AuxFun
  syntax        List ::= "#rho2list(" ListPat   ")" [function]
  syntax         Map ::=  "#rho2map(" ListPat   ")" [function]
                       |  "#rho2map(" MapPat    ")" [function]
                       |  "#rho2map(" TuplePat  ")" [function]
                       |  "#rho2map(" RhoKVPats ")" [function]
  syntax         Set ::=  "#rho2set(" SetPat    ")" [function]
                       |  "#rho2set(" ProcPats  ")" [function]

  // indexed
  syntax         Map ::= "#indexMap(" Int ";" ProcPats ")" [function]
  syntax         Set ::= "#indexSet(" Int ";" ProcPats ")" [function]
                       | "#indexSet(" ProcPats ")"         [function]

  // Seq inclusion: Map & Set
  syntax        Bool ::= "#SeqSetIn(" Set ";" Set ")" [function] // structural equivalence Set inclusion
                       | "#SeqMapIn(" Map ";" Map ")" [function] // structural equivalence Map inclusion

// seq of left arg against all right arg Procs
  syntax        Bool ::=    "#structEqs(" ProcPat ";" ProcPats  ")" [function]
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

// computes parSet of a Proc
  // par set of a nonPar Proc contains only one appearance of that Proc
  rule #setify( A:ProcPat ) => SetItem(1;#order(A)) requires notBool isParPat(A)
  rule #setify( A:ProcPat | B:ProcPat )
    => #if #parCount(A;B) >Int 0
       #then SetItem(1 +Int #parCount(A;B);#order(A)) (#setify(#parRemove(A;B)) -Set SetItem(1;Nil))
       #else SetItem(1;#order(A)) (#setify(B) -Set SetItem(1;Nil))
       #fi requires notBool isParPat(A)

  // Par normalization
  rule #parnorm( A:ParPat  ) => #pats2par(#reorder(#order(#par2pats(A))))
  rule #parnorm( A:ProcPat ) => A requires notBool isParPat(A)

//-------------------
//--- Unary Order ---
//-------------------
//  Returns least order term structurally equivalent to input
  // NamePats/ProcPats
  rule #order( A:NamePat , B:NamePats ) => #order(A) , #order(B)
  rule #order( A:ProcPat , B:ProcPats ) => #order(A) , #order(B)

  // RhoKVPats
  rule #order( A:ProcPat  : B:ProcPat   ) => #order(A) : #order(B)
  rule #order( A:RhoKVPat , B:RhoKVPats ) => #order(A) , #order(B)

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
  rule #order( A:RecPat ) => for(#reorder(#order(#gbind(A)))){#order(#cont(A))}
  // BindPats
  rule #order( <-  A:NamePat ) => <-  #order(A)
  rule #order( <=  A:NamePat ) => <=  #order(A)
  rule #order( <<- A:NamePat ) => <<- #order(A)
  rule #order( A:LbindPat ) => #order(#bvar(A)) <-  #order(#chan(A))
       requires notBool isEmptyLbind(A)
  rule #order( A:PbindPat ) => #order(#bvar(A)) <<- #order(#chan(A))
       requires notBool isEmptyPbind(A)
  rule #order( A:RbindPat ) => #order(#bvar(A)) <=  #order(#chan(A))
       requires notBool isEmptyRbind(A)

  rule #order( A:LbindPat & B:LbindPat  ) => #order(A) & #order(B)
  rule #order( A:LbindPat & B:LbindPats ) => #order(A) & #order(B)
  rule #order( A:PbindPat & B:PbindPat  ) => #order(A) & #order(B)
  rule #order( A:PbindPat & B:PbindPats ) => #order(A) & #order(B)
  rule #order( A:RbindPat & B:RbindPat  ) => #order(A) & #order(B)
  rule #order( A:RbindPat & B:RbindPats ) => #order(A) & #order(B)

// SendPat
  rule #order( A:NamePat !  ( ) ) => #order(A)! ( )
  rule #order( A:NamePat !! ( ) ) => #order(A)!!( )
  rule #order( A:NamePat !  ( B:ProcPats ) ) => #order(A)! ( #order(B) )
  rule #order( A:NamePat !! ( B:ProcPats ) ) => #order(A)!!( #order(B) )

// ParPat
  rule #order( A:ParPat ) => #parnorm(A)

// EvalPat
  rule #order( *A:NamePat ) => *#order(A)

// NewPat
  rule #order( new A:VarDecs in { B:ProcPat } ) => new A in { #order(B) }

// Match
  rule #order( match A:ProcPat { B:MCasePats } ) => match #order(A) { #order(B) }
  // MCasePats
  rule #order( { A:ProcPat } |=> B:ProcPat ) => { #order(A) } |=> #order(B)
  rule #order( A:MCasePat B:MCasePats ) => #order(A) #order(B)

// TODO: LetExp

// VarRef
  rule #order( A:VarRef ) => A

// CondPat
  rule #order( if ( A:BExp ) B:ProcPat ) => if ( #order(A) ) #order(B)
  rule #order( if ( A:BExp ) B:ProcPat else C:ProcPat ) => if ( #order(A) ) #order(B) else #order(C)

// ContractPat
  rule #order( contract A:NamePat (            ) = { C:ProcPat } ) => contract A (           ) = { #order(C) }
  rule #order( contract A:NamePat ( B:NamePats ) = { C:ProcPat } ) => contract A ( #order(B) ) = { #order(C) }

// InvocationPat
  rule #order( A:NamePat (  )           ) => #order(A) ( )
  rule #order( A:NamePat ( B:NamePats ) ) => #order(A) ( #order(B) )

// CollectionPat
  // ListPat
  rule #order( [ ] ) => [ ]
  rule #order( EmptyListPat ) => EmptyListPat
  rule #order( [ A:ProcPats ] ) => [ #order(A) ]
  rule #order( [ A:ProcPats ... B:ProcVar ] ) => [ #order(A) ... B ]
  rule #order( [ A:ProcPats ... B:EvalVar ] ) => [ #order(A) ... B ]
  // MapPat
  rule #order( { } ) => { }
  rule #order( EmptyMapPat ) => EmptyMapPat
  rule #order( { A:RhoKVPats } ) => { #reorder(#order(A)) }
  rule #order( { A:RhoKVPats ... B:ProcVar } ) => { #reorder(#order(A)) ... B }
  rule #order( { A:RhoKVPats ... B:EvalVar } ) => { #reorder(#order(A)) ... B }
  // SetPat
  rule #order( Set( ) ) => Set( )
  rule #order( EmptySetPat ) => EmptySetPat
  rule #order( Set( A:ProcPats ) ) => Set( #reorder(#order(A)) )
  rule #order( Set( A:ProcPats ... B:ProcVar ) ) => Set( #reorder(#order(A)) ... B )
  rule #order( Set( A:ProcPats ... B:EvalVar ) ) => Set( #reorder(#order(A)) ... B )
  // TuplePat
  rule #order( ( A:ProcPats ,) ) => ( #order(A) ,)

// AExp
  rule #order( A:AExp ) => A

// ListExp
  rule #order( A:RhoList    ++ B:ConcatRhoList ) => #order(A) ++ #order(B)
  rule #order( A:ListOrVar  ++ B:ListOrVar  ) => #order(A) ++ #order(B)
  rule #order( A:ListOrVar  ++ B:ConcatList ) => #order(A) ++ #order(B)
  rule #order( A:Invocation ++ B:ConcatList ) => #order(A) ++ #order(B)

// StringExp
  rule #order( A:StringOnlyExp ) => A
  rule #order( A:ConcatString  ) => A
  rule #order( A:StringOrVar ++ B:StringExp  ) => A ++ #order(B)
  rule #order( A:StringExp   %% B:InterpMaps ) => A %% #order(B)
  rule #order( A:RhoMap %% B:InterpMaps ) => #order(A) %% #order(B)

// BExp -- TODO: continue
  rule #order( A:BoolExp ) => A

// Select
  rule #order( select { A:BranchPats } ) => select {#reorder(A)}

// Method
  rule #order( A:ProcPat . B:Method ( )         ) => #order(A).B( )
  rule #order( A:ProcPat . B:Method ( C:Procs ) ) => #order(A).B( #order(C) )

// Bundle
  rule #order( bundle+{ A:Proc } ) => bundle+{ #order(A) }
  rule #order( bundle-{ A:Proc } ) => bundle-{ #order(A) }
  rule #order( bundle0{ A:Proc } ) => bundle0{ #order(A) }
  rule #order(  bundle{ A:Proc } ) =>  bundle{ #order(A) }

// Pure patterns -- TODO: continue
  rule #order( A:SimplePat     ) => A
  rule #order( A:SimpleNamePat ) => A

  rule #order( @A:ProcPat ) => @#order(A)
  rule #order( ~A:ProcPat ) => ~#order(A)
  rule #order(  A:ProcPat /\ B:ProcPat ) => #order(A) /\ #order(B)
  rule #order(  A:ProcPat \/ B:ProcPat ) => #order(A) \/ #order(B)

// Reorder BindPat
  rule #reorder( A:LbindPat ) => A
  rule #reorder( A:PbindPat ) => A
  rule #reorder( A:RbindPat ) => A

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

// Hierarchy:
// Nil < Bool < Int < String < Unforgeable < Uri < ProcVar < EvalVar < ...
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

  // Binds: lexicographical order by Type , length , Chans , bvars (, guard)
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

  // Collection: List < Map < Set < Tuple -- TODO: add remainder patterns
    // ListPat
  rule #order( _:ListPat ; A:CollectionPat ) => true  requires notBool isListPat(A)
  rule #order( A:CollectionPat ; _:ListPat ) => false requires notBool isListPat(A)
  rule #order( [ ] ; A:ListPat ) => true
  rule #order( A:ListPat ; [ ] ) => false requires notBool isEmptyList(A)
  rule #order( [ A:ProcPats ] ; [ B:ProcPats ] ) => #orderif(A;B)
    // MapPat
  rule #order( _:MapPat ; A:CollectionPat ) => true
       requires notBool (isListPat(A) orBool isMapPat(A))
  rule #order( A:CollectionPat ; _:MapPat ) => false
       requires notBool (isListPat(A) orBool isMapPat(A))
  rule #order( { } ; A:MapPat ) => true
  rule #order( A:MapPat ; { } ) => false requires notBool isEmptyMap(A)
  rule #order( { A:RhoKVPats } ; { B:RhoKVPats } ) => #orderif(A;;B)
    // RhoKVPairs
  rule #order( A:ProcPat : B:ProcPat ;; C:ProcPat : D:ProcPat )
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

// TODO: Set, Tuple

// TODO
  // MethodProc: Proc . Method ( Args ) dictionary order by Method , Args , Proc
  // Exp: BExp < AExp <StringExp
  // Matching: dictionary order by # of MatchCases, Proc, MatchCases
  // Contract: dictionary order by Chan , NamePat
  // Bundle:  < 0 < - < + and #order(Proc;Proc)
  // Conditional: dictionary order by BExp , then Proc [, else Proc]

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

// TODO: BranchPats -- lexicographical order by Bind , (guard ,) continuation


// Reorder
  // check order of left arg against all middle args and insert,
  // then move the head of the right arg list to the left arg and repeat
  // once only middle args remain, return

  //--- ProcPats ---
  rule #reorder( A:ParPat ) => #parnorm(A)

    // #reorder( ProcPat[s] )
  rule #reorder( A:ProcPat  ) => A requires notBool isParPat(A)
  rule #reorder( A:ProcPats ) => #reorder( ;; ;;A) requires notBool isProcPat(A)

    // #reorder( ;; ;; ProcPats )
  rule #reorder( ;; ;; A:ProcPat , B:ProcPats ) => #reorder( ;;A;;B)

    // #reorder( ;; ProcPats ;; )
  rule #reorder( ;; A:ProcPats ;;  ) => A

    // #reorder( ;; ProcPat[s] ;; ProcPat[s] )
  rule #reorder( ;; A:ProcPat              ;; B:ProcPat              ) => #reorder(B;;A  ;; )
  rule #reorder( ;; A:ProcPat              ;; B:ProcPat , C:ProcPats ) => #reorder(B;;A  ;;C)
  rule #reorder( ;; A:ProcPat , B:ProcPats ;; C:ProcPat              ) => #reorder(C;;A,B;; )
  rule #reorder( ;; A:ProcPat , B:ProcPats ;; C:ProcPat , D:ProcPats ) => #reorder(C;;A,B;;D)

    // #reorder( ProcPat ;; ProcPat[s] ;; )
  rule #reorder( A:ProcPat ;; B:ProcPat ;; ) => #if #order(A;B) #then A,B #else B,A #fi
  rule #reorder( A:ProcPat ;; B:ProcPat , C:ProcPats ;; ) => #if #order(A;B)
                                                             #then #append(A;B,C)
                                                             #else #append(B;#reorder(A;;C;; )) #fi

    // #reorder( ProcPat ;; ProcPat[s] ;; ProcPat[s] )
  rule #reorder( A:ProcPat ;; B:ProcPat  ;; C:ProcPat              ) => #reorder(C;;#reorder(A;;B;; );; )
  rule #reorder( A:ProcPat ;; B:ProcPat  ;; C:ProcPat , D:ProcPats ) => #reorder(C;;#reorder(A;;B;; );;D)
  rule #reorder( A:ProcPat ;; B:ProcPats ;; C:ProcPat              ) => #reorder(C;;#reorder(A;;B;; );; )
  rule #reorder( A:ProcPat ;; B:ProcPats ;; C:ProcPat , D:ProcPats ) => #reorder(C;;#reorder(A;;B;; );;D)

  //--- NamePats ---
    // #reorder( NamePat[s] )
  rule #reorder( A:NamePat  ) => A
  rule #reorder( A:NamePats ) => #reorder( ;; ;;A) requires notBool isNamePat(A)

    // #reorder( ;; ;; NamePats )
  rule #reorder( ;; ;; A:NamePat , B:NamePats ) => #reorder( ;;A;;B)

    // #reorder( ;; NamePats ;; )
  rule #reorder( ;; A:NamePats ;;  ) => A

    // #reorder( ;; NamePat[s] ;; NamePat[s] )
  rule #reorder( ;; A:NamePat              ;; B:NamePat              ) => #reorder(B;;A  ;; )
  rule #reorder( ;; A:NamePat              ;; B:NamePat , C:NamePats ) => #reorder(B;;A  ;;C)
  rule #reorder( ;; A:NamePat , B:NamePats ;; C:NamePat              ) => #reorder(C;;A,B;; )
  rule #reorder( ;; A:NamePat , B:NamePats ;; C:NamePat , D:NamePats ) => #reorder(C;;A,B;;D)

    // #reorder( NamePat ;; NamePat[s] ;; )
  rule #reorder( A:NamePat ;; B:NamePat ;; ) => #if #order(A;B) #then A,B #else B,A #fi
  rule #reorder( A:NamePat ;; B:NamePat , C:NamePats ;; ) => #if #order(A;B)
                                                             #then #append(A;B,C)
                                                             #else #append(B;#reorder(A;;C;; )) #fi

    // #reorder( NamePat ;; NamePat[s] ;; NamePat[s] )
  rule #reorder( A:NamePat ;; B:NamePat  ;; C:NamePat              ) => #reorder(C;;#reorder(A;;B;; );; )
  rule #reorder( A:NamePat ;; B:NamePat  ;; C:NamePat , D:NamePats ) => #reorder(C;;#reorder(A;;B;; );;D)
  rule #reorder( A:NamePat ;; B:NamePats ;; C:NamePat              ) => #reorder(C;;#reorder(A;;B;; );; )
  rule #reorder( A:NamePat ;; B:NamePats ;; C:NamePat , D:NamePats ) => #reorder(C;;#reorder(A;;B;; );;D)

  // BindPats
    // Guarded
  rule #reorder( A:GLbindPat  ) => A
  rule #reorder( A:GLbindPats ) => A
  rule #reorder( A:GPbindPat  ) => A
  rule #reorder( A:GPbindPats ) => A
  rule #reorder( A:GRbindPat  ) => A
  rule #reorder( A:GRbindPats ) => A

    // LbindPats
    // #reorder( LbindPat[s] )
  rule #reorder( A:LbindPat  ) => A
  rule #reorder( A:LbindPats ) => #reorder( ;; ;;A)

    // #reorder( ;; ;; LbindPats )
  rule #reorder( ;; ;; A:LbindPat & B:LbindPat  ) => #reorder( ;;A;;B)
  rule #reorder( ;; ;; A:LbindPat & B:LbindPats ) => #reorder( ;;A;;B)

    // #reorder( ;; LbindPats ;; )
  rule #reorder( ;; A:LbindPats ;;  ) => A

    // #reorder( ;; LbindPat[s] ;; LbindPat[s] )
  rule #reorder( ;; A:LbindPat  ;; B:LbindPat               ) => #reorder(B;;A;; )
  rule #reorder( ;; A:LbindPat  ;; B:LbindPat & C:LbindPat  ) => #reorder(B;;A;;C)
  rule #reorder( ;; A:LbindPat  ;; B:LbindPat & C:LbindPats ) => #reorder(B;;A;;C)
  rule #reorder( ;; A:LbindPats ;; C:LbindPat               ) => #reorder(C;;A;; )
  rule #reorder( ;; A:LbindPats ;; C:LbindPat & D:LbindPat  ) => #reorder(C;;A;;D)
  rule #reorder( ;; A:LbindPats ;; C:LbindPat & D:LbindPats ) => #reorder(C;;A;;D)

    // #reorder( LbindPat ;; LbindPat[s] ;; )
  rule #reorder( A:LbindPat ;; B:LbindPat ;; )
    => #if #order(A;;B) #then A&B #else B&A #fi
  rule #reorder( A:LbindPat ;; B:LbindPat & C:LbindPat  ;; )
    => #if #order(A;;B)
       #then #append(A;;B&C)
       #else #append(B;;#reorder(A;;C;; )) #fi
  rule #reorder( A:LbindPat ;; B:LbindPat & C:LbindPats ;; )
    => #if #order(A;;B)
       #then #append(A;;B&C)
       #else #append(B;;#reorder(A;;C;; )) #fi

    // #reorder( LbindPat ;; LbindPat[s] ;; LbindPat[s] )
  rule #reorder( A:LbindPat ;; B:LbindPat  ;; C:LbindPat               ) => #reorder(C;;#reorder(A;;B;; );; )
  rule #reorder( A:LbindPat ;; B:LbindPat  ;; C:LbindPat & D:LbindPat  ) => #reorder(C;;#reorder(A;;B;; );;D)
  rule #reorder( A:LbindPat ;; B:LbindPat  ;; C:LbindPat & D:LbindPats ) => #reorder(C;;#reorder(A;;B;; );;D)
  rule #reorder( A:LbindPat ;; B:LbindPats ;; C:LbindPat               ) => #reorder(C;;#reorder(A;;B;; );; )
  rule #reorder( A:LbindPat ;; B:LbindPats ;; C:LbindPat & D:LbindPat  ) => #reorder(C;;#reorder(A;;B;; );;D)
  rule #reorder( A:LbindPat ;; B:LbindPats ;; C:LbindPat & D:LbindPats ) => #reorder(C;;#reorder(A;;B;; );;D)

    // PbindPats
    // #reorder( PbindPat[s] )
  rule #reorder( A:PbindPat  ) => A
  rule #reorder( A:PbindPats ) => #reorder( ;; ;;A)

    // #reorder( ;; ;; PbindPats )
  rule #reorder( ;; ;; A:PbindPat & B:PbindPat  ) => #reorder( ;;A;;B)
  rule #reorder( ;; ;; A:PbindPat & B:PbindPats ) => #reorder( ;;A;;B)

    // #reorder( ;; PbindPats ;; )
  rule #reorder( ;; A:PbindPats ;;  ) => A

    // #reorder( ;; PbindPat[s] ;; PbindPat[s] )
  rule #reorder( ;; A:PbindPat  ;; B:PbindPat               ) => #reorder(B;;A;; )
  rule #reorder( ;; A:PbindPat  ;; B:PbindPat & C:PbindPat  ) => #reorder(B;;A;;C)
  rule #reorder( ;; A:PbindPat  ;; B:PbindPat & C:PbindPats ) => #reorder(B;;A;;C)
  rule #reorder( ;; A:PbindPats ;; C:PbindPat               ) => #reorder(C;;A;; )
  rule #reorder( ;; A:PbindPats ;; C:PbindPat & D:PbindPat  ) => #reorder(C;;A;;D)
  rule #reorder( ;; A:PbindPats ;; C:PbindPat & D:PbindPats ) => #reorder(C;;A;;D)

    // #reorder( PbindPat ;; PbindPat[s] ;; )
  rule #reorder( A:PbindPat ;; B:PbindPat ;; )
    => #if #order(A;;B) #then A&B #else B&A #fi
  rule #reorder( A:PbindPat ;; B:PbindPat & C:PbindPat  ;; )
    => #if #order(A;;B)
       #then #append(A;;B&C)
       #else #append(B;;#reorder(A;;C;; )) #fi
  rule #reorder( A:PbindPat ;; B:PbindPat & C:PbindPats ;; )
    => #if #order(A;;B)
       #then #append(A;;B&C)
       #else #append(B;;#reorder(A;;C;; )) #fi

    // #reorder( PbindPat ;; PbindPat[s] ;; PbindPat[s] )
  rule #reorder( A:PbindPat ;; B:PbindPat  ;; C:PbindPat               ) => #reorder(C;;#reorder(A;;B;; );; )
  rule #reorder( A:PbindPat ;; B:PbindPat  ;; C:PbindPat & D:PbindPat  ) => #reorder(C;;#reorder(A;;B;; );;D)
  rule #reorder( A:PbindPat ;; B:PbindPat  ;; C:PbindPat & D:PbindPats ) => #reorder(C;;#reorder(A;;B;; );;D)
  rule #reorder( A:PbindPat ;; B:PbindPats ;; C:PbindPat               ) => #reorder(C;;#reorder(A;;B;; );; )
  rule #reorder( A:PbindPat ;; B:PbindPats ;; C:PbindPat & D:PbindPat  ) => #reorder(C;;#reorder(A;;B;; );;D)
  rule #reorder( A:PbindPat ;; B:PbindPats ;; C:PbindPat & D:PbindPats ) => #reorder(C;;#reorder(A;;B;; );;D)

    // RbindPats
    // #reorder( RbindPat[s] )
  rule #reorder( A:RbindPat  ) => A
  rule #reorder( A:RbindPats ) => #reorder( ;; ;;A)

    // #reorder( ;; ;; RbindPats )
  rule #reorder( ;; ;; A:RbindPat & B:RbindPat  ) => #reorder( ;;A;;B)
  rule #reorder( ;; ;; A:RbindPat & B:RbindPats ) => #reorder( ;;A;;B)

    // #reorder( ;; RbindPats ;; )
  rule #reorder( ;; A:RbindPats ;;  ) => A

    // #reorder( ;; RbindPat[s] ;; RbindPat[s] )
  rule #reorder( ;; A:RbindPat  ;; B:RbindPat               ) => #reorder(B;;A;; )
  rule #reorder( ;; A:RbindPat  ;; B:RbindPat & C:RbindPat  ) => #reorder(B;;A;;C)
  rule #reorder( ;; A:RbindPat  ;; B:RbindPat & C:RbindPats ) => #reorder(B;;A;;C)
  rule #reorder( ;; A:RbindPats ;; C:RbindPat               ) => #reorder(C;;A;; )
  rule #reorder( ;; A:RbindPats ;; C:RbindPat & D:RbindPat  ) => #reorder(C;;A;;D)
  rule #reorder( ;; A:RbindPats ;; C:RbindPat & D:RbindPats ) => #reorder(C;;A;;D)

    // #reorder( RbindPat ;; RbindPat[s] ;; )
  rule #reorder( A:RbindPat ;; B:RbindPat ;; )
    => #if #order(A;;B) #then A&B #else B&A #fi
  rule #reorder( A:RbindPat ;; B:RbindPat & C:RbindPat  ;; )
    => #if #order(A;;B)
       #then #append(A;;B&C)
       #else #append(B;;#reorder(A;;C;; )) #fi
  rule #reorder( A:RbindPat ;; B:RbindPat & C:RbindPats ;; )
    => #if #order(A;;B)
       #then #append(A;;B&C)
       #else #append(B;;#reorder(A;;C;; )) #fi

    // #reorder( RbindPat ;; RbindPat[s] ;; RbindPat[s] )
  rule #reorder( A:RbindPat ;; B:RbindPat  ;; C:RbindPat               ) => #reorder(C;;#reorder(A;;B;; );; )
  rule #reorder( A:RbindPat ;; B:RbindPat  ;; C:RbindPat & D:RbindPat  ) => #reorder(C;;#reorder(A;;B;; );;D)
  rule #reorder( A:RbindPat ;; B:RbindPat  ;; C:RbindPat & D:RbindPats ) => #reorder(C;;#reorder(A;;B;; );;D)
  rule #reorder( A:RbindPat ;; B:RbindPats ;; C:RbindPat               ) => #reorder(C;;#reorder(A;;B;; );; )
  rule #reorder( A:RbindPat ;; B:RbindPats ;; C:RbindPat & D:RbindPat  ) => #reorder(C;;#reorder(A;;B;; );;D)
  rule #reorder( A:RbindPat ;; B:RbindPats ;; C:RbindPat & D:RbindPats ) => #reorder(C;;#reorder(A;;B;; );;D)

  // RhoKVPats
    // #reorder( RhoKVPat[s] )
  rule #reorder( A:RhoKVPat  ) => A
  rule #reorder( A:RhoKVPats ) => #reorder( ;; ;;A) requires notBool isRhoKVPat(A)

    // #reorder( ;; ;; RhoKVPats )
  rule #reorder( ;; ;; A:RhoKVPat , B:RhoKVPats ) => #reorder( ;;A;;B)

    // #reorder( ;; RhoKVPats ;; )
  rule #reorder( ;; A:RhoKVPats ;;  ) => A

    // #reorder( ;; RhoKVPat[s] ;; RhoKVPat[s] )
  rule #reorder( ;; A:RhoKVPats ;; B:RhoKVPat               ) => #reorder(B;;A;; )
  rule #reorder( ;; A:RhoKVPats ;; B:RhoKVPat , C:RhoKVPats ) => #reorder(B;;A;;C)

    // #reorder( RhoKVPat ;; RhoKVPat[s] ;; )
  rule #reorder( A:RhoKVPat ;; B:RhoKVPat ;; )
    => #if #order(A;;B) #then A,B #else B,A #fi
  rule #reorder( A:RhoKVPat ;; B:RhoKVPat , C:RhoKVPats ;; )
    => #if #order(A;;B)
       #then #append(A;B,C)
       #else #append(B;#reorder(A;;C;; )) #fi

    // #reorder( RhoKVPat ;; RhoKVPat[s] ;; RhoKVPat[s] )
  rule #reorder( A:RhoKVPat ;; B:RhoKVPats ;; C:RhoKVPat               ) => #reorder(C;;#reorder(A;;B;; );; )
  rule #reorder( A:RhoKVPat ;; B:RhoKVPats ;; C:RhoKVPat , D:RhoKVPats ) => #reorder(C;;#reorder(A;;B;; );;D)

// TODO: BranchPats

//------------------------------
//--- Structural Equivalence ---
//------------------------------
  rule #structEq( A:ProcPat ; A ) => true

  // indexes arguments & checks par set equality -- Note: at least one arg is a Par
  // #setify turns nonPar Proc P into the one element set: SetItem(P  , 1)
  // #setify turns Par P1 | ... | PM into the indexed set: SetItem(P1 , n1) ... SetItem(PM,)
  rule #structEq( A:ProcPat ; B:ProcPat ) => #setify(#deBruijn(A)) ==K #setify(#deBruijn(B))
       requires isParPat(A) orBool isParPat(B)
  rule #structEq( A:ProcPat , B:ProcPats ; C:ProcPat , D:ProcPats ) => #structEq(A;C) andBool #structEq(B;D)

  // if length is not the same, two Proc lists cannot be structurally equivalent
  rule #structEqif( A:Procs    ; B:Procs    ) => #length(A) ==Int #length(B) andBool #structEq(A;B)
  rule #structEqif( A:ProcPats ; B:ProcPats ) => #length(A) ==Int #length(B) andBool #structEq(A;B)
       requires notBool (isProcs(A) andBool isProcs(B))
  rule #structEqif( A:Procs    ; B:ProcPats ) => false requires notBool isProcs(B)
  rule #structEqif( A:ProcPats ; B:Procs    ) => false requires notBool isProcs(A)

  rule #structEqif( A:RhoKVPats ; B:RhoKVPats ) => #length(A) ==Int #length(B) andBool #structEq(A;B)

// SimplePat
  rule #structEq( Bool        ; Bool        ) => true
  rule #structEq( Int         ; Int         ) => true
  rule #structEq( String      ; String      ) => true
  rule #structEq( Unit        ; Unit        ) => true
  rule #structEq( Uri         ; Uri         ) => true
  rule #structEq( Unforgeable ; Unforgeable ) => true
  rule #structEq( A:SimplePat ; B:SimplePat ) => false [owise]
  rule #structEq( A:SimplePat ; B:ProcPat   ) => false requires notBool isSimplePat(B)
  rule #structEq( A:ProcPat   ; B:SimplePat ) => false requires notBool isSimplePat(A)

// Ground
  rule #structEq( A:Ground ; B:Ground ) => A ==K B
  rule #structEq( _:Ground ; B:Proc   ) => false requires notBool isGround(B)
  rule #structEq( A:Proc   ; _:Ground ) => false requires notBool isGround(A)

// Send
  rule #structEq( A:SendPat ; B:SendPat ) => #stype(A) ==Int #stype(B) andBool
       #nameEq(#chan(A);#chan(B)) andBool #structEqif(#msg(A);#msg(B))
  rule #structEq( A:ProcPat ; _:SendPat ) => false requires notBool (isSendPat(A) orBool isParPat(A))
  rule #structEq( _:SendPat ; A:ProcPat ) => false requires notBool (isSendPat(A) orBool isParPat(A))

// Receive -- checks equivalence of listening variables, channels, (Guard), and continuations
  // UGSRec
  rule #structEq( A:UGSRecPat ; B:UGSRecPat ) => #rtype(A) ==Int #rtype(B) andBool  //same receive type
       #nameEqif(#bvar(A);#bvar(B)) andBool #nameEq(#chan(A);#chan(B)) andBool  //same listening variable & channel types
       #structEq(#sub(#mapify(0,0;#bvar(A));#cont(A));#sub(#mapify(0,0;#bvar(A));#sub(#bvar(A);#bvar(B);#cont(B))))
  // GSRec
  rule #structEq( A:GSRecPat ; B:GSRecPat ) => #rtype(A) ==Int #rtype(B) andBool
       #nameEqif(#bvar(A);#bvar(B)) andBool #nameEq(#chan(A);#chan(B)) andBool
       #structEq(#sub(#mapify(0,0;#bvar(A));#guard(A));#sub(#mapify(0,0;#bvar(A));#sub(#bvar(A);#bvar(B);#guard(B)))) andBool
       #structEq(#sub(#mapify(0,0;#bvar(A));#cont(A));#sub(#mapify(0,0;#bvar(A));#sub(#bvar(A);#bvar(B);#cont(B))))

  // UGMRec -- TODO
  // GMRec -- TODO
// Contract -- TODO
// Invocation -- TODO

// EvalPat
  rule #structEq( *A:NamePat ; *B:NamePat ) => #nameEq(A;B)

// ProcVar
  rule #structEq( A:ProcVar ; B:ProcVar ) => A ==K B
  rule #structEq( _:ProcVar ; A:Proc    ) => false requires notBool isProcVar(A)
  rule #structEq( A:Proc    ; _:ProcVar ) => false requires notBool isProcVar(A)

// NewPat -- TODO
// VarRef -- TODO
// TypedProc -- TODO
// MethodPat -- TODO
// MatchPat -- TODO
// SelectPat -- TODO
// ConditionalPat -- TODO

// Collection
  // RhoList
  rule #structEq( A:ListPat ; B:ListPat ) => #structEqif(#rho2map(A);#rho2map(B))
       requires notBool (isListRemPat(A) andBool isListRemPat(B))
  rule #structEq( [ A:ProcPats ... _:ProcVar ] ; [ B:ProcPats ... _:ProcVar ] ) => #structEqif(A;B)
  rule #structEq( [ A:ProcPats ... _:EvalVar ] ; [ B:ProcPats ... _:EvalVar ] ) => #structEqif(A;B)
  rule #structEq( [ A:ProcPats ... _:ProcVar ] ; [ B:ProcPats ... _:EvalVar ] ) => #structEqif(A;B)
  rule #structEq( [ A:ProcPats ... _:EvalVar ] ; [ B:ProcPats ... _:ProcVar ] ) => #structEqif(A;B)
  rule #structEq(   A:ProcPat ; _:ListPat ) => false requires notBool isListPat(A)
  rule #structEq(   _:ListPat ; A:ProcPat ) => false requires notBool isListPat(A)
  // RhoMap
  rule #structEq( A:MapPat ; B:MapPat ) => #structEq(#rho2map(A);#rho2map(B))
       requires notBool (isMapRemPat(A) andBool isMapRemPat(B))
  rule #structEq( { A:RhoKVPats ... _:ProcVar } ; { B:RhoKVPats ... _:ProcVar } ) => #structEqif(A;B)
  rule #structEq( { A:RhoKVPats ... _:EvalVar } ; { B:RhoKVPats ... _:EvalVar } ) => #structEqif(A;B)
  rule #structEq( { A:RhoKVPats ... _:ProcVar } ; { B:RhoKVPats ... _:EvalVar } ) => #structEqif(A;B)
  rule #structEq( { A:RhoKVPats ... _:EvalVar } ; { B:RhoKVPats ... _:ProcVar } ) => #structEqif(A;B)
  rule #structEq( A:ProcPat ; _:MapPat  ) => false requires notBool isMapPat(A)
  rule #structEq( _:MapPat  ; A:ProcPat ) => false requires notBool isMapPat(A)
    // RhoKVPats
  rule #structEq( A:ProcPat  : B:ProcPat   ; C:ProcPat  : D:ProcPat   ) => #structEq(A;C) andBool #structEq(B;D)
  rule #structEq( A:RhoKVPat , B:RhoKVPats ; C:RhoKVPat , D:RhoKVPats ) => #structEq(A;C) andBool #structEq(B;D)
  // RhoSet
  rule #structEq( A:SetPat ; B:SetPat ) => #structEq(#rho2set(A);#rho2set(B))
       requires notBool (isSetRemPat(A) andBool isSetRemPat(B))
  rule #structEq( Set( A:ProcPats ... _:ProcVar ) ; Set( B:ProcPats ... _:ProcVar ) ) => #structEqif(A;B)
  rule #structEq( Set( A:ProcPats ... _:EvalVar ) ; Set( B:ProcPats ... _:EvalVar ) ) => #structEqif(A;B)
  rule #structEq( Set( A:ProcPats ... _:ProcVar ) ; Set( B:ProcPats ... _:EvalVar ) ) => #structEqif(A;B)
  rule #structEq( Set( A:ProcPats ... _:EvalVar ) ; Set( B:ProcPats ... _:ProcVar ) ) => #structEqif(A;B)
  rule #structEq( A:ProcPat ; _:SetPat  ) => false requires notBool isSetPat(A)
  rule #structEq( _:SetPat  ; A:ProcPat ) => false requires notBool isSetPat(A)
  // RhoTuple
  rule #structEq( ( A:ProcPats ,) ; ( B:ProcPats ,) ) => #structEqif(A;B)
  rule #structEq(   A:ProcPat     ;   _:TuplePat    ) => false requires notBool isTuplePat(A)
  rule #structEq(   _:TuplePat    ;   A:ProcPat     ) => false requires notBool isTuplePat(A)

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
  rule #structEqif( A:Set ; B:Set ) => size(A) ==Int size(B) andBool #structEq(A;B)
  rule #structEqif( A:Map ; B:Map ) => size(A) ==Int size(B) andBool #structEq(A;B)

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
  rule #SeqSetIn( SetItem( A:ProcPat ) S:Set ; T:Set )
    => #SeqSetIn( SetItem(A);T) andBool #SeqSetIn(S;T)
       requires S =/=K .Set andBool T =/=K .Set

  // #SeqSetIn( {e} ; {e'} T:Set ) => #SeqSetIn({e};{e'}) or #SeqSetIn({e};T)
  // left arg Set element is contained in right arg Set if there's at least one struct equiv right arg Set element
  // or-brach over right arg Set elements:
  rule #SeqSetIn( SetItem( A:ProcPat ) ; SetItem( B:ProcPat ) T:Set )
    => #SeqSetIn(SetItem(A);SetItem(B)) orBool #SeqSetIn(SetItem(A);T)
       requires T =/=K .Set
  rule #SeqSetIn( SetItem( A:ProcPat ) ; SetItem( B:ProcPat ) ) => #structEq(A;B)

// Structural equivalence Map inclusion
  // left arg empty Map
  rule #SeqMapIn(  .Map ; _:Map ) => true
  // right arg empty Map
  rule #SeqMapIn( A:Map ;  .Map ) => false requires A =/=K .Map
// TODO: normalize each element so this can become syntactic equality
  rule #SeqMapIn( A:ProcPat |-> B:ProcPat M:Map ; N:Map )
    => #SeqMapIn( A |-> B;N) andBool #SeqMapIn(M;N)
       requires M =/=K .Map andBool N =/=K .Map
  rule #SeqMapIn( A:ProcPat |-> B:ProcPat ; C:ProcPat |-> D:ProcPat N:Map ) // struct equiv of keys and values
    => #SeqMapIn(A|->B;C|->D) orBool #SeqMapIn(A|->B;N)
       requires N =/=K .Map
  rule #SeqMapIn( A:ProcPat |-> B:ProcPat ; C:ProcPat |-> D:ProcPat ) => #structEq(A;C) andBool #structEq(B;D)

//------------------------
//--- Name Equivalence ---
//------------------------
// Name equivalence == symmetric name matching
  rule #nameEq( A:NamePat ; A ) => true

// Name variables
  rule #nameEq( A:Var  ; B:Var  ) => A ==K B
  rule #nameEq( A:Var  ; B:Name ) => false requires notBool isVar(B)
  rule #nameEq( A:Name ; B:Var  ) => false requires notBool isVar(A)

// Typed name variable
  rule #nameEq( A:Name :: B:NamePat ; C:Name :: D:NamePat ) => #nameEq(A;C) andBool #nameEq(B;D)

// Quote
  rule #nameEq( @A:ProcPat ; @B:ProcPat ) => #structEq(A;B)
  rule #nameEq( @A:ProcPat ;  B:NamePat ) => false requires notBool isQuotePat(B)
  rule #nameEq(  A:NamePat ; @B:ProcPat ) => false requires notBool isQuotePat(A)

  // several Names
  rule #nameEq( A:NamePat , B:NamePats ; C:NamePat , D:NamePats ) => #nameEq(A;C) andBool #nameEq(B;D)
  // check length first
  rule #nameEqif( A:NamePats ; B:NamePats ) => #length(A) ==Int #length(B) andBool #nameEq(A;B)

//-----------------
//--- Built-ins ---
//-----------------
// #rho2list -- throws [Error] Internal: Uncaught exception thrown of type AssertionError.
// direct RhoList to List translation
  rule #rho2list( [ ] ) => .List
  rule #rho2list( EmptyListPat ) => .List
  rule #rho2list( [ A:ProcPat ] ) => ListItem(A)
  rule #rho2list( [ A:ProcPat , B:ProcPats ] ) => ListItem(A) #rho2list([B])

// #rho2map
  // RhoList -- produces Map with position keys
  rule #rho2map( [ ] ) => .Map
  rule #rho2map( EmptyListPat ) => .Map
  rule #rho2map( [ A:ProcPats ] ) => #indexMap(0;A)
  rule #indexMap( I:Int ; A:ProcPat ) => I |-> A
  rule #indexMap( I:Int ; A:ProcPat , B:ProcPats ) => I |-> A #indexMap(I +Int 1;B)

  // RhoTuple -- produces Map with position keys
  rule #rho2map( ( A:ProcPats ,) ) => #indexMap(0;A)

  // RhoMap -- produces Map with a unique key-value pair for each structurally equivalent key
  rule #rho2map( { } ) => .Map
  rule #rho2map( EmptyMapPat ) => .Map
  rule #rho2map( { A:ProcPat : B:ProcPat } ) => A |-> B
  rule #rho2map( { A:ProcPat : B:ProcPat , C:RhoKVPats } )
    => #if isProcVar(A) orBool isEvalVar(A)
       #then A |-> B #rho2map(C)
       #else #if #key_structEq(A;C)
             #then #rho2map(C)
             #else A |-> B #rho2map(C) #fi #fi

  // RhoKVPats
  rule #rho2map( A:ProcPat : B:ProcPat ) => A |-> B
  rule #rho2map( A:ProcPat : B:ProcPat , C:RhoKVPats )
    => #if isProcVar(A) orBool isEvalVar(A)
       #then A |-> B #rho2map(C)
       #else #if #key_structEq(A;C)
             #then #rho2map(C)
             #else A |-> B #rho2map(C) #fi #fi

// #rho2set
  // SetPat
  rule #rho2set( Set( ) ) => .Set
  rule #rho2set( EmptySetPat ) => .Set
  rule #rho2set( Set( A:ProcPat ) ) => SetItem(A)
  rule #rho2set( Set( A:ProcPat , B:ProcPats ) )
    => #if isProcVar(A) orBool isEvalVar(A)
       #then SetItem(A) #rho2set(B)
       #else #if #structEqs(A;B)
             #then #rho2set(B)
             #else SetItem(A) #rho2set(B) #fi #fi

  // ProcPats
  rule #rho2set( A:ProcPat ) => SetItem(A)
  rule #rho2set( A:ProcPat , B:ProcPats )
    => #if isProcVar(A) orBool isEvalVar(A)
       #then SetItem(A) #rho2set(B)
       #else #if #structEqs(A;B)
             #then #rho2set(B)
             #else SetItem(A) #rho2set(B) #fi #fi

  rule #indexSet( A:ProcPats ) => #indexSet(0;A)
  rule #indexSet( I:Int ; A:ProcPat ) => SetItem(I;A)
  rule #indexSet( I:Int ; A:ProcPat , B:ProcPats ) => SetItem(I;A) #indexSet(I +Int 1;B)

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

// TODO: add #getOrElse(RhoMap;Proc;Proc)

//---//---//---//---//---//---//---//---//---//
// Extension of ==K to NamePats & ProcPats
  rule ( A:NamePat , B:NamePats ) ==K ( C:NamePat , D:NamePats ) => A ==K C andBool B ==K D [structural]
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
