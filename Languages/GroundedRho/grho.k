// RHO CALCULUS with Bool, Int, String ground terms and Rholang features in a polyadic style

require "domains.k"
require "AuxFun/auxfun.k"
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
                            | Var "," Vars [right]

//-------------
//--- NAMES ---
//-------------
  syntax             Name ::= Quote
                            | NameVar   // name variable
                            | EmptyName // listen for empty message
                            | NewUri
  syntax            Quote ::= "@" Proc
  syntax          NameVar ::= Var
  syntax        EmptyName ::= "EmptyN" // listening for empty messages
  syntax           NewUri ::= NameVar "(" Uri ")"

// Several Names
  syntax            Names ::= Name // "," Name
                            | Vars
                            | Name "," Names [right]

//-----------------
//--- PROCESSES ---
//-----------------
// TODO: Finalize precedence
  syntax             Proc ::= "{" Proc "}"    [bracket]
                            > New             // New name declaration(s)
                            > Ground          // Ground terms - Bool, Int, Nil, String, Uri
                            | Collection      // Data structures - RhoList, RhoMap, RhoSet, RhoTuple
                            | ProcVar         // Process variable
                            > VarRef          // Variable references - Name/Process variable shadowing
                            > Eval            // Evaluation
                            > MethodProc      // Methods
                            > Exp             // Arith, Bool, & String expressions
                            > Matching        // Match & Select
                            > Receive         // Receive messages
                            | Contract        // Contract
                            | Invocation      // Contract invocation
                            | Send            // Send messages
                            | Bundle          // Process bundle
                            > Conditional     // If...then(...else)
                            > Par             // Parallel composition

  syntax          ProcVar ::= "\\" Var

// Several Processes
  syntax            Procs ::= Proc // "," Proc
                            | Vars
                            | Proc "," Procs [right]

// Parallel composition
  // Par should be an order-normalized, multiset of processes
    // each nonPar Proc is put into it's own <k/> cell in GRHO 
    // implemented as a multiset in STRUCT
  syntax              Par ::= Proc "|" Proc  [right]

// Receives - homogeneous joins
  syntax          Receive ::= SRec | MRec

  // Single Receives
  syntax             SRec ::= GSRec  // Guarded single receieve
                            | UGSRec // Unguarded single receieve

  syntax           UGSRec ::= LinearSRec // Linear single receieve, unguarded
                            | PeekSRec   // Peek single receieve, unguarded
                            | RepeatSRec // Repeat single receieve, unguarded

  syntax            GSRec ::= GLinearSRec // Linear single receieve, guarded
                            | GPeekSRec   // Peek single receieve, guarded
                            | GRepeatSRec // Repeat single receieve, guarded

  syntax            Guard ::= "if" BExp

  // Linear Single
  syntax       LinearSRec ::= "for" "(" Lbind  ")" "{" Proc "}"
  syntax      GLinearSRec ::= "for" "(" GLbind ")" "{" Proc "}"
    // Linear Bind
  syntax            Lbind ::= NamePats "<-" Name
                            | NamePat  "<-" Name
                            | Names    "<-" Name
                            | Name     "<-" Name
                            |          "<-" Name
  // Peek Single
  syntax         PeekSRec ::= "for" "(" Pbind  ")" "{" Proc "}"
  syntax        GPeekSRec ::= "for" "(" GPbind ")" "{" Proc "}"
    // Peek Bind
  syntax            Pbind ::= NamePats "<!" Name
                            | NamePat  "<!" Name
                            | Names    "<!" Name
                            | Name     "<!" Name
                            |          "<!" Name
  // Repeat Single
  syntax  RepeatSRec ::= "for" "(" Rbind  ")" "{" Proc "}"
  syntax GRepeatSRec ::= "for" "(" GRbind ")" "{" Proc "}"
    // Repeat Bind
  syntax            Rbind ::= NamePats "<=" Name
                            | NamePat  "<=" Name
                            | Names    "<=" Name
                            | Name     "<=" Name
                            |          "<=" Name
  // Guarded Bind
  syntax           GLbind ::= Lbind Guard
  syntax           GPbind ::= Pbind Guard
  syntax           GRbind ::= Rbind Guard
 // Any Bind
  syntax             Bind ::= Lbind  | Pbind  | Rbind
  syntax            GBind ::= GLbind | GPbind | GRbind
  syntax          AnyBind ::= Bind   | GBind

  // Multiple Receive
  syntax             MRec ::= GMRec  // Guarded multi receive
                            | UGMRec // Unguarded multi receieve

  syntax           UGMRec ::= LinearMRec // Linear multi receieve, unguarded
                            | PeekMRec   // Peek multi receieve, unguarded
                            | RepeatMRec // Repeat multi receieve, unguarded

  syntax            GMRec ::= GLinearMRec // Linear multi receieve, guarded
                            | GPeekMRec   // Peek multi receieve, guarded
                            | GRepeatMRec // Repeat multi receieve, guarded
  // Linear
  syntax       LinearMRec ::= "for" "(" Lbinds  ")" "{" Proc "}"
  syntax      GLinearMRec ::= "for" "(" GLbinds ")" "{" Proc "}"
    // Linear Binds
  syntax           Lbinds ::= Lbind ";" Lbind
                            | Lbind ";" Lbinds [right]
  // Peek
  syntax         PeekMRec ::= "for" "(" Pbinds  ")" "{" Proc "}"
  syntax        GPeekMRec ::= "for" "(" GPbinds ")" "{" Proc "}"
    // Peek Binds
  syntax           Pbinds ::= Pbind ";" Pbind
                            | Pbind ";" Pbinds [right]
  // Repeated
  syntax       RepeatMRec ::= "for" "(" Rbinds  ")" "{" Proc "}"
  syntax      GRepeatMRec ::= "for" "(" GRbinds ")" "{" Proc "}"
    // Repeated Binds
  syntax           Rbinds ::= Rbind ";" Rbind
                            | Rbind ";" Rbinds [right]
  // Guarded Binds
  syntax          GLbinds ::= Lbinds Guard
  syntax          GPbinds ::= Pbinds Guard
  syntax          GRbinds ::= Rbinds Guard
  // Any Binds
  syntax            Binds ::= Lbinds  | Pbinds  | Rbinds
  syntax           GBinds ::= GLbinds | GPbinds | GRbinds
  syntax         AnyBinds ::= Binds   | GBinds

// Sends
  syntax             Send ::= ConSend | UnconSend
  // Consumable
  syntax          ConSend ::= Name "!"  "(" Procs ")"
                            | Name "!"  "(" Proc  ")"
                            | Name "!"  "(" ")"
  // Unconsumable
  syntax        UnconSend ::= Name "!!" "(" Procs ")"
                            | Name "!!" "(" Proc  ")"
                            | Name "!!" "(" ")"

// Eval
  syntax             Eval ::= "*" Name

// New - creates fresh unforgeable names
  syntax              New ::= "new" Names "in" "{" Proc "}"
                            | "new" Name  "in" "{" Proc "}"

// Matching
  syntax         Matching ::= Match | Select
  // Match
  syntax            Match ::= "match" "{" Proc "}" "{" MatchCases "}"
                            | "match" "{" Proc "}" "{" MatchCase  "}"

  syntax        MatchCase ::= "{" Proc    "}" "|=>" Proc
                            | "{" ProcPat "}" "|=>" Proc
  syntax       MatchCases ::= MatchCase
                            | MatchCase MatchCases
  // Select
  syntax           Select ::= "select" "{" Branches "}"
                            | "select" "{" Branch   "}"

  syntax           Branch ::= "{" Lbind  "}" "|=>" Proc
                            | "{" Lbinds "}" "|=>" Proc
  syntax         Branches ::= Branch
                            | Branch Branches

// Variable Reference - allows for shadowing
  syntax           VarRef ::= "=" "*" NameVar
                            | "=" ProcVar

// Conditional
  syntax      Conditional ::= IfThen | Else

  syntax           IfThen ::= "if" "(" BExp ")" Proc  [strict(1)]
  syntax             Else ::= IfThen "else" Proc

// Contract - syntactic sugar for persistent receive
  syntax         Contract ::= "contract" Name "(" NamePats ")" "=" "{" Proc "}"
                            | "contract" Name "(" NamePat  ")" "=" "{" Proc "}"
                            | "contract" Name "(" Names    ")" "=" "{" Proc "}"
                            | "contract" Name "(" Name     ")" "=" "{" Proc "}"
                            | "contract" Name "("          ")" "=" "{" Proc "}"

// Contract Invocation
  // keyword "invoke" added to disambiguate from NewUri
  syntax       Invocation ::= "invoke" Name "(" ProcPats ")"
                            | "invoke" Name "(" ProcPat  ")"
                            | "invoke" Name "(" Procs    ")"
                            | "invoke" Name "(" Proc     ")"
                            | "invoke" Name "(" ")"

// Collections - data structures
  syntax       Collection ::= RhoList | RhoMap | RhoSet | RhoTuple

  // Process lists
  syntax          RhoList ::= "[" Procs "]"
                            | "[" Proc  "]"
                            | "[" "]"

  // Process maps
  syntax           RhoMap ::= "{" RhoKVPairs "}"
                            | "{" RhoKVPair  "}"
                            | "{" "}"

  syntax        RhoKVPair ::= Proc ":" Proc
  syntax       RhoKVPairs ::= RhoKVPair
                            | RhoKVPair "," RhoKVPairs [right]

  // Process sets
  syntax           RhoSet ::= "Set(" Procs ")"
                            | "Set(" Proc  ")"
                            | "Set(" ")"

  // Process tuples
  syntax         RhoTuple ::= "(" Procs ",)"
                            | "(" Proc  ",)"

// Ground terms
  syntax           Ground ::= "Nil" // stopped process
                            | Bool | Int | String // built-in
                            | Unforgeable | Uri   // storage & OCap
  syntax      Unforgeable ::= "unforgeable(" Int ")"

  syntax              Uri ::= "`" NativeChan "`"
  syntax       NativeChan ::= NativeIO
// TODO: add other native channels
  syntax         NativeIO ::= "rho:io:stdout"
                            | "rho:io:stdoutAck"

// Expressions resolve to ground terms
  syntax              Exp ::= "{" Exp "}" [bracket]
                            | AExp
                            | StringExp
                            > BExp


// Arithmetic
  syntax         IntOrVar ::= Int | ProcVar | Eval
  syntax             AExp ::= "{" AExp "}" [bracket]
                            > IntOrVar
                            > "-" AExp       [strict]
                            > AExp "%" AExp  [strict(2)] // mod reduction
                            > AExp "*" AExp  [strict, right]
                            | AExp "/" AExp  [strict, right]
                            > AExp "+" AExp  [strict, right]
                            | AExp "-" AExp  [strict, right]

// String
  syntax      StringOrVar ::= String | ProcVar | Eval
  syntax        StringExp ::= "{" StringExp "}" [bracket]
                            > StringOrVar
                            | Concat  // string concatenation
                            | Interp  // string interpolation: "${key}rest" %% { key:value , ... } => "value" ++ "rest"

  syntax           Concat ::= StringOrVar ConcatExp
  syntax        ConcatExp ::= "++" StringOrVar
                            | "++" StringOrVar ConcatExp

  syntax           Interp ::= StringOrVar "%%" InterpMaps
  syntax       InterpMaps ::= RhoMap
                            | RhoMap "%%" InterpMaps

// Boolean
  syntax             BExp ::= "{" BExp "}"   [bracket]
                            > Bool                // boolean output
                            | ProcVar             // e.g. \x == @0!(1), not \x, etc.
                            | Eval                // e.g. *x == @0!(1), not *x, etc.
                            > AExp "<=" AExp      [seqstrict]
                            | AExp "<"  AExp      [seqstrict]
                            | AExp ">=" AExp      [seqstrict]
                            > AExp ">"  AExp      [seqstrict]
                            | Name "==" Name      // name equivalence
                            | Name "!=" Name      // [| A:Name != B:Name |] = not ( A == B )
                            | Proc "==" Proc      // structural equivalence
                            | Proc "!=" Proc      // [| A:Proc != B:Proc |] = not ( A == B )
                            > "not" BExp          [strict]
                            > BExp "and" BExp     [strict(1), right]
                            > BExp "or"  BExp     [strict(1), right]
                            > Proc "matches" Proc // [| P matches Q |] = match P { { Q |=> true } { P |=> false } }
                            | Proc "matches" ProcPat

// Bundles -- cannot be destructured with pattern-matching
  syntax           Bundle ::= "bundle+{" Proc "}" // write-only
                            | "bundle-{" Proc "}" // read-only
                            | "bundle0{" Proc "}" // neither read/write
                            |  "bundle{" Proc "}" // both read/write

// Methods
  syntax       MethodProc ::= Proc MethodAndArgs
  syntax    MethodAndArgs ::= "." Method "(" Procs ")"
                            | "." Method "(" Proc  ")"
                            | "." Method "(" ")"

  syntax           Method ::= "nth"          // nth element - list, string(?), tuple - Proc.nth( Int ) 
                            | "toByteArray"  // transform to bytearray - Data.toByteArray( )
                            | "hexToBytes"   // hex string -> bytes
                            | "union"        // map, set union - Map.union( Map ) , Set.union( Set )
                            | "diff"         // difference - map, set?
                            | "add"          // add - like single element concat? - list, map, set?
                            | "delete"       // delete element? - list, map, set
                            | "contains"     // contains predicate
                            | "get"          // get - get value corresponding to key - Map.get( Key )
                            | "getOrElse"    // getOrElse - get or side condition - Map.getOrElse( Key , SideCondition )
                            | "set"          // set - Map.set( Key , Value )
                            | "contains"     // contains predicate - list, map, set?
                            | "keys"         // set of keys of a map - map.keys( )
                            | "values"       // list of values of a map - map.values( )
                            | "size"         // number of elements in unordered structures - Map.size(), Set.size()
                            | "length"       // length of ordered data list/tuple - List.length() , Tuple.length()
                            | "slice"        // slice of list/string - List.slice(I1,I2) , String.slice(I1,I2)
                            | "iterate"      // semantics? - list and tuple? - args?
                            | "confine"      // semantics? - confine variables? - args?

// For empty content & args
  syntax             Proc ::= EmptyProc // sending empty message; empty Proc arg
  syntax        EmptyProc ::= "EmptyP"

//----------------
//--- Patterns ---
//----------------
// Concrete process, process with free variable[s], or process pattern
//  syntax        ProcOrPat ::= Proc | ProcPat

// Concrete name, name with free variable[s], or name pattern
//  syntax        NameOrPat ::= Name | NamePat

// WildCard
  syntax         WildCard ::= "\\_" // instead of _
// WildCards
  syntax        WildCards ::= WildCard
                            | WildCard "," WildCards [right]

// Name pattern
  syntax          NamePat ::= "{" NamePat "}" [bracket]
                            | WildCard
                            | QuotePat
                            | SimpleNamePat
//                            > Name
// Quote pattern
  syntax         QuotePat ::= "@" ProcPat

// Simple Name pattern
  syntax    SimpleNamePat ::=    "ConcreteName" | "FreeVarName" | "NameContext" 
                            |  "Name" | "Quote" | "NameVar"
                            | "ConcreteNamePat" | "FreeVarNamePat" // other 

// Name patterns
  // NamePats contain at least one WildCard, i.e. they cannot all be Names
  syntax         NamePats ::= NamePat // "," NamePat
//                            | Name    "," NamePat
//                            | NamePat "," Name
                            | Name    "," NamePats [right]
                            | NamePat "," Names    [right]
                            | NamePat "," NamePats [right]
                            | WildCards
//                            | Names

// Pattern -- TODO: precedence
  syntax          ProcPat ::= "{" ProcPat "}" [bracket]
                            > WildCard
                            > PatExp          // Pattern expression
                            > NewPat          // New pattern
                            | CollectionPat   // Collection pattern
                            | SimplePat       // simple types
                            > EvalPat         // Evaluation pattern
//                            > MethodPat       // Method pattern
//                            > ExpPat          // Arith, Bool, & String pattern
                            > MatchingPat     // Match & Select pattern
                            > RecPat          // Receive pattern
                            | ContractPat     // Contract pattern
//                            | InvocationPat   // Contract invocation pattern
                            | SendPat         // Send pattern
//                            | BundlePat       // Bundle pattern
                            > CondPat         // If...then(...else) pattern
                            > ParPat          // Par pattern
//                            > Proc

// Patterns
  // cannot be all Procs, i.e. contains at least one WildCard
  syntax         ProcPats ::= ProcPat //  "," ProcPat
//                            | ProcPat  "," Proc
//                            | Proc     "," ProcPat
                            | Proc     "," ProcPats [right]
                            | ProcPat  "," Procs    [right]
                            | ProcPat  "," ProcPats [right]
                            | WildCards
//                            | Procs

// Parallel composition pattern
  syntax           ParPat ::= ProcPat "|" Proc     [right]
                            | Proc    "|" ProcPat  [right]
                            | ProcPat "|" ProcPat  [right]
//                            | Par

// Receive Pattern
  syntax           RecPat ::= SRecPat | MRecPat
  // Single listen receive pattern
  syntax          SRecPat ::= LinearSRecPat
                            | PeekSRecPat
                            | RepeatSRecPat
                            | GSRecPat
//                            | SRec
  syntax         GSRecPat ::= GLinearSRecPat
                            | GPeekSRecPat
                            | GRepeatSRecPat
//                            | GSRec

  // Linear listen pattern
  syntax    LinearSRecPat ::= "for" "(" Lbind     ")" "{" ProcPat "}"
                            | "for" "(" LbindPat  ")" "{" ProcPat "}"
                            | "for" "(" LbindPat  ")" "{" Proc    "}"
//                            | LinearSRec
  syntax   GLinearSRecPat ::= "for" "(" GLbind    ")" "{" ProcPat "}"
                            | "for" "(" GLbindPat ")" "{" ProcPat "}"
                            | "for" "(" GLbindPat ")" "{" Proc    "}"
//                            | GLinearSRec
  syntax        GLbindPat ::= LbindPat Guard
  syntax         LbindPat ::= NamePats "<-" NamePat
                            | NamePat  "<-" NamePat
                            | Names    "<-" NamePat
                            | Name     "<-" NamePat
                            |          "<-" NamePat

  // Peek listen pattern
  syntax      PeekSRecPat ::= "for" "(" Pbind     ")" "{" ProcPat "}"
                            | "for" "(" PbindPat  ")" "{" ProcPat "}"
                            | "for" "(" PbindPat  ")" "{" Proc    "}"
//                            | PeekSRec
  syntax     GPeekSRecPat ::= "for" "(" GPbind    ")" "{" ProcPat "}"
                            | "for" "(" GPbindPat ")" "{" ProcPat "}"
                            | "for" "(" GPbindPat ")" "{" Proc    "}"
//                            | GPeekSRec
  syntax        GPbindPat ::= PbindPat Guard
  syntax         PbindPat ::= NamePats "<!" NamePat
                            | NamePat  "<!" NamePat
                            | Names    "<!" NamePat
                            | Name     "<!" NamePat
                            |          "<!" NamePat
  // Repeated listen pattern
  syntax    RepeatSRecPat ::= "for" "(" Rbind     ")" "{" ProcPat "}"
                            | "for" "(" RbindPat  ")" "{" ProcPat "}"
                            | "for" "(" RbindPat  ")" "{" Proc    "}"
//                            | RepeatSRec
  syntax   GRepeatSRecPat ::= "for" "(" GRbind    ")" "{" ProcPat "}"
                            | "for" "(" GRbindPat ")" "{" ProcPat "}"
                            | "for" "(" GRbindPat ")" "{" Proc    "}"
//                            | GRepeatSRec
  syntax        GRbindPat ::= RbindPat Guard
  syntax         RbindPat ::= NamePats "<=" NamePat
                            | NamePat  "<=" NamePat
                            | Names    "<=" NamePat
                            | Name     "<=" NamePat
                            |          "<=" NamePat

  syntax          BindPat ::= LbindPat  | PbindPat  | RbindPat
  syntax         GBindPat ::= GLbindPat | GPbindPat | GRbindPat
  syntax       AnyBindPat ::= BindPat   | GBindPat

  // Multiple listen receive patterns
  syntax          MRecPat ::= LinearMRecPat
                            | PeekMRecPat
                            | RepeatMRecPat
                            | GMRecPat
  syntax         GMRecPat ::= GLinearMRecPat
                            | GPeekMRecPat
                            | GRepeatMRecPat
  // Linear
  syntax    LinearMRecPat ::= "for" "(" Lbinds     ")" "{" ProcPat "}"
                            | "for" "(" LbindPats  ")" "{" ProcPat "}"
                            | "for" "(" LbindPats  ")" "{" Proc    "}"
//                            | LinearMRec
  syntax   GLinearMRecPat ::= "for" "(" GLbinds    ")" "{" ProcPat "}"
                            | "for" "(" GLbindPats ")" "{" ProcPat "}"
                            | "for" "(" GLbindPats ")" "{" Proc    "}"
//                            | GLinearMRec
  syntax        LbindPats ::= Lbind    ";" LbindPat
                            | LbindPat ";" Lbind
                            | LbindPat ";" LbindPat
                            | Lbind    ";" LbindPats [right]
                            | LbindPat ";" Lbinds    [right]
                            | LbindPat ";" LbindPats [right]
  // Peek
  syntax      PeekMRecPat ::= "for" "(" Pbinds     ")" "{" ProcPat "}"
                            | "for" "(" PbindPats  ")" "{" ProcPat "}"
                            | "for" "(" PbindPats  ")" "{" Proc    "}"
  syntax     GPeekMRecPat ::= "for" "(" GPbinds    ")" "{" ProcPat "}"
                            | "for" "(" GPbindPats ")" "{" ProcPat "}"
                            | "for" "(" GPbindPats ")" "{" Proc    "}"
  syntax        PbindPats ::= Pbind    ";" PbindPat
                            | PbindPat ";" Pbind
                            | PbindPat ";" PbindPat
                            | Pbind    ";" PbindPats [right]
                            | PbindPat ";" Pbinds    [right]
                            | PbindPat ";" PbindPats [right]
  // Repeated
  syntax    RepeatMRecPat ::= "for" "(" Rbinds     ")" "{" ProcPat "}"
                            | "for" "(" RbindPats  ")" "{" ProcPat "}"
                            | "for" "(" RbindPats  ")" "{" Proc    "}"
  syntax   GRepeatMRecPat ::= "for" "(" GRbinds    ")" "{" ProcPat "}"
                            | "for" "(" GRbindPats ")" "{" ProcPat "}"
                            | "for" "(" GRbindPats ")" "{" Proc    "}"
  syntax        RbindPats ::= Rbind    ";" RbindPat
                            | RbindPat ";" Rbind
                            | RbindPat ";" RbindPat
                            | Rbind    ";" RbindPats [right]
                            | RbindPat ";" Rbinds    [right]
                            | RbindPat ";" RbindPats [right]

  syntax         BindPats ::= LbindPats  | PbindPats  | RbindPats
  syntax        GBindPats ::= GLbindPats | GPbindPats | GRbindPats
  syntax       GLbindPats ::= LbindPats Guard
  syntax       GPbindPats ::= PbindPats Guard
  syntax       GRbindPats ::= RbindPats Guard
  syntax      AnyBindPats ::= BindPats | GBindPats

// Send Pattern
  syntax          SendPat ::= CSendPat | USendPat
  // Consumable send pattern
  syntax         CSendPat ::= NamePat "!"  "("          ")"
                            | NamePat "!"  "(" Proc     ")"
                            | NamePat "!"  "(" Procs    ")"
                            | NamePat "!"  "(" ProcPat  ")"
                            | NamePat "!"  "(" ProcPats ")"
                            |    Name "!"  "(" ProcPat  ")"
                            |    Name "!"  "(" ProcPats ")"
  // Unconsumable send pattern
  syntax         USendPat ::= NamePat "!!" "("          ")"
                            | NamePat "!!" "(" Proc     ")"
                            | NamePat "!!" "(" Procs    ")"
                            | NamePat "!!" "(" ProcPat  ")"
                            | NamePat "!!" "(" ProcPats ")"
                            |    Name "!!" "(" ProcPat  ")"
                            |    Name "!!" "(" ProcPats ")"
// Eval pattern -- Q: does this cover anything less than ProcPat + *NameVar
  syntax          EvalPat ::= "*" NamePat

// New pattern
  syntax           NewPat ::= "new" Names "in" "{" ProcPat "}"
                            | "new" Name  "in" "{" ProcPat "}"

// Matching pattern
  // Match pattern
  syntax      MatchingPat ::= MatchPat | SelectPat

  syntax         MatchPat ::= "match" "{" Proc    "}" "{" MCasePat   "}"
                            | "match" "{" ProcPat "}" "{" MatchCase  "}"
                            | "match" "{" ProcPat "}" "{" MCasePat   "}"
                            | "match" "{" Proc    "}" "{" MCasePats  "}"
                            | "match" "{" ProcPat "}" "{" MatchCases "}"
                            | "match" "{" ProcPat "}" "{" MCasePats  "}"


  syntax         MCasePat ::= "{" ProcPat "}" "|=>" ProcPat // match pattern and return pattern
                            | "{" Proc    "}" "|=>" ProcPat // match process and return pattern
  // MCasePats has at least one pattern-returning MCasePat so there are no collisions with MatchCases
  syntax        MCasePats ::= MCasePat  // MCasePat
//                            | MatchCase MCasePat
                            | MCasePat  MatchCases
                            | MatchCase MCasePats
                            | MCasePat  MCasePats

  // Select pattern
  syntax        SelectPat ::= "select" "{" BranchPat  "}"
                            | "select" "{" BranchPats "}"

  syntax        BranchPat ::= "{" Lbind     "}" "|=>" ProcPat
                            | "{" Lbinds    "}" "|=>" ProcPat
                            | "{" LbindPat  "}" "|=>" Proc
                            | "{" LbindPats "}" "|=>" Proc
                            | "{" LbindPat  "}" "|=>" ProcPat
                            | "{" LbindPats "}" "|=>" ProcPat
  // BranchPats has at least one pattern-returning BrachPat so there are no collisions with Branches
  syntax       BranchPats ::= BranchPat // BranchPat
//                            | Branch    BranchPat
//                            | BranchPat Branch
                            | Branch    BranchPats
                            | BranchPat BranchPats

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
  syntax           PatAnd ::= Proc    "/\\" Proc
                            | Proc    "/\\" ProcPat
                            | ProcPat "/\\" Proc
                            | ProcPat "/\\" ProcPat
                            | Proc    "/\\" PatAnd [right]
                            | ProcPat "/\\" PatAnd [right]
  // Pattern Or
  syntax            PatOr ::= Proc    "\\/" Proc
                            | Proc    "\\/" ProcPat
                            | ProcPat "\\/" Proc
                            | ProcPat "\\/" ProcPat
                            | Proc    "\\/" PatOr  [right]
                            | ProcPat "\\/" PatOr  [right]

// Simple pattern
  syntax        SimplePat ::= "Bool" | "Int" | "String"
                            | "List" | "Map" | "Set" | "Tuple" | "Unforgeable" | "Uri"
                            | "ConcreteProc" | "FreeVarProc" | "ProcContext"
                            | "Proc" | "Ground" | "Par" | "Send" | "Receive" // other Proc constructors
                            | "ConcreteProcPat" | "FreeVarProcPat" //other ProcPat constructors

// Contract pattern
  syntax      ContractPat ::= "contract" NamePat "(" NamePats ")" "=" "{" ProcPat "}"
                            | "contract" NamePat "(" NamePats ")" "=" "{" Proc    "}"
                            | "contract" NamePat "(" Names    ")" "=" "{" ProcPat "}"
                            | "contract" NamePat "(" Names    ")" "=" "{" Proc    "}"
                            | "contract" NamePat "("          ")" "=" "{" ProcPat "}"
                            | "contract" NamePat "("          ")" "=" "{" Proc    "}"
                            | "contract" Name    "(" NamePats ")" "=" "{" ProcPat "}"
                            | "contract" Name    "(" Names    ")" "=" "{" ProcPat "}"
                            | "contract" Name    "("          ")" "=" "{" ProcPat "}"
//                            | "contract" Name    "(" Name     ")" "=" "{" ProcPat "}"
//                            | "contract" Name    "(" NamePat  ")" "=" "{" ProcPat "}"
//                            | "contract" NamePat "(" NamePat  ")" "=" "{" Proc    "}"
//                            | "contract" NamePat "(" Name     ")" "=" "{" Proc    "}"
//                            | "contract" NamePat "(" NamePat  ")" "=" "{" ProcPat "}"
//                            | "contract" NamePat "(" Name     ")" "=" "{" ProcPat "}"

/*
// TODO: Patternize?
// Contract Invocation
  syntax    InvocationPat ::= "invoke" NamePat "(" ProcPats ")"
                            | "invoke" NamePat "(" Procs    ")"
                            | "invoke" Name    "(" ProcPats ")"
                            | "invoke" NamePat "(" ")"
*/
// Collection pattern -- TODO: MapPat & SetPat
  syntax    CollectionPat ::= ListPat | /*MapPat | SetPat |*/ TuplePat

  // RhoList pattern -- bind Procs to ProcVar???
  syntax          ListPat ::= "[" ProcPats "..." ProcVar "]" // match each Pat and bind remainder as RhoList to ProcVar
                            | "[" ProcPat  "..." ProcVar "]" // match Pat and bind remainder as RhoList to ProcVar
                            | "[" Procs    "..." ProcVar "]" // match each Proc and bind remainder as RhoList to ProcVar
                            | "[" Proc     "..." ProcVar "]" // match Proc and bind remainder as RhoList to ProcVar
                            | "[" ProcPat  "]" // match List pattern
                            | "[" ProcPats "]" // match List pattern

  // RhoMap pattern -- TODO: bind RhoKVPairs to ProcVar???
  syntax           MapPat ::= "{" ProcPats "..." ProcVar "}" // match each Pat and bind remainder as RhoMap to ProcVar
                            | "{" ProcPat  "..." ProcVar "}" // match Pat and bind remainder as RhoMap to ProcVar
                            | "{" Procs    "..." ProcVar "}" // match each Proc and bind remainder as RhoMap to ProcVar
                            | "{" Proc     "..." ProcVar "}" // match Proc and bind remainder as RhoMap to ProcVar
                            | "{" RhoKVPairPats "}"
                            | "{" RhoKVPairPat  "}"
    // RhoKVPairPat
  syntax     RhoKVPairPat ::= Proc    ":" ProcPat
                            | ProcPat ":" Proc
                            | ProcPat ":" ProcPat
  syntax    RhoKVPairPats ::= RhoKVPairPat
                            | RhoKVPair    "," RhoKVPairPats
                            | RhoKVPairPat "," RhoKVPairs
                            | RhoKVPairPat "," RhoKVPairPats

  // RhoSet pattern -- bind Procs to ProcVar???
  syntax           SetPat ::= "Set(" ProcPats "..." ProcVar ")" // match each Pat and bind remainder as RhoSet to ProcVar
                            | "Set(" ProcPat  "..." ProcVar ")" // match Pat and bind remainder as RhoSet to ProcVar
                            | "Set(" Procs    "..." ProcVar ")" // match each Proc and bind remainder as RhoSet to ProcVar
                            | "Set(" Proc     "..." ProcVar ")" // match Proc and bind remainder as RhoSet to ProcVar
                            | "Set(" ProcPats ")"
                            | "Set(" ProcPat  ")"

  // RhoTuple pattern
  syntax         TuplePat ::= "(" ProcPats ",)"
                            | "(" ProcPat  ",)"

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
  syntax          MethPat ::= Proc    NEMethArgPats
                            | ProcPat MethodAndArgs
                            | ProcPat MethArgPats
  syntax    NEMethArgPats ::= "." Method "(" ProcPats ")"
                            | "." Method "(" ProcPat  ")"
  syntax      MethArgPats ::= NEMethArgPats
                            | "." Method "(" ")"
*/

// 
  syntax           Bool ::=    "#isConcreteName(" K ")" [function] // #FV( Name    ) ==K .Set
                          | "#isConcreteNamePat(" K ")" [function] // #FV( NamePat ) ==K .Set
                          |    "#isConcreteProc(" K ")" [function] // #FV( Proc    ) ==K .Set
                          | "#isConcreteProcPat(" K ")" [function] // #FV( ProcPat ) ==K .Set
                          |     "#isProcContext(" K ")" [function] // size(#PV( Proc )) ==Int 1 andBool size(#NV( Proc )) ==Int 0
                          |     "#isNameContext(" K ")" [function] // size(#PV( Proc )) ==Int 0 andBool size(#NV( Proc )) ==Int 1

// For De Bruijn indices & alpha/structural equivalence
  syntax             Name ::= BoundName
  syntax        BoundName ::= "boundN(" Int ")"
  syntax        BoundName ::= "boundN(" Int "," Int ")"

  syntax             Proc ::= BoundProc
  syntax        BoundProc ::= "boundP(" Int ")"
  syntax        BoundProc ::= "boundP(" Int "," Int ")"

  syntax             AExp ::= BoundProc // for substitution of variables in AExps
  syntax             BExp ::= BoundProc // for substitution of variables in BExps

// For substitution
  syntax              Sub ::= "sub"
  syntax             Proc ::= Sub

// Built-ins are processes too
  syntax             Proc ::= List | Map | Set

// For K
  syntax            KItem ::= Name | Names | Proc | Procs | RhoKVPair

endmodule

// SEMANTICS MODULE
module GRHO
  import AUXFUN
  import MATCH
  import NAMEVAR
  import SUB
  import ALPHA
  import STRUCT

//---------------------
//--- CONFIGURATION ---
//---------------------
  configuration
    <T color="purple">                                  //
      <activity color="red">                            //**activity threads**
        <task color="green" multiplicity="*">           // collection of concurrent tasks
//        <k> Error: FreeVars! ~> $PGM:Proc </k>        // Free variable program execution guard (part of type system)
          <k> $PGM:Proc </k>                            // programs and computations are process-based
        </task>                                         //
      </activity>                                       //**tuplespace**
      <tuplespace color="blue">                         // stores sends and receives
        <sends>                                         //**sends**
          <send color="cyan" multiplicity="*">          //
            <schan> .K </schan>                         // sending channel (many messages on same channel)
            <msg>   .K   </msg>                         // sent message
            <arity> .K </arity>                         // number of messages - for arity matching
            <stype> .K </stype>                         // 0 for single send (consumed), 1 for persistent send (not consumed)
          </send>                                       //
        </sends>                                        //
        <receives>                                      //
          <rec color="yellow" multiplicity="*">         //
            <rchan> .K </rchan>                         // receiving channel (many messages on same channel)
            <bvars> .K </bvars>                         // binding varible(s) in continuation
            <bnum>  .K  </bnum>                         // number of bindings
            <rtype> .K </rtype>                         // 0 for single listen (consumed), 1 for persistent listen (not consumed), 2 for peek
            <guard> .K </guard>                         // input guard
            <cont>  .K  </cont>                         // continuation
          </rec>                                        //
        </receives>                                     //
      </tuplespace>                                     //
      <nextLoc color="gray"> 0 </nextLoc>               //
      <original color="pink">                           //
        $PGM                                            // parsed original program
      </original>                                       //
      <OGfreevar color="pink">                          //
        FV($PGM)                                        // set of kind free variables of original program
      </OGfreevar>                                      //
      <OGdeBruijn color="pink">                         //
        #deBruijn($PGM)                                 // De Bruijn indexed original program
      </OGdeBruijn>                                     //
    </T>                                                //

// TODO: This is only needed for strict operations
  syntax KResult ::= Ground | Proc | List | Map | Set   // final output type of strict operations

// Free variable execution guard
//  syntax KItem ::= "Error: Free Variables!"
// Remove free variable error guard if program is closed
//  rule <k> (Error: FreeVars! ~> P:Proc) => P </k>
//       <free> .Set </free>

// Arithmetic & Boolean expressions are evaluated as soon as they can be
  // Arithmetic expressions -- evaluated immediately
  rule I:Int + J:Int => I +Int J                     [anywhere, structural] // addition
  rule I:Int - J:Int => I -Int J                     [anywhere, structural] // subtraction
  rule I:Int * J:Int => I *Int J                     [anywhere, structural] // multiplication
  rule I:Int / J:Int => I /Int J requires J =/=Int 0 [anywhere, structural] // division
  rule I:Int % J:Int => I %Int J requires J =/=Int 0 [anywhere, structural] // modular reduction
  rule - I:Int => 0 -Int I                           [anywhere, structural] // negation

  // String expressions -- evaluated immediately
    // concatenation
  rule S:String ++ T:String             => S +String T   [anywhere, structural]
  rule S:String ++ T:String U:ConcatExp => S +String T U [anywhere, structural]
    // interpolation: "begin${key}rest" %% { ..., key:value ,... } => "begin" ++ "value" ++ "rest"
  rule S:String %% R:RhoMap                 => #interpolate(S;R) [anywhere, structural]
  rule S:String %% R:RhoMap %% T:InterpMaps => #interpolate(S;R) %% T [anywhere, structural]

  // Boolean expressions
  rule I1:Int <= I2:Int => I1 <=Int I2 [anywhere, structural]
  rule I1:Int <  I2:Int => I1  <Int I2 [anywhere, structural]
  rule I1:Int >= I2:Int => I1 >=Int I2 [anywhere, structural]
  rule I1:Int >  I2:Int => I1  >Int I2 [anywhere, structural]
  rule not B:Bool => notBool B         [anywhere, structural]
    // short-circuited semantics
  rule true  and B:Bool => B     [anywhere, structural]
  rule false and _:Bool => false [anywhere, structural]
  rule true  or  _:Bool => true  [anywhere, structural]
  rule false or  B:Bool => B     [anywhere, structural]

// Structural Equivalence
  // Syntactic equality of Ground terms -- checked immediately
  rule A:Ground == B:Ground => A ==K  B [anywhere, structural]
  rule A:Ground != B:Ground => A =/=K B [anywhere, structural]
  // if only one term is Ground, we wait for the other -- e.g. in *x == true, we must wait on a value for x before computing
  // if both terms are not Ground, check structural equivalence immediately
  rule P:Proc == Q:Proc => #structEq(P;Q) requires notBool (isGround(P) orBool isGround(Q))         [anywhere, structural]
  rule P:Proc != Q:Proc => notBool #structEq(P;Q) requires notBool (isGround(P) orBool isGround(Q)) [anywhere, structural]
  rule M:Name == N:Name => #nameEq(M;N)         [anywhere, structural]
  rule M:Name != N:Name => notBool #nameEq(M;N) [anywhere, structural]

// Conditionals -- short-circuited
  rule if ( true  ) P:Proc => P              [structural]
  rule if ( false ) _:Proc => Nil            [structural]
  rule if ( true  ) P:Proc else _:Proc => P  [structural]
  rule if ( false ) _:Proc else Q:Proc => Q  [structural]

// Matching
  // Match
    // "matches" binop desugars into "match" statement
  rule P:Proc matches Q:Proc    => #match(P;Q) [structural]
  rule P:Proc matches Q:ProcPat => #match(P;Q) [structural]
  rule match { P:Proc } { { Q:Proc    } |=> R:Proc } => #if #match(P;Q) #then #sub(P;Q;R) #else Nil #fi
  rule match { P:Proc } { { Q:ProcPat } |=> R:Proc } => #if #match(P;Q) #then #sub(P;Q;R) #else Nil #fi
  rule match { P:Proc } { { Q:Proc    } |=> R:Proc M:MatchCase  } => #if #match(P;Q) #then #sub(P;Q;R) #else match {P}{M} #fi
  rule match { P:Proc } { { Q:ProcPat } |=> R:Proc M:MatchCase  } => #if #match(P;Q) #then #sub(P;Q;R) #else match {P}{M} #fi
  rule match { P:Proc } { { Q:Proc    } |=> R:Proc M:MatchCases } => #if #match(P;Q) #then #sub(P;Q;R) #else match {P}{M} #fi
  rule match { P:Proc } { { Q:ProcPat } |=> R:Proc M:MatchCases } => #if #match(P;Q) #then #sub(P;Q;R) #else match {P}{M} #fi

  // Select
  // select works with a single send or does it have access to all sends in the tuplespace???
//  rule select { { L:Lbind    } |=> Q:Proc } => 
//  rule select { { L:LbindPat } |=> Q:Proc } => 

// New Operator Semantics
  rule <k> new M:NameVar in { P:Proc } => #sub(@unforgeable(L);M;P) ...</k>
       <nextLoc> L => L +Int 1 </nextLoc>
  // TODO: special channel map needed for Uri?
  rule <k> new M:NameVar ( _:Uri ) in { P:Proc } => #sub(@unforgeable(L);M;P) ...</k>
       <nextLoc> L => L +Int 1 </nextLoc>
  
  rule <k> new M:NameVar , N:Name  in { P:Proc } => new N in {#sub(@unforgeable(L);M;P)} ...</k>
       <nextLoc> L => L +Int 1 </nextLoc>
  rule <k> new M:NameVar ( _:Uri ) , N:Name  in { P:Proc } => new N in {#sub(@unforgeable(L);M;P)} ...</k>
       <nextLoc> L => L +Int 1 </nextLoc>
       
  rule <k> new M:NameVar , N:Names in { P:Proc } => new N in {#sub(@unforgeable(L);M;P)} ...</k>
       <nextLoc> L => L +Int 1 </nextLoc>
  rule <k> new M:NameVar ( _:Uri ) , N:Names in { P:Proc } => new N in {#sub(@unforgeable(L);M;P)} ...</k>
       <nextLoc> L => L +Int 1 </nextLoc>

// Syntactic sugar - contract desugars into unconsumable receive
  rule contract X:Name ( Y:Names ) = { P:Proc } => for( Y <= X ){ P }  [anywhere, structural]
//  rule contract X:Name ( Y:Name  ) = { P:Proc } => for( Y <= X ){ P }  [anywhere, structural]
  rule contract X:Name (         ) = { P:Proc } => for(   <= X ){ P }  [anywhere, structural]

// Par Operator Semantics - concurrent execution of processes
  rule <task>
         <k> P:Proc | Q:Proc => Q ...</k>
       </task>
       (.Bag => <task> <k> P </k> </task>)
       requires notBool isPar(P)

//-------------------------------
//--- Send Operator Semantics ---
//-------------------------------
  rule (<task> <k> S:Send </k> </task> => .Bag) // dissolve send in <activity/> and spawn <send/>
       (.Bag => <send>
                  <schan>   #chan(S) </schan>  // sending channel
                  <msg>      #msg(S)   </msg>  // sending message(s)
                  <arity> #msglen(S) </arity>  // number of messages
                  <stype>  #stype(S) </stype>  // send type
                </send>)

  rule (<task> <k> S:SendPat </k> </task> => .Bag) // dissolve send in <activity/> and spawn <send/>
       (.Bag => <send>
                  <schan>   #chan(S) </schan>  // sending channel
                  <msg>      #msg(S)   </msg>  // sending message(s)
                  <arity> #msglen(S) </arity>  // number of messages
                  <stype>  #stype(S) </stype>  // send type
                </send>)

//----------------------------------
//--- Receive Operator Semantics ---
//----------------------------------
  rule (<task> <k> R:SRec </k> </task> => .Bag) // dissolve Rec in <activity/> and spawn <rec/>
       (.Bag => <rec>
                  <rchan>  #chan(R) </rchan>  // receiving channel
                  <bvars>  #bvar(R) </bvars>  // variable(s) to be substituted in continuation
                  <bnum> #lislen(R)  </bnum>  // number of binding variables
                  <rtype> #rtype(R) </rtype>  // receive type
                  <guard> #guard(R) </guard>  // input guard - restricts acceptable inputs
                  <cont>   #cont(R)  </cont>  // continuation
                </rec>)

  rule (<task> <k> R:SRecPat </k> </task> => .Bag) // dissolve Rec in <activity/> and spawn <rec/>
       (.Bag => <rec>
                  <rchan>  #chan(R) </rchan>  // receiving channel/pattern
                  <bvars>  #bvar(R) </bvars>  // variables/patterns to be substituted in continuation
                  <bnum> #lislen(R)  </bnum>  // number of binding variables/patterns
                  <rtype> #rtype(R) </rtype>  // receive type
                  <guard> #guard(R) </guard>  // input guard - restricts acceptable inputs
                  <cont>   #cont(R)  </cont>  // continuation/pattern
                </rec>)

// Joins
  rule (<task> <k> R:MRec </k> </task> => .Bag)
       (.Bag => <rec>
                  <rchan>  #chan(R) </rchan>  // receiving channel
                  <bvars>  #bvar(R) </bvars>  // variable(s) to be substituted in continuation
                  <bnum> #lislen(R)  </bnum>  // number of variables to bind
                  <rtype> #rtype(R) </rtype>  // receive type
                  <cont>   #cont(R)  </cont>  // continuation
                  <guard> #guard(R) </guard>  // input guard - restricts acceptable inputs
                </rec>)

  rule (<task> <k> R:MRecPat </k> </task> => .Bag)
       (.Bag => <rec>
                  <rchan>  #chan(R) </rchan>  // receiving channel
                  <bvars>  #bvar(R) </bvars>  // variable(s) to be substituted in continuation
                  <bnum> #lislen(R)  </bnum>  // number of variables to bind
                  <rtype> #rtype(R) </rtype>  // receive type
                  <cont>   #cont(R)  </cont>  // continuation
                  <guard> #guard(R) </guard>  // input guard - restricts acceptable inputs
                </rec>)

//-------------------
//--- COMM EVENTS ---
//-------------------
// Communication over name equivalent channels
// x!(Q) | for( z <- y ){P} => #sub(@Q;z;P) requires #nameEq(x;y)

// Comm semantics
// Linear listen, linear send
  rule                                     //consume single send, single receive
  (<rec>                                   //consume single receive
     <rchan> X:Name  </rchan>              // channel X
     <bvars> Y:Name  </bvars>              // binding variable(s) Y
     <bnum>  N:Int    </bnum>              // number of names to bind
     <rtype> 0       </rtype>              // linear listen
     <guard> B:BExp  </guard>              // input guard
     <cont>  P:Proc   </cont>              // continuation P
   </rec> => .Bag)                         //
  (<send>                                  //consume single send
     <schan> Z:Name  </schan>              // channel Z
     <msg>   Q:Proc    </msg>              // message(s) Q
     <arity> N       </arity>              // number of messages matches number of names to bind
     <stype> 0       </stype>              // linear send
   </send> => .Bag)                        //
   (.Bag => <task> <k> #sub(@Q;Y;P) </k> </task>) 
   requires #subGuard(Q;Y;B)               // checks if input guard is satisfied
    andBool #nameEq(X;Z)                   // checks if channels are name equivalent
    andBool #match(@Q;Y) [comm]            // checks if sent messages match the variable being listened for

  rule                                     //consume single send, single receive
  (<rec>                                   //consume single receive
     <rchan> X:Name  </rchan>              // channel X
     <bvars> Y:NamePat  </bvars>           // binding variable(s) Y
     <bnum>  N:Int    </bnum>              // number of names to bind
     <rtype> 0       </rtype>              // linear listen
     <guard> B:BExp  </guard>              // input guard
     <cont>  P:Proc   </cont>              // continuation P
   </rec> => .Bag)                         //
  (<send>                                  //consume single send
     <schan> Z:Name  </schan>              // channel Z
     <msg>   Q:Proc    </msg>              // message(s) Q
     <arity> N       </arity>              // number of messages matches number of names to bind
     <stype> 0       </stype>              // linear send
   </send> => .Bag)                        //
   (.Bag => <task> <k> #sub(@Q;Y;P) </k> </task>) 
   requires #subGuard(Q;Y;B)               // checks if input guard is satisfied
    andBool #nameEq(X;Z)                   // checks if channels are name equivalent
    andBool #match(@Q;Y) [comm]            // checks if sent messages match the variable being listened for

  rule                                     //consume single send, single receive
  (<rec>                                   //consume single receive
     <rchan> X:Name  </rchan>              // channel X
     <bvars> Y:Names </bvars>              // binding variable(s) Y
     <bnum>  N:Int    </bnum>              // number of names to bind
     <rtype> 0       </rtype>              // linear listen
     <guard> B:BExp  </guard>              // input guard
     <cont>  P:Proc   </cont>              // continuation P
   </rec> => .Bag)                         //
  (<send>                                  //consume single send
     <schan> Z:Name  </schan>              // channel Z
     <msg>   Q:Procs   </msg>              // message(s) Q
     <arity> N       </arity>              // number of messages matches number of names to bind
     <stype> 0       </stype>              // linear send
   </send> => .Bag)                        //
   (.Bag => <task> <k> #sub(#quotes(Q);Y;P) </k> </task>)
   requires #subGuard(Q;Y;B)               // checks if input guard is satisfied
    andBool #nameEq(X;Z)                   // checks if channels are name equivalent
    andBool #match(#quotes(Q);Y)    [comm] // checks if sent messages match the variables being listened for

  rule                                     //consume single send, single receive
  (<rec>                                   //consume single receive
     <rchan> X:Name  </rchan>              // channel X
     <bvars> Y:NamePats </bvars>           // binding variable(s) Y
     <bnum>  N:Int    </bnum>              // number of names to bind
     <rtype> 0       </rtype>              // linear listen
     <guard> B:BExp  </guard>              // input guard
     <cont>  P:Proc   </cont>              // continuation P
   </rec> => .Bag)                         //
  (<send>                                  //consume single send
     <schan> Z:Name  </schan>              // channel Z
     <msg>   Q:Procs   </msg>              // message(s) Q
     <arity> N       </arity>              // number of messages matches number of names to bind
     <stype> 0       </stype>              // linear send
   </send> => .Bag)                        //
   (.Bag => <task> <k> #sub(#quotes(Q);Y;P) </k> </task>)
   requires #subGuard(Q;Y;B)               // checks if input guard is satisfied
    andBool #nameEq(X;Z)                   // checks if channels are name equivalent
    andBool #match(#quotes(Q);Y)    [comm] // checks if sent messages match the variables being listened for

// Persistent listen, linear send
  rule                                     //consume single send, keep persistent receive
   <rec>                                   //DON'T consume persistent receive
     <rchan> X:Name  </rchan>              // channel X
     <bvars> Y:Name  </bvars>              // binding variable(s) Y
     <bnum>  N:Int    </bnum>              // number of name(s) to bind
     <rtype> 1       </rtype>              // repeated listen
     <guard> B:BExp  </guard>              // input guard
     <cont>  P:Proc   </cont>              // continuation P
   </rec>                                  //
  (<send>                                  //consume single send
     <schan> Z:Name  </schan>              // channel Z
     <msg>   Q:Proc    </msg>              // message(s) Q
     <arity> N       </arity>              // number of messages matches number of names to bind
     <stype> 0       </stype>              // linear send
   </send> => .Bag)                        //
   (.Bag => <task> <k> #sub(@Q;Y;P) </k> </task>)
   requires #subGuard(Q;Y;B)               // checks if input guard is satisfied
    andBool #nameEq(X;Z)                   // checks if channels are name equivalent
    andBool #match(@Q;Y)    [comm]         // checks if sent messages match the variable being listened for

  rule                                     //consume single send, keep persistent receive
   <rec>                                   //DON'T consume persistent receive
     <rchan> X:Name  </rchan>              // channel X
     <bvars> Y:NamePat  </bvars>           // binding variable(s) Y
     <bnum>  N:Int    </bnum>              // number of name(s) to bind
     <rtype> 1       </rtype>              // repeated listen
     <guard> B:BExp  </guard>              // input guard
     <cont>  P:Proc   </cont>              // continuation P
   </rec>                                  //
  (<send>                                  //consume single send
     <schan> Z:Name  </schan>              // channel Z
     <msg>   Q:Proc    </msg>              // message(s) Q
     <arity> N       </arity>              // number of messages matches number of names to bind
     <stype> 0       </stype>              // linear send
   </send> => .Bag)                        //
   (.Bag => <task> <k> #sub(@Q;Y;P) </k> </task>)
   requires #subGuard(Q;Y;B)               // checks if input guard is satisfied
    andBool #nameEq(X;Z)                   // checks if channels are name equivalent
    andBool #match(@Q;Y)    [comm]         // checks if sent messages match the variable being listened for

  rule                                     //consume single send, keep persistent receive
   <rec>                                   //DON'T consume persistent receive
     <rchan> X:Name  </rchan>              // channel X
     <bvars> Y:Names </bvars>              // binding variable(s) Y
     <bnum>  N:Int    </bnum>              // number of name(s) to bind
     <rtype> 1       </rtype>              // repeated listen
     <guard> B:BExp  </guard>              // input guard
     <cont>  P:Proc   </cont>              // continuation P
   </rec>                                  //
  (<send>                                  //consume single send
     <schan> Z:Name  </schan>              // channel Z
     <msg>   Q:Procs   </msg>              // message(s) Q
     <arity> N       </arity>              // number of messages matches number of names to bind
     <stype> 0       </stype>              // linear send
   </send> => .Bag)                        //
   (.Bag => <task> <k> #sub(#quotes(Q);Y;P) </k> </task>)
   requires #subGuard(Q;Y;B)               // checks if input guard is satisfied
    andBool #nameEq(X;Z)                   // checks if channels are name equivalent
    andBool #match(#quotes(Q);Y)    [comm] // checks if sent messages match the variables being listened for

  rule                                     //consume single send, keep persistent receive
   <rec>                                   //DON'T consume persistent receive
     <rchan> X:Name  </rchan>              // channel X
     <bvars> Y:NamePats </bvars>           // binding variable(s) Y
     <bnum>  N:Int    </bnum>              // number of name(s) to bind
     <rtype> 1       </rtype>              // repeated listen
     <guard> B:BExp  </guard>              // input guard
     <cont>  P:Proc   </cont>              // continuation P
   </rec>                                  //
  (<send>                                  //consume single send
     <schan> Z:Name  </schan>              // channel Z
     <msg>   Q:Procs   </msg>              // message(s) Q
     <arity> N       </arity>              // number of messages matches number of names to bind
     <stype> 0       </stype>              // linear send
   </send> => .Bag)                        //
   (.Bag => <task> <k> #sub(#quotes(Q);Y;P) </k> </task>)
   requires #subGuard(Q;Y;B)               // checks if input guard is satisfied
    andBool #nameEq(X;Z)                   // checks if channels are name equivalent
    andBool #match(#quotes(Q);Y)    [comm] // checks if sent messages match the variables being listened for

// Linear listen, persistent send
  rule                                     //consume single receive and keep single receive
  (<rec>                                   //consume single receive
     <rchan> X:Name  </rchan>              // channel X
     <bvars> Y:Name  </bvars>              // binding variable(s) Y
     <bnum>  N:Int    </bnum>              // number of name(s) to bind
     <rtype> 0       </rtype>              // linear listen
     <guard> B:BExp  </guard>              // input guard
     <cont>  P:Proc   </cont>              // continuation
   </rec> => .Bag)                         //
   <send>                                  //DON'T consume persistent send
     <schan> Z:Name  </schan>              // channel Z
     <msg>   Q:Proc    </msg>              // message(s) Q
     <arity> N       </arity>              // number of messages matches number of names to bind
     <stype> 1       </stype>              // persistent send
   </send>                                 //
   (.Bag => <task> <k> #sub(@Q;Y;P) </k> </task>)
   requires #subGuard(Q;Y;B)               // checks if input guard is satisfied
    andBool #nameEq(X;Z)                   // checks if channels are name equivalent
    andBool #match(@Q;Y)    [comm]         // checks if sent messages match the variable being listened for

  rule                                     //consume single receive and keep single receive
  (<rec>                                   //consume single receive
     <rchan> X:Name  </rchan>              // channel X
     <bvars> Y:NamePat  </bvars>           // binding variable(s) Y
     <bnum>  N:Int    </bnum>              // number of name(s) to bind
     <rtype> 0       </rtype>              // linear listen
     <guard> B:BExp  </guard>              // input guard
     <cont>  P:Proc   </cont>              // continuation
   </rec> => .Bag)                         //
   <send>                                  //DON'T consume persistent send
     <schan> Z:Name  </schan>              // channel Z
     <msg>   Q:Proc    </msg>              // message(s) Q
     <arity> N       </arity>              // number of messages matches number of names to bind
     <stype> 1       </stype>              // persistent send
   </send>                                 //
   (.Bag => <task> <k> #sub(@Q;Y;P) </k> </task>)
   requires #subGuard(Q;Y;B)               // checks if input guard is satisfied
    andBool #nameEq(X;Z)                   // checks if channels are name equivalent
    andBool #match(@Q;Y)    [comm]         // checks if sent messages match the variable being listened for

  rule                                     //consume single receive and keep single receive
  (<rec>                                   //consume single receive
     <rchan> X:Name  </rchan>              // channel X
     <bvars> Y:Names </bvars>              // binding variable(s) Y
     <bnum>  N:Int    </bnum>              // number of name(s) to bind
     <rtype> 0       </rtype>              // linear listen
     <guard> B:BExp  </guard>              // input guard
     <cont>  P:Proc   </cont>              // continuation
   </rec> => .Bag)                         //
   <send>                                  //DON'T consume persistent send
     <schan> Z:Name  </schan>              // channel Z
     <msg>   Q:Procs   </msg>              // message(s) Q
     <arity> N       </arity>              // number of messages matches number of names to bind
     <stype> 1       </stype>              // persistent send
   </send>                                 //
   (.Bag => <task> <k> #sub(#quotes(Q);Y;P) </k> </task>)
   requires #subGuard(Q;Y;B)               // checks if input guard is satisfied
    andBool #nameEq(X;Z)                   // checks if channels are name equivalent
    andBool #match(#quotes(Q);Y)    [comm] // checks if sent messages match the variables being listened for

  rule                                     //consume single receive and keep single receive
  (<rec>                                   //consume single receive
     <rchan> X:Name  </rchan>              // channel X
     <bvars> Y:NamePats </bvars>           // binding variable(s) Y
     <bnum>  N:Int    </bnum>              // number of name(s) to bind
     <rtype> 0       </rtype>              // linear listen
     <guard> B:BExp  </guard>              // input guard
     <cont>  P:Proc   </cont>              // continuation
   </rec> => .Bag)                         //
   <send>                                  //DON'T consume persistent send
     <schan> Z:Name  </schan>              // channel Z
     <msg>   Q:Procs   </msg>              // message(s) Q
     <arity> N       </arity>              // number of messages matches number of names to bind
     <stype> 1       </stype>              // persistent send
   </send>                                 //
   (.Bag => <task> <k> #sub(#quotes(Q);Y;P) </k> </task>)
   requires #subGuard(Q;Y;B)               // checks if input guard is satisfied
    andBool #nameEq(X;Z)                   // checks if channels are name equivalent
    andBool #match(#quotes(Q);Y)    [comm] // checks if sent messages match the variables being listened for

// Peek semantics
  rule                                     //consume single send, single receive
  (<rec>                                   //consume single receive
     <rchan> X:Name  </rchan>              // channel X
     <bvars> Y:Name  </bvars>              // binding variable(s) Y
     <bnum>  N:Int    </bnum>              // number of name(s) to bind
     <rtype> 2       </rtype>              // peek
     <guard> B:BExp  </guard>              // input guard
     <cont>  P:Proc   </cont>              // continuation P
   </rec> => .Bag)                         //
   <send>                                  //consume single send
     <schan> Z:Name  </schan>              // channel Z
     <msg>   Q:Proc    </msg>              // message(s) Q
     <arity> N       </arity>              // number of messages matches number of names to bind
     <stype> _       </stype>              // any kind of send
   </send>                                 // 
   (.Bag => <task> <k> #sub(@Q;Y;P) </k> </task>)
   requires #subGuard(Q;Y;B)               // checks if input guard is satisfied
    andBool #nameEq(X;Z)                   // checks if channels are name equivalent
    andBool #match(@Q;Y)    [comm]         // checks if sent messages match the variable being listened for

  rule                                     //consume single send, single receive
  (<rec>                                   //consume single receive
     <rchan> X:Name  </rchan>              // channel X
     <bvars> Y:NamePat  </bvars>           // binding variable(s) Y
     <bnum>  N:Int    </bnum>              // number of name(s) to bind
     <rtype> 2       </rtype>              // peek
     <guard> B:BExp  </guard>              // input guard
     <cont>  P:Proc   </cont>              // continuation P
   </rec> => .Bag)                         //
   <send>                                  //consume single send
     <schan> Z:Name  </schan>              // channel Z
     <msg>   Q:Proc    </msg>              // message(s) Q
     <arity> N       </arity>              // number of messages matches number of names to bind
     <stype> _       </stype>              // any kind of send
   </send>                                 // 
   (.Bag => <task> <k> #sub(@Q;Y;P) </k> </task>)
   requires #subGuard(Q;Y;B)               // checks if input guard is satisfied
    andBool #nameEq(X;Z)                   // checks if channels are name equivalent
    andBool #match(@Q;Y)    [comm]         // checks if sent messages match the variable being listened for

  rule                                     //consume single send, single receive
  (<rec>                                   //consume single receive
     <rchan> X:Name  </rchan>              // channel X
     <bvars> Y:Names </bvars>              // binding variable(s) Y
     <bnum>  N:Int    </bnum>              // number of name(s) to bind
     <rtype> 2       </rtype>              // peek
     <guard> B:BExp  </guard>              // input guard
     <cont>  P:Proc   </cont>              // continuation P
   </rec> => .Bag)                         //
   <send>                                  //consume single send
     <schan> Z:Name  </schan>              // channel Z
     <msg>   Q:Procs   </msg>              // message(s) Q
     <arity> N       </arity>              // number of messages matches number of names to bind
     <stype> _       </stype>              // any kind of send
   </send>                                 //
   (.Bag => <task> <k> #sub(#quotes(Q);Y;P) </k> </task>)
   requires #subGuard(Q;Y;B)               // checks if input guard is satisfied
    andBool #nameEq(X;Z)                   // checks if channels are name equivalent
    andBool #match(#quotes(Q);Y)    [comm] // checks if sent messages match the variables being listened for

  rule                                     //consume single send, single receive
  (<rec>                                   //consume single receive
     <rchan> X:Name  </rchan>              // channel X
     <bvars> Y:NamePats </bvars>           // binding variable(s) Y
     <bnum>  N:Int    </bnum>              // number of name(s) to bind
     <rtype> 2       </rtype>              // peek
     <guard> B:BExp  </guard>              // input guard
     <cont>  P:Proc   </cont>              // continuation P
   </rec> => .Bag)                         //
   <send>                                  //consume single send
     <schan> Z:Name  </schan>              // channel Z
     <msg>   Q:Procs   </msg>              // message(s) Q
     <arity> N       </arity>              // number of messages matches number of names to bind
     <stype> _       </stype>              // any kind of send
   </send>                                 //
   (.Bag => <task> <k> #sub(#quotes(Q);Y;P) </k> </task>)
   requires #subGuard(Q;Y;B)               // checks if input guard is satisfied
    andBool #nameEq(X;Z)                   // checks if channels are name equivalent
    andBool #match(#quotes(Q);Y)    [comm] // checks if sent messages match the variables being listened for

// Join semantics seem to be much more complicated than single listens...
// moved progress to join.k

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

// Complement Idempotency
  rule ~ ~ P:Proc    => P [anywhere, structural]
  rule ~ ~ P:ProcPat => P [anywhere, structural]

// Predicates for closed terms
  rule #isConcreteProc( A:Proc ) => #FV(A) ==K .Set
  rule #isConcreteProc( A:K    ) => false [owise]

  rule #isConcreteName( A:Name ) => #FV(A) ==K .Set
  rule #isConcreteName( A:K    ) => false [owise]

  rule #isConcreteNamePat( A:Name ) => #FV(A) ==K .Set
  rule #isConcreteNamePat( A:K    ) => false [owise]

  rule #isConcreteProcPat( A:Name ) => #FV(A) ==K .Set
  rule #isConcreteProcPat( A:K    ) => false [owise]

  rule #isProcContext( A:Proc ) => size(#PV(A)) ==Int size(#FV(A))
  rule #isProcContext( A:K    ) => false [owise]

  rule #isNameContext( A:Proc ) => size(#NV(A)) ==Int size(#FV(A))
  rule #isNameContext( A:K    ) => false [owise]

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
  rule ( P:Proc  ,) .length( ) => #length(P)
  rule ( P:Procs ,) .length( ) => #length(P)

  // mapkeys (maps)
  rule M:Map .keys( ) => keys( M )
  
  // nth (lists & tuples)
  rule L:List .nth( I:Int ) => L[I]

  rule ( ,):RhoTuple.nth( _ ) => Nil
  rule ( P:Proc ,).nth( I:Int ) => #if I ==Int 0 #then P #else Nil #fi
  rule ( P:Proc , Q:Proc  ,).nth( I:Int ) => #if I ==Int 0 #then P #else ( Q ,).nth( I -Int 1 ) #fi
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
  rule for( @ ( A:Proc  ) <! X:Name ){ P:Proc } => for( @A <! X ){ P }  [anywhere, structural]
  rule for( @ ( A:Proc  ) << X:Name ){ P:Proc } => for( @A << X ){ P }  [anywhere, structural]
  rule for( @ ( A:Procs ) <- X:Name ){ P:Proc } => for( #quotes(A) <- X ){ P } [anywhere, structural]
  rule for( @ ( A:Procs ) <= X:Name ){ P:Proc } => for( #quotes(A) <= X ){ P } [anywhere, structural]
  rule for( @ ( A:Procs ) <! X:Name ){ P:Proc } => for( #quotes(A) <! X ){ P } [anywhere, structural]
  rule for( @ ( A:Procs ) << X:Name ){ P:Proc } => for( #quotes(A) << X ){ P } [anywhere, structural]
*/
/*
TODO:
 - Matching (patterns & wildcard)
 - add TypedName ::= Name [":" Proc ]
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
   ⟦for( ptrn ← x?! ){P}⟧ = for( ( ptrn, r ) ← x ){ r!() | ⟦P⟧ }
   ⟦for( ptrn ← x!?( a 1 , ..., a k )){P}⟧ = new r in { x!( a 1 , ..., a k , *r) | for( ptrn ← r ){ ⟦P⟧ } }

 - Sequential output (pattern?):
   - x!?(v);P
    ⟦x!?(v);P⟧ = new r in x!((v,*r)) | for( _ ← r ){ ⟦P⟧ }
   - x!?(v).
    ⟦x!?(v).⟧ = x!?(v);0

  syntax  SeqOutput ::= Name "!?" "(" [Proc[s]] ")" ";" Proc
                      | Name "!?" "(" [Proc[s]] ")" "."
  rule A:Name !?(         ) ; C:Proc => new !X:NameVar in { A!(*!X)            | for( \_ <- !X ){ C } } [structural]
  rule A:Name !?( B:Proc  ) ; C:Proc => new !X:NameVar in { A!(B,*!X)          | for( \_ <- !X ){ C } } [structural]
  rule A:Name !?( B:Procs ) ; C:Proc => new !X:NameVar in { A!(#append(B,*!X)) | for( \_ <- !X ){ C } } [structural]

 - Sequential/nested let expressions: 
    let ptrn_1 ← v_1 ; ... ; ptrn_m ← v_m in P
   ⟦let ptrn_1 ← v_1 ; ... ; ptrn_n ← v_n in P ⟧ = new x in { x!(v_1) | for( ptrn_1 ← x_1 ){ ⟦let ptrn_2 ← v_2 ; ... ; ptrn_n ← v_n in P ⟧ } }

  syntax      LetBind ::= "let" Lbind
  syntax  SeqLetBinds ::= LetBind ";" LetBind
                        | LetBind ";" SeqLetBinds [right]
  syntax  SimLetBinds ::= LetBind "&" LetBind
                        | LetBind "&" SimLetBinds [right]
  syntax   SeqSimLets ::= LetBind     ";" SimLetBind
                        | LetBind     ";" SimLetBinds
                        | SimLetBind  ";" SeqLetBinds ....
                        | SimLetBinds ";" SimLetBinds
                        | SimLetBinds ";" SeqSimLets [right]
  syntax       LetExp ::= LetBind "in" Proc
                        | SeqLetBinds "in" Proc
                        | SimLetBinds "in" Proc
                        | SeqSimLets  "in" Proc
  syntax         Proc ::= LetExp

// Sequential Let Binds
  rule let A:Lbind in P:Proc => new !X:NameVar in { !X!(*#chan(A)) | for( #bvar(A) <- !X ){ P } }
  rule let A:Lbind ; let B:Lbind  in P:Proc => new !X:NameVar in { !X!(*#chan(A)) | for( #bvar(A) <- !X ){ let B in P } }
  rule let A:Lbind ; let B:Lbinds in P:Proc => new !X:NameVar in { !X!(*#chan(A)) | for( #bvar(A) <- !X ){ let B in P } }

 - Simultaneous let expressions: 
    let ptrn_1 ← v_1 & ... & ptrn_m ← v m in P
   ⟦let ptrn_1 ← v_1 & ... & ptrn_n ← v_n in P ⟧ = new x_1 , ... , x_n in { x_1 !(v_1) | ... | x_n!(v_n) | for( ptrn_1 ← x_1 & ... & ptrn_n ← x_n ){ ⟦P⟧ }

// Simultaneous Let Binds
  rule 

// Receive peek (Sneak?): 
  syntax Send ::= Name "??" "(" Proc[s] ")"
  "rule" X:Name ??( P:Proc[s] ) | for( Y:NamePats <? Z:Name ){ Q:Proc } | R:Proc => for(Y<?Z){Q} | #sub(@P;Y;Q)
*/
endmodule