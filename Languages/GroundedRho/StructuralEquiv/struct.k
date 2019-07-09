// Structural & Name Equivalence for Rholang

/*
TODO:
 - NonPar Proc
 - #structEq(ConSend;ConSend), #structEq(UnconSend;UnconSend)
 - Patterns
 - Normalize before checking structural equiv (then notBool isPar(...) and notBool isEval(...) can be removed)
*/

require "../grho.k"
require "../AlphaEquiv/alpha.k"

module STRUCT-SYNTAX
  import DOMAINS
  import GRHO-SYNTAX

// Structural equivalence relation
  syntax        Bool ::=   "#structEq(" Procs    ";" Procs    ")" [function]
                       |   "#structEq(" ProcPat  ";" ProcPat  ")" [function]
                       |   "#structEq(" ProcPats ";" ProcPats ")" [function]
                       | "#structEqif(" Procs    ";" Procs    ")" [function]
                       | "#structEqif(" ProcPats ";" ProcPats ")" [function]

  syntax        Bool ::=   "#structEq(" Map ";" Map ")" [function]
                       |   "#structEq(" Set ";" Set ")" [function]
                       | "#structEqif(" Map ";" Map ")" [function]
                       | "#structEqif(" Set ";" Set ")" [function]

  syntax        Bool ::= "#structEq(" RhoKVPairs ";" RhoKVPairs ")" [function]
  syntax        Bool ::= "#structEq(" RhoKVPats  ";" RhoKVPats  ")" [function]

// Name equivalence relation
  syntax        Bool ::=   "#nameEq(" Names    ";" Names    ")" [function]
                       |   "#nameEq(" NamePat  ";" NamePat  ")" [function]
                       |   "#nameEq(" NamePats ";" NamePats ")" [function]
                       | "#nameEqif(" Names    ";" Names    ")" [function]
                       | "#nameEqif(" NamePats ";" NamePats ")" [function]

// Normalization functions
  syntax         Int ::=  "#parCount(" Proc ";" Proc  ")" [function]
  syntax        Proc ::= "#parRemove(" Proc ";" Proc  ")" [function]
                       | "#removeNil(" Proc ")"           [function]
                       |   "#parnorm(" Proc ")"           [function]
  syntax         Set ::=    "#setify(" Proc ")"           [function]

// Unary Ordering
  syntax        Proc ::= "#order(" Proc ")" [function]
  syntax        Name ::= "#order(" Name ")" [function]

  syntax       Procs ::=     "#order(" Procs ")" [function]
                       | "#orderEach(" Procs ")" [function]
  syntax       Names ::=     "#order(" Names ")" [function]
                       | "#orderEach(" Names ")" [function]

  syntax   RhoKVPair ::= "#order(" RhoKVPair ")" [function]

  syntax  RhoKVPairs ::=     "#order(" RhoKVPairs ")" [function]
                       | "#orderEach(" RhoKVPairs ")" [function]

// Binary Ordering
  syntax        Bool ::=   "#order(" Procs  ";" Procs ")" [function]
                       |   "#order(" Names  ";" Names ")" [function]
                       | "#orderif(" Procs  ";" Procs ")" [function]
                       | "#orderif(" Names  ";" Names ")" [function]

  // subexpression ordering
    // Binds
  syntax        Bool ::=   "#order(" Bind  ";;" Bind  ")" [function]
                       |   "#order(" Bind  ";;" Binds ")" [function]
                       |   "#order(" Binds ";;" Bind  ")" [function]
                       |   "#order(" Binds ";;" Binds ")" [function]
                       | "#orderif(" Binds ";;" Binds ")" [function]
    // RhoKVPairs
  syntax        Bool ::=   "#order(" RhoKVPairs ";;" RhoKVPairs ")" [function]
                       | "#orderif(" RhoKVPairs ";;" RhoKVPairs ")" [function]
    // RhoKVPats
//syntax        Bool ::=   "#order(" RhoKVPats  ";" RhoKVPats  ")" [function]
//                     | "#orderif(" RhoKVPats  ";" RhoKVPats  ")" [function]

// Reordering
  syntax        Proc ::= "#reorder(" Proc  ")"                      [function]
  syntax       Procs ::= "#reorder(" Procs ")"                      [function]
                       | "#reorder("      ";;"       ";;" Procs ")" [function]
                       | "#reorder("      ";;" Procs ";;" Procs ")" [function]
                       | "#reorder(" Proc ";;" Procs ";;" Procs ")" [function]
                       | "#reorder(" Proc ";;" Procs ";;"       ")" [function]
                       | "#reorder("      ";;" Procs ";;"       ")" [function]

  syntax        Name ::= "#reorder(" Name  ")"                      [function]
  syntax       Names ::= "#reorder(" Names ")"                      [function]
                       | "#reorder("      ";;"       ";;" Names ")" [function]
                       | "#reorder("      ";;" Names ";;" Names ")" [function]
                       | "#reorder(" Name ";;" Names ";;" Names ")" [function]
                       | "#reorder(" Name ";;" Names ";;"       ")" [function]
                       | "#reorder("      ";;" Names ";;"       ")" [function]

  // Binds
  syntax       Lbind ::= "#reorder(" Lbind  ")"                        [function]
  syntax      Lbinds ::= "#reorder(" Lbinds ")"                        [function]
                       | "#reorder("       ";;"        ";;" Lbinds ")" [function]
                       | "#reorder("       ";;" Lbind  ";;" Lbind  ")" [function]
                       | "#reorder("       ";;" Lbind  ";;" Lbinds ")" [function]
                       | "#reorder("       ";;" Lbinds ";;" Lbind  ")" [function]
                       | "#reorder("       ";;" Lbinds ";;" Lbinds ")" [function]
                       | "#reorder(" Lbind ";;" Lbind  ";;" Lbind  ")" [function]
                       | "#reorder(" Lbind ";;" Lbind  ";;" Lbinds ")" [function]
                       | "#reorder(" Lbind ";;" Lbinds ";;" Lbind  ")" [function]
                       | "#reorder(" Lbind ";;" Lbinds ";;" Lbinds ")" [function]
                       | "#reorder(" Lbind ";;" Lbind  ";;"        ")" [function]
                       | "#reorder(" Lbind ";;" Lbinds ";;"        ")" [function]
                       | "#reorder("       ";;" Lbinds ";;"        ")" [function]
  syntax       Pbind ::= "#reorder(" Pbind  ")"                        [function]
  syntax      Pbinds ::= "#reorder(" Pbinds ")"                        [function]
                       | "#reorder("       ";;"        ";;" Pbinds ")" [function]
                       | "#reorder("       ";;" Pbind  ";;" Pbind  ")" [function]
                       | "#reorder("       ";;" Pbind  ";;" Pbinds ")" [function]
                       | "#reorder("       ";;" Pbinds ";;" Pbind  ")" [function]
                       | "#reorder("       ";;" Pbinds ";;" Pbinds ")" [function]
                       | "#reorder(" Pbind ";;" Pbind  ";;" Pbind  ")" [function]
                       | "#reorder(" Pbind ";;" Pbind  ";;" Pbinds ")" [function]
                       | "#reorder(" Pbind ";;" Pbinds ";;" Pbind  ")" [function]
                       | "#reorder(" Pbind ";;" Pbinds ";;" Pbinds ")" [function]
                       | "#reorder(" Pbind ";;" Pbind  ";;"        ")" [function]
                       | "#reorder(" Pbind ";;" Pbinds ";;"        ")" [function]
                       | "#reorder("       ";;" Pbinds ";;"        ")" [function]
  syntax       Rbind ::= "#reorder(" Rbind  ")"                        [function]
  syntax      Rbinds ::= "#reorder(" Rbinds ")"                        [function]
                       | "#reorder("       ";;"        ";;" Rbinds ")" [function]
                       | "#reorder("       ";;" Rbind  ";;" Rbind  ")" [function]
                       | "#reorder("       ";;" Rbind  ";;" Rbinds ")" [function]
                       | "#reorder("       ";;" Rbinds ";;" Rbind  ")" [function]
                       | "#reorder("       ";;" Rbinds ";;" Rbinds ")" [function]
                       | "#reorder(" Rbind ";;" Rbind  ";;" Rbind  ")" [function]
                       | "#reorder(" Rbind ";;" Rbind  ";;" Rbinds ")" [function]
                       | "#reorder(" Rbind ";;" Rbinds ";;" Rbind  ")" [function]
                       | "#reorder(" Rbind ";;" Rbinds ";;" Rbinds ")" [function]
                       | "#reorder(" Rbind ";;" Rbind  ";;"        ")" [function]
                       | "#reorder(" Rbind ";;" Rbinds ";;"        ")" [function]
                       | "#reorder("       ";;" Rbinds ";;"        ")" [function]
  // RhoKVPairs
  syntax   RhoKVPair ::= "#reorder(" RhoKVPair  ")"                                [function]
  syntax  RhoKVPairs ::= "#reorder(" RhoKVPairs ")"                                [function]
                       | "#reorder("           ";;"            ";;" RhoKVPairs ")" [function]
                       | "#reorder("           ";;" RhoKVPairs ";;" RhoKVPairs ")" [function]
                       | "#reorder(" RhoKVPair ";;" RhoKVPairs ";;" RhoKVPairs ")" [function]
                       | "#reorder(" RhoKVPair ";;" RhoKVPairs ";;"            ")" [function]
                       | "#reorder("           ";;" RhoKVPairs ";;"            ")" [function]
/*
  syntax    RhoKVPat ::= "#reorder(" RhoKVPat   ")"                                [function]
  syntax   RhoKVPats ::= "#reorder(" RhoKVPats  ")"                                [function]
                       | "#reorder("           ";;"            ";;" RhoKVPats  ")" [function]
                       | "#reorder("           ";;" RhoKVPats  ";;" RhoKVPats  ")" [function]
                       | "#reorder(" RhoKVPat  ";;" RhoKVPats  ";;" RhoKVPats  ")" [function]
                       | "#reorder(" RhoKVPat  ";;" RhoKVPats  ";;"            ")" [function]
                       | "#reorder("           ";;" RhoKVPats  ";;"            ")" [function]
*/

// Translation to built-ins -- other half in AuxFun
  syntax        List ::= "#rho2list(" RhoList ")" [function]
  syntax         Map ::=  "#rho2map(" RhoMap  ")" [function]
  syntax         Set ::=  "#rho2set(" RhoSet  ")" [function]

  // Seq inclusion: Map & Set
  syntax        Bool ::= "#SeqSetIn(" Set ";" Set ")" [function] // structural equivalence Set inclusion
                       | "#SeqMapIn(" Map ";" Map ")" [function] // structural equivalence Map inclusion

// seq of left arg against all right arg Procs
  syntax        Bool ::=    "#structEqs(" Proc ";" Procs ")" [function]
// seq of left arg against all keys of RhoKVPairs
  syntax        Bool ::= "#key_structEq(" Proc ";" RhoKVPairs ")" [function]

endmodule

module STRUCT
  import STRUCT-SYNTAX
  import ALPHA

  syntax KResult ::= Proc | Procs | Name | Names | Bool | Int | List | Map | Set
                   | Lbind | Lbinds | Rbind | Pbinds | Lbind | Lbinds
                   | RhoKVPair | RhoKVPairs // | RhoKVPat | RhoKVPats

// counts number of structurally eq appearances of a nonPar Proc in a Par
// first arg intended to be nonPar, second arg is intended to be Par (enforced by #setify)
  // single Proc Par i.e. a nonPar Proc
  rule #parCount( A:Proc ; B:Proc )
    => #if #structEq(A;B) #then 1 #else 0 #fi requires notBool isPar(B)
  // multiple Proc Par
  rule #parCount( A:Proc ; B:Proc | C:Proc )
    => #if #structEq(A;B) #then 1 +Int #parCount(A;C) #else #parCount(A;C) #fi
       requires notBool isPar(B)

// traverses Par removing structurally eq nonPar Proc
// first arg intended to be nonPar, second arg is intended to be Par (enforced by #setify)
  // single Proc Par i.e. a nonPar Proc
  rule #parRemove( A:Proc ; B:Proc )
    => #if #structEq(A;B) #then Nil #else B #fi requires notBool isPar(B)
  // multiple Proc Par
  rule #parRemove( A:Proc ; B:Proc | C:Proc )
    => #if #structEq(A;B) #then #parRemove(A;C) #else B | #parRemove(A;C) #fi
       requires notBool isPar(B)

// computes par set of a Proc
  // par set of a nonPar Proc contains only one appearance of that Proc
  rule #setify(   Nil  ) => .Set
  rule #setify( A:Proc ) => SetItem(A,1) requires notBool (isPar(A) orBool A ==K Nil)
  rule #setify( A:Proc | B:Proc )
    => #if A ==K Nil
       #then #setify(B) // Nil is the unit of | -- forget about it!
       #else
         #if #parCount(A;B) >Int 0
         // remove Nil introduced by #parRemove
         #then SetItem(A,1 +Int #parCount(A;B)) #setify(#parRemove(A;B))
         #else SetItem(A,1) #setify(B)
         #fi
       #fi requires notBool isPar(A)

// #removeNil( Nil | Proc ) => Proc
  rule #removeNil( A:Proc ) => A requires notBool isPar(A) // TODO: extend to Name
  rule #removeNil( A:Proc | Nil ) => A requires notBool isPar(A)
  rule #removeNil( A:Proc | B:Proc )
    => #if A ==K Nil
       #then #removeNil(B)
       #else A | #removeNil(B) #fi
       requires notBool (isPar(A) orBool B ==K Nil)

  // Par normalization
  rule #parnorm( A:Par  ) => #procs2par(#reorder(#par2procs(#removeNil(A))))
  rule #parnorm( A:Proc ) => A requires notBool isPar(A)

//-------------------
//--- Unary Order ---
//-------------------
//  Returns least order term structurally equivalent to input

  rule #order( [ ] ) => [ ]
  rule #order( [ A:Procs ] ) => [ #orderEach(A) ]

  rule #order( { } ) => { }
  rule #order( A:RhoMap ) => { #orderEach(#map2KVs(#rho2map(A))) }

//--------------------
//--- Binary Order ---
//--------------------
//   Think of #order( A:K ; B:K ) as order(A) <= order(B)
//   for some monotone increasing function order(_): K -> Real

  // check length first
  rule #orderif( A:Procs ; B:Procs ) => #length(A) ==Int #length(B) andBool #order(A;B)
  rule #orderif( A:Names ; B:Names ) => #length(A) ==Int #length(B) andBool #order(A;B)
  rule #orderif( A:RhoKVPairs ;; B:RhoKVPairs ) => #length(A) ==Int #length(B) andBool #order(A;;B)
//  rule #orderif( A:RhoKVPats  ; B:RhoKVPats  ) => #length(A) ==Int #length(B) andBool #order(A;B)

  // Dictionary Order
  rule #order( A:Proc , B:Procs ; C:Proc , D:Procs )
    => #if #order(A;C)
       #then #if #order(C;A)
             #then #order(B;D)
             #else true #fi
       #else false #fi

  rule #order( A:Name , B:Names ; C:Name , D:Names )
    => #if #order(A;C)
       #then #if #order(C;A)
             #then #order(B;D)
             #else true #fi
       #else false #fi

  // RhoKVPairs
  rule #order( A:RhoKVPair , B:RhoKVPairs ;; C:RhoKVPair , D:RhoKVPairs )
    => #if #order(A;;C)
       #then #if #order(C;;A)
             #then #order(B;;D)
             #else true #fi
       #else false #fi

/*
  // RhoKVPats
  rule #order( _:RhoKVPair , B:RhoKVPats  ; _:RhoKVPat  , D:RhoKVPats  ) => #order(B;D)
  rule #order( A:RhoKVPat  , B:RhoKVPats  ; C:RhoKVPat  , D:RhoKVPats  )
    => #if #order(A;C)
       #then #if #order(C;A)
             #then #order(B;D)
             #else true #fi
       #else false #fi
  rule #order( _:RhoKVPair , B:RhoKVPats  ; _:RhoKVPair , D:RhoKVPats  )
    => #if #order(A;C)
       #then #if #order(C;A)
             #then #order(B;D)
             #else true #fi
       #else false #fi
*/

  // Binds
  rule #order( A:Lbind ; B:Lbind  ;; C:Lbind ; D:Lbind  )
    => #if #order(A;;C)
       #then #if #order(C;;A)
             #then #order(B;;D)
             #else true #fi
       #else false #fi
  rule #order( A:Lbind ; B:Lbinds ;; C:Lbind ; D:Lbinds )
    => #if #order(A;;C)
       #then #if #order(C;;A)
             #then #order(B;;D)
             #else true #fi
       #else false #fi
  rule #order( A:Pbind ; B:Pbind  ;; C:Pbind ; D:Pbind  )
    => #if #order(A;;C)
       #then #if #order(C;;A)
             #then #order(B;;D)
             #else true #fi
       #else false #fi
  rule #order( A:Pbind ; B:Pbinds ;; C:Pbind ; D:Pbinds )
    => #if #order(A;;C)
       #then #if #order(C;;A)
             #then #order(B;;D)
             #else true #fi
       #else false #fi
  rule #order( A:Rbind ; B:Rbind  ;; C:Rbind ; D:Rbind  )
    => #if #order(A;;C)
       #then #if #order(C;;A)
             #then #order(B;;D)
             #else true #fi
       #else false #fi
  rule #order( A:Rbind ; B:Rbinds ;; C:Rbind ; D:Rbinds )
    => #if #order(A;;C)
       #then #if #order(C;;A)
             #then #order(B;;D)
             #else true #fi
       #else false #fi

// Reflexivity
  rule #order( A:Procs ; A ) => true

  // Ground
    // Nil
  rule #order( A:Proc ; Nil    ) => A ==K Nil
  rule #order( Nil    ; _:Proc ) => true
    // Bool
  rule #order( _:Bool ; A:Proc ) => true
       requires notBool (A ==K Nil orBool isBool(A))
  rule #order( A:Proc ; _:Bool ) => false
       requires notBool (A ==K Nil orBool isBool(A))
  rule #order( true   ; A:Bool ) => A
  rule #order( false  ; _:Bool ) => true
    // Int
  rule #order( _:Int  ; A:Proc ) => true
       requires notBool (A ==K Nil orBool isBool(A) orBool isInt(A))
  rule #order( A:Proc ; _:Int  ) => false
       requires notBool (A ==K Nil orBool isBool(A) orBool isInt(A))
  rule #order( I:Int  ; J:Int  ) => I <=Int J
    // String
  rule #order( _:String ; A:Proc   ) => true
       requires notBool (A ==K Nil orBool isBool(A) orBool isInt(A)
         orBool isString(A))
  rule #order( A:Proc   ; _:String ) => false
       requires notBool (A ==K Nil orBool isBool(A) orBool isInt(A)
         orBool isString(A))
  rule #order( A:String ; B:String ) => #set2procs(#procs2set(A,B)) ==K (A,B)
    // Unforgeable
  rule #order( _:Unforgeable ; A:Proc   ) => true
       requires notBool (A ==K Nil orBool isBool(A) orBool isInt(A)
         orBool isString(A) orBool isUnforgeable(A))
  rule #order( A:Proc   ; _:Unforgeable ) => false
       requires notBool (A ==K Nil orBool isBool(A) orBool isInt(A)
         orBool isString(A) orBool isUnforgeable(A))
  rule #order( unforgeable( I:Int ) ; unforgeable( J:Int ) ) => I <=Int J
    // Uri
  rule #order( _:Uri  ; A:Proc ) => true
       requires notBool (A ==K Nil orBool isBool(A) orBool isInt(A)
         orBool isString(A) orBool isUnforgeable(A) orBool isUri(A))
  rule #order( A:Proc ; _:Uri  ) => false
       requires notBool (A ==K Nil orBool isBool(A) orBool isInt(A)
         orBool isString(A) orBool isUnforgeable(A) orBool isUri(A))
  rule #order( A:Uri ; B:Uri ) => #set2procs(#procs2set(A,B)) ==K (A,B)

  // Variables -- use as Id and map to string for comparison
  rule #order( \(_:Var) ; A:Proc ) => true
       requires notBool (A ==K Nil orBool isGround(A) orBool isProcVar(A))
  rule #order( A:Proc ; \(_:Var) ) => false
       requires notBool (A ==K Nil orBool isGround(A) orBool isProcVar(A))
  rule #order( \A:Id ; \B:Id )
    => #set2procs(#procs2set(Id2String(A),Id2String(B))) ==K (Id2String(A),Id2String(B))
    // Eval
  rule #order( *_:Var ; A:Proc ) => true
       requires notBool (A ==K Nil orBool isGround(A) orBool isProcVar(A)
           orBool isEval(A))
  rule #order( A:Proc ; *_:Var ) => false
       requires notBool (A ==K Nil orBool isGround(A) orBool isProcVar(A)
           orBool isEval(A))
  rule #order( *A:Id ; *B:Id )
    => #set2procs(#procs2set(Id2String(A),Id2String(B))) ==K (Id2String(A),Id2String(B))

  // VarRef
  rule #order( _:VarRef ; A:Proc ) => true
       requires notBool (A ==K Nil orBool isGround(A) orBool isProcVar(A)
           orBool isEval(A) orBool isVarRef(A))
  rule #order( A:Proc ; _:VarRef ) => false
       requires notBool (A ==K Nil orBool isGround(A) orBool isProcVar(A)
           orBool isEval(A) orBool isVarRef(A))
  rule #order( = *A:Id ; = *B:Id ) => #order(A;B)
  rule #order( = \A:Id ; = \B:Id ) => #order(A;B)

  // New
  rule #order( _:New ; A:Proc ) => true
       requires notBool (A ==K Nil orBool isGround(A) orBool isProcVar(A)
           orBool isEval(A) orBool isVarRef(A) orBool isNew(A))
  rule #order( A:Proc ; _:New ) => false
       requires notBool (A ==K Nil orBool isGround(A) orBool isProcVar(A)
           orBool isEval(A) orBool isVarRef(A) orBool isNew(A))
  rule #order( new A:Names in { B:Proc } ; new C:Names in { D:Proc } )
    => #if #orderif(A;C)
       #then #if #order(C;A)
             #then #order(B;D)
             #else true #fi
       #else false #fi

 // Receive: Binds , Cont
  rule #order( _:Receive ; A:Proc ) => true
       requires notBool (A ==K Nil orBool isGround(A) orBool isProcVar(A)
           orBool isEval(A) orBool isVarRef(A) orBool isNew(A)
           orBool isReceive(A))
  rule #order( A:Proc ; _:Receive ) => false
       requires notBool (A ==K Nil orBool isGround(A) orBool isProcVar(A)
           orBool isEval(A) orBool isVarRef(A) orBool isNew(A)
           orBool isReceive(A))
  rule #order( A:Receive ; B:Receive )
    => #if #order(#bind(A);;#bind(B))
       #then #if #order(#bind(B);;#bind(A))
             #then #order(#cont(A);#cont(B))
             #else true #fi
       #else false #fi

  // Binds: dictionary order by Type , length , Chans , bvars
  rule #order( A:Bind ;; B:Bind )
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

  // Send: dictionary order by Type , # of msgs , Chan , Msg
  rule #order( A:Send ; B:Send )
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

// TODO
  // MethodProc: Proc . Method ( Args ) dictionary order by Method , Args , Proc
  // Exp: BExp < AExp <StringExp
  // Matching: dictionary order by # of MatchCases, Proc, MatchCases
  // Contract: dictionary order by Chan , NamePat
  // Bundle:  < 0 < - < + and #order(Proc;Proc)
  // Conditional: dictionary order by BExp , then Proc [, else Proc]

  // Collection: List < Map < Set < Tuple
  rule #order( _:RhoList ; A:Collection ) => true  requires notBool isRhoList(A)
  rule #order( A:Collection ; _:RhoList ) => false requires notBool isRhoList(A)
  rule #order( [ ] ; A:RhoList ) => true
  rule #order( A:RhoList ; [ ] ) => false requires A =/=K [ ]
  rule #order( [ A:Procs ] ; [ B:Procs ] ) => #orderif(A;B)

  rule #order( _:RhoMap ; A:Collection ) => true
       requires notBool (isRhoList(A) orBool isRhoMap(A))
  rule #order( A:Collection ; _:RhoMap ) => false
       requires notBool (isRhoList(A) orBool isRhoMap(A))
  rule #order( { } ; A:RhoMap ) => true
  rule #order( A:RhoMap ; { } ) => false requires A =/=K { }
  rule #order( { A:RhoKVPairs } ; { B:RhoKVPairs } ) => #orderif(A;;B)
    // RhoKVPairs
  rule #order( A:Proc : B:Proc  ;; C:Proc : D:Proc  )
    => #if #order(A;C)
       #then #if #order(C;A)
             #then #order(B;D)
             #else true #fi
       #else false #fi
  rule #order( A:RhoKVPair , B:RhoKVPairs ;; C:RhoKVPair , D:RhoKVPairs )
    => #if #order(A;;C)
       #then #if #order(C;;A)
             #then #order(B;;D)
             #else true #fi
       #else false #fi


  rule #order( @A:Proc ; @B:Proc ) => #order( A; B)
  rule #order( @A:Proc ;  B:Var  ) => #order( A;*B)
  rule #order(  A:Var  ; @B:Proc ) => #order(*A; B)
  rule #order(  A:Id   ;  B:Id   )
    => #set2procs(#procs2set(Id2String(A),Id2String(B))) ==K (Id2String(A),Id2String(B))

// Reorder
  // check order of left arg against all middle args and insert,
  // then move the head of the right arg list to the left arg and repeat

  //--- Procs ---
  rule #reorder( A:Par ) => #parnorm(A)

    // #reorder( Proc \/ Procs )
  rule #reorder( A:Proc  ) => A requires notBool isPar(A)
  rule #reorder( A:Procs ) => #reorder( ;; ;;A) requires notBool isProc(A)

    // #reorder( ;; ;; Procs )
  rule #reorder( ;; ;; A:Proc , B:Procs ) => #reorder( ;;A;;B)

    // #reorder( ;; Procs ;; )
  rule #reorder( ;; A:Procs ;;  ) => A

    // #reorder( ;; Proc \/ Procs ;; Proc \/ Procs )
  rule #reorder( ;; A:Proc           ;; B:Proc           ) => #reorder(B;;A  ;; )
  rule #reorder( ;; A:Proc           ;; B:Proc , C:Procs ) => #reorder(B;;A  ;;C)
  rule #reorder( ;; A:Proc , B:Procs ;; C:Proc           ) => #reorder(C;;A,B;; )
  rule #reorder( ;; A:Proc , B:Procs ;; C:Proc , D:Procs ) => #reorder(C;;A,B;;D)

    // #reorder( Proc ;; Proc \/ Procs ;; )
  rule #reorder( A:Proc ;; B:Proc ;; ) => #if #order(A;B) #then A,B #else B,A #fi
  rule #reorder( A:Proc ;; B:Proc , C:Procs ;; ) => #if #order(A;B)
                                                    #then #append(A;B,C)
                                                    #else #append(B;#reorder(A;;C;; )) #fi

    // #reorder( Proc ;; Proc \/ Procs ;; Proc \/ Procs )
  rule #reorder( A:Proc ;; B:Proc  ;; C:Proc           ) => #reorder(C;;#reorder(A;;B;; );; )
  rule #reorder( A:Proc ;; B:Proc  ;; C:Proc , D:Procs ) => #reorder(C;;#reorder(A;;B;; );;D)
  rule #reorder( A:Proc ;; B:Procs ;; C:Proc           ) => #reorder(C;;#reorder(A;;B;; );; )
  rule #reorder( A:Proc ;; B:Procs ;; C:Proc , D:Procs ) => #reorder(C;;#reorder(A;;B;; );;D)

  //--- Names ---
    // #reorder( Name \/ Names )
  rule #reorder( A:Name  ) => A
  rule #reorder( A:Names ) => #reorder( ;; ;;A) requires notBool isName(A)

    // #reorder( ;; ;; Names )
  rule #reorder( ;; ;; A:Name , B:Names ) => #reorder( ;;A;;B)

    // #reorder( ;; Names ;; )
  rule #reorder( ;; A:Names ;;  ) => A

    // #reorder( ;; Name \/ Names ;; Name \/ Names )
  rule #reorder( ;; A:Name           ;; B:Name           ) => #reorder(B;;A  ;; )
  rule #reorder( ;; A:Name           ;; B:Name , C:Names ) => #reorder(B;;A  ;;C)
  rule #reorder( ;; A:Name , B:Names ;; C:Name           ) => #reorder(C;;A,B;; )
  rule #reorder( ;; A:Name , B:Names ;; C:Name , D:Names ) => #reorder(C;;A,B;;D)

    // #reorder( Name ;; Name \/ Names ;; )
  rule #reorder( A:Name ;; B:Name ;; ) => #if #order(A;B) #then A,B #else B,A #fi
  rule #reorder( A:Name ;; B:Name , C:Names ;; ) => #if #order(A;B)
                                                      #then #append(A;B,C)
                                                      #else #append(B;#reorder(A;;C;; )) #fi

    // #reorder( Name ;; Name \/ Names ;; Name \/ Names )
  rule #reorder( A:Name ;; B:Name  ;; C:Name           ) => #reorder(C;;#reorder(A;;B;; );; )
  rule #reorder( A:Name ;; B:Name  ;; C:Name , D:Names ) => #reorder(C;;#reorder(A;;B;; );;D)
  rule #reorder( A:Name ;; B:Names ;; C:Name           ) => #reorder(C;;#reorder(A;;B;; );; )
  rule #reorder( A:Name ;; B:Names ;; C:Name , D:Names ) => #reorder(C;;#reorder(A;;B;; );;D)

  // Binds
    // Lbinds
    // #reorder( Lbind \/ Lbinds )
  rule #reorder( A:Lbind  ) => A
  rule #reorder( A:Lbinds ) => #reorder( ;; ;;A)

    // #reorder( ;; ;; Lbinds )
  rule #reorder( ;; ;; A:Lbind ; B:Lbind  ) => #reorder( ;;A;;B)
  rule #reorder( ;; ;; A:Lbind ; B:Lbinds ) => #reorder( ;;A;;B)

    // #reorder( ;; Lbinds ;; )
  rule #reorder( ;; A:Lbinds ;;  ) => A

    // #reorder( ;; Lbind \/ Lbinds ;; Lbind \/ Lbinds )
  rule #reorder( ;; A:Lbind  ;; B:Lbind            ) => #reorder(B;;A;; )
  rule #reorder( ;; A:Lbind  ;; B:Lbind ; C:Lbind  ) => #reorder(B;;A;;C)
  rule #reorder( ;; A:Lbind  ;; B:Lbind ; C:Lbinds ) => #reorder(B;;A;;C)
  rule #reorder( ;; A:Lbinds ;; C:Lbind            ) => #reorder(C;;A;; )
  rule #reorder( ;; A:Lbinds ;; C:Lbind ; D:Lbind  ) => #reorder(C;;A;;D)
  rule #reorder( ;; A:Lbinds ;; C:Lbind ; D:Lbinds ) => #reorder(C;;A;;D)

    // #reorder( Lbind ;; Lbind \/ Lbinds ;; )
  rule #reorder( A:Lbind ;; B:Lbind ;; ) => #if #order(A;;B) #then A;B #else B;A #fi
  rule #reorder( A:Lbind ;; B:Lbind ; C:Lbind  ;; ) => #if #order(A;;B)
                                                       #then #append(A;;B;C)
                                                       #else #append(B;;#reorder(A;;C;; )) #fi
  rule #reorder( A:Lbind ;; B:Lbind ; C:Lbinds ;; ) => #if #order(A;;B)
                                                       #then #append(A;;B;C)
                                                       #else #append(B;;#reorder(A;;C;; )) #fi

    // #reorder( Lbind ;; Lbind \/ Lbinds ;; Lbind \/ Lbinds )
  rule #reorder( A:Lbind ;; B:Lbind  ;; C:Lbind            ) => #reorder(C;;#reorder(A;;B;; );; )
  rule #reorder( A:Lbind ;; B:Lbind  ;; C:Lbind ; D:Lbind  ) => #reorder(C;;#reorder(A;;B;; );;D)
  rule #reorder( A:Lbind ;; B:Lbind  ;; C:Lbind ; D:Lbinds ) => #reorder(C;;#reorder(A;;B;; );;D)
  rule #reorder( A:Lbind ;; B:Lbinds ;; C:Lbind            ) => #reorder(C;;#reorder(A;;B;; );; )
  rule #reorder( A:Lbind ;; B:Lbinds ;; C:Lbind ; D:Lbind  ) => #reorder(C;;#reorder(A;;B;; );;D)
  rule #reorder( A:Lbind ;; B:Lbinds ;; C:Lbind ; D:Lbinds ) => #reorder(C;;#reorder(A;;B;; );;D)

    // Lbinds
    // #reorder( Pbind \/ Pbinds )
  rule #reorder( A:Pbind  ) => A
  rule #reorder( A:Pbinds ) => #reorder( ;; ;;A)

    // #reorder( ;; ;; Pbinds )
  rule #reorder( ;; ;; A:Pbind ; B:Pbind  ) => #reorder( ;;A;;B)
  rule #reorder( ;; ;; A:Pbind ; B:Pbinds ) => #reorder( ;;A;;B)

    // #reorder( ;; Pbinds ;; )
  rule #reorder( ;; A:Pbinds ;;  ) => A

    // #reorder( ;; Pbind \/ Pbinds ;; Pbind \/ Pbinds )
  rule #reorder( ;; A:Pbind  ;; B:Pbind            ) => #reorder(B;;A;; )
  rule #reorder( ;; A:Pbind  ;; B:Pbind ; C:Pbind  ) => #reorder(B;;A;;C)
  rule #reorder( ;; A:Pbind  ;; B:Pbind ; C:Pbinds ) => #reorder(B;;A;;C)
  rule #reorder( ;; A:Pbinds ;; C:Pbind            ) => #reorder(C;;A;; )
  rule #reorder( ;; A:Pbinds ;; C:Pbind ; D:Pbind  ) => #reorder(C;;A;;D)
  rule #reorder( ;; A:Pbinds ;; C:Pbind ; D:Pbinds ) => #reorder(C;;A;;D)

    // #reorder( Pbind ;; Pbind \/ Pbinds ;; )
  rule #reorder( A:Pbind ;; B:Pbind ;; ) => #if #order(A;;B) #then A;B #else B;A #fi
  rule #reorder( A:Pbind ;; B:Pbind ; C:Pbind  ;; ) => #if #order(A;;B)
                                                       #then #append(A;;B;C)
                                                       #else #append(B;;#reorder(A;;C;; )) #fi
  rule #reorder( A:Pbind ;; B:Pbind ; C:Pbinds ;; ) => #if #order(A;;B)
                                                       #then #append(A;;B;C)
                                                       #else #append(B;;#reorder(A;;C;; )) #fi

    // #reorder( Pbind ;; Pbind \/ Pbinds ;; Pbind \/ Pbinds )
  rule #reorder( A:Pbind ;; B:Pbind  ;; C:Pbind            ) => #reorder(C;;#reorder(A;;B;; );; )
  rule #reorder( A:Pbind ;; B:Pbind  ;; C:Pbind ; D:Pbind  ) => #reorder(C;;#reorder(A;;B;; );;D)
  rule #reorder( A:Pbind ;; B:Pbind  ;; C:Pbind ; D:Pbinds ) => #reorder(C;;#reorder(A;;B;; );;D)
  rule #reorder( A:Pbind ;; B:Pbinds ;; C:Pbind            ) => #reorder(C;;#reorder(A;;B;; );; )
  rule #reorder( A:Pbind ;; B:Pbinds ;; C:Pbind ; D:Pbind  ) => #reorder(C;;#reorder(A;;B;; );;D)
  rule #reorder( A:Pbind ;; B:Pbinds ;; C:Pbind ; D:Pbinds ) => #reorder(C;;#reorder(A;;B;; );;D)

    // Lbinds
    // #reorder( Rbind \/ Rbinds )
  rule #reorder( A:Rbind  ) => A
  rule #reorder( A:Rbinds ) => #reorder( ;; ;;A)

    // #reorder( ;; ;; Rbinds )
  rule #reorder( ;; ;; A:Rbind ; B:Rbind  ) => #reorder( ;;A;;B)
  rule #reorder( ;; ;; A:Rbind ; B:Rbinds ) => #reorder( ;;A;;B)

    // #reorder( ;; Rbinds ;; )
  rule #reorder( ;; A:Rbinds ;;  ) => A

    // #reorder( ;; Rbind \/ Rbinds ;; Rbind \/ Rbinds )
  rule #reorder( ;; A:Rbind  ;; B:Rbind            ) => #reorder(B;;A;; )
  rule #reorder( ;; A:Rbind  ;; B:Rbind ; C:Rbind  ) => #reorder(B;;A;;C)
  rule #reorder( ;; A:Rbind  ;; B:Rbind ; C:Rbinds ) => #reorder(B;;A;;C)
  rule #reorder( ;; A:Rbinds ;; C:Rbind            ) => #reorder(C;;A;; )
  rule #reorder( ;; A:Rbinds ;; C:Rbind ; D:Rbind  ) => #reorder(C;;A;;D)
  rule #reorder( ;; A:Rbinds ;; C:Rbind ; D:Rbinds ) => #reorder(C;;A;;D)

    // #reorder( Rbind ;; Rbind \/ Rbinds ;; )
  rule #reorder( A:Rbind ;; B:Rbind ;; ) => #if #order(A;;B) #then A;B #else B;A #fi
  rule #reorder( A:Rbind ;; B:Rbind ; C:Rbind  ;; ) => #if #order(A;;B)
                                                       #then #append(A;;B;C)
                                                       #else #append(B;;#reorder(A;;C;; )) #fi
  rule #reorder( A:Rbind ;; B:Rbind ; C:Rbinds ;; ) => #if #order(A;;B)
                                                       #then #append(A;;B;C)
                                                       #else #append(B;;#reorder(A;;C;; )) #fi

    // #reorder( Rbind ;; Rbind \/ Rbinds ;; Rbind \/ Rbinds )
  rule #reorder( A:Rbind ;; B:Rbind  ;; C:Rbind            ) => #reorder(C;;#reorder(A;;B;; );; )
  rule #reorder( A:Rbind ;; B:Rbind  ;; C:Rbind ; D:Rbind  ) => #reorder(C;;#reorder(A;;B;; );;D)
  rule #reorder( A:Rbind ;; B:Rbind  ;; C:Rbind ; D:Rbinds ) => #reorder(C;;#reorder(A;;B;; );;D)
  rule #reorder( A:Rbind ;; B:Rbinds ;; C:Rbind            ) => #reorder(C;;#reorder(A;;B;; );; )
  rule #reorder( A:Rbind ;; B:Rbinds ;; C:Rbind ; D:Rbind  ) => #reorder(C;;#reorder(A;;B;; );;D)
  rule #reorder( A:Rbind ;; B:Rbinds ;; C:Rbind ; D:Rbinds ) => #reorder(C;;#reorder(A;;B;; );;D)



// checks par set structural equality of deBruijnified Procs
  rule #structEq( A:Proc ; B:Proc ) => #setify(#deBruijn(A)) ==K #setify(#deBruijn(B))
       requires isPar(A) orBool isPar(B)
  rule #structEq( A:Proc , B:Procs ; C:Proc , D:Procs ) => #structEq(A;C) andBool #structEq(B;D)

  rule #structEqif( A:Procs ; B:Procs ) => #length(A) ==Int #length(B) andBool #structEq(A;B)

// NonPar Proc Structural Equivalence
  // Ground
  rule #structEq( A:Ground ; B:Ground ) => A ==K B
  rule #structEq( _:Ground ; B:Proc   ) => false requires notBool (isGround(B) orBool isPar(B) orBool isEval(B))
  rule #structEq( A:Proc   ; _:Ground ) => false requires notBool (isGround(A) orBool isPar(A) orBool isEval(A))

  // Send
  rule #structEq( A:Name !  (         ) ; C:Name !  (         ) ) => #nameEq(A;C)
  rule #structEq( A:Name !  ( B:Procs ) ; C:Name !  ( D:Procs ) ) => #nameEq(A;C) andBool #structEqif(B;D)
  rule #structEq( A:Name !! (         ) ; C:Name !! (         ) ) => #nameEq(A;C)
  rule #structEq( A:Name !! ( B:Procs ) ; C:Name !! ( D:Procs ) ) => #nameEq(A;C) andBool #structEqif(B;D)
  rule #structEq( A:Proc ; _:Send ) => false requires notBool (isSend(A) orBool isPar(A) orBool isEval(A))
  rule #structEq( _:Send ; A:Proc ) => false requires notBool (isSend(A) orBool isPar(A) orBool isEval(A))

  // Receive -- checks equivalence of listening variables, channels, and continuations
    // SRec
  rule #structEq( for( Y:NamePats <-  X:Name ){ P:Proc } ;
                  for( V:NamePats <-  U:Name ){ Q:Proc } )
    => #nameEqif(Y;V) andBool #nameEq(X;U) andBool #structEq(P;#sub(Y;V;Q))
  rule #structEq( for( Y:Names    <-  X:Name ){ P:Proc } ;
                  for( V:Names    <-  U:Name ){ Q:Proc } )
    => #nameEqif(Y;V) andBool #nameEq(X;U) andBool #structEq(P;#sub(Y;V;Q))
  rule #structEq( for(            <-  X:Name ){ P:Proc } ;
                  for(            <-  U:Name ){ Q:Proc } )
    => #nameEq(X;U) andBool #structEq(P;Q)

  rule #structEq( for( Y:NamePats <<- X:Name ){ P:Proc } ;
                  for( V:NamePats <<- U:Name ){ Q:Proc } )
    => #nameEqif(Y;V) andBool #nameEq(X;U) andBool #structEq(P;#sub(Y;V;Q))
  rule #structEq( for( Y:Names    <<- X:Name ){ P:Proc } ;
                  for( V:Names    <<- U:Name ){ Q:Proc } )
    => #nameEqif(Y;V) andBool #nameEq(X;U) andBool #structEq(P;#sub(Y;V;Q))
  rule #structEq( for(            <<- X:Name ){ P:Proc } ;
                  for(            <<- U:Name ){ Q:Proc } )
    => #nameEq(X;U) andBool #structEq(P;Q)

  rule #structEq( for( Y:NamePats <=  X:Name ){ P:Proc } ;
                  for( V:NamePats <=  U:Name ){ Q:Proc } )
    => #nameEqif(Y;V) andBool #nameEq(X;U) andBool #structEq(P;#sub(Y;V;Q))
  rule #structEq( for( Y:Names    <=  X:Name ){ P:Proc } ;
                  for( V:Names    <=  U:Name ){ Q:Proc } )
    => #nameEqif(Y;V) andBool #nameEq(X;U) andBool #structEq(P;#sub(Y;V;Q))
  rule #structEq( for(            <=  X:Name ){ P:Proc } ;
                  for(            <=  U:Name ){ Q:Proc } )
    => #nameEq(X;U) andBool #structEq(P;Q)

    // MRec -- TODO

  // Collection
    // RhoList
  rule #structEq( [ ] ; [ ] ) => true
  rule #structEq( [ A:Procs ] ; [ B:Procs ] ) => #structEqif(A;B)
  rule #structEq( _:RhoList   ; _:RhoList   ) => false [owise]

    // RhoMap
  rule #structEq( A:RhoMap ; B:RhoMap ) => #structEq(#rho2map(A);#rho2map(B))
  rule #structEq( A:Proc   ; _:RhoMap ) => false
       requires notBool (isRhoMap(A) orBool isPar(A))
  rule #structEq( _:RhoMap ; A:Proc   ) => false
       requires notBool (isRhoMap(A) orBool isPar(A))

    // RhoSet
  rule #structEq( A:RhoSet ; B:RhoSet ) => #structEq(#rho2set(A);#rho2set(B))
  rule #structEq( A:Proc   ; _:RhoSet ) => false
       requires notBool (isRhoSet(A) orBool isPar(A))
  rule #structEq( _:RhoSet ; A:Proc   ) => false
       requires notBool (isRhoSet(A) orBool isPar(A))

    // RhoTuple
  rule #structEq( ( A:Procs ,) ; ( B:Procs ,) ) => #structEqif(A;B)
  rule #structEq( _:RhoTuple   ; _:RhoTuple   ) => false [owise]

//----------------
//--- #SeqSetIn --
//----------------
// Structural equivalence of Maps & Sets
  rule #structEq( A:Set ; B:Set ) => #SeqSetIn(A;B) andBool #SeqSetIn(B;A)
  rule #structEq( A:Map ; B:Map ) => #SeqMapIn(A;B) andBool #SeqMapIn(B;A)

// Structural equivalence Set inclusion
  // left arg empty Set
  rule #SeqSetIn(  .Set ; _:Set ) => true
  // right arg empty Set
  rule #SeqSetIn( A:Set ;  .Set ) => false requires A =/=K .Set

// TODO: turn each element into least order seq term so this can become syntactic equality i.e. normalize term
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

  // left arg empty Map
  rule #SeqMapIn(  .Map ; _:Map ) => true
  // right arg empty Map
  rule #SeqMapIn( A:Map ;  .Map ) => false requires A =/=K .Map
// TODO: turn each element into least order seq term so this can become syntactic equality
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
  // mainly for NameVars
  rule #nameEq(  A:Name ;  B:Name ) => A ==K B requires notBool (isQuote(A) andBool isQuote(B))
  rule #nameEq(  A:Name ;  A ) => true
  rule #nameEq( @P:Proc ; @Q:Proc ) => #structEq(P;Q)

  // several Names
  rule #nameEq( A:Name , B:Names ; C:Name , D:Names ) => #nameEq(A;C) andBool #nameEq(B;D)

  // check length
  rule #nameEqif( A:Names ; B:Names ) => #length(A) ==Int #length(B) andBool #nameEq(A;B)

//-----------------
//--- Built-ins ---
//-----------------
// #rho2list -- throws [Error] Internal: Uncaught exception thrown of type AssertionError.
// direct RhoList to List translation
  rule #rho2list( [ ] ) => .List
  rule #rho2list( [ A:Proc ] ) => ListItem(A)
  rule #rho2list( [ A:Proc , B:Procs ] ) => ListItem(A) #rho2list([B])

// #rho2map
// produces Map with unique keys for structurally equivalent keys in RhoMap
  rule #rho2map( { } ) => .Map
  rule #rho2map( { A:Proc : B:Proc } ) => A |-> B
  rule #rho2map( { A:Proc : B:Proc , C:RhoKVPairs } )
    => #if #key_structEq(A;C)
       #then #rho2map({C})
       #else A |-> B #rho2map({C}) #fi

// #rho2set
  rule #rho2set( Set( ) ) => .Set
  rule #rho2set( Set( A:Proc ) ) => SetItem(A)
  rule #rho2set( Set( A:Proc , B:Procs ) )
    => #if #structEqs(A;B)
       #then #rho2set(Set(B)) // if #structEq(A;C) for some C in B, discard A
       #else SetItem(A) #rho2set(Set(B)) #fi // otherwise keep A and traverse remaining set

  // #key_structEq( key ; RhoKVPair )
  rule #key_structEq( A:Proc ; B:Proc : _:Proc ) => #structEq(A;B)
  // #key_structEq( key ; RhoKVPairs )
  rule #key_structEq( A:Proc ; B:Proc : _:Proc , C:RhoKVPairs ) => #structEq(A;B) orBool #key_structEq(A;C)

  rule #structEqs( A:Proc ; B:Proc           ) => #structEq(A;B)
  rule #structEqs( A:Proc ; B:Proc , C:Procs ) => #structEq(A;B) orBool #structEqs(A;C)

//---//---//

  rule ( A:Name , B:Names ) ==K ( C:Name , D:Names ) => A ==K C andBool B ==K D
  rule ( A:Proc , B:Procs ) ==K ( C:Proc , D:Procs ) => A ==K C andBool B ==K D

endmodule
