// Rholang syntax & semantics

require "domains.k"
require "AuxFun/auxfun.k"
require "Configuration/config.k"
require "Match/match.k"
require "Names_Variables/namevar.k"
require "Substitute/sub.k"
require "StructuralEquiv/struct.k"

// SYNTAX MODULE
module GRHO-SYNTAX
  import DOMAINS

// Variables
  syntax              Var ::= Id
  syntax             Vars ::= Var
                            > Var "," Vars [right]

//-------------
//--- NAMES ---
//-------------
  syntax             Name ::= "{" Name "}" [bracket]
                            > Bundle
                            | Quote
                            | Var       // name variable
                            > VarDec
                            > TypedName
                            | EmptyName // listen for empty message
  syntax            Quote ::= "@" Proc
  syntax        EmptyName ::= "EmptyN"  // listening for empty messages
  syntax           VarDec ::= Var | NewUri
  syntax           NewUri ::= Var "(" Uri ")"

  // Bundles -- cannot be destructured with pattern-matching
  // e.g. bundle?{P} acts as channel @P with object capabilities
  syntax           Bundle ::= BundlePlus | BundleMinus | BundleOther
  syntax       BundlePlus ::= "bundle+{" Proc "}" // write-only
  syntax      BundleMinus ::= "bundle-{" Proc "}" // read-only
  syntax      BundleOther ::= "bundle0{" Proc "}" // no-read/no-write
                            |  "bundle{" Proc "}" // read/write

// Typed Names
  syntax        TypedName ::= Var ":" NamePat

// Several Names
  syntax            Names ::= Vars
                            > VarDecs
                            > Name
                            > Name "," Names      [right]
  syntax            Names ::= "@" Procs        [function]

  syntax          VarDecs ::= Vars
                            > VarDec
                            > VarDec "," VarDecs  [right]

  syntax        NamesList ::= Names
                            > Names "&" NamesList [right]

//-----------------
//--- PROCESSES ---
//-----------------
// TODO: Finalize precedence
  syntax             Proc ::= "{" Proc "}"    [bracket]
                            > New             // New name declaration(s)
                            > Ground          // Ground terms - Bool, Int, Nil, String, Uri
                            | Collection      // Data structures - RhoList, RhoMap, RhoSet, RhoTuple
                            | ProcVar         // Process variable
                            > TypedProc
                            > VarRef          // Variable references - Name/Process variable shadowing
                            > Eval            // Evaluation
                            > MethodProc      // Methods
                            > Exp             // Arith, Bool, & String expressions
                            > Matching        // Match & Select
                            > Receive         // Receive messages
                            | Contract        // Contract
                            | Invocation      // Contract invocation
                            | Send            // Send messages
                            > Conditional     // If...then(...else)
                            > Par             // Parallel composition

  syntax          ProcVar ::= "\\" Var
  syntax        TypedProc ::= ProcVar ":" ProcPat [klabel(typeproc)]

// Several Processes
  syntax            Procs ::= Proc
//                            > Vars // TODO: include - will be needed once Var <: Name & Var <: Proc
//                            > Proc
                            > Proc "," Procs [right]

  syntax        ProcsList ::= Procs
                            > Procs "&" ProcsList

// Parallel composition
  // Par is a multiset of processes represented as an order-normalized list of processes
    // each nonPar Proc is put into it's own <k/> cell in GRHO when the Par is at the top-level
    // implemented as a multiset in STRUCT
  syntax              Par ::= Proc "|" Proc  [right]

// Receives
  syntax          Receive ::= SRec | MRec | GRec | UGRec
  syntax             GRec ::= GSRec  | GMRec
                            | "for" "(" OrGBinds ")" "{" Proc "}"
  syntax            UGRec ::= UGSRec | UGMRec
                            | "for" "(" OrBinds  ")" "{" Proc "}"

  // Single Listen Receives
  syntax             SRec ::= GSRec       // Guarded single receieve
                            | UGSRec      // Unguarded single receieve
                            | "for" "(" AnyBind ")" "{" Proc "}"
  syntax           UGSRec ::= LinearSRec  // Linear single receieve, unguarded
                            | PeekSRec    // Peek single receieve, unguarded
                            | RepeatSRec  // Repeat single receieve, unguarded
                            | "for" "(" Bind    ")" "{" Proc "}"
  syntax            GSRec ::= GLinearSRec // Linear single receieve, guarded
                            | GPeekSRec   // Peek single receieve, guarded
                            | GRepeatSRec // Repeat single receieve, guarded
                            | "for" "(" GBind   ")" "{" Proc "}"
  // Input Guard
  syntax            Guard ::= "if" BExp

  // Linear Single
  syntax       LinearSRec ::= "for" "(" Lbind  ")" "{" Proc "}"
  syntax      GLinearSRec ::= "for" "(" GLbind ")" "{" Proc "}"
  syntax            Lbind ::= NamePats "<-"  Name
                            | Names    "<-"  Name
                            | EmptyLbind
  syntax       EmptyLbind ::=          "<-"  Name

  // Peek Single
  syntax         PeekSRec ::= "for" "(" Pbind  ")" "{" Proc "}"
  syntax        GPeekSRec ::= "for" "(" GPbind ")" "{" Proc "}"
  syntax            Pbind ::= NamePats "<<-" Name
                            | Names    "<<-" Name
                            | EmptyPbind
  syntax       EmptyPbind ::=          "<<-" Name

  // Repeated/Persistent Single
  syntax       RepeatSRec ::= "for" "(" Rbind  ")" "{" Proc "}"
  syntax      GRepeatSRec ::= "for" "(" GRbind ")" "{" Proc "}"
  syntax            Rbind ::= NamePats "<="  Name
                            | Names    "<="  Name
                            | EmptyRbind
  syntax       EmptyRbind ::=          "<="  Name

  // Guarded Single Bind
  syntax           GLbind ::= Lbind Guard
  syntax           GPbind ::= Pbind Guard
  syntax           GRbind ::= Rbind Guard
  // Any Single Bind
  syntax             Bind ::= Lbind  | Pbind  | Rbind
  syntax            GBind ::= GLbind | GPbind | GRbind
                            > Bind Guard
  syntax          AnyBind ::= Bind   | GBind

  // Multiple Listen Receives -- TODO: add mixed binds & change syntax to "&"
  syntax             MRec ::= GMRec       // Guarded multi receive
                            | UGMRec      // Unguarded multi receive
                            | "for" "(" AnyBinds ")" "{" Proc "}"
  syntax           UGMRec ::= LinearMRec  // Linear multi receive, unguarded
                            | PeekMRec    // Peek multi receive, unguarded
                            | RepeatMRec  // Repeat multi receive, unguarded
                            | "for" "(" Binds    ")" "{" Proc "}"
  syntax            GMRec ::= GLinearMRec // Linear multi receive, guarded
                            | GPeekMRec   // Peek multi receive, guarded
                            | GRepeatMRec // Repeat multi receive, guarded
                            | "for" "(" GBinds   ")" "{" Proc "}"
  // Homogeneous binds
    // Linear
  syntax       LinearMRec ::= "for" "(" Lbinds  ")" "{" Proc "}"
  syntax      GLinearMRec ::= "for" "(" GLbinds ")" "{" Proc "}"
  syntax           Lbinds ::= Lbind "&" Lbind
                            | Lbind "&" Lbinds [right]
    // Peek
  syntax         PeekMRec ::= "for" "(" Pbinds  ")" "{" Proc "}"
  syntax        GPeekMRec ::= "for" "(" GPbinds ")" "{" Proc "}"
  syntax           Pbinds ::= Pbind "&" Pbind
                            | Pbind "&" Pbinds [right]
    // Repeated/Persistent
  syntax       RepeatMRec ::= "for" "(" Rbinds  ")" "{" Proc "}"
  syntax      GRepeatMRec ::= "for" "(" GRbinds ")" "{" Proc "}"
  syntax           Rbinds ::= Rbind "&" Rbind
                            | Rbind "&" Rbinds [right]
  // Guarded Binds
  syntax          GLbinds ::= Lbinds Guard
  syntax          GPbinds ::= Pbinds Guard
  syntax          GRbinds ::= Rbinds Guard
  // Any Binds
  syntax            Binds ::= Lbinds  | Pbinds  | Rbinds
  syntax           GBinds ::= GLbinds | GPbinds | GRbinds
                            > Binds Guard
  syntax         AnyBinds ::= Binds | GBinds
  syntax          OrBinds ::= Bind  | Binds
  syntax         OrGBinds ::= GBind | GBinds

// Sends
  syntax             Send ::= ConSend | UnconSend
  // Consumable -- ephemeral data
  syntax          ConSend ::= Name "!"  "(" Procs ")"
                            | EmptyCSend
  syntax       EmptyCSend ::= Name "!"  "("       ")"
  // Unconsumable -- persistent data
  syntax        UnconSend ::= Name "!!" "(" Procs ")"
                            | EmptyUSend
  syntax       EmptyUSend ::= Name "!!" "("       ")"

// Eval -- evaluation
  syntax             Eval ::= "*" Name
  syntax            Procs ::= "*" Names [function]

// New - declares variables corresponding to fresh unforgeable Names
  syntax              New ::= "new" VarDecs "in" "{" Proc "}"

// Matching
  syntax         Matching ::= Match | Select
  // Match -- pattern matching
  syntax            Match ::= "match" "{" Proc "}" "{" MatchCases "}"

  syntax        MatchCase ::= "{" Proc    "}" "|=>" Proc
                            | "{" ProcPat "}" "|=>" Proc
  syntax       MatchCases ::= MatchCase
                            | MatchCase MatchCases [right]
  // Select -- receive-guarded choice
  syntax           Select ::= "select" "{" Branches "}"

  syntax           Branch ::= "{" Lbind  "}" "|=>" Proc
                            | "{" Lbinds "}" "|=>" Proc
  syntax         Branches ::= Branch
                            | Branch Branches [right]

// Variable Reference - allows for variable shadowing
  syntax           VarRef ::= NameRef
                            | ProcRef
  syntax          NameRef ::= "=" "*" Var // Var binds a Name variable
  syntax          ProcRef ::= "=" ProcVar // Var binds a Proc variable

// Conditional
  syntax      Conditional ::= IfThen | Else
  syntax           IfThen ::= "if" "(" BExp ")" Proc  [strict(1)]
  syntax             Else ::= IfThen "else" Proc

// Contract - syntactic sugar for persistent single receive
  syntax         Contract ::= "contract" Name "(" NamePats ")" "=" "{" Proc "}"
                            | "contract" Name "(" Names    ")" "=" "{" Proc "}"
                            | "contract" Name "("          ")" "=" "{" Proc "}"

// Contract Invocation
  // keyword "invoke" added to disambiguate from NewUri
  syntax       Invocation ::= "invoke" Name "(" ProcPats ")"
                            | "invoke" Name "(" Procs    ")"
                            | "invoke" Name "("          ")"

// Collections - data structures
  syntax       Collection ::= RhoList | RhoMap | RhoSet | RhoTuple

  // Process lists
  syntax        EmptyList ::= "[" "]"
  syntax          RhoList ::= "[" Procs "]"
                            | EmptyList

  // Process maps
  syntax         EmptyMap ::= "{" "}"
  syntax           RhoMap ::= "{" RhoKVPairs "}"
                            | EmptyMap

  syntax        RhoKVPair ::= Proc ":" Proc
  syntax       RhoKVPairs ::= RhoKVPair
                            | RhoKVPair "," RhoKVPairs [right]

  // Process sets
  syntax         EmptySet ::= "Set(" ")"
  syntax           RhoSet ::= "Set(" Procs ")"
                            | EmptySet

  // Process tuples
  syntax         RhoTuple ::= "(" Procs ",)"

// Ground terms
  syntax           Ground ::= Unit                 // stopped process
                            | Bool | Int  | String // built-in
                            | Unforgeable | Uri    // registry, lookup, locker & OCaps
  syntax             Unit ::= "Nil"
  syntax      Unforgeable ::= "unforgeable(" Int ")"
  syntax              Uri ::= "`" NativeChan "`"
  syntax       NativeChan ::= NativeIO
// TODO: add other native channels
  syntax         NativeIO ::= "rho:io:stdout"
                            | "rho:io:stdoutAck"

// Expressions resolve to ground terms
  syntax              Exp ::= "{" Exp "}" [bracket]
                            > AExp
                            | LiStrExp
                            > BExp
  // Arithmetic
  syntax         IntOrVar ::= Int | ProcVar | Eval
  syntax             AExp ::= "{" AExp "}" [bracket]
                            > IntOrVar | AExpNeg
                            > AExpMod
                            > AExpMul  | AExpDiv
                            > AExpSum  | AExpSub
                            > IntExp

  syntax          AExpNeg ::= "-" AExp       [strict]
                            | IntNeg
  syntax          AExpMod ::= AExp "%" AExp  [strict(2), left] // mod reduction
                            | IntMod
  syntax          AExpMul ::= AExp "*" AExp  [strict, right]
                            | IntMul
  syntax          AExpDiv ::= AExp "/" AExp  [strict, right]
                            | IntDiv
  syntax          AExpSum ::= AExp "+" AExp  [strict, right]
                            | IntSum
  syntax          AExpSub ::= AExp "-" AExp  [strict, right]
                            | IntSub

  syntax           IntExp ::= Int > IntNeg > IntMod
                            > IntMul | IntDiv
                            > IntSum | IntSub

  syntax           IntNeg ::= "-" IntExp
  syntax           IntMod ::= IntExp "%" IntExp [left]
  syntax           IntMul ::= IntExp "*" IntExp [right]
  syntax           IntDiv ::= IntExp "/" IntExp [right]
  syntax           IntSum ::= IntExp "+" IntExp [right]
  syntax           IntSub ::= IntExp "-" IntExp [right]

  // RhoList & String
  syntax        ListOrVar ::= RhoList | ProcVar | Eval
  syntax          ListExp ::= "{" ListExp "}"             [bracket]
                            > ListOrVar
                            | ConcatList
  syntax    ConcatRhoList ::= RhoList
                            | RhoList   "++" ConcatRhoList  [right]
  syntax       ConcatList ::= ListOrVar "++" ListOrVar
                            | ListOrVar "++" ConcatList     [right]
                            > ConcatRhoList

  syntax      StringOrVar ::= String | ProcVar | Eval
  syntax        StringExp ::= "{" StringExp "}"           [bracket]
                            > StringOrVar
                            > ConcatStr  // string concat
                            | Interp     // string interpolation
                            > StringOnlyExp
  syntax     ConcatString ::= String
                            | String      "++" StringOnlyExp [right, strict(1)]
  syntax        ConcatStr ::= StringOrVar "++" StringExp     [right, strict(1)]
                            > ConcatString
  syntax           Interp ::= StringExp   "%%" InterpMaps    [right, strict(1)]
                            > InterpString
  syntax     InterpString ::= String | StringOnlyExp "%%" InterpMaps [right]
  syntax       InterpMaps ::= RhoMap | RhoMap "%%" InterpMaps
  syntax    StringOnlyExp ::= String | ConcatString | InterpString

  syntax           Concat ::= ConcatList | ConcatStr
  syntax         LiStrExp ::= ListExp | StringExp | Concat

  // Boolean
  syntax        BoolOrVar ::= Bool | ProcVar | Eval
  syntax             BExp ::= "{" BExp "}"              [bracket]
                            > BoolOrVar
                            | BExpLeq | BExpL | BExpGeq | BExpG
                            > Name "==" Name  // name equivalence
                            | Name "!=" Name
                            | Proc "==" Proc  // structural equivalence
                            | Proc "!=" Proc
                            > Proc    "matches" Proc
                            | Proc    "matches" ProcPat
                            | ProcPat "matches" ProcPat
                            > BExpNot > BExpAnd > BExpOr
                            | BoolExp

  syntax          BExpLeq ::= AExp "<=" AExp [seqstrict]
                            | BoolLeq
  syntax            BExpL ::= AExp "<"  AExp [seqstrict]
                            | BoolL
  syntax          BExpGeq ::= AExp ">=" AExp [seqstrict]
                            | BoolGeq
  syntax            BExpG ::= AExp ">"  AExp [seqstrict]
                            | BoolG
  syntax          BExpNot ::= "not" BExp     [strict]
                            | BoolNot
  syntax          BExpAnd ::=BExp "and" BExp [strict(1), right]
                            | BoolAnd
  syntax           BExpOr ::=BExp "or"  BExp [strict(1), right]
                            | BoolOr

  syntax          BoolExp ::= Bool | BoolLeq | BoolL | BoolGeq | BoolG
                            > BoolNot > BoolAnd > BoolOr
  syntax          BoolLeq ::= IntExp "<=" IntExp    [right]
  syntax            BoolL ::= IntExp "<"  IntExp    [right]
  syntax          BoolGeq ::= IntExp ">=" IntExp    [right]
  syntax            BoolG ::= IntExp ">"  IntExp    [right]
  syntax          BoolNot ::= "not" BoolExp         [right]
  syntax          BoolAnd ::= BoolExp "and" BoolExp [right]
  syntax           BoolOr ::= BoolExp "or"  BoolExp [right]

// Methods
  syntax       MethodProc ::= Proc MethodAndArgs
  syntax    MethodAndArgs ::= "." Method "(" Procs ")"
                            | "." Method "(" ")"

  // acknowledgement args?
  syntax           Method ::= "nth"          // nth element - list, tuple - Proc.nth( Int )
                            | "toByteArray"  // transform to bytearray - Data.toByteArray( )
                            | "hexToBytes"   // hex string -> bytes
                            | "union"        // map, set union - Map.union( Map ) , Set.union( Set )
                            | "diff"         // difference - Map.diff( Map ), Set.diff( Set )
                            | "add"          // add element - list, map, set
                            | "delete"       // delete element - list, map, set
                            | "contains"     // contains predicate - list, map:key?, set
                            | "get"          // get - get value corresponding to key - Map.get( Key )
                            | "getOrElse"    // getOrElse - get or side condition - Map.getOrElse( Key , SideCondition )
                            | "set"          // set - Map.set( Key , Value ) == updateMap( Map , Key:Value )
                            | "keys"         // set of keys of a map - Map.keys( )
                            | "values"       // list of values of a map - Map.values( )
                            | "size"         // size of unordered - Map.size(), Set.size()
                            | "length"       // length of ordered - List.length() , Tuple.length()
                            | "slice"        // slice of list/string - List.slice(I1,I2) , String.slice(I1,I2)
                            | "iterate"      // semantics? - list and tuple? - args?
                            | "confine"      // semantics? - confine variables/communication?

// For empty content & args
  syntax             Proc ::= EmptyProc // sending empty message; empty Proc arg
  syntax        EmptyProc ::= "EmptyP"

//----------------
//--- Patterns ---
//----------------
// Pattern Variable
  syntax           PatVar ::= "$" Var
  syntax          PatVars ::= PatVar
                            > PatVar "," PatVars [right]

// WildCard
  syntax         WildCard ::= "\\_" // instead of a simple _
// WildCards
  syntax        WildCards ::= WildCard
                            > WildCard "," WildCards [right]

// Name pattern
  syntax          NamePat ::= "{" NamePat "}" [bracket]
                            > WildCard
                            > PatVar
                            | QuotePat
                            | SimpleNamePat
//                          > NamePatExp
//                          > Name
/*
// Name Pattern expression
  syntax       NamePatExp ::= NPatNeg > NPatAnd > NPatOr
  // Pattern Negation
  syntax          NPatNeg ::= "~" Name
                            | "~" NamePat
  // Pattern And
  syntax          NPatAnd ::= Name    "/\\" Name    [right]
                            | Name    "/\\" NamePat [right]
                            | NamePat "/\\" Name    [right]
                            | NamePat "/\\" NamePat [right]

  // Pattern Or
  syntax           NPatOr ::= Name    "\\/" Name    [right]
                            | Name    "\\/" NamePat [right]
                            | NamePat "\\/" Name    [right]
                            | NamePat "\\/" NamePat [right]
*/
// Quote pattern
  syntax         QuotePat ::= "@" ProcPat

// Simple Name pattern
  syntax    SimpleNamePat ::= "ClosedName" | "ClosedNamePat" // other
                            | "Quote" | "NameVar"

// Name patterns
  // NamePats contain at least one WildCard, i.e. they cannot all be Names
  syntax         NamePats ::= NamePat
                            > Name    "," NamePats [right]
                            | NamePat "," Names    [right]
                            | NamePat "," NamePats [right]
                            > WildCards
                            > PatVars
//                          | Names

  syntax     NamePatsList ::= NamePats
                            > NamePats "&" NamePatsList [right]

// Pattern -- TODO: precedence
  syntax          ProcPat ::= "{" ProcPat "}" [bracket]
                            > WildCard
                            > PatVar
                            > PatExp          // Pattern expression
                            > NewPat          // New pattern
                            | CollectionPat   // Collection pattern
                            | SimplePat       // simple types
                            > EvalPat         // Evaluation pattern
//                          > MethodPat       // Method pattern
//                          > ExpPat          // Arith, Bool, & String pattern
                            > MatchingPat     // Match & Select pattern
                            > RecPat          // Receive pattern
                            | ContractPat     // Contract pattern
                            | InvocationPat   // Contract invocation pattern
                            | SendPat         // Send pattern
                            > CondPat         // If...then(...else) pattern
                            > ParPat          // Par pattern
//                          > Proc

// Simple pattern
  syntax        SimplePat ::= "Bool" | "Int" | "String"
                            | "List" | "Map" | "Set" | "Tuple" | "Unforgeable" | "Uri"
                            | "ClosedProc" | "ClosedProcPat"
                            | "Proc" | "Ground" | "Par" | "Send" | "Receive" | "ProcVar"
                            // add SimplePat for other Proc constructors
                            | "ProcContext" | "MultiProcContext"
                            | "NameContext" | "MultiNameContext" | "MixedContext"
                            | "Context(" Int "," Int ")"

// Patterns
  // cannot be all Procs, i.e. contains at least one WildCard
  syntax         ProcPats ::= ProcPat
                            > Proc     "," ProcPats [right]
                            | ProcPat  "," Procs    [right]
                            | ProcPat  "," ProcPats [right]
                            > WildCards
                            > PatVars
//                          | Procs

  syntax     ProcPatsList ::= ProcPats
                            > ProcPats "&" ProcPatsList [right]

// Parallel composition pattern
  syntax           ParPat ::= ProcPat "|" Proc     [right]
                            | Proc    "|" ProcPat  [right]
                            | ProcPat "|" ProcPat  [right]
//                          | Par

// Receive Pattern
  syntax           RecPat ::= SRecPat | MRecPat | GRecPat | UGRecPat
  syntax          GRecPat ::= GSRecPat  | GMRecPat
  syntax         UGRecPat ::= UGSRecPat | UGMRecPat

  // Single listen receive pattern
  syntax          SRecPat ::= GSRecPat
                            | UGSRecPat
//                          | SRec

  syntax         GSRecPat ::= GLinearSRecPat
                            | GPeekSRecPat
                            | GRepeatSRecPat
                            > "for" "(" GBindPat  ")" "{" Proc    "}"
                            | "for" "(" GBind     ")" "{" ProcPat "}"
                            | "for" "(" GBindPat  ")" "{" ProcPat "}"
//                          | GSRec
  syntax        UGSRecPat ::= LinearSRecPat
                            | PeekSRecPat
                            | RepeatSRecPat
                            > "for" "(" BindPat   ")" "{" Proc    "}"
                            | "for" "(" Bind      ")" "{" ProcPat "}"
                            | "for" "(" BindPat   ")" "{" ProcPat "}"
//                          | UGSRec

  // Linear listen pattern
  syntax    LinearSRecPat ::= "for" "(" Lbind     ")" "{" ProcPat "}"
                            | "for" "(" LbindPat  ")" "{" ProcPat "}"
                            | "for" "(" LbindPat  ")" "{" Proc    "}"
//                          | LinearSRec
  syntax   GLinearSRecPat ::= "for" "(" GLbind    ")" "{" ProcPat "}"
                            | "for" "(" GLbindPat ")" "{" ProcPat "}"
                            | "for" "(" GLbindPat ")" "{" Proc    "}"
//                          | GLinearSRec
  syntax        GLbindPat ::= LbindPat Guard
  syntax         LbindPat ::= NamePats "<-"  NamePat
                            | Names    "<-"  NamePat
                            |          "<-"  NamePat
  // Peek listen pattern
  syntax      PeekSRecPat ::= "for" "(" Pbind     ")" "{" ProcPat "}"
                            | "for" "(" PbindPat  ")" "{" ProcPat "}"
                            | "for" "(" PbindPat  ")" "{" Proc    "}"
//                          | PeekSRec
  syntax     GPeekSRecPat ::= "for" "(" GPbind    ")" "{" ProcPat "}"
                            | "for" "(" GPbindPat ")" "{" ProcPat "}"
                            | "for" "(" GPbindPat ")" "{" Proc    "}"
//                          | GPeekSRec
  syntax        GPbindPat ::= PbindPat Guard
  syntax         PbindPat ::= NamePats "<<-" NamePat
                            | Names    "<<-" NamePat
                            |          "<<-" NamePat
  // Repeated listen pattern
  syntax    RepeatSRecPat ::= "for" "(" Rbind     ")" "{" ProcPat "}"
                            | "for" "(" RbindPat  ")" "{" ProcPat "}"
                            | "for" "(" RbindPat  ")" "{" Proc    "}"
//                          | RepeatSRec
  syntax   GRepeatSRecPat ::= "for" "(" GRbind    ")" "{" ProcPat "}"
                            | "for" "(" GRbindPat ")" "{" ProcPat "}"
                            | "for" "(" GRbindPat ")" "{" Proc    "}"
//                          | GRepeatSRec
  syntax        GRbindPat ::= RbindPat Guard
  syntax         RbindPat ::= NamePats "<="  NamePat
                            | Names    "<="  NamePat
                            |          "<="  NamePat

  syntax          BindPat ::= LbindPat  | PbindPat  | RbindPat
  syntax         GBindPat ::= GLbindPat | GPbindPat | GRbindPat
                            > BindPat Guard
  syntax       AnyBindPat ::= BindPat   | GBindPat

  // Multiple listen receive patterns
  syntax          MRecPat ::= GMRecPat
                            | UGMRecPat
  syntax         GMRecPat ::= GLinearMRecPat
                            | GPeekMRecPat
                            | GRepeatMRecPat
                            > "for" "(" GBindPats ")" "{" Proc    "}"
                            | "for" "(" GBinds    ")" "{" ProcPat "}"
                            | "for" "(" GBindPats ")" "{" ProcPat "}"
  syntax        UGMRecPat ::= LinearMRecPat
                            | PeekMRecPat
                            | RepeatMRecPat
                            > "for" "(" BindPats  ")" "{" Proc    "}"
                            | "for" "(" Binds     ")" "{" ProcPat "}"
                            | "for" "(" BindPats  ")" "{" ProcPat "}"
  // Linear
  syntax    LinearMRecPat ::= "for" "(" Lbinds     ")" "{" ProcPat "}"
                            | "for" "(" LbindPats  ")" "{" ProcPat "}"
                            | "for" "(" LbindPats  ")" "{" Proc    "}"
//                          | LinearMRec
  syntax   GLinearMRecPat ::= "for" "(" GLbinds    ")" "{" ProcPat "}"
                            | "for" "(" GLbindPats ")" "{" ProcPat "}"
                            | "for" "(" GLbindPats ")" "{" Proc    "}"
//                          | GLinearMRec
  syntax        LbindPats ::= Lbind    "&" LbindPat
                            | LbindPat "&" Lbind
                            | LbindPat "&" LbindPat
                            | Lbind    "&" LbindPats [right]
                            | LbindPat "&" Lbinds    [right]
                            | LbindPat "&" LbindPats [right]
  // Peek
  syntax      PeekMRecPat ::= "for" "(" Pbinds     ")" "{" ProcPat "}"
                            | "for" "(" PbindPats  ")" "{" ProcPat "}"
                            | "for" "(" PbindPats  ")" "{" Proc    "}"
  syntax     GPeekMRecPat ::= "for" "(" GPbinds    ")" "{" ProcPat "}"
                            | "for" "(" GPbindPats ")" "{" ProcPat "}"
                            | "for" "(" GPbindPats ")" "{" Proc    "}"
  syntax        PbindPats ::= Pbind    "&" PbindPat
                            | PbindPat "&" Pbind
                            | PbindPat "&" PbindPat
                            | Pbind    "&" PbindPats [right]
                            | PbindPat "&" Pbinds    [right]
                            | PbindPat "&" PbindPats [right]
  // Repeated
  syntax    RepeatMRecPat ::= "for" "(" Rbinds     ")" "{" ProcPat "}"
                            | "for" "(" RbindPats  ")" "{" ProcPat "}"
                            | "for" "(" RbindPats  ")" "{" Proc    "}"
  syntax   GRepeatMRecPat ::= "for" "(" GRbinds    ")" "{" ProcPat "}"
                            | "for" "(" GRbindPats ")" "{" ProcPat "}"
                            | "for" "(" GRbindPats ")" "{" Proc    "}"
  syntax        RbindPats ::= Rbind    "&" RbindPat
                            | RbindPat "&" Rbind
                            | RbindPat "&" RbindPat
                            | Rbind    "&" RbindPats [right]
                            | RbindPat "&" Rbinds    [right]
                            | RbindPat "&" RbindPats [right]


  syntax         BindPats ::= LbindPats  | PbindPats  | RbindPats
  syntax        GBindPats ::= GLbindPats | GPbindPats | GRbindPats
                            > BindPats Guard
  syntax       GLbindPats ::= LbindPats Guard
  syntax       GPbindPats ::= PbindPats Guard
  syntax       GRbindPats ::= RbindPats Guard
  syntax      AnyBindPats ::= BindPats | GBindPats

// Send Pattern
  syntax          SendPat ::= CSendPat | USendPat
  // Consumable send pattern
  syntax         CSendPat ::= NamePat "!"  "("          ")"
                            | NamePat "!"  "(" Procs    ")"
                            | NamePat "!"  "(" ProcPats ")"
                            |    Name "!"  "(" ProcPats ")"
//                          > ConSend
  // Unconsumable send pattern
  syntax         USendPat ::= NamePat "!!" "("          ")"
                            | NamePat "!!" "(" Procs    ")"
                            | NamePat "!!" "(" ProcPats ")"
                            |    Name "!!" "(" ProcPats ")"
//                          > UnconSend

// Eval pattern -- Q: does this cover anything less than ProcPat + *Var
  syntax          EvalPat ::= "*" NamePat

// New pattern
  syntax           NewPat ::= "new" VarDecs "in" "{" ProcPat "}"

// Matching pattern
  // Match pattern
  syntax      MatchingPat ::= MatchPat | SelectPat

  syntax         MatchPat ::= "match" "{" Proc    "}" "{" MCasePats  "}"
                            | "match" "{" ProcPat "}" "{" MatchCases "}"
                            | "match" "{" ProcPat "}" "{" MCasePats  "}"


  syntax         MCasePat ::= "{" ProcPat "}" "|=>" ProcPat // match pattern and return pattern
                            | "{" Proc    "}" "|=>" ProcPat // match process and return pattern
  // MCasePats has at least one pattern-returning MCasePat so there are no collisions with MatchCases
  syntax        MCasePats ::= MCasePat
                            > MCasePat  MatchCases [right]
                            | MatchCase MCasePats  [right]
                            | MCasePat  MCasePats  [right]

  // Select pattern
  syntax        SelectPat ::= "select" "{" BranchPats "}"

  syntax        BranchPat ::= "{" Lbind     "}" "|=>" ProcPat
                            | "{" Lbinds    "}" "|=>" ProcPat
                            | "{" LbindPat  "}" "|=>" Proc
                            | "{" LbindPats "}" "|=>" Proc
                            | "{" LbindPat  "}" "|=>" ProcPat
                            | "{" LbindPats "}" "|=>" ProcPat
  // BranchPats has at least one pattern-returning BrachPat so there are no collisions with Branches
  syntax       BranchPats ::= BranchPat
                            > Branch    BranchPats [right]
                            | BranchPat Branches   [right]
                            | BranchPat BranchPats [right]

// Conditional pattern
  syntax          CondPat ::= IfThenPat | ElsePat

  syntax        IfThenPat ::= "if" "(" BExp ")" ProcPat [strict(1)]
  syntax          ElsePat ::= IfThenPat "else" Proc    // if ( BExp ) ProcPat else Proc
                            | IfThen    "else" ProcPat // if ( BExp ) Proc    else ProcPat
                            | IfThenPat "else" ProcPat // if ( BExp ) ProcPat else ProcPat
// Pattern expression
  syntax           PatExp ::= PatNeg > PatAnd > PatOr
  // Pattern Negation
  syntax           PatNeg ::= "~" Proc
                            | "~" ProcPat
  // Pattern And
  syntax           PatAnd ::= Proc    "/\\" Proc    [right]
                            | Proc    "/\\" ProcPat [right]
                            | ProcPat "/\\" Proc    [right]
                            | ProcPat "/\\" ProcPat [right]
  // Pattern Or
  syntax            PatOr ::= Proc    "\\/" Proc    [right]
                            | Proc    "\\/" ProcPat [right]
                            | ProcPat "\\/" Proc    [right]
                            | ProcPat "\\/" ProcPat [right]

// Contract pattern
  syntax      ContractPat ::= "contract" NamePat "(" NamePats ")" "=" "{" ProcPat "}"
                            | "contract" NamePat "(" NamePats ")" "=" "{" Proc    "}"
                            | "contract" Name    "(" NamePats ")" "=" "{" ProcPat "}"
                            | "contract" NamePat "(" Names    ")" "=" "{" ProcPat "}"
                            | "contract" NamePat "(" Names    ")" "=" "{" Proc    "}"
                            | "contract" Name    "(" Names    ")" "=" "{" ProcPat "}"
                            | "contract" NamePat "("          ")" "=" "{" ProcPat "}"
                            | "contract" NamePat "("          ")" "=" "{" Proc    "}"
                            | "contract" Name    "("          ")" "=" "{" ProcPat "}"

  syntax    InvocationPat ::= "invoke" NamePat "(" ProcPats ")"
                            | "invoke" Name    "(" ProcPats ")"
                            | "invoke" NamePat "(" Procs    ")"
                            | "invoke" NamePat "("          ")"

// Collection pattern
  syntax    CollectionPat ::= ListPat | MapPat | SetPat | TuplePat

  // RhoList pattern -- TODO: bind Procs or RhoList to ProcVar???
  // how to capture empty List?
     // match each Pat/Proc at head and bind remainder as RhoList to ProcVar?
  syntax          ListPat ::= "[" ProcPats "..." ProcVar "]"
                            | "[" Procs    "..." ProcVar "]"
                            | "[" ProcPats "]" // match List pattern

  // RhoMap pattern -- TODO: bind RhoKVPairs or RhoMap to ProcVar???
    // match each Pat and bind remainder as RhoMap to ProcVar?
  syntax           MapPat ::= "{" ProcPats "..." ProcVar "}"
                            | "{" Procs    "..." ProcVar "}"
                            | "{" RhoKVPats "}"
    // RhoKVPat
  syntax         RhoKVPat ::= Proc    ":" ProcPat
                            | ProcPat ":" Proc
                            | ProcPat ":" ProcPat
  syntax        RhoKVPats ::= RhoKVPat
                            > RhoKVPair "," RhoKVPats  [right]
                            | RhoKVPat  "," RhoKVPairs [right]
                            | RhoKVPat  "," RhoKVPats  [right]

  // RhoSet pattern -- TODO: bind Procs or RhoSet to ProcVar???
  // how to capture Set( )?
    // match each Pat and bind remainder as RhoSet to ProcVar?
  syntax           SetPat ::= "Set(" ProcPats "..." ProcVar ")"
                            | "Set(" Procs    "..." ProcVar ")"
                            | "Set(" ProcPats ")"

  // RhoTuple pattern  -- TODO: ProcVar for binding???
  syntax         TuplePat ::= "(" ProcPats ",)"

/*
// Q: Expressions patterns?
  syntax           ExpPat ::= "{" ExpPat "}" [bracket]
                            | AExpPat
                            | StringExpPat
                            > BExpPat


// Arithmetic
  syntax        IntOrWild ::= Int | WildCard
  syntax          AExpPat ::= "{" AExpPat "}" [bracket]
                            > IntOrWild
                            > "-" AExpPat
                            > AExpPat "%" AExp    // mod reduction
                            > AExpPat "*" AExp    [right]
                            | AExp    "*" AExpPat [right]
                            | AExpPat "*" AExpPat [right]
                            | AExpPat "/" AExp    [right]
                            | AExp    "/" AExpPat [right]
                            | AExpPat "/" AExpPat [right]
                            > AExpPat "+" AExp    [right]
                            | AExp    "+" AExpPat [right]
                            | AExpPat "+" AExp    [right]
                            | AExpPat "-" AExpPat [right]

// String
  syntax     StringOrWild ::= String | WildCard
  syntax     StringExpPat ::= "{" StringExpPat "}" [bracket]
                            > StringOrWild
                            | ConcatPat
                            | InterpPat

  syntax        ConcatPat ::= String ConcatExpPat
                            | WildCard ConcatExp
  syntax     ConcatExpPat ::= "++" WildCard
                            > "++" StringOrWild ConcatExpPat

  syntax        InterpPat ::= StringOrWild "%%" InterpMapPats
                            | WildCard     "%%" InterpMaps
  syntax    InterpMapPats ::= RhoMapPat
                            | RhoMapPat "%%" InterpMapPats
                            > RhoMap    "%%" InterpMapPats

// Boolean
  syntax          BExpPat ::= "{" BExpPat "}"   [bracket]
                            > Bool                // boolean output
                            | WildCard            // e.g. \_ == Proc or not \_
                            > AExp "<=" AExp      [seqstrict]
                            | AExp "<"  AExp      [seqstrict]
                            | AExp ">=" AExp      [seqstrict]
                            > AExp ">"  AExp      [seqstrict]
                            | Name "==" Name      // name equivalence
                            | Name "!=" Name      // not ( Name == Name )
                            | Proc "==" Proc      // structural equivalence
                            | Proc "!=" Proc      // not ( Proc == Proc )
                            > "not" BExp          [strict]
                            > BExp "and" BExp     [strict(1), right]
                            > BExp "or"  BExp     [strict(1), right]
                            > Proc "matches" Proc // P matches Q is syntactic sugar for: match P { { Q :=> true } { P :=> false } }

// Q: Method patterns?
  syntax        MethodPat ::= Proc    NEMethArgPats
                            | ProcPat MethodAndArgs
                            | ProcPat MethArgPats
  syntax    NEMethArgPats ::= "." Method "(" ProcPats ")"
  syntax      MethArgPats ::= NEMethArgPats
                            | "." Method "(" ")"
*/

// Predicates
  syntax           Bool ::=       "#isClosedName(" K ")" [function] // #FV( Name    ) ==K .Set
                          |    "#isClosedNamePat(" K ")" [function] // #FV( NamePat ) ==K .Set
                          |      "#isNameContext(" K ")" [function] // size(#FPV( Proc )) ==Int 0 andBool size(#FNV( Proc )) ==Int 1
                          | "#isMultiNameContext(" K ")" [function] // size(#FPV( Proc )) ==Int 0 andBool size(#FNV( Proc ))  >Int 1
                          |       "#isClosedProc(" K ")" [function] // #FV( Proc    ) ==K .Set
                          |    "#isClosedProcPat(" K ")" [function] // #FV( ProcPat ) ==K .Set
                          |      "#isProcContext(" K ")" [function] // size(#FPV( Proc )) ==Int 1 andBool size(#FNV( Proc )) ==Int 0
                          | "#isMultiProcContext(" K ")" [function] // size(#FPV( Proc ))  >Int 1 andBool size(#FNV( Proc )) ==Int 0
                          |     "#isMixedContext(" K ")" [function] // size(#FPV( Proc )) >=Int 1 andBool size(#FNV( Proc )) >=Int 1
                          |     "#isMixedContext(" Int "," Int ";" K ")" [function] // size(#FPV( Proc )) >=Int 1 andBool size(#FNV( Proc )) >=Int 1

  syntax            Var ::= "#variable(" Proc ")" [function]
  syntax          Names ::= "#variable(" Proc ")" [function]
  syntax          Procs ::= "#variable(" Proc ")" [function]

// For De Bruijn indices & alpha/structural equivalence
  syntax             Name ::= BoundName
  syntax        BoundName ::= "boundN(" Int ")"
                            | "boundN(" Int "," Int ")"

  syntax        BoolOrVar ::= BoundProc // for indexing variables in BExps
  syntax         IntOrVar ::= BoundProc // for indexing variables in AExps
  syntax        ListOrVar ::= BoundProc // for indexing variables in ListExps
  syntax      StringOrVar ::= BoundProc // for indexing variables in StringExps
  syntax        BoundProc ::= "boundP(" Int ")"
                            | "boundP(" Int "," Int ")"

// For blocking in substitution
  syntax              Sub ::= "sub"
  syntax             Proc ::= Sub

// For K
  syntax            KItem ::= Name | Names | Proc | Procs | RhoKVPair | RhoKVPairs

endmodule

// SEMANTICS MODULE
module GRHO
  import ALPHA
  import AUXFUN
  import CONFIG
  import MATCH
  import NAMEVAR
  import SUB
  import STRUCT

  syntax KResult ::= Ground | SimplePat | Proc | List | Map | Set   // final output type of functions & strict operations

// Arithmetic & Boolean expressions are evaluated as soon as they can be
  // Arithmetic expressions -- evaluated immediately
  rule A:IntExp + B:IntExp => #eval(A) +Int #eval(B)
  rule A:IntExp - B:IntExp => #eval(A) -Int #eval(B)
  rule A:IntExp * B:IntExp => #eval(A) *Int #eval(B)
  rule A:IntExp / B:IntExp => #eval(A) /Int #eval(B) requires #eval(B) =/=Int 0
  rule A:IntExp % B:IntExp => #eval(A) %Int #eval(B) requires #eval(B) =/=Int 0
  rule - A:IntExp =>   0 -Int #eval(A)

  // List & String expressions -- evaluated immediately
    // concatenation
  rule A:RhoList ++ B:ConcatRhoList => #concat(A;#eval(B))
  rule A:String  ++ B:StringOnlyExp => #concat(A;#eval(B))
    // interpolation: "begin${key}rest" %% { ..., key:value ,... } => "begin" ++ "value" ++ "rest"
  rule A:StringOnlyExp %% B:InterpMaps => #interpolate(#eval(A);B)

// TODO: #eval(InterpMaps)???

  // Boolean expressions
  rule A:IntExp   <= B:IntExp  => #eval(A)   <=Int #eval(B)
  rule A:IntExp   <  B:IntExp  => #eval(A)    <Int #eval(B)
  rule A:IntExp   >= B:IntExp  => #eval(A)   >=Int #eval(B)
  rule A:IntExp   >  B:IntExp  => #eval(A)    >Int #eval(B)
  rule A:BoolExp and B:BoolExp => #eval(A) andBool #eval(B)
  rule A:BoolExp  or B:BoolExp => #eval(A)  orBool #eval(B)
  rule not A:BoolExp =>  notBool  #eval(A)
    // short-circuited semantics
  rule true  and B:BExp => B     requires notBool isBoolExp(B) [anywhere, structural]
  rule false and B:BExp => false requires notBool isBoolExp(B) [anywhere, structural]
  rule true  or  B:BExp => true  requires notBool isBoolExp(B) [anywhere, structural]
  rule false or  B:BExp => B     requires notBool isBoolExp(B) [anywhere, structural]

// Structural Equivalence
  // Syntactic equality of Ground terms -- checked immediately
  rule A:Ground == B:Ground => A ==K  B [anywhere, structural]
  rule A:Ground != B:Ground => A =/=K B [anywhere, structural]
  // if only one term is Ground, we wait for the other -- e.g. in *x == true, we must wait on a value for x before computing
  // if both terms are not Ground, check structural equivalence immediately
  rule P:Proc == Q:Proc => #structEq(P;Q)
       requires notBool (isGround(P) andBool isGround(Q)) [structural]
  rule P:Proc != Q:Proc => notBool #structEq(P;Q)
       requires notBool (isGround(P) andBool isGround(Q)) [structural]
  rule M:Name == N:Name => #nameEq(M;N)                   [structural]
  rule M:Name != N:Name => notBool #nameEq(M;N)           [structural]

// Conditionals
  rule if ( B:BoolExp ) P:Proc => P   requires #eval(B)         [structural]
  rule if ( B:BoolExp ) _:Proc => Nil requires notBool #eval(B) [structural]
  rule if ( B:BoolExp ) P:Proc else _:Proc => P   requires #eval(B)         [structural]
  rule if ( B:BoolExp ) _:Proc else Q:Proc => Nil requires notBool #eval(B) [structural]

// Matching
  // Match
    // matches binop desugars into #match function call
  rule P:Proc    matches Q:Proc      => #match(P;Q) [structural]
  rule P:Proc    matches Q:ProcPat   => #match(P;Q) requires notBool isSimplePat(Q) [structural]
  rule P:Ground  matches Q:SimplePat => #match(P;Q) [anywhere, structural]
  rule P:ProcPat matches Q:ProcPat   => #match(P;Q) [structural]
//rule (A:Ground \/ B:Ground) matches Q:ProcPat => #match(A;Q) andBool #match(B;Q) [structural]
  rule match { P:Proc } { { Q:Proc    } |=> R:Proc } => #if #match(P;Q) #then #sub(P;Q;R) #else Nil #fi
  rule match { P:Proc } { { Q:ProcPat } |=> R:Proc } => #if #match(P;Q) #then #sub(P;Q;R) #else Nil #fi
  rule match { P:Proc } { { Q:Proc    } |=> R:Proc M:MatchCases } => #if #match(P;Q) #then #sub(P;Q;R) #else match {P}{M} #fi
  rule match { P:Proc } { { Q:ProcPat } |=> R:Proc M:MatchCases } => #if #match(P;Q) #then #sub(P;Q;R) #else match {P}{M} #fi

// New Operator Semantics
  rule <k> new V:VarDecs in { P:Proc } => #subNew(L;#DV(V);P) ...</k>
       <nextLoc> L => L +Int size(#DV(V)) </nextLoc>

// Bundles
  rule A:Send => . requires isBundleMinus(#chan(A)) [structural]
  rule A:SRec => . requires isBundlePlus( #chan(A)) [structural] // TODO: MRec

// Sugar - contract desugars into unconsumable receive
  rule contract X:Name ( Y:Names ) = { P:Proc } => for( Y <= X ){ P }  [structural]
  rule contract X:Name (         ) = { P:Proc } => for(   <= X ){ P }  [structural]

// Par Operator Semantics - concurrent execution of processes
  // each nonPar Proc in a top-level Par gets its own <task/> cell
  rule <task>
         <k> P:Proc | Q:Proc => Q ...</k>
       </task>
       (.Bag => <task> <k> P </k> </task>)
       requires notBool isPar(P)
  rule <task>
         <k> P:Proc | Q:ProcPat => Q ...</k>
       </task>
       (.Bag => <task> <k> P </k> </task>)
       requires notBool isPar(P)
  rule <task>
         <k> P:ProcPat | Q:Proc => Q ...</k>
       </task>
       (.Bag => <task> <k> P </k> </task>)
       requires notBool isParPat(P)
  rule <task>
         <k> P:ProcPat | Q:ProcPat => Q ...</k>
       </task>
       (.Bag => <task> <k> P </k> </task>)
       requires notBool isParPat(P)

//-------------------------------
//--- Send Operator Semantics ---
//-------------------------------
  rule (<task> <k> S:Send </k> </task> => .Bag) // dissolve send in <activity/> and spawn <send/>
       (.Bag => <send> S </send>)
  rule (<task> <k> S:SendPat </k> </task> => .Bag) // dissolve send in <activity/> and spawn <send/>
       (.Bag => <send> S </send>)

//----------------------------------
//--- Receive Operator Semantics ---
//----------------------------------
  rule (<task> <k> R:Receive </k> </task> => .Bag) // dissolve Rec in <activity/> and spawn <rec/>
       (.Bag => <rec> R </rec>)
  rule (<task> <k> R:RecPat </k> </task> => .Bag) // dissolve Rec in <activity/> and spawn <rec/>
       (.Bag => <rec> R </rec>)

//---------------------------------
//--- Select operator semantics ---
//---------------------------------
  rule
  (<task> <k> select { M:Branches } </k> </task> => .Bag)
  (.Bag => <sum> <branches> <branch> M </branch> </branches> </sum>)
  rule <branch> M:Branch N:Branches </branch>
    => <branch> M </branch> <branch> N </branch>

//-------------------
//--- COMM EVENTS ---
//-------------------
// Communication over name equivalent channels
// x!(Q) | for( z <- y ){P} => #sub(@Q;z;P) requires #nameEq(x;y)

  syntax SendCell
  syntax SendCellBag
  syntax Bag ::= SendCellBag
  syntax Bool ::= "#matchComm(" SendCell    ";;" AnyBind  ")" [function]
                | "#matchComm(" SendCellBag ";;" AnyBinds ")" [function]

  rule #matchComm( .SendCellBag ;; _:AnyBinds ) => false
  rule #matchComm( <send> _:Send </send> ;; _:AnyBinds ) => false
//  rule #matchComm( <send> A:Send </send> B ;; C:Bind & D:Bind  )
//    => #matchBind(A;;C) andBool #matchComm(B;;D)
//  rule #matchComm( <send> A:Send </send> B ;; C:Bind & D:Binds )
//    => #matchBind(A;;C) andBool #matchComm(B;;D)

  rule
  (<rec>  R:LinearSRec </rec> => .Bag)
  (<send> S:ConSend   </send> => .Bag)
  (.Bag => <task> <k> #order(#sub(#quotes(#msg(S));#bvar(R);#cont(R))) </k> </task>)
   requires #matchComm(S;;#gbind(R)) [comm]

  rule
  (<rec>  R:SRec       </rec> => .Bag)
   <send> S:UnconSend </send>
  (.Bag => <task> <k> #order(#sub(#quotes(#msg(S));#bvar(R);#cont(R))) </k> </task>)
   requires #matchComm(S;;#gbind(R)) andBool notBool isRepeatSRec(R) [comm]

  rule
  (<rec>  R:PeekSRec   </rec> => .Bag)
   <send> S:ConSend   </send>
  (.Bag => <task> <k> #order(#sub(#quotes(#msg(S));#bvar(R);#cont(R))) </k> </task>)
   requires #matchComm(S;;#gbind(R)) [comm]

  rule
   <rec>  R:RepeatSRec </rec>
  (<send> S:ConSend   </send> => .Bag)
  (.Bag => <task> <k> #order(#sub(#quotes(#msg(S));#bvar(R);#cont(R))) </k> </task>)
        requires #matchComm(S;;#gbind(R)) [comm]
//  rule  <rec>  R:RepeatSRec </rec>
//        <send> S:UnconSend </send>
//        requires #matchComm(S;;#gbind(R))

//  rule (<rec> R:MRec </rec> => .Bag)
//        <sends> (S => .Bag) ...</sends>
//       (.Bag => <task> <k> "wow" </k> </task>)
//        requires #matchComm(S;;#gbind(R)) [comm]

// Eliminate Nil in parallel compositions
  rule    Nil | P:Proc => P  [anywhere, structural]
  rule P:Proc | Nil    => P  [anywhere, structural]

// Dissolve computationally meaningless activity
  rule <task> <k> .K  </k> </task> => .Bag  [structural]
  rule <task> <k> Nil </k> </task> => .Bag  [structural]

// NAME EQUIVALENCE
// @{*x} \equiv_N x
// P \equiv Q \implies @P \equiv_N @Q
  rule @ * N:Name => N  [anywhere, structural]
  rule * @ P:Proc => P  [anywhere, structural]

  rule  * A:Names =>  #evals(A) requires notBool isName(A) [structural]
  rule  @ A:Procs => #quotes(A) requires notBool isProc(A) [structural]

// Complement Idempotency
  rule ~ ~ P:Proc    => P [anywhere, structural]
  rule ~ ~ P:ProcPat => P [anywhere, structural]

// Predicates for closed terms
  rule       #isClosedProc( A:Proc    ) => #FV(A) ==K .Set
  rule       #isClosedProc( A:K       ) => false requires notBool isProc(A)

  rule    #isClosedProcPat( A:ProcPat ) => #FV(A) ==K .Set
  rule    #isClosedProcPat( A:K       ) => false requires notBool isProcPat(A)

  rule       #isClosedName( A:Name    ) => #FV(A) ==K .Set
  rule       #isClosedName( A:K       ) => false requires notBool isName(A)

  rule    #isClosedNamePat( A:NamePat ) => #FV(A) ==K .Set
  rule    #isClosedNamePat( A:K       ) => false requires notBool isNamePat(A)

  rule      #isProcContext( A:Proc ) => size(#FNV(A)) ==Int 0 andBool size(#FPV(A)) ==Int 1
  rule           #variable( A:Proc ) => flatten(#FPV(A))
  rule      #isProcContext( A:K    ) => false requires notBool isProc(A)

  rule #isMultiProcContext( A:Proc ) => size(#FNV(A)) ==Int 0 andBool size(#FPV(A))  >Int 1
//  rule        #variable( A:Proc    ) => flatten(#FPV(A))
  rule #isMultiProcContext( A:K    ) => false requires notBool isProc(A)

  rule      #isNameContext( A:Proc ) => size(#FNV(A)) ==Int 1 andBool size(#FPV(A)) ==Int 0
  rule           #variable( A:Proc ) => flatten(#FNV(A))
  rule      #isNameContext( A:K    ) => false requires notBool isProc(A)

  rule #isMultiNameContext( A:Proc ) => size(#FNV(A))  >Int 1 andBool size(#FPV(A)) ==Int 0
//  rule        #variable( A:Proc    ) => flatten(#FNV(A))
  rule #isMultiNameContext( A:K    ) => false requires notBool isProc(A)

  rule     #isMixedContext( A:Proc ) => size(#FNV(A)) >=Int 1 andBool size(#FPV(A)) >=Int 1
//  rule        #variable( A:Proc    ) => flatten(#FNV(A))
  rule     #isMixedContext( A:K    ) => false requires notBool isProc(A)

  rule     #isMixedContext( N:Int , P:Int ; A:Proc ) => size(#FNV(A)) ==Int N andBool size(#FPV(A)) ==Int P
//  rule        #variable( A:Proc    ) => flatten(#FNV(A))
  rule     #isMixedContext( _:Int , _:Int ; A:K    ) => false requires notBool isProc(A)

/*
// Methods
  // add

  // confine

  // contains (maps & sets)
  rule M:Map .contains( Key:Proc ) => Key in_keys(M)
  rule S:Set .contains( Elm:Proc ) => Elm in S

  // delete (maps & sets)
  rule M:Map .delete( Key:Proc ) => M[ Key <- undef ]
  rule S:Set .delete( Elm:Proc ) => S -Set SetItem(Elm)

  // diff (maps & sets)
  rule M1:Map .diff( M2:Map ) => removeAll( M1 , keys(M2) )
  rule S1:Set .diff( S2:Set ) => S1 -Set S2

  // get (maps)
  rule M:Map .get( Key:Proc ) => #if ( Key in_keys(M) ) #then M[Key] #else Nil #fi

  //getOrElse (maps)
  rule M:Map .getOrElse( Key:Proc , Else:Proc ) => #if ( Key in_keys(M) ) #then M[Key] #else Else #fi

  // hexToBtyes

  // iterate

  // legnth (list & tuple)
  rule L:List .length( ) => size(L)

  rule ( ,) .length( ) => 0
  rule ( P:Procs ,) .length( ) => #length(P)

  // mapkeys (maps)
  rule M:Map .keys( ) => keys( M )

  // nth (lists & tuples)
  rule L:List .nth( I:Int ) => L[I]

  rule ( ,):RhoTuple.nth( _ ) => Nil
  rule ( P:Proc ,).nth( I:Int ) => #if I ==Int 0 #then P #else Nil #fi
  rule ( P:Proc , Q:Procs ,).nth( I:Int ) => #if I ==Int 0 #then P #else ( Q ,).nth( I -Int 1 ) #fi

  // set (maps)
  rule M:Map .set( Key:Proc , Val:Proc ) => updateMap( M , Key |-> Val)

  // size (maps & sets)
  rule M:Map .size( ) => size(M)
  rule S:Set .size( ) => size(S)

  // slice (lists & strings)
  rule S:String .slice( A:Int , B:Int ) => substrString( S , A , B )
  rule L:List .slice( A:Int , B:Int ) => range( L , A , B )

  // toByteArray

  // values (maps)
  rule M:Map .values( ) => values(M)

  // union (maps & sets)
  rule M1:Map .union( M2:Map ) => M1 M2
  rule S1:Set .union( S2:Set ) => S1 S2

// Syntactic sugar - quoted tuple listens desugar into regular listen
// included here (instead of in sytax module) because #quotes is defined in AUXFUN
  rule for( @ ( A:Proc  ) <- X:Name ){ P:Proc } => for( @A <- X ){ P }  [anywhere, structural]
  rule for( @ ( A:Proc  ) <= X:Name ){ P:Proc } => for( @A <= X ){ P }  [anywhere, structural]
  rule for( @ ( A:Proc  ) <<- X:Name ){ P:Proc } => for( @A <<- X ){ P }  [anywhere, structural]
  rule for( @ ( A:Proc  ) << X:Name ){ P:Proc } => for( @A << X ){ P }  [anywhere, structural]
  rule for( @ ( A:Procs ) <- X:Name ){ P:Proc } => for( #quotes(A) <- X ){ P } [anywhere, structural]
  rule for( @ ( A:Procs ) <= X:Name ){ P:Proc } => for( #quotes(A) <= X ){ P } [anywhere, structural]
  rule for( @ ( A:Procs ) <<- X:Name ){ P:Proc } => for( #quotes(A) <<- X ){ P } [anywhere, structural]
  rule for( @ ( A:Procs ) << X:Name ){ P:Proc } => for( #quotes(A) << X ){ P } [anywhere, structural]
*/
/*
TODO:
 - Matching (patterns & wildcard)
 - add TypedName ::= Name [":" Proc[Pat] ]
 - select semantics
 - Method semantics
 - Invocation semantics - syntactic sugar for cell pattern(?)
 - NativeChan semantics

**V1.1 features**
 - New & improved for-comprehension:
   for( ptrn 11 <- src 11 & ... & ptrn 1n <- src 1n ;
        ...
        ptrn m1 <- src m1 & ... & ptrn mn <- src mn ;
      ){P}
   where src ::= x | x?! | x!?( a 1 , ..., a k ) and ‘&’ replaces the old meaning of ‘;’
   ⟦for( ptrn <- x?! ){P}⟧ = for( ptrn, r <- x ){ r!() | ⟦P⟧ }
   ⟦for( ptrn <- x!?( a 1 , ..., a k )){P}⟧ = new r in { x!( a 1 , ..., a k , *r) | for( ptrn <- r ){ ⟦P⟧ } }

 - Sequential output (pattern?):
   - x!?(v);P
    ⟦x!?(v);P⟧ = new r in x!((v,*r)) | for( _ ← r ){ ⟦P⟧ }
   - x!?(v).
    ⟦x!?(v).⟧ = x!?(v);0

  syntax  SeqOutput ::= Name "!?" "(" [Proc[s]] ")" ";" Proc
                      | Name "!?" "(" [Proc[s]] ")" "."
  rule A:Name !?(         ) ; C:Proc => new !X:Var in { A!(*!X)            | for( \_ <- !X ){ C } } [structural]
  rule A:Name !?( B:Proc  ) ; C:Proc => new !X:Var in { A!(B,*!X)          | for( \_ <- !X ){ C } } [structural]
  rule A:Name !?( B:Procs ) ; C:Proc => new !X:Var in { A!(#append(B,*!X)) | for( \_ <- !X ){ C } } [structural]

 - Sequential/nested let expressions:
    let ptrn_1 <- v_1 ; ... ; ptrn_m <- v_m in P
   ⟦let ptrn_1 <- v_1 ; ... ; ptrn_n <- v_n in P ⟧ = new x in { x!(v_1) | for( ptrn_1 <- x_1 ){ ⟦let ptrn_2 <- v_2 ; ... ; ptrn_n <- v_n in P ⟧ } }

  syntax         Let ::= "let" Lbind

  syntax    SeqLbinds ::= Lbind
                        | Lbind";" SeqLbinds [right]
  syntax  SeqLetBinds ::= LetBind
                        | "let" SeqLbinds

  syntax    SimLbinds ::= Lbind
                        | Lbind "&" SimLbinds [right]
  syntax  SimLetBinds ::= LetBind
                        | "let" SimLbinds

  syntax SeqSimLbinds ::= Lbind
                        | SeqLbinds
                        | SimLbinds
                        | Lbind     ";" SeqSimLbinds [right]
                        | SeqLbinds ";" SeqSimLbinds [right]
                        | SimLbinds ";" SeqSimLbinds [right]
  syntax   SeqSimLets ::= LetBind
                        | SimLetBinds
                        | SeqLetBinds
                        | SimLetBinds ";" SeqSimLets  [right]

  syntax       LetExp ::= SimpleLetExp
                        | SeqLetExp
                        | SimLetExp
                        | SeqSimLetExp
  syntax  BasicLetExp ::= LetBind     "in" Proc
  syntax    SeqLetExp ::= SeqLetBinds "in" Proc
  syntax    SimLetExp ::= SimLetBinds "in" Proc
  syntax SeqSimLetExp ::= SeqSimLets  "in" Proc
  syntax         Proc ::= LetExp

// Sequential Let Binds
  rule let A:Lbind in P:Proc => new !X:Var in { !X!(*#chan(A)) | for( #bvar(A) <- !X ){ P } }
  rule let A:Lbind ; let B:Lbind  in P:Proc => new !X:Var in { !X!(*#chan(A)) | for( #bvar(A) <- !X ){ let B in P } }
  rule let A:Lbind ; let B:Lbinds in P:Proc => new !X:Var in { !X!(*#chan(A)) | for( #bvar(A) <- !X ){ let B in P } }

 - Simultaneous let expressions:
    let ptrn_1 <- v_1 & ... & ptrn_m <- v m in P
   ⟦let ptrn_1 <- v_1 & ... & ptrn_n <- v_n in P ⟧ = new x_1 , ... , x_n in { x_1 !(v_1) | ... | x_n!(v_n) | for( ptrn_1 <- x_1 & ... & ptrn_n <- x_n ){ ⟦P⟧ }

// Simultaneous Let Binds -- TODO: sub into Binds
// syntax SeqProcs ::= Procs
                     > Procs ";" SeqProcs [right]
// #sends( A:Name ;; B:Procs ) => A!(B)
// #sends( A:Name , B:Names ;; C:Procs ; D:SeqProcs ) => #sends(A;;C) | #sends(B;;D)
  rule let A:SimLbinds in B:Proc => new freshVars(#length(A)) in { #sends(freshVars(#length(A));;) #sub(freshNames(#length(A));#chan(A);P) }

 new A:Names in { P:Proc }

// Receive peek (Sneak?): -- TODO: #quotes( SeqProcs ), SeqNames ::= #seqbvars( Binds ), #freevar( Proc )
  syntax Send ::= Name "?" "(" SeqProcs ";;" Proc ")"
  "rule" X:Name ?( P:SeqProcs ;; C:Proc ) | for( B:Binds ){ Q:Proc } | ... => for(B){Q} | #sub(#sub(#quotes(P);#seqbvars(B);Q);#freevar(C);C) | ...
   requires size(#PV(C)) ==Int 1 andBool size(#NV(C)) ==Int 0
*/
endmodule
