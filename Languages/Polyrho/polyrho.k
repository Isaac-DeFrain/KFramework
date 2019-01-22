// Polyadic Rho-Calculus

require "substitution.k"
require "domains.k"

module POLYRHO-SYNTAX
import ID
import DOMAINS
import SUBSTITUTION

//-----------------
//--- PROCESSES ---
//-----------------

//--- Processes ---
syntax          Proc ::= "{" Proc "}"                              [bracket]
                       | "Nil"
                       | Ground
                       | ProcVar
                       | RhoTuple
                       > "*" Name
                       > Name Send
                       | "for" "(" Receipt ")" "{" Proc "}"         [binder]
                       > Proc "|" Proc                                [left]

syntax         Procs ::= Proc
                       | Proc "," Procs
                       | "{" Procs "}"                             [bracket]

//--- Ground Terms ---
syntax        Ground ::= Bool
                       | Int
                       | String

//--- Tuples ---
syntax      RhoTuple ::= "(" Proc ",)"
                       | "(" Proc "," Procs ")"

//--- Process Variables ---
syntax           Var ::= Id
syntax          Vars ::= Var
                       | Var "," Vars

syntax       ProcVar ::= Var
syntax      ProcVars ::= ProcVar
                       | ProcVar "," ProcVars

//--- Sends ---
syntax          Send ::= SingleSend

// Single send
syntax    SingleSend ::= "!"  SendContent

syntax   SendContent ::= "(" Procs ")"

//--- Receives ---
syntax       Receipt ::= LinearBinds

// Linear binds
syntax    LinearBind ::= NamePat "<-" Name

syntax   LinearBinds ::= LinearBind
                       | LinearBind ";" LinearBinds


//-------------
//--- NAMES ---
//-------------
syntax          Name ::= "@" Proc
                       | NameVar

syntax         Names ::= Name
                       | Name "," Names
                       | NameVars
                       | "@" "{" Procs "}"

//--- Name Variables ---
syntax       NameVar ::= Var
syntax      NameVars ::= NameVar
                       | NameVar "," NameVars


//----------------
//--- PATTERNS ---
//----------------

//--- Process Patterns ---
syntax       ProcPat ::= "{" ProcPat "}"
                       | Proc
                       > Proc "|" Proc

syntax      ProcPats ::= Procs
                       | ProcPat
                       | ProcPat "," ProcPats

//--- Name Patterns ---
syntax       NamePat ::= Name
                       | "@" ProcPat

syntax      NamePats ::= Names
                       | NamePat
                       | NamePat "," NamePats


endmodule

module POLYRHO
import POLYRHO-SYNTAX

//---------------------
//--- CONFIGURATION ---
//---------------------
configuration
  <T>
    <threadpool color="red">
      <thread color="red" multiplicity="*">
        <k> $PGM:Proc </k>
      </thread>
    </threadpool>
    <tuplespace color="blue">
      <rpackages>
        <rpackage color="teal" multiplicity="*">
          <receives>
            <receive color="green" multiplicity="*">
              <rchs> .K </rchs>
              <pats> .K </pats>
            </receive>
            <cont>   .K  </cont>
          </receives>
        </rpackage>  
      </rpackages>
      <spackages>
        <spackage color="purple" multiplicity="*">
          <sends>
            <send colr="orange" multiplicity="*">
              <schan> .K </schan>
              <msgs>  .K  </msgs>
            </send>
          </sends>
        </spackage>
      </spackages>
    </tuplespace>
  </T>

//-----------
//--- PAR ---
//-----------
rule <k> P:Proc | Q:Proc => . ...</k>
  (.Bag => <thread> <k> P </k> </thread>)
  (.Bag => <thread> <k> Q </k> </thread>)             [structural]

//------------
//--- SEND ---
//------------
rule <k> X:Name ! ( P:Procs ) => . ...</k>
  (.Bag => <send>
             <schan> X </schan>
             <msgs> @{P}  </msgs>
           </send>)                                   [structural]



endmodule

