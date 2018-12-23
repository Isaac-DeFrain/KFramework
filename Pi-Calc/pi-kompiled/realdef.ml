open Prelude
open Constants
open Constants.K
module Def = struct
let freshFunction (sort: string) (config: k) (counter: Z.t) : k = interned_bottom
let eval_ProcCellBag_ (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_ProcCellBag_ and sort = 
SortProcCellBag in match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisK (c: k) (config: k) (guard: int) : k = let lbl = 
LblisK and sort = 
SortBool in match c with 
| [_] -> [Bool true] | _ -> [Bool false]
| [List (s,_,_)] when (s = SortList) -> [Bool true]
| [String _] -> [Bool true]
| [Bool _] -> [Bool true]
| _ -> [Bool true]
| [Map (s,_,_)] when (s = SortMap) -> [Bool true]
| [Int _] -> [Bool true]
| [Float _] -> [Bool true]
| [Set (s,_,_)] when (s = SortSet) -> [Bool true]
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisBoundCellBag (c: k) (config: k) (guard: int) : k = let lbl = 
LblisBoundCellBag and sort = 
SortBool in match c with 
(*{| rule ``isBoundCellBag(#KToken(#token("BoundCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortBoundCell, var__0) :: [])) -> ((Bool true) :: [])
(*{| rule ``isBoundCellBag(`<bound>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'bound'_GT_',(varK0_1)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isBoundCellBag(#KToken(#token("BoundCellBag","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortBoundCellBag, var__2) :: [])) -> ((Bool true) :: [])
(*{| rule ``isBoundCellBag(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_3)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisBoundsCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisBoundsCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isBoundsCellOpt(noBoundsCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoBoundsCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isBoundsCellOpt(`<bounds>`(K0))=>#token("true","Bool")`` requires isBoundCellBag(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'bounds'_GT_',(varK0_4 :: [])) :: [])) when (isTrue (evalisBoundCellBag((varK0_4 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isBoundsCellOpt(#KToken(#token("BoundsCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortBoundsCellOpt, var__5) :: [])) -> ((Bool true) :: [])
(*{| rule ``isBoundsCellOpt(#KToken(#token("BoundsCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortBoundsCell, var__6) :: [])) -> ((Bool true) :: [])
(*{| rule ``isBoundsCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_7)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisSummandCellBag (c: k) (config: k) (guard: int) : k = let lbl = 
LblisSummandCellBag and sort = 
SortBool in match c with 
(*{| rule ``isSummandCellBag(#KToken(#token("SummandCellBag","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSummandCellBag, var__8) :: [])) -> ((Bool true) :: [])
(*{| rule ``isSummandCellBag(`<summand>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'summand'_GT_',(varK0_9)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isSummandCellBag(#KToken(#token("SummandCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSummandCell, var__10) :: [])) -> ((Bool true) :: [])
(*{| rule ``isSummandCellBag(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_11)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalnotBool_ (c: k) (config: k) (guard: int) : k = let lbl = 
LblnotBool_ and sort = 
SortBool in match c with 
| _ -> try BOOL.hook_not c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `notBool_`(#token("true","Bool"))=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(de18dba5cb1b6e56941a63279edb1d16da29d7a997a3e82cbc2b81b066eadf47) contentStartColumn(8) contentStartLine(299) org.kframework.attributes.Location(Location(299,8,299,29)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool true) :: [])) -> ((Bool false) :: [])
(*{| rule `` `notBool_`(#token("false","Bool"))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(dbe4d83961158619e994f90623f08be11020d80c56685ef1ec2dd2b15760c474) contentStartColumn(8) contentStartLine(300) org.kframework.attributes.Location(Location(300,8,300,29)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool false) :: [])) -> ((Bool true) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_'_LT_Eqls'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'_LT_Eqls'Int__INT and sort = 
SortBool in match c with 
| _ -> try INT.hook_le c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalId2String (c: k) (config: k) (guard: int) : k = let lbl = 
LblId2String and sort = 
SortString in match c with 
| _ -> try STRING.hook_token2string c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalMap'Coln'lookup (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblMap'Coln'lookup and sort = 
SortKItem in match c with 
| _ -> try MAP.hook_lookup c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisInt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisInt and sort = 
SortBool in match c with 
| [Int _] -> [Bool true]
(*{| rule ``isInt(#KToken(#token("Int","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortInt, var__12) :: [])) -> ((Bool true) :: [])
(*{| rule ``isInt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_13)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_'EqlsEqls'K_ (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'EqlsEqls'K_ and sort = 
SortBool in match c with 
| _ -> try KEQUAL.hook_eq c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisBool (c: k) (config: k) (guard: int) : k = let lbl = 
LblisBool and sort = 
SortBool in match c with 
| [Bool _] -> [Bool true]
(*{| rule ``isBool(#KToken(#token("Bool","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortBool, var__14) :: [])) -> ((Bool true) :: [])
(*{| rule ``isBool(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_15)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_andBool_ (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_andBool_ and sort = 
SortBool in match c with 
| _ -> try BOOL.hook_and c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_andBool_`(#token("true","Bool"),B)=>B`` requires isBool(B) ensures #token("true","Bool") [UNIQUE_ID(cd0a9b340fae24c9a05126d8df860cb7145fc64875711e36efaa694085559dc0) contentStartColumn(8) contentStartLine(302) org.kframework.attributes.Location(Location(302,8,302,37)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool true) :: []),((Bool _ as varB_16) :: [])) when true && (true) -> (varB_16 :: [])
(*{| rule `` `_andBool_`(B,#token("true","Bool"))=>B`` requires isBool(B) ensures #token("true","Bool") [UNIQUE_ID(b598bf51d1c959b7112e06b7f85a391ee5a18108acd52bb65ea27ef0381ed0e0) contentStartColumn(8) contentStartLine(303) org.kframework.attributes.Location(Location(303,8,303,37)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool _ as varB_17) :: []),((Bool true) :: [])) when true && (true) -> (varB_17 :: [])
(*{| rule `` `_andBool_`(_4,#token("false","Bool"))=>#token("false","Bool")`` requires isBool(_4) ensures #token("true","Bool") [UNIQUE_ID(1a7512841ede635d09556466797d23f3f3cec57fe0fb6a68ce0c3a1cccb0b68f) contentStartColumn(8) contentStartLine(305) org.kframework.attributes.Location(Location(305,8,305,37)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool _ as var_4_18) :: []),((Bool false) :: [])) when true && (true) -> ((Bool false) :: [])
(*{| rule `` `_andBool_`(#token("false","Bool"),_9)=>#token("false","Bool")`` requires isBool(_9) ensures #token("true","Bool") [UNIQUE_ID(e6ebe927ba416a1602679eb0166f22d394adf70452e0505c00f11c036a896253) contentStartColumn(8) contentStartLine(304) org.kframework.attributes.Location(Location(304,8,304,37)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool false) :: []),((Bool _ as var_9_19) :: [])) when true && (true) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'EqlsEqls'Bool__BOOL (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'EqlsEqls'Bool__BOOL and sort = 
SortBool in match c with 
| _ -> try BOOL.hook_eq c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_==Bool__BOOL`(K1,K2)=>`_==K_`(K1,K2)`` requires `_andBool_`(isBool(K1),isBool(K2)) ensures #token("true","Bool") [UNIQUE_ID(a17699668426366833f88851c95d611be854ecef7a676d2061669bf689f05fd1) contentStartColumn(8) contentStartLine(765) org.kframework.attributes.Location(Location(765,8,765,43)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool _ as varK1_20) :: []),((Bool _ as varK2_21) :: [])) when ((true) && (true)) && (true) -> ((eval_'EqlsEqls'K_((varK1_20 :: []),(varK2_21 :: [])) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'Hyph'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'Hyph'Int__INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_sub c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'Perc'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'Perc'Int__INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_tmod c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'Plus'Int_ (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'Plus'Int_ and sort = 
SortInt in match c with 
| _ -> try INT.hook_add c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalabsInt (c: k) (config: k) (guard: int) : k = let lbl = 
LblabsInt and sort = 
SortInt in match c with 
| _ -> try INT.hook_abs c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_'EqlsEqls'Int_ (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'EqlsEqls'Int_ and sort = 
SortBool in match c with 
| _ -> try INT.hook_eq c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_==Int_`(I1,I2)=>`_==K_`(I1,I2)`` requires `_andBool_`(isInt(I1),isInt(I2)) ensures #token("true","Bool") [UNIQUE_ID(e92e4aa4a18bee70f2627cdafb8687e2dfcc0dd6a7f8cbb8d1bd17d751c2da2a) contentStartColumn(8) contentStartLine(407) org.kframework.attributes.Location(Location(407,8,407,40)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Int _ as varI1_22) :: []),((Int _ as varI2_23) :: [])) when ((true) && (true)) && (true) -> ((eval_'EqlsEqls'K_((varI1_22 :: []),(varI2_23 :: [])) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'EqlsSlshEqls'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'EqlsSlshEqls'Int__INT and sort = 
SortBool in match c with 
| _ -> try INT.hook_ne c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_=/=Int__INT`(I1,I2)=>`notBool_`(`_==Int_`(I1,I2))`` requires `_andBool_`(isInt(I1),isInt(I2)) ensures #token("true","Bool") [UNIQUE_ID(59ca895589d5fc7fa573380dac68ddd6602f6fa8b2761530a861aa894455f27e) contentStartColumn(8) contentStartLine(408) org.kframework.attributes.Location(Location(408,8,408,53)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Int _ as varI1_24) :: []),((Int _ as varI2_25) :: [])) when ((true) && (true)) && (true) -> ([Bool ((not ((isTrue (eval_'EqlsEqls'Int_((varI1_24 :: []),(varI2_25 :: [])) config (-1))))))])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_modInt__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_modInt__INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_emod c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_modInt__INT`(I1,I2)=>`_%Int__INT`(`_+Int_`(`_%Int__INT`(I1,absInt(I2)),absInt(I2)),absInt(I2))`` requires `_andBool_`(`_andBool_`(isInt(I1),isInt(I2)),`_=/=Int__INT`(I2,#token("0","Int"))) ensures #token("true","Bool") [UNIQUE_ID(fb4bf5b2f12862af75611e525d51d7e1966bcc322ee8456d2ed1cdaadf02f6f5) concrete() contentStartColumn(5) contentStartLine(391) org.kframework.attributes.Location(Location(391,5,394,23)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
| (((Int _ as varI1_26) :: []),((Int _ as varI2_27) :: [])) when ((((true) && (true))) && ((isTrue (eval_'EqlsSlshEqls'Int__INT((varI2_27 :: []),((Lazy.force int0) :: [])) config (-1))))) && (true) -> ((eval_'Perc'Int__INT(((eval_'Plus'Int_(((eval_'Perc'Int__INT((varI1_26 :: []),((evalabsInt((varI2_27 :: [])) config (-1)))) config (-1))),((evalabsInt((varI2_27 :: [])) config (-1)))) config (-1))),((evalabsInt((varI2_27 :: [])) config (-1)))) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'_GT__GT_'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'_GT__GT_'Int__INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_shr c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'_LT__LT_'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'_LT__LT_'Int__INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_shl c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalbitRangeInt (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
LblbitRangeInt and sort = 
SortInt in match c with 
| _ -> try INT.hook_bitRange c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule ``bitRangeInt(I,IDX,LEN)=>`_modInt__INT`(`_>>Int__INT`(I,IDX),`_<<Int__INT`(#token("1","Int"),LEN))`` requires `_andBool_`(`_andBool_`(isInt(I),isInt(LEN)),isInt(IDX)) ensures #token("true","Bool") [UNIQUE_ID(08ec18eb216a86553c22eacaaf8b628b19097a5f4dbbbbb68a5daa77c9337449) contentStartColumn(8) contentStartLine(384) org.kframework.attributes.Location(Location(384,8,384,70)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Int _ as varI_28) :: []),((Int _ as varIDX_29) :: []),((Int _ as varLEN_30) :: [])) when ((((true) && (true))) && (true)) && (true) -> ((eval_modInt__INT(((eval_'_GT__GT_'Int__INT((varI_28 :: []),(varIDX_29 :: [])) config (-1))),((eval_'_LT__LT_'Int__INT(((Lazy.force int1) :: []),(varLEN_30 :: [])) config (-1)))) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let evalsignExtendBitRangeInt (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
LblsignExtendBitRangeInt and sort = 
SortInt in match c with 
| _ -> try INT.hook_signExtendBitRange c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule ``signExtendBitRangeInt(I,IDX,LEN)=>`_-Int__INT`(`_modInt__INT`(`_+Int_`(bitRangeInt(I,IDX,LEN),`_<<Int__INT`(#token("1","Int"),`_-Int__INT`(LEN,#token("1","Int")))),`_<<Int__INT`(#token("1","Int"),LEN)),`_<<Int__INT`(#token("1","Int"),`_-Int__INT`(LEN,#token("1","Int"))))`` requires `_andBool_`(`_andBool_`(isInt(I),isInt(LEN)),isInt(IDX)) ensures #token("true","Bool") [UNIQUE_ID(b413c3f4500443aec69bee9b10feb030330d60bd136c698a9947546393728a00) contentStartColumn(8) contentStartLine(386) org.kframework.attributes.Location(Location(386,8,386,149)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Int _ as varI_31) :: []),((Int _ as varIDX_32) :: []),((Int _ as varLEN_33) :: [])) when ((((true) && (true))) && (true)) && (true) -> ((eval_'Hyph'Int__INT(((eval_modInt__INT(((eval_'Plus'Int_(((evalbitRangeInt((varI_31 :: []),(varIDX_32 :: []),(varLEN_33 :: [])) config (-1))),((eval_'_LT__LT_'Int__INT(((Lazy.force int1) :: []),((eval_'Hyph'Int__INT((varLEN_33 :: []),((Lazy.force int1) :: [])) config (-1)))) config (-1)))) config (-1))),((eval_'_LT__LT_'Int__INT(((Lazy.force int1) :: []),(varLEN_33 :: [])) config (-1)))) config (-1))),((eval_'_LT__LT_'Int__INT(((Lazy.force int1) :: []),((eval_'Hyph'Int__INT((varLEN_33 :: []),((Lazy.force int1) :: [])) config (-1)))) config (-1)))) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let evalisSet (c: k) (config: k) (guard: int) : k = let lbl = 
LblisSet and sort = 
SortBool in match c with 
| [Set (s,_,_)] when (s = SortSet) -> [Bool true]
(*{| rule ``isSet(#KToken(#token("Set","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSet, var__34) :: [])) -> ((Bool true) :: [])
(*{| rule ``isSet(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_35)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalMap'Coln'choice (c: k) (config: k) (guard: int) : k = let lbl = 
LblMap'Coln'choice and sort = 
SortKItem in match c with 
| _ -> try MAP.hook_choice c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisKCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisKCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isKCellOpt(#KToken(#token("KCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortKCellOpt, var__36) :: [])) -> ((Bool true) :: [])
(*{| rule ``isKCellOpt(#KToken(#token("KCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortKCell, var__37) :: [])) -> ((Bool true) :: [])
(*{| rule ``isKCellOpt(`<k>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'k'_GT_',(varK0_38)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isKCellOpt(noKCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoKCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isKCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_39)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisSumCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisSumCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isSumCellOpt(#KToken(#token("SumCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSumCell, var__40) :: [])) -> ((Bool true) :: [])
(*{| rule ``isSumCellOpt(`<sum>`(K0))=>#token("true","Bool")`` requires isSummandCellBag(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'sum'_GT_',(varK0_41 :: [])) :: [])) when (isTrue (evalisSummandCellBag((varK0_41 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isSumCellOpt(#KToken(#token("SumCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSumCellOpt, var__42) :: [])) -> ((Bool true) :: [])
(*{| rule ``isSumCellOpt(noSumCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoSumCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isSumCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_43)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisProcCellFragment (c: k) (config: k) (guard: int) : k = let lbl = 
LblisProcCellFragment and sort = 
SortBool in match c with 
(*{| rule ``isProcCellFragment(#KToken(#token("ProcCellFragment","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortProcCellFragment, var__44) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProcCellFragment(`<proc>-fragment`(K0,K1,K2))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(isKCellOpt(K0),isBoundsCellOpt(K1)),isSumCellOpt(K2)) ensures #token("true","Bool") []|}*)
| ((KApply3(Lbl'_LT_'proc'_GT_Hyph'fragment,(varK0_45 :: []),(varK1_46 :: []),(varK2_47 :: [])) :: [])) when (((((isTrue (evalisKCellOpt((varK0_45 :: [])) config (-1)))) && ((isTrue (evalisBoundsCellOpt((varK1_46 :: [])) config (-1)))))) && ((isTrue (evalisSumCellOpt((varK2_47 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProcCellFragment(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_48)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalintersectSet (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblintersectSet and sort = 
SortSet in match c with 
| _ -> try SET.hook_intersection c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_in_keys'LPar'_'RPar'_MAP (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_in_keys'LPar'_'RPar'_MAP and sort = 
SortBool in match c with 
| _ -> try MAP.hook_in_keys c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_impliesBool__BOOL (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_impliesBool__BOOL and sort = 
SortBool in match c with 
| _ -> try BOOL.hook_implies c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_impliesBool__BOOL`(_2,#token("true","Bool"))=>#token("true","Bool")`` requires isBool(_2) ensures #token("true","Bool") [UNIQUE_ID(7fdeea13463fa86d05e4d5bfb9e9c627b90ab57930f712fef1bfc08543a87d74) contentStartColumn(8) contentStartLine(329) org.kframework.attributes.Location(Location(329,8,329,39)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool _ as var_2_49) :: []),((Bool true) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule `` `_impliesBool__BOOL`(B,#token("false","Bool"))=>`notBool_`(B)`` requires isBool(B) ensures #token("true","Bool") [UNIQUE_ID(0129e06009c7500aefab482e1bc8e348010c6bd01acd15725172192c05a70831) contentStartColumn(8) contentStartLine(330) org.kframework.attributes.Location(Location(330,8,330,45)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool _ as varB_50) :: []),((Bool false) :: [])) when true && (true) -> ([Bool ((not ((isTrue [varB_50]))))])
(*{| rule `` `_impliesBool__BOOL`(#token("false","Bool"),_7)=>#token("true","Bool")`` requires isBool(_7) ensures #token("true","Bool") [UNIQUE_ID(3497d026ef9468fdac7e6b5de6841fad0118b17ca073ba25af4c5d8573a167b2) contentStartColumn(8) contentStartLine(328) org.kframework.attributes.Location(Location(328,8,328,40)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool false) :: []),((Bool _ as var_7_51) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule `` `_impliesBool__BOOL`(#token("true","Bool"),B)=>B`` requires isBool(B) ensures #token("true","Bool") [UNIQUE_ID(278435b95efb1a1ce04f6d701b12e6438c3cf3aee8019b41ea93b05755d379d7) contentStartColumn(8) contentStartLine(327) org.kframework.attributes.Location(Location(327,8,327,36)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool true) :: []),((Bool _ as varB_52) :: [])) when true && (true) -> (varB_52 :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_Set_ (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_Set_ and sort = 
SortSet in match c with 
| _ -> try SET.hook_concat c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisString (c: k) (config: k) (guard: int) : k = let lbl = 
LblisString and sort = 
SortBool in match c with 
| [String _] -> [Bool true]
(*{| rule ``isString(#KToken(#token("String","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortString, var__53) :: [])) -> ((Bool true) :: [])
(*{| rule ``isString(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_54)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Hash'if_'Hash'then_'Hash'else_'Hash'fi_K'Hyph'EQUAL (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'if_'Hash'then_'Hash'else_'Hash'fi_K'Hyph'EQUAL and sort = 
SortK in match c with 
| _ -> try KEQUAL.hook_ite c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `#if_#then_#else_#fi_K-EQUAL`(C,B1,_10)=>B1`` requires `_andBool_`(isBool(C),C) ensures #token("true","Bool") [UNIQUE_ID(0883a4d4051090478d6b8a7ac8d4e0e15e7708308fa24e63137b9ac7e87383aa) contentStartColumn(8) contentStartLine(769) org.kframework.attributes.Location(Location(769,8,769,56)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
| (((Bool _ as varC_55) :: []),(varB1_56),(var_10_57)) when ((true) && ((isTrue [varC_55]))) && (true) -> (varB1_56)
(*{| rule `` `#if_#then_#else_#fi_K-EQUAL`(C,_11,B2)=>B2`` requires `_andBool_`(isBool(C),`notBool_`(C)) ensures #token("true","Bool") [UNIQUE_ID(d46b5ae094d17de19ef9725da497c32e21813c6e4b5a0d6a2c4b03bd55bb312c) contentStartColumn(8) contentStartLine(770) org.kframework.attributes.Location(Location(770,8,770,64)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
| (((Bool _ as varC_58) :: []),(var_11_59),(varB2_60)) when ((true) && ((not ((isTrue [varC_58]))))) && (true) -> (varB2_60)
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let evalfindString (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
LblfindString and sort = 
SortInt in match c with 
| _ -> try STRING.hook_find c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let evalsubstrString (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
LblsubstrString and sort = 
SortString in match c with 
| _ -> try STRING.hook_substr c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let evallengthString (c: k) (config: k) (guard: int) : k = let lbl = 
LbllengthString and sort = 
SortInt in match c with 
| _ -> try STRING.hook_length c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_'_GT_Eqls'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'_GT_Eqls'Int__INT and sort = 
SortBool in match c with 
| _ -> try INT.hook_ge c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalminInt'LPar'_'Comm'_'RPar'_INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblminInt'LPar'_'Comm'_'RPar'_INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_min c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `minInt(_,_)_INT`(I1,I2)=>I1`` requires `_andBool_`(`_andBool_`(isInt(I1),isInt(I2)),`_<=Int__INT`(I1,I2)) ensures #token("true","Bool") [UNIQUE_ID(c3daf36ef673ae6ce68430bc5170ec91b3d397f5f3e34aee375a841739bcfc9b) contentStartColumn(8) contentStartLine(396) org.kframework.attributes.Location(Location(396,8,396,57)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
| (((Int _ as varI1_61) :: []),((Int _ as varI2_62) :: [])) when ((((true) && (true))) && ((isTrue (eval_'_LT_Eqls'Int__INT((varI1_61 :: []),(varI2_62 :: [])) config (-1))))) && (true) -> (varI1_61 :: [])
(*{| rule `` `minInt(_,_)_INT`(I1,I2)=>I2`` requires `_andBool_`(`_andBool_`(isInt(I1),isInt(I2)),`_>=Int__INT`(I1,I2)) ensures #token("true","Bool") [UNIQUE_ID(f93c59dd0bdb46ab467898db4ad231d94d30e5b88427054becac14f3969eff8e) contentStartColumn(8) contentStartLine(397) org.kframework.attributes.Location(Location(397,8,397,57)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
| (((Int _ as varI1_63) :: []),((Int _ as varI2_64) :: [])) when ((((true) && (true))) && ((isTrue (eval_'_GT_Eqls'Int__INT((varI1_63 :: []),(varI2_64 :: [])) config (-1))))) && (true) -> (varI2_64 :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'EqlsEqls'String__STRING (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'EqlsEqls'String__STRING and sort = 
SortBool in match c with 
| _ -> try STRING.hook_eq c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_==String__STRING`(S1,S2)=>`_==K_`(S1,S2)`` requires `_andBool_`(isString(S2),isString(S1)) ensures #token("true","Bool") [UNIQUE_ID(daddd877c886e178648c9a2a7a5b307a0f59225ac211c099829b467bb5ebf98d) contentStartColumn(8) contentStartLine(537) org.kframework.attributes.Location(Location(537,8,537,49)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((String _ as varS1_65) :: []),((String _ as varS2_66) :: [])) when ((true) && (true)) && (true) -> ((eval_'EqlsEqls'K_((varS1_65 :: []),(varS2_66 :: [])) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'EqlsSlshEqls'String__STRING (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'EqlsSlshEqls'String__STRING and sort = 
SortBool in match c with 
| _ -> try STRING.hook_ne c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_=/=String__STRING`(S1,S2)=>`notBool_`(`_==String__STRING`(S1,S2))`` requires `_andBool_`(isString(S2),isString(S1)) ensures #token("true","Bool") [UNIQUE_ID(2a5c8974455ca9cde473273aeca1a4fa8072aa68d104bc94daa71ee7bf52c8a4) contentStartColumn(8) contentStartLine(536) org.kframework.attributes.Location(Location(536,8,536,65)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((String _ as varS1_67) :: []),((String _ as varS2_68) :: [])) when ((true) && (true)) && (true) -> ([Bool ((not ((isTrue (eval_'EqlsEqls'String__STRING((varS1_67 :: []),(varS2_68 :: [])) config (-1))))))])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let rec evalfindChar (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
LblfindChar and sort = 
SortInt in match c with 
| _ -> try STRING.hook_findChar c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule ``findChar(_13,#token("\"\"","String"),_14)=>#token("-1","Int")`` requires `_andBool_`(isInt(_14),isString(_13)) ensures #token("true","Bool") [UNIQUE_ID(3c92cdc7bbe8b210d199a92b38a24538ca780f801572b653c3cb72d6d89a2adf) contentStartColumn(8) contentStartLine(554) org.kframework.attributes.Location(Location(554,8,554,32)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((String _ as var_13_69) :: []),((String "") :: []),((Int _ as var_14_70) :: [])) when ((true) && (true)) && (true) -> ((Lazy.force int'Hyph'1) :: [])
(*{| rule ``findChar(S1,S2,I)=>`#if_#then_#else_#fi_K-EQUAL`(`_==Int_`(findString(S1,substrString(S2,#token("0","Int"),#token("1","Int")),I),#token("-1","Int")),findChar(S1,substrString(S2,#token("1","Int"),lengthString(S2)),I),`#if_#then_#else_#fi_K-EQUAL`(`_==Int_`(findChar(S1,substrString(S2,#token("1","Int"),lengthString(S2)),I),#token("-1","Int")),findString(S1,substrString(S2,#token("0","Int"),#token("1","Int")),I),`minInt(_,_)_INT`(findString(S1,substrString(S2,#token("0","Int"),#token("1","Int")),I),findChar(S1,substrString(S2,#token("1","Int"),lengthString(S2)),I))))`` requires `_andBool_`(`_andBool_`(`_andBool_`(isInt(I),isString(S2)),isString(S1)),`_=/=String__STRING`(S2,#token("\"\"","String"))) ensures #token("true","Bool") [UNIQUE_ID(5a89a8f3b78438530e84da3913f33203b224f3c348d32f09785edd80c9cfe137) contentStartColumn(8) contentStartLine(553) org.kframework.attributes.Location(Location(553,8,553,431)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
| (((String _ as varS1_71) :: []),((String _ as varS2_72) :: []),((Int _ as varI_73) :: [])) when ((((((true) && (true))) && (true))) && ((isTrue (eval_'EqlsSlshEqls'String__STRING((varS2_72 :: []),((String "") :: [])) config (-1))))) && (true) -> ((if ((isTrue (eval_'EqlsEqls'Int_(((evalfindString((varS1_71 :: []),((evalsubstrString((varS2_72 :: []),((Lazy.force int0) :: []),((Lazy.force int1) :: [])) config (-1))),(varI_73 :: [])) config (-1))),((Lazy.force int'Hyph'1) :: [])) config (-1)))) then (((evalfindChar((varS1_71 :: []),((evalsubstrString((varS2_72 :: []),((Lazy.force int1) :: []),((evallengthString((varS2_72 :: [])) config (-1)))) config (-1))),(varI_73 :: [])) config (-1)))) else (((if ((isTrue (eval_'EqlsEqls'Int_(((evalfindChar((varS1_71 :: []),((evalsubstrString((varS2_72 :: []),((Lazy.force int1) :: []),((evallengthString((varS2_72 :: [])) config (-1)))) config (-1))),(varI_73 :: [])) config (-1))),((Lazy.force int'Hyph'1) :: [])) config (-1)))) then (((evalfindString((varS1_71 :: []),((evalsubstrString((varS2_72 :: []),((Lazy.force int0) :: []),((Lazy.force int1) :: [])) config (-1))),(varI_73 :: [])) config (-1)))) else (((evalminInt'LPar'_'Comm'_'RPar'_INT(((evalfindString((varS1_71 :: []),((evalsubstrString((varS2_72 :: []),((Lazy.force int0) :: []),((Lazy.force int1) :: [])) config (-1))),(varI_73 :: [])) config (-1))),((evalfindChar((varS1_71 :: []),((evalsubstrString((varS2_72 :: []),((Lazy.force int1) :: []),((evallengthString((varS2_72 :: [])) config (-1)))) config (-1))),(varI_73 :: [])) config (-1)))) config (-1)))))))))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let eval_'Star'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'Star'Int__INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_mul c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalSet'Coln'in (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblSet'Coln'in and sort = 
SortBool in match c with 
| _ -> try SET.hook_in c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalString2Int (c: k) (config: k) (guard: int) : k = let lbl = 
LblString2Int and sort = 
SortInt in match c with 
| _ -> try STRING.hook_string2int c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalmaxInt'LPar'_'Comm'_'RPar'_INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblmaxInt'LPar'_'Comm'_'RPar'_INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_max c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'_LT_Eqls'Set__SET (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'_LT_Eqls'Set__SET and sort = 
SortBool in match c with 
| _ -> try SET.hook_inclusion c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval'Tild'Int__INT (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Tild'Int__INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_not c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_'_LT_'String__STRING (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'_LT_'String__STRING and sort = 
SortBool in match c with 
| _ -> try STRING.hook_lt c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'_LT_Eqls'String__STRING (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'_LT_Eqls'String__STRING and sort = 
SortBool in match c with 
| _ -> try STRING.hook_le c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_<=String__STRING`(S1,S2)=>`notBool_`(`_<String__STRING`(S2,S1))`` requires `_andBool_`(isString(S2),isString(S1)) ensures #token("true","Bool") [UNIQUE_ID(2c1110a97c0d904a19992e4eac695692515cb703f5d689aaa6945290a696d662) contentStartColumn(8) contentStartLine(549) org.kframework.attributes.Location(Location(549,8,549,63)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((String _ as varS1_74) :: []),((String _ as varS2_75) :: [])) when ((true) && (true)) && (true) -> ([Bool ((not ((isTrue (eval_'_LT_'String__STRING((varS2_75 :: []),(varS1_74 :: [])) config (-1))))))])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalordChar (c: k) (config: k) (guard: int) : k = let lbl = 
LblordChar and sort = 
SortInt in match c with 
| _ -> try STRING.hook_ord c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalrfindString (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
LblrfindString and sort = 
SortInt in match c with 
| _ -> try STRING.hook_rfind c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let rec evalrfindChar (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
LblrfindChar and sort = 
SortInt in match c with 
| _ -> try STRING.hook_rfindChar c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule ``rfindChar(S1,S2,I)=>`maxInt(_,_)_INT`(rfindString(S1,substrString(S2,#token("0","Int"),#token("1","Int")),I),rfindChar(S1,substrString(S2,#token("1","Int"),lengthString(S2)),I))`` requires `_andBool_`(`_andBool_`(`_andBool_`(isInt(I),isString(S2)),isString(S1)),`_=/=String__STRING`(S2,#token("\"\"","String"))) ensures #token("true","Bool") [UNIQUE_ID(dea96adb63c0d77626a51f08fb7a6daf76e3a7b8d0205f5285542c1160f2ddeb) contentStartColumn(8) contentStartLine(555) org.kframework.attributes.Location(Location(555,8,555,182)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
| (((String _ as varS1_76) :: []),((String _ as varS2_77) :: []),((Int _ as varI_78) :: [])) when ((((((true) && (true))) && (true))) && ((isTrue (eval_'EqlsSlshEqls'String__STRING((varS2_77 :: []),((String "") :: [])) config (-1))))) && (true) -> ((evalmaxInt'LPar'_'Comm'_'RPar'_INT(((evalrfindString((varS1_76 :: []),((evalsubstrString((varS2_77 :: []),((Lazy.force int0) :: []),((Lazy.force int1) :: [])) config (-1))),(varI_78 :: [])) config (-1))),((evalrfindChar((varS1_76 :: []),((evalsubstrString((varS2_77 :: []),((Lazy.force int1) :: []),((evallengthString((varS2_77 :: [])) config (-1)))) config (-1))),(varI_78 :: [])) config (-1)))) config (-1)))
(*{| rule ``rfindChar(_15,#token("\"\"","String"),_16)=>#token("-1","Int")`` requires `_andBool_`(isInt(_16),isString(_15)) ensures #token("true","Bool") [UNIQUE_ID(04cb290eea9d7c93a48f761cab20217a689222a306098df1120917b013944330) contentStartColumn(8) contentStartLine(556) org.kframework.attributes.Location(Location(556,8,556,33)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((String _ as var_15_79) :: []),((String "") :: []),((Int _ as var_16_80) :: [])) when ((true) && (true)) && (true) -> ((Lazy.force int'Hyph'1) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let evalmakeList (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblmakeList and sort = 
SortList in match c with 
| _ -> try LIST.hook_make c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'LSqB'_'_LT_Hyph'undef'RSqB' (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'LSqB'_'_LT_Hyph'undef'RSqB' and sort = 
SortMap in match c with 
| _ -> try MAP.hook_remove c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_Map_ (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_Map_ and sort = 
SortMap in match c with 
| _ -> try MAP.hook_concat c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisName (c: k) (config: k) (guard: int) : k = let lbl = 
LblisName and sort = 
SortBool in match c with 
(*{| rule ``isName(#KToken(#token("Name","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortName, var__81) :: [])) -> ((Bool true) :: [])
(*{| rule ``isName(#KToken(#token("Id","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortId, var__82) :: [])) -> ((Bool true) :: [])
(*{| rule ``isName(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_83)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let rec evalisProc (c: k) (config: k) (guard: int) : k = let lbl = 
LblisProc and sort = 
SortBool in match c with 
(*{| rule ``isProc(`Nil_PI-SYNTAX`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblNil_PI'Hyph'SYNTAX) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProc(#KToken(#token("Proc","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortProc, var__84) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProc(`Or`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isNormProc(K0),isNormProc(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(LblOr,(varK0_85 :: []),(varK1_86 :: [])) :: [])) when (((isTrue (evalisNormProc((varK0_85 :: [])) config (-1)))) && ((isTrue (evalisNormProc((varK1_86 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProc(`New`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isName(K0),isProc(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(LblNew,(varK0_87 :: []),(varK1_88 :: [])) :: [])) when (((isTrue (evalisName((varK0_87 :: [])) config (-1)))) && ((isTrue (evalisProc((varK1_88 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProc(#KToken(#token("NormProc","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortNormProc, var__89) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProc(`Par`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isProc(K0),isProc(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(LblPar,(varK0_90 :: []),(varK1_91 :: [])) :: [])) when (((isTrue (evalisProc((varK0_90 :: [])) config (-1)))) && ((isTrue (evalisProc((varK1_91 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProc(`Receive`(K0,K1,K2))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(isName(K0),isName(K1)),isProc(K2)) ensures #token("true","Bool") []|}*)
| ((KApply3(LblReceive,(varK0_92 :: []),(varK1_93 :: []),(varK2_94 :: [])) :: [])) when (((((isTrue (evalisName((varK0_92 :: [])) config (-1)))) && ((isTrue (evalisName((varK1_93 :: [])) config (-1)))))) && ((isTrue (evalisProc((varK2_94 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProc(`Send`(K0,K1,K2))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(isName(K0),isName(K1)),isProc(K2)) ensures #token("true","Bool") []|}*)
| ((KApply3(LblSend,(varK0_95 :: []),(varK1_96 :: []),(varK2_97 :: [])) :: [])) when (((((isTrue (evalisName((varK0_95 :: [])) config (-1)))) && ((isTrue (evalisName((varK1_96 :: [])) config (-1)))))) && ((isTrue (evalisProc((varK2_97 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProc(`Replication`(K0))=>#token("true","Bool")`` requires isProc(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(LblReplication,(varK0_98 :: [])) :: [])) when (isTrue (evalisProc((varK0_98 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProc(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_99)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
and evalisNormProc (c: k) (config: k) (guard: int) : k = let lbl = 
LblisNormProc and sort = 
SortBool in match c with 
(*{| rule ``isNormProc(`Send`(K0,K1,K2))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(isName(K0),isName(K1)),isProc(K2)) ensures #token("true","Bool") []|}*)
| ((KApply3(LblSend,(varK0_100 :: []),(varK1_101 :: []),(varK2_102 :: [])) :: [])) when (((((isTrue (evalisName((varK0_100 :: [])) config (-1)))) && ((isTrue (evalisName((varK1_101 :: [])) config (-1)))))) && ((isTrue (evalisProc((varK2_102 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isNormProc(`Nil_PI-SYNTAX`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblNil_PI'Hyph'SYNTAX) :: [])) -> ((Bool true) :: [])
(*{| rule ``isNormProc(`Receive`(K0,K1,K2))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(isName(K0),isName(K1)),isProc(K2)) ensures #token("true","Bool") []|}*)
| ((KApply3(LblReceive,(varK0_103 :: []),(varK1_104 :: []),(varK2_105 :: [])) :: [])) when (((((isTrue (evalisName((varK0_103 :: [])) config (-1)))) && ((isTrue (evalisName((varK1_104 :: [])) config (-1)))))) && ((isTrue (evalisProc((varK2_105 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isNormProc(#KToken(#token("NormProc","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortNormProc, var__106) :: [])) -> ((Bool true) :: [])
(*{| rule ``isNormProc(`Or`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isNormProc(K0),isNormProc(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(LblOr,(varK0_107 :: []),(varK1_108 :: [])) :: [])) when (((isTrue (evalisNormProc((varK0_107 :: [])) config (-1)))) && ((isTrue (evalisNormProc((varK1_108 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isNormProc(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_109)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_andThenBool__BOOL (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_andThenBool__BOOL and sort = 
SortBool in match c with 
| _ -> try BOOL.hook_andThen c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_andThenBool__BOOL`(#token("true","Bool"),K)=>K`` requires isBool(K) ensures #token("true","Bool") [UNIQUE_ID(b058439c1adf0de5fb7afd07d638d2cda247a4344cbdc14812da46c5db5499df) contentStartColumn(8) contentStartLine(307) org.kframework.attributes.Location(Location(307,8,307,37)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool true) :: []),((Bool _ as varK_110) :: [])) when true && (true) -> (varK_110 :: [])
(*{| rule `` `_andThenBool__BOOL`(K,#token("true","Bool"))=>K`` requires isBool(K) ensures #token("true","Bool") [UNIQUE_ID(1aad8125a2ba7fcbd3c40ac487b7dc776993e9d167ac20f0210e14213abec45f) contentStartColumn(8) contentStartLine(308) org.kframework.attributes.Location(Location(308,8,308,37)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool _ as varK_111) :: []),((Bool true) :: [])) when true && (true) -> (varK_111 :: [])
(*{| rule `` `_andThenBool__BOOL`(#token("false","Bool"),_8)=>#token("false","Bool")`` requires isBool(_8) ensures #token("true","Bool") [UNIQUE_ID(34b51d1bff350ce2cd8b17b3af8effdfcf390962b57189087f3cc3b6bbe59cbc) contentStartColumn(8) contentStartLine(309) org.kframework.attributes.Location(Location(309,8,309,36)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool false) :: []),((Bool _ as var_8_112) :: [])) when true && (true) -> ((Bool false) :: [])
(*{| rule `` `_andThenBool__BOOL`(_0,#token("false","Bool"))=>#token("false","Bool")`` requires isBool(_0) ensures #token("true","Bool") [UNIQUE_ID(d0a6502b90e84545c10a45f7199b2a6d77f52d0841c63dcc792b60073f300e07) contentStartColumn(8) contentStartLine(310) org.kframework.attributes.Location(Location(310,8,310,36)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool _ as var_0_113) :: []),((Bool false) :: [])) when true && (true) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evaldirectionalityChar (c: k) (config: k) (guard: int) : k = let lbl = 
LbldirectionalityChar and sort = 
SortString in match c with 
| _ -> try STRING.hook_directionality c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalFloat2String (c: k) (config: k) (guard: int) : k = let lbl = 
LblFloat2String and sort = 
SortString in match c with 
| _ -> try STRING.hook_float2string c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalproject'Coln'Proc (c: k) (config: k) (guard: int) : k = let lbl = 
Lblproject'Coln'Proc and sort = 
SortProc in match c with 
(*{| rule `` `project:Proc`(K)=>K`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(cb126cf017df4e6349622538a0090ca4f49fe00ccf73259bbd5ec5a3e59e3beb) projection()]|}*)
| ((varK_114 :: [])) -> (varK_114 :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalinitKCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblinitKCell and sort = 
SortKCell in match c with 
(*{| rule ``initKCell(Init)=>`<k>`(`project:Proc`(`Map:lookup`(Init,#token("$PGM","KConfigVar"))))`` requires isProc(`project:Proc`(`Map:lookup`(Init,#token("$PGM","KConfigVar")))) ensures #token("true","Bool") [UNIQUE_ID(d3d92662c16a4dde1625ade96c567eef65d6dc0ed7c3f0ee2b3d4001d0c3f393) initializer()]|}*)
| (((Map (SortMap,_,_) as varInit_115) :: [])) when (isTrue (evalisProc(((evalproject'Coln'Proc(((evalMap'Coln'lookup((varInit_115 :: []),(KToken (SortKConfigVar, "$PGM") :: [])) config (-1)))) config (-1)))) config (-1))) && (true) -> (KApply1(Lbl'_LT_'k'_GT_',((evalproject'Coln'Proc(((evalMap'Coln'lookup((varInit_115 :: []),(KToken (SortKConfigVar, "$PGM") :: [])) config (-1)))) config (-1)))) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Stop'BoundCellBag (c: unit) (config: k) (guard: int) : k = let lbl = 
Lbl'Stop'BoundCellBag and sort = 
SortBoundCellBag in match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let const'Stop'BoundCellBag : k Lazy.t = lazy (eval'Stop'BoundCellBag () interned_bottom (-1))
let evalinitBoundsCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitBoundsCell and sort = 
SortBoundsCell in match c with 
(*{| rule ``initBoundsCell(.KList)=>`<bounds>`(`.BoundCellBag`(.KList))`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(431315c549e86edc2286da7d315bb5ab511e7f736b1590d3a434ed1e00a0b73f) initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'bounds'_GT_',((Lazy.force const'Stop'BoundCellBag))) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitBoundsCell : k Lazy.t = lazy (evalinitBoundsCell () interned_bottom (-1))
let eval'Stop'SummandCellBag (c: unit) (config: k) (guard: int) : k = let lbl = 
Lbl'Stop'SummandCellBag and sort = 
SortSummandCellBag in match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let const'Stop'SummandCellBag : k Lazy.t = lazy (eval'Stop'SummandCellBag () interned_bottom (-1))
let evalinitSumCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitSumCell and sort = 
SortSumCell in match c with 
(*{| rule ``initSumCell(.KList)=>`<sum>`(`.SummandCellBag`(.KList))`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(441266a4b299691b699741953a7e41949cca7e352f8e518f3595a107b58dd1b9) initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'sum'_GT_',((Lazy.force const'Stop'SummandCellBag))) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitSumCell : k Lazy.t = lazy (evalinitSumCell () interned_bottom (-1))
let evalinitProcCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblinitProcCell and sort = 
SortProcCell in match c with 
(*{| rule ``initProcCell(Init)=>`<proc>`(initKCell(Init),initBoundsCell(.KList),initSumCell(.KList))`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(467e22822e1b38ec8da62ce0b01fb6053564aea32ffeedbfa27030bef6c24c1c) initializer()]|}*)
| (((Map (SortMap,_,_) as varInit_116) :: [])) -> (KApply3(Lbl'_LT_'proc'_GT_',((evalinitKCell((varInit_116 :: [])) config (-1))),((Lazy.force constinitBoundsCell)),((Lazy.force constinitSumCell))) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalsizeList (c: k) (config: k) (guard: int) : k = let lbl = 
LblsizeList and sort = 
SortInt in match c with 
| _ -> try LIST.hook_size c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Stop'Set (c: unit) (config: k) (guard: int) : k = let lbl = 
Lbl'Stop'Set and sort = 
SortSet in match c with 
| _ -> try SET.hook_unit c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let const'Stop'Set : k Lazy.t = lazy (eval'Stop'Set () interned_bottom (-1))
let evalString2Id (c: k) (config: k) (guard: int) : k = let lbl = 
LblString2Id and sort = 
SortId in match c with 
| _ -> try STRING.hook_string2token c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisList (c: k) (config: k) (guard: int) : k = let lbl = 
LblisList and sort = 
SortBool in match c with 
| [List (s,_,_)] when (s = SortList) -> [Bool true]
(*{| rule ``isList(#KToken(#token("List","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortList, var__117) :: [])) -> ((Bool true) :: [])
(*{| rule ``isList(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_118)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_'Plus'String__STRING (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'Plus'String__STRING and sort = 
SortString in match c with 
| _ -> try STRING.hook_concat c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'_GT_'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'_GT_'Int__INT and sort = 
SortBool in match c with 
| _ -> try INT.hook_gt c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let rec evalreplace'LPar'_'Comm'_'Comm'_'Comm'_'RPar'_STRING (c: k * k * k * k) (config: k) (guard: int) : k = let lbl = 
Lblreplace'LPar'_'Comm'_'Comm'_'Comm'_'RPar'_STRING and sort = 
SortString in match c with 
| _ -> try STRING.hook_replace c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `replace(_,_,_,_)_STRING`(Source,ToReplace,Replacement,Count)=>`_+String__STRING`(`_+String__STRING`(substrString(Source,#token("0","Int"),findString(Source,ToReplace,#token("0","Int"))),Replacement),`replace(_,_,_,_)_STRING`(substrString(Source,`_+Int_`(findString(Source,ToReplace,#token("0","Int")),lengthString(ToReplace)),lengthString(Source)),ToReplace,Replacement,`_-Int__INT`(Count,#token("1","Int"))))`` requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isString(Replacement),isString(Source)),isInt(Count)),isString(ToReplace)),`_>Int__INT`(Count,#token("0","Int"))) ensures #token("true","Bool") [UNIQUE_ID(00a2618b5ebbb57a911b7f2ad35458f6b3e1d5cb14ef1e49468e9833e93e48c0) contentStartColumn(8) contentStartLine(570) org.kframework.attributes.Location(Location(570,8,573,30)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
| (((String _ as varSource_119) :: []),((String _ as varToReplace_120) :: []),((String _ as varReplacement_121) :: []),((Int _ as varCount_122) :: [])) when ((((((((true) && (true))) && (true))) && (true))) && ((isTrue (eval_'_GT_'Int__INT((varCount_122 :: []),((Lazy.force int0) :: [])) config (-1))))) && (true) -> ((eval_'Plus'String__STRING(((eval_'Plus'String__STRING(((evalsubstrString((varSource_119 :: []),((Lazy.force int0) :: []),((evalfindString((varSource_119 :: []),(varToReplace_120 :: []),((Lazy.force int0) :: [])) config (-1)))) config (-1))),(varReplacement_121 :: [])) config (-1))),((evalreplace'LPar'_'Comm'_'Comm'_'Comm'_'RPar'_STRING(((evalsubstrString((varSource_119 :: []),((eval_'Plus'Int_(((evalfindString((varSource_119 :: []),(varToReplace_120 :: []),((Lazy.force int0) :: [])) config (-1))),((evallengthString((varToReplace_120 :: [])) config (-1)))) config (-1))),((evallengthString((varSource_119 :: [])) config (-1)))) config (-1))),(varToReplace_120 :: []),(varReplacement_121 :: []),((eval_'Hyph'Int__INT((varCount_122 :: []),((Lazy.force int1) :: [])) config (-1)))) config (-1)))) config (-1)))
(*{| rule `` `replace(_,_,_,_)_STRING`(Source,_17,_18,_0)=>Source`` requires `_andBool_`(`_andBool_`(`_andBool_`(isString(Source),isString(_18)),isString(_17)),`_==Int_`(_0,#token("0","Int"))) ensures #token("true","Bool") [UNIQUE_ID(ba5c0b944155cbe05f7bf6c179a2ed1e9baea983ec5099e8449b31926e9b3069) contentStartColumn(8) contentStartLine(574) org.kframework.attributes.Location(Location(574,8,574,49)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((String _ as varSource_123) :: []),((String _ as var_17_124) :: []),((String _ as var_18_125) :: []),((Int _ as var_0_126) :: [])) when ((((((true) && (true))) && (true))) && ((isTrue (eval_'EqlsEqls'Int_((var_0_126 :: []),((Lazy.force int0) :: [])) config (-1))))) && (true) -> (varSource_123 :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize4 c)))])
let eval_'_LT_'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'_LT_'Int__INT and sort = 
SortBool in match c with 
| _ -> try INT.hook_lt c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let rec evalcountAllOccurrences'LPar'_'Comm'_'RPar'_STRING (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblcountAllOccurrences'LPar'_'Comm'_'RPar'_STRING and sort = 
SortInt in match c with 
| _ -> try STRING.hook_countAllOccurrences c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `countAllOccurrences(_,_)_STRING`(Source,ToCount)=>`_+Int_`(#token("1","Int"),`countAllOccurrences(_,_)_STRING`(substrString(Source,`_+Int_`(findString(Source,ToCount,#token("0","Int")),lengthString(ToCount)),lengthString(Source)),ToCount))`` requires `_andBool_`(`_andBool_`(isString(ToCount),isString(Source)),`_>=Int__INT`(findString(Source,ToCount,#token("0","Int")),#token("0","Int"))) ensures #token("true","Bool") [UNIQUE_ID(9834f2e2641cb2ecf28969acaab73619cb181f1a69c9cfef5102f907edaeb71e) contentStartColumn(8) contentStartLine(560) org.kframework.attributes.Location(Location(560,8,561,60)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
| (((String _ as varSource_127) :: []),((String _ as varToCount_128) :: [])) when ((((true) && (true))) && ((isTrue (eval_'_GT_Eqls'Int__INT(((evalfindString((varSource_127 :: []),(varToCount_128 :: []),((Lazy.force int0) :: [])) config (-1))),((Lazy.force int0) :: [])) config (-1))))) && (true) -> ((eval_'Plus'Int_(((Lazy.force int1) :: []),((evalcountAllOccurrences'LPar'_'Comm'_'RPar'_STRING(((evalsubstrString((varSource_127 :: []),((eval_'Plus'Int_(((evalfindString((varSource_127 :: []),(varToCount_128 :: []),((Lazy.force int0) :: [])) config (-1))),((evallengthString((varToCount_128 :: [])) config (-1)))) config (-1))),((evallengthString((varSource_127 :: [])) config (-1)))) config (-1))),(varToCount_128 :: [])) config (-1)))) config (-1)))
(*{| rule `` `countAllOccurrences(_,_)_STRING`(Source,ToCount)=>#token("0","Int")`` requires `_andBool_`(`_andBool_`(isString(ToCount),isString(Source)),`_<Int__INT`(findString(Source,ToCount,#token("0","Int")),#token("0","Int"))) ensures #token("true","Bool") [UNIQUE_ID(cb338e251d0b5234f4abbf9c60008d68dc9dd3a8b1a5a410ed51f56d43a7b5af) contentStartColumn(8) contentStartLine(558) org.kframework.attributes.Location(Location(558,8,559,59)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
| (((String _ as varSource_129) :: []),((String _ as varToCount_130) :: [])) when ((((true) && (true))) && ((isTrue (eval_'_LT_'Int__INT(((evalfindString((varSource_129 :: []),(varToCount_130 :: []),((Lazy.force int0) :: [])) config (-1))),((Lazy.force int0) :: [])) config (-1))))) && (true) -> ((Lazy.force int0) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalreplaceAll'LPar'_'Comm'_'Comm'_'RPar'_STRING (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
LblreplaceAll'LPar'_'Comm'_'Comm'_'RPar'_STRING and sort = 
SortString in match c with 
| _ -> try STRING.hook_replaceAll c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `replaceAll(_,_,_)_STRING`(Source,ToReplace,Replacement)=>`replace(_,_,_,_)_STRING`(Source,ToReplace,Replacement,`countAllOccurrences(_,_)_STRING`(Source,ToReplace))`` requires `_andBool_`(`_andBool_`(isString(Replacement),isString(Source)),isString(ToReplace)) ensures #token("true","Bool") [UNIQUE_ID(3358d86b83068ab68fc4f0ed02513db149426f011866db38ff0a5015e8fee30d) contentStartColumn(8) contentStartLine(575) org.kframework.attributes.Location(Location(575,8,575,154)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((String _ as varSource_131) :: []),((String _ as varToReplace_132) :: []),((String _ as varReplacement_133) :: [])) when ((((true) && (true))) && (true)) && (true) -> ((evalreplace'LPar'_'Comm'_'Comm'_'Comm'_'RPar'_STRING((varSource_131 :: []),(varToReplace_132 :: []),(varReplacement_133 :: []),((evalcountAllOccurrences'LPar'_'Comm'_'RPar'_STRING((varSource_131 :: []),(varToReplace_132 :: [])) config (-1)))) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let eval_'EqlsSlshEqls'Bool__BOOL (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'EqlsSlshEqls'Bool__BOOL and sort = 
SortBool in match c with 
| _ -> try BOOL.hook_ne c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_=/=Bool__BOOL`(B1,B2)=>`notBool_`(`_==Bool__BOOL`(B1,B2))`` requires `_andBool_`(isBool(B2),isBool(B1)) ensures #token("true","Bool") [UNIQUE_ID(229c060a3ad56352e70dadb0089a132434aa77f4aaf4ef46e44d820031a08b83) contentStartColumn(8) contentStartLine(332) org.kframework.attributes.Location(Location(332,8,332,57)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool _ as varB1_134) :: []),((Bool _ as varB2_135) :: [])) when ((true) && (true)) && (true) -> ([Bool ((not ((isTrue (eval_'EqlsEqls'Bool__BOOL((varB1_134 :: []),(varB2_135 :: [])) config (-1))))))])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisBoundsCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisBoundsCell and sort = 
SortBool in match c with 
(*{| rule ``isBoundsCell(`<bounds>`(K0))=>#token("true","Bool")`` requires isBoundCellBag(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'bounds'_GT_',(varK0_136 :: [])) :: [])) when (isTrue (evalisBoundCellBag((varK0_136 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isBoundsCell(#KToken(#token("BoundsCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortBoundsCell, var__137) :: [])) -> ((Bool true) :: [])
(*{| rule ``isBoundsCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_138)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_SummandCellBag_ (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_SummandCellBag_ and sort = 
SortSummandCellBag in match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalremoveAll (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblremoveAll and sort = 
SortMap in match c with 
| _ -> try MAP.hook_removeAll c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisKCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisKCell and sort = 
SortBool in match c with 
(*{| rule ``isKCell(`<k>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'k'_GT_',(varK0_139)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isKCell(#KToken(#token("KCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortKCell, var__140) :: [])) -> ((Bool true) :: [])
(*{| rule ``isKCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_141)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisSumCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisSumCell and sort = 
SortBool in match c with 
(*{| rule ``isSumCell(#KToken(#token("SumCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSumCell, var__142) :: [])) -> ((Bool true) :: [])
(*{| rule ``isSumCell(`<sum>`(K0))=>#token("true","Bool")`` requires isSummandCellBag(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'sum'_GT_',(varK0_143 :: [])) :: [])) when (isTrue (evalisSummandCellBag((varK0_143 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isSumCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_144)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisProcCellBag (c: k) (config: k) (guard: int) : k = let lbl = 
LblisProcCellBag and sort = 
SortBool in match c with 
(*{| rule ``isProcCellBag(#KToken(#token("ProcCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortProcCell, var__145) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProcCellBag(`<proc>`(K0,K1,K2))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(isKCell(K0),isBoundsCell(K1)),isSumCell(K2)) ensures #token("true","Bool") []|}*)
| ((KApply3(Lbl'_LT_'proc'_GT_',(varK0_146 :: []),(varK1_147 :: []),(varK2_148 :: [])) :: [])) when (((((isTrue (evalisKCell((varK0_146 :: [])) config (-1)))) && ((isTrue (evalisBoundsCell((varK1_147 :: [])) config (-1)))))) && ((isTrue (evalisSumCell((varK2_148 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProcCellBag(#KToken(#token("ProcCellBag","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortProcCellBag, var__149) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProcCellBag(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_150)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisParCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisParCell and sort = 
SortBool in match c with 
(*{| rule ``isParCell(#KToken(#token("ParCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortParCell, var__151) :: [])) -> ((Bool true) :: [])
(*{| rule ``isParCell(`<par>`(K0))=>#token("true","Bool")`` requires isProcCellBag(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'par'_GT_',(varK0_152 :: [])) :: [])) when (isTrue (evalisProcCellBag((varK0_152 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isParCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_153)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisTCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisTCell and sort = 
SortBool in match c with 
(*{| rule ``isTCell(`<T>`(K0))=>#token("true","Bool")`` requires isParCell(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'T'_GT_',(varK0_154 :: [])) :: [])) when (isTrue (evalisParCell((varK0_154 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isTCell(#KToken(#token("TCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortTCell, var__155) :: [])) -> ((Bool true) :: [])
(*{| rule ``isTCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_156)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_'LSqB'_'Slsh'_'RSqB'_SUBSTITUTION (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'LSqB'_'Slsh'_'RSqB'_SUBSTITUTION and sort = 
SortK in match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let eval_'Xor_'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'Xor_'Int__INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_pow c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalinitParCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblinitParCell and sort = 
SortParCell in match c with 
(*{| rule ``initParCell(Init)=>`<par>`(initProcCell(Init))`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(de79fbca323b2a1c1cd0eb1a5994efbe6d4cc3a7c402c8585a6d041ccb4c6418) initializer()]|}*)
| (((Map (SortMap,_,_) as varInit_157) :: [])) -> (KApply1(Lbl'_LT_'par'_GT_',((evalinitProcCell((varInit_157 :: [])) config (-1)))) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalinitTCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblinitTCell and sort = 
SortTCell in match c with 
(*{| rule ``initTCell(Init)=>`<T>`(initParCell(Init))`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(5d2b4200227be702a8af7794f089797b0548076cebcfbdd5bea4aef42a0e3004) initializer()]|}*)
| (((Map (SortMap,_,_) as varInit_158) :: [])) -> (KApply1(Lbl'_LT_'T'_GT_',((evalinitParCell((varInit_158 :: [])) config (-1)))) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_'_GT_'String__STRING (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'_GT_'String__STRING and sort = 
SortBool in match c with 
| _ -> try STRING.hook_gt c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_>String__STRING`(S1,S2)=>`_<String__STRING`(S2,S1)`` requires `_andBool_`(isString(S2),isString(S1)) ensures #token("true","Bool") [UNIQUE_ID(85f6517ce0e2b7074d495585267afa5b0502e09d5bf63c57fb6c6d77174aa16a) contentStartColumn(8) contentStartLine(550) org.kframework.attributes.Location(Location(550,8,550,52)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((String _ as varS1_159) :: []),((String _ as varS2_160) :: [])) when ((true) && (true)) && (true) -> ((eval_'_LT_'String__STRING((varS2_160 :: []),(varS1_159 :: [])) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalFloatFormat (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblFloatFormat and sort = 
SortString in match c with 
| _ -> try STRING.hook_floatFormat c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisKConfigVar (c: k) (config: k) (guard: int) : k = let lbl = 
LblisKConfigVar and sort = 
SortBool in match c with 
(*{| rule ``isKConfigVar(#KToken(#token("KConfigVar","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortKConfigVar, var__161) :: [])) -> ((Bool true) :: [])
(*{| rule ``isKConfigVar(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_162)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_'Xor_Perc'Int___INT (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'Xor_Perc'Int___INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_powmod c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let eval_'Pipe'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'Pipe'Int__INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_or c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisKVariable (c: k) (config: k) (guard: int) : k = let lbl = 
LblisKVariable and sort = 
SortBool in match c with 
(*{| rule ``isKVariable(#KToken(#token("KVariable","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortKVariable, var__163) :: [])) -> ((Bool true) :: [])
(*{| rule ``isKVariable(#KToken(#token("Id","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortId, var__164) :: [])) -> ((Bool true) :: [])
(*{| rule ``isKVariable(#KToken(#token("Name","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortName, var__165) :: [])) -> ((Bool true) :: [])
(*{| rule ``isKVariable(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_166)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_dividesInt__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_dividesInt__INT and sort = 
SortBool in match c with 
(*{| rule `` `_dividesInt__INT`(I1,I2)=>`_==Int_`(`_%Int__INT`(I2,I1),#token("0","Int"))`` requires `_andBool_`(isInt(I1),isInt(I2)) ensures #token("true","Bool") [UNIQUE_ID(81f77f3fbad78d0c735f87bfe9eff8339b46a8ead5ca820f8d69aafef7cb551d) contentStartColumn(8) contentStartLine(409) org.kframework.attributes.Location(Location(409,8,409,58)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Int _ as varI1_167) :: []),((Int _ as varI2_168) :: [])) when ((true) && (true)) && (true) -> ((eval_'EqlsEqls'Int_(((eval_'Perc'Int__INT((varI2_168 :: []),(varI1_167 :: [])) config (-1))),((Lazy.force int0) :: [])) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisCell and sort = 
SortBool in match c with 
(*{| rule ``isCell(#KToken(#token("Cell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortCell, var__169) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("BoundCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortBoundCell, var__170) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("TCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortTCell, var__171) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("SumCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSumCell, var__172) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("SummandCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSummandCell, var__173) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(`<par>`(K0))=>#token("true","Bool")`` requires isProcCellBag(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'par'_GT_',(varK0_174 :: [])) :: [])) when (isTrue (evalisProcCellBag((varK0_174 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(`<k>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'k'_GT_',(varK0_175)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("ProcCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortProcCell, var__176) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(`<bounds>`(K0))=>#token("true","Bool")`` requires isBoundCellBag(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'bounds'_GT_',(varK0_177 :: [])) :: [])) when (isTrue (evalisBoundCellBag((varK0_177 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(`<sum>`(K0))=>#token("true","Bool")`` requires isSummandCellBag(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'sum'_GT_',(varK0_178 :: [])) :: [])) when (isTrue (evalisSummandCellBag((varK0_178 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(`<proc>`(K0,K1,K2))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(isKCell(K0),isBoundsCell(K1)),isSumCell(K2)) ensures #token("true","Bool") []|}*)
| ((KApply3(Lbl'_LT_'proc'_GT_',(varK0_179 :: []),(varK1_180 :: []),(varK2_181 :: [])) :: [])) when (((((isTrue (evalisKCell((varK0_179 :: [])) config (-1)))) && ((isTrue (evalisBoundsCell((varK1_180 :: [])) config (-1)))))) && ((isTrue (evalisSumCell((varK2_181 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(`<bound>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'bound'_GT_',(varK0_182)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("KCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortKCell, var__183) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(`<summand>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'summand'_GT_',(varK0_184)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("BoundsCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortBoundsCell, var__185) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("ParCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortParCell, var__186) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(`<T>`(K0))=>#token("true","Bool")`` requires isParCell(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'T'_GT_',(varK0_187 :: [])) :: [])) when (isTrue (evalisParCell((varK0_187 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_188)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalvalues (c: k) (config: k) (guard: int) : k = let lbl = 
Lblvalues and sort = 
SortList in match c with 
| _ -> try MAP.hook_values c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalupdateList (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
LblupdateList and sort = 
SortList in match c with 
| _ -> try LIST.hook_updateAll c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let evalSet'Coln'choice (c: k) (config: k) (guard: int) : k = let lbl = 
LblSet'Coln'choice and sort = 
SortKItem in match c with 
| _ -> try SET.hook_choice c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalList'Coln'get (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblList'Coln'get and sort = 
SortKItem in match c with 
| _ -> try LIST.hook_get c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisSumCellFragment (c: k) (config: k) (guard: int) : k = let lbl = 
LblisSumCellFragment and sort = 
SortBool in match c with 
(*{| rule ``isSumCellFragment(#KToken(#token("SumCellFragment","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSumCellFragment, var__189) :: [])) -> ((Bool true) :: [])
(*{| rule ``isSumCellFragment(`<sum>-fragment`(K0))=>#token("true","Bool")`` requires isSummandCellBag(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'sum'_GT_Hyph'fragment,(varK0_190 :: [])) :: [])) when (isTrue (evalisSummandCellBag((varK0_190 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isSumCellFragment(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_191)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalSetItem (c: k) (config: k) (guard: int) : k = let lbl = 
LblSetItem and sort = 
SortSet in match c with 
| _ -> try SET.hook_element c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalcategoryChar (c: k) (config: k) (guard: int) : k = let lbl = 
LblcategoryChar and sort = 
SortString in match c with 
| _ -> try STRING.hook_category c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalSet'Coln'difference (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblSet'Coln'difference and sort = 
SortSet in match c with 
| _ -> try SET.hook_difference c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalfreshInt (c: k) (config: k) (guard: int) : k = let lbl = 
LblfreshInt and sort = 
SortInt in match c with 
(*{| rule ``freshInt(I)=>I`` requires isInt(I) ensures #token("true","Bool") [UNIQUE_ID(d7221da1fa6b633137e79279efd265a289ea7e8496612615f43546422d446bc4) contentStartColumn(8) contentStartLine(412) org.kframework.attributes.Location(Location(412,8,412,28)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Int _ as varI_192) :: [])) when true && (true) -> (varI_192 :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisParCellFragment (c: k) (config: k) (guard: int) : k = let lbl = 
LblisParCellFragment and sort = 
SortBool in match c with 
(*{| rule ``isParCellFragment(`<par>-fragment`(K0))=>#token("true","Bool")`` requires isProcCellBag(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'par'_GT_Hyph'fragment,(varK0_193 :: [])) :: [])) when (isTrue (evalisProcCellBag((varK0_193 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isParCellFragment(#KToken(#token("ParCellFragment","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortParCellFragment, var__194) :: [])) -> ((Bool true) :: [])
(*{| rule ``isParCellFragment(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_195)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Stop'List (c: unit) (config: k) (guard: int) : k = let lbl = 
Lbl'Stop'List and sort = 
SortList in match c with 
| _ -> try LIST.hook_unit c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let const'Stop'List : k Lazy.t = lazy (eval'Stop'List () interned_bottom (-1))
let eval_xorInt__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_xorInt__INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_xor c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalMap'Coln'lookupOrDefault (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
LblMap'Coln'lookupOrDefault and sort = 
SortKItem in match c with 
| _ -> try MAP.hook_lookupOrDefault c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let evalrandInt (c: k) (config: k) (guard: int) : k = let lbl = 
LblrandInt and sort = 
SortInt in match c with 
| _ -> try INT.hook_rand c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalString2Float (c: k) (config: k) (guard: int) : k = let lbl = 
LblString2Float and sort = 
SortFloat in match c with 
| _ -> try STRING.hook_string2float c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisFloat (c: k) (config: k) (guard: int) : k = let lbl = 
LblisFloat and sort = 
SortBool in match c with 
| [Float _] -> [Bool true]
(*{| rule ``isFloat(#KToken(#token("Float","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortFloat, var__196) :: [])) -> ((Bool true) :: [])
(*{| rule ``isFloat(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_197)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisParCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisParCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isParCellOpt(noParCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoParCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isParCellOpt(#KToken(#token("ParCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortParCell, var__198) :: [])) -> ((Bool true) :: [])
(*{| rule ``isParCellOpt(`<par>`(K0))=>#token("true","Bool")`` requires isProcCellBag(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'par'_GT_',(varK0_199 :: [])) :: [])) when (isTrue (evalisProcCellBag((varK0_199 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isParCellOpt(#KToken(#token("ParCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortParCellOpt, var__200) :: [])) -> ((Bool true) :: [])
(*{| rule ``isParCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_201)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalkeys_list'LPar'_'RPar'_MAP (c: k) (config: k) (guard: int) : k = let lbl = 
Lblkeys_list'LPar'_'RPar'_MAP and sort = 
SortList in match c with 
| _ -> try MAP.hook_keys_list c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalInt2String (c: k) (config: k) (guard: int) : k = let lbl = 
LblInt2String and sort = 
SortString in match c with 
| _ -> try STRING.hook_int2string c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalfreshId (c: k) (config: k) (guard: int) : k = let lbl = 
LblfreshId and sort = 
SortId in match c with 
(*{| rule ``freshId(I)=>`String2Id`(`_+String__STRING`(#token("\"_\"","String"),`Int2String`(I)))`` requires isInt(I) ensures #token("true","Bool") [UNIQUE_ID(cb89ef33f1b27d7db53de8a3c240cc3b944a9a0a9559c32b1b97c7bfec87bfa2) contentStartColumn(8) contentStartLine(745) org.kframework.attributes.Location(Location(745,8,745,62)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Int _ as varI_202) :: [])) when true && (true) -> ((evalString2Id(((eval_'Plus'String__STRING(((String "_") :: []),((evalInt2String((varI_202 :: [])) config (-1)))) config (-1)))) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalchrChar (c: k) (config: k) (guard: int) : k = let lbl = 
LblchrChar and sort = 
SortString in match c with 
| _ -> try STRING.hook_chr c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisProcCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisProcCell and sort = 
SortBool in match c with 
(*{| rule ``isProcCell(`<proc>`(K0,K1,K2))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(isKCell(K0),isBoundsCell(K1)),isSumCell(K2)) ensures #token("true","Bool") []|}*)
| ((KApply3(Lbl'_LT_'proc'_GT_',(varK0_203 :: []),(varK1_204 :: []),(varK2_205 :: [])) :: [])) when (((((isTrue (evalisKCell((varK0_203 :: [])) config (-1)))) && ((isTrue (evalisBoundsCell((varK1_204 :: [])) config (-1)))))) && ((isTrue (evalisSumCell((varK2_205 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProcCell(#KToken(#token("ProcCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortProcCell, var__206) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProcCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_207)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_'And'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'And'Int__INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_and c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_orElseBool__BOOL (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_orElseBool__BOOL and sort = 
SortBool in match c with 
| _ -> try BOOL.hook_orElse c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_orElseBool__BOOL`(#token("false","Bool"),K)=>K`` requires isBool(K) ensures #token("true","Bool") [UNIQUE_ID(efdd958595a7fecb549f4368ba6097862b61abc903a6d33684803a3a0043bda8) contentStartColumn(8) contentStartLine(324) org.kframework.attributes.Location(Location(324,8,324,37)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool false) :: []),((Bool _ as varK_208) :: [])) when true && (true) -> (varK_208 :: [])
(*{| rule `` `_orElseBool__BOOL`(_1,#token("true","Bool"))=>#token("true","Bool")`` requires isBool(_1) ensures #token("true","Bool") [UNIQUE_ID(2882f8b0a388fe37313c6b828cb9039a9838984f56e50b5095476c319b3dfbd8) contentStartColumn(8) contentStartLine(323) org.kframework.attributes.Location(Location(323,8,323,33)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool _ as var_1_209) :: []),((Bool true) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule `` `_orElseBool__BOOL`(#token("true","Bool"),_6)=>#token("true","Bool")`` requires isBool(_6) ensures #token("true","Bool") [UNIQUE_ID(6ea998be2fb9b60b7964c4b4939293b6fecb47f52a53031c6227218949cf22f0) contentStartColumn(8) contentStartLine(322) org.kframework.attributes.Location(Location(322,8,322,33)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool true) :: []),((Bool _ as var_6_210) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule `` `_orElseBool__BOOL`(K,#token("false","Bool"))=>K`` requires isBool(K) ensures #token("true","Bool") [UNIQUE_ID(8c7774b237a73a62ffd53be8d97ac73eb2f040dcf41983ea18840919b416d291) contentStartColumn(8) contentStartLine(325) org.kframework.attributes.Location(Location(325,8,325,37)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool _ as varK_211) :: []),((Bool false) :: [])) when true && (true) -> (varK_211 :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'Slsh'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'Slsh'Int__INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_tdiv c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_divInt__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_divInt__INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_ediv c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_divInt__INT`(I1,I2)=>`_/Int__INT`(`_-Int__INT`(I1,`_modInt__INT`(I1,I2)),I2)`` requires `_andBool_`(`_andBool_`(isInt(I1),isInt(I2)),`_=/=Int__INT`(I2,#token("0","Int"))) ensures #token("true","Bool") [UNIQUE_ID(b7fc8e019ea9840ee8c5e9232d39d7944e010f117308f672e92891325002610e) contentStartColumn(8) contentStartLine(388) org.kframework.attributes.Location(Location(388,8,389,23)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
| (((Int _ as varI1_212) :: []),((Int _ as varI2_213) :: [])) when ((((true) && (true))) && ((isTrue (eval_'EqlsSlshEqls'Int__INT((varI2_213 :: []),((Lazy.force int0) :: [])) config (-1))))) && (true) -> ((eval_'Slsh'Int__INT(((eval_'Hyph'Int__INT((varI1_212 :: []),((eval_modInt__INT((varI1_212 :: []),(varI2_213 :: [])) config (-1)))) config (-1))),(varI2_213 :: [])) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalList'Coln'range (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
LblList'Coln'range and sort = 
SortList in match c with 
| _ -> try LIST.hook_range c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let evallog2Int (c: k) (config: k) (guard: int) : k = let lbl = 
Lbllog2Int and sort = 
SortInt in match c with 
| _ -> try INT.hook_log2 c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalBoundCellBagItem (c: k) (config: k) (guard: int) : k = let lbl = 
LblBoundCellBagItem and sort = 
SortBoundCellBag in match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalProcCellBagItem (c: k) (config: k) (guard: int) : k = let lbl = 
LblProcCellBagItem and sort = 
SortProcCellBag in match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalBase2String (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblBase2String and sort = 
SortString in match c with 
| _ -> try STRING.hook_base2string c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_orBool__BOOL (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_orBool__BOOL and sort = 
SortBool in match c with 
| _ -> try BOOL.hook_or c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_orBool__BOOL`(#token("true","Bool"),_5)=>#token("true","Bool")`` requires isBool(_5) ensures #token("true","Bool") [UNIQUE_ID(166d732e9fd6609a71feb6d62f8a420d291ac81be018b646ee1177935b008f01) contentStartColumn(8) contentStartLine(317) org.kframework.attributes.Location(Location(317,8,317,34)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool true) :: []),((Bool _ as var_5_214) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule `` `_orBool__BOOL`(_3,#token("true","Bool"))=>#token("true","Bool")`` requires isBool(_3) ensures #token("true","Bool") [UNIQUE_ID(497077a299480dbc06eccb33cd98338014bd125c4c601cb88a765dbcb334b14b) contentStartColumn(8) contentStartLine(318) org.kframework.attributes.Location(Location(318,8,318,34)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool _ as var_3_215) :: []),((Bool true) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule `` `_orBool__BOOL`(B,#token("false","Bool"))=>B`` requires isBool(B) ensures #token("true","Bool") [UNIQUE_ID(630487d34ae5fc313a9b8cae2ad45b7b80671058bca3c97a7864774c5a431711) contentStartColumn(8) contentStartLine(320) org.kframework.attributes.Location(Location(320,8,320,32)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool _ as varB_216) :: []),((Bool false) :: [])) when true && (true) -> (varB_216 :: [])
(*{| rule `` `_orBool__BOOL`(#token("false","Bool"),B)=>B`` requires isBool(B) ensures #token("true","Bool") [UNIQUE_ID(ababa6e5e3735076933657815e24f99518fe532715ea97eae22ead8e30097b53) contentStartColumn(8) contentStartLine(319) org.kframework.attributes.Location(Location(319,8,319,32)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool false) :: []),((Bool _ as varB_217) :: [])) when true && (true) -> (varB_217 :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalListItem (c: k) (config: k) (guard: int) : k = let lbl = 
LblListItem and sort = 
SortList in match c with 
| _ -> try LIST.hook_element c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_'_GT_Eqls'String__STRING (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'_GT_Eqls'String__STRING and sort = 
SortBool in match c with 
| _ -> try STRING.hook_ge c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_>=String__STRING`(S1,S2)=>`notBool_`(`_<String__STRING`(S1,S2))`` requires `_andBool_`(isString(S2),isString(S1)) ensures #token("true","Bool") [UNIQUE_ID(2e24bd4be2ac7aa21b58ac7fe4e1e4e70e5e69437dff6c98e3ff986df28f5b21) contentStartColumn(8) contentStartLine(551) org.kframework.attributes.Location(Location(551,8,551,63)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((String _ as varS1_218) :: []),((String _ as varS2_219) :: [])) when ((true) && (true)) && (true) -> ([Bool ((not ((isTrue (eval_'_LT_'String__STRING((varS1_218 :: []),(varS2_219 :: [])) config (-1))))))])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'_LT_Eqls'Map__MAP (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'_LT_Eqls'Map__MAP and sort = 
SortBool in match c with 
| _ -> try MAP.hook_inclusion c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalnewUUID_STRING (c: unit) (config: k) (guard: int) : k = let lbl = 
LblnewUUID_STRING and sort = 
SortString in match c with 
| _ -> try STRING.hook_uuid c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let evalsizeMap (c: k) (config: k) (guard: int) : k = let lbl = 
LblsizeMap and sort = 
SortInt in match c with 
| _ -> try MAP.hook_size c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalupdateMap (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblupdateMap and sort = 
SortMap in match c with 
| _ -> try MAP.hook_updateAll c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisId (c: k) (config: k) (guard: int) : k = let lbl = 
LblisId and sort = 
SortBool in match c with 
(*{| rule ``isId(#KToken(#token("Id","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortId, var__220) :: [])) -> ((Bool true) :: [])
(*{| rule ``isId(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_221)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalsize (c: k) (config: k) (guard: int) : k = let lbl = 
Lblsize and sort = 
SortInt in match c with 
| _ -> try SET.hook_size c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_'EqlsSlshEqls'K_ (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'EqlsSlshEqls'K_ and sort = 
SortBool in match c with 
| _ -> try KEQUAL.hook_ne c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_=/=K_`(K1,K2)=>`notBool_`(`_==K_`(K1,K2))`` requires `_andBool_`(isK(K1),isK(K2)) ensures #token("true","Bool") [UNIQUE_ID(0221882a8af3c088550dce160a5b2e48351ef2431aad518a72f3d65258a4066d) contentStartColumn(8) contentStartLine(763) org.kframework.attributes.Location(Location(763,8,763,45)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((varK1_222),(varK2_223)) when ((true) && (true)) && (true) -> ([Bool ((not ((isTrue (eval_'EqlsEqls'K_((varK1_222),(varK2_223)) config (-1))))))])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisSummandCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisSummandCell and sort = 
SortBool in match c with 
(*{| rule ``isSummandCell(#KToken(#token("SummandCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSummandCell, var__224) :: [])) -> ((Bool true) :: [])
(*{| rule ``isSummandCell(`<summand>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'summand'_GT_',(varK0_225)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isSummandCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_226)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_BoundCellBag_ (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_BoundCellBag_ and sort = 
SortBoundCellBag in match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalfillList (c: k * k * k * k) (config: k) (guard: int) : k = let lbl = 
LblfillList and sort = 
SortList in match c with 
| _ -> try LIST.hook_fill c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize4 c)))])
let evalSummandCellBagItem (c: k) (config: k) (guard: int) : k = let lbl = 
LblSummandCellBagItem and sort = 
SortSummandCellBag in match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Stop'ProcCellBag (c: unit) (config: k) (guard: int) : k = let lbl = 
Lbl'Stop'ProcCellBag and sort = 
SortProcCellBag in match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let const'Stop'ProcCellBag : k Lazy.t = lazy (eval'Stop'ProcCellBag () interned_bottom (-1))
let evalinitSummandCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitSummandCell and sort = 
SortSummandCell in match c with 
(*{| rule ``initSummandCell(.KList)=>`<summand>`(.K)`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(571de001ebffb30b04c1784cfa7611ac8e9cc0fe1bbf2fd5410836965e0e5aeb) initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'summand'_GT_',([])) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitSummandCell : k Lazy.t = lazy (evalinitSummandCell () interned_bottom (-1))
let eval_inList_ (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_inList_ and sort = 
SortBool in match c with 
| _ -> try LIST.hook_in c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_List_ (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_List_ and sort = 
SortList in match c with 
| _ -> try LIST.hook_concat c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisBoundCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisBoundCell and sort = 
SortBool in match c with 
(*{| rule ``isBoundCell(#KToken(#token("BoundCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortBoundCell, var__227) :: [])) -> ((Bool true) :: [])
(*{| rule ``isBoundCell(`<bound>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'bound'_GT_',(varK0_228)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isBoundCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_229)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_'PipeHyph_GT_'_ (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'PipeHyph_GT_'_ and sort = 
SortMap in match c with 
| _ -> try MAP.hook_element c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_xorBool__BOOL (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_xorBool__BOOL and sort = 
SortBool in match c with 
| _ -> try BOOL.hook_xor c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_xorBool__BOOL`(B,B)=>#token("false","Bool")`` requires isBool(B) ensures #token("true","Bool") [UNIQUE_ID(70684b52edf7d3194cd01f6e5714b364631e8d96267df666bb689e5380e13cc4) contentStartColumn(8) contentStartLine(314) org.kframework.attributes.Location(Location(314,8,314,38)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool _ as varB_230) :: []),((Bool _ as varB_231) :: [])) when true && (((compare_kitem varB_231 varB_230) = 0) && true) -> ((Bool false) :: [])
(*{| rule `` `_xorBool__BOOL`(B,#token("false","Bool"))=>B`` requires isBool(B) ensures #token("true","Bool") [UNIQUE_ID(2eae84ae7b21312fecde18860149de73365b819e65aada5f952fc5b9101ae014) contentStartColumn(8) contentStartLine(313) org.kframework.attributes.Location(Location(313,8,313,38)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool _ as varB_232) :: []),((Bool false) :: [])) when true && (true) -> (varB_232 :: [])
(*{| rule `` `_xorBool__BOOL`(#token("false","Bool"),B)=>B`` requires isBool(B) ensures #token("true","Bool") [UNIQUE_ID(0b888132027262073a3306d90f4a55b0a4ea27984cd77fccd8bf29cd48efb665) contentStartColumn(8) contentStartLine(312) org.kframework.attributes.Location(Location(312,8,312,38)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool false) :: []),((Bool _ as varB_233) :: [])) when true && (true) -> (varB_233 :: [])
(*{| rule `` `_xorBool__BOOL`(B1,B2)=>`notBool_`(`_==Bool__BOOL`(B1,B2))`` requires `_andBool_`(isBool(B2),isBool(B1)) ensures #token("true","Bool") [UNIQUE_ID(1c34683a46438798498c925345e696fc017c0665504d0877c44e540d820b1ec7) contentStartColumn(8) contentStartLine(315) org.kframework.attributes.Location(Location(315,8,315,57)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool _ as varB1_234) :: []),((Bool _ as varB2_235) :: [])) when ((true) && (true)) && (true) -> ([Bool ((not ((isTrue (eval_'EqlsEqls'Bool__BOOL((varB1_234 :: []),(varB2_235 :: [])) config (-1))))))])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'Hyph'Map__MAP (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'Hyph'Map__MAP and sort = 
SortMap in match c with 
| _ -> try MAP.hook_difference c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisMap (c: k) (config: k) (guard: int) : k = let lbl = 
LblisMap and sort = 
SortBool in match c with 
| [Map (s,_,_)] when (s = SortMap) -> [Bool true]
(*{| rule ``isMap(#KToken(#token("Map","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortMap, var__236) :: [])) -> ((Bool true) :: [])
(*{| rule ``isMap(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_237)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalsrandInt (c: k) (config: k) (guard: int) : k = let lbl = 
LblsrandInt and sort = 
SortK in match c with 
| _ -> try INT.hook_srand c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisKItem (c: k) (config: k) (guard: int) : k = let lbl = 
LblisKItem and sort = 
SortBool in match c with 
| [_] -> [Bool true] | _ -> [Bool false]
| [List (s,_,_)] when (s = SortList) -> [Bool true]
| [String _] -> [Bool true]
| [Bool _] -> [Bool true]
| [Map (s,_,_)] when (s = SortMap) -> [Bool true]
| [Int _] -> [Bool true]
| [Float _] -> [Bool true]
| [Set (s,_,_)] when (s = SortSet) -> [Bool true]
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisBoundsCellFragment (c: k) (config: k) (guard: int) : k = let lbl = 
LblisBoundsCellFragment and sort = 
SortBool in match c with 
(*{| rule ``isBoundsCellFragment(#KToken(#token("BoundsCellFragment","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortBoundsCellFragment, var__238) :: [])) -> ((Bool true) :: [])
(*{| rule ``isBoundsCellFragment(`<bounds>-fragment`(K0))=>#token("true","Bool")`` requires isBoundCellBag(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'bounds'_GT_Hyph'fragment,(varK0_239 :: [])) :: [])) when (isTrue (evalisBoundCellBag((varK0_239 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isBoundsCellFragment(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_240)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalList'Coln'set (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
LblList'Coln'set and sort = 
SortList in match c with 
| _ -> try LIST.hook_update c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let evalString2Base (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblString2Base and sort = 
SortInt in match c with 
| _ -> try STRING.hook_string2base c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'LSqB'_'RSqB'_SUBSTITUTION (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'LSqB'_'RSqB'_SUBSTITUTION and sort = 
SortK in match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisTCellFragment (c: k) (config: k) (guard: int) : k = let lbl = 
LblisTCellFragment and sort = 
SortBool in match c with 
(*{| rule ``isTCellFragment(`<T>-fragment`(K0))=>#token("true","Bool")`` requires isParCellOpt(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'T'_GT_Hyph'fragment,(varK0_241 :: [])) :: [])) when (isTrue (evalisParCellOpt((varK0_241 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isTCellFragment(#KToken(#token("TCellFragment","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortTCellFragment, var__242) :: [])) -> ((Bool true) :: [])
(*{| rule ``isTCellFragment(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_243)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalreplaceFirst'LPar'_'Comm'_'Comm'_'RPar'_STRING (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
LblreplaceFirst'LPar'_'Comm'_'Comm'_'RPar'_STRING and sort = 
SortString in match c with 
| _ -> try STRING.hook_replaceFirst c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `replaceFirst(_,_,_)_STRING`(Source,ToReplace,Replacement)=>`_+String__STRING`(`_+String__STRING`(substrString(Source,#token("0","Int"),findString(Source,ToReplace,#token("0","Int"))),Replacement),substrString(Source,`_+Int_`(findString(Source,ToReplace,#token("0","Int")),lengthString(ToReplace)),lengthString(Source)))`` requires `_andBool_`(`_andBool_`(`_andBool_`(isString(Replacement),isString(Source)),isString(ToReplace)),`_>=Int__INT`(findString(Source,ToReplace,#token("0","Int")),#token("0","Int"))) ensures #token("true","Bool") [UNIQUE_ID(4941a93fc06d65bd530ddbfcaabb498d40e247effd559cda2d85e65d73692b70) contentStartColumn(8) contentStartLine(563) org.kframework.attributes.Location(Location(563,8,565,66)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
| (((String _ as varSource_244) :: []),((String _ as varToReplace_245) :: []),((String _ as varReplacement_246) :: [])) when ((((((true) && (true))) && (true))) && ((isTrue (eval_'_GT_Eqls'Int__INT(((evalfindString((varSource_244 :: []),(varToReplace_245 :: []),((Lazy.force int0) :: [])) config (-1))),((Lazy.force int0) :: [])) config (-1))))) && (true) -> ((eval_'Plus'String__STRING(((eval_'Plus'String__STRING(((evalsubstrString((varSource_244 :: []),((Lazy.force int0) :: []),((evalfindString((varSource_244 :: []),(varToReplace_245 :: []),((Lazy.force int0) :: [])) config (-1)))) config (-1))),(varReplacement_246 :: [])) config (-1))),((evalsubstrString((varSource_244 :: []),((eval_'Plus'Int_(((evalfindString((varSource_244 :: []),(varToReplace_245 :: []),((Lazy.force int0) :: [])) config (-1))),((evallengthString((varToReplace_245 :: [])) config (-1)))) config (-1))),((evallengthString((varSource_244 :: [])) config (-1)))) config (-1)))) config (-1)))
(*{| rule `` `replaceFirst(_,_,_)_STRING`(Source,ToReplace,_12)=>Source`` requires `_andBool_`(`_andBool_`(`_andBool_`(isString(Source),isString(ToReplace)),isString(_12)),`_<Int__INT`(findString(Source,ToReplace,#token("0","Int")),#token("0","Int"))) ensures #token("true","Bool") [UNIQUE_ID(4320c56cb2a4f4c70e2500eb8f33dab497a5bb09aa847e4e0c0ae496ab671040) contentStartColumn(8) contentStartLine(566) org.kframework.attributes.Location(Location(566,8,567,57)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
| (((String _ as varSource_247) :: []),((String _ as varToReplace_248) :: []),((String _ as var_12_249) :: [])) when ((((((true) && (true))) && (true))) && ((isTrue (eval_'_LT_'Int__INT(((evalfindString((varSource_247 :: []),(varToReplace_248 :: []),((Lazy.force int0) :: [])) config (-1))),((Lazy.force int0) :: [])) config (-1))))) && (true) -> (varSource_247 :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let eval_'LSqB'_'_LT_Hyph'_'RSqB'_MAP (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'LSqB'_'_LT_Hyph'_'RSqB'_MAP and sort = 
SortMap in match c with 
| _ -> try MAP.hook_update c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let evalkeys (c: k) (config: k) (guard: int) : k = let lbl = 
Lblkeys and sort = 
SortSet in match c with 
| _ -> try MAP.hook_keys c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalinitBoundCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitBoundCell and sort = 
SortBoundCell in match c with 
(*{| rule ``initBoundCell(.KList)=>`<bound>`(.K)`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(06bef7a818e5ca3e0d72a703fb2f8db02d741df008c092b8b47425e1ee46f236) initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'bound'_GT_',([])) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitBoundCell : k Lazy.t = lazy (evalinitBoundCell () interned_bottom (-1))
let eval'Stop'Map (c: unit) (config: k) (guard: int) : k = let lbl = 
Lbl'Stop'Map and sort = 
SortMap in match c with 
| _ -> try MAP.hook_unit c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let const'Stop'Map : k Lazy.t = lazy (eval'Stop'Map () interned_bottom (-1))
let eval (c: normal_kitem) (config: k) : k = match c with KApply(lbl, kl) -> (match lbl with 
|Lbl_ProcCellBag_ -> eval_ProcCellBag_ (normalize2 kl) config (-1)
|LblisBoundsCellOpt -> evalisBoundsCellOpt (normalize1 kl) config (-1)
|LblisSummandCellBag -> evalisSummandCellBag (normalize1 kl) config (-1)
|LblnotBool_ -> evalnotBool_ (normalize1 kl) config (-1)
|Lbl_'_LT_Eqls'Int__INT -> eval_'_LT_Eqls'Int__INT (normalize2 kl) config (-1)
|LblId2String -> evalId2String (normalize1 kl) config (-1)
|LblMap'Coln'lookup -> evalMap'Coln'lookup (normalize2 kl) config (-1)
|LblisInt -> evalisInt (normalize1 kl) config (-1)
|Lbl_'EqlsEqls'Bool__BOOL -> eval_'EqlsEqls'Bool__BOOL (normalize2 kl) config (-1)
|LblsignExtendBitRangeInt -> evalsignExtendBitRangeInt (normalize3 kl) config (-1)
|LblisSet -> evalisSet (normalize1 kl) config (-1)
|LblMap'Coln'choice -> evalMap'Coln'choice (normalize1 kl) config (-1)
|LblisProcCellFragment -> evalisProcCellFragment (normalize1 kl) config (-1)
|LblintersectSet -> evalintersectSet (normalize2 kl) config (-1)
|Lbl_in_keys'LPar'_'RPar'_MAP -> eval_in_keys'LPar'_'RPar'_MAP (normalize2 kl) config (-1)
|Lbl_impliesBool__BOOL -> eval_impliesBool__BOOL (normalize2 kl) config (-1)
|Lbl_Set_ -> eval_Set_ (normalize2 kl) config (-1)
|LblfindChar -> evalfindChar (normalize3 kl) config (-1)
|Lbl_'Star'Int__INT -> eval_'Star'Int__INT (normalize2 kl) config (-1)
|LblSet'Coln'in -> evalSet'Coln'in (normalize2 kl) config (-1)
|LblisK -> evalisK (normalize1 kl) config (-1)
|LblString2Int -> evalString2Int (normalize1 kl) config (-1)
|LblmaxInt'LPar'_'Comm'_'RPar'_INT -> evalmaxInt'LPar'_'Comm'_'RPar'_INT (normalize2 kl) config (-1)
|Lbl_'_LT_Eqls'Set__SET -> eval_'_LT_Eqls'Set__SET (normalize2 kl) config (-1)
|LblisBool -> evalisBool (normalize1 kl) config (-1)
|Lbl'Tild'Int__INT -> eval'Tild'Int__INT (normalize1 kl) config (-1)
|Lbl_'_LT_Eqls'String__STRING -> eval_'_LT_Eqls'String__STRING (normalize2 kl) config (-1)
|LblordChar -> evalordChar (normalize1 kl) config (-1)
|LblrfindChar -> evalrfindChar (normalize3 kl) config (-1)
|Lbl_modInt__INT -> eval_modInt__INT (normalize2 kl) config (-1)
|LblmakeList -> evalmakeList (normalize2 kl) config (-1)
|Lbl_'LSqB'_'_LT_Hyph'undef'RSqB' -> eval_'LSqB'_'_LT_Hyph'undef'RSqB' (normalize2 kl) config (-1)
|Lbl_Map_ -> eval_Map_ (normalize2 kl) config (-1)
|LblisNormProc -> evalisNormProc (normalize1 kl) config (-1)
|Lbl_'Hyph'Int__INT -> eval_'Hyph'Int__INT (normalize2 kl) config (-1)
|Lbl_'EqlsEqls'Int_ -> eval_'EqlsEqls'Int_ (normalize2 kl) config (-1)
|Lbl_andThenBool__BOOL -> eval_andThenBool__BOOL (normalize2 kl) config (-1)
|LbldirectionalityChar -> evaldirectionalityChar (normalize1 kl) config (-1)
|LblFloat2String -> evalFloat2String (normalize1 kl) config (-1)
|LblinitKCell -> evalinitKCell (normalize1 kl) config (-1)
|LblinitProcCell -> evalinitProcCell (normalize1 kl) config (-1)
|LblisString -> evalisString (normalize1 kl) config (-1)
|Lbl_'Perc'Int__INT -> eval_'Perc'Int__INT (normalize2 kl) config (-1)
|Lbl_'_GT__GT_'Int__INT -> eval_'_GT__GT_'Int__INT (normalize2 kl) config (-1)
|LblsizeList -> evalsizeList (normalize1 kl) config (-1)
|Lbl'Stop'Set -> eval'Stop'Set (normalize0 kl) config (-1)
|LblString2Id -> evalString2Id (normalize1 kl) config (-1)
|LblisList -> evalisList (normalize1 kl) config (-1)
|LblreplaceAll'LPar'_'Comm'_'Comm'_'RPar'_STRING -> evalreplaceAll'LPar'_'Comm'_'Comm'_'RPar'_STRING (normalize3 kl) config (-1)
|Lbl_'EqlsSlshEqls'Bool__BOOL -> eval_'EqlsSlshEqls'Bool__BOOL (normalize2 kl) config (-1)
|LblisBoundsCell -> evalisBoundsCell (normalize1 kl) config (-1)
|Lbl_SummandCellBag_ -> eval_SummandCellBag_ (normalize2 kl) config (-1)
|LblremoveAll -> evalremoveAll (normalize2 kl) config (-1)
|LblisTCell -> evalisTCell (normalize1 kl) config (-1)
|Lbl_'LSqB'_'Slsh'_'RSqB'_SUBSTITUTION -> eval_'LSqB'_'Slsh'_'RSqB'_SUBSTITUTION (normalize3 kl) config (-1)
|LblfindString -> evalfindString (normalize3 kl) config (-1)
|Lbl_'Xor_'Int__INT -> eval_'Xor_'Int__INT (normalize2 kl) config (-1)
|Lbl_andBool_ -> eval_andBool_ (normalize2 kl) config (-1)
|LbllengthString -> evallengthString (normalize1 kl) config (-1)
|LblabsInt -> evalabsInt (normalize1 kl) config (-1)
|LblinitTCell -> evalinitTCell (normalize1 kl) config (-1)
|Lbl_'_GT_'String__STRING -> eval_'_GT_'String__STRING (normalize2 kl) config (-1)
|LblFloatFormat -> evalFloatFormat (normalize2 kl) config (-1)
|Lbl_'EqlsEqls'String__STRING -> eval_'EqlsEqls'String__STRING (normalize2 kl) config (-1)
|LblisKConfigVar -> evalisKConfigVar (normalize1 kl) config (-1)
|Lbl_'Plus'String__STRING -> eval_'Plus'String__STRING (normalize2 kl) config (-1)
|Lbl_'Xor_Perc'Int___INT -> eval_'Xor_Perc'Int___INT (normalize3 kl) config (-1)
|Lbl_'Pipe'Int__INT -> eval_'Pipe'Int__INT (normalize2 kl) config (-1)
|LblisSumCell -> evalisSumCell (normalize1 kl) config (-1)
|LblisKVariable -> evalisKVariable (normalize1 kl) config (-1)
|Lbl_dividesInt__INT -> eval_dividesInt__INT (normalize2 kl) config (-1)
|LblinitSumCell -> evalinitSumCell (normalize0 kl) config (-1)
|LblisCell -> evalisCell (normalize1 kl) config (-1)
|Lblvalues -> evalvalues (normalize1 kl) config (-1)
|LblrfindString -> evalrfindString (normalize3 kl) config (-1)
|LblupdateList -> evalupdateList (normalize3 kl) config (-1)
|LblSet'Coln'choice -> evalSet'Coln'choice (normalize1 kl) config (-1)
|LblList'Coln'get -> evalList'Coln'get (normalize2 kl) config (-1)
|LblisSumCellFragment -> evalisSumCellFragment (normalize1 kl) config (-1)
|LblSetItem -> evalSetItem (normalize1 kl) config (-1)
|LblisSumCellOpt -> evalisSumCellOpt (normalize1 kl) config (-1)
|LblcategoryChar -> evalcategoryChar (normalize1 kl) config (-1)
|LblisName -> evalisName (normalize1 kl) config (-1)
|LblSet'Coln'difference -> evalSet'Coln'difference (normalize2 kl) config (-1)
|LblfreshInt -> evalfreshInt (normalize1 kl) config (-1)
|LblisParCellFragment -> evalisParCellFragment (normalize1 kl) config (-1)
|LblisKCellOpt -> evalisKCellOpt (normalize1 kl) config (-1)
|Lbl_'_LT_'Int__INT -> eval_'_LT_'Int__INT (normalize2 kl) config (-1)
|Lbl'Stop'SummandCellBag -> eval'Stop'SummandCellBag (normalize0 kl) config (-1)
|Lbl'Stop'List -> eval'Stop'List (normalize0 kl) config (-1)
|Lbl_xorInt__INT -> eval_xorInt__INT (normalize2 kl) config (-1)
|LblMap'Coln'lookupOrDefault -> evalMap'Coln'lookupOrDefault (normalize3 kl) config (-1)
|LblrandInt -> evalrandInt (normalize1 kl) config (-1)
|LblString2Float -> evalString2Float (normalize1 kl) config (-1)
|Lbl'Hash'if_'Hash'then_'Hash'else_'Hash'fi_K'Hyph'EQUAL -> eval'Hash'if_'Hash'then_'Hash'else_'Hash'fi_K'Hyph'EQUAL (normalize3 kl) config (-1)
|LblisFloat -> evalisFloat (normalize1 kl) config (-1)
|LblisParCellOpt -> evalisParCellOpt (normalize1 kl) config (-1)
|LblinitBoundsCell -> evalinitBoundsCell (normalize0 kl) config (-1)
|Lblkeys_list'LPar'_'RPar'_MAP -> evalkeys_list'LPar'_'RPar'_MAP (normalize1 kl) config (-1)
|LblfreshId -> evalfreshId (normalize1 kl) config (-1)
|LblchrChar -> evalchrChar (normalize1 kl) config (-1)
|LblisProcCell -> evalisProcCell (normalize1 kl) config (-1)
|Lbl_'And'Int__INT -> eval_'And'Int__INT (normalize2 kl) config (-1)
|Lbl_orElseBool__BOOL -> eval_orElseBool__BOOL (normalize2 kl) config (-1)
|Lbl_divInt__INT -> eval_divInt__INT (normalize2 kl) config (-1)
|LblisParCell -> evalisParCell (normalize1 kl) config (-1)
|LblList'Coln'range -> evalList'Coln'range (normalize3 kl) config (-1)
|LblisProc -> evalisProc (normalize1 kl) config (-1)
|Lbl_'EqlsSlshEqls'Int__INT -> eval_'EqlsSlshEqls'Int__INT (normalize2 kl) config (-1)
|Lbl_'Plus'Int_ -> eval_'Plus'Int_ (normalize2 kl) config (-1)
|Lbl_'_LT__LT_'Int__INT -> eval_'_LT__LT_'Int__INT (normalize2 kl) config (-1)
|Lbllog2Int -> evallog2Int (normalize1 kl) config (-1)
|LblBoundCellBagItem -> evalBoundCellBagItem (normalize1 kl) config (-1)
|LblisKCell -> evalisKCell (normalize1 kl) config (-1)
|LblProcCellBagItem -> evalProcCellBagItem (normalize1 kl) config (-1)
|LblBase2String -> evalBase2String (normalize2 kl) config (-1)
|Lbl_orBool__BOOL -> eval_orBool__BOOL (normalize2 kl) config (-1)
|LblListItem -> evalListItem (normalize1 kl) config (-1)
|Lbl_'_GT_Eqls'String__STRING -> eval_'_GT_Eqls'String__STRING (normalize2 kl) config (-1)
|LblinitParCell -> evalinitParCell (normalize1 kl) config (-1)
|Lbl_'_GT_Eqls'Int__INT -> eval_'_GT_Eqls'Int__INT (normalize2 kl) config (-1)
|Lbl_'_LT_Eqls'Map__MAP -> eval_'_LT_Eqls'Map__MAP (normalize2 kl) config (-1)
|LblnewUUID_STRING -> evalnewUUID_STRING (normalize0 kl) config (-1)
|LblsizeMap -> evalsizeMap (normalize1 kl) config (-1)
|LblupdateMap -> evalupdateMap (normalize2 kl) config (-1)
|LblisBoundCellBag -> evalisBoundCellBag (normalize1 kl) config (-1)
|LblisId -> evalisId (normalize1 kl) config (-1)
|LblsubstrString -> evalsubstrString (normalize3 kl) config (-1)
|LblInt2String -> evalInt2String (normalize1 kl) config (-1)
|Lblsize -> evalsize (normalize1 kl) config (-1)
|Lbl_'EqlsSlshEqls'K_ -> eval_'EqlsSlshEqls'K_ (normalize2 kl) config (-1)
|LblisSummandCell -> evalisSummandCell (normalize1 kl) config (-1)
|LblcountAllOccurrences'LPar'_'Comm'_'RPar'_STRING -> evalcountAllOccurrences'LPar'_'Comm'_'RPar'_STRING (normalize2 kl) config (-1)
|Lbl_'_GT_'Int__INT -> eval_'_GT_'Int__INT (normalize2 kl) config (-1)
|Lblproject'Coln'Proc -> evalproject'Coln'Proc (normalize1 kl) config (-1)
|Lbl_BoundCellBag_ -> eval_BoundCellBag_ (normalize2 kl) config (-1)
|LblfillList -> evalfillList (normalize4 kl) config (-1)
|LblisProcCellBag -> evalisProcCellBag (normalize1 kl) config (-1)
|LblbitRangeInt -> evalbitRangeInt (normalize3 kl) config (-1)
|LblSummandCellBagItem -> evalSummandCellBagItem (normalize1 kl) config (-1)
|Lbl'Stop'ProcCellBag -> eval'Stop'ProcCellBag (normalize0 kl) config (-1)
|Lbl_'_LT_'String__STRING -> eval_'_LT_'String__STRING (normalize2 kl) config (-1)
|LblinitSummandCell -> evalinitSummandCell (normalize0 kl) config (-1)
|Lbl_inList_ -> eval_inList_ (normalize2 kl) config (-1)
|Lbl_List_ -> eval_List_ (normalize2 kl) config (-1)
|LblisBoundCell -> evalisBoundCell (normalize1 kl) config (-1)
|Lbl_'PipeHyph_GT_'_ -> eval_'PipeHyph_GT_'_ (normalize2 kl) config (-1)
|Lbl_xorBool__BOOL -> eval_xorBool__BOOL (normalize2 kl) config (-1)
|Lbl_'Hyph'Map__MAP -> eval_'Hyph'Map__MAP (normalize2 kl) config (-1)
|LblminInt'LPar'_'Comm'_'RPar'_INT -> evalminInt'LPar'_'Comm'_'RPar'_INT (normalize2 kl) config (-1)
|LblisMap -> evalisMap (normalize1 kl) config (-1)
|LblsrandInt -> evalsrandInt (normalize1 kl) config (-1)
|LblisKItem -> evalisKItem (normalize1 kl) config (-1)
|LblisBoundsCellFragment -> evalisBoundsCellFragment (normalize1 kl) config (-1)
|Lbl_'EqlsEqls'K_ -> eval_'EqlsEqls'K_ (normalize2 kl) config (-1)
|Lbl'Stop'BoundCellBag -> eval'Stop'BoundCellBag (normalize0 kl) config (-1)
|LblList'Coln'set -> evalList'Coln'set (normalize3 kl) config (-1)
|LblString2Base -> evalString2Base (normalize2 kl) config (-1)
|Lbl_'LSqB'_'RSqB'_SUBSTITUTION -> eval_'LSqB'_'RSqB'_SUBSTITUTION (normalize2 kl) config (-1)
|LblisTCellFragment -> evalisTCellFragment (normalize1 kl) config (-1)
|LblreplaceFirst'LPar'_'Comm'_'Comm'_'RPar'_STRING -> evalreplaceFirst'LPar'_'Comm'_'Comm'_'RPar'_STRING (normalize3 kl) config (-1)
|Lblreplace'LPar'_'Comm'_'Comm'_'Comm'_'RPar'_STRING -> evalreplace'LPar'_'Comm'_'Comm'_'Comm'_'RPar'_STRING (normalize4 kl) config (-1)
|Lbl_'Slsh'Int__INT -> eval_'Slsh'Int__INT (normalize2 kl) config (-1)
|Lbl_'LSqB'_'_LT_Hyph'_'RSqB'_MAP -> eval_'LSqB'_'_LT_Hyph'_'RSqB'_MAP (normalize3 kl) config (-1)
|Lblkeys -> evalkeys (normalize1 kl) config (-1)
|LblinitBoundCell -> evalinitBoundCell (normalize0 kl) config (-1)
|Lbl'Stop'Map -> eval'Stop'Map (normalize0 kl) config (-1)
|Lbl_'EqlsSlshEqls'String__STRING -> eval_'EqlsSlshEqls'String__STRING (normalize2 kl) config (-1)
| _ -> [denormalize c])
| _ -> [denormalize c]
let rec get_next_op_from_exp(c: kitem) : (k -> k * (step_function)) = step
and step (c:k) : k * step_function =
 try let config = c in match c with 
(*{| rule `<T>`(`<par>`(`_ProcCellBag_`(`<proc>`(_0,_1,`<sum>`(`_SummandCellBag_`(`` `<summand>`(`Nil_PI-SYNTAX`(.KList))=>`.SummandCellBag`(.KList)``,DotVar3))),DotVar1))) requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(482205607c5d4302c54454babf39445a48640b86144dacef746e2d5bb2d9e643) contentStartColumn(8) contentStartLine(71) org.kframework.attributes.Location(Location(71,8,71,59)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/Git/KFramework/Pi-Calc/./pi.k)) org.kframework.definition.Production(syntax RuleContent ::= K) structural()]|}*)
| (KApply1(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'par'_GT_',((eval_ProcCellBag_((KApply3(Lbl'_LT_'proc'_GT_',(var_0_250),(var_1_251),(KApply1(Lbl'_LT_'sum'_GT_',((eval_SummandCellBag_((KApply1(Lbl'_LT_'summand'_GT_',(KApply0(LblNil_PI'Hyph'SYNTAX) :: [])) :: []),(varDotVar3_252 :: [])) config (-1)) :: [])) :: [])) :: []),(varDotVar1_253 :: [])) config (-1)) :: [])) :: [])) :: []) -> (((KApply1(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'par'_GT_',((eval_ProcCellBag_((KApply3(Lbl'_LT_'proc'_GT_',(var_0_250),(var_1_251),(KApply1(Lbl'_LT_'sum'_GT_',((eval_SummandCellBag_(((Lazy.force const'Stop'SummandCellBag)),(varDotVar3_252 :: [])) config (-1)))) :: [])) :: []),(varDotVar1_253 :: [])) config (-1)))) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(`<par>`(`_ProcCellBag_`(`<proc>`(_0,_1,`<sum>`(`_SummandCellBag_`(`_SummandCellBag_`(`<summand>`(`` `Or`(N,M)=>N``),`` `.SummandCellBag`(.KList)=>`<summand>`(M)``),DotVar3))),DotVar1))) requires `_andBool_`(isNormProc(M),isNormProc(N)) ensures #token("true","Bool") [UNIQUE_ID(ba87a412350741ced5e7e6daffe704fc1dc320b0f22ea4f4ebe728551adb18a2) contentStartColumn(8) contentStartLine(68) org.kframework.attributes.Location(Location(68,8,69,40)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/Git/KFramework/Pi-Calc/./pi.k)) org.kframework.definition.Production(syntax RuleContent ::= K) structural()]|}*)
| (KApply1(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'par'_GT_',((eval_ProcCellBag_((KApply3(Lbl'_LT_'proc'_GT_',(var_0_254),(var_1_255),(KApply1(Lbl'_LT_'sum'_GT_',((eval_SummandCellBag_(((eval_SummandCellBag_((KApply1(Lbl'_LT_'summand'_GT_',(KApply2(LblOr,(varN_256 :: []),(varM_257 :: [])) :: [])) :: []),((Lazy.force const'Stop'SummandCellBag) :: [])) config (-1)) :: []),(varDotVar3_258 :: [])) config (-1)) :: [])) :: [])) :: []),(varDotVar1_259 :: [])) config (-1)) :: [])) :: [])) :: []) when (((isTrue (evalisNormProc((varM_257 :: [])) config (-1)))) && ((isTrue (evalisNormProc((varN_256 :: [])) config (-1))))) && (true) -> (((KApply1(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'par'_GT_',((eval_ProcCellBag_((KApply3(Lbl'_LT_'proc'_GT_',(var_0_254),(var_1_255),(KApply1(Lbl'_LT_'sum'_GT_',((eval_SummandCellBag_(((eval_SummandCellBag_((KApply1(Lbl'_LT_'summand'_GT_',(varN_256 :: [])) :: []),(KApply1(Lbl'_LT_'summand'_GT_',(varM_257 :: [])) :: [])) config (-1))),(varDotVar3_258 :: [])) config (-1)))) :: [])) :: []),(varDotVar1_259 :: [])) config (-1)))) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(`<par>`(`_ProcCellBag_`(`_ProcCellBag_`(`<proc>`(`<k>`(`` `Replication`(P)=>P``~>DotVar3),_0,_1),`` `.ProcCellBag`(.KList)=>`<proc>`(`<k>`(P),initBoundsCell(.KList),initSumCell(.KList))``),DotVar1))) requires isProc(P) ensures #token("true","Bool") [UNIQUE_ID(374a4ba6e872a71359d02e1d72fb5c9a74d73fb1231fed3ced34eaf9541af594) contentStartColumn(8) contentStartLine(49) org.kframework.attributes.Location(Location(49,8,50,49)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/Git/KFramework/Pi-Calc/./pi.k)) org.kframework.definition.Production(syntax RuleContent ::= K) structural()]|}*)
| (KApply1(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'par'_GT_',((eval_ProcCellBag_(((eval_ProcCellBag_((KApply3(Lbl'_LT_'proc'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(KApply1(LblReplication,(varP_260 :: [])) :: varDotVar3_261)) :: []),(var_0_262),(var_1_263)) :: []),((Lazy.force const'Stop'ProcCellBag) :: [])) config (-1)) :: []),(varDotVar1_264 :: [])) config (-1)) :: [])) :: [])) :: []) when (isTrue (evalisProc((varP_260 :: [])) config (-1))) && (true) -> (((KApply1(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'par'_GT_',((eval_ProcCellBag_(((eval_ProcCellBag_((KApply3(Lbl'_LT_'proc'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(varP_260 :: varDotVar3_261)) :: []),(var_0_262),(var_1_263)) :: []),(KApply3(Lbl'_LT_'proc'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(varP_260 :: [])) :: []),((Lazy.force constinitBoundsCell)),((Lazy.force constinitSumCell))) :: [])) config (-1))),(varDotVar1_264 :: [])) config (-1)))) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(`<par>`(`_ProcCellBag_`(`<proc>`(`<k>`(`` `New`(X,P)=>P``~>DotVar3),`<bounds>`(`_BoundCellBag_`(`` `.BoundCellBag`(.KList)=>`<bound>`(X)``,DotVar4)),DotVar2),DotVar1))) requires `_andBool_`(isProc(P),isName(X)) ensures #token("true","Bool") [UNIQUE_ID(61f877a35c585e40dafd331540b1e7ab78b1517fa811a21ba9fd5499641f4a93) contentStartColumn(8) contentStartLine(79) org.kframework.attributes.Location(Location(79,8,80,61)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/Git/KFramework/Pi-Calc/./pi.k)) org.kframework.definition.Production(syntax RuleContent ::= K) structural()]|}*)
| (KApply1(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'par'_GT_',((eval_ProcCellBag_((KApply3(Lbl'_LT_'proc'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(KApply2(LblNew,(varX_265 :: []),(varP_266 :: [])) :: varDotVar3_267)) :: []),(KApply1(Lbl'_LT_'bounds'_GT_',((eval_BoundCellBag_(((Lazy.force const'Stop'BoundCellBag) :: []),(varDotVar4_268 :: [])) config (-1)) :: [])) :: []),(varDotVar2_269)) :: []),(varDotVar1_270 :: [])) config (-1)) :: [])) :: [])) :: []) when (((isTrue (evalisProc((varP_266 :: [])) config (-1)))) && ((isTrue (evalisName((varX_265 :: [])) config (-1))))) && (true) -> (((KApply1(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'par'_GT_',((eval_ProcCellBag_((KApply3(Lbl'_LT_'proc'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(varP_266 :: varDotVar3_267)) :: []),(KApply1(Lbl'_LT_'bounds'_GT_',((eval_BoundCellBag_((KApply1(Lbl'_LT_'bound'_GT_',(varX_265 :: [])) :: []),(varDotVar4_268 :: [])) config (-1)))) :: []),(varDotVar2_269)) :: []),(varDotVar1_270 :: [])) config (-1)))) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(`<par>`(`_ProcCellBag_`(`_ProcCellBag_`(`<proc>`(`<k>`(`` `Par`(P,Q)=>P``),_0,_1),`` `.ProcCellBag`(.KList)=>`<proc>`(`<k>`(Q),initBoundsCell(.KList),initSumCell(.KList))``),DotVar1))) requires `_andBool_`(isProc(Q),isProc(P)) ensures #token("true","Bool") [UNIQUE_ID(62731f8379e3f6eedbb55e64e3c440e8c5d89ad7dde06d3ef4d6f59767d7a98a) contentStartColumn(8) contentStartLine(58) org.kframework.attributes.Location(Location(58,8,59,49)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/Git/KFramework/Pi-Calc/./pi.k)) org.kframework.definition.Production(syntax RuleContent ::= K) structural()]|}*)
| (KApply1(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'par'_GT_',((eval_ProcCellBag_(((eval_ProcCellBag_((KApply3(Lbl'_LT_'proc'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(KApply2(LblPar,(varP_271 :: []),(varQ_272 :: [])) :: [])) :: []),(var_0_273),(var_1_274)) :: []),((Lazy.force const'Stop'ProcCellBag) :: [])) config (-1)) :: []),(varDotVar1_275 :: [])) config (-1)) :: [])) :: [])) :: []) when (((isTrue (evalisProc((varQ_272 :: [])) config (-1)))) && ((isTrue (evalisProc((varP_271 :: [])) config (-1))))) && (true) -> (((KApply1(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'par'_GT_',((eval_ProcCellBag_(((eval_ProcCellBag_((KApply3(Lbl'_LT_'proc'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(varP_271 :: [])) :: []),(var_0_273),(var_1_274)) :: []),(KApply3(Lbl'_LT_'proc'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(varQ_272 :: [])) :: []),((Lazy.force constinitBoundsCell)),((Lazy.force constinitSumCell))) :: [])) config (-1))),(varDotVar1_275 :: [])) config (-1)))) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(`<par>`(`_ProcCellBag_`(`` `<proc>`(`<k>`(.K),DotVar2,`<sum>`(`.SummandCellBag`(.KList)))=>`.ProcCellBag`(.KList)``,DotVar1))) requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(f1be5fadeffa85f0fe2b2241aa9fae05df387e43c36aeae3d3687437f66025e3) contentStartColumn(8) contentStartLine(73) org.kframework.attributes.Location(Location(73,8,73,65)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/Git/KFramework/Pi-Calc/./pi.k)) org.kframework.definition.Production(syntax RuleContent ::= K) structural()]|}*)
| (KApply1(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'par'_GT_',((eval_ProcCellBag_((KApply3(Lbl'_LT_'proc'_GT_',(KApply1(Lbl'_LT_'k'_GT_',([])) :: []),(varDotVar2_276),(KApply1(Lbl'_LT_'sum'_GT_',((Lazy.force const'Stop'SummandCellBag) :: [])) :: [])) :: []),(varDotVar1_277 :: [])) config (-1)) :: [])) :: [])) :: []) -> (((KApply1(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'par'_GT_',((eval_ProcCellBag_(((Lazy.force const'Stop'ProcCellBag)),(varDotVar1_277 :: [])) config (-1)))) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(`<par>`(`_ProcCellBag_`(`<proc>`(`<k>`(``N=>.K``),DotVar2,`<sum>`(`` `.SummandCellBag`(.KList)=>`<summand>`(N)``)),DotVar1))) requires isNormProc(N) ensures #token("true","Bool") [UNIQUE_ID(cc95a9fdba286108d02af0c74d3af87cedcee69a2f4cc5253f6dc16395b0253c) contentStartColumn(8) contentStartLine(65) org.kframework.attributes.Location(Location(65,8,66,62)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/Git/KFramework/Pi-Calc/./pi.k)) org.kframework.definition.Production(syntax RuleContent ::= K) structural()]|}*)
| (KApply1(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'par'_GT_',((eval_ProcCellBag_((KApply3(Lbl'_LT_'proc'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(varN_278 :: [])) :: []),(varDotVar2_279),(KApply1(Lbl'_LT_'sum'_GT_',((Lazy.force const'Stop'SummandCellBag) :: [])) :: [])) :: []),(varDotVar1_280 :: [])) config (-1)) :: [])) :: [])) :: []) when (isTrue (evalisNormProc((varN_278 :: [])) config (-1))) && (true) -> (((KApply1(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'par'_GT_',((eval_ProcCellBag_((KApply3(Lbl'_LT_'proc'_GT_',(KApply1(Lbl'_LT_'k'_GT_',([])) :: []),(varDotVar2_279),(KApply1(Lbl'_LT_'sum'_GT_',(KApply1(Lbl'_LT_'summand'_GT_',(varN_278 :: [])) :: [])) :: [])) :: []),(varDotVar1_280 :: [])) config (-1)))) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(`<par>`(`_ProcCellBag_`(`` `<proc>`(`<k>`(`Nil_PI-SYNTAX`(.KList)),_0,_1)=>`.ProcCellBag`(.KList)``,DotVar1))) requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(15ae83fa0302a3e1c3682ca647dfd89129f01e983c6f2cd5590813a01fcfabbd) contentStartColumn(8) contentStartLine(61) org.kframework.attributes.Location(Location(61,8,61,49)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/Git/KFramework/Pi-Calc/./pi.k)) org.kframework.definition.Production(syntax RuleContent ::= K) structural()]|}*)
| (KApply1(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'par'_GT_',((eval_ProcCellBag_((KApply3(Lbl'_LT_'proc'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(KApply0(LblNil_PI'Hyph'SYNTAX) :: [])) :: []),(var_0_281),(var_1_282)) :: []),(varDotVar1_283 :: [])) config (-1)) :: [])) :: [])) :: []) -> (((KApply1(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'par'_GT_',((eval_ProcCellBag_(((Lazy.force const'Stop'ProcCellBag)),(varDotVar1_283 :: [])) config (-1)))) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(`<par>`(`_ProcCellBag_`(`_ProcCellBag_`(`<proc>`(`<k>`(``.K=>`_[_/_]_SUBSTITUTION`(P,Z,Y)``~>DotVar3),DotVar2,`` `<sum>`(`_SummandCellBag_`(`<summand>`(`Receive`(X,Y,P)),DotVar4))=>`<sum>`(`.SummandCellBag`(.KList))``),`<proc>`(`<k>`(``.K=>Q``~>DotVar6),DotVar5,`` `<sum>`(`_SummandCellBag_`(`<summand>`(`Send`(X,Z,Q)),DotVar7))=>`<sum>`(`.SummandCellBag`(.KList))``)),DotVar1))) requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isName(Y),isProc(Q)),isName(Z)),isProc(P)),isName(X)) ensures #token("true","Bool") [UNIQUE_ID(fdc216fa1763099e27a924646ec6f24e043c95e48b8dbd9751d1ad5a8b9b36ae) contentStartColumn(8) contentStartLine(88) org.kframework.attributes.Location(Location(88,8,107,15)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/Git/KFramework/Pi-Calc/./pi.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (KApply1(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'par'_GT_',((eval_ProcCellBag_(((eval_ProcCellBag_((KApply3(Lbl'_LT_'proc'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(varDotVar3_284)) :: []),(varDotVar2_285),(KApply1(Lbl'_LT_'sum'_GT_',((eval_SummandCellBag_((KApply1(Lbl'_LT_'summand'_GT_',(KApply3(LblReceive,(varX_286 :: []),(varY_287 :: []),(varP_288 :: [])) :: [])) :: []),(varDotVar4_289 :: [])) config (-1)) :: [])) :: [])) :: []),(KApply3(Lbl'_LT_'proc'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(varDotVar6_290)) :: []),(varDotVar5_291),(KApply1(Lbl'_LT_'sum'_GT_',((eval_SummandCellBag_((KApply1(Lbl'_LT_'summand'_GT_',(KApply3(LblSend,(varX_292 :: []),(varZ_293 :: []),(varQ_294 :: [])) :: [])) :: []),(varDotVar7_295 :: [])) config (-1)) :: [])) :: [])) :: [])) config (-1)) :: []),(varDotVar1_296 :: [])) config (-1)) :: [])) :: [])) :: []) when (((((((((isTrue (evalisName((varY_287 :: [])) config (-1)))) && ((isTrue (evalisProc((varQ_294 :: [])) config (-1)))))) && ((isTrue (evalisName((varZ_293 :: [])) config (-1)))))) && ((isTrue (evalisProc((varP_288 :: [])) config (-1)))))) && ((isTrue (evalisName((varX_286 :: [])) config (-1))))) && (((compare_kitem varX_286 varX_292) = 0) && true) -> (((KApply1(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'par'_GT_',((eval_ProcCellBag_(((eval_ProcCellBag_((KApply3(Lbl'_LT_'proc'_GT_',(KApply1(Lbl'_LT_'k'_GT_',((eval_'LSqB'_'Slsh'_'RSqB'_SUBSTITUTION((varP_288 :: []),(varZ_293 :: []),(varY_287 :: [])) config (-1)) @ varDotVar3_284)) :: []),(varDotVar2_285),(KApply1(Lbl'_LT_'sum'_GT_',((Lazy.force const'Stop'SummandCellBag))) :: [])) :: []),(KApply3(Lbl'_LT_'proc'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(varQ_294 :: varDotVar6_290)) :: []),(varDotVar5_291),(KApply1(Lbl'_LT_'sum'_GT_',((Lazy.force const'Stop'SummandCellBag))) :: [])) :: [])) config (-1))),(varDotVar1_296 :: [])) config (-1)))) :: [])) :: [])), (StepFunc step))
| _ -> lookups_step c c (-1)
with Sys.Break -> raise (Stuck c)
and lookups_step (c: k) (config: k) (guard: int) : k * step_function = match c with 
| _ -> raise (Stuck c)
let make_stuck (config: k) : k = config
let make_unstuck (config: k) : k = config
let get_thread_set (config: k) : k = [Map(SortMap,Lbl_Map_,KMap.empty)]
let set_thread_set (config: k) (set: k) : k = config
end
let () = Plugin.the_definition := Some (module Def)
