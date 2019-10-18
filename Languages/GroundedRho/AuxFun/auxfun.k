// Auxilary functions for GRHO configuration

require "../grho.k"
require "../AlphaEquiv/alpha.k"

module AUXFUN-SYNTAX
  import GRHO-SYNTAX

// Length of object lists
  syntax        Int ::= "#length(" Names       ")" [function]
                      | "#length(" NamePats    ")" [function]
                      | "#length(" Procs       ")" [function]
                      | "#length(" ProcPats    ")" [function]
                      | "#length(" AnyBinds    ")" [function]
                      | "#length(" AnyBindPats ")" [function]
                      | "#length(" RhoKVPairs  ")" [function]
                      | "#length(" RhoKVPats   ")" [function]
                      | "#length(" Select      ")" [function]
                      | "#length(" SelectPat   ")" [function]
                      | "#length(" Branches    ")" [function]
                      | "#length(" BranchPats  ")" [function]
                      | "#length(" Match       ")" [function]
                      | "#length(" MatchPat    ")" [function]
                      | "#length(" MatchCases  ")" [function]
                      | "#length(" MCasePats   ")" [function]
  // List & String [sub]expressions
  syntax        Int ::= "#length+(" ListOrVar   ")" [function]
                      | "#length+(" StringOrVar ")" [function]
                      | "#length+(" Concat      ")" [function]
                      | "#length+(" Interp      ")" [function]
                      | "#length+(" InterpMaps  ")" [function]
  // Collections
  syntax        Int ::=  "#size(" RhoMap ")" [function]
                      |  "#size(" MapPat ")" [function]
                      |  "#size(" RhoSet ")" [function]
                      |  "#size(" SetPat ")" [function]
                      | "#length" RhoList    [function]
                      | "#length" ListPat    [function]
                      | "#length" RhoTuple   [function]
                      | "#length" TuplePat   [function]

// I/O depth -- TODO
  syntax        Int ::= "#depth(" Receive ")" [function]
                      | "#depth(" Send    ")" [function]

// Destructuring functions
  // Receive/RecPat
    // receive bind function
  syntax      Lbind ::=  "#bind(" Receive ")" [function]
                      |  "#bind(" LinearSRec ")" [function]
                      |  "#bind(" RecPat  ")" [function]
                      | "#gbind(" Receive ")" [function]
                      | "#gbind(" RecPat  ")" [function]
  syntax     GLbind ::= "#gbind(" Receive ")" [function]
                      | "#gbind(" RecPat  ")" [function]
  syntax     Lbinds ::=  "#bind(" Receive ")" [function]
                      |  "#bind(" LinearMRec ")" [function]
                      |  "#bind(" RecPat  ")" [function]
                      | "#gbind(" Receive ")" [function]
                      | "#gbind(" RecPat  ")" [function]
  syntax    GLbinds ::= "#gbind(" Receive ")" [function]
                      | "#gbind(" RecPat  ")" [function]
  syntax   LbindPat ::=  "#bind(" RecPat  ")" [function]
                      | "#gbind(" RecPat  ")" [function]
  syntax  GLbindPat ::= "#gbind(" RecPat  ")" [function]
  syntax  LbindPats ::=  "#bind(" RecPat  ")" [function]
                      | "#gbind(" RecPat  ")" [function]
  syntax GLbindPats ::= "#gbind(" RecPat  ")" [function]
  syntax      Pbind ::=  "#bind(" Receive ")" [function]
                      |  "#bind(" RecPat  ")" [function]
                      | "#gbind(" Receive ")" [function]
                      | "#gbind(" RecPat  ")" [function]
  syntax     GPbind ::= "#gbind(" Receive ")" [function]
                      | "#gbind(" RecPat  ")" [function]
  syntax     Pbinds ::=  "#bind(" Receive ")" [function]
                      |  "#bind(" RecPat  ")" [function]
                      | "#gbind(" Receive ")" [function]
                      | "#gbind(" RecPat  ")" [function]
  syntax    GPbinds ::= "#gbind(" Receive ")" [function]
                      | "#gbind(" RecPat  ")" [function]
  syntax   PbindPat ::=  "#bind(" RecPat  ")" [function]
                      | "#gbind(" RecPat  ")" [function]
  syntax  GPbindPat ::= "#gbind(" RecPat  ")" [function]
  syntax  PbindPats ::=  "#bind(" RecPat  ")" [function]
                      | "#gbind(" RecPat  ")" [function]
  syntax GPbindPats ::= "#gbind(" RecPat  ")" [function]
  syntax      Rbind ::=  "#bind(" Receive ")" [function]
                      |  "#bind(" RecPat  ")" [function]
                      | "#gbind(" Receive ")" [function]
                      | "#gbind(" RecPat  ")" [function]
  syntax     GRbind ::= "#gbind(" Receive ")" [function]
                      | "#gbind(" RecPat  ")" [function]
  syntax     Rbinds ::=  "#bind(" Receive ")" [function]
                      |  "#bind(" RecPat  ")" [function]
                      | "#gbind(" Receive ")" [function]
                      | "#gbind(" RecPat  ")" [function]
  syntax    GRbinds ::= "#gbind(" Receive ")" [function]
                      | "#gbind(" RecPat  ")" [function]
  syntax   RbindPat ::=  "#bind(" RecPat  ")" [function]
                      | "#gbind(" RecPat  ")" [function]
  syntax  GRbindPat ::= "#gbind(" RecPat  ")" [function]
  syntax  RbindPats ::=  "#bind(" RecPat  ")" [function]
                      | "#gbind(" RecPat  ")" [function]
  syntax GRbindPats ::= "#gbind(" RecPat  ")" [function]

  syntax      Lbind ::= "#bind(" GBind     ")" [function]
                      | "#bind(" GBindPat  ")" [function]
  syntax     Lbinds ::= "#bind(" GBinds    ")" [function]
                      | "#bind(" GBindPats ")" [function]
  syntax   LbindPat ::= "#bind(" GBindPat  ")" [function]
  syntax  LbindPats ::= "#bind(" GBindPats ")" [function]
  syntax      Pbind ::= "#bind(" GBind     ")" [function]
                      | "#bind(" GBindPat  ")" [function]
  syntax     Pbinds ::= "#bind(" GBinds    ")" [function]
                      | "#bind(" GBindPats ")" [function]
  syntax   PbindPat ::= "#bind(" GBindPat  ")" [function]
  syntax  PbindPats ::= "#bind(" GBindPats ")" [function]
  syntax      Rbind ::= "#bind(" GBind     ")" [function]
                      | "#bind(" GBindPat  ")" [function]
  syntax     Rbinds ::= "#bind(" GBinds    ")" [function]
                      | "#bind(" GBindPats ")" [function]
  syntax   RbindPat ::= "#bind(" GBindPat  ")" [function]
  syntax  RbindPats ::= "#bind(" GBindPats ")" [function]
    // receive listening patterns
  syntax       Name ::= "#bvar(" Receive ")" [function]
                      | "#bvar(" RecPat  ")" [function]
  syntax      Names ::= "#bvar(" Receive ")" [function]
                      | "#bvar(" RecPat  ")" [function]
  syntax    NamePat ::= "#bvar(" Receive ")" [function]
                      | "#bvar(" RecPat  ")" [function]
  syntax   NamePats ::= "#bvar(" Receive ")" [function]
                      | "#bvar(" RecPat  ")" [function]
    // receive channel function
  syntax       Name ::= "#chan(" Receive ")" [function]
                      | "#chan(" RecPat  ")" [function]
  syntax      Names ::= "#chan(" Receive ")" [function]
                      | "#chan(" RecPat  ")" [function]
  syntax    NamePat ::= "#chan(" RecPat  ")" [function]
  syntax   NamePats ::= "#chan(" RecPat  ")" [function]
    // receive continuation function
  syntax       Proc ::= "#cont(" Receive ")" [function]
                      | "#cont(" RecPat  ")" [function]
  syntax    ProcPat ::= "#cont(" RecPat  ")" [function]
    // receive input guard function
  syntax       BExp ::= "#guard(" Receive ")" [function]
                      | "#guard(" RecPat  ")" [function]
    // receive listen length function
  syntax        Int ::= "#lislen(" Receive ")" [function]
                      | "#lislen(" RecPat  ")" [function]
    // receive listen lengths function
  syntax      Procs ::= "#lislens(" MRec    ")" [function]
                      | "#lislens(" MRecPat ")" [function]
    // receive type function
  syntax        Int ::= "#rtype(" Receive ")" [function]
                      | "#rtype(" RecPat  ")" [function]

  // #chanSet: RecPat/BindPat[s] ---> Set( position ; channel )
  syntax        Set ::= "#chanSet(" RecPat   ")"          [function]
  syntax        Set ::= "#chanSet(" BindPat  ";;" Int ")" [function]
                      | "#chanSet(" BindPats ";;" Int ")" [function]
  // #chanMap: RecPat/BindPat[s] ---> Map( position |-> channel )
  syntax        Map ::= "#chanMap(" RecPat   ")"          [function]
  syntax        Map ::= "#chanMap(" BindPat  ";;" Int ")" [function]
                      | "#chanMap(" BindPats ";;" Int ")" [function]

  // #bindSet: Receive/RecPat/Bind[Pat][s] ---> set of binds with position
  syntax        Set ::= "#bindSet(" Receive ")"           [function]
                      | "#bindSet(" RecPat  ")"           [function]
  syntax        Set ::= "#bindSet(" Bind     ";;" Int ")" [function]
                      | "#bindSet(" Binds    ";;" Int ")" [function]
                      | "#bindSet(" BindPat  ";;" Int ")" [function]
                      | "#bindSet(" BindPats ";;" Int ")" [function]
  syntax    BindPat ::=  "#set2bind(" Int ";" Set ")"     [function]
  syntax   BindPats ::= "#set2binds(" Set ")"             [function]
                      | "#set2binds(" Int ";" Set ")"     [function]
  // #bindMap: RecPat/BindPat[s] ---> Map( bind number |-> BindPat )
  syntax        Map ::= "#bindMap(" RecPat  ")"           [function]
  syntax        Map ::= "#bindMap(" BindPat  ";;" Int ")" [function]
                      | "#bindMap(" BindPats ";;" Int ")" [function]
    // bindMap ---> Bind[s]
  syntax    BindPat ::=  "#map2bind(" Int ";" Map ")"     [function]
  syntax   BindPats ::= "#map2binds(" Map ")"             [function]
                      | "#map2binds(" Int ";" Map ")"     [function]

  // #bvarSet: RecPat/BindPat[s] ---> set of listening name[pat]s with position
  syntax        Set ::= "#bvarSet(" RecPat  ")"           [function]
  syntax        Set ::= "#bvarSet(" BindPat  ";;" Int ")" [function]
                      | "#bvarSet(" BindPats ";;" Int ")" [function]
    // bindSet ---> bvarSet
  syntax        Set ::=   "#bvarSet(" Set ")"         [function]
    // bvarSet ---> bvars
  syntax   NamePats ::= "#set2bvars(" Set ")"         [function]
                      | "#set2bvars(" Int ";" Set ")" [function]
  syntax   NamePats ::=  "#set2bvar(" Int ";" Set ")" [function]

  // #bvarMap: RecPat/BindPat[s] ---> set of listening name[pat]s with position
  syntax        Map ::= "#bvarMap(" RecPat  ")"           [function]
  syntax        Map ::= "#bvarMap(" BindPat  ";;" Int ")" [function]
                      | "#bvarMap(" BindPats ";;" Int ")" [function]
    // bindMap ---> bvarMap
  syntax        Map ::=   "#bvarMap(" Map ")"         [function]
    // bvarMap ---> bvars
  syntax   NamePats ::= "#map2bvars(" Map ")"         [function]
                      | "#map2bvars(" Int ";" Map ")" [function]
  syntax   NamePats ::=  "#map2bvar(" Int ";" Map ")" [function]

  // Bind at given position in Receive/RecPat/Bind[Pat][s]
  syntax   LbindPat ::= "#bind(" RecPat    ";;" Int ")" [function]
                      | "#bind(" LbindPat  ";;" Int ")" [function]
                      | "#bind(" LbindPats ";;" Int ")" [function]
  syntax   PbindPat ::= "#bind(" RecPat    ";;" Int ")" [function]
                      | "#bind(" PbindPat  ";;" Int ")" [function]
                      | "#bind(" PbindPats ";;" Int ")" [function]
  syntax   RbindPat ::= "#bind(" RecPat    ";;" Int ")" [function]
                      | "#bind(" RbindPat  ";;" Int ")" [function]
                      | "#bind(" RbindPats ";;" Int ")" [function]

  // Listening NamePats at given position in RecPat/BindPat[s]
  syntax   NamePats ::= "#bvar(" RecPat   ";;" Int ")" [function]
                      | "#bvar(" BindPat  ";;" Int ")" [function]
                      | "#bvar(" BindPats ";;" Int ")" [function]

  // Channel Name[Pat] at given position in Receive/RecPat/Bind[Pat][s]
  syntax       Name ::= "#chan(" Receive  ";;" Int ")" [function]
                      | "#chan(" RecPat   ";;" Int ")" [function]
                      | "#chan(" Bind     ";;" Int ")" [function]
                      | "#chan(" Binds    ";;" Int ")" [function]
                      | "#chan(" BindPats ";;" Int ")" [function]
  syntax    NamePat ::= "#chan(" RecPat   ";;" Int ")" [function]
                      | "#chan(" BindPat  ";;" Int ")" [function]
                      | "#chan(" BindPats ";;" Int ")" [function]

  // AnyBind[Pat]s
    // bind pattern function
  syntax       Name ::= "#bvar(" AnyBind     ")" [function]
                      | "#bvar(" AnyBindPat  ")" [function]
  syntax      Names ::= "#bvar(" AnyBind     ")" [function]
                      | "#bvar(" AnyBinds    ")" [function]
                      | "#bvar(" AnyBindPat  ")" [function]
                      | "#bvar(" AnyBindPats ")" [function]
  syntax    NamePat ::= "#bvar(" AnyBind     ")" [function]
                      | "#bvar(" AnyBindPat  ")" [function]
  syntax   NamePats ::= "#bvar(" AnyBind     ")" [function]
                      | "#bvar(" AnyBinds    ")" [function]
                      | "#bvar(" AnyBindPat  ")" [function]
                      | "#bvar(" AnyBindPats ")" [function]
    // bind channel function
  syntax       Name ::= "#chan(" AnyBind     ")" [function]
  syntax      Names ::= "#chan(" AnyBinds    ")" [function]
  syntax    NamePat ::= "#chan(" AnyBindPat  ")" [function]
  syntax   NamePats ::= "#chan(" AnyBindPats ")" [function]
    // bind input guard function
  syntax       BExp ::= "#guard(" GBind     ")" [function]
                      | "#guard(" GBinds    ")" [function]
                      | "#guard(" GBindPat  ")" [function]
                      | "#guard(" GBindPats ")" [function]
    // bind listen length function
  syntax        Int ::= "#lislen(" AnyBind    ")" [function]
                      | "#lislen(" AnyBindPat ")" [function]
    // bind listen length function
  syntax      Procs ::= "#lislens(" AnyBinds    ")" [function]
                      | "#lislens(" AnyBindPats ")" [function]
    // bind type function
  syntax        Int ::= "#rtype(" AnyBind     ")" [function]
                      | "#rtype(" AnyBindPat  ")" [function]
                      | "#rtype(" AnyBinds    ")" [function]
                      | "#rtype(" AnyBindPats ")" [function]

  // Send[Pat]
    // send channel function
  syntax    NamePat ::=   "#chan(" SendPat ")" [function]
    // send message function
  syntax   ProcPats ::=    "#msg(" SendPat ")" [function]
    // send message length function
  syntax        Int ::= "#msglen(" SendPat ")" [function]
    // send type function
  syntax        Int ::=  "#stype(" SendPat ")" [function]

  // New[Pat]
    // declared names function
  syntax     VarDec ::= "#dec(" New    ")" [function]
                      | "#dec(" NewPat ")" [function]
  syntax    VarDecs ::= "#dec(" New    ")" [function]
                      | "#dec(" NewPat ")" [function]

  syntax        Var ::= "#var(" New     ")" [function]
                      | "#var(" NewPat  ")" [function]
                      | "#var(" VarDec  ")" [function]
  syntax       Vars ::= "#var(" New     ")" [function]
                      | "#var(" NewPat  ")" [function]
                      | "#var(" VarDecs ")" [function]
    // deletes duplicate name declarations and preserves syntactic order
  syntax    VarDecs ::= "#indecs(" New     ")" [function]
                      | "#indecs(" NewPat  ")" [function]
                      | "#indecs(" VarDecs ")" [function]
                      | "#indecs(" VarDecs ";" Set ";" VarDecs ")" [function]

  syntax       Proc ::= "#newproc(" New    ")" [function]
  syntax    ProcPat ::= "#newproc(" NewPat ")" [function]

  // Select
  syntax     RecPat ::=    "#branch2rec(" BranchPat ")" [function]
  syntax BranchPats ::= "#select2branch(" SelectPat ")" [function]

  syntax   LbindPat ::= "#bind(" BranchPat ")" [function]
  syntax  LbindPats ::= "#bind(" BranchPat ")" [function]
  syntax  GLbindPat ::= "#bind(" BranchPat ")" [function]
  syntax GLbindPats ::= "#bind(" BranchPat ")" [function]
  syntax    ProcPat ::= "#cont(" BranchPat ")" [function]

  // IfThenElse
    // if function
  syntax       BExp ::=   "#if(" IfThen ")" [function]
                      |   "#if(" Else   ")" [function]
    // then & else functions
  syntax       Proc ::= "#then(" IfThen ")" [function]
                      | "#then(" Else   ")" [function]
                      | "#else(" IfThen ")" [function]
                      | "#else(" Else   ")" [function]

  // Let
  syntax    ProcVar ::=  "#letvar(" LetBind        ")" [function]
  syntax      Procs ::=  "#letvar(" SeqLetBinds    ")" [function]
                      |  "#letvar(" SimLetBinds    ")" [function]
                      |  "#letvar(" SeqSimLetBinds ")" [function]
  syntax       Proc ::= "#letproc(" LetBind        ")" [function]
  syntax      Procs ::= "#letproc(" SeqLetBinds    ")" [function]
                      | "#letproc(" SimLetBinds    ")" [function]
                      | "#letproc(" SeqSimLetBinds ")" [function]

  // Procs <-> Par
  syntax       Proc ::= "#procs2par(" Procs    ")" [function]
  syntax      Procs ::= "#par2procs(" Proc     ")" [function]
  syntax    ProcPat ::=  "#pats2par(" ProcPats ")" [function]
  syntax   ProcPats ::=  "#par2pats(" ProcPat  ")" [function]
  // Collection <-> Procs
  syntax      Procs ::=  "#rho2procs(" RhoList    ")" [function]
                      |  "#rho2procs(" RhoSet     ")" [function]
                      |  "#rho2procs(" RhoTuple   ")" [function]
  syntax       List ::= "#procs2list(" Procs      ")" [function]
                      | "#names2list(" Names      ")" [function]
  syntax     RhoMap ::=    "#KVs2rho(" RhoKVPairs ")" [function]
  syntax     MapPat ::=    "#KVs2rho(" RhoKVPats  ")" [function]
  syntax RhoKVPairs ::=    "#rho2KVs(" RhoMap     ")" [function]
                      |    "#map2KVs(" Map        ")" [function]
  syntax  RhoKVPats ::=    "#rho2KVs(" MapPat     ")" [function]
                      |    "#map2KVs(" Map        ")" [function]
  syntax        Map ::=    "#KVs2map(" RhoKVPats  ")" [function]
                      |    "#KVs2map(" RhoKVPairs ")" [function]

  syntax   ProcPats ::=  "#rho2pats(" ListPat  ")" [function]
                      |  "#rho2pats(" SetPat   ")" [function]
                      |  "#rho2pats(" TuplePat ")" [function]
  syntax       List ::= "#pats2list(" Procs    ")" [function]
                      | "#pats2list(" ProcPats ")" [function]
                      | "#pats2list(" Names    ")" [function]
                      | "#pats2list(" NamePats ")" [function]
  syntax        Set ::=  "#pats2set(" Procs    ")" [function]
                      |  "#pats2set(" ProcPats ")" [function]
                      |  "#pats2set(" Names    ")" [function]
                      |  "#pats2set(" NamePats ")" [function]

// Quotes
  syntax   NamePats ::= "#quotes(" ProcPats ")" [function]

// Evals -- *( A , B , ... ) => *A , *B , ...
  syntax   ProcPats ::= "#evals(" NamePats ")" [function]

// Append
  // Names & NamePats
  syntax      Names ::= "#append(" Names    ";" Names    ")" [function]
  syntax   NamePats ::= "#append(" Names    ";" NamePats ")" [function]
                      | "#append(" NamePats ";" Names    ")" [function]
                      | "#append(" NamePats ";" NamePats ")" [function]
  syntax    VarDecs ::= "#append(" VarDecs  ";" VarDecs  ")" [function]
  // Procs & ProcPats
  syntax      Procs ::= "#append(" Procs    ";" Procs    ")" [function]
  syntax   ProcPats ::= "#append(" Procs    ";" ProcPats ")" [function]
                      | "#append(" ProcPats ";" Procs    ")" [function]
                      | "#append(" ProcPats ";" ProcPats ")" [function]
  // BindPats
  syntax  LbindPats ::= "#append(" LbindPat  ";;" LbindPat  ")" [function]
                      | "#append(" LbindPat  ";;" LbindPats ")" [function]
                      | "#append(" LbindPats ";;" LbindPat  ")" [function]
                      | "#append(" LbindPats ";;" LbindPats ")" [function]
  syntax  PbindPats ::= "#append(" PbindPat  ";;" PbindPat  ")" [function]
                      | "#append(" PbindPat  ";;" PbindPats ")" [function]
                      | "#append(" PbindPats ";;" PbindPat  ")" [function]
                      | "#append(" PbindPats ";;" PbindPats ")" [function]
  syntax  RbindPats ::= "#append(" RbindPat  ";;" RbindPat  ")" [function]
                      | "#append(" RbindPat  ";;" RbindPats ")" [function]
                      | "#append(" RbindPats ";;" RbindPat  ")" [function]
                      | "#append(" RbindPats ";;" RbindPats ")" [function]

  // RhoKVPairs & Pats
  syntax  RhoKVPats ::= "#append(" RhoKVPats  ";" RhoKVPats  ")" [function]

// Methods
  syntax     RhoSet ::=  "#keys(" RhoMap ")"            [function]
                      | "#union(" RhoSet ";" RhoSet ")" [function]

  syntax    RhoList ::=    "#slice(" RhoList "," Int "," Int ")" [function]
                      | "#truncate(" RhoList "," Int ")"         [function]

// Substitution
  syntax        Map ::= "#mapSub(" Set ")" [function] // for hiding bound variables
                      | "#mapNil(" Set ")" [function] // for Par substitution

// Par Normalization
  syntax       Proc ::=   "#normPar(" Proc  ")"          [function, poly(0,1)]
                      |   "#set2Par(" Set   ")"          [function]
                      | "#removePar(" Proc  ";" Proc ")" [function]
                      |    "#parDup(" Proc  ";" Int  ")" [function]
  syntax      Procs ::= "#set2procs(" Set   ")"          [function]
  syntax      Names ::= "#set2names(" Set   ")"          [function]
  syntax        Set ::=   "#par2Set(" Proc  ")"          [function]
                      | "#procs2set(" Procs ")"          [function]
                      | "#names2set(" Names ")"          [function]
  syntax        Int ::=  "#countPar(" Proc  ";" Proc ")" [function]
  syntax        Int ::= "#parlength(" Proc  ")"          [function]

  syntax        Set ::=  "#par2Set(" ProcPat  ")" [function]
                      | "#pats2set(" ProcPats ")" [function]
                      | "#pats2set(" NamePats ")" [function]
  syntax        Int ::= "#parlength(" ProcPat ")" [function]

// String Interpolation
  syntax     String ::= "#interpolate(" String ";" InterpMaps ")" [function]

// De Bruijn indexing
  syntax       Proc ::= "#val2Key(" Proc ";" Map ")" [function]
  syntax       Name ::= "#val2Key(" Name ";" Map ")" [function]

// For MRec matching
  syntax        Int ::= "#val(" Map ";" Int ")" [function]

// Predicates -- List, RhoMap keys, & RhoSet inclusion
  syntax       Bool ::= Int   "#int" "(" Procs ")" [function]
                      | Name  "#in"  "(" Names ")" [function]
                      | Bind  "#in"  "(" Bind  ")" [function]
                      | Bind  "#in"  "(" Binds ")" [function]
                      | Binds "#in"  "(" Binds ")" [function]
                      | Proc     "#in_keys" RhoMap [function]
                      | Proc     "#in_keys" MapPat [function]
                      | ProcPat  "#in_keys" RhoMap [function]
                      | ProcPat  "#in_keys" MapPat [function]
                      | Proc     "#in_set"  RhoSet [function]
                      | Proc     "#in_set"  SetPat [function]
                      | ProcPat  "#in_set"  RhoSet [function]
                      | ProcPat  "#in_set"  SetPat [function]

// Translation from built-ins to rho -- other direction in STRUCT
  syntax     String ::=   "#concat(" String ";" ConcatStr ")" [function]
  syntax    RhoList ::= "#list2rho(" List ")"                 [function]
                      | "#concat(" RhoList ";" ConcatList ")" [function]
  syntax    ListPat ::=  "#list2rho(" List ")"                [function]
                      |    "#concat(" RhoList ";" ListPat ")" [function]
                      |    "#concat(" ListPat ";" RhoList ")" [function]
                      |    "#concat(" ListPat ";" ListPat ")" [function]
  syntax     RhoMap ::=   "#map2rho(" Map  ")"                [function]
                      |  "#unionMap(" RhoMap  ";" RhoMap  ")" [function]
  syntax     MapPat ::=   "#map2rho(" Map  ")"                [function]
                      |  "#unionMap(" RhoMap  ";" MapPat  ")" [function]
                      |  "#unionMap(" MapPat  ";" RhoMap  ")" [function]
                      |  "#unionMap(" MapPat  ";" MapPat  ")" [function]
  syntax     RhoSet ::=   "#set2rho(" Set  ")"                [function]
                      |  "#unionSet(" RhoSet  ";" RhoSet  ")" [function]
  syntax     SetPat ::=   "#set2rho(" Set  ")"                [function]
                      |  "#unionSet(" RhoSet  ";" SetPat  ")" [function]
                      |  "#unionSet(" SetPat  ";" RhoSet  ")" [function]
                      |  "#unionSet(" SetPat  ";" SetPat  ")" [function]
  syntax   RhoTuple ::= "#tuple2rho(" List ")"                [function]
  syntax   TuplePat ::= "#tuple2rho(" List ")"                [function]

  syntax    RhoList ::= "#tuple2list(" RhoTuple ")" [function]
  syntax    ListPat ::= "#tuple2list(" TuplePat ")" [function]
  syntax   RhoTuple ::= "#list2tuple(" RhoList  ")" [function]
  syntax   TuplePat ::= "#list2tuple(" ListPat  ")" [function]

  syntax      Procs ::= "#list2procs(" List ")" [function]
  syntax   ProcPats ::=  "#list2pats(" List ")" [function]
  syntax      Names ::= "#list2names(" List ")" [function]
  syntax   NamePats ::=  "#list2pats(" List ")" [function]

  syntax   NamePats ::= "#set2pats(" Set ")" [function]
  syntax   ProcPats ::= "#set2pats(" Set ")" [function]

  syntax        Set ::= "#vardecs2set(" VarDecs ")" [function]
  syntax    VarDecs ::= "#set2vardecs(" Set     ")" [function]

// Evaluating expressions
  syntax       Bool ::= "#eval(" BoolExp       ")" [function]
  syntax        Int ::= "#eval(" IntExp        ")" [function]
  syntax    RhoList ::= "#eval(" ConcatRhoList ")" [function]
  syntax     String ::= "#eval(" StringOnlyExp ")" [function]

// Explicit sort chechking functions
  syntax       Bool ::= "#isBranches(" BranchPats ")" [function]

  syntax      KItem ::= Name  | Names  | NamePat  | NamePats | Var
                      | Proc  | Procs  | ProcPat  | ProcPats
                      | Lbind | Lbinds | LbindPat | LbindPats
                      | Pbind | Pbinds | PbindPat | PbindPats
                      | Rbind | Rbinds | RbindPat | RbindPats
                      | IndexedNames | IndexedBinds

endmodule

module AUXFUN
  import AUXFUN-SYNTAX

  syntax KResult ::= RhoKVPair | RhoKVPairs | Collection
                   | Name | Names | NamePat | NamePats
                   | Proc | Procs | ProcPat | ProcPats
                   | Bind | Binds | BindPat | BindPats
                   | Bool | Int   | String  | List | Map | Set

// Sends
  rule #chan( N:NamePat !  (            ) ) => N
  rule #chan( N:NamePat !  ( _:ProcPats ) ) => N
  rule #chan( N:NamePat !! (            ) ) => N
  rule #chan( N:NamePat !! ( _:ProcPats ) ) => N

  rule #msg( _:NamePat !  (            ) ) => EmptyP
  rule #msg( _:NamePat !  ( P:ProcPats ) ) => P
  rule #msg( _:NamePat !! (            ) ) => EmptyP
  rule #msg( _:NamePat !! ( P:ProcPats ) ) => P

  rule #msglen( S:SendPat ) => #length(#msg(S))

  rule #stype( _:CSendPat ) => 0
  rule #stype( _:USendPat ) => 1

// Receives
  rule #bind( for ( B:LbindPat          ){ _:ProcPat } ) => B
  rule #bind( for ( B:LbindPats         ){ _:ProcPat } ) => B
  rule #bind( for ( B:LbindPat  _:Guard ){ _:ProcPat } ) => B
  rule #bind( for ( B:LbindPats _:Guard ){ _:ProcPat } ) => B
  rule #bind( for ( B:PbindPat          ){ _:ProcPat } ) => B
  rule #bind( for ( B:PbindPats         ){ _:ProcPat } ) => B
  rule #bind( for ( B:PbindPat  _:Guard ){ _:ProcPat } ) => B
  rule #bind( for ( B:PbindPats _:Guard ){ _:ProcPat } ) => B
  rule #bind( for ( B:RbindPat          ){ _:ProcPat } ) => B
  rule #bind( for ( B:RbindPats         ){ _:ProcPat } ) => B
  rule #bind( for ( B:RbindPat  _:Guard ){ _:ProcPat } ) => B
  rule #bind( for ( B:RbindPats _:Guard ){ _:ProcPat } ) => B

  rule #gbind( R:UGRecPat ) => #bind(R) [structural]
  rule #gbind( for( B:GLbindPat  ){ _:ProcPat } ) => B
  rule #gbind( for( B:GPbindPat  ){ _:ProcPat } ) => B
  rule #gbind( for( B:GRbindPat  ){ _:ProcPat } ) => B
  rule #gbind( for( B:GLbindPats ){ _:ProcPat } ) => B
  rule #gbind( for( B:GPbindPats ){ _:ProcPat } ) => B
  rule #gbind( for( B:GRbindPats ){ _:ProcPat } ) => B

  rule #bind( A:LbindPat  _:Guard ) => A
  rule #bind( A:PbindPat  _:Guard ) => A
  rule #bind( A:RbindPat  _:Guard ) => A
  rule #bind( A:LbindPats _:Guard ) => A
  rule #bind( A:PbindPats _:Guard ) => A
  rule #bind( A:RbindPats _:Guard ) => A

  rule #bvar( A:RecPat ) => #bvar(#bind(A))
  rule #chan( A:SRec ) => #chan(#bind(A))
  rule #chan( A:MRec ) => #chan(#bind(A))

  // Branch[Pat]
  rule #bind( { A:Lbind     } |=> _:Proc    ) => A [structural]
  rule #bind( { A:Lbinds    } |=> _:Proc    ) => A [structural]
  rule #bind( { A:Lbind     } |=> _:ProcPat ) => A [structural]
  rule #bind( { A:Lbinds    } |=> _:ProcPat ) => A [structural]
  rule #bind( { A:LbindPat  } |=> _:Proc    ) => A [structural]
  rule #bind( { A:LbindPats } |=> _:Proc    ) => A [structural]
  rule #bind( { A:LbindPat  } |=> _:ProcPat ) => A [structural]
  rule #bind( { A:LbindPats } |=> _:ProcPat ) => A [structural]
  rule #cont( { _:Lbind     } |=> A:Proc    ) => A [structural]
  rule #cont( { _:Lbinds    } |=> A:Proc    ) => A [structural]
  rule #cont( { _:Lbind     } |=> A:ProcPat ) => A [structural]
  rule #cont( { _:Lbinds    } |=> A:ProcPat ) => A [structural]
  rule #cont( { _:LbindPat  } |=> A:Proc    ) => A [structural]
  rule #cont( { _:LbindPats } |=> A:Proc    ) => A [structural]
  rule #cont( { _:LbindPat  } |=> A:ProcPat ) => A [structural]
  rule #cont( { _:LbindPats } |=> A:ProcPat ) => A [structural]

  rule #cont( for ( _:Lbind             ){ P:Proc    } ) => P
  rule #cont( for ( _:Lbinds            ){ P:Proc    } ) => P
  rule #cont( for ( _:Lbind     _:Guard ){ P:Proc    } ) => P
  rule #cont( for ( _:Lbinds    _:Guard ){ P:Proc    } ) => P
  rule #cont( for ( _:Pbind             ){ P:Proc    } ) => P
  rule #cont( for ( _:Pbinds            ){ P:Proc    } ) => P
  rule #cont( for ( _:Pbind     _:Guard ){ P:Proc    } ) => P
  rule #cont( for ( _:Pbinds    _:Guard ){ P:Proc    } ) => P
  rule #cont( for ( _:Rbind             ){ P:Proc    } ) => P
  rule #cont( for ( _:Rbinds            ){ P:Proc    } ) => P
  rule #cont( for ( _:Rbind     _:Guard ){ P:Proc    } ) => P
  rule #cont( for ( _:Rbinds    _:Guard ){ P:Proc    } ) => P
  rule #cont( for ( _:Lbind             ){ P:ProcPat } ) => P
  rule #cont( for ( _:Lbinds            ){ P:ProcPat } ) => P
  rule #cont( for ( _:Lbind     _:Guard ){ P:ProcPat } ) => P
  rule #cont( for ( _:Lbinds    _:Guard ){ P:ProcPat } ) => P
  rule #cont( for ( _:Pbind             ){ P:ProcPat } ) => P
  rule #cont( for ( _:Pbinds            ){ P:ProcPat } ) => P
  rule #cont( for ( _:Pbind     _:Guard ){ P:ProcPat } ) => P
  rule #cont( for ( _:Pbinds    _:Guard ){ P:ProcPat } ) => P
  rule #cont( for ( _:Rbind             ){ P:ProcPat } ) => P
  rule #cont( for ( _:Rbinds            ){ P:ProcPat } ) => P
  rule #cont( for ( _:Rbind     _:Guard ){ P:ProcPat } ) => P
  rule #cont( for ( _:Rbinds    _:Guard ){ P:ProcPat } ) => P
  rule #cont( for ( _:LbindPat          ){ P:Proc    } ) => P
  rule #cont( for ( _:LbindPats         ){ P:Proc    } ) => P
  rule #cont( for ( _:LbindPat  _:Guard ){ P:Proc    } ) => P
  rule #cont( for ( _:LbindPats _:Guard ){ P:Proc    } ) => P
  rule #cont( for ( _:PbindPat          ){ P:Proc    } ) => P
  rule #cont( for ( _:PbindPats         ){ P:Proc    } ) => P
  rule #cont( for ( _:PbindPat  _:Guard ){ P:Proc    } ) => P
  rule #cont( for ( _:PbindPats _:Guard ){ P:Proc    } ) => P
  rule #cont( for ( _:RbindPat          ){ P:Proc    } ) => P
  rule #cont( for ( _:RbindPats         ){ P:Proc    } ) => P
  rule #cont( for ( _:RbindPat  _:Guard ){ P:Proc    } ) => P
  rule #cont( for ( _:RbindPats _:Guard ){ P:Proc    } ) => P
  rule #cont( for ( _:LbindPat          ){ P:ProcPat } ) => P
  rule #cont( for ( _:LbindPats         ){ P:ProcPat } ) => P
  rule #cont( for ( _:LbindPat  _:Guard ){ P:ProcPat } ) => P
  rule #cont( for ( _:LbindPats _:Guard ){ P:ProcPat } ) => P
  rule #cont( for ( _:PbindPat          ){ P:ProcPat } ) => P
  rule #cont( for ( _:PbindPats         ){ P:ProcPat } ) => P
  rule #cont( for ( _:PbindPat  _:Guard ){ P:ProcPat } ) => P
  rule #cont( for ( _:PbindPats _:Guard ){ P:ProcPat } ) => P
  rule #cont( for ( _:RbindPat          ){ P:ProcPat } ) => P
  rule #cont( for ( _:RbindPats         ){ P:ProcPat } ) => P
  rule #cont( for ( _:RbindPat  _:Guard ){ P:ProcPat } ) => P
  rule #cont( for ( _:RbindPats _:Guard ){ P:ProcPat } ) => P

// listen length
  rule #lislen( A:SRec ) => #lislen(#bind(A))
  rule #lislen( A:MRec ) => #length(#bind(A))

// listen lengths
  rule #lislens( A:MRec    ) => #lislens(#bind(A))
  rule #lislens( A:MRecPat ) => #lislens(#bind(A))
  rule #lislens( A:Lbind & B:Lbind  ) => #lislen(A) ,  #lislen(B)
  rule #lislens( A:Lbind & B:Lbinds ) => #lislen(A) , #lislens(B)
  rule #lislens( A:Pbind & B:Pbind  ) => #lislen(A) ,  #lislen(B)
  rule #lislens( A:Pbind & B:Pbinds ) => #lislen(A) , #lislens(B)
  rule #lislens( A:Rbind & B:Rbind  ) => #lislen(A) ,  #lislen(B)
  rule #lislens( A:Rbind & B:Rbinds ) => #lislen(A) , #lislens(B)

// receive types
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

  rule #rtype( _:Lbind             ) => 0
  rule #rtype( _:Lbinds            ) => 0
  rule #rtype( _:Lbind     _:Guard ) => 0
  rule #rtype( _:Lbinds    _:Guard ) => 0
  rule #rtype( _:LbindPat          ) => 0
  rule #rtype( _:LbindPats         ) => 0
  rule #rtype( _:LbindPat  _:Guard ) => 0
  rule #rtype( _:LbindPats _:Guard ) => 0
  rule #rtype( _:Rbind             ) => 1
  rule #rtype( _:Rbinds            ) => 1
  rule #rtype( _:Rbind     _:Guard ) => 1
  rule #rtype( _:Rbinds    _:Guard ) => 1
  rule #rtype( _:RbindPat          ) => 1
  rule #rtype( _:RbindPats         ) => 1
  rule #rtype( _:RbindPat  _:Guard ) => 1
  rule #rtype( _:RbindPats _:Guard ) => 1
  rule #rtype( _:Pbind             ) => 2
  rule #rtype( _:Pbinds            ) => 2
  rule #rtype( _:Pbind     _:Guard ) => 2
  rule #rtype( _:Pbinds    _:Guard ) => 2
  rule #rtype( _:PbindPat          ) => 2
  rule #rtype( _:PbindPats         ) => 2
  rule #rtype( _:PbindPat  _:Guard ) => 2
  rule #rtype( _:PbindPats _:Guard ) => 2

// Guards
  rule #guard( _:UGSRec ) => true
  rule #guard( _:UGMRec ) => true
  rule #guard( for( _:Lbind     if G:BExp ){ _:Proc    } ) => G
  rule #guard( for( _:Pbind     if G:BExp ){ _:Proc    } ) => G
  rule #guard( for( _:Rbind     if G:BExp ){ _:Proc    } ) => G
  rule #guard( for( _:Lbinds    if G:BExp ){ _:Proc    } ) => G
  rule #guard( for( _:Pbinds    if G:BExp ){ _:Proc    } ) => G
  rule #guard( for( _:Rbinds    if G:BExp ){ _:Proc    } ) => G
  rule #guard( for( _:Lbind     if G:BExp ){ _:ProcPat } ) => G
  rule #guard( for( _:Pbind     if G:BExp ){ _:ProcPat } ) => G
  rule #guard( for( _:Rbind     if G:BExp ){ _:ProcPat } ) => G
  rule #guard( for( _:Lbinds    if G:BExp ){ _:ProcPat } ) => G
  rule #guard( for( _:Pbinds    if G:BExp ){ _:ProcPat } ) => G
  rule #guard( for( _:Rbinds    if G:BExp ){ _:ProcPat } ) => G
  rule #guard( for( _:LbindPat  if G:BExp ){ _:Proc    } ) => G
  rule #guard( for( _:PbindPat  if G:BExp ){ _:Proc    } ) => G
  rule #guard( for( _:RbindPat  if G:BExp ){ _:Proc    } ) => G
  rule #guard( for( _:LbindPats if G:BExp ){ _:Proc    } ) => G
  rule #guard( for( _:PbindPats if G:BExp ){ _:Proc    } ) => G
  rule #guard( for( _:RbindPats if G:BExp ){ _:Proc    } ) => G
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
// Name[Pat]s
  rule #append( A:Name                 ; B:Names    ) => A,B
  rule #append( A:Name                 ; B:NamePats ) => A,B
  rule #append( A:NamePat              ; B:Names    ) => A,B
  rule #append( A:NamePat              ; B:NamePats ) => A,B
  rule #append( A:Name    , B:Names    ; C:Names    ) => A,#append(B;C)
  rule #append( A:Name    , B:Names    ; C:NamePats ) => A,#append(B;C)
  rule #append( A:Name    , B:NamePats ; C:Names    ) => A,#append(B;C)
  rule #append( A:Name    , B:NamePats ; C:NamePats ) => A,#append(B;C)
  rule #append( A:NamePat , B:NamePats ; C:Names    ) => A,#append(B;C)
  rule #append( A:NamePat , B:NamePats ; C:NamePats ) => A,#append(B;C)

// Proc[Pat]s
  rule #append( A:Proc                 ; B:Procs    ) => A,B
  rule #append( A:Proc                 ; B:ProcPats ) => A,B
  rule #append( A:ProcPat              ; B:Procs    ) => A,B
  rule #append( A:ProcPat              ; B:ProcPats ) => A,B
  rule #append( A:Proc    , B:Procs    ; C:Procs    ) => A,#append(B;C)
  rule #append( A:Proc    , B:Procs    ; C:ProcPats ) => A,#append(B;C)
  rule #append( A:Proc    , B:ProcPats ; C:Procs    ) => A,#append(B;C)
  rule #append( A:Proc    , B:ProcPats ; C:ProcPats ) => A,#append(B;C)
  rule #append( A:ProcPat , B:ProcPats ; C:Procs    ) => A,#append(B;C)
  rule #append( A:ProcPat , B:ProcPats ; C:ProcPats ) => A,#append(B;C)

// Binds
  rule #append( A:Lbind ;; B:Lbind  ) => A&B
  rule #append( A:Lbind ;; B:Lbinds ) => A&B
  rule #append( A:Pbind ;; B:Pbind  ) => A&B
  rule #append( A:Pbind ;; B:Pbinds ) => A&B
  rule #append( A:Rbind ;; B:Rbind  ) => A&B
  rule #append( A:Rbind ;; B:Rbinds ) => A&B
  rule #append( A:Lbind  & B:Lbinds ;; C:Lbind  ) => A&#append(B;;C)
  rule #append( A:Lbind  & B:Lbinds ;; C:Lbinds ) => A&#append(B;;C)
  rule #append( A:Pbind  & B:Pbinds ;; C:Pbind  ) => A&#append(B;;C)
  rule #append( A:Pbind  & B:Pbinds ;; C:Pbinds ) => A&#append(B;;C)
  rule #append( A:Rbind  & B:Rbinds ;; C:Rbind  ) => A&#append(B;;C)
  rule #append( A:Rbind  & B:Rbinds ;; C:Rbinds ) => A&#append(B;;C)

// BindPats
  // LbindPats
  rule #append( A:Lbind    ;; B:LbindPat  ) => A&B
  rule #append( A:Lbind    ;; B:LbindPats ) => A&B
  rule #append( A:LbindPat ;; B:Lbind     ) => A&B
  rule #append( A:LbindPat ;; B:Lbinds    ) => A&B
  rule #append( A:LbindPat ;; B:LbindPat  ) => A&B
  rule #append( A:LbindPat ;; B:LbindPats ) => A&B
  rule #append( A:Lbind     & B:Lbind     ;; C:LbindPat  ) => A&#append(B;;C)
  rule #append( A:Lbind     & B:Lbind     ;; C:LbindPats ) => A&#append(B;;C)
  rule #append( A:Lbind     & B:Lbinds    ;; C:LbindPat  ) => A&#append(B;;C)
  rule #append( A:Lbind     & B:Lbinds    ;; C:LbindPats ) => A&#append(B;;C)
  rule #append( A:Lbind     & B:LbindPat  ;; C:Lbind     ) => A&#append(B;;C)
  rule #append( A:Lbind     & B:LbindPat  ;; C:Lbinds    ) => A&#append(B;;C)
  rule #append( A:Lbind     & B:LbindPat  ;; C:LbindPat  ) => A&#append(B;;C)
  rule #append( A:Lbind     & B:LbindPat  ;; C:LbindPats ) => A&#append(B;;C)
  rule #append( A:Lbind     & B:LbindPats ;; C:Lbind     ) => A&#append(B;;C)
  rule #append( A:Lbind     & B:LbindPats ;; C:Lbinds    ) => A&#append(B;;C)
  rule #append( A:Lbind     & B:LbindPats ;; C:LbindPat  ) => A&#append(B;;C)
  rule #append( A:Lbind     & B:LbindPats ;; C:LbindPats ) => A&#append(B;;C)
  rule #append( A:LbindPat  & B:Lbind     ;; C:Lbind     ) => A&#append(B;;C)
  rule #append( A:LbindPat  & B:Lbind     ;; C:Lbinds    ) => A&#append(B;;C)
  rule #append( A:LbindPat  & B:Lbind     ;; C:LbindPat  ) => A&#append(B;;C)
  rule #append( A:LbindPat  & B:Lbind     ;; C:LbindPats ) => A&#append(B;;C)
  rule #append( A:LbindPat  & B:Lbinds    ;; C:Lbind     ) => A&#append(B;;C)
  rule #append( A:LbindPat  & B:Lbinds    ;; C:Lbinds    ) => A&#append(B;;C)
  rule #append( A:LbindPat  & B:Lbinds    ;; C:LbindPat  ) => A&#append(B;;C)
  rule #append( A:LbindPat  & B:Lbinds    ;; C:LbindPats ) => A&#append(B;;C)
  rule #append( A:LbindPat  & B:LbindPat  ;; C:Lbind     ) => A&#append(B;;C)
  rule #append( A:LbindPat  & B:LbindPat  ;; C:Lbinds    ) => A&#append(B;;C)
  rule #append( A:LbindPat  & B:LbindPat  ;; C:LbindPat  ) => A&#append(B;;C)
  rule #append( A:LbindPat  & B:LbindPat  ;; C:LbindPats ) => A&#append(B;;C)
  rule #append( A:LbindPat  & B:LbindPats ;; C:Lbind     ) => A&#append(B;;C)
  rule #append( A:LbindPat  & B:LbindPats ;; C:Lbinds    ) => A&#append(B;;C)
  rule #append( A:LbindPat  & B:LbindPats ;; C:LbindPat  ) => A&#append(B;;C)
  rule #append( A:LbindPat  & B:LbindPats ;; C:LbindPats ) => A&#append(B;;C)
  // PbindPats
  rule #append( A:Pbind    ;; B:PbindPat  ) => A&B
  rule #append( A:Pbind    ;; B:PbindPats ) => A&B
  rule #append( A:PbindPat ;; B:Pbind     ) => A&B
  rule #append( A:PbindPat ;; B:Pbinds    ) => A&B
  rule #append( A:PbindPat ;; B:PbindPat  ) => A&B
  rule #append( A:PbindPat ;; B:PbindPats ) => A&B
  rule #append( A:Pbind     & B:Pbind     ;; C:PbindPat  ) => A&#append(B;;C)
  rule #append( A:Pbind     & B:Pbind     ;; C:PbindPats ) => A&#append(B;;C)
  rule #append( A:Pbind     & B:Pbinds    ;; C:PbindPat  ) => A&#append(B;;C)
  rule #append( A:Pbind     & B:Pbinds    ;; C:PbindPats ) => A&#append(B;;C)
  rule #append( A:Pbind     & B:PbindPat  ;; C:Pbind     ) => A&#append(B;;C)
  rule #append( A:Pbind     & B:PbindPat  ;; C:Pbinds    ) => A&#append(B;;C)
  rule #append( A:Pbind     & B:PbindPat  ;; C:PbindPat  ) => A&#append(B;;C)
  rule #append( A:Pbind     & B:PbindPat  ;; C:PbindPats ) => A&#append(B;;C)
  rule #append( A:Pbind     & B:PbindPats ;; C:Pbind     ) => A&#append(B;;C)
  rule #append( A:Pbind     & B:PbindPats ;; C:Pbinds    ) => A&#append(B;;C)
  rule #append( A:Pbind     & B:PbindPats ;; C:PbindPat  ) => A&#append(B;;C)
  rule #append( A:Pbind     & B:PbindPats ;; C:PbindPats ) => A&#append(B;;C)
  rule #append( A:PbindPat  & B:Pbind     ;; C:Pbind     ) => A&#append(B;;C)
  rule #append( A:PbindPat  & B:Pbind     ;; C:Pbinds    ) => A&#append(B;;C)
  rule #append( A:PbindPat  & B:Pbind     ;; C:PbindPat  ) => A&#append(B;;C)
  rule #append( A:PbindPat  & B:Pbind     ;; C:PbindPats ) => A&#append(B;;C)
  rule #append( A:PbindPat  & B:Pbinds    ;; C:Pbind     ) => A&#append(B;;C)
  rule #append( A:PbindPat  & B:Pbinds    ;; C:Pbinds    ) => A&#append(B;;C)
  rule #append( A:PbindPat  & B:Pbinds    ;; C:PbindPat  ) => A&#append(B;;C)
  rule #append( A:PbindPat  & B:Pbinds    ;; C:PbindPats ) => A&#append(B;;C)
  rule #append( A:PbindPat  & B:PbindPat  ;; C:Pbind     ) => A&#append(B;;C)
  rule #append( A:PbindPat  & B:PbindPat  ;; C:Pbinds    ) => A&#append(B;;C)
  rule #append( A:PbindPat  & B:PbindPat  ;; C:PbindPat  ) => A&#append(B;;C)
  rule #append( A:PbindPat  & B:PbindPat  ;; C:PbindPats ) => A&#append(B;;C)
  rule #append( A:PbindPat  & B:PbindPats ;; C:Pbind     ) => A&#append(B;;C)
  rule #append( A:PbindPat  & B:PbindPats ;; C:Pbinds    ) => A&#append(B;;C)
  rule #append( A:PbindPat  & B:PbindPats ;; C:PbindPat  ) => A&#append(B;;C)
  rule #append( A:PbindPat  & B:PbindPats ;; C:PbindPats ) => A&#append(B;;C)
  // RbindPats
  rule #append( A:Rbind    ;; B:RbindPat  ) => A&B
  rule #append( A:Rbind    ;; B:RbindPats ) => A&B
  rule #append( A:RbindPat ;; B:Rbind     ) => A&B
  rule #append( A:RbindPat ;; B:Rbinds    ) => A&B
  rule #append( A:RbindPat ;; B:RbindPat  ) => A&B
  rule #append( A:RbindPat ;; B:RbindPats ) => A&B
  rule #append( A:Rbind     & B:Rbind     ;; C:RbindPat  ) => A&#append(B;;C)
  rule #append( A:Rbind     & B:Rbind     ;; C:RbindPats ) => A&#append(B;;C)
  rule #append( A:Rbind     & B:Rbinds    ;; C:RbindPat  ) => A&#append(B;;C)
  rule #append( A:Rbind     & B:Rbinds    ;; C:RbindPats ) => A&#append(B;;C)
  rule #append( A:Rbind     & B:RbindPat  ;; C:Rbind     ) => A&#append(B;;C)
  rule #append( A:Rbind     & B:RbindPat  ;; C:Rbinds    ) => A&#append(B;;C)
  rule #append( A:Rbind     & B:RbindPat  ;; C:RbindPat  ) => A&#append(B;;C)
  rule #append( A:Rbind     & B:RbindPat  ;; C:RbindPats ) => A&#append(B;;C)
  rule #append( A:Rbind     & B:RbindPats ;; C:Rbind     ) => A&#append(B;;C)
  rule #append( A:Rbind     & B:RbindPats ;; C:Rbinds    ) => A&#append(B;;C)
  rule #append( A:Rbind     & B:RbindPats ;; C:RbindPat  ) => A&#append(B;;C)
  rule #append( A:Rbind     & B:RbindPats ;; C:RbindPats ) => A&#append(B;;C)
  rule #append( A:RbindPat  & B:Rbind     ;; C:Rbind     ) => A&#append(B;;C)
  rule #append( A:RbindPat  & B:Rbind     ;; C:Rbinds    ) => A&#append(B;;C)
  rule #append( A:RbindPat  & B:Rbind     ;; C:RbindPat  ) => A&#append(B;;C)
  rule #append( A:RbindPat  & B:Rbind     ;; C:RbindPats ) => A&#append(B;;C)
  rule #append( A:RbindPat  & B:Rbinds    ;; C:Rbind     ) => A&#append(B;;C)
  rule #append( A:RbindPat  & B:Rbinds    ;; C:Rbinds    ) => A&#append(B;;C)
  rule #append( A:RbindPat  & B:Rbinds    ;; C:RbindPat  ) => A&#append(B;;C)
  rule #append( A:RbindPat  & B:Rbinds    ;; C:RbindPats ) => A&#append(B;;C)
  rule #append( A:RbindPat  & B:RbindPat  ;; C:Rbind     ) => A&#append(B;;C)
  rule #append( A:RbindPat  & B:RbindPat  ;; C:Rbinds    ) => A&#append(B;;C)
  rule #append( A:RbindPat  & B:RbindPat  ;; C:RbindPat  ) => A&#append(B;;C)
  rule #append( A:RbindPat  & B:RbindPat  ;; C:RbindPats ) => A&#append(B;;C)
  rule #append( A:RbindPat  & B:RbindPats ;; C:Rbind     ) => A&#append(B;;C)
  rule #append( A:RbindPat  & B:RbindPats ;; C:Rbinds    ) => A&#append(B;;C)
  rule #append( A:RbindPat  & B:RbindPats ;; C:RbindPat  ) => A&#append(B;;C)
  rule #append( A:RbindPat  & B:RbindPats ;; C:RbindPats ) => A&#append(B;;C)

// RhoKVPairs & RhoKVPats
  rule #append( A:RhoKVPair                ; B:RhoKVPairs ) => A,B
  rule #append( A:RhoKVPair                ; B:RhoKVPats  ) => A,B
  rule #append( A:RhoKVPat                 ; B:RhoKVPairs ) => A,B
  rule #append( A:RhoKVPat                 ; B:RhoKVPats  ) => A,B
  rule #append( A:RhoKVPair , B:RhoKVPairs ; C:RhoKVPairs ) => A,#append(B;C)
  rule #append( A:RhoKVPair , B:RhoKVPairs ; C:RhoKVPats  ) => A,#append(B;C)
  rule #append( A:RhoKVPair , B:RhoKVPats  ; C:RhoKVPairs ) => A,#append(B;C)
  rule #append( A:RhoKVPair , B:RhoKVPats  ; C:RhoKVPats  ) => A,#append(B;C)
  rule #append( A:RhoKVPat  , B:RhoKVPairs ; C:RhoKVPairs ) => A,#append(B;C)
  rule #append( A:RhoKVPat  , B:RhoKVPairs ; C:RhoKVPats  ) => A,#append(B;C)
  rule #append( A:RhoKVPat  , B:RhoKVPats  ; C:RhoKVPairs ) => A,#append(B;C)
  rule #append( A:RhoKVPat  , B:RhoKVPats  ; C:RhoKVPats  ) => A,#append(B;C)

//-----------
//--- #in ---
//-----------
// Int #int IntList
  rule A:Int #int ( B:Int            ) => A ==Int B
  rule A:Int #int ( B:Int , C:Procs  ) => A ==Int B orBool A #int (C)

// Name #in Names
  rule _:Name #in ( EmptyN           ) => false
  rule A:Name #in ( B:Name           ) => A ==K B requires notBool isEmptyName(B)
  rule A:Name #in ( B:Name , C:Names ) => A ==K B orBool A #in (C)

//------------
//--- #dec ---
//------------
// New name declarations
  // New[Pat]
  rule #dec( new A:VarDecs in { _:Proc    } ) => A
  rule #dec( new A:VarDecs in { _:ProcPat } ) => A

  rule #var( A:Var ) => A
  rule #var( A:Var ( _:Uri ) ) => A
  rule #var( A:VarDec , B:VarDecs ) => A , #var(B)
  rule #var( new A:VarDecs in { _:Proc    } ) => #var(A)
  rule #var( new A:VarDecs in { _:ProcPat } ) => #var(A)

  rule #newproc( new _:VarDecs in { A:Proc    } ) => A
  rule #newproc( new _:VarDecs in { A:ProcPat } ) => A

// #indecs deletes duplicates from a list of declared name variables
// i.e. it takes VarDecs and returns
  rule #indecs( A:Var ) => A
  rule #indecs( A:Var ( _:Uri ) ) => A
  rule #indecs( A:New    ) => #indecs(#dec(A))
  rule #indecs( A:NewPat ) => #indecs(#dec(A))
  // the head VarDec is added to a running set and list
  rule #indecs( A:VarDec , B:VarDecs ) => #indecs(B;SetItem(#var(A));#var(A))
  // later variables are checked for membership in the running set, if not there, add it,
  // and also add it to the end of the running list; #indecs is recursively called on remaining VarDecs
  rule #indecs( A:VarDec , B:VarDecs ; S:Set ; C:VarDecs )
    => #if #var(A) in S #then #indecs(B;S;C) #else #indecs(B;S SetItem(#var(A));#append(C;#var(A))) #fi
  rule #indecs( A:VarDec ; B:Set ; C:VarDecs ) => #if #var(A) in B #then C #else #append(C;#var(A)) #fi

//-------------
//--- #size ---
//-------------
// for RhoMap & RhoSet
  // RhoMap
  rule #size( { } ) => 0
  rule #size( { A:RhoKVPairs } ) => #length(A) // size(#KVs2map(A))
  rule #size( { A:RhoKVPats  } ) => #length(A) // size(#KVs2map(A))
  rule #size( { A:RhoKVPairs ... _:ProcVar } ) => #length(A)
  rule #size( { A:RhoKVPats  ... _:ProcVar } ) => #length(A)

  // RhoSet
  rule #size( Set( ) ) => 0
  rule #size( Set( A:Procs    ) ) => #length(A) // size(#procs2set(P))
  rule #size( Set( A:ProcPats ) ) => #length(A) // size( #pats2set(P))
  rule #size( Set( A:Procs    ... _:ProcVar ) ) => #length(A)
  rule #size( Set( A:ProcPats ... _:ProcVar ) ) => #length(A)

//---------------
//--- #length ---
//---------------
// Proc[Pat]s
  rule #length(   EmptyP  ) => 0
  rule #length(  *EmptyN  ) => 0
  rule #length( A:Proc    ) => 1 [owise]
  rule #length( _:ProcPat ) => 1
  rule #length( _:Proc    , A:Procs    ) => 1 +Int #length(A)
  rule #length( _:Proc    , A:ProcPats ) => 1 +Int #length(A)
  rule #length( _:ProcPat , A:Procs    ) => 1 +Int #length(A)
  rule #length( _:ProcPat , A:ProcPats ) => 1 +Int #length(A)

  // RhoList
  rule #length [ ] => 0
  rule #length [ A:Procs    ] => #length(A)
  rule #length [ A:ProcPats ] => #length(A)
  rule #length [ A:Procs    ... _:ProcVar ] => #length(A)
  rule #length [ A:ProcPats ... _:ProcVar ] => #length(A)

  // RhoKVPairs
  rule #length( EmptyP : EmptyP ) => 0
  rule #length( _:RhoKVPair     ) => 1 [owise]
  rule #length( _:RhoKVPat      ) => 1
  rule #length( _:RhoKVPair , B:RhoKVPairs ) => 1 +Int #length(B)
  rule #length( _:RhoKVPair , B:RhoKVPats  ) => 1 +Int #length(B)
  rule #length( _:RhoKVPat  , B:RhoKVPairs ) => 1 +Int #length(B)
  rule #length( _:RhoKVPat  , B:RhoKVPats  ) => 1 +Int #length(B)

  // RhoTuple
  rule #length ( P:Procs    ,) => #length(P)
  rule #length ( P:ProcPats ,) => #length(P)

// Name[Pat]s
  rule #length(   EmptyN  ) => 0
  rule #length(  @EmptyP  ) => 0
  rule #length( _:Name    ) => 1 [owise]
  rule #length( _:NamePat ) => 1
  rule #length( _:Name    , N:Names    ) => 1 +Int #length(N)
  rule #length( _:Name    , N:NamePats ) => 1 +Int #length(N)
  rule #length( _:NamePat , N:Names    ) => 1 +Int #length(N)
  rule #length( _:NamePat , N:NamePats ) => 1 +Int #length(N)

//--- Bind[Pat]s ---
// Binds - number of listens in a join[pat]
  // Lbind[Pat]s
  rule #length( _:LbindPat & _:LbindPat  ) => 2
  rule #length( _:LbindPat & A:LbindPats ) => 1 +Int #length(A)
  // Pbind[Pat]s
  rule #length( _:PbindPat & _:PbindPat  ) => 2
  rule #length( _:PbindPat & A:PbindPats ) => 1 +Int #length(A)
  // Rbind[Pat]s
  rule #length( _:RbindPat & _:RbindPat  ) => 2
  rule #length( _:RbindPat & A:RbindPats ) => 1 +Int #length(A)
  // Guarded
  rule #length( B:LbindPats _:Guard ) => #length(B)
  rule #length( B:PbindPats _:Guard ) => #length(B)
  rule #length( B:RbindPats _:Guard ) => #length(B)

  rule #length( match _:Proc    { M:MatchCases } ) => #length(M) [structural]
  rule #length( match _:Proc    { M:MCasePats  } ) => #length(M) [structural]
  rule #length( match _:ProcPat { M:MatchCases } ) => #length(M) [structural]
  rule #length( match _:ProcPat { M:MCasePats  } ) => #length(M) [structural]
  rule #length( A:MatchCase ) => 1
  rule #length( A:MCasePat  ) => 1
  rule #length( A:MatchCase B:MatchCases ) => 1 +Int #length(B)
  rule #length( A:MatchCase B:MCasePats  ) => 1 +Int #length(B)
  rule #length( A:MCasePat  B:MatchCases ) => 1 +Int #length(B)
  rule #length( A:MCasePat  B:MCasePats  ) => 1 +Int #length(B)

  rule #length( select { B:BranchPats } ) => #length(B) [structural]
  rule #length( A:BranchPat ) => 1
  rule #length( A:BranchPat B:BranchPats ) => 1 +Int #length(B)

// Concat
  // ConcatList
  rule #length+( _:ListOrVar   ) => 1
  rule #length+( _:ListOrVar   ++ A:ConcatList ) => 1 +Int #length+(A)
  // ConcatStr
  rule #length+( _:StringOrVar ) => 1
  rule #length+( _:StringOrVar ++ A:ConcatStr  ) => 1 +Int #length+(A)

// Interp
  rule #length+( _:StringOrVar %% A:InterpMaps ) => 1 +Int #length+(A)
  // InterpMaps
  rule #length+( _:RhoMap ) => 1
  rule #length+( _:RhoMap %% A:InterpMaps ) => 1 +Int #length+(A)

//-------------
//--- #chan ---
//-------------
// Bind
  rule #chan(            <-  N:Name ) => N
  rule #chan( _:Names    <-  N:Name ) => N
  rule #chan( _:NamePats <-  N:Name ) => N
  rule #chan(            <=  N:Name ) => N
  rule #chan( _:Names    <=  N:Name ) => N
  rule #chan( _:NamePats <=  N:Name ) => N
  rule #chan(            <<- N:Name ) => N
  rule #chan( _:Names    <<- N:Name ) => N
  rule #chan( _:NamePats <<- N:Name ) => N
  // Guraded
  rule #chan( B:Lbind _:Guard ) => #chan(B)
  rule #chan( B:Pbind _:Guard ) => #chan(B)
  rule #chan( B:Rbind _:Guard ) => #chan(B)

  // comma-separated list of channels involved in bindings
  rule #chan( B:Lbind & C:Lbind  ) => #chan(B) , #chan(C)
  rule #chan( B:Lbind & C:Lbinds ) => #chan(B) , #chan(C)
  rule #chan( B:Rbind & C:Rbind  ) => #chan(B) , #chan(C)
  rule #chan( B:Rbind & C:Rbinds ) => #chan(B) , #chan(C)
  rule #chan( B:Pbind & C:Pbind  ) => #chan(B) , #chan(C)
  rule #chan( B:Pbind & C:Pbinds ) => #chan(B) , #chan(C)

  rule #chan( B:Lbinds _:Guard ) => #chan(B)
  rule #chan( B:Pbinds _:Guard ) => #chan(B)
  rule #chan( B:Rbinds _:Guard ) => #chan(B)

// BindPat
  rule #chan(            <-  N:NamePat ) => N
  rule #chan( _:Names    <-  N:NamePat ) => N
  rule #chan( _:NamePats <-  N:NamePat ) => N
  rule #chan(            <=  N:NamePat ) => N
  rule #chan( _:Names    <=  N:NamePat ) => N
  rule #chan( _:NamePats <=  N:NamePat ) => N
  rule #chan(            <<- N:NamePat ) => N
  rule #chan( _:Names    <<- N:NamePat ) => N
  rule #chan( _:NamePats <<- N:NamePat ) => N
  // Guraded
  rule #chan( B:LbindPat _:Guard ) => #chan(B)
  rule #chan( B:PbindPat _:Guard ) => #chan(B)
  rule #chan( B:RbindPat _:Guard ) => #chan(B)

  // comma-separated list of channels involved in bindings
  rule #chan( B:Lbind    & C:LbindPat  ) => #chan(B) , #chan(C)
  rule #chan( B:LbindPat & C:Lbind     ) => #chan(B) , #chan(C)
  rule #chan( B:LbindPat & C:LbindPat  ) => #chan(B) , #chan(C)
  rule #chan( B:Lbind    & C:LbindPats ) => #chan(B) , #chan(C)
  rule #chan( B:LbindPat & C:Lbinds    ) => #chan(B) , #chan(C)
  rule #chan( B:Lbind    & C:LbindPats ) => #chan(B) , #chan(C)
  rule #chan( B:LbindPat & C:LbindPats ) => #chan(B) , #chan(C)
  rule #chan( B:Pbind    & C:PbindPat  ) => #chan(B) , #chan(C)
  rule #chan( B:PbindPat & C:Pbind     ) => #chan(B) , #chan(C)
  rule #chan( B:PbindPat & C:PbindPat  ) => #chan(B) , #chan(C)
  rule #chan( B:Pbind    & C:PbindPats ) => #chan(B) , #chan(C)
  rule #chan( B:PbindPat & C:Pbinds    ) => #chan(B) , #chan(C)
  rule #chan( B:Pbind    & C:PbindPats ) => #chan(B) , #chan(C)
  rule #chan( B:PbindPat & C:PbindPats ) => #chan(B) , #chan(C)
  rule #chan( B:Rbind    & C:RbindPat  ) => #chan(B) , #chan(C)
  rule #chan( B:RbindPat & C:Rbind     ) => #chan(B) , #chan(C)
  rule #chan( B:RbindPat & C:RbindPat  ) => #chan(B) , #chan(C)
  rule #chan( B:Rbind    & C:RbindPats ) => #chan(B) , #chan(C)
  rule #chan( B:RbindPat & C:Rbinds    ) => #chan(B) , #chan(C)
  rule #chan( B:Rbind    & C:RbindPats ) => #chan(B) , #chan(C)
  rule #chan( B:RbindPat & C:RbindPats ) => #chan(B) , #chan(C)
  // Guarded
  rule #chan( B:LbindPats _:Guard ) => #chan(B)
  rule #chan( B:PbindPats _:Guard ) => #chan(B)
  rule #chan( B:RbindPats _:Guard ) => #chan(B)

//-------------
//--- #lislen ---
//-------------
// number of binding variables in a listen
// Bind
  rule #lislen(            <-  _:Name ) => 0
  rule #lislen( N:Names    <-  _:Name ) => #length(N)
  rule #lislen( N:NamePats <-  _:Name ) => #length(N)
  rule #lislen(            <=  _:Name ) => 0
  rule #lislen( N:Names    <=  _:Name ) => #length(N)
  rule #lislen( N:NamePats <=  _:Name ) => #length(N)
  rule #lislen(            <<- _:Name ) => 0
  rule #lislen( N:Names    <<- _:Name ) => #length(N)
  rule #lislen( N:NamePats <<- _:Name ) => #length(N)
  // Guraded
  rule #lislen( B:Lbind _:Guard ) => #lislen(B)
  rule #lislen( B:Pbind _:Guard ) => #lislen(B)
  rule #lislen( B:Rbind _:Guard ) => #lislen(B)
// BindPat
  rule #lislen(            <-  _:NamePat ) => 0
  rule #lislen( N:Names    <-  _:NamePat ) => #length(N)
  rule #lislen( N:NamePats <-  _:NamePat ) => #length(N)
  rule #lislen(            <=  _:NamePat ) => 0
  rule #lislen( N:Names    <=  _:NamePat ) => #length(N)
  rule #lislen( N:NamePats <=  _:NamePat ) => #length(N)
  rule #lislen(            <<- _:NamePat ) => 0
  rule #lislen( N:Names    <<- _:NamePat ) => #length(N)
  rule #lislen( N:NamePats <<- _:NamePat ) => #length(N)
  // Guarded
  rule #lislen( B:LbindPat _:Guard ) => #lislen(B)
  rule #lislen( B:PbindPat _:Guard ) => #lislen(B)
  rule #lislen( B:RbindPat _:Guard ) => #lislen(B)

//-------------
//--- #bvar ---
//-------------
// binding variables
// BindPat
  rule #bvar(            <-  _:NamePat ) => EmptyN
  rule #bvar( N:Names    <-  _:NamePat ) => N
  rule #bvar( N:NamePats <-  _:NamePat ) => N
  rule #bvar(            <=  _:NamePat ) => EmptyN
  rule #bvar( N:Names    <=  _:NamePat ) => N
  rule #bvar( N:NamePats <=  _:NamePat ) => N
  rule #bvar(            <<- _:NamePat ) => EmptyN
  rule #bvar( N:Names    <<- _:NamePat ) => N
  rule #bvar( N:NamePats <<- _:NamePat ) => N
  // guarded
  rule #bvar( B:LbindPat _:Guard ) => #bvar(B)
  rule #bvar( B:PbindPat _:Guard ) => #bvar(B)
  rule #bvar( B:RbindPat _:Guard ) => #bvar(B)

// Multiple Bindings
  rule #bvar( B:LbindPat & C:LbindPat  ) => #append(#bvar(B);#bvar(C))
  rule #bvar( B:LbindPat & C:LbindPats ) => #append(#bvar(B);#bvar(C))
  rule #bvar( B:PbindPat & C:PbindPat  ) => #append(#bvar(B);#bvar(C))
  rule #bvar( B:PbindPat & C:PbindPats ) => #append(#bvar(B);#bvar(C))
  rule #bvar( B:RbindPat & C:RbindPat  ) => #append(#bvar(B);#bvar(C))
  rule #bvar( B:RbindPat & C:RbindPats ) => #append(#bvar(B);#bvar(C))
  // guarded
  rule #bvar( B:LbindPats _:Guard ) => #bvar(B)
  rule #bvar( B:PbindPats _:Guard ) => #bvar(B)
  rule #bvar( B:RbindPats _:Guard ) => #bvar(B)

//---------------
//--- #quotes ---
//---------------
  rule #quotes( A:ProcPat ) => @A
  rule #quotes( A:ProcPat , B:ProcPats ) => @A , #quotes(B)

//--------------
//--- #evals ---
//--------------
  rule #evals( A:NamePat ) => *A
  rule #evals( A:NamePat , B:NamePats ) => *A , #evals(B)

//--------------------
//--- #interpolate ---
//--------------------
// #interpolate( String ; RhoMap )
  // substitutes string in first occurrence of ${...} and ignores all } before ${
  rule #interpolate( S:String ; { A:String : B:String } )
       => #if substrString(S,findString(S,"${",0) +Int 2,findString(S,"}",findString(S,"${",0) +Int 2)) ==String A
          #then substrString(S,0,findString(S,"${",0)) // this part extracts A from original string
          +String replaceAll(substrString(S,findString(S,"${",0) +Int 2,findString(S,"}",findString(S,"${",0) +Int 2)),
                substrString(S,findString(S,"${",0) +Int 2,findString(S,"}",findString(S,"${",0) +Int 2)), B) // this part substitutes B for A
          +String substrString(S,findString(S,"}",findString(S,"${",0) +Int 2) +Int 1, lengthString(S))
          #else S
          #fi
  rule #interpolate( S:String ; { A:String : B:String , KV:RhoKVPairs } )
       => #if substrString(S,findString(S,"${",0) +Int 2,findString(S,"}",findString(S,"${",0) +Int 2)) ==String A
          #then substrString(S,0,findString(S,"${",0)) // this part extracts A from original string
          +String replaceAll(substrString(S,findString(S,"${",0) +Int 2,findString(S,"}",findString(S,"${",0) +Int 2)),
                substrString(S,findString(S,"${",0) +Int 2,findString(S,"}",findString(S,"${",0) +Int 2)), B) // this part substitutes B for A
          +String substrString(S,findString(S,"}",findString(S,"${",0) +Int 2) +Int 1, lengthString(S))
          #else #interpolate(S;{KV})
          #fi
  // if key is not a string, bypass it
  rule #interpolate( S:String ; { A:Proc : _:Proc , KV:RhoKVPairs } ) => #interpolate(S;{KV}) requires notBool isString(A)
  // if all else fails, return the original string
  //rule #interpolate( S:String ; _:RhoMap ) => S [owise]

  rule #interpolate( S:String ; A:RhoMap %% B:InterpMaps )
    => #interpolate(#interpolate(S;A);B)

//------------------
//--- Predicates ---
//------------------
// Maps -- syntactic Proc inclusion in set of keys
  rule _:Proc    #in_keys   A:RhoMap => false requires isEmptyMap(A)
  rule _:ProcPat #in_keys   _:RhoMap => false
  rule A:Proc    #in_keys { B:RhoKVPairs } => A in keys(#KVs2map(B))
  rule A:Proc    #in_keys { B:RhoKVPats  } => A in keys(#KVs2map(B))
  rule A:ProcPat #in_keys { B:RhoKVPats  } => A in keys(#KVs2map(B))

// Sets -- syntactic Proc inclusion in a set of Procs
  rule _:Proc    #in_set A:RhoSet => false requires isEmptySet(A)
  rule _:ProcPat #in_set _:RhoSet => false
  rule A:Proc    #in_set Set( B:Procs    ) => A in #procs2set(B)
  rule A:Proc    #in_set Set( B:ProcPats ) => A in  #pats2set(B)
  rule A:ProcPat #in_set Set( B:ProcPats ) => A in  #pats2set(B)

//---------------
//--- #mapSub ---
//---------------
// guards bound variables from generating substitutions maps
  rule #mapSub( .Set ) => .Map
  rule #mapSub( SetItem( A:Name ) S:Set ) => A |-> @sub #mapSub(S)
  rule #mapSub( SetItem( A:Proc ) S:Set ) => A |->  sub #mapSub(S)

  // #mapNil -- for Par matching/sub
  rule #mapNil( .Set ) => .Map
  rule #mapNil( SetItem( A:Proc ) S:Set ) => A |->  Nil #mapNil(S)

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
  rule #set2Par( SetItem( A:Proc , N:Int ) S:Set ) => #parDup(A;N) | #set2Par(S)
       requires notBool S <=Set .Set

// applied after normalization
  rule #parlength( A:Proc    ) => 1 requires notBool isPar(A)
  rule #parlength( A:Par     ) => #length(#par2procs(A))
  rule #parlength( A:ProcPat ) => 1 requires notBool isParPat(A)
  rule #parlength( A:ParPat  ) => #length(#par2pats(A))

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

// #procs2par
  rule #procs2par( A:Proc ) => A
  rule #procs2par( A:Proc , B:Procs ) => A | #procs2par(B)

// #par2pats
  rule #par2pats( A:ProcPat | B:ProcPat ) => A,#par2pats(B) requires notBool isParPat(A)
  rule #par2pats( A:ProcPat ) => A requires notBool isParPat(A)

// #pats2par
  rule #pats2par( A:ProcPat ) => A
  rule #pats2par( A:ProcPat , B:ProcPats ) => A | #pats2par(B)

//----------------------------
//--- #set2procs/name/pats ---
//----------------------------
// Set <-> Names
  rule #names2set( A:Name                  ) => SetItem(A)
  rule #names2set( A:Name , B:Names        ) => SetItem(A) #names2set(B)
  rule #set2names( SetItem( A:Name )       ) => A
  rule #set2names( SetItem( A:Name ) S:Set ) => A , #set2names(S) requires S =/=K .Set

// Set <-> Procs
  rule #procs2set( A:Proc                  ) => SetItem(A)
  rule #procs2set( A:Proc , B:Procs        ) => SetItem(A) #procs2set(B)
  rule #set2procs( SetItem( A:Proc )       ) => A
  rule #set2procs( SetItem( A:Proc ) S:Set ) => A , #set2procs(S) requires S =/=K .Set

// Set <-> Pats
  rule #set2pats( SetItem( A:Name    ) ) => A
  rule #set2pats( SetItem( A:NamePat ) ) => A
  rule #set2pats( SetItem( A:Proc    ) ) => A
  rule #set2pats( SetItem( A:ProcPat ) ) => A
  rule #set2pats( SetItem( A:Proc    ) B:Set ) => A , #set2pats(B) requires B =/=K .Set
  rule #set2pats( SetItem( A:ProcPat ) B:Set ) => A , #set2pats(B) requires B =/=K .Set
  rule #set2pats( SetItem( A:Name    ) B:Set ) => A , #set2pats(B) requires B =/=K .Set
  rule #set2pats( SetItem( A:NamePat ) B:Set ) => A , #set2pats(B) requires B =/=K .Set

  rule #pats2set( A:Name    ) => SetItem(A)
  rule #pats2set( A:NamePat ) => SetItem(A)
  rule #pats2set( A:Name    , B:Names    ) => SetItem(A) #pats2set(B)
  rule #pats2set( A:Name    , B:NamePats ) => SetItem(A) #pats2set(B)
  rule #pats2set( A:NamePat , B:Names    ) => SetItem(A) #pats2set(B)
  rule #pats2set( A:NamePat , B:NamePats ) => SetItem(A) #pats2set(B)
  rule #pats2set( A:Proc    ) => SetItem(A)
  rule #pats2set( A:ProcPat ) => SetItem(A)
  rule #pats2set( A:Proc    , B:Procs    ) => SetItem(A) #pats2set(B)
  rule #pats2set( A:Proc    , B:ProcPats ) => SetItem(A) #pats2set(B)
  rule #pats2set( A:ProcPat , B:Procs    ) => SetItem(A) #pats2set(B)
  rule #pats2set( A:ProcPat , B:ProcPats ) => SetItem(A) #pats2set(B)

//-----------------
//--- Built-ins ---
//-----------------
// List
  rule #procs2list( A:Proc ) => ListItem(A)
  rule #procs2list( A:Proc , B:Procs ) => ListItem(A) #procs2list(B)
  rule #list2procs( ListItem( A:Proc ) ) => A
  rule #list2procs( ListItem( A:Proc ) B:List ) => A , #list2procs(B) requires B =/=K .List

  rule #names2list( A:Name ) => ListItem(A)
  rule #names2list( A:Name , B:Names ) => ListItem(A) #names2list(B)
  rule #list2names( ListItem( A:Name ) ) => A
  rule #list2names( ListItem( A:Name ) B:List ) => A , #list2names(B) requires B =/=K .List

  rule #pats2list( A:ProcPat ) => ListItem(A)
  rule #pats2list( A:ProcPat , B:ProcPats ) => ListItem(A) #pats2list(B)
  rule #pats2list( A:NamePat ) => ListItem(A)
  rule #pats2list( A:NamePat , B:NamePats ) => ListItem(A) #pats2list(B)
  rule #list2pats( ListItem( A:ProcPat ) ) => A
  rule #list2pats( ListItem( A:ProcPat ) B:List ) => A , #list2pats(B) requires B =/=K .List
  rule #list2pats( ListItem( A:NamePat ) ) => A
  rule #list2pats( ListItem( A:NamePat ) B:List ) => A , #list2pats(B) requires B =/=K .List

  rule #list2rho( .List ) => [ ]
  rule #list2rho( ListItem( A:Proc    ) B:List ) => [A,#list2procs(B)]
  rule #list2rho( ListItem( A:ProcPat ) B:List ) => [A, #list2pats(B)]
  rule #concat( [ ] ; A:RhoList ) => A
  rule #concat( [ ] ; A:ListPat ) => A
  rule #concat( A:RhoList ; [ ] ) => A requires notBool isEmptyList(A)
  rule #concat( A:ListPat ; [ ] ) => A
  rule #concat( [ A:Procs    ] ; [ B:Procs    ] ) => [#append(A;B)]
  rule #concat( [ A:Procs    ] ; [ B:ProcPats ] ) => [#append(A;B)]
  rule #concat( [ A:ProcPats ] ; [ B:Procs    ] ) => [#append(A;B)]
  rule #concat( [ A:ProcPats ] ; [ B:ProcPats ] ) => [#append(A;B)]

  rule #concat( A:RhoList ; B:RhoList ++ C:RhoList    ) => #concat(#concat(A;B);C)
  rule #concat( A:RhoList ; B:RhoList ++ C:ConcatList ) => #concat(#concat(A;B);C)

// String
  rule #concat( A:String ; B:String ) => A +String B
  rule #concat( A:String ; B:String ++ C:ConcatStr ) => #concat(A +String B;C)

// Map
  rule #map2rho( A:Map ) => #KVs2rho(#map2KVs(A))
  // check if each right arg element is seq to a left arg element
  rule #unionMap( { } ; A:RhoMap ) => A
  rule #unionMap( { } ; A:MapPat ) => A
  rule #unionMap( A:RhoMap ; { } ) => A
  rule #unionMap( A:MapPat ; { } ) => A
  rule #unionMap( { A:RhoKVPairs } ; { B:RhoKVPairs } ) => {#map2KVs(#KVs2map(#append(A;B)))}
  rule #unionMap( { A:RhoKVPairs } ; { B:RhoKVPats  } ) => {#map2KVs(#KVs2map(#append(A;B)))}
  rule #unionMap( { A:RhoKVPats  } ; { B:RhoKVPairs } ) => {#map2KVs(#KVs2map(#append(A;B)))}
  rule #unionMap( { A:RhoKVPats  } ; { B:RhoKVPats  } ) => {#map2KVs(#KVs2map(#append(A;B)))}

  rule #map2KVs( .Map ) => EmptyP : EmptyP
  rule #map2KVs( A:Proc    |-> B:Proc    ) => A : B
  rule #map2KVs( A:Proc    |-> B:ProcPat ) => A : B
  rule #map2KVs( A:ProcPat |-> B:Proc    ) => A : B
  rule #map2KVs( A:ProcPat |-> B:ProcPat ) => A : B
  rule #map2KVs( A:Proc    |-> B:Proc    M:Map ) => A : B , #map2KVs(M) requires M =/=K .Map
  rule #map2KVs( A:Proc    |-> B:ProcPat M:Map ) => A : B , #map2KVs(M) requires M =/=K .Map
  rule #map2KVs( A:ProcPat |-> B:Proc    M:Map ) => A : B , #map2KVs(M) requires M =/=K .Map
  rule #map2KVs( A:ProcPat |-> B:ProcPat M:Map ) => A : B , #map2KVs(M) requires M =/=K .Map

// Tuple
  rule #tuple2rho( ListItem( A:Proc    ) ) => (A,)
  rule #tuple2rho( ListItem( A:ProcPat ) ) => (A,)
  rule #tuple2rho( ListItem( A:Proc    ) B:List ) => #list2tuple(#concat([A];#list2rho(B))) requires B =/=K .List
  rule #tuple2rho( ListItem( A:ProcPat ) B:List ) => #list2tuple(#concat([A];#list2rho(B))) requires B =/=K .List

  rule #list2tuple( [ A:Procs     ] ) => (A,)
  rule #list2tuple( [ A:ProcPats  ] ) => (A,)
  rule #tuple2list( ( A:Procs    ,) ) => [A]
  rule #tuple2list( ( A:ProcPats ,) ) => [A]

// Set
  rule #set2rho( .Set ) => Set( )
  rule #set2rho( SetItem( A:Proc    ) B:Set ) => Set(#append(A;#set2procs(B)))
  rule #set2rho( SetItem( A:ProcPat ) B:Set ) => Set(#append(A;#set2procs(B)))
  // #unionSet
  rule #unionSet( Set( ) ; A:RhoSet ) => A
  rule #unionSet( Set( ) ; A:SetPat ) => A
  rule #unionSet( A:RhoSet ; Set( ) ) => A
  rule #unionSet( A:SetPat ; Set( ) ) => A
  // check if each right arg element is seq to a left arg element -- e.g. #unionSet( Set(a,b,c) ; Set(b,c,d) ) => Set( #set2procs( { a,b,c,d } ) ) => Set( a,b,c,d )
  rule #unionSet( Set( A:Procs    ) ; Set( B:Procs    ) ) => Set(#set2procs(#procs2set(A) #procs2set(B)))
  rule #unionSet( Set( A:Procs    ) ; Set( B:ProcPats ) ) => Set( #set2pats(#procs2set(A)  #pats2set(B)))
  rule #unionSet( Set( A:ProcPats ) ; Set( B:Procs    ) ) => Set( #set2pats( #pats2set(A) #procs2set(B)))
  rule #unionSet( Set( A:ProcPats ) ; Set( B:ProcPats ) ) => Set( #set2pats( #pats2set(A)  #pats2set(B)))

//----------------------------------------------------
//--- Channel, Bind, Binding Variables Sets & Maps ---
//----------------------------------------------------
// Channel set: RecPat
// returns Set of (Int;NamePat) "bind number ; channel"
  rule #chanSet( for( A:BindPat          ){ _:ProcPat } ) => SetItem(0;#chan(A))
  rule #chanSet( for( A:BindPat  _:Guard ){ _:ProcPat } ) => SetItem(0;#chan(A))
  rule #chanSet( for( A:BindPats         ){ _:ProcPat } ) => #chanSet(A;;0)
  rule #chanSet( for( A:BindPats _:Guard ){ _:ProcPat } ) => #chanSet(A;;0)
  // Channel set: BindPat[s]
  rule #chanSet( A:LbindPat               ;; I:Int ) => SetItem(I;#chan(A))
  rule #chanSet( A:LbindPat & B:LbindPat  ;; I:Int ) => SetItem(I;#chan(A)) #chanSet(B;;I +Int 1)
  rule #chanSet( A:LbindPat & B:LbindPats ;; I:Int ) => SetItem(I;#chan(A)) #chanSet(B;;I +Int 1)
  rule #chanSet( A:PbindPat               ;; I:Int ) => SetItem(I;#chan(A))
  rule #chanSet( A:PbindPat & B:PbindPat  ;; I:Int ) => SetItem(I;#chan(A)) #chanSet(B;;I +Int 1)
  rule #chanSet( A:PbindPat & B:PbindPats ;; I:Int ) => SetItem(I;#chan(A)) #chanSet(B;;I +Int 1)
  rule #chanSet( A:RbindPat               ;; I:Int ) => SetItem(I;#chan(A))
  rule #chanSet( A:RbindPat & B:RbindPat  ;; I:Int ) => SetItem(I;#chan(A)) #chanSet(B;;I +Int 1)
  rule #chanSet( A:RbindPat & B:RbindPats ;; I:Int ) => SetItem(I;#chan(A)) #chanSet(B;;I +Int 1)

// Channel map: RecPat
// returns Map of Int |-> NamePat: "bind number ; channel"
  rule #chanMap( for( A:BindPat          ){ _:ProcPat } ) => 0 |-> #chan(A)
  rule #chanMap( for( A:BindPat  _:Guard ){ _:ProcPat } ) => 0 |-> #chan(A)
  rule #chanMap( for( A:BindPats         ){ _:ProcPat } ) => #chanMap(A;;0)
  rule #chanMap( for( A:BindPats _:Guard ){ _:ProcPat } ) => #chanMap(A;;0)
  // Channel set: BindPat[s]
  rule #chanMap( A:LbindPat               ;; I:Int ) => I |-> #chan(A)
  rule #chanMap( A:LbindPat & B:LbindPat  ;; I:Int ) => I |-> #chan(A) #chanMap(B;;I +Int 1)
  rule #chanMap( A:LbindPat & B:LbindPats ;; I:Int ) => I |-> #chan(A) #chanMap(B;;I +Int 1)
  rule #chanMap( A:PbindPat               ;; I:Int ) => I |-> #chan(A)
  rule #chanMap( A:PbindPat & B:PbindPat  ;; I:Int ) => I |-> #chan(A) #chanMap(B;;I +Int 1)
  rule #chanMap( A:PbindPat & B:PbindPats ;; I:Int ) => I |-> #chan(A) #chanMap(B;;I +Int 1)
  rule #chanMap( A:RbindPat               ;; I:Int ) => I |-> #chan(A)
  rule #chanMap( A:RbindPat & B:RbindPat  ;; I:Int ) => I |-> #chan(A) #chanMap(B;;I +Int 1)
  rule #chanMap( A:RbindPat & B:RbindPats ;; I:Int ) => I |-> #chan(A) #chanMap(B;;I +Int 1)

// Bind set: Receive & RecPat
// returns Set of (Int;Bind[Pat]) "bind number ; Bind[Pat]"
  rule #bindSet( for( A:LbindPat          ){ _:ProcPat } ) => SetItem(0;A)
  rule #bindSet( for( A:PbindPat          ){ _:ProcPat } ) => SetItem(0;A)
  rule #bindSet( for( A:RbindPat          ){ _:ProcPat } ) => SetItem(0;A)
  rule #bindSet( for( A:LbindPat  _:Guard ){ _:ProcPat } ) => SetItem(0;A)
  rule #bindSet( for( A:PbindPat  _:Guard ){ _:ProcPat } ) => SetItem(0;A)
  rule #bindSet( for( A:RbindPat  _:Guard ){ _:ProcPat } ) => SetItem(0;A)
  rule #bindSet( for( A:LbindPats         ){ _:ProcPat } ) => #bindSet(A;;0)
  rule #bindSet( for( A:PbindPats         ){ _:ProcPat } ) => #bindSet(A;;0)
  rule #bindSet( for( A:RbindPats         ){ _:ProcPat } ) => #bindSet(A;;0)
  rule #bindSet( for( A:LbindPats _:Guard ){ _:ProcPat } ) => #bindSet(A;;0)
  rule #bindSet( for( A:PbindPats _:Guard ){ _:ProcPat } ) => #bindSet(A;;0)
  rule #bindSet( for( A:RbindPats _:Guard ){ _:ProcPat } ) => #bindSet(A;;0)
  // Bind set: BindPat[s]
  rule #bindSet( A:LbindPat               ;; I:Int ) => SetItem(I;A)
  rule #bindSet( A:LbindPat & B:LbindPat  ;; I:Int ) => SetItem(I;A) #bindSet(B;;I +Int 1)
  rule #bindSet( A:LbindPat & B:LbindPats ;; I:Int ) => SetItem(I;A) #bindSet(B;;I +Int 1)
  rule #bindSet( A:PbindPat               ;; I:Int ) => SetItem(I;A)
  rule #bindSet( A:PbindPat & B:PbindPat  ;; I:Int ) => SetItem(I;A) #bindSet(B;;I +Int 1)
  rule #bindSet( A:PbindPat & B:PbindPats ;; I:Int ) => SetItem(I;A) #bindSet(B;;I +Int 1)
  rule #bindSet( A:RbindPat               ;; I:Int ) => SetItem(I;A)
  rule #bindSet( A:RbindPat & B:RbindPat  ;; I:Int ) => SetItem(I;A) #bindSet(B;;I +Int 1)
  rule #bindSet( A:RbindPat & B:RbindPats ;; I:Int ) => SetItem(I;A) #bindSet(B;;I +Int 1)
// set2binds: returns Binds from #bindSet
  rule #set2binds( A:Set ) => #set2binds(0;A)
  rule #set2binds( I:Int ; A:Set ) => #set2bind(I;A) & #set2binds(I +Int 1;A) requires I  <Int size(A) -Int 2
  rule #set2binds( I:Int ; A:Set ) => #set2bind(I;A) &  #set2bind(I +Int 1;A) requires I ==Int size(A) -Int 2
  rule  #set2bind( I:Int ; SetItem( I ; A:LbindPat ) ) => A
  rule  #set2bind( I:Int ; SetItem( I ; A:PbindPat ) ) => A
  rule  #set2bind( I:Int ; SetItem( I ; A:RbindPat ) ) => A
  rule  #set2bind( I:Int ; SetItem( I ; A:LbindPat ) B:Set ) => A requires B =/=K .Set
  rule  #set2bind( I:Int ; SetItem( I ; A:PbindPat ) B:Set ) => A requires B =/=K .Set
  rule  #set2bind( I:Int ; SetItem( I ; A:RbindPat ) B:Set ) => A requires B =/=K .Set
  rule  #set2bind( I:Int ; SetItem( J:Int ; A:LbindPat ) B:Set ) => #set2bind(I;B) requires B =/=K .Set andBool I =/=Int J
  rule  #set2bind( I:Int ; SetItem( J:Int ; A:PbindPat ) B:Set ) => #set2bind(I;B) requires B =/=K .Set andBool I =/=Int J
  rule  #set2bind( I:Int ; SetItem( J:Int ; A:RbindPat ) B:Set ) => #set2bind(I;B) requires B =/=K .Set andBool I =/=Int J

// Bind map: RecPat
// returns Map of Int |-> BindPat: "bind number |-> BindPat"
  rule #bindMap( for( A:LbindPat          ){ _:ProcPat } ) => 0 |-> A
  rule #bindMap( for( A:PbindPat          ){ _:ProcPat } ) => 0 |-> A
  rule #bindMap( for( A:RbindPat          ){ _:ProcPat } ) => 0 |-> A
  rule #bindMap( for( A:LbindPat  _:Guard ){ _:ProcPat } ) => 0 |-> A
  rule #bindMap( for( A:PbindPat  _:Guard ){ _:ProcPat } ) => 0 |-> A
  rule #bindMap( for( A:RbindPat  _:Guard ){ _:ProcPat } ) => 0 |-> A
  rule #bindMap( for( A:LbindPats         ){ _:ProcPat } ) => #bindMap(A;;0) [structural]
  rule #bindMap( for( A:PbindPats         ){ _:ProcPat } ) => #bindMap(A;;0) [structural]
  rule #bindMap( for( A:RbindPats         ){ _:ProcPat } ) => #bindMap(A;;0) [structural]
  rule #bindMap( for( A:LbindPats _:Guard ){ _:ProcPat } ) => #bindMap(A;;0) [structural]
  rule #bindMap( for( A:PbindPats _:Guard ){ _:ProcPat } ) => #bindMap(A;;0) [structural]
  rule #bindMap( for( A:RbindPats _:Guard ){ _:ProcPat } ) => #bindMap(A;;0) [structural]
  // Bind map: BindPat[s]
  rule #bindMap( A:LbindPat               ;; I:Int ) => I |-> A
  rule #bindMap( A:LbindPat & B:LbindPat  ;; I:Int ) => I |-> A #bindMap(B;;I +Int 1)
  rule #bindMap( A:LbindPat & B:LbindPats ;; I:Int ) => I |-> A #bindMap(B;;I +Int 1)
  rule #bindMap( A:PbindPat               ;; I:Int ) => I |-> A
  rule #bindMap( A:PbindPat & B:PbindPat  ;; I:Int ) => I |-> A #bindMap(B;;I +Int 1)
  rule #bindMap( A:PbindPat & B:PbindPats ;; I:Int ) => I |-> A #bindMap(B;;I +Int 1)
  rule #bindMap( A:RbindPat               ;; I:Int ) => I |-> A
  rule #bindMap( A:RbindPat & B:RbindPat  ;; I:Int ) => I |-> A #bindMap(B;;I +Int 1)
  rule #bindMap( A:RbindPat & B:RbindPats ;; I:Int ) => I |-> A #bindMap(B;;I +Int 1)
  // map2binds: returns Bind[Pat]s from #bindMap
  rule #map2binds( A:Map ) => #map2binds(0;A)
  rule #map2binds( I:Int ; A:Map ) => #map2bind(I;A) & #map2binds(I +Int 1;A) requires I  <Int size(A) -Int 2
  rule #map2binds( I:Int ; A:Map ) => #map2bind(I;A) &  #map2bind(I +Int 1;A) requires I ==Int size(A) -Int 2
  rule  #map2bind( I:Int ; I |-> A:LbindPat ) => A
  rule  #map2bind( I:Int ; I |-> A:PbindPat ) => A
  rule  #map2bind( I:Int ; I |-> A:RbindPat ) => A
  rule  #map2bind( I:Int ; I |-> A:LbindPat B:Map ) => A requires B =/=K .Map
  rule  #map2bind( I:Int ; I |-> A:PbindPat B:Map ) => A requires B =/=K .Map
  rule  #map2bind( I:Int ; I |-> A:RbindPat B:Map ) => A requires B =/=K .Map
  rule  #map2bind( I:Int ; J:Int |-> A:LbindPat B:Map ) => #map2bind(I;B) requires B =/=K .Map andBool I =/=Int J
  rule  #map2bind( I:Int ; J:Int |-> A:PbindPat B:Map ) => #map2bind(I;B) requires B =/=K .Map andBool I =/=Int J
  rule  #map2bind( I:Int ; J:Int |-> A:RbindPat B:Map ) => #map2bind(I;B) requires B =/=K .Map andBool I =/=Int J

  // bvarSet from bindSet
  rule #bvarSet( .Set ) => .Set
  rule #bvarSet( SetItem( I ; A:LbindPat ) B:Set ) => SetItem(I;#bvar(A)) #bvarSet(B)
  rule #bvarSet( SetItem( I ; A:PbindPat ) B:Set ) => SetItem(I;#bvar(A)) #bvarSet(B)
  rule #bvarSet( SetItem( I ; A:RbindPat ) B:Set ) => SetItem(I;#bvar(A)) #bvarSet(B)
  // set2bvars: returns binding patterns (#bvar) from #bvarSet
  rule #set2bvars( A:Set ) => #set2bvars(0;A)
  rule #set2bvars( I:Int ; A:Set ) => #append(#set2bvar(I;A);#set2bvars(I +Int 1;A)) requires I  <Int size(A) -Int 2
  rule #set2bvars( I:Int ; A:Set ) => #append(#set2bvar(I;A); #set2bvar(I +Int 1;A)) requires I ==Int size(A) -Int 2
  rule  #set2bvar( I:Int ; SetItem( I ; A:NamePats ) ) => A
  rule  #set2bvar( I:Int ; SetItem( I ; A:NamePats ) B:Set ) => A requires B =/=K .Set
  rule  #set2bvar( I:Int ; SetItem( J:Int ; A:NamePats ) B:Set ) => #set2bvar(I;B) requires B =/=K .Set andBool I =/=Int J

// Binding variable set: RecPat
// returns Set of (Int;NamePats) "bind number ; binding patterns"
  rule #bvarSet( for( A:BindPat          ){ _:ProcPat } ) => SetItem(0;#bvar(A))
  rule #bvarSet( for( A:BindPat  _:Guard ){ _:ProcPat } ) => SetItem(0;#bvar(A))
  rule #bvarSet( for( A:BindPats         ){ _:ProcPat } ) => #bvarSet(A;;0)
  rule #bvarSet( for( A:BindPats _:Guard ){ _:ProcPat } ) => #bvarSet(A;;0)
  // Binding variable set: BindPat[s]
  rule #bvarSet( A:LbindPat               ;; I:Int ) => SetItem(I;#bvar(A))
  rule #bvarSet( A:LbindPat & B:LbindPat  ;; I:Int ) => SetItem(I;#bvar(A)) #bvarSet(B;;I +Int 1)
  rule #bvarSet( A:LbindPat & B:LbindPats ;; I:Int ) => SetItem(I;#bvar(A)) #bvarSet(B;;I +Int 1)
  rule #bvarSet( A:PbindPat               ;; I:Int ) => SetItem(I;#bvar(A))
  rule #bvarSet( A:PbindPat & B:PbindPat  ;; I:Int ) => SetItem(I;#bvar(A)) #bvarSet(B;;I +Int 1)
  rule #bvarSet( A:PbindPat & B:PbindPats ;; I:Int ) => SetItem(I;#bvar(A)) #bvarSet(B;;I +Int 1)
  rule #bvarSet( A:RbindPat               ;; I:Int ) => SetItem(I;#bvar(A))
  rule #bvarSet( A:RbindPat & B:RbindPat  ;; I:Int ) => SetItem(I;#bvar(A)) #bvarSet(B;;I +Int 1)
  rule #bvarSet( A:RbindPat & B:RbindPats ;; I:Int ) => SetItem(I;#bvar(A)) #bvarSet(B;;I +Int 1)

  // bvarMap from bindMap
  rule #bvarMap( .Map ) => .Map
  rule #bvarMap( I |-> A:LbindPat B:Map ) => I |-> #bvar(A) #bvarMap(B)
  rule #bvarMap( I |-> A:PbindPat B:Map ) => I |-> #bvar(A) #bvarMap(B)
  rule #bvarMap( I |-> A:RbindPat B:Map ) => I |-> #bvar(A) #bvarMap(B)
  // set2bvars: returns binding patterns (#bvar) from #bvarSet
  rule #map2bvars( A:Map ) => #map2bvars(0;A)
  rule #map2bvars( I:Int ; A:Map ) => #append(#map2bvar(I;A);#map2bvars(I +Int 1;A)) requires I  <Int size(A) -Int 2
  rule #map2bvars( I:Int ; A:Map ) => #append(#map2bvar(I;A); #map2bvar(I +Int 1;A)) requires I ==Int size(A) -Int 2
  rule  #map2bvar( I:Int ; I |-> A:NamePats ) => A
  rule  #map2bvar( I:Int ; I |-> A:NamePats B:Map ) => A requires B =/=K .Map
  rule  #map2bvar( I:Int ; J:Int |-> A:NamePats B:Map ) => #map2bvar(I;B) requires B =/=K .Map andBool I =/=Int J

// Binding variable set: RecPat
// returns Set of (Int;NamePats) "bind number ; binding patterns"
  rule #bvarMap( for( A:BindPat          ){ _:ProcPat } ) => 0 |-> #bvar(A)
  rule #bvarMap( for( A:BindPat  _:Guard ){ _:ProcPat } ) => 0 |-> #bvar(A)
  rule #bvarMap( for( A:BindPats         ){ _:ProcPat } ) => #bvarMap(A;;0)
  rule #bvarMap( for( A:BindPats _:Guard ){ _:ProcPat } ) => #bvarMap(A;;0)
  // Binding variable set: BindPat[s]
  rule #bvarMap( A:LbindPat               ;; I:Int ) => I |-> #bvar(A)
  rule #bvarMap( A:LbindPat & B:LbindPat  ;; I:Int ) => I |-> #bvar(A) #bvarMap(B;;I +Int 1)
  rule #bvarMap( A:LbindPat & B:LbindPats ;; I:Int ) => I |-> #bvar(A) #bvarMap(B;;I +Int 1)
  rule #bvarMap( A:PbindPat               ;; I:Int ) => I |-> #bvar(A)
  rule #bvarMap( A:PbindPat & B:PbindPat  ;; I:Int ) => I |-> #bvar(A) #bvarMap(B;;I +Int 1)
  rule #bvarMap( A:PbindPat & B:PbindPats ;; I:Int ) => I |-> #bvar(A) #bvarMap(B;;I +Int 1)
  rule #bvarMap( A:RbindPat               ;; I:Int ) => I |-> #bvar(A)
  rule #bvarMap( A:RbindPat & B:RbindPat  ;; I:Int ) => I |-> #bvar(A) #bvarMap(B;;I +Int 1)
  rule #bvarMap( A:RbindPat & B:RbindPats ;; I:Int ) => I |-> #bvar(A) #bvarMap(B;;I +Int 1)

// Bind position
  rule #bind( A:Receive ;; I:Int ) => #bind(#bind(A);;I)
  rule #bind( A:RecPat  ;; I:Int ) => #bind(#bind(A);;I)

  // degenerate cases
  rule #bind( A:Lbind  ;; I:Int ) => .K requires I <Int 0
  rule #bind( A:Pbind  ;; I:Int ) => .K requires I <Int 0
  rule #bind( A:Rbind  ;; I:Int ) => .K requires I <Int 0
  rule #bind( A:Lbinds ;; I:Int ) => .K requires I <Int 0
  rule #bind( A:Pbinds ;; I:Int ) => .K requires I <Int 0
  rule #bind( A:Rbinds ;; I:Int ) => .K requires I <Int 0

  rule #bind( A:Lbind ;; I:Int ) => #if I ==Int 0 #then A #else .K #fi requires I >=Int 0
  rule #bind( A:Lbind & B:Lbind  ;; I:Int ) => #if I ==Int 0 #then A #else #bind(B;;I -Int 1) #fi requires I >=Int 0
  rule #bind( A:Lbind & B:Lbinds ;; I:Int ) => #if I ==Int 0 #then A #else #bind(B;;I -Int 1) #fi requires I >=Int 0
  rule #bind( A:Pbind ;; I:Int ) => #if I ==Int 0 #then A #else .K #fi requires I >=Int 0
  rule #bind( A:Pbind & B:Pbind  ;; I:Int ) => #if I ==Int 0 #then A #else #bind(B;;I -Int 1) #fi requires I >=Int 0
  rule #bind( A:Pbind & B:Pbinds ;; I:Int ) => #if I ==Int 0 #then A #else #bind(B;;I -Int 1) #fi requires I >=Int 0
  rule #bind( A:Rbind ;; I:Int ) => #if I ==Int 0 #then A #else .K #fi requires I >=Int 0
  rule #bind( A:Rbind & B:Rbind  ;; I:Int ) => #if I ==Int 0 #then A #else #bind(B;;I -Int 1) #fi requires I >=Int 0
  rule #bind( A:Rbind & B:Rbinds ;; I:Int ) => #if I ==Int 0 #then A #else #bind(B;;I -Int 1) #fi requires I >=Int 0

// Channel position
  rule #chan( A:Receive ;; I:Int ) => #chan(#bind(A);;I)
  rule #chan( A:RecPat  ;; I:Int ) => #chan(#bind(A);;I)

  // degenerate cases
  rule #chan( A:Lbind  ;; I:Int ) => .K requires I <Int 0 orBool I >=Int 1
  rule #chan( A:Pbind  ;; I:Int ) => .K requires I <Int 0 orBool I >=Int 1
  rule #chan( A:Rbind  ;; I:Int ) => .K requires I <Int 0 orBool I >=Int 1
  rule #chan( A:Lbinds ;; I:Int ) => .K requires I <Int 0 orBool I >=Int #length(A)
  rule #chan( A:Pbinds ;; I:Int ) => .K requires I <Int 0 orBool I >=Int #length(A)
  rule #chan( A:Rbinds ;; I:Int ) => .K requires I <Int 0 orBool I >=Int #length(A)

  rule #chan( A:Lbind ;; I:Int ) => #if I ==Int 0 #then #chan(A) #else .K #fi requires I >=Int 0
  rule #chan( A:Lbind & B:Lbind  ;; I:Int ) => #if I ==Int 0 #then #chan(A) #else #chan(B;;I -Int 1) #fi requires I >=Int 0
  rule #chan( A:Lbind & B:Lbinds ;; I:Int ) => #if I ==Int 0 #then #chan(A) #else #chan(B;;I -Int 1) #fi requires I >=Int 0
  rule #chan( A:Pbind ;; I:Int ) => #if I ==Int 0 #then #chan(A) #else .K #fi requires I >=Int 0
  rule #chan( A:Pbind & B:Pbind  ;; I:Int ) => #if I ==Int 0 #then #chan(A) #else #chan(B;;I -Int 1) #fi requires I >=Int 0
  rule #chan( A:Pbind & B:Pbinds ;; I:Int ) => #if I ==Int 0 #then #chan(A) #else #chan(B;;I -Int 1) #fi requires I >=Int 0
  rule #chan( A:Rbind ;; I:Int ) => #if I ==Int 0 #then #chan(A) #else .K #fi requires I >=Int 0
  rule #chan( A:Rbind & B:Rbind  ;; I:Int ) => #if I ==Int 0 #then #chan(A) #else #chan(B;;I -Int 1) #fi requires I >=Int 0
  rule #chan( A:Rbind & B:Rbinds ;; I:Int ) => #if I ==Int 0 #then #chan(A) #else #chan(B;;I -Int 1) #fi requires I >=Int 0

//------------------
//--- #rho2procs ---
//------------------
  rule #rho2procs(    [ ]            ) => EmptyP
  rule #rho2procs( Set( )            ) => EmptyP
  rule #rho2procs( [ A:Procs    ]    ) => A
  rule  #rho2pats( [ A:ProcPats ]    ) => A
  rule #rho2procs( Set( A:Procs    ) ) => A
  rule  #rho2pats( Set( A:ProcPats ) ) => A
  rule #rho2procs( ( A:Procs    ,)   ) => A
  rule  #rho2pats( ( A:ProcPats ,)   ) => A

  rule #rho2KVs( { } ) => EmptyP : EmptyP
  rule #rho2KVs( { A:RhoKVPairs } ) => A
  rule #rho2KVs( { A:RhoKVPats  } ) => A
  rule #KVs2rho( EmptyP : EmptyP  ) => { }
  rule #KVs2rho( A:RhoKVPairs     ) => {A}
  rule #KVs2rho( A:RhoKVPats      ) => {A}

  rule #KVs2map(   EmptyP    : EmptyP       ) => .Map
  rule #KVs2map( A:Proc      : B:Proc       ) => A |-> B
  rule #KVs2map( A:Proc      : B:ProcPat    ) => A |-> B
  rule #KVs2map( A:ProcPat   : B:Proc       ) => A |-> B
  rule #KVs2map( A:ProcPat   : B:ProcPat    ) => A |-> B
  rule #KVs2map( A:RhoKVPair , B:RhoKVPairs ) => updateMap( #KVs2map(B) , #KVs2map(A) ) // keeps first occurrence of RhoKVPair/Pat
  rule #KVs2map( A:RhoKVPair , B:RhoKVPats  ) => updateMap( #KVs2map(B) , #KVs2map(A) ) // keeps first occurrence of RhoKVPair/Pat
  rule #KVs2map( A:RhoKVPat  , B:RhoKVPairs ) => updateMap( #KVs2map(B) , #KVs2map(A) ) // keeps first occurrence of RhoKVPair/Pat
  rule #KVs2map( A:RhoKVPat  , B:RhoKVPats  ) => updateMap( #KVs2map(B) , #KVs2map(A) ) // keeps first occurrence of RhoKVPair/Pat

//--------------------
//--- IfThen[Else] ---
//--------------------
  rule   #if( if ( A:BExp ) _:Proc ) => A
  rule   #if( if ( A:BExp ) _:Proc else _:Proc ) => A
  rule #then( if ( _:BExp ) A:Proc ) => A
  rule #then( if ( _:BExp ) A:Proc else _:Proc ) => A
  rule #else( if ( _:BExp ) _:Proc ) => Nil
  rule #else( if ( _:BExp ) _:Proc else A:Proc ) => A

//-----------
//--- Let ---
//-----------
// Let variables
  rule #letvar(  A:ProcVar <- _:Proc ) => A
  rule #letvar(  A:LetBind ; B:LetBind     ) => #letvar(A),#letvar(B)
  rule #letvar(  A:LetBind ; B:SeqLetBinds ) => #letvar(A),#letvar(B)
  rule #letvar(  A:LetBind & B:SimLetBinds ) => #letvar(A),#letvar(B)
  rule #letvar(  A:SeqLetBinds > B:SimLetBinds    ) => #append(#letvar(A);#letvar(B))
  rule #letvar(  A:SimLetBinds > B:SeqLetBinds    ) => #append(#letvar(A);#letvar(B))
  rule #letvar(  A:SimLetBinds > B:SimLetBinds    ) => #append(#letvar(A);#letvar(B))
  rule #letvar(  A:SeqLetBinds > B:SeqSimLetBinds ) => #append(#letvar(A);#letvar(B))
  rule #letvar(  A:SimLetBinds > B:SeqSimLetBinds ) => #append(#letvar(A);#letvar(B))
// Let procs
  rule #letproc( _:ProcVar <- A:Proc ) => A
  rule #letproc( A:LetBind ; B:LetBind     ) => #letproc(A),#letproc(B)
  rule #letproc( A:LetBind ; B:SeqLetBinds ) => #letproc(A),#letproc(B)
  rule #letproc( A:LetBind & B:SimLetBinds ) => #letproc(A),#letproc(B)
  rule #letproc(  A:SeqLetBinds > B:SimLetBinds    ) => #append(#letproc(A);#letproc(B))
  rule #letproc(  A:SimLetBinds > B:SeqLetBinds    ) => #append(#letproc(A);#letproc(B))
  rule #letproc(  A:SimLetBinds > B:SimLetBinds    ) => #append(#letproc(A);#letproc(B))
  rule #letproc(  A:SeqLetBinds > B:SeqSimLetBinds ) => #append(#letproc(A);#letproc(B))
  rule #letproc(  A:SimLetBinds > B:SeqSimLetBinds ) => #append(#letproc(A);#letproc(B))

//--------------------
//--- #vardecs2set ---
//--------------------
  rule #vardecs2set( A:Var                ) => SetItem(A)
  rule #vardecs2set( A:Var ( _:Uri )      ) => SetItem(A)
  rule #vardecs2set( A:VarDec , B:VarDecs ) => SetItem(A) #vardecs2set(B)

  rule #set2vardecs( SetItem( A:Var ) ) => A
  rule #set2vardecs( SetItem( A:Var ) B:Set ) => A , #set2vardecs(B)
       requires B =/=K .Set

//--------------
//--- Select ---
//--------------
  rule #bind( { A:LbindPat   } |=> _:Proc ) => A
  rule #bind( { A:LbindPats  } |=> _:Proc ) => A
  rule #bind( { A:GLbindPat  } |=> _:Proc ) => A
  rule #bind( { A:GLbindPats } |=> _:Proc ) => A

  rule #branch2rec( { A:LbindPat   } |=> B:Proc ) => for(A){B}
  rule #branch2rec( { A:LbindPats  } |=> B:Proc ) => for(A){B}
  rule #branch2rec( { A:GLbindPat  } |=> B:Proc ) => for(A){B}
  rule #branch2rec( { A:GLbindPats } |=> B:Proc ) => for(A){B}

  rule #select2branch( select { A:BranchPats } ) => A

//-------------------
// --- Evaluation ---
//-------------------
// BoolExp
  rule #eval( B:Bool ) => B [structural]
  rule #eval(           not B:BoolExp ) =>          notBool #eval(B)
  rule #eval( A:BoolExp and B:BoolExp ) => #eval(A) andBool #eval(B)
  rule #eval( A:BoolExp  or B:BoolExp ) => #eval(A)  orBool #eval(B)
  rule #eval( A:IntExp   <= B:IntExp  ) => #eval(A)   <=Int #eval(B)
  rule #eval( A:IntExp    < B:IntExp  ) => #eval(A)    <Int #eval(B)
  rule #eval( A:IntExp   >= B:IntExp  ) => #eval(A)   >=Int #eval(B)
  rule #eval( A:IntExp    > B:IntExp  ) => #eval(A)    >Int #eval(B)

// IntExp
  rule #eval( B:Int ) => B [structural]
  rule #eval(          - B:IntExp ) =>       0  -Int #eval(B)
  rule #eval( A:IntExp % B:IntExp ) => #eval(A) %Int #eval(B)
  rule #eval( A:IntExp * B:IntExp ) => #eval(A) *Int #eval(B)
  rule #eval( A:IntExp / B:IntExp ) => #eval(A) /Int #eval(B)
  rule #eval( A:IntExp + B:IntExp ) => #eval(A) +Int #eval(B)
  rule #eval( A:IntExp - B:IntExp ) => #eval(A) -Int #eval(B)

// ListExp
  rule #eval( A:RhoList ) => A [structural]
  rule #eval( A:RhoList ++ B:ConcatRhoList ) => #concat(A;#eval(B))

// StringExp
  rule #eval( A:String  ) => A [structural]
  rule #eval( A:String        ++ B:StringOnlyExp ) => A +String #eval(B)
  rule #eval( A:StringOnlyExp %% B:InterpMaps    ) => #interpolate(#eval(A);B)


// #val
  rule #val( I:Int |-> J:Int ; I ) => J
  rule #val( I:Int |-> J:Int A:Map ; I ) => J requires A =/=K .Map
  rule #val( I:Int |-> J:Int A:Map ; L:Int ) => #val(A;L) requires A =/=K .Map andBool I =/=Int L

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
//  rule #lengths( B:Lbind & C:Lbind  ) => #lislen(B) , #lislen(C)
//  rule #lengths( B:Lbind & C:Lbinds ) => #lislen(B) , #lengths(C)

//  rule #lengths( B:Rbind & C:Rbind  ) => #lislen(B) , #lislen(C)
//  rule #lengths( B:Rbind & C:Rbinds ) => #lislen(B) , #lengths(C)

//  rule #lengths( B:Pbind & C:Pbind  ) => #lislen(B) , #lislen(C)
//  rule #lengths( B:Pbind & C:Pbinds ) => #lislen(B) , #lengths(C)

  rule #isBranches( A:BranchPats ) => isBranches(A)

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
