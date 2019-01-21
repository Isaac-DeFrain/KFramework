// Polyadic Rho-Calculus (no Ground, VarRef, AExp, BExp, patterns, contracts, bundle, conditionals, unforgeable names)

require "substitution.k"
require "domains.k"

module POLYRHO-SYNTAX
import ID
import DOMAINS
import SUBSTITUTION

//-----------------
//--- PROCESSES ---
//-----------------

//--- Process ---
syntax          Proc ::= "{" Proc "}"
                       | "Nil"
                       | Collection
                       | ProcVar
                       > "*" Name
                       > MethodProc "." Method "(" MethodArgs ")"
                       > Name Send
                       | "for" "(" Receipt ")" "{" Proc "}"
                       > Proc "|" Proc

//--- Processes ---
syntax         Procs ::= Proc
                       | Proc "," Procs

//--- Collections ---
syntax    Collection ::= RhoList
                       | RhoMap
                       | RhoSet
                       | RhoTuple

// Rho Lists
syntax       RhoList ::= "[" Procs "]"

// Rho Maps & Key-Value Pairs
syntax        RhoMap ::= "{" KeyValuePairs "}"

syntax  KeyValuePair ::= Proc ":" Proc

syntax KeyValuePairs ::= KeyValuePair
                       | KeyValuePair "," KeyValuePairs

// Rho Sets
syntax        RhoSet ::= "Set" "(" Procs ")"

// Rho Tuples
syntax      RhoTuple ::= "(" Proc ",)"
                       | "(" Proc "," Procs ")"

//--- Process Variables ---
syntax           Var ::= Id
syntax          Vars ::= Var
                       | Var "," Vars

syntax       ProcVar ::= Var
syntax      ProcVars ::= ProcVar
                       | ProcVar "," ProcVars

//--- Methods ---
syntax    MethodProc ::= Collection

syntax    MethodArgs ::= ""
                       | Procs

syntax        Method ::= "add"                                                          //add: Proc*Proc -> Method (list & string)
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
                       | "union"

//--- Sends ---
syntax          Send ::= SingleSend
                       | PSend

syntax    SingleSend ::= "!"  SendContent

syntax         PSend ::= "!!" SendContent

syntax   SendContent ::= "(" Proc ")"
                       | RhoTuple

//--- Receives ---
syntax     Receipt ::= 


//-------------
//--- NAMES ---
//-------------
syntax          Name ::= "@" Proc
                       | NameVar

syntax         Names ::= Name
                       | Name "," Names
                       | NameVars

//--- Name Variables ---
syntax       NameVar ::= Var
syntax      NameVars ::= NameVar
                       | NameVar "," NameVars

endmodule

module POLYRHO
import POLYRHO-SYNTAX

configuration
<T>
  <threadpool>
    <thread>
      <k> $PGM:Proc </k>
    </thread>
  </threadpool>
</T>

// Sends - send Proc or RhoTuple on Name, single and persistent
rule 










endmodule

