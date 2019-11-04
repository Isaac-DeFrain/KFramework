// Rholang Configuration

/*
TODO:
 - contract mapping cell: contract keyword updates map with Name |-> Body & invocation looks up the given contract name add substitutes in provided values for the contract variables
*/

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
          .Set
          // <send color="cyan" multiplicity="*">          //
          //   .K                                          //
          // </send>                                       //
        </sends>                                        //
        <input>                                         //
          <receives>                                    //**receives**
            .Set
            // <receive color="yellow" multiplicity="*">   //
            //   .K                                        //
            // </receive>                                  //
          </receives>                                   //
          <sums>                                        //**selects**
            <sum multiplicity="*">                      //
              <branches>                                //
                <branch multiplicity="*"> .K </branch>  // TODO: may be better as a set of Branches (they should be mutually exclusive anyways)
              </branches>                               //
            </sum>                                      //
          </sums>                                       //
        </input>                                        //
      </tuplespace>                                     //
      <contracts> .Map </contracts>                     // mapping of contract names to bodies: contract
/*
      <registry>
        <contracts>
          <contractName> .Map </contractName>           // map from public contract name to location
          <contractBody> .Map </contractBody>           // map from location to contract body
          <nextContractLoc> 0 </nextContractLoc>        // contract location counter
        </contracts>
        <otherRegistryItems>
        </otherRegistryItems>
      </registry>
*/
      <nextLoc color="gray"> 0 </nextLoc>               // declared variable counter
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
  rule (Check_All => Check_FreeVars ~> Check_Type) ~> _:Proc

  // Free variable execution guard
  syntax KItem ::= "Check_FreeVars"
                 | "Error: Free Variables!"
  // Remove free variable error guard if program is closed & check type
  rule (Check_FreeVars ~> Check_Type ~> P:Proc)
    => #if FV(P) ==K .Set #then (Check_Type ~> Normalize ~> P) #else Error: Free Variables! #fi

  // Type check execution guard
  syntax KItem ::= "Check_Type"
                 | "Error: Invalid Type"
  // Remove type check guard if program is correct & normalize
  rule (Check_Type ~> P:Proc)
    => #if #typeCheck(P) #then #order(P) #else Error: Invalid Type #fi // TODO: #typeCheck
*/

endmodule
