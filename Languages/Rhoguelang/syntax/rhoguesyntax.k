// RHOGUELANG (a.k.a. RHO-CALC++)

require "substitution.k"

//.....................
//... SYNTAX MODULE ...
//.....................
module RHOGUE-SYNTAX
import ID
import DOMAINS-syntax
import SUBSTITUTION

//-----------------------------
//--- PROCESSES & VARIABLES ---
//-----------------------------

//--- Process ---
syntax          Proc ::= "{" Proc "}"                                       [bracket]  //bracket for process
                       | "Nil"                                                         //stopped process
                       | Ground                                                        //boolean, integer, string, unforgeable int, uri
                       | Collection                                                    //process tuple, list, set, map
                       | ProcVar                                                       //process variables
                       > VarRef                                                        //variable references
                       > "*" Name                                                      //evaluate/reify
                       > Proc "." Method "(" MethodArgs ")"                            //method
                       > AExp                                                          //arithmetic expression
                       > BExp                                                          //boolean expression
                       > Name Send                                                     //send on channel
                       > "contract" Names "(" NamePats ")" "=" "{" Proc "}"            //contract: needs to be given an alias which binds
                       | "for" "(" Receipt ")" "{" Proc "}"                  [binder]  //listen
                       | "match" Proc "{" MatchCases "}"                               //match
                       | Bundle "{" Proc "}"                                           //bundle
                       > "if" "(" Bool ")" Proc                           [strict(1)]  //if...then...
                       | "if" "(" Bool ")" Proc "else" Proc               [strict(1)]  //if...then...else...
                       | "new" NameDecs "in" "{" Proc "}"                    [binder]  //unforgeable names
                       > Proc "|" Proc                                         [left]  //parallel composition

//--- Ground ---
//Basic Data Structures
syntax        Ground ::= Bool                                                          //boolean
                       | Int                                                           //integer
                       | String                                                        //string
                       | "unforgeable(" Int ")"                                        //unforgeable integer
                       | Uri                                                           //uri

//--- Collection ---
syntax    Collection ::= RhoList                                                       //process list
                       | RhoMap                                                        //process map
                       | RhoSet                                                        //process set
                       | RhoTuple                                                      //process tuple

// Lists
syntax      RhoList ::= "[" Procs "]"                                                  //list of processes

// Maps & Key-Value Pairs
syntax       RhoMap ::= "{" RhoKVPairs "}"                                             //map = { key-value pairs }

syntax   RhoKVPairs ::= Proc ":" Proc                                                  //single key-value pair
                      | Proc ":" Proc "," RhoKVPairs                                   //multiple key-value pairs

// Sets
syntax          Set ::= "Set" "(" Procs ")"                                            //set of processes

// Tuples
syntax     RhoTuple ::= "(" Proc ",)"                                                  //1-tuple, note the ",)"
                      | "(" Proc "," Procs ")"                                         //n-tuple, n >= 2

//--- General Variables ---
syntax          Var ::= Id                                                             //name or process variable
syntax         Vars ::= Var                                                            //single variable
                      | Var "," Vars                                                   //multiple variables

//---Process Variables---
syntax      ProcVar ::= Var                                                            //process variable

syntax     ProcVars ::= ProcVar                                                        //monadic
                      | ProcVar "," ProcVars                                           //polyadic

//--- Variable References ---                                                          //so we don't shadow the variable referenced
syntax       VarRef ::= "=" ProcVar                                                    //process variable reference
                      | "=" "*" NameVar                                                //evaluated name variable reference

//--- Methods ---
syntax   MethodArgs ::= Procs                                                          //one or more processes
                      | ""                                                             //no method arguments

// List of current methods
syntax       Method ::= "add"                                                          //add: list & string
                      | "confine"                                                      //still not in interpreter?
                      | "contains"                                                     //contains: not tuple
                      | "delete"                                                       //delete: not tuple
                      | "diff"                                                         //difference: not tuple
                      | "get"                                                          //get value: map
                      | "getOrElse"                                                    //get value or else: map
                      | "hexToBytes"                                                   //hex to bytes: string
                      | "lenth"                                                        //length: list & string
                      | "keys"                                                         //key set: map
                      | "nth"                                                          //nth element: list, string & tuple
                      | "set"                                                          //set value: map
                      | "size"                                                         //size: not tuple
                      | "slice"                                                        //slice: list & string        
                      | "toByteArray"                                                  //to byte array: all
                      | "union"                                                        //union: map & set


//--- Expressions ---
// expressions are anything that necessarily resolves to a ground term or collection
syntax          Exp ::= Collection
                      | Ground
                      | AExp

// Arithmetic Expressions
syntax         AExp ::= "(" AExp ")"                                                   //parentheses for arithmetic expression
                      > AExp "*"  AExp                                       [strict]  //multiplication
                      | AExp "/"  AExp                                       [strict]  //division
                      | AExp "%"  AExp                                       [strict]  //remainders
                      > AExp "+"  AExp                                       [strict]  //addition
                      | AExp "-"  AExp                                       [strict]  //subtraction
                      | AExp "++" AExp                                       [strict]  //plus plus
                      > AExp "--" AExp                                       [strict]  //minus minus

// Boolean Expressions
syntax         BExp ::= "(" BExp ")"                                        [bracket]  //parentheses for boolean expression
                      | Bool                                                           //true or false
                     // Arithmetic                                                     //arithmetic predicates
                      > AExp "<"  AExp                                    [seqstrict]  //strictly less than
                      | AExp "<=" AExp                                    [seqstrict]  //less than
                      | AExp ">"  AExp                                    [seqstrict]  //strictly greater than
                      | AExp ">=" AExp                                    [seqstrict]  //greater than
                     // Processes                                                      //process predicates
                      > Proc "matches" Proc                                            //process matching
                      | Proc "==" Proc                                                 //process equality
                      | Proc "!=" Proc                                                 //process inequlaity
                     // Connectives                                                    //boolean connectives
                      | "not" BExp                                           [strict]  //not
                      > BExp "and" BExp                                   [seqstrict]  //and
                      > BExp "or"  BExp                                   [strict(1)]  //or

//--- Sends ---
syntax          Send ::= SendSingle                                                    //single
                       | SendMultiple                                                  //persistent

// Single Send
syntax    SendSingle ::= "!"  SendContent

// Persistent Send
syntax  SendMultiple ::= "!!" SendContent

// Content of send
syntax   SendContent ::= "(" Proc ")"                                                  //monadic send
                       | RhoTuple                                                      //poladic send

//--- Listens ---
// Receipts
syntax       Receipt ::= LinearBinds
                       | RepeatedBinds

// Linear binds
syntax    LinearBind ::= NamePats  "<-" Name                                           //for( y <- x ){ P }

syntax      PeekBind ::= NamePats  "<!" Name                                           //peek

syntax   LinearBinds ::= LinearBind                                                    //single linear bind
                       | LinearBind ";" LinearBinds                                    //multiple linear binds (join)

// Repeated binds
syntax  RepeatedBind ::= NamePats "<=" Name                                            //for( y <= x ){ P }

syntax RepeatedBinds ::= RepeatedBind                                                  //single repeated bind
                       | RepeatedBind ";" RepeatedBinds                                //multiple repeated binds (join)

//--- Matches ---
syntax     MatchCase ::= ProcPat "=>" Proc                                      [binder]  //match case

syntax    MatchCases ::= MatchCase                                                     //single match case
                       | MathCase MatchCases                                           //multiple match cases

//--- Bundles ---
// cannot be destructured by pattern matching                                          // | can read? | can write? |
syntax        Bundle ::= "bundle0"                                                     // | no        | no         |
                       | "bundle-"                                                     // | yes       | no         |
                       | "bundle+"                                                     // | no        | yes        |
                       | "bundle"                                                      // | yes       | yes        |


//------------------------
//--- PROCESS PATTERNS ---
//------------------------

syntax       ProcPat ::= "{" ProcPat "}"     [bracket]                                 //bracket for process pattern
                       | CollectionPat                                                 //collection pattern
                       | SimpleType                                                    //simple type
                       > "~" ProcPat                                                   //logical negation
                       > ProcPat "/\\" ProcPat  [left]                                 //logical "and"
                       > ProcPat "\\/" ProcPat  [left]                                 //logical "or"
                       > Proc                                                          //process patterns can be ordinary pattern
                       > ProcPat "|" ProcPat    [left]                                 //parallel compsition

syntax      ProcPats ::= Procs                                                         //process patterns can be ordinary patterns
                       | ProcPat                                                       //single process pattern
                       | ProcPat "," ProcPats                                          //multiple process patterns

//--- Collection Patterns ---
syntax CollectionPat ::= RhoListPat                                                    //list patterns
                       | RhoMapPat                                                     //map patterns
                       | RhoSetPat                                                     //set patterns
                       | RhoTuplePat                                                   //tuple patterns

// List Patterns
syntax    RhoListPat ::= RhoList                                                       //ordinary list
                       | "[" ProcPats "," "..." ProcVar "]"                            //genuine list pattern

// Map & Key-Value Pair Patterns
//syntax   RhoMapPat ::= RhoMap                                                        //ordinary map
//                     | "{" RhoKVPairPat "," "..." RhoKVPairVar "}"                   //genuine map pattern
//
//syntaxRhoKVPairPat ::= ProcPat ":" ProcPat                                           //single key-value pattern
//                     | ProcPat ":" ProcPat "," RhoKVPairPat                          //multiple key-value patterns
//
//syntaxRhoKVPairVar ::= ProcVar ":" ProcVar                                           //single key-value variable
//                     | ProcVar ":" ProcVar "," RhoKVPairVar                          //multiple key-value variables

// Set Patterns
syntax     RhoSetPat ::= RhoSet                                                        //ordinary set
                       | "Set" "(" ProcPats "," "..." ProcVar ")"                      //genuine set pattern

// Tuple Patterns
//syntax RhoTuplePat ::= RhoTuple                                                      //ordinary tuple
//                     | "(" ProcVar ",)"                                              //genuine 1-tuple pattern
//                     | "(" ProcPats "," "..." ProcVar ")"                            //genuine n-tuple pattern

//--- Simple Types ---
syntax    SimpleType ::= "Bool"
                       | "ByteArray"
                       | "Int"
                       | "List"
                       | "Map"
                       | "String"
                       | "Tuple"
                       | "Uri"

//------------------------------
//--- NAMES & NAME VARIABLES ---
//------------------------------

//--- Name Variables ---
syntax       NameVar ::= Var                                                           //name variable

syntax      NameVars ::= NameVar                                                       //single variable
                       | NameVar "," NameVars                                          //multiple variables

//--- Names ---
syntax          Name ::= "@" Proc                                                      //quoted process
                       | NameVar                                                       //variable

syntax         Names ::= Name                                                          //single name
                       | Name "," Names                                                //multiple names
                       | NameVars                                                      //name variables

//--- Name Declarations ---
syntax       NameDec ::= NameVar                                                       //name variable
                       | NameVar "(" Uri ")"                                           //name variable with uri

syntax      NameDecs ::= NameVars                                                      //one or more name variables
                       | NamDec                                                        //single name declaration
                       | NameDec "," NameDecs                                          //multiple name declarations

//--- Uri ---
syntax           Uri ::= "uri(" String ")"

//---------------------
//--- NAME PATTERNS ---
//---------------------
syntax       NamePat ::= Name                                                          //ordinary name
                       | "@" ProcPat                                                   //quoted process pattern

syntax      NamePats ::= NamePat                                                       //single name pattern
                       | NamePat "," NamePats                                          //multiple name patterns
                       | Names                                                         //ordinary names



//------------------------
//--- GENERAL PATTERNS ---
//------------------------
syntax           Pat ::= NamePat                                                       //name pattern
                       | ProcPat                                                       //process pattern

syntax          Pats ::= NamePats                                                      //name patterns
                       | ProcPats                                                      //process patterns

endmodule

