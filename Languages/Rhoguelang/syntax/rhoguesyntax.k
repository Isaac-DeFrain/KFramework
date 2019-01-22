// RHOGUELANG (RHO-CALC to RHOLANG)

require "substitution.k"
require "domains.k"

//.....................
//... SYNTAX MODULE ...
//.....................
module RHOGUESYNTAX-SYNTAX
import ID
import DOMAINS
import SUBSTITUTION

//-----------------------------
//--- PROCESSES & VARIABLES ---
//-----------------------------

//--- Process ---
syntax          Proc ::= "{" Proc "}"                                       [bracket]  //bracket for process
                       | "Nil"                                                         //stopped process
                       | Ground                                                        //boolean, integer, string, unforgeable int, uri
                       | Collection                                                    //process list, map, set, tuple
                       | ProcVar                                                       //process variables
                       > VarRef                                                        //variable references
                       > "*" Name                                                      //evaluate/reify
                       > MethodProc "." Method "(" MethodArgs ")"                      //method
                       > AExp                                                          //arithmetic expression
                       > BExp                                                          //boolean expression
                       > Name Send                                                     //send on channel
                       > "contract" Names "(" NamePats ")" "=" "{" Proc "}"            //contract: needs to be given an alias which binds
                       | "for" "(" Receipt ")" "{" Proc "}"                  [binder]  //listen
                       | "match" Proc "{" MatchCases "}"                               //match
                       | Bundle "{" Proc "}"                                           //bundle
                       > "if" "(" BExp ")" Proc                           [strict(1)]  //if...then...
                       | "if" "(" BExp ")" Proc "else" Proc               [strict(1)]  //if...then...else...
                       | "new" NameDeclares "in" "{" Proc "}"                [binder]  //unforgeable names
                       > Proc "|" Proc                                         [left]  //parallel composition

//--- Ground Terms ---
//Basic Data Structures
syntax        Ground ::= Bool                                                          //boolean
                       | Int                                                           //integer
                       | String                                                        //string
                       | "unforgeable(" Int ")"                                        //unforgeable integer
                       | Uri                                                           //uri

//--- Collection ---
syntax    Collection ::= RhoList                                                       //process list
                       | RhoMap                                                        //process key-value pairs
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

syntax     ProcVars ::= ProcVar                                                        //single variable
                      | ProcVar "," ProcVars                                           //several variables

//--- Variable References ---                                                          //so we don't shadow the variable referenced (mutable reference)
syntax       VarRef ::= "=" ProcVar                                                    //process variable reference
                      | "=" "*" NameVar                                                //evaluated name variable reference

//---------------
//--- Methods ---
//---------------

// Method Prefixes
syntax   MethodProc ::= Collection                                                     //rholist, rhomap, rhoset, rhotuple
                      | String                                                         //ordinary string

// Method Arguments
syntax   MethodArgs ::= Procs                                                          //one or more process arguments "," separated
                      | ""                                                             //no method arguments

// List of current methods
syntax       Method ::= "add"                                                          //add: Proc*Proc -> Method (list & string)
                      | "confine"                                                      //still not in interpreter?
                      | "contains"                                                     //contains predicate: Proc*Elements -> Method
                      | "delete"                                                       //delete: Proc*Elements -> Method (not tuple)
                      | "diff"                                                         //difference: Proc*Procs -> Method (not tuple)
                      | "get"                                                          //get value: Map*Key -> Method
                      | "getOrElse"                                                    //get value or else: Map*Key*Proc -> Method
                      | "hexToBytes"                                                   //hex to bytes: String -> Method
                      | "lenth"                                                        //length: Proc -> Method (list & string)
                      | "keys"                                                         //keys set: Map -> Method
                      | "nth"                                                          //nth element: Proc*Int -> Method (list, string & tuple)
                      | "set"                                                          //set value: Map*Key*Value -> Method
                      | "size"                                                         //size: Proc -> Method (map & set)
                      | "slice"                                                        //slice: Proc*Int*Int -> Method (list & string)        
                      | "toByteArray"                                                  //to byte array: Proc -> Method (all)
                      | "union"                                                        //union: Proc*Proc -> Method (map & set)


//--- Expressions ---
// expressions are anything that necessarily resolves to a ground term or collection
syntax          Exp ::= Collection
                      | Ground
                      | AExp
                      | BExp

// Arithmetic Expressions
syntax         AExp ::= "(" AExp ")"                                                   //parentheses for arithmetic expression
                      > AExp "*"  AExp                                    [seqstrict]  //multiplication
                      | AExp "/"  AExp                               [seqstrict(2 1)]  //division
                      | AExp "%"  AExp                               [seqstrict(2 1)]  //remainders
                      > AExp "+"  AExp                                    [seqstrict]  //addition
                      | AExp "-"  AExp                                    [seqstrict]  //subtraction
                      | AExp "++" AExp                                       [strict]  //plus plus
                      > AExp "--" AExp                                       [strict]  //minus minus

// Boolean Expressions
syntax         BExp ::= "(" BExp ")"                                        [bracket]  //parentheses for boolean expression
                      | Bool                                                           //bool
                     // Arithmetic predicates
                      > AExp "<"  AExp                                    [seqstrict]  //strictly less than
                      | AExp "<=" AExp                                    [seqstrict]  //less than
                      | AExp ">"  AExp                                    [seqstrict]  //strictly greater than
                      | AExp ">=" AExp                                    [seqstrict]  //greater than
                     // Process predicates
                      > Proc "matches" Proc                                            //process matching
                      | Proc "==" Proc                                                 //process equivalence
                      | Proc "!=" Proc                                                 //process nonequivalence
                     // Boolean connectives
                      | "not" BExp                                           [strict]  //not
                      > BExp "and" BExp                                   [seqstrict]  //and
                      > BExp "or"  BExp                                   [strict(1)]  //or

//--- Sends ---
syntax          Send ::= SingleSend                                                    //single
                       | PersistSend                                                   //persistent

// Single Send
syntax    SingleSend ::= "!"  SendContent                                              //consumable once

// Persistent Send
syntax   PersistSend ::= "!!" SendContent                                              //arbitrarily consuamable

// Content of send
syntax   SendContent ::= "(" Proc ")"                                                  //monadic contents
                       | RhoTuple                                                      //polyadic contents

//--- Listens ---
// Receipts
syntax       Receipt ::= LinearBinds                                                   //supports monadic & polyadic linear receive
                       | RepeatedBinds                                                 //supports monadic & polyadic persistent receive
                       | PeekingBind                                                   //supports monadic peeking only

// Linear binds
syntax   PeekingBind ::= NamePats  "<!" Name                                           //for( y <! x ){ P } - does *not* consume send on x

syntax    LinearBind ::= NamePats  "<-" Name                                           //for( y <- x ){ P } - consumes send on x

syntax   LinearBinds ::= LinearBind                                                    //linear monadic
                       | LinearBind ";" LinearBinds                                    //linear polyadic

// Repeated binds
syntax  RepeatedBind ::= NamePats "<=" Name                                            //for( y <= x ){ P }

syntax RepeatedBinds ::= RepeatedBind                                                  //single repeated bind
                       | RepeatedBind ";" RepeatedBinds                                //multiple repeated binds (join)

//--- Matches ---
syntax     MatchCase ::= ProcPat "=>" Proc                                   [binder]  //match case

syntax    MatchCases ::= MatchCase                                                     //single match case
                       | MathCase MatchCases                                           //multiple match cases, space separated

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
syntax   NameDeclare ::= NameVar                                                       //name variable
                       | NameVar "(" Uri ")"                                           //name variable with uri

syntax  NameDeclares ::= NameVars                                                      //one or more name variables
                       | NamDec                                                        //single name declaration
                       | NameDec "," NameDecs                                          //multiple name declarations

//--- Uri ---
syntax           Uri ::= "uri(" String ")"

//---------------------
//--- NAME PATTERNS ---
//---------------------
syntax       NamePat ::= Name                                                          //ordinary name
                       | "@" ProcPat                                                   //quoted process pattern

syntax      NamePats ::= Names                                                         //ordinary names
                       | NamePat                                                       //single name pattern
                       | NamePat "," NamePats                                          //multiple name patterns




//------------------------
//--- GENERAL PATTERNS ---
//------------------------
syntax           Pat ::= NamePat                                                       //name pattern
                       | ProcPat                                                       //process pattern

syntax          Pats ::= NamePats                                                      //name patterns
                       | ProcPats                                                      //process patterns

endmodule

module RHOUGESYNTAX
import RHOGUESYNTAX-SYNTAX

endmodule
