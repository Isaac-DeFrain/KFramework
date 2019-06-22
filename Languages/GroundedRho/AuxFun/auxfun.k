// Auxilary functions for GRHO configuration

/*
TODO:
 - #toK( RhoList/RhoMap/RhoSet ) => List/Map/Set to utilize builtin functionality for methods
 - #fromK( List/Map/Set ) => RhoList/RhoMap/RhoSet

 - #length( RhoKVPairs ), #length( ConcatExp ), & #length( InterpMaps )
*/

require "../grho.k"
require "../AlphaEquiv/alpha.k"

module AUXFUN-SYNTAX
  import GRHO-SYNTAX

// Length of object lists
  syntax     Int ::= "#length(" Name        ")" [function]
                   | "#length(" Names       ")" [function]
                   | "#length(" NamePat     ")" [function]
                   | "#length(" NamePats    ")" [function]
                   | "#length(" Proc        ")" [function]
                   | "#length(" Procs       ")" [function]
                   | "#length(" ProcPat     ")" [function]
                   | "#length(" ProcPats    ")" [function]
                   | "#length(" AnyBinds    ")" [function]
                   | "#length(" AnyBindPats ")" [function]

  syntax     Int ::=   "#size(" RhoMap   ")" [function]
                   |   "#size(" RhoSet   ")" [function]
                   | "#length(" RhoList  ")" [function]
                   | "#length(" RhoTuple ")" [function]

// Send/Rec classification & destructuring
  syntax     Int ::= "#msglen(" Send        ")" [function] // number of messages
                   | "#msglen(" SendPat     ")" [function] // number of messages
                   | "#lislen(" AnyBind     ")" [function] // number of listening names
                   | "#lislen(" AnyBindPat  ")" [function] // number of listening names
                   | "#lislen(" Receive     ")" [function] // number of listening names
                   | "#lislen(" RecPat      ")" [function] // number of listening names
                   |  "#stype(" Send        ")" [function]
                   |  "#stype(" SendPat     ")" [function]
                   |  "#rtype(" AnyBind     ")" [function]
                   |  "#rtype(" AnyBindPat  ")" [function]
                   |  "#rtype(" AnyBinds    ")" [function]
                   |  "#rtype(" AnyBindPats ")" [function]
                   |  "#rtype(" Receive     ")" [function]
                   |  "#rtype(" RecPat      ")" [function]

  // Finish Pattern syntax

// Receive and RecPat can both have Bind listens
  syntax      Bind ::= "#bind(" Receive ")" [function]
                     | "#bind(" RecPat  ")" [function]
  syntax     Binds ::= "#bind(" Receive ")" [function]
                     | "#bind(" RecPat  ")" [function]

// Only RecPat has BindPat listens
  syntax   BindPat ::= "#bind(" RecPat  ")" [function]
  syntax  BindPats ::= "#bind(" RecPat  ")" [function]

// Patterns & Processes can have Proc msg & cont
  syntax      Proc ::= "#cont(" Receive ")" [function]
                     | "#cont(" RecPat  ")" [function]
                     |  "#msg(" Send    ")" [function]
                     |  "#msg(" SendPat ")" [function]
  syntax     Procs ::=  "#msg(" Send    ")" [function]
                     |  "#msg(" SendPat ")" [function]

// Only Patterns have ProcPat msg or cont
  syntax   ProcPat ::= "#cont(" RecPat  ")" [function]
                     |  "#msg(" SendPat ")" [function]
  syntax  ProcPats ::=  "#msg(" SendPat ")" [function]


  syntax      Name ::= "#chan(" Send       ")" [function]
                     | "#chan(" SendPat    ")" [function]
                     | "#chan(" Receive    ")" [function]
                     | "#chan(" RecPat     ")" [function]
                     | "#chan(" AnyBind    ")" [function]
                     | "#bvar(" AnyBind    ")" [function]
                     | "#bvar(" AnyBindPat ")" [function]
                     | "#bvar(" Receive    ")" [function]
                     | "#bvar(" RecPat     ")" [function]
                     |  "#dec(" New        ")" [function]
                     |  "#dec(" NewPat     ")" [function]

  syntax     Names ::= "#chan(" AnyBinds    ")" [function]
                     | "#chan(" Receive     ")" [function]
                     | "#chan(" RecPat      ")" [function]
                     | "#bvar(" AnyBind     ")" [function]
                     | "#bvar(" AnyBinds    ")" [function]
                     | "#bvar(" AnyBindPat  ")" [function]
                     | "#bvar(" AnyBindPats ")" [function]
                     | "#bvar(" Receive     ")" [function]
                     | "#bvar(" RecPat      ")" [function]
                     |  "#dec(" New         ")" [function]
                     |  "#dec(" NewPat      ")" [function]

  syntax   NamePat ::= "#chan(" SendPat     ")" [function]
                     | "#chan(" RecPat      ")" [function]
                     | "#chan(" AnyBindPat  ")" [function]
                     | "#bvar(" AnyBind     ")" [function]
                     | "#bvar(" AnyBindPat  ")" [function]
                     | "#bvar(" Receive     ")" [function]
                     | "#bvar(" RecPat      ")" [function]
  syntax  NamePats ::= "#chan(" RecPat      ")" [function]
                     | "#chan(" AnyBindPats ")" [function]
                     | "#bvar(" AnyBindPat  ")" [function]
                     | "#bvar(" AnyBind     ")" [function]
                     | "#bvar(" AnyBinds    ")" [function]
                     | "#bvar(" AnyBindPat  ")" [function]
                     | "#bvar(" AnyBindPats ")" [function]
                     | "#bvar(" Receive     ")" [function]
                     | "#bvar(" RecPat      ")" [function]

  // Input Guards
  syntax      BExp ::= "#guard(" Receive   ")" [function]
                     | "#guard(" RecPat    ")" [function]
                     | "#guard(" GBind     ")" [function]
                     | "#guard(" GBinds    ")" [function]
                     | "#guard(" GBindPat  ")" [function]
                     | "#guard(" GBindPats ")" [function]

  syntax      Proc ::= "#par2procs(" Proc  ")" [function]
                     | "#procs2par(" Proc  ")" [function]
                     | "#procs2par(" Procs ")" [function]
  syntax     Procs ::= "#par2procs(" Proc  ")" [function]

  syntax     Names ::= "#quotes(" Procs ")"           [function]
                     | "#append(" Name  ";" Name  ")" [function]
                     | "#append(" Names ";" Name  ")" [function]
                     | "#append(" Name  ";" Names ")" [function]
                     | "#append(" Names ";" Names ")" [function]

  syntax  NamePats ::= "#quotes(" ProcPats ")"              [function]
                     | "#append(" Name     ";" NamePat  ")" [function]
                     | "#append(" Names    ";" NamePat  ")" [function]
                     | "#append(" Name     ";" NamePats ")" [function]
                     | "#append(" Names    ";" NamePats ")" [function]
                     | "#append(" NamePat  ";" Name     ")" [function]
                     | "#append(" NamePats ";" Name     ")" [function]
                     | "#append(" NamePat  ";" Names    ")" [function]
                     | "#append(" NamePats ";" Names    ")" [function]
                     | "#append(" NamePat  ";" NamePat  ")" [function]
                     | "#append(" NamePats ";" NamePat  ")" [function]
                     | "#append(" NamePat  ";" NamePats ")" [function]
                     | "#append(" NamePats ";" NamePats ")" [function]

  syntax     Procs ::= "#append(" Proc  ";" Proc  ")" [function]
                     | "#append(" Procs ";" Proc  ")" [function]
                     | "#append(" Proc  ";" Procs ")" [function]
                     | "#append(" Procs ";" Procs ")" [function]

  syntax  ProcPats ::= "#append(" Proc     ";" ProcPat  ")" [function]
                     | "#append(" Procs    ";" ProcPat  ")" [function]
                     | "#append(" Proc     ";" ProcPats ")" [function]
                     | "#append(" Procs    ";" ProcPats ")" [function]
                     | "#append(" ProcPat  ";" Proc     ")" [function]
                     | "#append(" ProcPats ";" Proc     ")" [function]
                     | "#append(" ProcPat  ";" Procs    ")" [function]
                     | "#append(" ProcPats ";" Procs    ")" [function]
                     | "#append(" ProcPat  ";" ProcPat  ")" [function]
                     | "#append(" ProcPats ";" ProcPat  ")" [function]
                     | "#append(" ProcPat  ";" ProcPats ")" [function]
                     | "#append(" ProcPats ";" ProcPats ")" [function]

  syntax
        RhoKVPairs ::= "#append(" RhoKVPair  ";" RhoKVPair  ")" [function]
                     | "#append(" RhoKVPairs ";" RhoKVPair  ")" [function]
                     | "#append(" RhoKVPair  ";" RhoKVPairs ")" [function]
                     | "#append(" RhoKVPairs ";" RhoKVPairs ")" [function]

// Methods
  syntax    RhoSet ::=  "#keys(" RhoMap ")"            [function]
                     | "#union(" RhoSet ";" RhoSet ")" [function]

  syntax   RhoList ::=    "#slice(" RhoList "," Int "," Int ")" [function]
                     | "#truncate(" RhoList "," Int ")"         [function]

// Substitution
  syntax       Map ::= "#mapSub(" Set ")" [function]

// Par Normalization
  syntax      Proc ::=   "#normPar(" Proc ")"          [function, poly(0,1)]
                     |   "#set2Par(" Set  ")"          [function]
                     | "#removePar(" Proc ";" Proc ")" [function]
                     |    "#parDup(" Proc ";" Int  ")" [function]
  syntax       Set ::=   "#par2Set(" Proc ")"          [function]
  syntax       Int ::=  "#countPar(" Proc ";" Proc ")" [function]

// String Interpolation
  syntax    String ::= "#interpolate(" String ";" RhoMap ")" [function]

// De Bruijn indexing
  syntax     Proc ::= "#val2Key(" Proc ";" Map ")" [function]
  syntax     Name ::= "#val2Key(" Name ";" Map ")" [function]

// Predicates -- List, RhoMap keys, & RhoSet inclusion
  syntax     Bool ::= Int   "#in"  "(" Procs ")" [function]
                    | Int   "#in"  "(" Proc  ")" [function]
                    | Name  "#in"  "(" Names ")" [function]
                    | Name  "#in"  "(" Name  ")" [function]
                    | Bind  "#in"  "(" Bind  ")" [function]
                    | Bind  "#in"  "(" Binds ")" [function]
                    | Binds "#in"  "(" Binds ")" [function]
                    | Proc  "#in_keys" RhoMap    [function]
                    | Proc  "#in_set"  RhoSet    [function]

// Translation from Built-ins
  syntax  RhoList ::= "#list2rho(" List ")" [function]
                    |   "#concat(" RhoList ";" RhoList ")" [function]
  syntax   RhoMap ::=  "#map2rho(" Map  ")" [function]
                    | "#unionMap(" RhoMap  ";" RhoMap ")" [function]
  syntax   RhoSet ::=  "#set2rho(" Set  ")" [function]
                    | "#unionSet(" RhoSet  ";" RhoSet ")" [function]

endmodule

module AUXFUN
  import AUXFUN-SYNTAX

  syntax KResult ::= RhoKVPair | RhoKVPairs
                   | Name | Names | NamePat | NamePats
                   | Proc | Procs | ProcPat | ProcPats
                   | Bind | Binds | BindPat | BindPats
                   /*| Bool | Int | String | Map | Set <: Proc*/

// Sends
  rule #chan( N:Name    !  (            ) ) => N
  rule #chan( N:Name    !  ( _:Proc     ) ) => N
  rule #chan( N:Name    !  ( _:Procs    ) ) => N
  rule #chan( N:Name    !  ( _:ProcPat  ) ) => N
  rule #chan( N:Name    !  ( _:ProcPats ) ) => N
  rule #chan( N:NamePat !  (            ) ) => N
  rule #chan( N:NamePat !  ( _:Proc     ) ) => N
  rule #chan( N:NamePat !  ( _:Procs    ) ) => N
  rule #chan( N:NamePat !  ( _:ProcPat  ) ) => N
  rule #chan( N:NamePat !  ( _:ProcPats ) ) => N
  rule #chan( N:Name    !! (            ) ) => N
  rule #chan( N:Name    !! ( _:Proc     ) ) => N
  rule #chan( N:Name    !! ( _:Procs    ) ) => N
  rule #chan( N:Name    !! ( _:ProcPat  ) ) => N
  rule #chan( N:Name    !! ( _:ProcPats ) ) => N
  rule #chan( N:NamePat !! (            ) ) => N
  rule #chan( N:NamePat !! ( _:Proc     ) ) => N
  rule #chan( N:NamePat !! ( _:Procs    ) ) => N
  rule #chan( N:NamePat !! ( _:ProcPat  ) ) => N
  rule #chan( N:NamePat !! ( _:ProcPats ) ) => N

  rule #msg( _:Name    !  (            ) ) => EmptyP
  rule #msg( _:Name    !  ( P:Proc     ) ) => P
  rule #msg( _:Name    !  ( P:Procs    ) ) => P
  rule #msg( _:Name    !  ( P:ProcPat  ) ) => P
  rule #msg( _:Name    !  ( P:ProcPats ) ) => P
  rule #msg( _:NamePat !  (            ) ) => EmptyP
  rule #msg( _:NamePat !  ( P:Proc     ) ) => P
  rule #msg( _:NamePat !  ( P:Procs    ) ) => P
  rule #msg( _:NamePat !  ( P:ProcPat  ) ) => P
  rule #msg( _:NamePat !  ( P:ProcPats ) ) => P
  rule #msg( _:Name    !! (            ) ) => EmptyP
  rule #msg( _:Name    !! ( P:Proc     ) ) => P
  rule #msg( _:Name    !! ( P:Procs    ) ) => P
  rule #msg( _:Name    !! ( P:ProcPat  ) ) => P
  rule #msg( _:Name    !! ( P:ProcPats ) ) => P
  rule #msg( _:NamePat !! (            ) ) => EmptyP
  rule #msg( _:NamePat !! ( P:Proc     ) ) => P
  rule #msg( _:NamePat !! ( P:Procs    ) ) => P
  rule #msg( _:NamePat !! ( P:ProcPat  ) ) => P
  rule #msg( _:NamePat !! ( P:ProcPats ) ) => P
  
  rule #msglen( S:Send    ) => #length(#msg(S))
  rule #msglen( S:SendPat ) => #length(#msg(S))

  rule #stype( _:ConSend   ) => 0
  rule #stype( _:UnconSend ) => 1

// Receives
  rule #bind( for ( B:Lbind  ){ _:Proc } ) => B
  rule #bind( for ( B:Lbinds ){ _:Proc } ) => B
  rule #bind( for ( B:Lbind  _:Guard ){ _:Proc } ) => B
  rule #bind( for ( B:Lbinds _:Guard ){ _:Proc } ) => B
  rule #bind( for ( B:Pbind  ){ _:Proc } ) => B
  rule #bind( for ( B:Pbinds ){ _:Proc } ) => B
  rule #bind( for ( B:Pbind  _:Guard ){ _:Proc } ) => B
  rule #bind( for ( B:Pbinds _:Guard ){ _:Proc } ) => B
  rule #bind( for ( B:Rbind  ){ _:Proc } ) => B
  rule #bind( for ( B:Rbinds ){ _:Proc } ) => B
  rule #bind( for ( B:Rbind  _:Guard ){ _:Proc } ) => B
  rule #bind( for ( B:Rbinds _:Guard ){ _:Proc } ) => B
  rule #bind( for ( B:Lbind  ){ _:ProcPat } ) => B
  rule #bind( for ( B:Lbinds ){ _:ProcPat } ) => B
  rule #bind( for ( B:Lbind  _:Guard ){ _:ProcPat } ) => B
  rule #bind( for ( B:Lbinds _:Guard ){ _:ProcPat } ) => B
  rule #bind( for ( B:Pbind  ){ _:ProcPat } ) => B
  rule #bind( for ( B:Pbinds ){ _:ProcPat } ) => B
  rule #bind( for ( B:Pbind  _:Guard ){ _:ProcPat } ) => B
  rule #bind( for ( B:Pbinds _:Guard ){ _:ProcPat } ) => B
  rule #bind( for ( B:Rbind  ){ _:ProcPat } ) => B
  rule #bind( for ( B:Rbinds ){ _:ProcPat } ) => B
  rule #bind( for ( B:Rbind  _:Guard ){ _:ProcPat } ) => B
  rule #bind( for ( B:Rbinds _:Guard ){ _:ProcPat } ) => B
  rule #bind( for ( B:LbindPat  ){ _:Proc } ) => B
  rule #bind( for ( B:LbindPats ){ _:Proc } ) => B
  rule #bind( for ( B:LbindPat  _:Guard ){ _:Proc } ) => B
  rule #bind( for ( B:LbindPats _:Guard ){ _:Proc } ) => B
  rule #bind( for ( B:PbindPat  ){ _:Proc } ) => B
  rule #bind( for ( B:PbindPats ){ _:Proc } ) => B
  rule #bind( for ( B:PbindPat  _:Guard ){ _:Proc } ) => B
  rule #bind( for ( B:PbindPats _:Guard ){ _:Proc } ) => B
  rule #bind( for ( B:RbindPat  ){ _:Proc } ) => B
  rule #bind( for ( B:RbindPats ){ _:Proc } ) => B
  rule #bind( for ( B:RbindPat  _:Guard ){ _:Proc } ) => B
  rule #bind( for ( B:RbindPats _:Guard ){ _:Proc } ) => B
  rule #bind( for ( B:LbindPat  ){ _:ProcPat } ) => B
  rule #bind( for ( B:LbindPats ){ _:ProcPat } ) => B
  rule #bind( for ( B:LbindPat  _:Guard ){ _:ProcPat } ) => B
  rule #bind( for ( B:LbindPats _:Guard ){ _:ProcPat } ) => B
  rule #bind( for ( B:PbindPat  ){ _:ProcPat } ) => B
  rule #bind( for ( B:PbindPats ){ _:ProcPat } ) => B
  rule #bind( for ( B:PbindPat  _:Guard ){ _:ProcPat } ) => B
  rule #bind( for ( B:PbindPats _:Guard ){ _:ProcPat } ) => B
  rule #bind( for ( B:RbindPat  ){ _:ProcPat } ) => B
  rule #bind( for ( B:RbindPats ){ _:ProcPat } ) => B
  rule #bind( for ( B:RbindPat  _:Guard ){ _:ProcPat } ) => B
  rule #bind( for ( B:RbindPats _:Guard ){ _:ProcPat } ) => B

  rule #bvar( for ( B:Lbind  ){ _:Proc } ) => #bvar(B)
  rule #bvar( for ( B:Lbinds ){ _:Proc } ) => #bvar(B)
  rule #bvar( for ( B:Lbind  _:Guard ){ _:Proc } ) => #bvar(B)
  rule #bvar( for ( B:Lbinds _:Guard ){ _:Proc } ) => #bvar(B)
  rule #bvar( for ( B:Pbind  ){ _:Proc } ) => #bvar(B)
  rule #bvar( for ( B:Pbinds ){ _:Proc } ) => #bvar(B)
  rule #bvar( for ( B:Pbind  _:Guard ){ _:Proc } ) => #bvar(B)
  rule #bvar( for ( B:Pbinds _:Guard ){ _:Proc } ) => #bvar(B)
  rule #bvar( for ( B:Rbind  ){ _:Proc } ) => #bvar(B)
  rule #bvar( for ( B:Rbinds ){ _:Proc } ) => #bvar(B)
  rule #bvar( for ( B:Rbind  _:Guard ){ _:Proc } ) => #bvar(B)
  rule #bvar( for ( B:Rbinds _:Guard ){ _:Proc } ) => #bvar(B)
  rule #bvar( for ( B:Lbind  ){ _:ProcPat } ) => #bvar(B)
  rule #bvar( for ( B:Lbinds ){ _:ProcPat } ) => #bvar(B)
  rule #bvar( for ( B:Lbind  _:Guard ){ _:ProcPat } ) => #bvar(B)
  rule #bvar( for ( B:Lbinds _:Guard ){ _:ProcPat } ) => #bvar(B)
  rule #bvar( for ( B:Pbind  ){ _:ProcPat } ) => #bvar(B)
  rule #bvar( for ( B:Pbinds ){ _:ProcPat } ) => #bvar(B)
  rule #bvar( for ( B:Pbind  _:Guard ){ _:ProcPat } ) => #bvar(B)
  rule #bvar( for ( B:Pbinds _:Guard ){ _:ProcPat } ) => #bvar(B)
  rule #bvar( for ( B:Rbind  ){ _:ProcPat } ) => #bvar(B)
  rule #bvar( for ( B:Rbinds ){ _:ProcPat } ) => #bvar(B)
  rule #bvar( for ( B:Rbind  _:Guard ){ _:ProcPat } ) => #bvar(B)
  rule #bvar( for ( B:Rbinds _:Guard ){ _:ProcPat } ) => #bvar(B)
  rule #bvar( for ( B:LbindPat  ){ _:Proc } ) => #bvar(B)
  rule #bvar( for ( B:LbindPats ){ _:Proc } ) => #bvar(B)
  rule #bvar( for ( B:LbindPat  _:Guard ){ _:Proc } ) => #bvar(B)
  rule #bvar( for ( B:LbindPats _:Guard ){ _:Proc } ) => #bvar(B)
  rule #bvar( for ( B:PbindPat  ){ _:Proc } ) => #bvar(B)
  rule #bvar( for ( B:PbindPats ){ _:Proc } ) => #bvar(B)
  rule #bvar( for ( B:PbindPat  _:Guard ){ _:Proc } ) => #bvar(B)
  rule #bvar( for ( B:PbindPats _:Guard ){ _:Proc } ) => #bvar(B)
  rule #bvar( for ( B:RbindPat  ){ _:Proc } ) => #bvar(B)
  rule #bvar( for ( B:RbindPats ){ _:Proc } ) => #bvar(B)
  rule #bvar( for ( B:RbindPat  _:Guard ){ _:Proc } ) => #bvar(B)
  rule #bvar( for ( B:RbindPats _:Guard ){ _:Proc } ) => #bvar(B)
  rule #bvar( for ( B:LbindPat  ){ _:ProcPat } ) => #bvar(B)
  rule #bvar( for ( B:LbindPats ){ _:ProcPat } ) => #bvar(B)
  rule #bvar( for ( B:LbindPat  _:Guard ){ _:ProcPat } ) => #bvar(B)
  rule #bvar( for ( B:LbindPats _:Guard ){ _:ProcPat } ) => #bvar(B)
  rule #bvar( for ( B:PbindPat  ){ _:ProcPat } ) => #bvar(B)
  rule #bvar( for ( B:PbindPats ){ _:ProcPat } ) => #bvar(B)
  rule #bvar( for ( B:PbindPat  _:Guard ){ _:ProcPat } ) => #bvar(B)
  rule #bvar( for ( B:PbindPats _:Guard ){ _:ProcPat } ) => #bvar(B)
  rule #bvar( for ( B:RbindPat  ){ _:ProcPat } ) => #bvar(B)
  rule #bvar( for ( B:RbindPats ){ _:ProcPat } ) => #bvar(B)
  rule #bvar( for ( B:RbindPat  _:Guard ){ _:ProcPat } ) => #bvar(B)
  rule #bvar( for ( B:RbindPats _:Guard ){ _:ProcPat } ) => #bvar(B)

  rule #chan( for ( B:Lbind  ){ _:Proc } ) => #chan(B)
  rule #chan( for ( B:Lbinds ){ _:Proc } ) => #chan(B)
  rule #chan( for ( B:Lbind  _:Guard ){ _:Proc } ) => #chan(B)
  rule #chan( for ( B:Lbinds _:Guard ){ _:Proc } ) => #chan(B)
  rule #chan( for ( B:Pbind  ){ _:Proc } ) => #chan(B)
  rule #chan( for ( B:Pbinds ){ _:Proc } ) => #chan(B)
  rule #chan( for ( B:Pbind  _:Guard ){ _:Proc } ) => #chan(B)
  rule #chan( for ( B:Pbinds _:Guard ){ _:Proc } ) => #chan(B)
  rule #chan( for ( B:Rbind  ){ _:Proc } ) => #chan(B)
  rule #chan( for ( B:Rbinds ){ _:Proc } ) => #chan(B)
  rule #chan( for ( B:Rbind  _:Guard ){ _:Proc } ) => #chan(B)
  rule #chan( for ( B:Rbinds _:Guard ){ _:Proc } ) => #chan(B)
  rule #chan( for ( B:Lbind  ){ _:ProcPat } ) => #chan(B)
  rule #chan( for ( B:Lbinds ){ _:ProcPat } ) => #chan(B)
  rule #chan( for ( B:Lbind  _:Guard ){ _:ProcPat } ) => #chan(B)
  rule #chan( for ( B:Lbinds _:Guard ){ _:ProcPat } ) => #chan(B)
  rule #chan( for ( B:Pbind  ){ _:ProcPat } ) => #chan(B)
  rule #chan( for ( B:Pbinds ){ _:ProcPat } ) => #chan(B)
  rule #chan( for ( B:Pbind  _:Guard ){ _:ProcPat } ) => #chan(B)
  rule #chan( for ( B:Pbinds _:Guard ){ _:ProcPat } ) => #chan(B)
  rule #chan( for ( B:Rbind  ){ _:ProcPat } ) => #chan(B)
  rule #chan( for ( B:Rbinds ){ _:ProcPat } ) => #chan(B)
  rule #chan( for ( B:Rbind  _:Guard ){ _:ProcPat } ) => #chan(B)
  rule #chan( for ( B:Rbinds _:Guard ){ _:ProcPat } ) => #chan(B)
  rule #chan( for ( B:LbindPat  ){ _:Proc } ) => #chan(B)
  rule #chan( for ( B:LbindPats ){ _:Proc } ) => #chan(B)
  rule #chan( for ( B:LbindPat  _:Guard ){ _:Proc } ) => #chan(B)
  rule #chan( for ( B:LbindPats _:Guard ){ _:Proc } ) => #chan(B)
  rule #chan( for ( B:PbindPat  ){ _:Proc } ) => #chan(B)
  rule #chan( for ( B:PbindPats ){ _:Proc } ) => #chan(B)
  rule #chan( for ( B:PbindPat  _:Guard ){ _:Proc } ) => #chan(B)
  rule #chan( for ( B:PbindPats _:Guard ){ _:Proc } ) => #chan(B)
  rule #chan( for ( B:RbindPat  ){ _:Proc } ) => #chan(B)
  rule #chan( for ( B:RbindPats ){ _:Proc } ) => #chan(B)
  rule #chan( for ( B:RbindPat  _:Guard ){ _:Proc } ) => #chan(B)
  rule #chan( for ( B:RbindPats _:Guard ){ _:Proc } ) => #chan(B)
  rule #chan( for ( B:LbindPat  ){ _:ProcPat } ) => #chan(B)
  rule #chan( for ( B:LbindPats ){ _:ProcPat } ) => #chan(B)
  rule #chan( for ( B:LbindPat  _:Guard ){ _:ProcPat } ) => #chan(B)
  rule #chan( for ( B:LbindPats _:Guard ){ _:ProcPat } ) => #chan(B)
  rule #chan( for ( B:PbindPat  ){ _:ProcPat } ) => #chan(B)
  rule #chan( for ( B:PbindPats ){ _:ProcPat } ) => #chan(B)
  rule #chan( for ( B:PbindPat  _:Guard ){ _:ProcPat } ) => #chan(B)
  rule #chan( for ( B:PbindPats _:Guard ){ _:ProcPat } ) => #chan(B)
  rule #chan( for ( B:RbindPat  ){ _:ProcPat } ) => #chan(B)
  rule #chan( for ( B:RbindPats ){ _:ProcPat } ) => #chan(B)
  rule #chan( for ( B:RbindPat  _:Guard ){ _:ProcPat } ) => #chan(B)
  rule #chan( for ( B:RbindPats _:Guard ){ _:ProcPat } ) => #chan(B)

  rule #cont( for ( _:Lbind  ){ P:Proc } ) => P
  rule #cont( for ( _:Lbinds ){ P:Proc } ) => P
  rule #cont( for ( _:Lbind  _:Guard ){ P:Proc } ) => P
  rule #cont( for ( _:Lbinds _:Guard ){ P:Proc } ) => P
  rule #cont( for ( _:Pbind  ){ P:Proc } ) => P
  rule #cont( for ( _:Pbinds ){ P:Proc } ) => P
  rule #cont( for ( _:Pbind  _:Guard ){ P:Proc } ) => P
  rule #cont( for ( _:Pbinds _:Guard ){ P:Proc } ) => P
  rule #cont( for ( _:Rbind  ){ P:Proc } ) => P
  rule #cont( for ( _:Rbinds ){ P:Proc } ) => P
  rule #cont( for ( _:Rbind  _:Guard ){ P:Proc } ) => P
  rule #cont( for ( _:Rbinds _:Guard ){ P:Proc } ) => P
  rule #cont( for ( _:Lbind  ){ P:ProcPat } ) => P
  rule #cont( for ( _:Lbinds ){ P:ProcPat } ) => P
  rule #cont( for ( _:Lbind  _:Guard ){ P:ProcPat } ) => P
  rule #cont( for ( _:Lbinds _:Guard ){ P:ProcPat } ) => P
  rule #cont( for ( _:Pbind  ){ P:ProcPat } ) => P
  rule #cont( for ( _:Pbinds ){ P:ProcPat } ) => P
  rule #cont( for ( _:Pbind  _:Guard ){ P:ProcPat } ) => P
  rule #cont( for ( _:Pbinds _:Guard ){ P:ProcPat } ) => P
  rule #cont( for ( _:Rbind  ){ P:ProcPat } ) => P
  rule #cont( for ( _:Rbinds ){ P:ProcPat } ) => P
  rule #cont( for ( _:Rbind  _:Guard ){ P:ProcPat } ) => P
  rule #cont( for ( _:Rbinds _:Guard ){ P:ProcPat } ) => P
  rule #cont( for ( _:LbindPat  ){ P:Proc } ) => P
  rule #cont( for ( _:LbindPats ){ P:Proc } ) => P
  rule #cont( for ( _:LbindPat  _:Guard ){ P:Proc } ) => P
  rule #cont( for ( _:LbindPats _:Guard ){ P:Proc } ) => P
  rule #cont( for ( _:PbindPat  ){ P:Proc } ) => P
  rule #cont( for ( _:PbindPats ){ P:Proc } ) => P
  rule #cont( for ( _:PbindPat  _:Guard ){ P:Proc } ) => P
  rule #cont( for ( _:PbindPats _:Guard ){ P:Proc } ) => P
  rule #cont( for ( _:RbindPat  ){ P:Proc } ) => P
  rule #cont( for ( _:RbindPats ){ P:Proc } ) => P
  rule #cont( for ( _:RbindPat  _:Guard ){ P:Proc } ) => P
  rule #cont( for ( _:RbindPats _:Guard ){ P:Proc } ) => P
  rule #cont( for ( _:LbindPat  ){ P:ProcPat } ) => P
  rule #cont( for ( _:LbindPats ){ P:ProcPat } ) => P
  rule #cont( for ( _:LbindPat  _:Guard ){ P:ProcPat } ) => P
  rule #cont( for ( _:LbindPats _:Guard ){ P:ProcPat } ) => P
  rule #cont( for ( _:PbindPat  ){ P:ProcPat } ) => P
  rule #cont( for ( _:PbindPats ){ P:ProcPat } ) => P
  rule #cont( for ( _:PbindPat  _:Guard ){ P:ProcPat } ) => P
  rule #cont( for ( _:PbindPats _:Guard ){ P:ProcPat } ) => P
  rule #cont( for ( _:RbindPat  ){ P:ProcPat } ) => P
  rule #cont( for ( _:RbindPats ){ P:ProcPat } ) => P
  rule #cont( for ( _:RbindPat  _:Guard ){ P:ProcPat } ) => P
  rule #cont( for ( _:RbindPats _:Guard ){ P:ProcPat } ) => P

  rule #lislen( for ( B:Lbind  ){ _:Proc } ) => #lislen(B)
  rule #lislen( for ( B:Lbinds ){ _:Proc } ) => #length(B)
  rule #lislen( for ( B:Lbind  _:Guard ){ _:Proc } ) => #lislen(B)
  rule #lislen( for ( B:Lbinds _:Guard ){ _:Proc } ) => #length(B)
  rule #lislen( for ( B:Pbind  ){ _:Proc } ) => #lislen(B)
  rule #lislen( for ( B:Pbinds ){ _:Proc } ) => #length(B)
  rule #lislen( for ( B:Pbind  _:Guard ){ _:Proc } ) => #lislen(B)
  rule #lislen( for ( B:Pbinds _:Guard ){ _:Proc } ) => #length(B)
  rule #lislen( for ( B:Rbind  ){ _:Proc } ) => #lislen(B)
  rule #lislen( for ( B:Rbinds ){ _:Proc } ) => #length(B)
  rule #lislen( for ( B:Rbind  _:Guard ){ _:Proc } ) => #lislen(B)
  rule #lislen( for ( B:Rbinds _:Guard ){ _:Proc } ) => #length(B)
  rule #lislen( for ( B:Lbind  ){ _:ProcPat } ) => #lislen(B)
  rule #lislen( for ( B:Lbinds ){ _:ProcPat } ) => #length(B)
  rule #lislen( for ( B:Lbind  _:Guard ){ _:ProcPat } ) => #lislen(B)
  rule #lislen( for ( B:Lbinds _:Guard ){ _:ProcPat } ) => #length(B)
  rule #lislen( for ( B:Pbind  ){ _:ProcPat } ) => #lislen(B)
  rule #lislen( for ( B:Pbinds ){ _:ProcPat } ) => #length(B)
  rule #lislen( for ( B:Pbind  _:Guard ){ _:ProcPat } ) => #lislen(B)
  rule #lislen( for ( B:Pbinds _:Guard ){ _:ProcPat } ) => #length(B)
  rule #lislen( for ( B:Rbind  ){ _:ProcPat } ) => #lislen(B)
  rule #lislen( for ( B:Rbinds ){ _:ProcPat } ) => #length(B)
  rule #lislen( for ( B:Rbind  _:Guard ){ _:ProcPat } ) => #lislen(B)
  rule #lislen( for ( B:Rbinds _:Guard ){ _:ProcPat } ) => #length(B)
  rule #lislen( for ( B:LbindPat  ){ _:Proc } ) => #lislen(B)
  rule #lislen( for ( B:LbindPats ){ _:Proc } ) => #length(B)
  rule #lislen( for ( B:LbindPat  _:Guard ){ _:Proc } ) => #lislen(B)
  rule #lislen( for ( B:LbindPats _:Guard ){ _:Proc } ) => #length(B)
  rule #lislen( for ( B:PbindPat  ){ _:Proc } ) => #lislen(B)
  rule #lislen( for ( B:PbindPats ){ _:Proc } ) => #length(B)
  rule #lislen( for ( B:PbindPat  _:Guard ){ _:Proc } ) => #lislen(B)
  rule #lislen( for ( B:PbindPats _:Guard ){ _:Proc } ) => #length(B)
  rule #lislen( for ( B:RbindPat  ){ _:Proc } ) => #lislen(B)
  rule #lislen( for ( B:RbindPats ){ _:Proc } ) => #length(B)
  rule #lislen( for ( B:RbindPat  _:Guard ){ _:Proc } ) => #lislen(B)
  rule #lislen( for ( B:RbindPats _:Guard ){ _:Proc } ) => #length(B)
  rule #lislen( for ( B:LbindPat  ){ _:ProcPat } ) => #lislen(B)
  rule #lislen( for ( B:LbindPats ){ _:ProcPat } ) => #length(B)
  rule #lislen( for ( B:LbindPat  _:Guard ){ _:ProcPat } ) => #lislen(B)
  rule #lislen( for ( B:LbindPats _:Guard ){ _:ProcPat } ) => #length(B)
  rule #lislen( for ( B:PbindPat  ){ _:ProcPat } ) => #lislen(B)
  rule #lislen( for ( B:PbindPats ){ _:ProcPat } ) => #length(B)
  rule #lislen( for ( B:PbindPat  _:Guard ){ _:ProcPat } ) => #lislen(B)
  rule #lislen( for ( B:PbindPats _:Guard ){ _:ProcPat } ) => #length(B)
  rule #lislen( for ( B:RbindPat  ){ _:ProcPat } ) => #lislen(B)
  rule #lislen( for ( B:RbindPats ){ _:ProcPat } ) => #length(B)
  rule #lislen( for ( B:RbindPat  _:Guard ){ _:ProcPat } ) => #lislen(B)
  rule #lislen( for ( B:RbindPats _:Guard ){ _:ProcPat } ) => #length(B)

// receive types - receive
  rule #rtype( _:LinearSRec     ) => 0
  rule #rtype( _:GLinearSRec    ) => 0
  rule #rtype( _:LinearMRec     ) => 0
  rule #rtype( _:GLinearMRec    ) => 0
  rule #rtype( _:LinearSRecPat  ) => 0
  rule #rtype( _:GLinearSRecPat ) => 0
  rule #rtype( _:LinearMRecPat  ) => 0
  rule #rtype( _:GLinearMRecPat ) => 0
  rule #rtype( _:RepeatSRec     ) => 1
  rule #rtype( _:GRepeatSRec    ) => 1
  rule #rtype( _:RepeatMRec     ) => 1
  rule #rtype( _:GRepeatMRec    ) => 1
  rule #rtype( _:RepeatSRecPat  ) => 1
  rule #rtype( _:GRepeatSRecPat ) => 1
  rule #rtype( _:RepeatMRecPat  ) => 1
  rule #rtype( _:GRepeatMRecPat ) => 1
  rule #rtype( _:PeekSRec       ) => 2
  rule #rtype( _:GPeekSRec      ) => 2
  rule #rtype( _:PeekMRec       ) => 2
  rule #rtype( _:GPeekMRec      ) => 2
  rule #rtype( _:PeekSRecPat    ) => 2
  rule #rtype( _:GPeekSRecPat   ) => 2
  rule #rtype( _:PeekMRecPat    ) => 2
  rule #rtype( _:GPeekMRecPat   ) => 2

  rule #rtype( _:Lbind  ) => 0
  rule #rtype( _:Lbinds ) => 0
  rule #rtype( _:Lbind  _:Guard ) => 0
  rule #rtype( _:Lbinds _:Guard ) => 0
  rule #rtype( _:LbindPat  ) => 0
  rule #rtype( _:LbindPats ) => 0
  rule #rtype( _:LbindPat  _:Guard ) => 0
  rule #rtype( _:LbindPats _:Guard ) => 0
  rule #rtype( _:Rbind  ) => 1
  rule #rtype( _:Rbinds ) => 1
  rule #rtype( _:Rbind  _:Guard ) => 1
  rule #rtype( _:Rbinds _:Guard ) => 1
  rule #rtype( _:RbindPat  ) => 1
  rule #rtype( _:RbindPats ) => 1
  rule #rtype( _:RbindPat  _:Guard ) => 1
  rule #rtype( _:RbindPats _:Guard ) => 1
  rule #rtype( _:Pbind  ) => 2
  rule #rtype( _:Pbinds ) => 2
  rule #rtype( _:Pbind  _:Guard ) => 2
  rule #rtype( _:Pbinds _:Guard ) => 2
  rule #rtype( _:PbindPat  ) => 2
  rule #rtype( _:PbindPats ) => 2
  rule #rtype( _:PbindPat  _:Guard ) => 2
  rule #rtype( _:PbindPats _:Guard ) => 2

// Guards
  rule #guard( _:UGSRec ) => true
  rule #guard( _:UGMRec ) => true
  rule #guard( for( _:Lbind     if G:BExp ){ _:Proc } ) => G
  rule #guard( for( _:Pbind     if G:BExp ){ _:Proc } ) => G
  rule #guard( for( _:Rbind     if G:BExp ){ _:Proc } ) => G
  rule #guard( for( _:Lbinds    if G:BExp ){ _:Proc } ) => G
  rule #guard( for( _:Pbinds    if G:BExp ){ _:Proc } ) => G
  rule #guard( for( _:Rbinds    if G:BExp ){ _:Proc } ) => G
  rule #guard( for( _:Lbind     if G:BExp ){ _:ProcPat } ) => G
  rule #guard( for( _:Pbind     if G:BExp ){ _:ProcPat } ) => G
  rule #guard( for( _:Rbind     if G:BExp ){ _:ProcPat } ) => G
  rule #guard( for( _:Lbinds    if G:BExp ){ _:ProcPat } ) => G
  rule #guard( for( _:Pbinds    if G:BExp ){ _:ProcPat } ) => G
  rule #guard( for( _:Rbinds    if G:BExp ){ _:ProcPat } ) => G
  rule #guard( for( _:LbindPat  if G:BExp ){ _:Proc } ) => G
  rule #guard( for( _:PbindPat  if G:BExp ){ _:Proc } ) => G
  rule #guard( for( _:RbindPat  if G:BExp ){ _:Proc } ) => G
  rule #guard( for( _:LbindPats if G:BExp ){ _:Proc } ) => G
  rule #guard( for( _:PbindPats if G:BExp ){ _:Proc } ) => G
  rule #guard( for( _:RbindPats if G:BExp ){ _:Proc } ) => G
  rule #guard( for( _:LbindPat  if G:BExp ){ _:ProcPat } ) => G
  rule #guard( for( _:PbindPat  if G:BExp ){ _:ProcPat } ) => G
  rule #guard( for( _:RbindPat  if G:BExp ){ _:ProcPat } ) => G
  rule #guard( for( _:LbindPats if G:BExp ){ _:ProcPat } ) => G
  rule #guard( for( _:PbindPats if G:BExp ){ _:ProcPat } ) => G
  rule #guard( for( _:RbindPats if G:BExp ){ _:ProcPat } ) => G
  rule #guard( _:Lbind     if G:BExp ) => G
  rule #guard( _:Pbind     if G:BExp ) => G
  rule #guard( _:Rbind     if G:BExp ) => G
  rule #guard( _:Lbinds    if G:BExp ) => G
  rule #guard( _:Pbinds    if G:BExp ) => G
  rule #guard( _:Rbinds    if G:BExp ) => G
  rule #guard( _:LbindPat  if G:BExp ) => G
  rule #guard( _:PbindPat  if G:BExp ) => G
  rule #guard( _:RbindPat  if G:BExp ) => G
  rule #guard( _:LbindPats if G:BExp ) => G
  rule #guard( _:PbindPats if G:BExp ) => G
  rule #guard( _:RbindPats if G:BExp ) => G

//---------------
//--- #append ---
//---------------
// Names
  rule #append( A:Name           ; B:Name  ) => A,B
  rule #append( A:Name           ; B:Names ) => A,B
  rule #append( A:Name , B:Name  ; C:Name  ) => A,#append(B;C)
  rule #append( A:Name , B:Name  ; C:Names ) => A,#append(B;C)
  rule #append( A:Name , B:Names ; C:Name  ) => A,#append(B;C)
  rule #append( A:Name , B:Names ; C:Names ) => A,#append(B;C)

// NamePats
  rule #append( A:Name                 ; B:NamePat  ) => A,B
  rule #append( A:NamePat              ; B:Name     ) => A,B
  rule #append( A:NamePat              ; B:NamePat  ) => A,B
  rule #append( A:Name                 ; B:NamePats ) => A,B
  rule #append( A:NamePat              ; B:Names    ) => A,B
  rule #append( A:NamePat              ; B:NamePats ) => A,B
  rule #append( A:Name    , B:Name     ; C:NamePat  ) => A,#append(B;C)
  rule #append( A:Name    , B:Name     ; C:NamePats ) => A,#append(B;C)
  rule #append( A:Name    , B:Names    ; C:NamePat  ) => A,#append(B;C)
  rule #append( A:Name    , B:Names    ; C:NamePats ) => A,#append(B;C)
  rule #append( A:Name    , B:NamePat  ; C:Name     ) => A,#append(B;C)
  rule #append( A:Name    , B:NamePat  ; C:Names    ) => A,#append(B;C)
  rule #append( A:Name    , B:NamePat  ; C:NamePat  ) => A,#append(B;C)
  rule #append( A:Name    , B:NamePat  ; C:NamePats ) => A,#append(B;C)
  rule #append( A:NamePat , B:Name     ; C:Name     ) => A,#append(B;C)
  rule #append( A:NamePat , B:Name     ; C:Names    ) => A,#append(B;C)
  rule #append( A:NamePat , B:Name     ; C:NamePat  ) => A,#append(B;C)
  rule #append( A:NamePat , B:Name     ; C:NamePats ) => A,#append(B;C)
  rule #append( A:NamePat , B:NamePat  ; C:Name     ) => A,#append(B;C)
  rule #append( A:NamePat , B:NamePat  ; C:Names    ) => A,#append(B;C)
  rule #append( A:NamePat , B:NamePat  ; C:NamePat  ) => A,#append(B;C)
  rule #append( A:NamePat , B:NamePat  ; C:NamePats ) => A,#append(B;C)
  rule #append( A:Name    , B:NamePats ; C:Name     ) => A,#append(B;C)
  rule #append( A:Name    , B:NamePats ; C:Names    ) => A,#append(B;C)
  rule #append( A:Name    , B:NamePats ; C:NamePat  ) => A,#append(B;C)
  rule #append( A:Name    , B:NamePats ; C:NamePats ) => A,#append(B;C)
  rule #append( A:NamePat , B:NamePats ; C:Name     ) => A,#append(B;C)
  rule #append( A:NamePat , B:NamePats ; C:Names    ) => A,#append(B;C)
  rule #append( A:NamePat , B:NamePats ; C:NamePat  ) => A,#append(B;C)
  rule #append( A:NamePat , B:NamePats ; C:NamePats ) => A,#append(B;C)


// Procs
  rule #append( A:Proc           ; B:Proc  ) => A,B
  rule #append( A:Proc           ; B:Procs ) => A,B
  rule #append( A:Proc , B:Proc  ; C:Proc  ) => A,#append(B;C)
  rule #append( A:Proc , B:Proc  ; C:Procs ) => A,#append(B;C)
  rule #append( A:Proc , B:Procs ; C:Proc  ) => A,#append(B;C)
  rule #append( A:Proc , B:Procs ; C:Procs ) => A,#append(B;C)

// ProcPats
  rule #append( A:Proc                 ; B:ProcPat  ) => A,B
  rule #append( A:ProcPat              ; B:Proc     ) => A,B
  rule #append( A:ProcPat              ; B:ProcPat  ) => A,B
  rule #append( A:Proc                 ; B:ProcPats ) => A,B
  rule #append( A:ProcPat              ; B:Procs    ) => A,B
  rule #append( A:ProcPat              ; B:ProcPats ) => A,B
  rule #append( A:Proc    , B:Proc     ; C:ProcPat  ) => A,#append(B;C)
  rule #append( A:Proc    , B:Proc     ; C:ProcPats ) => A,#append(B;C)
  rule #append( A:Proc    , B:Procs    ; C:ProcPat  ) => A,#append(B;C)
  rule #append( A:Proc    , B:Procs    ; C:ProcPats ) => A,#append(B;C)
  rule #append( A:Proc    , B:ProcPat  ; C:Proc     ) => A,#append(B;C)
  rule #append( A:Proc    , B:ProcPat  ; C:Procs    ) => A,#append(B;C)
  rule #append( A:Proc    , B:ProcPat  ; C:ProcPat  ) => A,#append(B;C)
  rule #append( A:Proc    , B:ProcPat  ; C:ProcPats ) => A,#append(B;C)
  rule #append( A:ProcPat , B:Proc     ; C:Proc     ) => A,#append(B;C)
  rule #append( A:ProcPat , B:Proc     ; C:Procs    ) => A,#append(B;C)
  rule #append( A:ProcPat , B:Proc     ; C:ProcPat  ) => A,#append(B;C)
  rule #append( A:ProcPat , B:Proc     ; C:ProcPats ) => A,#append(B;C)
  rule #append( A:ProcPat , B:ProcPat  ; C:Proc     ) => A,#append(B;C)
  rule #append( A:ProcPat , B:ProcPat  ; C:Procs    ) => A,#append(B;C)
  rule #append( A:ProcPat , B:ProcPat  ; C:ProcPat  ) => A,#append(B;C)
  rule #append( A:ProcPat , B:ProcPat  ; C:ProcPats ) => A,#append(B;C)
  rule #append( A:Proc    , B:ProcPats ; C:Proc     ) => A,#append(B;C)
  rule #append( A:Proc    , B:ProcPats ; C:Procs    ) => A,#append(B;C)
  rule #append( A:Proc    , B:ProcPats ; C:ProcPat  ) => A,#append(B;C)
  rule #append( A:Proc    , B:ProcPats ; C:ProcPats ) => A,#append(B;C)
  rule #append( A:ProcPat , B:ProcPats ; C:Proc     ) => A,#append(B;C)
  rule #append( A:ProcPat , B:ProcPats ; C:Procs    ) => A,#append(B;C)
  rule #append( A:ProcPat , B:ProcPats ; C:ProcPat  ) => A,#append(B;C)
  rule #append( A:ProcPat , B:ProcPats ; C:ProcPats ) => A,#append(B;C)

// RhoKVPairs
  rule #append( A:RhoKVPair ; B:RhoKVPair  ) => A,B
  rule #append( A:RhoKVPair ; B:RhoKVPairs ) => A,B
  rule #append( A:RhoKVPair , B:RhoKVPair  ; C:RhoKVPair  ) => A,#append(B;C)
  rule #append( A:RhoKVPair , B:RhoKVPairs ; C:RhoKVPair  ) => A,#append(B;C)
  rule #append( A:RhoKVPair , B:RhoKVPair  ; C:RhoKVPairs ) => A,#append(B;C)
  rule #append( A:RhoKVPair , B:RhoKVPairs ; C:RhoKVPairs ) => A,#append(B;C)

//-----------
//--- #in ---
//-----------
// Int #in RhoTuple
  rule A:Int #in ( B:Int           ) => A ==Int B
  rule A:Int #in ( B:Int , C:Int   ) => A ==Int B orBool A ==Int C
  rule A:Int #in ( B:Int , C:Procs ) => A ==Int B orBool A #in (C)

// Name #in Names
  rule _:Name #in ( EmptyN           ) => false
  rule A:Name #in ( B:Name           ) => A ==K B requires B =/=K EmptyN
  rule A:Name #in ( B:Name , C:Name  ) => A ==K B orBool A ==K C
  rule A:Name #in ( B:Name , C:Names ) => A ==K B orBool A #in (C)

//------------
//--- #dec ---
//------------
// New name declarations
  // New
  rule #dec( new A:Name  in { _:Proc } ) => A
  rule #dec( new A:Names in { _:Proc } ) => A
  // NewPat
  rule #dec( new A:Name  in { _:ProcPat } ) => A
  rule #dec( new A:Names in { _:ProcPat } ) => A

//-------------
//--- #size ---
//-------------
  rule #size( Set( ) ) => 0
  rule #size( Set( P:Proc  ) ) => #length(P)
  rule #size( Set( P:Procs ) ) => #length(P)
  
  rule #size( { } ) => 0
  rule #size( { _:Proc : _:Proc } ) => 1
  rule #size( { _:Proc : _:Proc , _:RhoKVPair  } ) => 2
  rule #size( { _:Proc : _:Proc , R:RhoKVPairs } ) => 1 +Int #size({R})

//---------------
//--- #length ---
//---------------
// Procs
  rule #length( EmptyP ) => 0
  rule #length( A:Proc ) => 1 requires A =/=K EmptyP
  rule #length( _:Proc , _:Proc  ) => 2
  rule #length( _:Proc , P:Procs ) => 1 +Int #length(P)

// ProcPats
  rule #length( _:ProcPat ) => 1
  rule #length( _:Proc    , _:ProcPat  ) => 2
  rule #length( _:ProcPat , _:Proc     ) => 2
  rule #length( _:ProcPat , _:ProcPat  ) => 2
  rule #length( _:Proc    , P:ProcPats ) => 1 +Int #length(P)
  rule #length( _:ProcPat , P:ProcPats ) => 1 +Int #length(P)
  rule #length( _:ProcPat , P:Procs    ) => 1 +Int #length(P)

// RhoList
  rule #length( [ ] ) => 0
  rule #length( [ P:Proc     ] ) => #length(P)
  rule #length( [ P:Procs    ] ) => #length(P)
  rule #length( [ P:ProcPat  ] ) => #length(P)
  rule #length( [ P:ProcPats ] ) => #length(P)

// Names
  rule #length( EmptyN ) => 0
  rule #length( A:Name ) => 1 requires A =/=K EmptyN
  rule #length( _:Name , _:Name  ) => 2
  rule #length( _:Name , N:Names ) => 1 +Int #length(N)

// NamePats
  rule #length( _:NamePat ) => 1
  rule #length( _:Name    , _:NamePat  ) => 2
  rule #length( _:NamePat , _:Name     ) => 2
  rule #length( _:NamePat , _:NamePat  ) => 2
  rule #length( _:Name    , N:NamePats ) => 1 +Int #length(N)
  rule #length( _:NamePat , N:NamePats ) => 1 +Int #length(N)
  rule #length( _:NamePat , N:Names    ) => 1 +Int #length(N)

//--- Binds ---
// Binds - number of listens in a join
  // Lbinds
  rule #length( _:Lbind    ; _:Lbind     ) => 2
  rule #length( _:Lbind    ; C:Lbinds    ) => 1 +Int #length(C)
  // LbindPats
  rule #length( _:LbindPat ; _:LbindPat  ) => 2
  rule #length( _:LbindPat ; C:LbindPats ) => 1 +Int #length(C)
  // Pbinds
  rule #length( _:Pbind ; _:Pbind  ) => 2
  rule #length( _:Pbind ; C:Pbinds ) => 1 +Int #length(C)
  // PbindPats
  rule #length( _:PbindPat ; _:PbindPat  ) => 2
  rule #length( _:PbindPat ; C:PbindPats ) => 1 +Int #length(C)
  // Rbinds
  rule #length( _:Rbind ; _:Rbind  ) => 2
  rule #length( _:Rbind ; C:Rbinds ) => 1 +Int #length(C)
  // RbindPats
  rule #length( _:RbindPat ; _:RbindPat  ) => 2
  rule #length( _:RbindPat ; C:RbindPats ) => 1 +Int #length(C)
  // Guarded
  rule #length( B:Lbinds _:Guard ) => #length(B)
  rule #length( B:Pbinds _:Guard ) => #length(B)
  rule #length( B:Rbinds _:Guard ) => #length(B)
  rule #length( B:LbindPats _:Guard ) => #length(B)
  rule #length( B:PbindPats _:Guard ) => #length(B)
  rule #length( B:RbindPats _:Guard ) => #length(B)

//-------------
//--- #chan ---
//-------------
// Bind
  rule #chan(            <- N:Name ) => N
  rule #chan( _:Name     <- N:Name ) => N
  rule #chan( _:Names    <- N:Name ) => N
  rule #chan( _:NamePat  <- N:Name ) => N
  rule #chan( _:NamePats <- N:Name ) => N
  rule #chan(            <= N:Name ) => N
  rule #chan( _:Name     <= N:Name ) => N
  rule #chan( _:Names    <= N:Name ) => N
  rule #chan( _:NamePat  <= N:Name ) => N
  rule #chan( _:NamePats <= N:Name ) => N
  rule #chan(            <! N:Name ) => N
  rule #chan( _:Name     <! N:Name ) => N
  rule #chan( _:Names    <! N:Name ) => N
  rule #chan( _:NamePat  <! N:Name ) => N
  rule #chan( _:NamePats <! N:Name ) => N
  // Guraded
  rule #chan( B:Lbind _:Guard ) => #chan(B)
  rule #chan( B:Pbind _:Guard ) => #chan(B)
  rule #chan( B:Rbind _:Guard ) => #chan(B)

  // comma-separated list of channels involved in bindings
  rule #chan( B:Lbind ; C:Lbind  ) => #chan(B) , #chan(C)
  rule #chan( B:Lbind ; C:Lbinds ) => #chan(B) , #chan(C)
  rule #chan( B:Rbind ; C:Rbind  ) => #chan(B) , #chan(C)
  rule #chan( B:Rbind ; C:Rbinds ) => #chan(B) , #chan(C)
  rule #chan( B:Pbind ; C:Pbind  ) => #chan(B) , #chan(C)
  rule #chan( B:Pbind ; C:Pbinds ) => #chan(B) , #chan(C)
  
  rule #chan( B:Lbinds _:Guard ) => #chan(B)
  rule #chan( B:Pbinds _:Guard ) => #chan(B)
  rule #chan( B:Rbinds _:Guard ) => #chan(B)

// BindPat
  rule #chan(            <- N:NamePat ) => N
  rule #chan( _:Name     <- N:NamePat ) => N
  rule #chan( _:Names    <- N:NamePat ) => N
  rule #chan( _:NamePat  <- N:NamePat ) => N
  rule #chan( _:NamePats <- N:NamePat ) => N
  rule #chan(            <= N:NamePat ) => N
  rule #chan( _:Name     <= N:NamePat ) => N
  rule #chan( _:Names    <= N:NamePat ) => N
  rule #chan( _:NamePat  <= N:NamePat ) => N
  rule #chan( _:NamePats <= N:NamePat ) => N
  rule #chan(            <! N:NamePat ) => N
  rule #chan( _:Name     <! N:NamePat ) => N
  rule #chan( _:Names    <! N:NamePat ) => N
  rule #chan( _:NamePat  <! N:NamePat ) => N
  rule #chan( _:NamePats <! N:NamePat ) => N
  // Guraded
  rule #chan( B:LbindPat _:Guard ) => #chan(B)
  rule #chan( B:PbindPat _:Guard ) => #chan(B)
  rule #chan( B:RbindPat _:Guard ) => #chan(B)

  // comma-separated list of channels involved in bindings
  rule #chan( B:Lbind    ; C:LbindPat  ) => #chan(B) , #chan(C)
  rule #chan( B:LbindPat ; C:Lbind     ) => #chan(B) , #chan(C)
  rule #chan( B:LbindPat ; C:LbindPat  ) => #chan(B) , #chan(C)
  rule #chan( B:Lbind    ; C:LbindPats ) => #chan(B) , #chan(C)
  rule #chan( B:LbindPat ; C:Lbinds    ) => #chan(B) , #chan(C)
  rule #chan( B:Lbind    ; C:LbindPats ) => #chan(B) , #chan(C)
  rule #chan( B:LbindPat ; C:LbindPats ) => #chan(B) , #chan(C)
  rule #chan( B:Pbind    ; C:PbindPat  ) => #chan(B) , #chan(C)
  rule #chan( B:PbindPat ; C:Pbind     ) => #chan(B) , #chan(C)
  rule #chan( B:PbindPat ; C:PbindPat  ) => #chan(B) , #chan(C)
  rule #chan( B:Pbind    ; C:PbindPats ) => #chan(B) , #chan(C)
  rule #chan( B:PbindPat ; C:Pbinds    ) => #chan(B) , #chan(C)
  rule #chan( B:Pbind    ; C:PbindPats ) => #chan(B) , #chan(C)
  rule #chan( B:PbindPat ; C:PbindPats ) => #chan(B) , #chan(C)
  rule #chan( B:Rbind    ; C:RbindPat  ) => #chan(B) , #chan(C)
  rule #chan( B:RbindPat ; C:Rbind     ) => #chan(B) , #chan(C)
  rule #chan( B:RbindPat ; C:RbindPat  ) => #chan(B) , #chan(C)
  rule #chan( B:Rbind    ; C:RbindPats ) => #chan(B) , #chan(C)
  rule #chan( B:RbindPat ; C:Rbinds    ) => #chan(B) , #chan(C)
  rule #chan( B:Rbind    ; C:RbindPats ) => #chan(B) , #chan(C)
  rule #chan( B:RbindPat ; C:RbindPats ) => #chan(B) , #chan(C)
  // Guarded
  rule #chan( B:LbindPats _:Guard ) => #chan(B)
  rule #chan( B:PbindPats _:Guard ) => #chan(B)
  rule #chan( B:RbindPats _:Guard ) => #chan(B)

//-------------
//--- #lislen ---
//-------------
// number of binding variables in a listen
// Bind
  rule #lislen(            <- _:Name ) => 0
  rule #lislen( _:Name     <- _:Name ) => 1
  rule #lislen( N:Names    <- _:Name ) => #length(N)
  rule #lislen( _:NamePat  <- _:Name ) => 1
  rule #lislen( N:NamePats <- _:Name ) => #length(N)
  rule #lislen(            <= _:Name ) => 0
  rule #lislen( _:Name     <= _:Name ) => 1
  rule #lislen( N:Names    <= _:Name ) => #length(N)
  rule #lislen( _:NamePat  <= _:Name ) => 1
  rule #lislen( N:NamePats <= _:Name ) => #length(N)
  rule #lislen(            <! _:Name ) => 0
  rule #lislen( _:Name     <! _:Name ) => 1
  rule #lislen( N:Names    <! _:Name ) => #length(N)
  rule #lislen( _:NamePat  <! _:Name ) => 1
  rule #lislen( N:NamePats <! _:Name ) => #length(N)
  // Guraded
  rule #lislen( B:Lbind _:Guard ) => #lislen(B)
  rule #lislen( B:Pbind _:Guard ) => #lislen(B)
  rule #lislen( B:Rbind _:Guard ) => #lislen(B)
// BindPat
  rule #lislen(            <- _:NamePat ) => 0
  rule #lislen( _:Name     <- _:NamePat ) => 1
  rule #lislen( N:Names    <- _:NamePat ) => #length(N)
  rule #lislen( _:NamePat  <- _:NamePat ) => 1
  rule #lislen( N:NamePats <- _:NamePat ) => #length(N)
  rule #lislen(            <= _:NamePat ) => 0
  rule #lislen( _:Name     <= _:NamePat ) => 1
  rule #lislen( N:Names    <= _:NamePat ) => #length(N)
  rule #lislen( _:NamePat  <= _:NamePat ) => 1
  rule #lislen( N:NamePats <= _:NamePat ) => #length(N)
  rule #lislen(            <! _:NamePat ) => 0
  rule #lislen( _:Name     <! _:NamePat ) => 1
  rule #lislen( N:Names    <! _:NamePat ) => #length(N)
  rule #lislen( _:NamePat  <! _:NamePat ) => 1
  rule #lislen( N:NamePats <! _:NamePat ) => #length(N)
  // Guraded
  rule #lislen( B:LbindPat _:Guard ) => #lislen(B)
  rule #lislen( B:PbindPat _:Guard ) => #lislen(B)
  rule #lislen( B:RbindPat _:Guard ) => #lislen(B)

//-------------
//--- #bvar ---
//-------------
// binding variables
// Bind
  rule #bvar(            <- _:Name ) => EmptyN
  rule #bvar( N:Name     <- _:Name ) => N
  rule #bvar( N:Names    <- _:Name ) => N
  rule #bvar( N:NamePat  <- _:Name ) => N
  rule #bvar( N:NamePats <- _:Name ) => N
  rule #bvar(            <= _:Name ) => EmptyN
  rule #bvar( N:Name     <= _:Name ) => N
  rule #bvar( N:Names    <= _:Name ) => N
  rule #bvar( N:NamePat  <= _:Name ) => N
  rule #bvar( N:NamePats <= _:Name ) => N
  rule #bvar(            <! _:Name ) => EmptyN
  rule #bvar( N:Name     <! _:Name ) => N
  rule #bvar( N:Names    <! _:Name ) => N
  rule #bvar( N:NamePat  <! _:Name ) => N
  rule #bvar( N:NamePats <! _:Name ) => N
  // Guraded
  rule #bvar( B:Lbind _:Guard ) => #bvar(B)
  rule #bvar( B:Pbind _:Guard ) => #bvar(B)
  rule #bvar( B:Rbind _:Guard ) => #bvar(B)

// BindPat
  rule #bvar(            <- _:NamePat ) => EmptyN
  rule #bvar( N:Name     <- _:NamePat ) => N
  rule #bvar( N:Names    <- _:NamePat ) => N
  rule #bvar( N:NamePat  <- _:NamePat ) => N
  rule #bvar( N:NamePats <- _:NamePat ) => N
  rule #bvar(            <= _:NamePat ) => EmptyN
  rule #bvar( N:Name     <= _:NamePat ) => N
  rule #bvar( N:Names    <= _:NamePat ) => N
  rule #bvar( N:NamePat  <= _:NamePat ) => N
  rule #bvar( N:NamePats <= _:NamePat ) => N
  rule #bvar(            <! _:NamePat ) => EmptyN
  rule #bvar( N:Name     <! _:NamePat ) => N
  rule #bvar( N:Names    <! _:NamePat ) => N
  rule #bvar( N:NamePat  <! _:NamePat ) => N
  rule #bvar( N:NamePats <! _:NamePat ) => N
  // Guraded
  rule #bvar( B:LbindPat _:Guard ) => #bvar(B)
  rule #bvar( B:PbindPat _:Guard ) => #bvar(B)
  rule #bvar( B:RbindPat _:Guard ) => #bvar(B)

// Multiple Bindings
  rule #bvar( B:Lbind    ; C:Lbind     ) => #append(#bvar(B);#bvar(C))
  rule #bvar( B:Lbind    ; C:Lbinds    ) => #append(#bvar(B);#bvar(C))
  rule #bvar( B:Lbind    ; C:LbindPat  ) => #append(#bvar(B);#bvar(C))
  rule #bvar( B:Lbind    ; C:LbindPats ) => #append(#bvar(B);#bvar(C))
  rule #bvar( B:LbindPat ; C:Lbind     ) => #append(#bvar(B);#bvar(C))
  rule #bvar( B:LbindPat ; C:Lbinds    ) => #append(#bvar(B);#bvar(C))
  rule #bvar( B:LbindPat ; C:LbindPat  ) => #append(#bvar(B);#bvar(C))
  rule #bvar( B:LbindPat ; C:LbindPats ) => #append(#bvar(B);#bvar(C))
  rule #bvar( B:Pbind    ; C:Pbind     ) => #append(#bvar(B);#bvar(C))
  rule #bvar( B:Pbind    ; C:Pbinds    ) => #append(#bvar(B);#bvar(C))
  rule #bvar( B:Pbind    ; C:PbindPat  ) => #append(#bvar(B);#bvar(C))
  rule #bvar( B:Pbind    ; C:PbindPats ) => #append(#bvar(B);#bvar(C))
  rule #bvar( B:PbindPat ; C:Pbind     ) => #append(#bvar(B);#bvar(C))
  rule #bvar( B:PbindPat ; C:Pbinds    ) => #append(#bvar(B);#bvar(C))
  rule #bvar( B:PbindPat ; C:PbindPat  ) => #append(#bvar(B);#bvar(C))
  rule #bvar( B:PbindPat ; C:PbindPats ) => #append(#bvar(B);#bvar(C))
  rule #bvar( B:Rbind    ; C:Rbind     ) => #append(#bvar(B);#bvar(C))
  rule #bvar( B:Rbind    ; C:Rbinds    ) => #append(#bvar(B);#bvar(C))
  rule #bvar( B:Rbind    ; C:RbindPat  ) => #append(#bvar(B);#bvar(C))
  rule #bvar( B:Rbind    ; C:RbindPats ) => #append(#bvar(B);#bvar(C))
  rule #bvar( B:RbindPat ; C:Rbind     ) => #append(#bvar(B);#bvar(C))
  rule #bvar( B:RbindPat ; C:Rbinds    ) => #append(#bvar(B);#bvar(C))
  rule #bvar( B:RbindPat ; C:RbindPat  ) => #append(#bvar(B);#bvar(C))
  rule #bvar( B:RbindPat ; C:RbindPats ) => #append(#bvar(B);#bvar(C))
  
  rule #bvar( B:LbindPats _:Guard ) => #bvar(B)
  rule #bvar( B:PbindPats _:Guard ) => #bvar(B)
  rule #bvar( B:RbindPats _:Guard ) => #bvar(B)
  
//---------------
//--- #quotes ---  
//---------------
  rule #quotes( A:Proc , B:Proc  ) => @A , @B
  rule #quotes( A:Proc , B:Procs ) => @A , #quotes(B)

  rule #quotes( A:Proc    , B:ProcPat  ) => @A , @B
  rule #quotes( A:ProcPat , B:Proc     ) => @A , @B
  rule #quotes( A:ProcPat , B:ProcPat  ) => @A , @B
  rule #quotes( A:Proc    , B:ProcPats ) => @A , #quotes(B)
  rule #quotes( A:ProcPat , B:ProcPats ) => @A , #quotes(B)
  rule #quotes( A:ProcPat , B:Procs    ) => @A , #quotes(B)

//--------------------
//--- #interpolate ---
//--------------------
  // substitutes string in first occurrence of ${...} and ignores all } before ${
  rule #interpolate( S:String ; { A:String : B:String } )
       => #if substrString(S,findString(S,"${",0) +Int 2,findString(S,"}",findString(S,"${",0) +Int 2)) ==String A
          #then substrString(S,0,findString(S,"${",0)) // this part extracts A from original string
          +String replaceAll(substrString(S,findString(S,"${",0) +Int 2,findString(S,"}",findString(S,"${",0) +Int 2)),                                  
                substrString(S,findString(S,"${",0) +Int 2,findString(S,"}",findString(S,"${",0) +Int 2)), B) // this part substitutes B for A
          +String substrString(S,findString(S,"}",findString(S,"${",0) +Int 2) +Int 1, lengthString(S))
          #else S
          #fi
  rule #interpolate( S:String ; { A:String : B:String , KV:RhoKVPair } )
       => #if substrString(S,findString(S,"${",0) +Int 2,findString(S,"}",findString(S,"${",0) +Int 2)) ==String A
          #then substrString(S,0,findString(S,"${",0)) // this part extracts A from original string
          +String replaceAll(substrString(S,findString(S,"${",0) +Int 2,findString(S,"}",findString(S,"${",0) +Int 2)),                                  
                substrString(S,findString(S,"${",0) +Int 2,findString(S,"}",findString(S,"${",0) +Int 2)), B) // this part substitutes B for A
          +String substrString(S,findString(S,"}",findString(S,"${",0) +Int 2) +Int 1, lengthString(S))
          #else #interpolate(S;{KV})
          #fi
  rule #interpolate( S:String ; { A:String : B:String , KVs:RhoKVPairs } )
       => #if substrString(S,findString(S,"${",0) +Int 2,findString(S,"}",findString(S,"${",0) +Int 2)) ==String A
          #then substrString(S,0,findString(S,"${",0)) // this part extracts A from original string
          +String replaceAll(substrString(S,findString(S,"${",0) +Int 2,findString(S,"}",findString(S,"${",0) +Int 2)),                                  
                substrString(S,findString(S,"${",0) +Int 2,findString(S,"}",findString(S,"${",0) +Int 2)), B) // this part substitutes B for A
          +String substrString(S,findString(S,"}",findString(S,"${",0) +Int 2) +Int 1, lengthString(S))
          #else #interpolate(S;{KVs})
          #fi
  // if key is not a string, bypass it
  rule #interpolate(S:String ; { A:Proc : _:Proc ,  KV:RhoKVPair  } ) => #interpolate(S;{KV})  requires notBool isString(A)
  rule #interpolate(S:String ; { A:Proc : _:Proc , KVs:RhoKVPairs } ) => #interpolate(S;{KVs}) requires notBool isString(A)
  // if all else fails, return the original string
  rule #interpolate(S:String ; _:RhoMap ) => S [owise]

//------------------
//--- Predicates ---
//------------------
// Maps
  rule _:Proc #in_keys { }:RhoMap => false
  rule A:Proc #in_keys { Key:Proc : Val:Proc } => A ==K Key
  rule A:Proc #in_keys { Key:Proc : Val:Proc , KV:RhoKVPair   } => A ==K Key orBool A #in_keys { KV  }
  rule A:Proc #in_keys { Key:Proc : Val:Proc , KVs:RhoKVPairs } => A ==K Key orBool A #in_keys { KVs }
  
// Sets
  rule _:Proc #in_set Set( ) => false
  rule A:Proc #in_set Set( Elm:Proc ) => A ==K Elm
  rule A:Proc #in_set Set( Elm1:Proc , Elm2:Proc  ) => A ==K Elm1 orBool A ==K Elm2
  rule A:Proc #in_set Set( Elm1:Proc , Rest:Procs ) => A ==K Elm1 orBool A #in_set Set( Rest )

//---------------
//--- #mapSub ---
//---------------
// guards bound variables from generating substitutions maps
  rule #mapSub( .Set ) => .Map
  rule #mapSub( SetItem( A:Name ) S:Set ) => A |-> @sub #mapSub(S)
  rule #mapSub( SetItem( A:Proc ) S:Set ) => A |->  sub #mapSub(S)

//------------------
//--- #normPar ---
//------------------
  rule #normPar( A:Proc ) => A requires notBool isPar(A)
  rule #normPar( A:Par  ) => #set2Par(#par2Set(A))

// Essentially identical to functions in STRUCT except that #par2Set does not delete Nil from the Par
// counts appearances in Par
  // nonPar Proc
  rule #countPar( A:Proc ; B:Proc ) => #if A ==K B #then 1 #else 0 #fi requires notBool isPar(B)
  // multiple Proc Par
  rule #countPar( A:Proc ; B:Proc | C:Proc ) => #if A ==K B #then 1 +Int #countPar(A;C) #else #countPar(A;C) #fi
       requires notBool isPar(B)

// removes a nonPar Proc from a Par and preserves order
// first arg intended to be nonPar, second arg is intended to be Par (enforced by #setify)
  // single Proc Par i.e. a nonPar Proc
  rule #removePar( A:Proc ; B:Proc ) => #if A ==K B #then .K #else B #fi requires notBool isPar(B)
  // multiple Proc Par
  rule #removePar( A:Proc ; B:Proc | C:Proc ) => #if A ==K B #then #removePar(A;C) #else B | #removePar(A;C) #fi
       requires notBool isPar(B)

// computes Par Set of a Proc
  // par set of a nonPar Proc contains only one appearance of that Proc
  rule #par2Set( A:Proc ) => SetItem(A,1) requires notBool isPar(A)
  rule #par2Set( A:Proc | B:Proc ) 
    => #if #countPar(A;B) >Int 0
       #then SetItem(A, 1 +Int #countPar(A;B)) #par2Set(#removePar(A;B))
       #else SetItem(A,1) #par2Set(B)
       #fi requires notBool isPar(A)

  // duplicator
  rule #parDup( A:Proc ; 1 ) => A
  rule #parDup( A:Proc ; N:Int ) => A | #parDup(A;N -Int 1) requires N >Int 1

  // turns Set into normPard Par
  rule #set2Par( SetItem( A:Proc , N:Int )  .Set ) => #parDup(A;N)
  rule #set2Par( SetItem( A:Proc , N:Int ) S:Set ) => #parDup(A;N) | #set2Par( S ) requires notBool S <=Set .Set

//----------------
//--- #val2Key ---
//----------------
// requires each KV pair of the form: Proc |-> Proc or Name |-> Name & requested value uniquely in values(Map)
  rule #val2Key( A:Proc ; B:Proc |-> A _:Map ) => B // if value matches, return key
  rule #val2Key( A:Proc ; _:Proc |-> C:Proc M:Map ) => #val2Key(A;M) requires A =/=K C // if value doesn't match, traverse map
  rule #val2Key( A:Proc ; _:Name |-> _:Name M:Map ) => #val2Key(A;M) // if value has wrong type, traverse map

  rule #val2Key( A:Name ; B:Name |-> A _:Map ) => B // if value matches, return key
  rule #val2Key( A:Name ; _:Name |-> C:Name M:Map ) => #val2Key(A;M) requires A =/=K C // if value doesn't match, traverse map
  rule #val2Key( A:Name ; _:Proc |-> _:Proc M:Map ) => #val2Key(A;M) // if value has wrong type, traverse map

//------------------
//--- #par2procs ---
//------------------
  rule #par2procs( A:Proc | B:Proc ) => A,B requires notBool (isPar(A) orBool isPar(B))
  rule #par2procs( A:Proc | B:Par  ) => A,#par2procs(B) requires notBool isPar(A)
  rule #par2procs( A:Proc ) => A requires notBool isPar(A)

  rule #procs2par( A:Proc ) => A
  rule #procs2par( A:Proc , B:Proc  ) => A | B
  rule #procs2par( A:Proc , B:Procs ) => A | #procs2par(B)


//-----------------
//--- Built-ins ---
//-----------------
// List
  rule #list2rho( .List ) => [ ]
  rule #list2rho( ListItem( A:Proc ) ) => [A]
  rule #list2rho( ListItem( A:Proc ) B:List ) => #concat([A];#list2rho(B)) requires B =/=K .List

  rule #concat( [ ] ; A:RhoList ) => A
  rule #concat( A:RhoList ; [ ] ) => A
  rule #concat( [ A:Proc  ] ; [ B:Proc  ] ) => [#append(A;B)]
  rule #concat( [ A:Procs ] ; [ B:Proc  ] ) => [#append(A;B)]
  rule #concat( [ A:Proc  ] ; [ B:Procs ] ) => [#append(A;B)]
  rule #concat( [ A:Procs ] ; [ B:Procs ] ) => [#append(A;B)]

// Map
  rule #map2rho( .Map ) => { }
  rule #map2rho( A:Proc |-> B:Proc ) => {A:B}
  rule #map2rho( A:Proc |-> B:Proc C:Map ) => #unionMap({A:B};#map2rho(C)) requires C =/=K .Map

  rule #unionMap( { } ; A:RhoMap ) => A
  rule #unionMap( A:RhoMap ; { } ) => A
  rule #unionMap( { A:RhoKVPair  } ; { B:RhoKVPair  } ) => {#append(A;B)}
  rule #unionMap( { A:RhoKVPairs } ; { B:RhoKVPair  } ) => {#append(A;B)}
  rule #unionMap( { A:RhoKVPair  } ; { B:RhoKVPairs } ) => {#append(A;B)}
  rule #unionMap( { A:RhoKVPairs } ; { B:RhoKVPairs } ) => {#append(A;B)}

// Set
  rule #set2rho( .Set ) => Set( )
  rule #set2rho( SetItem( A:Proc ) ) => Set(A)
  rule #set2rho( SetItem( A:Proc ) B:Set ) => #unionSet(Set(A);#set2rho(B)) requires B =/=K .Set

  rule #unionSet( Set( ) ; A:RhoSet ) => A
  rule #unionSet( A:RhoSet ; Set( ) ) => A
  rule #unionSet( Set( A:Proc  ) ; Set( B:Proc  ) ) => Set(#append(A;B))
  rule #unionSet( Set( A:Procs ) ; Set( B:Proc  ) ) => Set(#append(A;B))
  rule #unionSet( Set( A:Proc  ) ; Set( B:Procs ) ) => Set(#append(A;B))
  rule #unionSet( Set( A:Procs ) ; Set( B:Procs ) ) => Set(#append(A;B))

//-------------
//--- #bind ---
//-------------
// Reconstruct listen from listen info
/*
  rule #bind ( A:Name ; B:Name  ;; 0 ) => B <- A
  rule #bind ( A:Name ; B:Names ;; 0 ) => B <- A
  rule #bind ( A:Name ; B:Name  ;; 1 ) => B <= A
  rule #bind ( A:Name ; B:Names ;; 1 ) => B <= A
  rule #bind ( A:Name ; B:Name  ;; 2 ) => B <! A
  rule #bind ( A:Name ; B:Names ;; 2 ) => B <! A
*/

/*
// Methods
//--------------
//--- #slice ---
//--------------
  rule #truncate( R:RhoList , Fin:Int ) => R requires (Fin >=Int #length R)
  rule #truncate( [ A:Proc ] , Fin:Int ) => #if Fin <=Int 0 #then [ ] #else [A] #fi

  rule #slice( [ ] , _ , _ ) => [ ]
  rule #slice( [ A:Proc ] , St:Int , Fin:Int ) => #if ( St ==Int 0 andBool Fin ==Int 0 ) #then [A] #else [ ] #fi
  rule #slice( [ A:Proc ] , St:Int , Fin:Int ) => #if ( St ==Int 0 andBool Fin ==Int 0 ) #then [A] #else [ ] #fi
  
//-------------
//--- #keys ---
//-------------
  rule #keys { }:RhoMap => Set( )
  rule #keys { A:Proc : _:Proc } => Set( A )
  rule #keys { A:Proc : _:Proc , B:Proc : _:Proc } => Set( A , B )
  rule #keys { A:Proc : _:Proc , R:RhoKVPairs } => SetItem(A) #keys {R}

//--------------
//--- #union ---
//--------------
  rule Set( ) #union S:RhoSet => S
  rule S:RhoSet #union Set( ) => S
  rule Set( A:Proc ) #union Set( B:Proc ) => #if A ==K B #then Set( A ) #else Set( A , B ) #fi
  rule Set( A:Proc ) #union Set( B:Proc , C:Proc ) => #if A ==K B
*/

//----------------
//--- #lengths ---
//----------------
// Binds
//  rule #lengths( B:Lbind ; C:Lbind  ) => #lislen(B) , #lislen(C)
//  rule #lengths( B:Lbind ; C:Lbinds ) => #lislen(B) , #lengths(C)

//  rule #lengths( B:Rbind ; C:Rbind  ) => #lislen(B) , #lislen(C)
//  rule #lengths( B:Rbind ; C:Rbinds ) => #lislen(B) , #lengths(C)

//  rule #lengths( B:Pbind ; C:Pbind  ) => #lislen(B) , #lislen(C)
//  rule #lengths( B:Pbind ; C:Pbinds ) => #lislen(B) , #lengths(C)

endmodule