// Rholang Configuration

require "domains.k"
require "../AuxFun/auxfun.k"
require "../Names_Variables/namevar.k"
require "../StructuralEquiv/struct.k"
require "../grho.k"

module CONFIG-SYNTAX
  import GRHO-SYNTAX

endmodule

module CONFIG
  import CONFIG-SYNTAX
  import AUXFUN
  import NAMEVAR
  import STRUCT

//---------------------
//--- CONFIGURATION ---
//---------------------
  configuration
    <T color="purple">                                  //
      <activity color="red">                            //**activity threads**
        <task color="green" multiplicity="*">           // collection of concurrent tasks
//        <k> Check_All ~> $PGM:Proc </k>               // check all program execution guards
          <k> #order($PGM:Proc) </k>                    // programs and computations are process-based
        </task>                                         //
      </activity>                                       //**tuplespace**
      <tuplespace color="blue">                         // stores sends and receives
        <sends>                                         //**sends**
          <send color="cyan" multiplicity="*">          //
            .K                                          //
          </send>                                       //
        </sends>                                        //
        <input>                                         //
          <receives>                                    //
            <receive color="yellow" multiplicity="*">   //
              .K                                        //
            </receive>                                  //
          </receives>                                   //
          <sums>                                        //
            <sum multiplicity="*">                      //
              <branches>                                //
                <branch multiplicity="*"> .K </branch>  //
              </branches>                               //
            </sum>                                      //
          </sums>                                       //
        </input>                                        //
      </tuplespace>                                     //
      <nextLoc color="gray"> 0 </nextLoc>               //
      <original color="pink">                           //
        $PGM                                            // parsed original program -- unordered, unidexed
      </original>                                       //
      <OGfreevar color="pink">                          //
        FV($PGM)                                        // set of kind free variables of original program
      </OGfreevar>                                      //
      <OGdeBruijn color="pink">                         //
        #deBruijn(#order($PGM))                         // De Bruijn indexed original program
      </OGdeBruijn>                                     //
    </T>                                                //

/*
// Execution guards
  syntax KItem ::= "Check_All"
  rule (Check_All => Check_FreeVars ~> Check_VarContext) ~> _:Proc

  // Free variable execution guard
  syntax KItem ::= "Check_FreeVars"
                 | "Error: Free Variables!"
  // Remove free variable error guard if program is closed & check variable context
  rule (Check_FreeVars ~> Check_VarContext ~> P:Proc) => #if FV(P) ==K .Set
                                           #then (Check_VarContext ~> P)
                                           #else Error: FreeVars! #fi
// Variable context execution guard
  syntax KItem ::= "Check_VarContext"
                 | "Error: Variable used in both name and process contexts!"
                 | "Error: VarContext!"
// Remove variable context error guard and execute if program is well-formed
  rule <k> (Check_VarContext ~> P:Proc) => #if #VarContext(P) ==K .Set
                                             #then P // TODO: more execution constraints?
                                             #else Error: Variable used in both name and process contexts! #fi
       </k>
*/
// TODO: add other type constraints


endmodule
