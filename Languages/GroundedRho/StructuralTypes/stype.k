// Structural type system for Grounded RHO-CALCULUS
// Type is a structural binary tree

require "domains.k"
require "../Is-In/is-in.k"

module STYPE-SYNTAX
  import DOMAINS

//***************************************************
//*** Grounded Rho-Calculus with Process Patterns ***
//***************************************************

//-------------
//--- NAMES ---
//-------------

// Names
  syntax             Name ::= "{" Name "}"                                [bracket]
                            > "@" Proc                               [klabel(name)]  // @: Proc -----> Name
                            | Unforgeable                                            //  Unforgeable < Name
                            | "@" ProcVar "(" Uri ")"                                // @_(_): ProcVar x Uri ---> Name

// Unforgeable name
  syntax      Unforgeable ::= "unforgeable(" Int ")"                                 // unforgeable(_): Int ---> Name

// Name Patterns
  syntax          NamePat ::= "{" NamePat "}"                             [bracket]
                            > "@" ProcPat                         [klabel(namepat)]  // @: ProcPat ---> NamePat
                            | "WildName"                                             //      WildName < NamePat

// Name or Name Pattern
  syntax        NameOrPat ::= "{" NameOrPat "}"                           [bracket]
                            > Name                                                   //    Name < NameOrPat
                            | NamePat                                                // NamePat < NameOrPat

// Several Names
  syntax            Names ::= "{" Names "}"                               [bracket]
                            > Name "," Name                                          // _,_: Name  x Name ---> Names
                            | Name "," Names                                         // _,_: Names x Name ---> Names

// Several Name Patterns
  syntax         NamePats ::= "{" NamePats "}"                            [bracket]
                            > NamePat "," NamePat                                    // _,_: NamePat  x NamePat ---> NamePats
                            | NamePat "," NamePats                                   // _,_: NamePats x NamePat ---> NamePats

// Name or Name Pattern
  syntax       NameOrPats ::= "{" NameOrPats "}"                          [bracket]
                            > Names                                                  //    Names < NameOrPats
                            | NamePats                                               // NamePats < NameOrPats

//-----------------
//--- PROCESSES ---
//-----------------

// Process Variable
  syntax          ProcVar ::= Id                                                     // Id < ProcVar

// Processes
  syntax             Proc ::= "{" Proc "}"                                [bracket]  // {_}: Proc -> Proc
                            > New                                                    //        New < Proc
                            > "Nil"                                                  //        Nil < Proc
                            | Ground                                                 //     Ground < Proc
                            | Collection                                             // Collection < Proc
                            | ProcVar                                                //    ProcVar < Proc
                            > VarRef                                                 //     VarRef < Proc
                            > Eval                                                   //       Eval < Proc
                            > MethodProc                                             // MethodProc < Proc
                            > AExp                                                   //       AExp < Proc
                            > BExp                                                   //       BExp < Proc
                            > Match                                                  //      Match < Proc
                            > Send                                                   //       Send < Proc
                            | Contract                                               //   Contract < Proc
                            | Receive                                                //    Receive < Proc
                            | Bundle                                                 //     Bundle < Proc
                            > Conditional                                            //Conditional < Proc
                            > Par                                                    //        Par < Proc

// Par
  syntax              Par ::= Proc "|" Proc                                  [left]  // _|_: Proc x Proc ----------> Par

// Receive
  syntax          Receive ::= "for" "(" Bind  ")" "{" Proc "}"                       // for(_){_}: Bind  x Proc ---> Receive
                            | "for" "(" Binds ")" "{" Proc "}"                       // for(_){_}: Binds x Proc ---> Receive

  syntax             Bind ::= Lbind                                                  // Lbind < Bind, linear
                            | Pbind                                                  // Pbind < Bind, peek
                            | Rbind                                                  // Rbind < Bind, repeated

  syntax            Binds ::= Lbinds                                                 // Lbinds < Binds
                            | Pbinds                                                 // Pbinds < Binds
                            | Rbinds                                                 // Rbinds < Binds

  syntax      BindNamePat ::= Name                                                   //    Name < BindNamePat
                            | NamePat                                                // NamePat < BindNamePat

  syntax     BindNamePats ::= Names                                                  // 
                            | NamePats                                               // 

  syntax            Lbind ::= BindNamePat  "<-" Name                                 // _<-_: BindNamePat  x Name ---> Lbind 
                            | BindNamePats "<-" Name                                 // _<-_: BindNamePats x Name ---> Lbind

  syntax           Lbinds ::= Lbind ";" Lbind                                        // 2 linear binds
                            | Lbind ";" Lbinds                                       // N linear binds, N > 2


  syntax            Pbind ::= BindNamePat  "<!" Name                                 // _<!_: BindNamePat  x Name ---> Pbind 
                            | BindNamePats "<!" Name                                 // _<!_: BindNamePats x Name ---> Pbind

  syntax           Pbinds ::= Pbind ";" Pbind                                        // 2 peek binds
                            | Pbind ";" Pbinds                                       // N peek binds, N > 2


  syntax            Rbind ::= BindNamePat  "<=" Name                 [klabel(bind)]  // _<=_: BindNamePat  x Name ---> Rbind 
                            | BindNamePats "<=" Name                                 // _<=_: BindNamePats x Name ---> Rbind

  syntax           Rbinds ::= Rbind ";" Rbind                                        // 2 repeated binds
                            | Rbind ";" Rbinds                                       // N repeated binds, N > 2

// Send
  syntax             Send ::= Name "!"  RhoTuple                                     //  _!(_): Name x RhoTuple ------> Send
                            | Name "!!" RhoTuple                                     // _!!(_): Name x RhoTuple ------> Send

// Eval
  syntax             Eval ::= "*" Name                                               // *: Name ----------------------> Eval

// Ground terms
  syntax           Ground ::= Bool                                                   //   Bool < Ground
                            | Int                                                    //    Int < Ground
                            | String                                                 // String < Ground
                            | Uri                                                    //    Uri < Ground

  syntax              Uri ::= "uri(" String ")"                                      // uri(_): String ---> Uri

// Collections
  syntax       Collection ::= RhoList                                                // process list
                            | RhoMap                                                 // process map
                            | RhoSet                                                 // process set
                            | RhoTuple                                               // process tuple

// Process lists
  syntax          RhoList ::= "[" Proc  "]"                                          // single process list
                            | "[" Procs "]"                                          // N process list, N > 1

// Process maps
  syntax           RhoMap ::= "{" RhoKVPairs "}"                                     // process map

  syntax       RhoKVPairs ::= Proc ":" Proc                                          // single key-value pair
                            | Proc ":" Proc "," RhoKVPairs                           // N key-value pairs, N > 1

// Process sets
  syntax           RhoSet ::= "Set" "(" Proc  ")"                                    // single process set
                            | "Set" "(" Procs ")"                                    // N process set, N > 1

// Process tuples
  syntax         RhoTuple ::= "(" Proc           ")"               [klabel(tuple1)]  // 1-tuple
                            | "(" Proc "," Proc  ")"               [klabel(tuple2)]  // N-tuple, N > 1
                            | "(" Proc "," Procs ")"               [klabel(tuplen)]  // N-tuple, N > 1

// Bundles
  syntax           Bundle ::= "bundle+" "{" Proc "}"                                 // write-only bundle
                            | "bundle-" "{" Proc "}"                                 // read-only bundle
                            | "bundle0" "{" Proc "}"                                 // no bundle
                            | "bundle"  "{" Proc "}"                                 // read/write bundle

// New
  syntax              New ::= "new" Name  "in" "{" Proc "}"                [binder]  // 1 name declaration
                            | "new" Names "in" "{" Proc "}"                [binder]  // N > 1 name declarations

// Match
  syntax            Match ::= "match" Proc "{" MatchCase  "}"                        // 1 match case
                            | "match" Proc "{" MatchCases "}"                        // N match cases, N > 1

  syntax        MatchCase ::= ProcPat ":=>" Proc                                     // _:=>_: ProcPat x Proc ----------> MatchCase

  syntax       MatchCases ::= MatchCase MatchCase                                    // _ _: MatchCase x MatchCase -----> MatchCase
                            | MatchCase MatchCases                                   // _ _: MatchCase x MatchCases ----> MatchCases

// Methods
  syntax       MethodProc ::= Proc "." MethodAndArgs                                 // _._(_): Proc x MethodAndArgs ---> MethodProc

  syntax    MethodAndArgs ::= Method "(" MethodArgs ")"                              // _(_): Method x MethodArgs ------> MethodAndArgs

  syntax           Method ::= "nth"                                                  // nth element in list, tuple?, set
                            | "toByteArray"                                          // input? -> bytearray
                            | "hexToBytes"                                           // hex -> bytes
                            | "union"                                                // list?, map, set union
                            | "diff"                                                 // map, set difference?
                            | "add"                                                  // concat list?
                            | "delete"                                               // delete element from 
                            | "contains"                                             // contains predicate -> applied to what?
                            | "get"                                                  // get?
                            | "getOrElse"                                            // getOrElse?
                            | "set"                                                  // set?
                            | "keys"                                                 // return set of keys of a map
                            | "size"                                                 // number of elements in list, map, set, tuple
                            | "length"                                               // length of list, tuple - different from size?
                            | "slice"                                                // slice of list, map, or set
                            | "confine"                                              // still not in interpreter? semantics?

  syntax       MethodArgs ::= ""                                                     // 0 arguments
                            | Proc                                                   // 1 argument
                            | Procs                                                  // N arguments, N > 2

// Expressions
  syntax             AExp ::= "(" AExp ")"                                [bracket]  //     (_): AExp ------> AExp
                            > Int                                                    //    Int < AExp
                            | Eval                                                   //   Eval < AExp , for interesting message passing, e.g. for( y <- x ){ *y + 5 }
                            | String                                                 // String < AExp (S1 + S2 => S1 +String S2)
                            > AExp "*" AExp                                [strict]  // _*_: AExp x AExp ---> AExp
                            > AExp "+" AExp                                [strict]  // _+_: AExp x AExp ---> AExp
                            | AExp "-" AExp                                [strict]  // _-_: AExp x AExp ---> AExp

  syntax             BExp ::= "(" BExp ")"                                [bracket]  //  (_): BExp ----------> BExp
                            > Bool                                                   //   Bool < BExp
                            | Eval                                                   //   Eval < BExp
                            | String                                                 // String < BExp
                            | AExp  "<=" AExp                              [strict]  // _<=_: AExp x AExp ---> BExp
                            > "not" BExp                                   [strict]  // not_: BExp ----------> BExp
                            > BExp "and" BExp                              [strict]  //  and: BExp ----------> BExp
                            > BExp  "or" BExp                              [strict]  //   or: BExp ----------> BExp

// Conditional
  syntax      Conditional ::= IfThen                                                 // if ... then ...
                            | Else                                                   // if ... then ... else

  syntax           IfThen ::= "if" "(" BExp ")" "then" Proc             [strict(1)]  // if ... then ...
 
  syntax             Else ::= IfThen "else" Proc                                     // if ... then ... else ...

// Contract
  syntax         Contract ::= "contract" Name "(" BindNamePat  ")" "=" "{" Proc "}"  // syntactic sugar => for( BindNamePat  <= Name ){ Proc }
                            | "contract" Name "(" BindNamePats ")" "=" "{" Proc "}"  // syntactic sugar => for( BindNamePats <= Name ){ Proc }

// Variable Refernces - Makes it so we _don't_ shadow the variable referenced
  syntax           VarRef ::= "=:" ProcVar                                           //  =:_: ProcVar -------> VarRef

// Several Processes
  syntax            Procs ::= "{" Procs "}"                               [bracket]  // {_}: Procs ----------> Procs
                            > Proc "," Proc                                          // _,_: Proc x Proc  ---> Procs
                            | Proc "," Procs                                         // _,_: Proc x Procs ---> Procs

//------------------------
//--- Process Patterns ---
//------------------------

// Par Pattern
  syntax           ParPat ::= Proc    "|" ProcPat                            [left]  // _|_: Proc x ProcPat ---------> ParPat
                            | ProcPat "|" Proc                               [left]  // _|_: ProcPat x Proc ---------> ParPat
                            | ProcPat "|" ProcPat                            [left]  // _|_: ProcPat x ProcPat ------> ParPat

  syntax         ParOrPat ::= Par                                                    //     Par < ParOrPat
                            | ParPat                                                 //  ParPat < ParOrPat

// Receive Pattern
  syntax       ReceivePat ::= "for" "(" Bind  ")" "{" ProcPat "}"                    // for(_){_}: Bind  x ProcPat ---> ProcPat  // requires ProcPat[Name / BindNamePat] to be a process pattern?
                            | "for" "(" Binds ")" "{" ProcPat "}"                    // for(_){_}: Binds x ProcPat ---> ProcPat 

  syntax     ReceiveOrPat ::= Receive                                                //    Receive < ReciveOrPat
                            | ReceivePat                                             // ReceivePat < ReciveOrPat

// Send Pattern
  syntax          SendPat ::= Name    "!"  PatTuple                                  //  _!(_): Name    x PatTuple ---> SendPat
                            | NamePat "!"  RhoTuple                                  //  _!(_): NamePat x RhoTuple ---> SendPat
                            | NamePat "!"  PatTuple                                  //  _!(_): NamePat x PatTuple ---> SendPat
                            | Name    "!!" PatTuple                                  // _!!(_): Name    x PatTuple ---> SendPat
                            | NamePat "!!" RhoTuple                                  // _!!(_): NamePat x RhoTuple ---> SendPat
                            | NamePat "!!" PatTuple                                  // _!!(_): NamePat x PatTuple ---> SendPat

  syntax        SendOrPat ::= Send                                                   //    Send < SendOrPat
                            | SendPat                                                // SendPat < SendOrPat

// Eval Pattern
  syntax          EvalPat ::= "*" NamePat                                            // *: NamePat ----------------> EvalPat

  syntax        EvalOrPat ::= Eval                                                   //    Eval < EvalOrPat
                            | EvalPat                                                // EvalPat < EvalOrPat

// Process Pattern
  syntax          ProcPat ::= "{" ProcPat "}"                                        // {_}: ProcPat --------------> ProcPat
                            > NewPat                                                 //        NewPat < ProcPat
                            > "WildProc"                                             //      WildProc < ProcPat
                            | SimpleType                                             //     SimplType < ProcPat
                            | CollectionPat                                          // CollectionPat < ProcPat
                            > EvalPat                                                //       EvalPat < ProcPat
                            > MethodPat                                              //     MethodPat < ProcPat
                            > ContractPat                                            //   ContractPat < ProcPat
                            | ReceivePat                                             //    ReceivePat < ProcPat
                            | SendPat                                                //       SendPat < ProcPat
                            > ConditionalPat                                         //ConditionalPat < ProcPat
                            > ParPat                                                 //        ParPat < ProcPat
                            // Logical connectives
                            > "~" Proc                                               //   ~_: Proc ----------------> ProcPat
                            | "~" ProcPat                                            //   ~_: ProcPat -------------> ProcPat
                            > Proc    "/\\" Proc                                     // _/\_: Proc x Proc ---------> ProcPat
                            | Proc    "/\\" ProcPat                                  // _/\_: Proc x ProcPat ------> ProcPat
                            | ProcPat "/\\" Proc                                     // _/\_: ProcPat x Proc ------> ProcPat
                            | ProcPat "/\\" ProcPat                                  // _/\_: ProcPat x ProcPat ---> ProcPat
                            > Proc    "\\/" Proc                                     // _\/_: Proc x Proc ---------> ProcPat
                            | Proc    "\\/" ProcPat                                  // _\/_: Proc x ProcPat ------> ProcPat
                            | ProcPat "\\/" Proc                                     // _\/_: ProcPat x Proc ------> ProcPat
                            | ProcPat "\\/" ProcPat                                  // _\/_: ProcPat x ProcPat ---> ProcPat

// New Pattern
  syntax           NewPat ::= "new" Name  "in" "{" ProcPat "}"             [binder]  // 1 name declaration
                            | "new" Names "in" "{" ProcPat "}"             [binder]  // N > 1 name declarations

// Conditional Pattern
  syntax   ConditionalPat ::= IfThenPat                                              // if ... then ...
                            | ElsePat                                                // if ... then ... else

  syntax        IfThenPat ::= "if" "(" BExp ")" "then" ProcPat          [strict(1)]  // if ... then ...
 
  syntax          ElsePat ::= IfThenPat "else" ProcPat                               // if ... then ... else ...

// Collection Pattern
  syntax    CollectionPat ::= RhoListPat                                             //  RhoListPat < CollectionPat
                            | RhoMapPat                                              //   RhoMapPat < CollectionPat
                            | RhoSetPat                                              //   RhoSetPat < CollectionPat
                            | RhoTuplePat                                            // RhoTuplePat < CollectionPat
                            | PatTuple                                               //    PatTuple < CollectionPat

// List Pattern
  syntax       RhoListPat ::= "[" ProcPat "," "..." ProcVar "]"                      // [_,..._]: ProcPat x ProcVar ------> RhoListPat

// Map Pattern
  syntax         RhoKVPat ::= ProcPat ":" ProcPat                                    // _:_: ProcPat x ProcPat ----------------> RhoKVPat
                            | ProcPat ":" ProcPat "," RhoKVPat                       // _:_,_: ProcPat x ProcPat x RhoKVPat ---> RhoKVPat

  syntax        RhoMapPat ::= "{" RhoKVPat "," "..." ProcVar ":" ProcVar "}"         // {_,..._:_}: RhoKVPat x ProcVar x ProcVar ---> RhoMapPat

// Set Pattern
  syntax        RhoSetPat ::= "Set" "(" ProcPat "," "..." ProcVar ")"                // Set(_,..._): ProcPat x ProcVar ---> RhoSetPat

// TUple Pattern
  syntax      RhoTuplePat ::= "(" ProcPat "," "..." ProcVar ")"                      // (_,..._): ProcPat x ProcVar ---> RhoTuplePat

// Pattern Tuple
  syntax         PatTuple ::= "(" ProcPat              ")"           [klabel(pat1)]  // 1-tuple pattern
                            | "(" ProcPat "," ProcPat  ")"           [klabel(pat2)]  // 2-tuple pattern
                            | "(" ProcPat "," ProcPats ")"           [klabel(patn)]  // N-tuple pattern, N > 2

  syntax      ContractPat ::= "contract" Name "(" BindNamePat  ")" "=" "{" ProcPat "}"  // contract_(_)={_}: Name x BindNamePat  x ProcPat ---> ContractPat
                            | "contract" Name "(" BindNamePats ")" "=" "{" ProcPat "}"  // contract_(_)={_}: Name x BindNamePats x ProcPat ---> ContractPat

// Method Pattern
  syntax        MethodPat ::= ProcPat "." MethodAndArgs                              // _._: ProcPat x MethodAndArgs ---> MethodPat

// Several Process Patterns
  syntax         ProcPats ::= ProcPat "," ProcPat                                    // _,_: ProcPat  x ProcPat ---> ProcPats
                            | ProcPat "," ProcPats                                   // _,_: ProcPats x ProcPat ---> ProcPats

// Proc or ProcPat
  syntax        ProcOrPat ::= "{" ProcOrPat "}"                                      //      {_}: ProcOrPat -------> ProcOrPat
                            > Proc                                                   //    Proc < ProcOrPat
                            | ProcPat                                                // ProcPat < ProcOrPat

  syntax       ProcOrPats ::= Procs                                                  //              Procs < ProcOrPats
                            | ProcPats                                               //           ProcPats < ProcOrPats

// Name, NamePat, Proc, or ProcPat
  syntax            OrPat ::= "{" OrPat "}"                                          // {_}: OrPat ---> OrPat
                            > ProcOrPat                                              //     ProcOrPat < OrPat
                            | NameOrPat                                              //     NameOrPat < OrPat

// Names, NamePats, Procs, or ProcPats
  syntax           OrPats ::= ProcOrPats                                             //     ProcOrPats < OrPat
                            | NameOrPats                                             //     NameOrPats < OrPat

//******************************
//*** STRUCTURAL TYPE SYNTAX ***
//******************************
  syntax             Type ::= "#type(" ProcOrPat ")"                      [function] // #type(_): ProcOrPat -> Type
                            | "#type(" NameOrPat ")"                      [function] // #type(_): NameOrPat -> Type
                            | InitialType                                            //          InitialType < Type
                            | IntermediateType                                       //     IntermediateType < Type
                            | TerminalType                                           //         TerminalType < Type
                            | Bool

// Simple Types - types of ground terms
  syntax       SimpleType ::= "Bool"                                                 //        "Bool" < SimpleType
                            | "ByteArray"                                            //   "ByteArray" < SimpleType
                            | "Int"                                                  //         "Int" < SimpleType
                            | "List"                                                 //        "List" < SimpleType
                            | "Map"                                                  //         "Map" < SimpleType
                            | "Set"                                                  //         "Set" < SimpleType
                            | "String"                                               //      "String" < SimpleType
                            | "Tuple"                                                //       "Tuple" < SimpleType
                            | "Unforgeable"                                          // "Unforgeable" < SimpleType
                            | "Uri"                                                  //         "Uri" < SimpleType

// Typical input for type rewrites
  syntax  OrPatOrLeafType ::= "type[" OrPat        "]"                               // type[_]: OrPat -----------> OrPatOrLeafType
                            | "type[" OrPats       "]"                               // type[_]: OrPats ----------> OrPatOrLeafType
                            | "type[" Leaf         "]"                               // type[_]: Leaf ------------> OrPatOrLeafType

//  Initial type
  syntax      InitialType ::= OrPatOrLeafType                                        //           OrPatOrLeafType < InitialType
                            | "type[" Bind          "]"                              // type[_]: Bind ------------> InitialType
                            | "type[" Binds         "]"                              // type[_]: Binds -----------> InitialType
                            | "type[" BindNamePat   "]"                              // type[_]: BindNamePat -----> InitialType
                            | "type[" BindNamePats  "]"                              // type[_]: BindNamePat -----> InitialType
                            | "type[" IfThen        "]"                              // type[_]: IfThen ----------> InitialType
                            | "type[" IfThenPat     "]"                              // type[_]: IfThenPat -------> InitialType
                            | "type[" Else          "]"                              // type[_]: Else ------------> InitialType
                            | "type[" ElsePat       "]"                              // type[_]: ElsePat ---------> InitialType
                            | "type[" MatchCase     "]"                              // type[_]: MatchCase -------> InitialType
                            | "type[" MatchCases    "]"                              // type[_]: MatchCases ------> InitialType
                            | "type[" MethodArgs    "]"                              // type[_]: MethodArgs ------> InitialType
                            | "type[" MethodAndArgs "]"                              // type[_]: MethodAndArgs ---> InitialType
                            | "type[" RhoKVPairs    "]"                              // type[_]: RhoKVPairs ------> InitialType
                            | "type[" RhoKVPat      "]"                              // type[_]: RhoKVPat --------> InitialType

//  Intermediate type - type[_;;_;;_]: String x IntermediateType x IntermediateType ---> IntermediateType
  syntax IntermediateType ::= "type[" String ";;" IntermediateType ";;" IntermediateType "]"  [strict(2,3)]
                            | TerminalType                                           // TerminalType < IntermediateType
                            | InitialType                                            //  InitialType < IntermediateType

//  Terminal type - type[_;;_;;_]: String x TerminalType x TerminalType ---> TerminalType
  syntax     TerminalType ::= "type[" String ";;" TerminalType     ";;" TerminalType     "]"
                            | LeafType                                               // LeafType < TerminalType

// corresponds to the leaves in the structural binary tree - type[_;;_;;_]: String x Leaf x Leaf ---> LeafType
  syntax         LeafType ::= "type[" String ";;" Leaf             ";;" Leaf             "]"
                            | "type[" Truncate  "]"                                  // truncate

//--- toString function ---
  syntax           String ::= "toString(" OrPat ")"                                  // toString(_): OrPat ---> String
                            | "toString(" Type  ")"                                  // toString(_): Type ----> String

// Leaves
  syntax             Leaf ::= Ground                                                 //     Ground < Leaf
                            | ProcVar                                                //    ProcVar < Leaf
                            | Method                                                 //     Method < Leaf

  syntax         Truncate ::= "#truncate"

//----------------------
//--- Type Inclusion ---
//----------------------
// The type inclusion predicate
  syntax    Bool ::= Type "#isIn"   Type  [function]
                   | Type "#isin"   Type  [strict(1,2)]
                   |      "#isName" Type  [function]
                   |      "#isProc" Type  [function]
                   |      "#isPat"  Type  [function]

  syntax    Bool ::= ProcOrPat "#isIn" ProcOrPat
                   | NameOrPat "#isIn" NameOrPat
                   | Type      "#isIn" ProcOrPat
                   | Type      "#isIn" NameOrPat

// Name, Process, Pattern types for #isName, #isProc, #isPat predicates
  syntax    Type ::= "Name"
                   | "Process"
                   | "Pattern"

endmodule


module STYPE
  import STYPE-SYNTAX
  import IS-IN

  configuration
    <T color="teal">
      <k color="purple"> $PGM:Type </k>
    </T>

  syntax KResult ::= TerminalType

//---------------------
//--- Type function ---
//---------------------
  rule #type( P:ProcOrPat ) => type[P]
  rule #type( N:NameOrPat ) => type[N]

//*** Leaves ***
// Ground
  rule type[ B:Bool                      ] => type[ "leaf"  ;; "bool"        ;; B       ]  // Bool =================> Leaf
  rule type[ I:Int                       ] => type[ "leaf"  ;; "int"         ;; I       ]  // Int ==================> Leaf
  rule type[ S:String                    ] => type[ "leaf"  ;; "string"      ;; S       ]  // String ===============> Leaf

// Method
  rule type[ M:Method                    ] => type[ "leaf"  ;; "method"      ;; M       ]  // Method ===============> Leaf
  rule type[                             ] => type[ "empty" ;; "method"      ;; "arg"   ]  //  =====================> Leaf

// Nil
  rule type[ Nil                         ] => type[ "leaf"  ;; "nil"         ;; "Nil"   ]  // Nil ==================> Leaf

// Process Variable
  rule type[ V:ProcVar                   ] => type[ "leaf"  ;; "procvar"     ;; V       ]  // ProcVar ==============> Leaf

// Unforgeable Integers
  rule type[ unforgeable( I:Int )        ] => type[ "leaf"  ;; "unforgeable" ;; I       ]  // Unforgeable ==========> Leaf

// Uri
  rule type[ uri( S:String )             ] => type[ "leaf"  ;; "uri"         ;; S       ]  // Uri ==================> Leaf

// Wildcards
  rule type[ WildProc                    ] => type[ "leaf"  ;; "wildcard"    ;; "proc"  ]  // WildProc =============> Leaf
  rule type[ WildName                    ] => type[ "leaf"  ;; "wildcard"    ;; "name"  ]  // WildName =============> Leaf

//*** Nodes ***
// SimpleType
  rule type[ ST:SimpleType               ] => type[ "simpletype" ;; type[toString(ST)] ;; type[#truncate] ]  // Bool, Int, String types

// Quote
  rule type[ @ P:Proc                    ] => type[ "quote"      ;; type[P]   ;; type[#truncate] ]  // quoted process
  rule type[ @ P:ProcPat                 ] => type[ "quote"      ;; type[P]   ;; type[#truncate] ]  // quoted process pattern

// EvalOrPat
  rule type[ * N:Name                    ] => type[ "eval"       ;; type[N]   ;; type[#truncate] ]  // Eval
  rule type[ * N:NamePat                 ] => type[ "eval"       ;; type[N]   ;; type[#truncate] ]  // Eval pattern

// SendOrPat
  rule type[ N:Name    !  R:RhoTuple     ] => type[ "send"       ;; type[N]           ;; type[R] ]  // Send
  rule type[ N:Name    !  R:PatTuple     ] => type[ "send"       ;; type[N]           ;; type[R] ]  // Send pattern
  rule type[ N:NamePat !  R:RhoTuple     ] => type[ "send"       ;; type[N]           ;; type[R] ]  // Send pattern
  rule type[ N:NamePat !  R:PatTuple     ] => type[ "send"       ;; type[N]           ;; type[R] ]  // Send pattern
  rule type[ N:Name    !! R:RhoTuple     ] => type[ "psend"      ;; type[N]           ;; type[R] ]  // Send
  rule type[ N:Name    !! R:PatTuple     ] => type[ "psend"      ;; type[N]           ;; type[R] ]  // Send pattern
  rule type[ N:NamePat !! R:RhoTuple     ] => type[ "psend"      ;; type[N]           ;; type[R] ]  // Send pattern
  rule type[ N:NamePat !! R:PatTuple     ] => type[ "psend"      ;; type[N]           ;; type[R] ]  // Send pattern

// ReceiveOrPat/Bind(s)
  rule type[ B:BindNamePat  <- N:Name    ] => type[ "lbind"      ;; type[B]           ;; type[N] ]  // Linear bind
  rule type[ B:BindNamePats <- N:Name    ] => type[ "lbind"      ;; type[B]           ;; type[N] ]  // Linear bind
  rule type[ A:Lbind ; B:Lbind           ] => type[ "lbinds"     ;; type[A]           ;; type[B] ]  // 2 linear binds
  rule type[ A:Lbind ; B:Lbinds          ] => type[ "lbinds"     ;; type[A]           ;; type[B] ]  // N linear binds, N > 2

  rule type[ B:BindNamePat  <! N:Name    ] => type[ "peek"       ;; type[B]           ;; type[N] ]  // Peek bind
  rule type[ B:BindNamePats <! N:Name    ] => type[ "peek"       ;; type[B]           ;; type[N] ]  // Peek bind
  rule type[ A:Pbind ; B:Pbind           ] => type[ "peeks"      ;; type[A]           ;; type[B] ]  // 2 peek binds
  rule type[ A:Pbind ; B:Pbinds          ] => type[ "peeks"      ;; type[A]           ;; type[B] ]  // N peek binds, N > 2

  rule type[ B:BindNamePat  <= N:Name    ] => type[ "pbind"      ;; type[B]           ;; type[N] ]  // Persistent bind
  rule type[ B:BindNamePats <= N:Name    ] => type[ "pbind"      ;; type[B]           ;; type[N] ]  // Persistent bind
  rule type[ A:Rbind ; B:Rbind           ] => type[ "pbinds"     ;; type[A]           ;; type[B] ]  // 2 persistent binds
  rule type[ A:Rbind ; B:Rbinds          ] => type[ "pbinds"     ;; type[A]           ;; type[B] ]  // N persistent binds, N > 2

  rule type[ for( B:Bind  ){ P:Proc    } ] => type[ "receive"    ;; type[B]           ;; type[P] ]  // Receive
  rule type[ for( B:Bind  ){ P:ProcPat } ] => type[ "receive"    ;; type[B]           ;; type[P] ]  // Receive pattern
  rule type[ for( B:Binds ){ P:Proc    } ] => type[ "receives"   ;; type[B]           ;; type[P] ]  // Receive
  rule type[ for( B:Binds ){ P:ProcPat } ] => type[ "receives"   ;; type[B]           ;; type[P] ]  // Receive pattern

// Contract and Pattern
  rule type[ contract X:Name ( Y:BindNamePat  ) = { P:Proc    } ] => type[ "contract" ;; type[ Y <= X ] ;; type[P] ]  // contract, 1 name declared
  rule type[ contract X:Name ( Y:BindNamePats ) = { P:Proc    } ] => type[ "contract" ;; type[ Y <= X ] ;; type[P] ]  // contract, N names declared, N > 1
  rule type[ contract X:Name ( Y:BindNamePat  ) = { P:ProcPat } ] => type[ "contract" ;; type[ Y <= X ] ;; type[P] ]  // contract pattern, 1 name declared
  rule type[ contract X:Name ( Y:BindNamePats ) = { P:ProcPat } ] => type[ "contract" ;; type[ Y <= X ] ;; type[P] ]  // contract pattern, N names declared, N > 1

// New and Pattern
 rule type[ new N:Name  in { P:Proc    } ] => type[ "new"     ;; type[N]    ;; type[P] ]  // new binding
 rule type[ new N:Names in { P:Proc    } ] => type[ "new"     ;; type[N]    ;; type[P] ]  // new bindings
 rule type[ new N:Name  in { P:ProcPat } ] => type[ "new"     ;; type[N]    ;; type[P] ]  // new binding pattern
 rule type[ new N:Names in { P:ProcPat } ] => type[ "new"     ;; type[N]    ;; type[P] ]  // new bindings pattern

 rule type[ @ V:ProcVar ( U:Uri )        ] => type[ "newuri"  ;; type[V]    ;; type[U] ]  // new uri name declaration

// ParOrPat
  rule type[ P:Proc    | Q:Proc          ] => type[ "par"     ;; type[P]    ;; type[Q] ]  // Par
  rule type[ P:Proc    | Q:ProcPat       ] => type[ "par"     ;; type[P]    ;; type[Q] ]  // Par pattern
  rule type[ P:ProcPat | Q:Proc          ] => type[ "par"     ;; type[P]    ;; type[Q] ]  // Par pattern
  rule type[ P:ProcPat | Q:ProcPat       ] => type[ "par"     ;; type[P]    ;; type[Q] ]  // Par pattern

// Match
  rule type[ match P:Proc { M:MatchCase  } ] => type[ "match" ;; type[P] ;; type[M] ]  // Match against one case
  rule type[ match P:Proc { M:MatchCases } ] => type[ "match" ;; type[P] ;; type[M] ]  // Match against several cases

  rule type[ M:ProcPat :=> P:Proc          ] => type[ "case"  ;; type[M] ;; type[P] ]  // 1 match case
  rule type[ M:MatchCase N:MatchCase       ] => type[ "cases" ;; type[M] ;; type[N] ]  // 2 match cases
  rule type[ M:MatchCase N:MatchCases      ] => type[ "cases" ;; type[M] ;; type[N] ]  // N match cases, N > 2

// VarRef
  rule type[ =: V:ProcVar ] => type[ "varref" ;; type[V] ;; type[#truncate]   ]  // variable reference

// Logical Patterns
  rule type[ P:Proc    /\ Q:Proc         ] => type[ "andpat" ;; type[P]  ;; type[Q]         ]  // logical and
  rule type[ P:Proc    /\ Q:ProcPat      ] => type[ "andpat" ;; type[P]  ;; type[Q]         ]  // logical and
  rule type[ P:ProcPat /\ Q:Proc         ] => type[ "andpat" ;; type[P]  ;; type[Q]         ]  // logical and
  rule type[ P:ProcPat /\ Q:ProcPat      ] => type[ "andpat" ;; type[P]  ;; type[Q]         ]  // logical and

  rule type[ P:Proc    \/ Q:Proc         ] => type[ "orpat"  ;; type[P]  ;; type[Q]         ]  // logical or
  rule type[ P:Proc    \/ Q:ProcPat      ] => type[ "orpat"  ;; type[P]  ;; type[Q]         ]  // logical or
  rule type[ P:ProcPat \/ Q:Proc         ] => type[ "orpat"  ;; type[P]  ;; type[Q]         ]  // logical or
  rule type[ P:ProcPat \/ Q:ProcPat      ] => type[ "orpat"  ;; type[P]  ;; type[Q]         ]  // logical or

  rule type[ ~ P:Proc                    ] => type[ "notpat" ;; type[P]  ;; type[#truncate] ]  // logical negation
  rule type[ ~ P:ProcPat                 ] => type[ "notpat" ;; type[P]  ;; type[#truncate] ]  // logical negation

// Conditionals and Patterns
  rule type[ if (B:BExp) then P:Proc     ] => type[ "ifthen" ;; type[B]  ;; type[P] ]  // if true/false then P
  rule type[ if (B:BExp) then P:ProcPat  ] => type[ "ifthen" ;; type[B]  ;; type[P] ]  // if true/false then P

  rule type[ P:IfThen    else Q:Proc     ] => type[ "else"   ;; type[P] ;; type[Q] ]  // if true/false then P else Q
  rule type[ P:IfThenPat else Q:ProcPat  ] => type[ "else"   ;; type[P] ;; type[Q] ]  // if true/false then P else Q

// Bundles
  rule type[ bundle+{ P:Proc }  ] => type[ "bundle+" ;; type[P] ;; type[#truncate] ]  // bundle+
  rule type[ bundle-{ P:Proc }  ] => type[ "bundle-" ;; type[P] ;; type[#truncate] ]  // bundle-
  rule type[ bundle0{ P:Proc }  ] => type[ "bundle0" ;; type[P] ;; type[#truncate] ]  // bundle0
  rule type[ bundle { P:Proc }  ] => type[ "bundle"  ;; type[P] ;; type[#truncate] ]  // bundle

// Collections and Patterns
// RhoList
  rule type[ [ P:Proc           ]               ] => type[ "list"    ;; type[P]   ;; type[#truncate] ]  // singleton list
  rule type[ [ P:Proc , Q:Proc  ]               ] => type[ "list"    ;; type[P]   ;; type[Q]         ]  // 2 process list
  rule type[ [ P:Proc , Q:Procs ]               ] => type[ "list"    ;; type[P]   ;; type[Q]         ]  // N process list, N > 2

// RhoListPat
  rule type[ [ P:ProcPat , ... V:ProcVar ]      ] => type[ "listpat" ;; type[P]   ;; type[V]         ]  // list pattern

// RhoMap
  rule type[ P:Proc : Q:Proc                        ] => type[ "kvpair"     ;; type[P]   ;; type[Q]         ]  // single key-value pair
  rule type[ P:Proc : Q:Proc , R:RhoKVPairs         ] => type[ "kvpairs"    ;; type[P:Q] ;; type[R]         ]  // N key-value pairs, N > 2

  rule type[ { P:Proc : Q:Proc                }     ] => type[ "map"        ;; type[P:Q] ;; type[#truncate] ]  // 1 key-value pair map
  rule type[ { P:Proc : Q:Proc , S:RhoKVPairs }     ] => type[ "map"        ;; type[P:Q] ;; type[S]         ]  // N key-value pairs map

// RhoMapPat
  rule type[ P:ProcPat : Q:ProcPat                  ] => type[ "kvpat"      ;; type[P]   ;; type[Q]         ]  // single key-value pair
  rule type[ P:ProcPat : Q:ProcPat , R:RhoKVPat     ] => type[ "kvpats"     ;; type[P:Q] ;; type[R]         ]  // N key-value pairs, N > 2

  rule type[ { R:RhoKVPat , ... U:ProcVar : V:ProcVar } ] => type[ "mappat" ;; type[R]   ;; type[U:V]       ]  // map pattern

// RhoSet
  rule type[ Set( P:Proc           )            ] => type[ "set"      ;; type[P]   ;; type[#truncate] ]  // singleton set
  rule type[ Set( P:Proc , Q:Proc  )            ] => type[ "set"      ;; type[P]   ;; type[Q]         ]  // 2 element set
  rule type[ Set( P:Proc , Q:Procs )            ] => type[ "set"      ;; type[P]   ;; type[Q]         ]  // N element set, N > 2

// RhoSetPat
  rule type[ Set( P:ProcPat , ... V:ProcVar )   ] => type[ "setpat"   ;; type[P]   ;; type[V]         ]  // set pattern

// RhoTuple
  rule type[ tuple1( P:Proc           )         ] => type[ "tuple"    ;; type[P]   ;; type[#truncate] ]  // single process set
  rule type[ tuple2( P:Proc , Q:Proc  )         ] => type[ "tuple"    ;; type[P]   ;; type[Q]         ]  // 2 process set
  rule type[ tuplen( P:Proc , Q:Procs )         ] => type[ "tuple"    ;; type[P]   ;; type[Q]         ]  // N process set, N > 2

// RhoTuplePat
  rule type[ ( P:ProcPat , ... V:ProcVar  )     ] => type[ "tuplepat" ;; type[P]   ;; type[V]      ]  // tuple pattern

// PatTuple
  rule type[ pat1( P:ProcPat              )     ] => type[ "tuple" ;; type[P]   ;; type[#truncate] ]  // pattern 1-tuple
  rule type[ pat2( P:ProcPat , Q:ProcPat  )     ] => type[ "tuple" ;; type[P]   ;; type[Q]         ]  // pattern 2-tuple
  rule type[ patn( P:ProcPat , Q:ProcPats )     ] => type[ "tuple" ;; type[P]   ;; type[Q]         ]  // pattern N-tuple, N > 2

// Method and Pattern
  rule type[ P:Proc    . M:MethodAndArgs  ] => type[ "method"         ;; type[P]   ;; type[M] ]  // Method
  rule type[ P:ProcPat . M:MethodAndArgs  ] => type[ "method"         ;; type[P]   ;; type[M] ]  // Method pattern
  rule type[ M:Method (  A:MethodArgs )   ] => type[ "methodandargs"  ;; type[M]   ;; type[A] ]  // Method and Args

// Several Names/Pats
  rule type[ M:Name , N:Name        ] => type[ "names"     ;; type[M] ;; type[N] ]  // 2 names
  rule type[ M:Name , N:Names       ] => type[ "names"     ;; type[M] ;; type[N] ]  // N names, N > 2

  rule type[ M:NamePat , N:NamePat  ] => type[ "namepats"  ;; type[M] ;; type[N] ]  // 2 name patterns
  rule type[ M:NamePat , N:NamePats ] => type[ "namepats"  ;; type[M] ;; type[N] ]  // N name patterns, N > 2

// Several Procs/Pats
  rule type[ P:Proc , Q:Proc        ] => type[ "procs"     ;; type[P] ;; type[Q] ]  // 2 processes
  rule type[ P:Proc , Q:Procs       ] => type[ "procs"     ;; type[P] ;; type[Q] ]  // N processes, N > 2

  rule type[ P:ProcPat , Q:ProcPat  ] => type[ "procpats"  ;; type[P] ;; type[Q] ]  // 2 process patterns
  rule type[ P:ProcPat , Q:ProcPats ] => type[ "procpats"  ;; type[P] ;; type[Q] ]  // N process patterns, N > 2

// Arithmetic
  rule type[ A:AExp * B:AExp        ] => type[ "mult"      ;; type[A] ;; type[B] ]  // multiplication
  rule type[ A:AExp + B:AExp        ] => type[ "plus"      ;; type[A] ;; type[B] ]  // addition
  rule type[ A:AExp - B:AExp        ] => type[ "minus"     ;; type[A] ;; type[B] ]  // subtraction

// Boolean
  rule type[ A:AExp <=  B:AExp      ] => type[ "leq"       ;; type[A] ;; type[B] ]  // leq
  rule type[ A:BExp and B:BExp      ] => type[ "and"       ;; type[A] ;; type[B] ]  // bool and
  rule type[ A:BExp or  B:BExp      ] => type[ "or"        ;; type[A] ;; type[B] ]  // bool or
  rule type[   not A:BExp           ] => type[ "not"       ;; type[A] ;; type[#truncate] ]  // bool not

// Resolving brackets
  rule type[ { P:ProcOrPat } ] => type[P]  // bracketed ProcOrPat type resolution

//----------------------
//--- Type Inclusion ---
//----------------------
// Relation to #isIn predicate
  rule A:Type #isin B:Type => A #isIn B

  rule P:Proc    #isIn Q:Proc    => #type(P) #isin #type(Q)
  rule P:Proc    #isIn Q:ProcPat => #type(P) #isin #type(Q)
  rule P:ProcPat #isIn Q:ProcPat => #type(P) #isin #type(Q)
  rule _:ProcPat #isIn _:Proc    => false

  rule M:Name    #isIn N:Name    => #type(M) #isin #type(N)
  rule M:Name    #isIn N:NamePat => #type(M) #isin #type(N)
  rule M:NamePat #isIn N:NamePat => #type(M) #isin #type(N)
  rule _:NamePat #isIn _:Name    => false

endmodule