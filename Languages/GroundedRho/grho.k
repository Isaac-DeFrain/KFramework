// Rholang syntax & semantics

require "domains.k"
require "AuxFun/auxfun.k"
require "Configuration/config.k"
require "Match/match.k"
require "Methods/method.k"
require "MRecMatch/mrec.k"
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
                            > Var          // Name variable
                            > Quote        // Quoted process
                            > VarDec       // New name declaration
                            > TypedName    // Typed name
  syntax         QuoteVar ::= "@" ProcVar
  syntax            Quote ::= QuoteVar
                            > "@" Proc
  syntax           VarDec ::= Var | NewUri
  syntax           NewUri ::= Var "(" Uri ")"

  // Typed Name
  syntax        TypedName ::= Name "::" NamePat
                            | Name "::" Name  [strict(2)] // names have the same type

// Several Names
  syntax            Names ::= Vars
                            > VarDecs
                            > Name
                            > Name "," Names [right]
  syntax            Names ::= "@" Procs   [function]

  // Several name variable declarations
  syntax          VarDecs ::= Vars
                            > VarDec
                            > VarDec "," VarDecs  [right]
  // Names List
  syntax        NamesList ::= Names
                            > Names "&" NamesList [right]

//-----------------
//--- PROCESSES ---
//-----------------
// TODO: Finalize precedence
  syntax             Proc ::= "{" Proc "}" [bracket]
                            > New          // New name declaration(s)
                            > Ground       // Ground terms - Bool, Int, Nil, String, Uri, Unforgeable
                            | Collection   // Data structures - RhoList, RhoMap, RhoSet, RhoTuple
                            | ProcVar      // Process variable
                            > TypedProc    // Typed processes
                            > VarRef       // Variable references - Name/Process variable shadowing
                            > Eval         // Evaluation
                            > MethodProc   // Methods
                            > Exp          // Arith, Bool, & String expressions
                            | LetExp       // Let expressions
                            > Matching     // Match & Select
                            > Receive      // Receive messages
                            | Contract     // Contract
                            | Invocation   // Contract invocation
                            | Send         // Send messages
                            > Conditional  // If...then(...else)
                            > Bundle       // Process bundles
                            > Par          // Parallel composition

  syntax          ProcVar ::= PVar
  syntax             PVar ::= "\\" Var
  syntax            PVars ::= PVar
                            > PVar "," PVars   [right]
  syntax        TypedProc ::= Proc "::" ProcPat
                            | Proc "::" Proc   [strict(2)] // processes have the same type

// Several Processes
  syntax            Procs ::= Proc
                            > PVars
                            > Proc "," Procs [right]

  syntax        ProcsList ::= Procs
                            > Procs "&" ProcsList [right]

// Parallel composition
  // Par is a multiset of processes represented as an order-normalized list of processes
    // each nonPar Proc is put into it's own <k/> cell when the Par is at the top-level
    // implemented as a multiset in STRUCT
  syntax              Par ::= Proc "|" Proc [right]

// Receives
  syntax          Receive ::= SRec   | MRec | GRec | UGRec
  syntax             GRec ::= GSRec  | GMRec
                            > "for" "(" OrGBinds ")" "{" Proc "}"
  syntax            UGRec ::= UGSRec | UGMRec
                            > "for" "(" OrBinds  ")" "{" Proc "}"

  // Single Listen Receives
  syntax             SRec ::= GSRec       // Guarded single receieve
                            | UGSRec      // Unguarded single receieve
                            > "for" "(" AnyBind ")" "{" Proc "}"
  syntax           UGSRec ::= LinearSRec  // Linear single receieve, unguarded
                            | PeekSRec    // Peek single receieve, unguarded
                            | RepeatSRec  // Repeat single receieve, unguarded
                            > "for" "(" Bind    ")" "{" Proc "}"
  syntax            GSRec ::= GLinearSRec // Linear single receieve, guarded
                            | GPeekSRec   // Peek single receieve, guarded
                            | GRepeatSRec // Repeat single receieve, guarded
                            > "for" "(" GBind   ")" "{" Proc "}"
  // Input Guard
  syntax            Guard ::= "if" BExp

  // Linear Single
  syntax       LinearSRec ::= "for" "(" Lbind  ")" "{" Proc "}"
  syntax      GLinearSRec ::= "for" "(" GLbind ")" "{" Proc "}"
  syntax            Lbind ::= NamePats "<-"  Name
                            | EmptyLbind
  syntax       EmptyLbind ::=          "<-"  Name

  // Peek Single
  syntax         PeekSRec ::= "for" "(" Pbind  ")" "{" Proc "}"
  syntax        GPeekSRec ::= "for" "(" GPbind ")" "{" Proc "}"
  syntax            Pbind ::= NamePats "<<-" Name
                            | EmptyPbind
  syntax       EmptyPbind ::=          "<<-" Name

  // Repeated/Persistent Single
  syntax       RepeatSRec ::= "for" "(" Rbind  ")" "{" Proc "}"
  syntax      GRepeatSRec ::= "for" "(" GRbind ")" "{" Proc "}"
  syntax            Rbind ::= NamePats "<="  Name
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

  // Multiple Listen Receives
  syntax             MRec ::= GMRec       // Guarded multi receive
                            | UGMRec      // Unguarded multi receive
                            > "for" "(" AnyBinds ")" "{" Proc "}"
  syntax           UGMRec ::= LinearMRec  // Linear multi receive, unguarded
                            | PeekMRec    // Peek multi receive, unguarded
                            | RepeatMRec  // Repeat multi receive, unguarded
                            > "for" "(" Binds    ")" "{" Proc "}"
  syntax            GMRec ::= GLinearMRec // Linear multi receive, guarded
                            | GPeekMRec   // Peek multi receive, guarded
                            | GRepeatMRec // Repeat multi receive, guarded
                            > "for" "(" GBinds   ")" "{" Proc "}"
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
                            > Bind "&" Bind
                            | Bind "&" Binds [right]
  syntax           GBinds ::= GLbinds | GPbinds | GRbinds
                            > Binds Guard
  syntax         AnyBinds ::= Binds | GBinds
  syntax         OrLbinds ::= Lbind > Lbinds
  syntax         OrPbinds ::= Pbind > Pbinds
  syntax         OrRbinds ::= Rbind > Rbinds
  syntax          OrBinds ::= Bind  > Binds
                            > OrLbinds | OrPbinds | OrRbinds
  syntax         OrGBinds ::= GBind > GBinds

// Sends
  syntax             Send ::= ConSend | UnconSend
  // Consumable -- ephemeral data
  syntax          ConSend ::= Name "!"  "(" Procs ")" [strict(1,2)]
                            | EmptyCSend
  syntax       EmptyCSend ::= Name "!"  "("       ")" [strict(1)]
  // Unconsumable -- persistent data
  syntax        UnconSend ::= Name "!!" "(" Procs ")" [strict(1,2)]
                            | EmptyUSend
  syntax       EmptyUSend ::= Name "!!" "("       ")" [strict(1)]

// Eval -- evaluation
  syntax          EvalVar ::= "*" Var
  syntax             Eval ::= EvalVar
                            > "*" Name
  syntax            Procs ::= "*" Names [function]

// New -- declares variables corresponding to fresh unforgeable Names
  syntax              New ::= "new" VarDecs "in" "{" Proc "}"

// Matching
  syntax         Matching ::= Match | Select
  // Match -- pattern matching construct
  syntax            Match ::= "match" Proc "{" MatchCases "}"
  syntax        MatchCase ::= "{" ProcPat "}" "|=>" Proc
  syntax       MatchCases ::= MatchCase
                            > MatchCase MatchCases [right]
  // Select -- receive-guarded choice
  syntax           Select ::= "select" "{" Branches "}"
  syntax           Branch ::= "{" Lbind   "}" "|=>" Proc
                            | "{" Lbinds  "}" "|=>" Proc
                            | "{" GLbind  "}" "|=>" Proc
                            | "{" GLbinds "}" "|=>" Proc
  syntax         Branches ::= Branch
                            > Branch Branches [right]

// Let expressions
  syntax           LetExp ::= BasicLetExp
                            > SeqLetExp
                            | SimLetExp
                            > SeqSimLetExp
  syntax      BasicLetExp ::= BasicLet   "in" "{" Proc "}"
  syntax        SeqLetExp ::= SeqLets    "in" "{" Proc "}"
  syntax        SimLetExp ::= BasicLetExp
                            > SimLets    "in" "{" Proc "}"
  syntax     SeqSimLetExp ::= SeqSimLets "in" "{" Proc "}"
                            > SeqLetExp
                            | SimLetExp
  syntax          LetBind ::= ProcVar "<-" Proc          [strict(2)]
  syntax      SeqLetBinds ::= LetBind ";" LetBind
                            | LetBind ";" SeqLetBinds        [right]
  syntax      SimLetBinds ::= LetBind
                            > LetBind "&" SimLetBinds        [right]
  syntax   SeqSimLetBinds ::= SeqLetBinds ">" SimLetBinds
                            | SimLetBinds ">" SeqLetBinds
                            | SimLetBinds ">" SimLetBinds    [right]
                            | SeqLetBinds ">" SeqSimLetBinds [right]
                            | SimLetBinds ">" SeqSimLetBinds [right]
  syntax         BasicLet ::= "let" LetBind
  syntax          SeqLets ::= "let" SeqLetBinds
  syntax          SimLets ::= BasicLet
                            > "let" SimLetBinds
  syntax       SeqSimLets ::= "let" SeqSimLetBinds

// Variable Reference - allows for variable shadowing
  syntax           VarRef ::= NameRef
                            | ProcRef
  syntax          NameRef ::= "=" "*" Var // shadows a Name variable
  syntax          ProcRef ::= "=" ProcVar // shadows a Proc variable

// Conditional
  syntax      Conditional ::= IfThen | Else
  syntax           IfThen ::= "if" "(" BExp ")" Proc  [strict(1)]
  syntax             Else ::= IfThen "else" Proc      [avoid]

// Contract - syntactic sugar for persistent single receive with no input guard
  syntax         Contract ::= "contract" Name "(" NamePats ")" "=" "{" Proc "}"
                            | "contract" Name "("          ")" "=" "{" Proc "}"

// Contract Invocation
  syntax       Invocation ::= Name "(" Names ")"
                            | Name "("       ")"

// Collections - native data structures
  syntax       Collection ::= RhoList | RhoMap | RhoSet | RhoTuple

  // Process lists
  syntax        EmptyList ::= "[" "]"
  syntax          RhoList ::= "[" Procs "]"
                            | EmptyList

  // Process maps
  syntax         EmptyMap ::= "{" "}"
  syntax           RhoMap ::= "{" RhoKVPairs "}"
                            | EmptyMap
    // Key-value pairs
  syntax        RhoKVPair ::= Proc ":" Proc
  syntax       RhoKVPairs ::= RhoKVPair
                            > RhoKVPair "," RhoKVPairs [right]

  // Process sets
  syntax         EmptySet ::= "Set(" ")"
  syntax           RhoSet ::= "Set(" Procs ")"
                            | EmptySet

  // Process tuples
    // trailing comma added to disambiguate from builtin parens
  syntax         RhoTuple ::= "(" Procs ",)"

// Ground terms -- computationally void processes
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


// TODO: priorities
// Expressions resolve to ground terms
  syntax              Exp ::= "{" Exp "}" [bracket]
                            > AExp
                            | LiStrExp
                            > BExp
  // Arithmetic
  syntax         IntOrVar ::= Int | ProcVar | EvalVar
  syntax             AExp ::= "{" AExp "}" [bracket]
                            > IntOrVar
                            > AExpNeg
                            > AExpMod
                            > AExpMul | AExpDiv
                            > AExpSum | AExpSub
                            > IntExp

  syntax          AExpNeg ::= IntNeg
                            > "-" AExp       [strict]
  syntax          AExpMod ::= IntMod
                            > AExp "%" AExp  [strict(2), left] // mod reduction
  syntax          AExpMul ::= IntMul
                            > AExp "*" AExp  [strict, right]
  syntax          AExpDiv ::= IntDiv
                            > AExp "/" AExp  [strict, right]
  syntax          AExpSum ::= IntSum
                            > AExp "+" AExp  [strict, right]
  syntax          AExpSub ::= IntSub
                            > AExp "-" AExp  [strict, right]
    // AExps ready for evaluation
  syntax           IntExp ::= Int > IntNeg > IntMod
                            > IntMul | IntDiv
                            > IntSum | IntSub
  syntax           IntNeg ::= "-" IntExp
  syntax           IntMod ::= IntExp "%" IntExp [left]
  syntax           IntMul ::= IntExp "*" IntExp [right]
  syntax           IntDiv ::= IntExp "/" IntExp [right]
  syntax           IntSum ::= IntExp "+" IntExp [right]
  syntax           IntSub ::= IntExp "-" IntExp [right]

  // RhoList & String expressions
  syntax        ListOrVar ::= RhoList | ProcVar | EvalVar
  syntax          ListExp ::= "{" ListExp "}"              [bracket]
                            > ListOrVar
                            | ConcatList
  syntax    ConcatRhoList ::= RhoList
                            | RhoList    "++" ConcatRhoList  [right]
  syntax       ConcatList ::= ConcatRhoList
                            > ListOrVar  "++" ListOrVar
                            | ListOrVar  "++" ConcatList     [right]
                            | Invocation "++" ConcatList [strict(1)]
  syntax      StringOrVar ::= String | ProcVar | EvalVar
  syntax        StringExp ::= "{" StringExp "}"            [bracket]
                            > StringOnlyExp
                            > StringOrVar
                            > ConcatStr  // string concat
                            > Interp     // string interpolation
  syntax     ConcatString ::= String
                            > String      "++" StringOnlyExp [right, strict(2)]
  syntax        ConcatStr ::= ConcatString
                            > StringOrVar "++" StringExp     [right, strict(2)]
  syntax           Interp ::= InterpString
                            > StringExp   "%%" InterpMaps    [right, strict(1)]
  syntax           Concat ::= ConcatList | ConcatStr
  syntax         LiStrExp ::= ListExp | StringExp | Concat
    // StringExps ready for evaluation
  syntax     InterpString ::= String
                            > StringOnlyExp "%%" InterpMaps [right]
  syntax       InterpMaps ::= RhoMap
                            > RhoMap "%%" InterpMaps
  syntax    StringOnlyExp ::= String
                            > ConcatString | InterpString

  // Boolean
  syntax        BoolOrVar ::= Bool | ProcVar | EvalVar
  syntax             BExp ::= "{" BExp "}" [bracket]
                            > BoolOrVar
                            > BExpLeq | BExpL | BExpGeq | BExpG
                            > Name "==" Name  // name equivalence
                            | Name "!=" Name
                            | Proc "==" Proc  // structural equivalence
                            | Proc "!=" Proc
                            > ProcPat "matches" ProcPat
                            > BExpNot > BExpAnd > BExpOr
                            > BoolExp

  syntax          BExpLeq ::= BoolLeq
                            > AExp "<=" AExp  [seqstrict]
  syntax            BExpL ::= BoolL
                            > AExp "<"  AExp  [seqstrict]
  syntax          BExpGeq ::= BoolGeq
                            > AExp ">=" AExp  [seqstrict]
  syntax            BExpG ::= BoolG
                            > AExp ">"  AExp  [seqstrict]
  syntax          BExpNot ::= BoolNot
                            > "not" BExp      [strict]
  syntax          BExpAnd ::= BoolAnd
                            > BExp "and" BExp [strict(1), right]
  syntax           BExpOr ::= BoolOr
                            > BExp "or"  BExp [strict(1), right]
    // BExps ready for evaluation
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
                            | "." Method "("       ")"

  // Are acknowledgement arguments needed?
  syntax           Method ::= "nth"          // nth element in list, tuple - _.nth( Int )
                            | "toByteArray"  // transform to bytearray - Proc.toByteArray( )
                            | "toUtf8Bytes"  // String -> Utf8 bytes
                            | "hexToBytes"   // hex encoded string -> bytes
                            | "union"        // map, set union - A1.union( A2 )
                            | "diff"         // map, set difference - A1.diff( A2 )
                            | "add"          // set add element
                            | "delete"       // map, set delete element/KVPair - map.delete(key)
                            | "contains"     // contains predicate - map:key, set
                            | "get"          // get - get value corresponding to key - map.get( key )
                            | "getOrElse"    // getOrElse - get or side condition - map.getOrElse( key , sideConditionProc )
                            | "set"          // set - map.set( key , value ) == updateMap( map , key:value )
                            | "keys"         // set of keys of a map - map.keys( )
                            | "size"         // size of map, set - _.size()
                            | "length"       // length of list, string - _.length()
                            | "slice"        // slice of list, string, byte array - _.slice(I1,I2)
                            | "interpolate"  // string interpolation - string.interpolate(map)
// not implemented yet
//                          | "append"       // append list, string, map, set, GByteArray - type.append(same type(s))
//                          | "values"       // list of values of a map - map.values( )
//                          | "iterate"      // iterate over list, tuple - _.iterate( chan )
//                          | "confine"      // semantics? - confine communication channels

// Bundles -- cannot be destructured with pattern-matching
  // e.g. bundle?{P} acts as process P with object capabilities -- read/write permissions
  syntax           Bundle ::= BundleRead | BundleWrite | BundleEquiv | BundleBoth
  syntax       BundleRead ::= "bundle-{" Proc "}" // read-only
  syntax      BundleWrite ::= "bundle+{" Proc "}" // write-only
  syntax      BundleEquiv ::= "bundle0{" Proc "}" // only for equivalence checking
  syntax       BundleBoth ::=  "bundle{" Proc "}" // both read/write

//----------------
//--- Patterns ---
//----------------
// WildCards
  syntax         WildCard ::= "\\_" // instead of simply _
  syntax        WildCards ::= WildCard
                            > WildCard "," WildCards [right]

// Name pattern
  syntax          NamePat ::= "{" NamePat "}" [bracket]
                            > Name
                            > WildCard
                            > QuotePat
                            | SimpleNamePat
//                          > NamePatExp
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
  syntax         QuotePat ::= Quote
                            > "@" ProcPat

// Simple Name pattern
  syntax    SimpleNamePat ::= "ClosedName" | "ClosedNamePat" // other?
                            | "Quote"  | "NameVar" | "NamePat"
                            | "Bundle" | "Bundle+" | "Bundle-" | "Bundle0" | "Bundle_"

// Name patterns
  // NamePats contain at least one WildCard, i.e. they cannot all be Names
  syntax         NamePats ::= Names
                            > NamePat
                            > WildCards
                            > NamePat "," NamePats [right]

  syntax     NamePatsList ::= NamePats
                            > NamePats "&" NamePatsList [right]

// Pattern
  // TODO: finalize precedence
  syntax          ProcPat ::= "{" ProcPat "}" [bracket]
                            > Proc
                            > WildCard
                            > PatExp          // Pattern expression
                            > NewPat          // New pattern
                            | CollectionPat   // Collection pattern
                            | SimplePat       // simple types
                            > EvalPat         // Evaluation pattern
                            > MethodPat       // Method pattern
//                          > ExpPat          // Arith, Bool, & String pattern???
                            > MatchingPat     // Match & Select pattern
                            > RecPat          // Receive pattern
                            | ContractPat     // Contract pattern
                            | InvocationPat   // Contract invocation pattern
                            | SendPat         // Send pattern
                            > CondPat         // If...then(...else) pattern
                            > BundlePat       // Bundle pattern
                            > ParPat          // Par pattern

// Simple Process Patterns
  syntax        SimplePat ::= "Bool" | "Int" | "String" | "Empty" | "WildCard"
                            | "List" | "Map" | "Set" | "Tuple" | "Unforgeable" | "Unit" | "Uri"
                            | "ClosedProc" | "ClosedProcPat"
                            | "Proc" | "Ground" | "Par" | "Send" | "Receive" | "ProcVar"
                            | "Contract" | "Method"
                            | "ProcPat"  | "ByteArray"
                            // add SimplePat for other Proc constructors

// Not-so-simple Patterns
  syntax         ProcPats ::= ProcPat
                            > Procs
                            > WildCards
                            > ProcPat "," ProcPats [right]

  syntax     ProcPatsList ::= ProcPats
                            > ProcPats "&" ProcPatsList [right]

// Parallel composition pattern
  syntax           ParPat ::= Par
                            > ProcPat "|" ProcPat [right]

// Receive Pattern
  syntax           RecPat ::= Receive
                            > SRecPat | MRecPat | GRecPat | UGRecPat
  syntax          GRecPat ::= GRec
                            > GSRecPat  | GMRecPat
  syntax         UGRecPat ::= UGRec
                            > UGSRecPat | UGMRecPat

  // Single listen receive pattern
  syntax          SRecPat ::= SRec
                            > GSRecPat | UGSRecPat
  syntax         GSRecPat ::= GSRec
                            > GLinearSRecPat | GPeekSRecPat | GRepeatSRecPat
                            > "for" "(" GBindPat  ")" "{" ProcPat "}"
  syntax        UGSRecPat ::= UGSRec
                            > LinearSRecPat  | PeekSRecPat  | RepeatSRecPat
                            > "for" "(" BindPat   ")" "{" ProcPat "}"

  // Linear listen pattern
  syntax    LinearSRecPat ::= LinearSRec
                            > "for" "(" LbindPat  ")" "{" ProcPat "}"
  syntax   GLinearSRecPat ::= GLinearSRec
                            > "for" "(" GLbindPat ")" "{" ProcPat "}"
  syntax        GLbindPat ::= GLbind > LbindPat Guard
  syntax         LbindPat ::= Lbind
                            > NamePats "<-"  NamePat
                            | EmptyLbindPat
  syntax    EmptyLbindPat ::= EmptyLbind
                            >          "<-"  NamePat
  // Peek listen pattern
  syntax      PeekSRecPat ::= PeekSRec
                            > "for" "(" PbindPat  ")" "{" ProcPat "}"
  syntax     GPeekSRecPat ::= GPeekSRec
                            > "for" "(" GPbindPat ")" "{" ProcPat "}"
  syntax        GPbindPat ::= GPbind
                            > PbindPat Guard
  syntax         PbindPat ::= Pbind
                            > NamePats "<<-" NamePat
                            | EmptyPbindPat
  syntax    EmptyPbindPat ::= EmptyPbind
                            >          "<<-" NamePat
  // Repeated listen pattern
  syntax    RepeatSRecPat ::= RepeatSRec
                            > "for" "(" RbindPat  ")" "{" ProcPat "}"
  syntax   GRepeatSRecPat ::= GRepeatSRec
                            > "for" "(" GRbindPat ")" "{" ProcPat "}"
  syntax        GRbindPat ::= GRbind
                            > RbindPat Guard
  syntax         RbindPat ::= Rbind
                            > NamePats "<="  NamePat
                            | EmptyRbindPat
  syntax    EmptyRbindPat ::= EmptyRbind
                            >          "<="  NamePat

  syntax          BindPat ::= Bind
                            > LbindPat  | PbindPat  | RbindPat
  syntax         GBindPat ::= GBind
                            > GLbindPat | GPbindPat | GRbindPat
                            > BindPat Guard
  syntax       AnyBindPat ::= AnyBind
                            > BindPat | GBindPat

  // Multiple listen receive patterns
  syntax          MRecPat ::= MRec
                            > GMRecPat | UGMRecPat
  syntax         GMRecPat ::= GMRec
                            > GLinearMRecPat
                            | GPeekMRecPat
                            | GRepeatMRecPat
                            > "for" "(" GBindPats ")" "{" ProcPat "}"
  syntax        UGMRecPat ::= UGMRec
                            > LinearMRecPat
                            | PeekMRecPat
                            | RepeatMRecPat
                            > "for" "(" BindPats  ")" "{" ProcPat "}"
  // Linear
  syntax    LinearMRecPat ::= LinearMRec
                            > "for" "(" LbindPats  ")" "{" ProcPat "}"
  syntax   GLinearMRecPat ::= GLinearMRec
                            > "for" "(" GLbindPats ")" "{" ProcPat "}"
  syntax        LbindPats ::= Lbinds
                            > LbindPat "&" LbindPat
                            | LbindPat "&" LbindPats [right]
  // Peek
  syntax      PeekMRecPat ::= PeekMRec
                            > "for" "(" PbindPats  ")" "{" ProcPat "}"
  syntax     GPeekMRecPat ::= GPeekMRec
                            > "for" "(" GPbindPats ")" "{" ProcPat "}"
  syntax        PbindPats ::= Pbinds
                            > PbindPat "&" PbindPat
                            | PbindPat "&" PbindPats [right]
  // Repeated
  syntax    RepeatMRecPat ::= RepeatMRec
                            > "for" "(" RbindPats  ")" "{" ProcPat "}"
  syntax   GRepeatMRecPat ::= GRepeatMRec
                            > "for" "(" GRbindPats ")" "{" ProcPat "}"
  syntax        RbindPats ::= Rbinds
                            > RbindPat "&" RbindPat
                            | RbindPat "&" RbindPats [right]
  // General Binding Patterns
  syntax         BindPats ::= Binds
                            > LbindPats  | PbindPats  | RbindPats
                            > BindPat  "&" BindPat
                            | BindPat  "&" BindPats  [right]
  syntax        GBindPats ::= GBinds
                            > GLbindPats | GPbindPats | GRbindPats
                            > BindPats  Guard
  syntax       GLbindPats ::= GLbinds
                            > LbindPats Guard
  syntax       GPbindPats ::= GPbinds
                            > PbindPats Guard
  syntax       GRbindPats ::= GRbinds
                            > RbindPats Guard
  syntax      AnyBindPats ::= AnyBinds
                            > BindPats | GBindPats

// Send pattern
  syntax          SendPat ::= Send
                            > CSendPat | USendPat
  // Consumable -- ephmeral
  syntax         CSendPat ::= ConSend
                            > NamePat "!"  "("          ")"
                            | NamePat "!"  "(" ProcPats ")"
  // Unconsumable -- persistent
  syntax         USendPat ::= UnconSend
                            > NamePat "!!" "("          ")"
                            | NamePat "!!" "(" ProcPats ")"

// Eval pattern
  syntax          EvalPat ::= Eval
                            > "*" NamePat

// New pattern
  syntax           NewPat ::= New
                            > "new" VarDecs "in" "{" ProcPat "}"

// Matching patterns
  // Match pattern
  syntax      MatchingPat ::= Matching
                            > MatchPat | SelectPat
  syntax         MatchPat ::= Match
                            > "match" ProcPat "{" MCasePats "}"
  syntax         MCasePat ::= MatchCase
                            > "{" ProcPat "}" "|=>" ProcPat // match pattern and return pattern
  syntax        MCasePats ::= MatchCases
                            > MCasePat
                            > MCasePat MCasePats [right]
  // Select pattern
  syntax        SelectPat ::= Select
                            > "select" "{" BranchPats "}"
  syntax        BranchPat ::= Branch
                            > "{" LbindPat   "}" "|=>" ProcPat
                            | "{" LbindPats  "}" "|=>" ProcPat
                            | "{" GLbindPat  "}" "|=>" ProcPat
                            | "{" GLbindPats "}" "|=>" ProcPat
  // Branch patterns
  syntax       BranchPats ::= Branches
                            > BranchPat
                            > BranchPat BranchPats [right]
/*
// Variable reference pattern
  syntax        PatVarRef ::= VarRef
                            > NamePatVarRef | ProcPatVarRef
  syntax    NamePatVarRef ::= NameRef
                            > "=" "*" PatVar
  syntax    ProcPatVarRef ::= ProcRef
                            > "=" PatVar
*/

// Conditional pattern
  syntax          CondPat ::= Conditional
                            > IfThenPat | ElsePat
  syntax        IfThenPat ::= IfThen
                            > "if" "(" BExp ")" ProcPat [strict(1)]
  syntax          ElsePat ::= Else
                            > IfThenPat "else" ProcPat  [avoid]
// Pattern expression
  syntax           PatExp ::= PatNeg > PatAnd > PatOr
  // Pattern Negation
  syntax           PatNeg ::= "~" ProcPat
  // Pattern And
  syntax           PatAnd ::= ProcPat "/\\" ProcPat [right]
  // Pattern Or
  syntax            PatOr ::= ProcPat "\\/" ProcPat [right]

// Contract pattern
  syntax      ContractPat ::= Contract
                            > "contract" NamePat "(" NamePats ")" "=" "{" ProcPat "}"
                            | "contract" NamePat "("          ")" "=" "{" ProcPat "}"

  syntax    InvocationPat ::= Invocation
                            > NamePat "(" NamePats ")"
                            | NamePat "("          ")"

// Collection pattern
  syntax    CollectionPat ::= Collection > ListPat | MapPat | SetPat | TuplePat

  // RhoList pattern
     // match each Pat/Proc at head and bind remainder as RhoList to ProcVar?
  syntax          ListPat ::= RhoList
                            > ListRemPat
                            | "[" ProcPats "]" // match List pattern
                            | "EmptyListPat"
  syntax       ListRemPat ::= "[" ProcPats "..." ProcVar "]"
                            | "[" ProcPats "..." EvalVar "]"

  // RhoMap pattern
    // match each Pat/Proc and bind remainder as RhoMap to ProcVar
  syntax           MapPat ::= RhoMap
                            > MapRemPat
                            | "{" RhoKVPats "}"
                            | "EmptyMapPat"
  syntax        MapRemPat ::= "{" RhoKVPats "..." ProcVar "}"
                            | "{" RhoKVPats "..." EvalVar "}"

    // RhoKVPat
  syntax         RhoKVPat ::= RhoKVPair
                            > ProcPat ":" ProcPat
  syntax        RhoKVPats ::= RhoKVPairs
                            > RhoKVPat
                            > RhoKVPat "," RhoKVPats  [right]
  // RhoSet pattern
    // match each Pat/Proc and bind remainder as RhoSet to ProcVar
  syntax           SetPat ::= RhoSet
                            > SetRemPat
                            | "Set(" ProcPats ")"
                            | "EmptySetPat"
  syntax        SetRemPat ::= "Set(" ProcPats "..." ProcVar ")"
                            | "Set(" ProcPats "..." EvalVar ")"

  // RhoTuple pattern
  syntax         TuplePat ::= RhoTuple
                            > "(" ProcPats ",)"
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
*/
// Method pattern
  syntax        MethodPat ::= MethodProc
                            > ProcPat MethodArgPats
  syntax    MethodArgPats ::= MethodAndArgs
                            > "." Method "(" ProcPats ")"

// Bundle pattern
  syntax        BundlePat ::= Bundle
                            > BundleReadPat | BundleWritePat | BundleEquivPat | BundleBothPat
  syntax    BundleReadPat ::= "bundle-{" ProcPat "}" // read-only
  syntax   BundleWritePat ::= "bundle+{" ProcPat "}" // write-only
  syntax   BundleEquivPat ::= "bundle0{" ProcPat "}" // only for equivalence checking
  syntax    BundleBothPat ::=  "bundle{" ProcPat "}" // both read/write

// For empty content & args
  syntax             Name ::= EmptyName // listen for empty message
  syntax        EmptyName ::= "EmptyN"  // listening for empty messages
  syntax             Proc ::= EmptyProc
  syntax        EmptyProc ::= "EmptyP"  // for sending empty message; empty Proc arg

// For DeBruijn indices & alpha/structural equivalence
  syntax              Var ::= BoundName
  syntax        BoundName ::=  "N(" Int ")" | "N(" Int "," Int ")"

  syntax          ProcVar ::= BoundProc
  syntax        BoundProc ::=  "X(" Int ")" | "X(" Int "," Int ")"

// For hiding variables in substitutions
  syntax              Sub ::= "sub"
  syntax          ProcVar ::= Sub

// For simultaneous substitutions -- not needed if indices are assigned first
  syntax        Var ::= IndexNVar
  syntax  IndexNVar ::= "nvar(" Int ")"
  syntax    ProcVar ::= IndexPVar
  syntax  IndexPVar ::= "pvar(" Int ")"

// For AUXFUN, MREC, STRUCT & CONFIG
  syntax     IndexedBinds ::= Int ";" Lbind | Int ";" LbindPat
                            | Int ";" Pbind | Int ";" PbindPat
                            | Int ";" Rbind | Int ";" RbindPat
  syntax     IndexedNames ::= Int ";" Name  | Int ";" NamePat
                            | Int ";" Names | Int ";" NamePats
  syntax     IndexedProcs ::= Int ";" Proc  | Int ";" ProcPat
                            | Int ";" Procs | Int ";" ProcPats
  syntax       IndexedSet ::= Int ";" Set

  // Representation in tuplespace
    // SendSetElem : num ; data ; stype
  syntax      SendSetElem ::= Int ";" NamePats ";" Int [klabel(sendSetElem)]
    // NamespaceElem : channel/data types ; TypeSendSet
  syntax    NameSpaceElem ::= NamePats ";" Set      [klabel(nameSpaceElem)]
    // RecSetElem : enum ; enumBindSet ; cont ; rtype
  syntax       RecSetElem ::= Int ";" Set  ";" Proc ";" BExp ";" Int [klabel(recSetElem)]
  syntax      BindSetElem ::= Int ";" Name ";" NamePats              [klabel(bindSetElem)]

// For K
  syntax            KItem ::= Name | Names | NamePat | NamePats
                            | Proc | Procs | ProcPat | ProcPats
                            | RhoKVPair  | RhoKVPairs
                            | Invocation | InvocationPat // for contract map

endmodule

// SEMANTICS MODULE
module GRHO
  import ALPHA
  import AUXFUN
  import CONFIG
  import MATCH
  import METHOD
  import MREC
  import NAMEVAR
  import SUB
  import STRUCT

// final output type of functions & strict operations
  syntax KResult ::= Ground | SimplePat | Proc | List | Map | Set
                   | Lbind | Lbinds | LbindPat | LbindPats

// Arithmetic & Boolean expressions are evaluated as soon as they can be
  // Arithmetic expressions -- evaluated immediately
  rule A:IntExp + B:IntExp => #eval(A) +Int #eval(B)                            [anywhere]
  rule A:IntExp - B:IntExp => #eval(A) -Int #eval(B)                            [anywhere]
  rule A:IntExp * B:IntExp => #eval(A) *Int #eval(B)                            [anywhere]
  rule A:IntExp / B:IntExp => #eval(A) /Int #eval(B) requires #eval(B) =/=Int 0 [anywhere]
  rule A:IntExp % B:IntExp => #eval(A) %Int #eval(B) requires #eval(B) =/=Int 0 [anywhere]
  rule - A:IntExp =>   0 -Int #eval(A)                                          [anywhere]

  // List & String expressions -- evaluated immediately
    // concatenation
  rule A:RhoList ++ B:ConcatRhoList => #concat(A;#eval(B)) [anywhere, structural]
  rule A:String  ++ B:StringOnlyExp => #concat(A;#eval(B)) [anywhere, structural]
    // interpolation: "begin${key}rest" %% { ..., key:value ,... } => "begin" ++ "value" ++ "rest"
  rule A:StringOnlyExp %% B:InterpMaps => #interpolate(#eval(A);B)
       requires #FV(B) ==K .Set [anywhere, structural]
    // invocation of a list contract
  rule <k> A:Name ( B:Names ) ++ E:ConcatRhoList => #concat(#sub(B;C;D);#eval(E)) ... </k>
       <contracts> A( C:NamePats ) |-> D:RhoList _:Map </contracts>
       requires #match(B;C)
  rule <k> A:Name ( B:Names ) ++ E:ConcatRhoList => #concat(#sub(B;C;D);#eval(E)) ... </k>
       <contracts> A( C:Names    ) |-> D:RhoList _:Map </contracts>
       requires #match(B;C)
  rule <k> A:Name ( ) ++ E:ConcatRhoList => #concat(D;#eval(E)) ... </k>
       <contracts> A( ) |-> D:RhoList _:Map </contracts>

  // Boolean expressions
  rule A:IntExp   <= B:IntExp  => #eval(A)   <=Int #eval(B) [anywhere, structural]
  rule A:IntExp   <  B:IntExp  => #eval(A)    <Int #eval(B) [anywhere, structural]
  rule A:IntExp   >= B:IntExp  => #eval(A)   >=Int #eval(B) [anywhere, structural]
  rule A:IntExp   >  B:IntExp  => #eval(A)    >Int #eval(B) [anywhere, structural]
  rule A:BoolExp and B:BoolExp => #eval(A) andBool #eval(B) [anywhere, structural]
  rule A:BoolExp  or B:BoolExp => #eval(A)  orBool #eval(B) [anywhere, structural]
  rule not A:BoolExp =>  notBool  #eval(A)                  [anywhere, structural]
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
  rule A:Proc == B:Proc => #structEq(A;B)
       requires notBool (isGround(A) andBool isGround(B)) [structural]
  rule A:Proc != B:Proc => notBool #structEq(A;B)
       requires notBool (isGround(A) andBool isGround(B)) [structural]
  rule A:Name == B:Name => #nameEq(A;B)                   [structural]
  rule A:Name != B:Name => notBool #nameEq(A;B)           [structural]

// Conditionals
  rule if ( B:BoolExp ) A:Proc => A   requires #eval(B)                   [anywhere, structural]
  rule if ( B:BoolExp ) _:Proc => Nil requires notBool #eval(B)           [anywhere, structural]
  rule if ( B:BoolExp ) A:Proc else _:Proc => A requires #eval(B)         [anywhere, structural]
  rule if ( B:BoolExp ) _:Proc else A:Proc => A requires notBool #eval(B) [anywhere, structural]

// Matching
  // Match
    // matches binop desugars into #match function call
  rule A:Proc    matches B:Proc      => #match(A;B)                                 [structural]
  rule A:Proc    matches B:ProcPat   => #match(A;B) requires notBool isSimplePat(B) [structural]
  rule A:Ground  matches B:SimplePat => #match(A;B)                       [anywhere, structural]
  rule A:ProcPat matches B:ProcPat   => #match(A;B)                                 [structural]
  rule match A:Proc { { B:Proc    } |=> C:Proc } => #if #match(A;B) #then #sub(A;B;C) #else Nil #fi
  rule match A:Proc { { B:ProcPat } |=> C:Proc } => #if #match(A;B) #then #sub(A;B;C) #else Nil #fi
  rule match A:Proc { { B:Proc    } |=> C:Proc D:MatchCases } => #if #match(A;B) #then #sub(A;B;C) #else match {A}{D} #fi
  rule match A:Proc { { B:ProcPat } |=> C:Proc D:MatchCases } => #if #match(A;B) #then #sub(A;B;C) #else match {A}{D} #fi

// New Operator Semantics
  rule <k> A:New => #subNew(L;#indecs(A);#newproc(A)) ...</k>
       <nextLoc> L => L +Int size(#DV(A)) </nextLoc>

// Bundles -- for object capabilities
//  rule A:Send => . requires isBundleMinus(#chan(A)) [structural]
//  rule A:SRec => . requires isBundlePlus( #chan(A)) [structural] // TODO: MRec

// Contract
  // a contract rewrites to a persistent receive and is added to the contracts store
  rule <k> contract A:Name ( B:NamePats ) = { C:Proc } => for(B <= A){C} ...</k>
       <contracts> M:Map => updateMap( M , A(B) |-> C ) </contracts>
  rule <k> contract A:Name ( B:Names    ) = { C:Proc } => for(B <= A){C} ...</k>
       <contracts> M:Map => updateMap( M , A(B) |-> C ) </contracts>
  rule <k> contract A:Name (            ) = { C:Proc } => for(  <= A){C} ...</k>
       <contracts> M:Map => updateMap( M , A( ) |-> C ) </contracts>

  // a contract invocation looks for the invoked contract in the contracts map and
  // then executes the body of the contract with the given values
  rule <k> A:Name ( B:Names ) => #sub(B;C;D) ...</k>
       <contracts> A( C:NamePats ) |-> D:Proc _:Map </contracts>
       requires #match(B;C)
  rule <k> A:Name ( B:Names ) => #sub(B;C;D) ...</k>
       <contracts> A( C:Names    ) |-> D:Proc _:Map </contracts>
       requires #match(B;C)
  rule <k> A:Name ( ) => D ...</k>
       <contracts> A( ) |-> D:Proc _:Map </contracts>

// Par Operator Semantics - concurrent execution of processes
  // each nonPar Proc in a top-level Par gets its own <task/> cell
  rule <task> <k> A:Proc | B:Proc => B ...</k> </task>
       (.Bag => <task> <k> A </k> </task>)
       requires notBool isPar(A)

//-------------------------------
//--- Send Operator Semantics ---
//-------------------------------
  rule (<task> <k> A:Send </k> </task> => .Bag) // dissolve send in <activity/> and spawn <send/>
       // (.Bag => <send> A </send>)
        <sends> S:Set => #addNameSpace(#sendSet(A);S) </sends>

//----------------------------------
//--- Receive Operator Semantics ---
//----------------------------------
  rule (<task> <k> A:Receive </k> </task> => .Bag) // dissolve Rec in <activity/> and spawn <rec/>
       // (.Bag => <receive> A </receive>)
        <receives> S:Set => #addRec(#recSet(A);S) </receives>

//---------------------------------
//--- Select operator semantics ---
//---------------------------------
  rule
  (<task> <k> select { B:Branches } </k> </task> => .Bag)
  (.Bag => <sum> <branches> <branch> B </branch> </branches> </sum>)
  rule <branch> A:Branch B:Branches </branch>
    => <branch> A </branch> <branch> B </branch>

//------------------------------
//--- Let Operator Semantics ---
//------------------------------
// LetBind
  rule let A:ProcVar <- B:Proc in { C:Proc } => #sub(B;A;C)
// SimLetBinds
  rule let A:SimLetBinds in { C:Proc } => #sub(#letproc(A);#letvar(A);C)
// SeqLetBinds
  rule let A:ProcVar <- B:Proc ; D:LetBind     in { C:Proc } => let D in { #sub(B;A;C) }
  rule let A:ProcVar <- B:Proc ; D:SeqLetBinds in { C:Proc } => let D in { #sub(B;A;C) }
// SeqSimLetBinds
//  rule let A:ProcVar <- B:Proc > D:SimLetBinds    in { C:Proc } => let D in { #sub(B;A;C) }
  rule let A:SeqLetBinds       > D:SimLetBinds    in { C:Proc } => let D in { let A in {C} }
  rule let A:SimLetBinds       > D:SimLetBinds    in { C:Proc } => let D in { #sub(#letproc(A);#letvar(A);C) }
//  rule let A:SimLetBinds       > D:LetBind        in { C:Proc } => let D in { #sub(#letproc(A);#letvar(A);C) }
  rule let A:SimLetBinds       > D:SeqLetBinds    in { C:Proc } => let D in { #sub(#letproc(A);#letvar(A);C) }
//  rule let A:ProcVar <- B:Proc > D:SeqSimLetBinds in { C:Proc } => let D in { #sub(B;A;C) }
  rule let A:SimLetBinds       > D:SeqSimLetBinds in { C:Proc } => let D in { #sub(#letproc(A);#letvar(A);C) }
  rule let A:SeqLetBinds       > D:SeqSimLetBinds in { C:Proc } => let D in { let A in {C} }

//-------------------
//--- COMM EVENTS ---
//-------------------
// Communication over name equivalent channels
// x!(Q) | for( z <- y ){P} => #sub(@Q;z;P) requires #nameEq(x;y)

  // rule
  // (<receive>  R:LinearSRec </receive> => .Bag)
  // (<send>     S:ConSend       </send> => .Bag)
  // (.Bag => <task> <k> #order(#sub(#quotes(#msg(S));#bvar(R);#cont(R))) </k> </task>)
  //  requires #matchComm(S;;#gbind(R)) [comm]
	//
  // rule
  // (<receive>  R:SRec      </receive> => .Bag)
  //  <send>     S:UnconSend    </send>
  // (.Bag => <task> <k> #order(#sub(#quotes(#msg(S));#bvar(R);#cont(R))) </k> </task>)
  //  requires #matchComm(S;;#gbind(R)) andBool notBool isRepeatSRec(R) [comm]
	//
  // rule
  // (<receive>  R:PeekSRec </receive> => .Bag)
  //  <send>     S:ConSend     </send>
  // (.Bag => <task> <k> #order(#sub(#quotes(#msg(S));#bvar(R);#cont(R))) </k> </task>)
  //  requires #matchComm(S;;#gbind(R)) [comm]
	//
  // rule
  //  <receive>  R:RepeatSRec </receive>
  // (<send>     S:ConSend       </send> => .Bag)
  // (.Bag => <task> <k> #order(#sub(#quotes(#msg(S));#bvar(R);#cont(R))) </k> </task>)
  //       requires #matchComm(S;;#gbind(R)) [comm]

// This would have an infinite trace...
//  rule  <receive> R:RepeatSRec </receive>
//        <send>    S:UnconSend     </send>
//        requires #matchComm(S;;#gbind(R))

// TODO: MRec comms
//  rule (<receive> R:MRec      </receive> => .Bag)
//        <sends>  (S => .Bag) ...</sends>
//       (.Bag => <task> <k> "wow" </k> </task>)
//        requires #matchComm(S;;#gbind(R)) [comm]

// Select comm -- all branches are dissolved and only one branch is used in comm
  // rule
  // (<sum> <branches>... <branch> { A:Lbind } |=> B:Proc </branch> ...</branches> </sum> => .Bag)
  // (<send> S:ConSend   </send> => .Bag)
  // (.Bag => <task> <k> #order(#sub(#quotes(#msg(S));#bvar(A);B)) </k> </task>)
  //  requires #matchComm(S;;A) [comm]
	//
  // rule
  // (<sum> <branches>... <branch> { A:Lbind } |=> B:Proc </branch> ...</branches> </sum> => .Bag)
  //  <send> S:UnconSend </send>
  // (.Bag => <task> <k> #order(#sub(#quotes(#msg(S));#bvar(A);B)) </k> </task>)
  //  requires #matchComm(S;;A) [comm]

//------------------
//--- Structural ---
//------------------
// Dissolve computationally meaningless activity
  rule <task> <k> .K  </k> </task> => .Bag  [structural]
  rule <task> <k> Nil </k> </task> => .Bag  [structural]
// Nil = unit of |
  rule Nil       | A:ProcPat => A [anywhere, structural]
  rule A:ProcPat | Nil       => A [anywhere, structural]
// @* = Id_NamePat & *@ = Id_ProcPat
  rule @ * A:NamePat => A [anywhere, structural]
  rule * @ A:ProcPat => A [anywhere, structural]
// ~~ = Id_ProcPat
  rule ~ ~ A:ProcPat => A [anywhere, structural]

/*
**V1.1 features**
// New & improved for-comprehension // TODO: other bind types?:
   for( ptrn 11 <- src 11 & ... & ptrn 1n <- src 1n ;
        ...
        ptrn m1 <- src m1 & ... & ptrn mn <- src mn ;
      ){P}
   where src ::= x | x?! | x!?( a 1 , ..., a k )

  // Sequential & Simultaneous Receives
  syntax      SeqRec ::= LinearSRec
                       > "for(" SeqLbinds    ")" "{" Proc "}"
  syntax      SimRec ::= LinearSRec
                       > "for(" SimLbinds    ")" "{" Proc "}"
  syntax   SeqSimRec ::= LinearSRec
                       > SeqRec
                       > "for(" SeqSimLbinds ")" "{" Proc "}"

  // Sequential & Simultaneous Binds
  syntax    SeqLbinds ::= Lbind ";" Lbind
                        > Lbind ";" SeqLbinds [right]
  syntax    SimLbinds ::= Lbind
                        > Lbind "&" SimLbinds [right]
  syntax SeqSimLbinds ::= Lbind
                        > SeqLbinds
                        | SimLbinds
                        > SeqLbinds ";" SeqSimLbinds [right]
                        | SimLbinds ";" SeqSimLbinds [right]

  syntax RecSendName ::= Name "?!"
  syntax SendRecName ::= Name "!?" "(" Procs ")"
  syntax        Name ::= RecSendName | SendRecName

  rule for(            <- A:Name ?!             ){ D:Proc } => new !E:Var in { for(          !E  <- A){ !E!( ) | D } } [structural]
  rule for( B:NamePats <- A:Name ?!             ){ D:Proc } => new !E:Var in { for(#append(B;!E) <- A){ !E!( ) | D } } [structural]
  rule for(            <- A:Name !? ( C:Procs ) ){ D:Proc } => new !E:Var in { A!(#append(C;*!E)) | for(   <- !E){D} } [structural]
  rule for( B:NamePats <- A:Name !? ( C:Procs ) ){ D:Proc } => new !E:Var in { A!(#append(C;*!E)) | for( B <- !E){D} } [structural]

// Sequential Output
  syntax   SeqOutput ::= SendRecName ";" Proc
                       | SendRecName "."
  rule A:Name !? (         ) ; C:Proc => new !D:Var in { A!( *!D )          | for(\_ <- !D){C} } [structural]
  rule A:Name !? ( B:Procs ) ; C:Proc => new !D:Var in { A!(#append(B;*!D)) | for(\_ <- !D){C} } [structural]
  rule A:Name !? (         ) . => A!?( );Nil [structural]
  rule A:Name !? ( B:Procs ) . => A!?(B);Nil [structural]
*/

endmodule
