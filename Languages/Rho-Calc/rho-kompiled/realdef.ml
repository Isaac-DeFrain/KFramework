open Prelude
open Constants
open Constants.K
module Def = struct
let freshFunction (sort: string) (config: k) (counter: Z.t) : k = interned_bottom
let eval'Hash'argv (c: unit) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'argv and sort = 
SortList in match c with 
| _ -> try KREFLECTION.hook_argv c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let const'Hash'argv : k Lazy.t = lazy (eval'Hash'argv () interned_bottom (-1))
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
let evalisKCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisKCell and sort = 
SortBool in match c with 
(*{| rule ``isKCell(`<k>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'k'_GT_',(varK0_0)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isKCell(#KToken(#token("KCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortKCell, var__1) :: [])) -> ((Bool true) :: [])
(*{| rule ``isKCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_2)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisThreadCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisThreadCell and sort = 
SortBool in match c with 
(*{| rule ``isThreadCell(`<thread>`(K0))=>#token("true","Bool")`` requires isKCell(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'thread'_GT_',(varK0_3 :: [])) :: [])) when (isTrue (evalisKCell((varK0_3 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isThreadCell(#KToken(#token("ThreadCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortThreadCell, var__4) :: [])) -> ((Bool true) :: [])
(*{| rule ``isThreadCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_5)) -> ((Bool false) :: [])
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
let evalMap'Coln'lookup (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblMap'Coln'lookup and sort = 
SortKItem in match c with 
| _ -> try MAP.hook_lookup c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval'Hash'stderr_K'Hyph'IO (c: unit) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'stderr_K'Hyph'IO and sort = 
SortInt in match c with 
(*{| rule `` `#stderr_K-IO`(.KList)=>#token("2","Int")`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(11ef087f50cc8e9fe0fe6a8b028370816f2f2a3573af358ab6ca98318723d0e5) contentStartColumn(8) contentStartLine(910) org.kframework.attributes.Location(Location(910,8,910,20)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| () -> ((Lazy.force int2) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let const'Hash'stderr_K'Hyph'IO : k Lazy.t = lazy (eval'Hash'stderr_K'Hyph'IO () interned_bottom (-1))
let evalisThreadCellBag (c: k) (config: k) (guard: int) : k = let lbl = 
LblisThreadCellBag and sort = 
SortBool in match c with 
(*{| rule ``isThreadCellBag(#KToken(#token("ThreadCellBag","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortThreadCellBag, var__6) :: [])) -> ((Bool true) :: [])
(*{| rule ``isThreadCellBag(#KToken(#token("ThreadCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortThreadCell, var__7) :: [])) -> ((Bool true) :: [])
(*{| rule ``isThreadCellBag(`<thread>`(K0))=>#token("true","Bool")`` requires isKCell(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'thread'_GT_',(varK0_8 :: [])) :: [])) when (isTrue (evalisKCell((varK0_8 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isThreadCellBag(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_9)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisActivityCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisActivityCell and sort = 
SortBool in match c with 
(*{| rule ``isActivityCell(`<activity>`(K0))=>#token("true","Bool")`` requires isThreadCellBag(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'activity'_GT_',(varK0_10 :: [])) :: [])) when (isTrue (evalisThreadCellBag((varK0_10 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isActivityCell(#KToken(#token("ActivityCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortActivityCell, var__11) :: [])) -> ((Bool true) :: [])
(*{| rule ``isActivityCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_12)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Hash'seek'LPar'_'Comm'_'RPar'_K'Hyph'IO (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'seek'LPar'_'Comm'_'RPar'_K'Hyph'IO and sort = 
SortK in match c with 
| _ -> try IO.hook_seek c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
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
| ((KToken (SortBool, var__13) :: [])) -> ((Bool true) :: [])
(*{| rule ``isBool(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_14)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_andBool_ (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_andBool_ and sort = 
SortBool in match c with 
| _ -> try BOOL.hook_and c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_andBool_`(#token("true","Bool"),B)=>B`` requires isBool(B) ensures #token("true","Bool") [UNIQUE_ID(cd0a9b340fae24c9a05126d8df860cb7145fc64875711e36efaa694085559dc0) contentStartColumn(8) contentStartLine(302) org.kframework.attributes.Location(Location(302,8,302,37)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool true) :: []),((Bool _ as varB_15) :: [])) when true && (true) -> (varB_15 :: [])
(*{| rule `` `_andBool_`(B,#token("true","Bool"))=>B`` requires isBool(B) ensures #token("true","Bool") [UNIQUE_ID(b598bf51d1c959b7112e06b7f85a391ee5a18108acd52bb65ea27ef0381ed0e0) contentStartColumn(8) contentStartLine(303) org.kframework.attributes.Location(Location(303,8,303,37)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool _ as varB_16) :: []),((Bool true) :: [])) when true && (true) -> (varB_16 :: [])
(*{| rule `` `_andBool_`(_4,#token("false","Bool"))=>#token("false","Bool")`` requires isBool(_4) ensures #token("true","Bool") [UNIQUE_ID(1a7512841ede635d09556466797d23f3f3cec57fe0fb6a68ce0c3a1cccb0b68f) contentStartColumn(8) contentStartLine(305) org.kframework.attributes.Location(Location(305,8,305,37)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool _ as var_4_17) :: []),((Bool false) :: [])) when true && (true) -> ((Bool false) :: [])
(*{| rule `` `_andBool_`(#token("false","Bool"),_9)=>#token("false","Bool")`` requires isBool(_9) ensures #token("true","Bool") [UNIQUE_ID(e6ebe927ba416a1602679eb0166f22d394adf70452e0505c00f11c036a896253) contentStartColumn(8) contentStartLine(304) org.kframework.attributes.Location(Location(304,8,304,37)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool false) :: []),((Bool _ as var_9_18) :: [])) when true && (true) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'EqlsEqls'Bool__BOOL (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'EqlsEqls'Bool__BOOL and sort = 
SortBool in match c with 
| _ -> try BOOL.hook_eq c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_==Bool__BOOL`(K1,K2)=>`_==K_`(K1,K2)`` requires `_andBool_`(isBool(K1),isBool(K2)) ensures #token("true","Bool") [UNIQUE_ID(a17699668426366833f88851c95d611be854ecef7a676d2061669bf689f05fd1) contentStartColumn(8) contentStartLine(765) org.kframework.attributes.Location(Location(765,8,765,43)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool _ as varK1_19) :: []),((Bool _ as varK2_20) :: [])) when ((true) && (true)) && (true) -> ((eval_'EqlsEqls'K_((varK1_19 :: []),(varK2_20 :: [])) config (-1)))
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
let evalisInt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisInt and sort = 
SortBool in match c with 
| [Int _] -> [Bool true]
(*{| rule ``isInt(#KToken(#token("Int","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortInt, var__21) :: [])) -> ((Bool true) :: [])
(*{| rule ``isInt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_22)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_'EqlsEqls'Int_ (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'EqlsEqls'Int_ and sort = 
SortBool in match c with 
| _ -> try INT.hook_eq c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_==Int_`(I1,I2)=>`_==K_`(I1,I2)`` requires `_andBool_`(isInt(I1),isInt(I2)) ensures #token("true","Bool") [UNIQUE_ID(e92e4aa4a18bee70f2627cdafb8687e2dfcc0dd6a7f8cbb8d1bd17d751c2da2a) contentStartColumn(8) contentStartLine(407) org.kframework.attributes.Location(Location(407,8,407,40)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Int _ as varI1_23) :: []),((Int _ as varI2_24) :: [])) when ((true) && (true)) && (true) -> ((eval_'EqlsEqls'K_((varI1_23 :: []),(varI2_24 :: [])) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'EqlsSlshEqls'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'EqlsSlshEqls'Int__INT and sort = 
SortBool in match c with 
| _ -> try INT.hook_ne c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_=/=Int__INT`(I1,I2)=>`notBool_`(`_==Int_`(I1,I2))`` requires `_andBool_`(isInt(I1),isInt(I2)) ensures #token("true","Bool") [UNIQUE_ID(59ca895589d5fc7fa573380dac68ddd6602f6fa8b2761530a861aa894455f27e) contentStartColumn(8) contentStartLine(408) org.kframework.attributes.Location(Location(408,8,408,53)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Int _ as varI1_25) :: []),((Int _ as varI2_26) :: [])) when ((true) && (true)) && (true) -> ([Bool ((not ((isTrue (eval_'EqlsEqls'Int_((varI1_25 :: []),(varI2_26 :: [])) config (-1))))))])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_modInt__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_modInt__INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_emod c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_modInt__INT`(I1,I2)=>`_%Int__INT`(`_+Int_`(`_%Int__INT`(I1,absInt(I2)),absInt(I2)),absInt(I2))`` requires `_andBool_`(`_andBool_`(isInt(I1),isInt(I2)),`_=/=Int__INT`(I2,#token("0","Int"))) ensures #token("true","Bool") [UNIQUE_ID(fb4bf5b2f12862af75611e525d51d7e1966bcc322ee8456d2ed1cdaadf02f6f5) concrete() contentStartColumn(5) contentStartLine(391) org.kframework.attributes.Location(Location(391,5,394,23)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
| (((Int _ as varI1_27) :: []),((Int _ as varI2_28) :: [])) when ((((true) && (true))) && ((isTrue (eval_'EqlsSlshEqls'Int__INT((varI2_28 :: []),((Lazy.force int0) :: [])) config (-1))))) && (true) -> ((eval_'Perc'Int__INT(((eval_'Plus'Int_(((eval_'Perc'Int__INT((varI1_27 :: []),((evalabsInt((varI2_28 :: [])) config (-1)))) config (-1))),((evalabsInt((varI2_28 :: [])) config (-1)))) config (-1))),((evalabsInt((varI2_28 :: [])) config (-1)))) config (-1)))
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
| (((Int _ as varI_29) :: []),((Int _ as varIDX_30) :: []),((Int _ as varLEN_31) :: [])) when ((((true) && (true))) && (true)) && (true) -> ((eval_modInt__INT(((eval_'_GT__GT_'Int__INT((varI_29 :: []),(varIDX_30 :: [])) config (-1))),((eval_'_LT__LT_'Int__INT(((Lazy.force int1) :: []),(varLEN_31 :: [])) config (-1)))) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let evalsignExtendBitRangeInt (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
LblsignExtendBitRangeInt and sort = 
SortInt in match c with 
| _ -> try INT.hook_signExtendBitRange c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule ``signExtendBitRangeInt(I,IDX,LEN)=>`_-Int__INT`(`_modInt__INT`(`_+Int_`(bitRangeInt(I,IDX,LEN),`_<<Int__INT`(#token("1","Int"),`_-Int__INT`(LEN,#token("1","Int")))),`_<<Int__INT`(#token("1","Int"),LEN)),`_<<Int__INT`(#token("1","Int"),`_-Int__INT`(LEN,#token("1","Int"))))`` requires `_andBool_`(`_andBool_`(isInt(I),isInt(LEN)),isInt(IDX)) ensures #token("true","Bool") [UNIQUE_ID(b413c3f4500443aec69bee9b10feb030330d60bd136c698a9947546393728a00) contentStartColumn(8) contentStartLine(386) org.kframework.attributes.Location(Location(386,8,386,149)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Int _ as varI_32) :: []),((Int _ as varIDX_33) :: []),((Int _ as varLEN_34) :: [])) when ((((true) && (true))) && (true)) && (true) -> ((eval_'Hyph'Int__INT(((eval_modInt__INT(((eval_'Plus'Int_(((evalbitRangeInt((varI_32 :: []),(varIDX_33 :: []),(varLEN_34 :: [])) config (-1))),((eval_'_LT__LT_'Int__INT(((Lazy.force int1) :: []),((eval_'Hyph'Int__INT((varLEN_34 :: []),((Lazy.force int1) :: [])) config (-1)))) config (-1)))) config (-1))),((eval_'_LT__LT_'Int__INT(((Lazy.force int1) :: []),(varLEN_34 :: [])) config (-1)))) config (-1))),((eval_'_LT__LT_'Int__INT(((Lazy.force int1) :: []),((eval_'Hyph'Int__INT((varLEN_34 :: []),((Lazy.force int1) :: [])) config (-1)))) config (-1)))) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let evalisSet (c: k) (config: k) (guard: int) : k = let lbl = 
LblisSet and sort = 
SortBool in match c with 
| [Set (s,_,_)] when (s = SortSet) -> [Bool true]
(*{| rule ``isSet(#KToken(#token("Set","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSet, var__35) :: [])) -> ((Bool true) :: [])
(*{| rule ``isSet(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_36)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Hash'getenv (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'getenv and sort = 
SortString in match c with 
| _ -> try KREFLECTION.hook_getenv c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisSchanCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisSchanCell and sort = 
SortBool in match c with 
(*{| rule ``isSchanCell(#KToken(#token("SchanCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSchanCell, var__37) :: [])) -> ((Bool true) :: [])
(*{| rule ``isSchanCell(`<schan>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'schan'_GT_',(varK0_38)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isSchanCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_39)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisMsgCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisMsgCell and sort = 
SortBool in match c with 
(*{| rule ``isMsgCell(`<msg>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'msg'_GT_',(varK0_40)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isMsgCell(#KToken(#token("MsgCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortMsgCell, var__41) :: [])) -> ((Bool true) :: [])
(*{| rule ``isMsgCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_42)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisSendCellBag (c: k) (config: k) (guard: int) : k = let lbl = 
LblisSendCellBag and sort = 
SortBool in match c with 
(*{| rule ``isSendCellBag(#KToken(#token("SendCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSendCell, var__43) :: [])) -> ((Bool true) :: [])
(*{| rule ``isSendCellBag(`<send>`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isSchanCell(K0),isMsgCell(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl'_LT_'send'_GT_',(varK0_44 :: []),(varK1_45 :: [])) :: [])) when (((isTrue (evalisSchanCell((varK0_44 :: [])) config (-1)))) && ((isTrue (evalisMsgCell((varK1_45 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isSendCellBag(#KToken(#token("SendCellBag","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSendCellBag, var__46) :: [])) -> ((Bool true) :: [])
(*{| rule ``isSendCellBag(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_47)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisSendsCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisSendsCell and sort = 
SortBool in match c with 
(*{| rule ``isSendsCell(`<sends>`(K0))=>#token("true","Bool")`` requires isSendCellBag(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'sends'_GT_',(varK0_48 :: [])) :: [])) when (isTrue (evalisSendCellBag((varK0_48 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isSendsCell(#KToken(#token("SendsCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSendsCell, var__49) :: [])) -> ((Bool true) :: [])
(*{| rule ``isSendsCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_50)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisRchanCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisRchanCell and sort = 
SortBool in match c with 
(*{| rule ``isRchanCell(#KToken(#token("RchanCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRchanCell, var__51) :: [])) -> ((Bool true) :: [])
(*{| rule ``isRchanCell(`<rchan>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'rchan'_GT_',(varK0_52)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isRchanCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_53)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisBindCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisBindCell and sort = 
SortBool in match c with 
(*{| rule ``isBindCell(`<bind>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'bind'_GT_',(varK0_54)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isBindCell(#KToken(#token("BindCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortBindCell, var__55) :: [])) -> ((Bool true) :: [])
(*{| rule ``isBindCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_56)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisContCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisContCell and sort = 
SortBool in match c with 
(*{| rule ``isContCell(`<cont>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'cont'_GT_',(varK0_57)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isContCell(#KToken(#token("ContCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortContCell, var__58) :: [])) -> ((Bool true) :: [])
(*{| rule ``isContCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_59)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisRecCellBag (c: k) (config: k) (guard: int) : k = let lbl = 
LblisRecCellBag and sort = 
SortBool in match c with 
(*{| rule ``isRecCellBag(#KToken(#token("RecCellBag","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRecCellBag, var__60) :: [])) -> ((Bool true) :: [])
(*{| rule ``isRecCellBag(`<rec>`(K0,K1,K2))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(isRchanCell(K0),isBindCell(K1)),isContCell(K2)) ensures #token("true","Bool") []|}*)
| ((KApply3(Lbl'_LT_'rec'_GT_',(varK0_61 :: []),(varK1_62 :: []),(varK2_63 :: [])) :: [])) when (((((isTrue (evalisRchanCell((varK0_61 :: [])) config (-1)))) && ((isTrue (evalisBindCell((varK1_62 :: [])) config (-1)))))) && ((isTrue (evalisContCell((varK2_63 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isRecCellBag(#KToken(#token("RecCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRecCell, var__64) :: [])) -> ((Bool true) :: [])
(*{| rule ``isRecCellBag(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_65)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisRecsCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisRecsCell and sort = 
SortBool in match c with 
(*{| rule ``isRecsCell(#KToken(#token("RecsCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRecsCell, var__66) :: [])) -> ((Bool true) :: [])
(*{| rule ``isRecsCell(`<recs>`(K0))=>#token("true","Bool")`` requires isRecCellBag(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'recs'_GT_',(varK0_67 :: [])) :: [])) when (isTrue (evalisRecCellBag((varK0_67 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isRecsCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_68)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisTuplespaceCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisTuplespaceCell and sort = 
SortBool in match c with 
(*{| rule ``isTuplespaceCell(#KToken(#token("TuplespaceCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortTuplespaceCell, var__69) :: [])) -> ((Bool true) :: [])
(*{| rule ``isTuplespaceCell(`<tuplespace>`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isSendsCell(K0),isRecsCell(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl'_LT_'tuplespace'_GT_',(varK0_70 :: []),(varK1_71 :: [])) :: [])) when (((isTrue (evalisSendsCell((varK0_70 :: [])) config (-1)))) && ((isTrue (evalisRecsCell((varK1_71 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isTuplespaceCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_72)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalintersectSet (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblintersectSet and sort = 
SortSet in match c with 
| _ -> try SET.hook_intersection c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalinitMsgCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitMsgCell and sort = 
SortMsgCell in match c with 
(*{| rule ``initMsgCell(.KList)=>`<msg>`(.K)`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(1b2eec790506b4e2b5dc92efe6a0fd6aa6ec03227fcef86f1d415c06b10a6181) initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'msg'_GT_',([])) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitMsgCell : k Lazy.t = lazy (evalinitMsgCell () interned_bottom (-1))
let eval_in_keys'LPar'_'RPar'_MAP (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_in_keys'LPar'_'RPar'_MAP and sort = 
SortBool in match c with 
| _ -> try MAP.hook_in_keys c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisString (c: k) (config: k) (guard: int) : k = let lbl = 
LblisString and sort = 
SortBool in match c with 
| [String _] -> [Bool true]
(*{| rule ``isString(#KToken(#token("String","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortString, var__73) :: [])) -> ((Bool true) :: [])
(*{| rule ``isString(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_74)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Hash'if_'Hash'then_'Hash'else_'Hash'fi_K'Hyph'EQUAL (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'if_'Hash'then_'Hash'else_'Hash'fi_K'Hyph'EQUAL and sort = 
SortK in match c with 
| _ -> try KEQUAL.hook_ite c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `#if_#then_#else_#fi_K-EQUAL`(C,B1,_10)=>B1`` requires `_andBool_`(isBool(C),C) ensures #token("true","Bool") [UNIQUE_ID(0883a4d4051090478d6b8a7ac8d4e0e15e7708308fa24e63137b9ac7e87383aa) contentStartColumn(8) contentStartLine(769) org.kframework.attributes.Location(Location(769,8,769,56)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
| (((Bool _ as varC_75) :: []),(varB1_76),(var_10_77)) when ((true) && ((isTrue [varC_75]))) && (true) -> (varB1_76)
(*{| rule `` `#if_#then_#else_#fi_K-EQUAL`(C,_11,B2)=>B2`` requires `_andBool_`(isBool(C),`notBool_`(C)) ensures #token("true","Bool") [UNIQUE_ID(d46b5ae094d17de19ef9725da497c32e21813c6e4b5a0d6a2c4b03bd55bb312c) contentStartColumn(8) contentStartLine(770) org.kframework.attributes.Location(Location(770,8,770,64)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
| (((Bool _ as varC_78) :: []),(var_11_79),(varB2_80)) when ((true) && ((not ((isTrue [varC_78]))))) && (true) -> (varB2_80)
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
| (((Int _ as varI1_81) :: []),((Int _ as varI2_82) :: [])) when ((((true) && (true))) && ((isTrue (eval_'_LT_Eqls'Int__INT((varI1_81 :: []),(varI2_82 :: [])) config (-1))))) && (true) -> (varI1_81 :: [])
(*{| rule `` `minInt(_,_)_INT`(I1,I2)=>I2`` requires `_andBool_`(`_andBool_`(isInt(I1),isInt(I2)),`_>=Int__INT`(I1,I2)) ensures #token("true","Bool") [UNIQUE_ID(f93c59dd0bdb46ab467898db4ad231d94d30e5b88427054becac14f3969eff8e) contentStartColumn(8) contentStartLine(397) org.kframework.attributes.Location(Location(397,8,397,57)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
| (((Int _ as varI1_83) :: []),((Int _ as varI2_84) :: [])) when ((((true) && (true))) && ((isTrue (eval_'_GT_Eqls'Int__INT((varI1_83 :: []),(varI2_84 :: [])) config (-1))))) && (true) -> (varI2_84 :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'EqlsEqls'String__STRING (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'EqlsEqls'String__STRING and sort = 
SortBool in match c with 
| _ -> try STRING.hook_eq c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_==String__STRING`(S1,S2)=>`_==K_`(S1,S2)`` requires `_andBool_`(isString(S2),isString(S1)) ensures #token("true","Bool") [UNIQUE_ID(daddd877c886e178648c9a2a7a5b307a0f59225ac211c099829b467bb5ebf98d) contentStartColumn(8) contentStartLine(537) org.kframework.attributes.Location(Location(537,8,537,49)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((String _ as varS1_85) :: []),((String _ as varS2_86) :: [])) when ((true) && (true)) && (true) -> ((eval_'EqlsEqls'K_((varS1_85 :: []),(varS2_86 :: [])) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'EqlsSlshEqls'String__STRING (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'EqlsSlshEqls'String__STRING and sort = 
SortBool in match c with 
| _ -> try STRING.hook_ne c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_=/=String__STRING`(S1,S2)=>`notBool_`(`_==String__STRING`(S1,S2))`` requires `_andBool_`(isString(S2),isString(S1)) ensures #token("true","Bool") [UNIQUE_ID(2a5c8974455ca9cde473273aeca1a4fa8072aa68d104bc94daa71ee7bf52c8a4) contentStartColumn(8) contentStartLine(536) org.kframework.attributes.Location(Location(536,8,536,65)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((String _ as varS1_87) :: []),((String _ as varS2_88) :: [])) when ((true) && (true)) && (true) -> ([Bool ((not ((isTrue (eval_'EqlsEqls'String__STRING((varS1_87 :: []),(varS2_88 :: [])) config (-1))))))])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let rec evalfindChar (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
LblfindChar and sort = 
SortInt in match c with 
| _ -> try STRING.hook_findChar c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule ``findChar(_13,#token("\"\"","String"),_14)=>#token("-1","Int")`` requires `_andBool_`(isInt(_14),isString(_13)) ensures #token("true","Bool") [UNIQUE_ID(3c92cdc7bbe8b210d199a92b38a24538ca780f801572b653c3cb72d6d89a2adf) contentStartColumn(8) contentStartLine(554) org.kframework.attributes.Location(Location(554,8,554,32)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((String _ as var_13_89) :: []),((String "") :: []),((Int _ as var_14_90) :: [])) when ((true) && (true)) && (true) -> ((Lazy.force int'Hyph'1) :: [])
(*{| rule ``findChar(S1,S2,I)=>`#if_#then_#else_#fi_K-EQUAL`(`_==Int_`(findString(S1,substrString(S2,#token("0","Int"),#token("1","Int")),I),#token("-1","Int")),findChar(S1,substrString(S2,#token("1","Int"),lengthString(S2)),I),`#if_#then_#else_#fi_K-EQUAL`(`_==Int_`(findChar(S1,substrString(S2,#token("1","Int"),lengthString(S2)),I),#token("-1","Int")),findString(S1,substrString(S2,#token("0","Int"),#token("1","Int")),I),`minInt(_,_)_INT`(findString(S1,substrString(S2,#token("0","Int"),#token("1","Int")),I),findChar(S1,substrString(S2,#token("1","Int"),lengthString(S2)),I))))`` requires `_andBool_`(`_andBool_`(`_andBool_`(isInt(I),isString(S2)),isString(S1)),`_=/=String__STRING`(S2,#token("\"\"","String"))) ensures #token("true","Bool") [UNIQUE_ID(5a89a8f3b78438530e84da3913f33203b224f3c348d32f09785edd80c9cfe137) contentStartColumn(8) contentStartLine(553) org.kframework.attributes.Location(Location(553,8,553,431)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
| (((String _ as varS1_91) :: []),((String _ as varS2_92) :: []),((Int _ as varI_93) :: [])) when ((((((true) && (true))) && (true))) && ((isTrue (eval_'EqlsSlshEqls'String__STRING((varS2_92 :: []),((String "") :: [])) config (-1))))) && (true) -> ((if ((isTrue (eval_'EqlsEqls'Int_(((evalfindString((varS1_91 :: []),((evalsubstrString((varS2_92 :: []),((Lazy.force int0) :: []),((Lazy.force int1) :: [])) config (-1))),(varI_93 :: [])) config (-1))),((Lazy.force int'Hyph'1) :: [])) config (-1)))) then (((evalfindChar((varS1_91 :: []),((evalsubstrString((varS2_92 :: []),((Lazy.force int1) :: []),((evallengthString((varS2_92 :: [])) config (-1)))) config (-1))),(varI_93 :: [])) config (-1)))) else (((if ((isTrue (eval_'EqlsEqls'Int_(((evalfindChar((varS1_91 :: []),((evalsubstrString((varS2_92 :: []),((Lazy.force int1) :: []),((evallengthString((varS2_92 :: [])) config (-1)))) config (-1))),(varI_93 :: [])) config (-1))),((Lazy.force int'Hyph'1) :: [])) config (-1)))) then (((evalfindString((varS1_91 :: []),((evalsubstrString((varS2_92 :: []),((Lazy.force int0) :: []),((Lazy.force int1) :: [])) config (-1))),(varI_93 :: [])) config (-1)))) else (((evalminInt'LPar'_'Comm'_'RPar'_INT(((evalfindString((varS1_91 :: []),((evalsubstrString((varS2_92 :: []),((Lazy.force int0) :: []),((Lazy.force int1) :: [])) config (-1))),(varI_93 :: [])) config (-1))),((evalfindChar((varS1_91 :: []),((evalsubstrString((varS2_92 :: []),((Lazy.force int1) :: []),((evallengthString((varS2_92 :: [])) config (-1)))) config (-1))),(varI_93 :: [])) config (-1)))) config (-1)))))))))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
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
let eval_'_LT_Eqls'Set__SET (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'_LT_Eqls'Set__SET and sort = 
SortBool in match c with 
| _ -> try SET.hook_inclusion c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalproject'Coln'Proc (c: k) (config: k) (guard: int) : k = let lbl = 
Lblproject'Coln'Proc and sort = 
SortProc in match c with 
(*{| rule `` `project:Proc`(K)=>K`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(cb126cf017df4e6349622538a0090ca4f49fe00ccf73259bbd5ec5a3e59e3beb) projection()]|}*)
| ((varK_94 :: [])) -> (varK_94 :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let rec evalisName (c: k) (config: k) (guard: int) : k = let lbl = 
LblisName and sort = 
SortBool in match c with 
(*{| rule ``isName(#KToken(#token("Id","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortId, var__95) :: [])) -> ((Bool true) :: [])
(*{| rule ``isName(`Quote`(K0))=>#token("true","Bool")`` requires isProc(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(LblQuote,(varK0_96 :: [])) :: [])) when (isTrue (evalisProc((varK0_96 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isName(#KToken(#token("Name","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortName, var__97) :: [])) -> ((Bool true) :: [])
(*{| rule ``isName(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_98)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
and evalisProc (c: k) (config: k) (guard: int) : k = let lbl = 
LblisProc and sort = 
SortBool in match c with 
(*{| rule ``isProc(#KToken(#token("Proc","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortProc, var__99) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProc(`Send`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isName(K0),isProc(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(LblSend,(varK0_100 :: []),(varK1_101 :: [])) :: [])) when (((isTrue (evalisName((varK0_100 :: [])) config (-1)))) && ((isTrue (evalisProc((varK1_101 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProc(`Rec`(K0,K1,K2))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(isName(K0),isName(K1)),isProc(K2)) ensures #token("true","Bool") []|}*)
| ((KApply3(LblRec,(varK0_102 :: []),(varK1_103 :: []),(varK2_104 :: [])) :: [])) when (((((isTrue (evalisName((varK0_102 :: [])) config (-1)))) && ((isTrue (evalisName((varK1_103 :: [])) config (-1)))))) && ((isTrue (evalisProc((varK2_104 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProc(`Reify`(K0))=>#token("true","Bool")`` requires isName(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(LblReify,(varK0_105 :: [])) :: [])) when (isTrue (evalisName((varK0_105 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProc(`Stop`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblStop) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProc(`Par`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isProc(K0),isProc(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(LblPar,(varK0_106 :: []),(varK1_107 :: [])) :: [])) when (((isTrue (evalisProc((varK0_106 :: [])) config (-1)))) && ((isTrue (evalisProc((varK1_107 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProc(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_108)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalinitKCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblinitKCell and sort = 
SortKCell in match c with 
(*{| rule ``initKCell(Init)=>`<k>`(`project:Proc`(`Map:lookup`(Init,#token("$PGM","KConfigVar"))))`` requires isProc(`project:Proc`(`Map:lookup`(Init,#token("$PGM","KConfigVar")))) ensures #token("true","Bool") [UNIQUE_ID(d3d92662c16a4dde1625ade96c567eef65d6dc0ed7c3f0ee2b3d4001d0c3f393) initializer()]|}*)
| (((Map (SortMap,_,_) as varInit_109) :: [])) when (isTrue (evalisProc(((evalproject'Coln'Proc(((evalMap'Coln'lookup((varInit_109 :: []),(KToken (SortKConfigVar, "$PGM") :: [])) config (-1)))) config (-1)))) config (-1))) && (true) -> (KApply1(Lbl'_LT_'k'_GT_',((evalproject'Coln'Proc(((evalMap'Coln'lookup((varInit_109 :: []),(KToken (SortKConfigVar, "$PGM") :: [])) config (-1)))) config (-1)))) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalinitThreadCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblinitThreadCell and sort = 
SortThreadCell in match c with 
(*{| rule ``initThreadCell(Init)=>`<thread>`(initKCell(Init))`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(0eb9a346d4152f513a1782dc6b34441979e54d9311b37b51fa40edf829c8b39e) initializer()]|}*)
| (((Map (SortMap,_,_) as varInit_110) :: [])) -> (KApply1(Lbl'_LT_'thread'_GT_',((evalinitKCell((varInit_110 :: [])) config (-1)))) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisIOError (c: k) (config: k) (guard: int) : k = let lbl = 
LblisIOError and sort = 
SortBool in match c with 
(*{| rule ``isIOError(`#ECONNREFUSED_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ECONNREFUSED_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EPIPE_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EPIPE_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ETOOMANYREFS_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ETOOMANYREFS_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENETUNREACH_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENETUNREACH_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EBUSY_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EBUSY_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EHOSTDOWN_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EHOSTDOWN_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENOTEMPTY_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENOTEMPTY_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EFBIG_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EFBIG_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#E2BIG_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'E2BIG_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENOLCK_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENOLCK_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EROFS_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EROFS_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EISCONN_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EISCONN_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ESRCH_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ESRCH_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EINPROGRESS_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EINPROGRESS_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ERANGE_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ERANGE_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(#KToken(#token("IOError","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortIOError, var__111) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENOBUFS_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENOBUFS_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENOSPC_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENOSPC_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EADDRINUSE_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EADDRINUSE_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EAFNOSUPPORT_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EAFNOSUPPORT_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EDOM_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EDOM_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EIO_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EIO_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EOPNOTSUPP_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EOPNOTSUPP_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENAMETOOLONG_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENAMETOOLONG_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EPERM_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EPERM_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EPROTONOSUPPORT_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EPROTONOSUPPORT_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EMLINK_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EMLINK_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENOENT_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENOENT_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENOMEM_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENOMEM_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ECONNRESET_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ECONNRESET_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EWOULDBLOCK_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EWOULDBLOCK_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENOEXEC_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENOEXEC_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ECONNABORTED_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ECONNABORTED_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENOSYS_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENOSYS_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EHOSTUNREACH_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EHOSTUNREACH_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EEXIST_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EEXIST_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(#unknownIOError(K0))=>#token("true","Bool")`` requires isInt(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Hash'unknownIOError,((Int _ as varK0_112) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EDESTADDRREQ_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EDESTADDRREQ_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EBADF_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EBADF_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EXDEV_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EXDEV_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENOTCONN_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENOTCONN_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENFILE_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENFILE_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENODEV_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENODEV_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENXIO_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENXIO_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENETRESET_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENETRESET_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EPFNOSUPPORT_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EPFNOSUPPORT_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EISDIR_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EISDIR_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ETIMEDOUT_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ETIMEDOUT_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EINVAL_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EINVAL_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EAGAIN_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EAGAIN_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ESPIPE_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ESPIPE_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EMFILE_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EMFILE_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EFAULT_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EFAULT_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENETDOWN_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENETDOWN_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EOVERFLOW_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EOVERFLOW_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EACCES_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EACCES_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EOF_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EOF_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EDEADLK_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EDEADLK_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENOTSOCK_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENOTSOCK_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ECHILD_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ECHILD_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EPROTOTYPE_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EPROTOTYPE_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENOPROTOOPT_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENOPROTOOPT_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EINTR_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EINTR_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ELOOP_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ELOOP_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ESHUTDOWN_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ESHUTDOWN_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EMSGSIZE_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EMSGSIZE_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENOTDIR_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENOTDIR_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EALREADY_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EALREADY_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENOTTY_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENOTTY_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ESOCKTNOSUPPORT_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ESOCKTNOSUPPORT_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EADDRNOTAVAIL_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EADDRNOTAVAIL_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#noparse_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'noparse_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_113)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Hash'parse (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'parse and sort = 
SortKItem in match c with 
| _ -> try IO.hook_parse c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisRchanCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisRchanCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isRchanCellOpt(`<rchan>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'rchan'_GT_',(varK0_114)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isRchanCellOpt(#KToken(#token("RchanCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRchanCellOpt, var__115) :: [])) -> ((Bool true) :: [])
(*{| rule ``isRchanCellOpt(noRchanCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoRchanCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isRchanCellOpt(#KToken(#token("RchanCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRchanCell, var__116) :: [])) -> ((Bool true) :: [])
(*{| rule ``isRchanCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_117)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
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
let eval'Hash'unlock'LPar'_'Comm'_'RPar'_K'Hyph'IO (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'unlock'LPar'_'Comm'_'RPar'_K'Hyph'IO and sort = 
SortK in match c with 
| _ -> try IO.hook_unlock c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_andThenBool__BOOL (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_andThenBool__BOOL and sort = 
SortBool in match c with 
| _ -> try BOOL.hook_andThen c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_andThenBool__BOOL`(#token("true","Bool"),K)=>K`` requires isBool(K) ensures #token("true","Bool") [UNIQUE_ID(b058439c1adf0de5fb7afd07d638d2cda247a4344cbdc14812da46c5db5499df) contentStartColumn(8) contentStartLine(307) org.kframework.attributes.Location(Location(307,8,307,37)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool true) :: []),((Bool _ as varK_118) :: [])) when true && (true) -> (varK_118 :: [])
(*{| rule `` `_andThenBool__BOOL`(K,#token("true","Bool"))=>K`` requires isBool(K) ensures #token("true","Bool") [UNIQUE_ID(1aad8125a2ba7fcbd3c40ac487b7dc776993e9d167ac20f0210e14213abec45f) contentStartColumn(8) contentStartLine(308) org.kframework.attributes.Location(Location(308,8,308,37)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool _ as varK_119) :: []),((Bool true) :: [])) when true && (true) -> (varK_119 :: [])
(*{| rule `` `_andThenBool__BOOL`(#token("false","Bool"),_8)=>#token("false","Bool")`` requires isBool(_8) ensures #token("true","Bool") [UNIQUE_ID(34b51d1bff350ce2cd8b17b3af8effdfcf390962b57189087f3cc3b6bbe59cbc) contentStartColumn(8) contentStartLine(309) org.kframework.attributes.Location(Location(309,8,309,36)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool false) :: []),((Bool _ as var_8_120) :: [])) when true && (true) -> ((Bool false) :: [])
(*{| rule `` `_andThenBool__BOOL`(_0,#token("false","Bool"))=>#token("false","Bool")`` requires isBool(_0) ensures #token("true","Bool") [UNIQUE_ID(d0a6502b90e84545c10a45f7199b2a6d77f52d0841c63dcc792b60073f300e07) contentStartColumn(8) contentStartLine(310) org.kframework.attributes.Location(Location(310,8,310,36)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool _ as var_0_121) :: []),((Bool false) :: [])) when true && (true) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval'Hash'parseInModule (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'parseInModule and sort = 
SortKItem in match c with 
| _ -> try IO.hook_parseInModule c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let eval'Hash'system (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'system and sort = 
SortKItem in match c with 
| _ -> try IO.hook_system c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisList (c: k) (config: k) (guard: int) : k = let lbl = 
LblisList and sort = 
SortBool in match c with 
| [List (s,_,_)] when (s = SortList) -> [Bool true]
(*{| rule ``isList(#KToken(#token("List","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortList, var__122) :: [])) -> ((Bool true) :: [])
(*{| rule ``isList(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_123)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisSendsCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisSendsCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isSendsCellOpt(`<sends>`(K0))=>#token("true","Bool")`` requires isSendCellBag(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'sends'_GT_',(varK0_124 :: [])) :: [])) when (isTrue (evalisSendCellBag((varK0_124 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isSendsCellOpt(noSendsCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoSendsCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isSendsCellOpt(#KToken(#token("SendsCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSendsCellOpt, var__125) :: [])) -> ((Bool true) :: [])
(*{| rule ``isSendsCellOpt(#KToken(#token("SendsCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSendsCell, var__126) :: [])) -> ((Bool true) :: [])
(*{| rule ``isSendsCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_127)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisRecsCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisRecsCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isRecsCellOpt(noRecsCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoRecsCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isRecsCellOpt(#KToken(#token("RecsCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRecsCellOpt, var__128) :: [])) -> ((Bool true) :: [])
(*{| rule ``isRecsCellOpt(`<recs>`(K0))=>#token("true","Bool")`` requires isRecCellBag(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'recs'_GT_',(varK0_129 :: [])) :: [])) when (isTrue (evalisRecCellBag((varK0_129 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isRecsCellOpt(#KToken(#token("RecsCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRecsCell, var__130) :: [])) -> ((Bool true) :: [])
(*{| rule ``isRecsCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_131)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisTuplespaceCellFragment (c: k) (config: k) (guard: int) : k = let lbl = 
LblisTuplespaceCellFragment and sort = 
SortBool in match c with 
(*{| rule ``isTuplespaceCellFragment(`<tuplespace>-fragment`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isSendsCellOpt(K0),isRecsCellOpt(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl'_LT_'tuplespace'_GT_Hyph'fragment,(varK0_132 :: []),(varK1_133 :: [])) :: [])) when (((isTrue (evalisSendsCellOpt((varK0_132 :: [])) config (-1)))) && ((isTrue (evalisRecsCellOpt((varK1_133 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isTuplespaceCellFragment(#KToken(#token("TuplespaceCellFragment","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortTuplespaceCellFragment, var__134) :: [])) -> ((Bool true) :: [])
(*{| rule ``isTuplespaceCellFragment(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_135)) -> ((Bool false) :: [])
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
| (((String _ as varSource_136) :: []),((String _ as varToReplace_137) :: []),((String _ as varReplacement_138) :: []),((Int _ as varCount_139) :: [])) when ((((((((true) && (true))) && (true))) && (true))) && ((isTrue (eval_'_GT_'Int__INT((varCount_139 :: []),((Lazy.force int0) :: [])) config (-1))))) && (true) -> ((eval_'Plus'String__STRING(((eval_'Plus'String__STRING(((evalsubstrString((varSource_136 :: []),((Lazy.force int0) :: []),((evalfindString((varSource_136 :: []),(varToReplace_137 :: []),((Lazy.force int0) :: [])) config (-1)))) config (-1))),(varReplacement_138 :: [])) config (-1))),((evalreplace'LPar'_'Comm'_'Comm'_'Comm'_'RPar'_STRING(((evalsubstrString((varSource_136 :: []),((eval_'Plus'Int_(((evalfindString((varSource_136 :: []),(varToReplace_137 :: []),((Lazy.force int0) :: [])) config (-1))),((evallengthString((varToReplace_137 :: [])) config (-1)))) config (-1))),((evallengthString((varSource_136 :: [])) config (-1)))) config (-1))),(varToReplace_137 :: []),(varReplacement_138 :: []),((eval_'Hyph'Int__INT((varCount_139 :: []),((Lazy.force int1) :: [])) config (-1)))) config (-1)))) config (-1)))
(*{| rule `` `replace(_,_,_,_)_STRING`(Source,_17,_18,_0)=>Source`` requires `_andBool_`(`_andBool_`(`_andBool_`(isString(Source),isString(_18)),isString(_17)),`_==Int_`(_0,#token("0","Int"))) ensures #token("true","Bool") [UNIQUE_ID(ba5c0b944155cbe05f7bf6c179a2ed1e9baea983ec5099e8449b31926e9b3069) contentStartColumn(8) contentStartLine(574) org.kframework.attributes.Location(Location(574,8,574,49)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((String _ as varSource_140) :: []),((String _ as var_17_141) :: []),((String _ as var_18_142) :: []),((Int _ as var_0_143) :: [])) when ((((((true) && (true))) && (true))) && ((isTrue (eval_'EqlsEqls'Int_((var_0_143 :: []),((Lazy.force int0) :: [])) config (-1))))) && (true) -> (varSource_140 :: [])
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
| (((String _ as varSource_144) :: []),((String _ as varToCount_145) :: [])) when ((((true) && (true))) && ((isTrue (eval_'_GT_Eqls'Int__INT(((evalfindString((varSource_144 :: []),(varToCount_145 :: []),((Lazy.force int0) :: [])) config (-1))),((Lazy.force int0) :: [])) config (-1))))) && (true) -> ((eval_'Plus'Int_(((Lazy.force int1) :: []),((evalcountAllOccurrences'LPar'_'Comm'_'RPar'_STRING(((evalsubstrString((varSource_144 :: []),((eval_'Plus'Int_(((evalfindString((varSource_144 :: []),(varToCount_145 :: []),((Lazy.force int0) :: [])) config (-1))),((evallengthString((varToCount_145 :: [])) config (-1)))) config (-1))),((evallengthString((varSource_144 :: [])) config (-1)))) config (-1))),(varToCount_145 :: [])) config (-1)))) config (-1)))
(*{| rule `` `countAllOccurrences(_,_)_STRING`(Source,ToCount)=>#token("0","Int")`` requires `_andBool_`(`_andBool_`(isString(ToCount),isString(Source)),`_<Int__INT`(findString(Source,ToCount,#token("0","Int")),#token("0","Int"))) ensures #token("true","Bool") [UNIQUE_ID(cb338e251d0b5234f4abbf9c60008d68dc9dd3a8b1a5a410ed51f56d43a7b5af) contentStartColumn(8) contentStartLine(558) org.kframework.attributes.Location(Location(558,8,559,59)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
| (((String _ as varSource_146) :: []),((String _ as varToCount_147) :: [])) when ((((true) && (true))) && ((isTrue (eval_'_LT_'Int__INT(((evalfindString((varSource_146 :: []),(varToCount_147 :: []),((Lazy.force int0) :: [])) config (-1))),((Lazy.force int0) :: [])) config (-1))))) && (true) -> ((Lazy.force int0) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalreplaceAll'LPar'_'Comm'_'Comm'_'RPar'_STRING (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
LblreplaceAll'LPar'_'Comm'_'Comm'_'RPar'_STRING and sort = 
SortString in match c with 
| _ -> try STRING.hook_replaceAll c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `replaceAll(_,_,_)_STRING`(Source,ToReplace,Replacement)=>`replace(_,_,_,_)_STRING`(Source,ToReplace,Replacement,`countAllOccurrences(_,_)_STRING`(Source,ToReplace))`` requires `_andBool_`(`_andBool_`(isString(Replacement),isString(Source)),isString(ToReplace)) ensures #token("true","Bool") [UNIQUE_ID(3358d86b83068ab68fc4f0ed02513db149426f011866db38ff0a5015e8fee30d) contentStartColumn(8) contentStartLine(575) org.kframework.attributes.Location(Location(575,8,575,154)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((String _ as varSource_148) :: []),((String _ as varToReplace_149) :: []),((String _ as varReplacement_150) :: [])) when ((((true) && (true))) && (true)) && (true) -> ((evalreplace'LPar'_'Comm'_'Comm'_'Comm'_'RPar'_STRING((varSource_148 :: []),(varToReplace_149 :: []),(varReplacement_150 :: []),((evalcountAllOccurrences'LPar'_'Comm'_'RPar'_STRING((varSource_148 :: []),(varToReplace_149 :: [])) config (-1)))) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let eval_'Xor_'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'Xor_'Int__INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_pow c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'_LT_'String__STRING (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'_LT_'String__STRING and sort = 
SortBool in match c with 
| _ -> try STRING.hook_lt c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'_GT_'String__STRING (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'_GT_'String__STRING and sort = 
SortBool in match c with 
| _ -> try STRING.hook_gt c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_>String__STRING`(S1,S2)=>`_<String__STRING`(S2,S1)`` requires `_andBool_`(isString(S2),isString(S1)) ensures #token("true","Bool") [UNIQUE_ID(85f6517ce0e2b7074d495585267afa5b0502e09d5bf63c57fb6c6d77174aa16a) contentStartColumn(8) contentStartLine(550) org.kframework.attributes.Location(Location(550,8,550,52)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((String _ as varS1_151) :: []),((String _ as varS2_152) :: [])) when ((true) && (true)) && (true) -> ((eval_'_LT_'String__STRING((varS2_152 :: []),(varS1_151 :: [])) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisSendsCellFragment (c: k) (config: k) (guard: int) : k = let lbl = 
LblisSendsCellFragment and sort = 
SortBool in match c with 
(*{| rule ``isSendsCellFragment(#KToken(#token("SendsCellFragment","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSendsCellFragment, var__153) :: [])) -> ((Bool true) :: [])
(*{| rule ``isSendsCellFragment(`<sends>-fragment`(K0))=>#token("true","Bool")`` requires isSendCellBag(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'sends'_GT_Hyph'fragment,(varK0_154 :: [])) :: [])) when (isTrue (evalisSendCellBag((varK0_154 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isSendsCellFragment(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_155)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisKConfigVar (c: k) (config: k) (guard: int) : k = let lbl = 
LblisKConfigVar and sort = 
SortBool in match c with 
(*{| rule ``isKConfigVar(#KToken(#token("KConfigVar","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortKConfigVar, var__156) :: [])) -> ((Bool true) :: [])
(*{| rule ``isKConfigVar(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_157)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisCell and sort = 
SortBool in match c with 
(*{| rule ``isCell(`<msg>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'msg'_GT_',(varK0_158)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("Cell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortCell, var__159) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("TCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortTCell, var__160) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("RecCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRecCell, var__161) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(`<tuplespace>`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isSendsCell(K0),isRecsCell(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl'_LT_'tuplespace'_GT_',(varK0_162 :: []),(varK1_163 :: [])) :: [])) when (((isTrue (evalisSendsCell((varK0_162 :: [])) config (-1)))) && ((isTrue (evalisRecsCell((varK1_163 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(`<k>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'k'_GT_',(varK0_164)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(`<T>`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isActivityCell(K0),isTuplespaceCell(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl'_LT_'T'_GT_',(varK0_165 :: []),(varK1_166 :: [])) :: [])) when (((isTrue (evalisActivityCell((varK0_165 :: [])) config (-1)))) && ((isTrue (evalisTuplespaceCell((varK1_166 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(`<activity>`(K0))=>#token("true","Bool")`` requires isThreadCellBag(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'activity'_GT_',(varK0_167 :: [])) :: [])) when (isTrue (evalisThreadCellBag((varK0_167 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("RecsCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRecsCell, var__168) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("ThreadCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortThreadCell, var__169) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("KCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortKCell, var__170) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(`<rchan>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'rchan'_GT_',(varK0_171)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(`<sends>`(K0))=>#token("true","Bool")`` requires isSendCellBag(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'sends'_GT_',(varK0_172 :: [])) :: [])) when (isTrue (evalisSendCellBag((varK0_172 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("RchanCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRchanCell, var__173) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(`<send>`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isSchanCell(K0),isMsgCell(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl'_LT_'send'_GT_',(varK0_174 :: []),(varK1_175 :: [])) :: [])) when (((isTrue (evalisSchanCell((varK0_174 :: [])) config (-1)))) && ((isTrue (evalisMsgCell((varK1_175 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(`<cont>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'cont'_GT_',(varK0_176)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("ActivityCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortActivityCell, var__177) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("MsgCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortMsgCell, var__178) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(`<recs>`(K0))=>#token("true","Bool")`` requires isRecCellBag(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'recs'_GT_',(varK0_179 :: [])) :: [])) when (isTrue (evalisRecCellBag((varK0_179 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(`<bind>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'bind'_GT_',(varK0_180)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(`<rec>`(K0,K1,K2))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(isRchanCell(K0),isBindCell(K1)),isContCell(K2)) ensures #token("true","Bool") []|}*)
| ((KApply3(Lbl'_LT_'rec'_GT_',(varK0_181 :: []),(varK1_182 :: []),(varK2_183 :: [])) :: [])) when (((((isTrue (evalisRchanCell((varK0_181 :: [])) config (-1)))) && ((isTrue (evalisBindCell((varK1_182 :: [])) config (-1)))))) && ((isTrue (evalisContCell((varK2_183 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("ContCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortContCell, var__184) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("BindCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortBindCell, var__185) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("SchanCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSchanCell, var__186) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("TuplespaceCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortTuplespaceCell, var__187) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(`<thread>`(K0))=>#token("true","Bool")`` requires isKCell(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'thread'_GT_',(varK0_188 :: [])) :: [])) when (isTrue (evalisKCell((varK0_188 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("SendCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSendCell, var__189) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("SendsCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSendsCell, var__190) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(`<schan>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'schan'_GT_',(varK0_191)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_192)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalvalues (c: k) (config: k) (guard: int) : k = let lbl = 
Lblvalues and sort = 
SortList in match c with 
| _ -> try MAP.hook_values c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalList'Coln'get (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblList'Coln'get and sort = 
SortKItem in match c with 
| _ -> try LIST.hook_get c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval'Hash'lstat'LPar'_'RPar'_K'Hyph'IO (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'lstat'LPar'_'RPar'_K'Hyph'IO and sort = 
SortKItem in match c with 
| _ -> try IO.hook_lstat c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalSendCellBagItem (c: k) (config: k) (guard: int) : k = let lbl = 
LblSendCellBagItem and sort = 
SortSendCellBag in match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisKCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisKCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isKCellOpt(#KToken(#token("KCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortKCellOpt, var__193) :: [])) -> ((Bool true) :: [])
(*{| rule ``isKCellOpt(#KToken(#token("KCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortKCell, var__194) :: [])) -> ((Bool true) :: [])
(*{| rule ``isKCellOpt(`<k>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'k'_GT_',(varK0_195)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isKCellOpt(noKCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoKCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isKCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_196)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisThreadCellFragment (c: k) (config: k) (guard: int) : k = let lbl = 
LblisThreadCellFragment and sort = 
SortBool in match c with 
(*{| rule ``isThreadCellFragment(`<thread>-fragment`(K0))=>#token("true","Bool")`` requires isKCellOpt(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'thread'_GT_Hyph'fragment,(varK0_197 :: [])) :: [])) when (isTrue (evalisKCellOpt((varK0_197 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isThreadCellFragment(#KToken(#token("ThreadCellFragment","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortThreadCellFragment, var__198) :: [])) -> ((Bool true) :: [])
(*{| rule ``isThreadCellFragment(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_199)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalSetItem (c: k) (config: k) (guard: int) : k = let lbl = 
LblSetItem and sort = 
SortSet in match c with 
| _ -> try SET.hook_element c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisTuplespaceCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisTuplespaceCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isTuplespaceCellOpt(#KToken(#token("TuplespaceCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortTuplespaceCellOpt, var__200) :: [])) -> ((Bool true) :: [])
(*{| rule ``isTuplespaceCellOpt(#KToken(#token("TuplespaceCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortTuplespaceCell, var__201) :: [])) -> ((Bool true) :: [])
(*{| rule ``isTuplespaceCellOpt(`<tuplespace>`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isSendsCell(K0),isRecsCell(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl'_LT_'tuplespace'_GT_',(varK0_202 :: []),(varK1_203 :: [])) :: [])) when (((isTrue (evalisSendsCell((varK0_202 :: [])) config (-1)))) && ((isTrue (evalisRecsCell((varK1_203 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isTuplespaceCellOpt(noTuplespaceCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoTuplespaceCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isTuplespaceCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_204)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Stop'List (c: unit) (config: k) (guard: int) : k = let lbl = 
Lbl'Stop'List and sort = 
SortList in match c with 
| _ -> try LIST.hook_unit c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let const'Stop'List : k Lazy.t = lazy (eval'Stop'List () interned_bottom (-1))
let evalisSendCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisSendCell and sort = 
SortBool in match c with 
(*{| rule ``isSendCell(`<send>`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isSchanCell(K0),isMsgCell(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl'_LT_'send'_GT_',(varK0_205 :: []),(varK1_206 :: [])) :: [])) when (((isTrue (evalisSchanCell((varK0_205 :: [])) config (-1)))) && ((isTrue (evalisMsgCell((varK1_206 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isSendCell(#KToken(#token("SendCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSendCell, var__207) :: [])) -> ((Bool true) :: [])
(*{| rule ``isSendCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_208)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalrandInt (c: k) (config: k) (guard: int) : k = let lbl = 
LblrandInt and sort = 
SortInt in match c with 
| _ -> try INT.hook_rand c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Hash'configuration_K'Hyph'REFLECTION (c: unit) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'configuration_K'Hyph'REFLECTION and sort = 
SortK in match c with 
| _ -> try KREFLECTION.hook_configuration c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let evalisFloat (c: k) (config: k) (guard: int) : k = let lbl = 
LblisFloat and sort = 
SortBool in match c with 
| [Float _] -> [Bool true]
(*{| rule ``isFloat(#KToken(#token("Float","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortFloat, var__209) :: [])) -> ((Bool true) :: [])
(*{| rule ``isFloat(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_210)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Hash'close'LPar'_'RPar'_K'Hyph'IO (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'close'LPar'_'RPar'_K'Hyph'IO and sort = 
SortK in match c with 
| _ -> try IO.hook_close c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalkeys_list'LPar'_'RPar'_MAP (c: k) (config: k) (guard: int) : k = let lbl = 
Lblkeys_list'LPar'_'RPar'_MAP and sort = 
SortList in match c with 
| _ -> try MAP.hook_keys_list c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalString2Id (c: k) (config: k) (guard: int) : k = let lbl = 
LblString2Id and sort = 
SortId in match c with 
| _ -> try STRING.hook_string2token c lbl sort config freshFunction
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
| (((Int _ as varI_211) :: [])) when true && (true) -> ((evalString2Id(((eval_'Plus'String__STRING(((String "_") :: []),((evalInt2String((varI_211 :: [])) config (-1)))) config (-1)))) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalchrChar (c: k) (config: k) (guard: int) : k = let lbl = 
LblchrChar and sort = 
SortString in match c with 
| _ -> try STRING.hook_chr c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisSchanCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisSchanCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isSchanCellOpt(#KToken(#token("SchanCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSchanCell, var__212) :: [])) -> ((Bool true) :: [])
(*{| rule ``isSchanCellOpt(noSchanCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoSchanCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isSchanCellOpt(`<schan>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'schan'_GT_',(varK0_213)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isSchanCellOpt(#KToken(#token("SchanCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSchanCellOpt, var__214) :: [])) -> ((Bool true) :: [])
(*{| rule ``isSchanCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_215)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_orElseBool__BOOL (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_orElseBool__BOOL and sort = 
SortBool in match c with 
| _ -> try BOOL.hook_orElse c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_orElseBool__BOOL`(#token("false","Bool"),K)=>K`` requires isBool(K) ensures #token("true","Bool") [UNIQUE_ID(efdd958595a7fecb549f4368ba6097862b61abc903a6d33684803a3a0043bda8) contentStartColumn(8) contentStartLine(324) org.kframework.attributes.Location(Location(324,8,324,37)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool false) :: []),((Bool _ as varK_216) :: [])) when true && (true) -> (varK_216 :: [])
(*{| rule `` `_orElseBool__BOOL`(_1,#token("true","Bool"))=>#token("true","Bool")`` requires isBool(_1) ensures #token("true","Bool") [UNIQUE_ID(2882f8b0a388fe37313c6b828cb9039a9838984f56e50b5095476c319b3dfbd8) contentStartColumn(8) contentStartLine(323) org.kframework.attributes.Location(Location(323,8,323,33)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool _ as var_1_217) :: []),((Bool true) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule `` `_orElseBool__BOOL`(#token("true","Bool"),_6)=>#token("true","Bool")`` requires isBool(_6) ensures #token("true","Bool") [UNIQUE_ID(6ea998be2fb9b60b7964c4b4939293b6fecb47f52a53031c6227218949cf22f0) contentStartColumn(8) contentStartLine(322) org.kframework.attributes.Location(Location(322,8,322,33)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool true) :: []),((Bool _ as var_6_218) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule `` `_orElseBool__BOOL`(K,#token("false","Bool"))=>K`` requires isBool(K) ensures #token("true","Bool") [UNIQUE_ID(8c7774b237a73a62ffd53be8d97ac73eb2f040dcf41983ea18840919b416d291) contentStartColumn(8) contentStartLine(325) org.kframework.attributes.Location(Location(325,8,325,37)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool _ as varK_219) :: []),((Bool false) :: [])) when true && (true) -> (varK_219 :: [])
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
| (((Int _ as varI1_220) :: []),((Int _ as varI2_221) :: [])) when ((((true) && (true))) && ((isTrue (eval_'EqlsSlshEqls'Int__INT((varI2_221 :: []),((Lazy.force int0) :: [])) config (-1))))) && (true) -> ((eval_'Slsh'Int__INT(((eval_'Hyph'Int__INT((varI1_220 :: []),((eval_modInt__INT((varI1_220 :: []),(varI2_221 :: [])) config (-1)))) config (-1))),(varI2_221 :: [])) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_ThreadCellBag_ (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_ThreadCellBag_ and sort = 
SortThreadCellBag in match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalList'Coln'range (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
LblList'Coln'range and sort = 
SortList in match c with 
| _ -> try LIST.hook_range c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let eval_orBool__BOOL (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_orBool__BOOL and sort = 
SortBool in match c with 
| _ -> try BOOL.hook_or c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_orBool__BOOL`(#token("true","Bool"),_5)=>#token("true","Bool")`` requires isBool(_5) ensures #token("true","Bool") [UNIQUE_ID(166d732e9fd6609a71feb6d62f8a420d291ac81be018b646ee1177935b008f01) contentStartColumn(8) contentStartLine(317) org.kframework.attributes.Location(Location(317,8,317,34)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool true) :: []),((Bool _ as var_5_222) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule `` `_orBool__BOOL`(_3,#token("true","Bool"))=>#token("true","Bool")`` requires isBool(_3) ensures #token("true","Bool") [UNIQUE_ID(497077a299480dbc06eccb33cd98338014bd125c4c601cb88a765dbcb334b14b) contentStartColumn(8) contentStartLine(318) org.kframework.attributes.Location(Location(318,8,318,34)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool _ as var_3_223) :: []),((Bool true) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule `` `_orBool__BOOL`(B,#token("false","Bool"))=>B`` requires isBool(B) ensures #token("true","Bool") [UNIQUE_ID(630487d34ae5fc313a9b8cae2ad45b7b80671058bca3c97a7864774c5a431711) contentStartColumn(8) contentStartLine(320) org.kframework.attributes.Location(Location(320,8,320,32)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool _ as varB_224) :: []),((Bool false) :: [])) when true && (true) -> (varB_224 :: [])
(*{| rule `` `_orBool__BOOL`(#token("false","Bool"),B)=>B`` requires isBool(B) ensures #token("true","Bool") [UNIQUE_ID(ababa6e5e3735076933657815e24f99518fe532715ea97eae22ead8e30097b53) contentStartColumn(8) contentStartLine(319) org.kframework.attributes.Location(Location(319,8,319,32)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool false) :: []),((Bool _ as varB_225) :: [])) when true && (true) -> (varB_225 :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisMsgCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisMsgCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isMsgCellOpt(#KToken(#token("MsgCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortMsgCellOpt, var__226) :: [])) -> ((Bool true) :: [])
(*{| rule ``isMsgCellOpt(`<msg>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'msg'_GT_',(varK0_227)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isMsgCellOpt(noMsgCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoMsgCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isMsgCellOpt(#KToken(#token("MsgCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortMsgCell, var__228) :: [])) -> ((Bool true) :: [])
(*{| rule ``isMsgCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_229)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisSendCellFragment (c: k) (config: k) (guard: int) : k = let lbl = 
LblisSendCellFragment and sort = 
SortBool in match c with 
(*{| rule ``isSendCellFragment(`<send>-fragment`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isSchanCellOpt(K0),isMsgCellOpt(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl'_LT_'send'_GT_Hyph'fragment,(varK0_230 :: []),(varK1_231 :: [])) :: [])) when (((isTrue (evalisSchanCellOpt((varK0_230 :: [])) config (-1)))) && ((isTrue (evalisMsgCellOpt((varK1_231 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isSendCellFragment(#KToken(#token("SendCellFragment","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSendCellFragment, var__232) :: [])) -> ((Bool true) :: [])
(*{| rule ``isSendCellFragment(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_233)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalupdateMap (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblupdateMap and sort = 
SortMap in match c with 
| _ -> try MAP.hook_updateAll c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'EqlsSlshEqls'K_ (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'EqlsSlshEqls'K_ and sort = 
SortBool in match c with 
| _ -> try KEQUAL.hook_ne c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_=/=K_`(K1,K2)=>`notBool_`(`_==K_`(K1,K2))`` requires `_andBool_`(isK(K1),isK(K2)) ensures #token("true","Bool") [UNIQUE_ID(0221882a8af3c088550dce160a5b2e48351ef2431aad518a72f3d65258a4066d) contentStartColumn(8) contentStartLine(763) org.kframework.attributes.Location(Location(763,8,763,45)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((varK1_234),(varK2_235)) when ((true) && (true)) && (true) -> ([Bool ((not ((isTrue (eval_'EqlsEqls'K_((varK1_234),(varK2_235)) config (-1))))))])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval'Hash'lock'LPar'_'Comm'_'RPar'_K'Hyph'IO (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'lock'LPar'_'Comm'_'RPar'_K'Hyph'IO and sort = 
SortK in match c with 
| _ -> try IO.hook_lock c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalfillList (c: k * k * k * k) (config: k) (guard: int) : k = let lbl = 
LblfillList and sort = 
SortList in match c with 
| _ -> try LIST.hook_fill c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize4 c)))])
let evalisRecCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisRecCell and sort = 
SortBool in match c with 
(*{| rule ``isRecCell(`<rec>`(K0,K1,K2))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(isRchanCell(K0),isBindCell(K1)),isContCell(K2)) ensures #token("true","Bool") []|}*)
| ((KApply3(Lbl'_LT_'rec'_GT_',(varK0_236 :: []),(varK1_237 :: []),(varK2_238 :: [])) :: [])) when (((((isTrue (evalisRchanCell((varK0_236 :: [])) config (-1)))) && ((isTrue (evalisBindCell((varK1_237 :: [])) config (-1)))))) && ((isTrue (evalisContCell((varK2_238 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isRecCell(#KToken(#token("RecCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRecCell, var__239) :: [])) -> ((Bool true) :: [])
(*{| rule ``isRecCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_240)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_List_ (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_List_ and sort = 
SortList in match c with 
| _ -> try LIST.hook_concat c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval'Hash'open'LPar'_'Comm'_'RPar'_K'Hyph'IO (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'open'LPar'_'Comm'_'RPar'_K'Hyph'IO and sort = 
SortInt in match c with 
| _ -> try IO.hook_open c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
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
| (((Bool _ as varB_241) :: []),((Bool _ as varB_242) :: [])) when true && (((compare_kitem varB_242 varB_241) = 0) && true) -> ((Bool false) :: [])
(*{| rule `` `_xorBool__BOOL`(B,#token("false","Bool"))=>B`` requires isBool(B) ensures #token("true","Bool") [UNIQUE_ID(2eae84ae7b21312fecde18860149de73365b819e65aada5f952fc5b9101ae014) contentStartColumn(8) contentStartLine(313) org.kframework.attributes.Location(Location(313,8,313,38)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool _ as varB_243) :: []),((Bool false) :: [])) when true && (true) -> (varB_243 :: [])
(*{| rule `` `_xorBool__BOOL`(#token("false","Bool"),B)=>B`` requires isBool(B) ensures #token("true","Bool") [UNIQUE_ID(0b888132027262073a3306d90f4a55b0a4ea27984cd77fccd8bf29cd48efb665) contentStartColumn(8) contentStartLine(312) org.kframework.attributes.Location(Location(312,8,312,38)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool false) :: []),((Bool _ as varB_244) :: [])) when true && (true) -> (varB_244 :: [])
(*{| rule `` `_xorBool__BOOL`(B1,B2)=>`notBool_`(`_==Bool__BOOL`(B1,B2))`` requires `_andBool_`(isBool(B2),isBool(B1)) ensures #token("true","Bool") [UNIQUE_ID(1c34683a46438798498c925345e696fc017c0665504d0877c44e540d820b1ec7) contentStartColumn(8) contentStartLine(315) org.kframework.attributes.Location(Location(315,8,315,57)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool _ as varB1_245) :: []),((Bool _ as varB2_246) :: [])) when ((true) && (true)) && (true) -> ([Bool ((not ((isTrue (eval_'EqlsEqls'Bool__BOOL((varB1_245 :: []),(varB2_246 :: [])) config (-1))))))])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'Hyph'Map__MAP (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'Hyph'Map__MAP and sort = 
SortMap in match c with 
| _ -> try MAP.hook_difference c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval'Stop'RecCellBag (c: unit) (config: k) (guard: int) : k = let lbl = 
Lbl'Stop'RecCellBag and sort = 
SortRecCellBag in match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let const'Stop'RecCellBag : k Lazy.t = lazy (eval'Stop'RecCellBag () interned_bottom (-1))
let eval'Hash'sort (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'sort and sort = 
SortString in match c with 
| _ -> try KREFLECTION.hook_sort c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Hash'open'LPar'_'RPar'_K'Hyph'IO (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'open'LPar'_'RPar'_K'Hyph'IO and sort = 
SortInt in match c with 
(*{| rule `` `#open(_)_K-IO`(S)=>`#open(_,_)_K-IO`(S,#token("\"r+\"","String"))`` requires isString(S) ensures #token("true","Bool") [UNIQUE_ID(ed7ee74167faa7f8e3a152e9e495d112a67407097a0bb306ac17e2ce4bebf100) contentStartColumn(8) contentStartLine(902) org.kframework.attributes.Location(Location(902,8,902,48)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((String _ as varS_247) :: [])) when true && (true) -> ((eval'Hash'open'LPar'_'Comm'_'RPar'_K'Hyph'IO((varS_247 :: []),((String "r+") :: [])) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisBindCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisBindCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isBindCellOpt(`<bind>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'bind'_GT_',(varK0_248)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isBindCellOpt(#KToken(#token("BindCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortBindCellOpt, var__249) :: [])) -> ((Bool true) :: [])
(*{| rule ``isBindCellOpt(noBindCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoBindCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isBindCellOpt(#KToken(#token("BindCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortBindCell, var__250) :: [])) -> ((Bool true) :: [])
(*{| rule ``isBindCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_251)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_'LSqB'_'RSqB'_SUBSTITUTION (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'LSqB'_'RSqB'_SUBSTITUTION and sort = 
SortK in match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalreplaceFirst'LPar'_'Comm'_'Comm'_'RPar'_STRING (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
LblreplaceFirst'LPar'_'Comm'_'Comm'_'RPar'_STRING and sort = 
SortString in match c with 
| _ -> try STRING.hook_replaceFirst c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `replaceFirst(_,_,_)_STRING`(Source,ToReplace,Replacement)=>`_+String__STRING`(`_+String__STRING`(substrString(Source,#token("0","Int"),findString(Source,ToReplace,#token("0","Int"))),Replacement),substrString(Source,`_+Int_`(findString(Source,ToReplace,#token("0","Int")),lengthString(ToReplace)),lengthString(Source)))`` requires `_andBool_`(`_andBool_`(`_andBool_`(isString(Replacement),isString(Source)),isString(ToReplace)),`_>=Int__INT`(findString(Source,ToReplace,#token("0","Int")),#token("0","Int"))) ensures #token("true","Bool") [UNIQUE_ID(4941a93fc06d65bd530ddbfcaabb498d40e247effd559cda2d85e65d73692b70) contentStartColumn(8) contentStartLine(563) org.kframework.attributes.Location(Location(563,8,565,66)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
| (((String _ as varSource_252) :: []),((String _ as varToReplace_253) :: []),((String _ as varReplacement_254) :: [])) when ((((((true) && (true))) && (true))) && ((isTrue (eval_'_GT_Eqls'Int__INT(((evalfindString((varSource_252 :: []),(varToReplace_253 :: []),((Lazy.force int0) :: [])) config (-1))),((Lazy.force int0) :: [])) config (-1))))) && (true) -> ((eval_'Plus'String__STRING(((eval_'Plus'String__STRING(((evalsubstrString((varSource_252 :: []),((Lazy.force int0) :: []),((evalfindString((varSource_252 :: []),(varToReplace_253 :: []),((Lazy.force int0) :: [])) config (-1)))) config (-1))),(varReplacement_254 :: [])) config (-1))),((evalsubstrString((varSource_252 :: []),((eval_'Plus'Int_(((evalfindString((varSource_252 :: []),(varToReplace_253 :: []),((Lazy.force int0) :: [])) config (-1))),((evallengthString((varToReplace_253 :: [])) config (-1)))) config (-1))),((evallengthString((varSource_252 :: [])) config (-1)))) config (-1)))) config (-1)))
(*{| rule `` `replaceFirst(_,_,_)_STRING`(Source,ToReplace,_12)=>Source`` requires `_andBool_`(`_andBool_`(`_andBool_`(isString(Source),isString(ToReplace)),isString(_12)),`_<Int__INT`(findString(Source,ToReplace,#token("0","Int")),#token("0","Int"))) ensures #token("true","Bool") [UNIQUE_ID(4320c56cb2a4f4c70e2500eb8f33dab497a5bb09aa847e4e0c0ae496ab671040) contentStartColumn(8) contentStartLine(566) org.kframework.attributes.Location(Location(566,8,567,57)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
| (((String _ as varSource_255) :: []),((String _ as varToReplace_256) :: []),((String _ as var_12_257) :: [])) when ((((((true) && (true))) && (true))) && ((isTrue (eval_'_LT_'Int__INT(((evalfindString((varSource_255 :: []),(varToReplace_256 :: []),((Lazy.force int0) :: [])) config (-1))),((Lazy.force int0) :: [])) config (-1))))) && (true) -> (varSource_255 :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let eval'Hash'putc'LPar'_'Comm'_'RPar'_K'Hyph'IO (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'putc'LPar'_'Comm'_'RPar'_K'Hyph'IO and sort = 
SortK in match c with 
| _ -> try IO.hook_putc c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval'Stop'Map (c: unit) (config: k) (guard: int) : k = let lbl = 
Lbl'Stop'Map and sort = 
SortMap in match c with 
| _ -> try MAP.hook_unit c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let const'Stop'Map : k Lazy.t = lazy (eval'Stop'Map () interned_bottom (-1))
let eval'Hash'logToFile (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'logToFile and sort = 
SortK in match c with 
| _ -> try IO.hook_log c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval'Hash'read'LPar'_'Comm'_'RPar'_K'Hyph'IO (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'read'LPar'_'Comm'_'RPar'_K'Hyph'IO and sort = 
SortString in match c with 
| _ -> try IO.hook_read c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalId2String (c: k) (config: k) (guard: int) : k = let lbl = 
LblId2String and sort = 
SortString in match c with 
| _ -> try STRING.hook_token2string c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisContCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisContCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isContCellOpt(noContCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoContCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isContCellOpt(#KToken(#token("ContCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortContCellOpt, var__258) :: [])) -> ((Bool true) :: [])
(*{| rule ``isContCellOpt(#KToken(#token("ContCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortContCell, var__259) :: [])) -> ((Bool true) :: [])
(*{| rule ``isContCellOpt(`<cont>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'cont'_GT_',(varK0_260)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isContCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_261)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalfreshInt (c: k) (config: k) (guard: int) : k = let lbl = 
LblfreshInt and sort = 
SortInt in match c with 
(*{| rule ``freshInt(I)=>I`` requires isInt(I) ensures #token("true","Bool") [UNIQUE_ID(d7221da1fa6b633137e79279efd265a289ea7e8496612615f43546422d446bc4) contentStartColumn(8) contentStartLine(412) org.kframework.attributes.Location(Location(412,8,412,28)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Int _ as varI_262) :: [])) when true && (true) -> (varI_262 :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let freshFunction (sort: string) (config: k) (counter: Z.t) : k = match sort with 
| "Id" -> (evalfreshId ([Int counter]) config (-1))
| "Int" -> (evalfreshInt ([Int counter]) config (-1))
| _ -> invalid_arg ("Cannot find fresh function for sort " ^ sort)let eval'Hash'fresh (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'fresh and sort = 
SortKItem in match c with 
| _ -> try KREFLECTION.hook_fresh c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalMap'Coln'choice (c: k) (config: k) (guard: int) : k = let lbl = 
LblMap'Coln'choice and sort = 
SortKItem in match c with 
| _ -> try MAP.hook_choice c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_impliesBool__BOOL (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_impliesBool__BOOL and sort = 
SortBool in match c with 
| _ -> try BOOL.hook_implies c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_impliesBool__BOOL`(_2,#token("true","Bool"))=>#token("true","Bool")`` requires isBool(_2) ensures #token("true","Bool") [UNIQUE_ID(7fdeea13463fa86d05e4d5bfb9e9c627b90ab57930f712fef1bfc08543a87d74) contentStartColumn(8) contentStartLine(329) org.kframework.attributes.Location(Location(329,8,329,39)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool _ as var_2_263) :: []),((Bool true) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule `` `_impliesBool__BOOL`(B,#token("false","Bool"))=>`notBool_`(B)`` requires isBool(B) ensures #token("true","Bool") [UNIQUE_ID(0129e06009c7500aefab482e1bc8e348010c6bd01acd15725172192c05a70831) contentStartColumn(8) contentStartLine(330) org.kframework.attributes.Location(Location(330,8,330,45)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool _ as varB_264) :: []),((Bool false) :: [])) when true && (true) -> ([Bool ((not ((isTrue [varB_264]))))])
(*{| rule `` `_impliesBool__BOOL`(#token("false","Bool"),_7)=>#token("true","Bool")`` requires isBool(_7) ensures #token("true","Bool") [UNIQUE_ID(3497d026ef9468fdac7e6b5de6841fad0118b17ca073ba25af4c5d8573a167b2) contentStartColumn(8) contentStartLine(328) org.kframework.attributes.Location(Location(328,8,328,40)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool false) :: []),((Bool _ as var_7_265) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule `` `_impliesBool__BOOL`(#token("true","Bool"),B)=>B`` requires isBool(B) ensures #token("true","Bool") [UNIQUE_ID(278435b95efb1a1ce04f6d701b12e6438c3cf3aee8019b41ea93b05755d379d7) contentStartColumn(8) contentStartLine(327) org.kframework.attributes.Location(Location(327,8,327,36)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool true) :: []),((Bool _ as varB_266) :: [])) when true && (true) -> (varB_266 :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval'Hash'getc'LPar'_'RPar'_K'Hyph'IO (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'getc'LPar'_'RPar'_K'Hyph'IO and sort = 
SortInt in match c with 
| _ -> try IO.hook_getc c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_Set_ (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_Set_ and sort = 
SortSet in match c with 
| _ -> try SET.hook_concat c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalinitActivityCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblinitActivityCell and sort = 
SortActivityCell in match c with 
(*{| rule ``initActivityCell(Init)=>`<activity>`(initThreadCell(Init))`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(e7ab45a618515b9b5397417ad78f871868b403f028f15d6b92c70dca269fc904) initializer()]|}*)
| (((Map (SortMap,_,_) as varInit_267) :: [])) -> (KApply1(Lbl'_LT_'activity'_GT_',((evalinitThreadCell((varInit_267 :: [])) config (-1)))) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_'Star'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'Star'Int__INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_mul c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisActivityCellFragment (c: k) (config: k) (guard: int) : k = let lbl = 
LblisActivityCellFragment and sort = 
SortBool in match c with 
(*{| rule ``isActivityCellFragment(`<activity>-fragment`(K0))=>#token("true","Bool")`` requires isThreadCellBag(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'activity'_GT_Hyph'fragment,(varK0_268 :: [])) :: [])) when (isTrue (evalisThreadCellBag((varK0_268 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isActivityCellFragment(#KToken(#token("ActivityCellFragment","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortActivityCellFragment, var__269) :: [])) -> ((Bool true) :: [])
(*{| rule ``isActivityCellFragment(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_270)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalmaxInt'LPar'_'Comm'_'RPar'_INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblmaxInt'LPar'_'Comm'_'RPar'_INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_max c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval'Tild'Int__INT (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Tild'Int__INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_not c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_'_LT_Eqls'String__STRING (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'_LT_Eqls'String__STRING and sort = 
SortBool in match c with 
| _ -> try STRING.hook_le c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_<=String__STRING`(S1,S2)=>`notBool_`(`_<String__STRING`(S2,S1))`` requires `_andBool_`(isString(S2),isString(S1)) ensures #token("true","Bool") [UNIQUE_ID(2c1110a97c0d904a19992e4eac695692515cb703f5d689aaa6945290a696d662) contentStartColumn(8) contentStartLine(549) org.kframework.attributes.Location(Location(549,8,549,63)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((String _ as varS1_271) :: []),((String _ as varS2_272) :: [])) when ((true) && (true)) && (true) -> ([Bool ((not ((isTrue (eval_'_LT_'String__STRING((varS2_272 :: []),(varS1_271 :: [])) config (-1))))))])
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
| (((String _ as varS1_273) :: []),((String _ as varS2_274) :: []),((Int _ as varI_275) :: [])) when ((((((true) && (true))) && (true))) && ((isTrue (eval_'EqlsSlshEqls'String__STRING((varS2_274 :: []),((String "") :: [])) config (-1))))) && (true) -> ((evalmaxInt'LPar'_'Comm'_'RPar'_INT(((evalrfindString((varS1_273 :: []),((evalsubstrString((varS2_274 :: []),((Lazy.force int0) :: []),((Lazy.force int1) :: [])) config (-1))),(varI_275 :: [])) config (-1))),((evalrfindChar((varS1_273 :: []),((evalsubstrString((varS2_274 :: []),((Lazy.force int1) :: []),((evallengthString((varS2_274 :: [])) config (-1)))) config (-1))),(varI_275 :: [])) config (-1)))) config (-1)))
(*{| rule ``rfindChar(_15,#token("\"\"","String"),_16)=>#token("-1","Int")`` requires `_andBool_`(isInt(_16),isString(_15)) ensures #token("true","Bool") [UNIQUE_ID(04cb290eea9d7c93a48f761cab20217a689222a306098df1120917b013944330) contentStartColumn(8) contentStartLine(556) org.kframework.attributes.Location(Location(556,8,556,33)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((String _ as var_15_276) :: []),((String "") :: []),((Int _ as var_16_277) :: [])) when ((true) && (true)) && (true) -> ((Lazy.force int'Hyph'1) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let eval_Map_ (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_Map_ and sort = 
SortMap in match c with 
| _ -> try MAP.hook_concat c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalinitSchanCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitSchanCell and sort = 
SortSchanCell in match c with 
(*{| rule ``initSchanCell(.KList)=>`<schan>`(.K)`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(fb3f04378e2de704012940ecf0be5d176bf31eff6f4ae8799fe8998e5c601d32) initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'schan'_GT_',([])) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitSchanCell : k Lazy.t = lazy (evalinitSchanCell () interned_bottom (-1))
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
let eval'Hash'opendir'LPar'_'RPar'_K'Hyph'IO (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'opendir'LPar'_'RPar'_K'Hyph'IO and sort = 
SortKItem in match c with 
| _ -> try IO.hook_opendir c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalRecCellBagItem (c: k) (config: k) (guard: int) : k = let lbl = 
LblRecCellBagItem and sort = 
SortRecCellBag in match c with 
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
let eval'Stop'SendCellBag (c: unit) (config: k) (guard: int) : k = let lbl = 
Lbl'Stop'SendCellBag and sort = 
SortSendCellBag in match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let const'Stop'SendCellBag : k Lazy.t = lazy (eval'Stop'SendCellBag () interned_bottom (-1))
let evalinitSendsCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitSendsCell and sort = 
SortSendsCell in match c with 
(*{| rule ``initSendsCell(.KList)=>`<sends>`(`.SendCellBag`(.KList))`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(f560092ab59f628f9463eec0f65b1c172f37d9c5d7064c88449f2427728dd6e1) initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'sends'_GT_',((Lazy.force const'Stop'SendCellBag))) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitSendsCell : k Lazy.t = lazy (evalinitSendsCell () interned_bottom (-1))
let evalinitRecsCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitRecsCell and sort = 
SortRecsCell in match c with 
(*{| rule ``initRecsCell(.KList)=>`<recs>`(`.RecCellBag`(.KList))`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(392e607eccf6164dbab4db0d585a8371fd0d7311354f87a7124899d4551cdfb9) initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'recs'_GT_',((Lazy.force const'Stop'RecCellBag))) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitRecsCell : k Lazy.t = lazy (evalinitRecsCell () interned_bottom (-1))
let evalinitTuplespaceCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitTuplespaceCell and sort = 
SortTuplespaceCell in match c with 
(*{| rule ``initTuplespaceCell(.KList)=>`<tuplespace>`(initSendsCell(.KList),initRecsCell(.KList))`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(378c3acdf944f723306729e6f02a6db8d01d83484d132342dfdb17279f6828ce) initializer()]|}*)
| () -> (KApply2(Lbl'_LT_'tuplespace'_GT_',((Lazy.force constinitSendsCell)),((Lazy.force constinitRecsCell))) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitTuplespaceCell : k Lazy.t = lazy (evalinitTuplespaceCell () interned_bottom (-1))
let eval_'EqlsSlshEqls'Bool__BOOL (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'EqlsSlshEqls'Bool__BOOL and sort = 
SortBool in match c with 
| _ -> try BOOL.hook_ne c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_=/=Bool__BOOL`(B1,B2)=>`notBool_`(`_==Bool__BOOL`(B1,B2))`` requires `_andBool_`(isBool(B2),isBool(B1)) ensures #token("true","Bool") [UNIQUE_ID(229c060a3ad56352e70dadb0089a132434aa77f4aaf4ef46e44d820031a08b83) contentStartColumn(8) contentStartLine(332) org.kframework.attributes.Location(Location(332,8,332,57)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool _ as varB1_278) :: []),((Bool _ as varB2_279) :: [])) when ((true) && (true)) && (true) -> ([Bool ((not ((isTrue (eval_'EqlsEqls'Bool__BOOL((varB1_278 :: []),(varB2_279 :: [])) config (-1))))))])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalremoveAll (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblremoveAll and sort = 
SortMap in match c with 
| _ -> try MAP.hook_removeAll c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisTCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisTCell and sort = 
SortBool in match c with 
(*{| rule ``isTCell(#KToken(#token("TCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortTCell, var__280) :: [])) -> ((Bool true) :: [])
(*{| rule ``isTCell(`<T>`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isActivityCell(K0),isTuplespaceCell(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl'_LT_'T'_GT_',(varK0_281 :: []),(varK1_282 :: [])) :: [])) when (((isTrue (evalisActivityCell((varK0_281 :: [])) config (-1)))) && ((isTrue (evalisTuplespaceCell((varK1_282 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isTCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_283)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_'LSqB'_'Slsh'_'RSqB'_SUBSTITUTION (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'LSqB'_'Slsh'_'RSqB'_SUBSTITUTION and sort = 
SortK in match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let evalinitTCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblinitTCell and sort = 
SortTCell in match c with 
(*{| rule ``initTCell(Init)=>`<T>`(initActivityCell(Init),initTuplespaceCell(.KList))`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(0fbc20ab2b109e70a36deb420e1b9f875cc0f9e6586fc2428535d1ed21b71478) initializer()]|}*)
| (((Map (SortMap,_,_) as varInit_284) :: [])) -> (KApply2(Lbl'_LT_'T'_GT_',((evalinitActivityCell((varInit_284 :: [])) config (-1))),((Lazy.force constinitTuplespaceCell))) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalFloatFormat (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblFloatFormat and sort = 
SortString in match c with 
| _ -> try STRING.hook_floatFormat c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'Xor_Perc'Int___INT (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'Xor_Perc'Int___INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_powmod c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let eval_RecCellBag_ (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_RecCellBag_ and sort = 
SortRecCellBag in match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'Pipe'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'Pipe'Int__INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_or c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisKVariable (c: k) (config: k) (guard: int) : k = let lbl = 
LblisKVariable and sort = 
SortBool in match c with 
(*{| rule ``isKVariable(`Quote`(K0))=>#token("true","Bool")`` requires isProc(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(LblQuote,(varK0_285 :: [])) :: [])) when (isTrue (evalisProc((varK0_285 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isKVariable(#KToken(#token("KVariable","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortKVariable, var__286) :: [])) -> ((Bool true) :: [])
(*{| rule ``isKVariable(#KToken(#token("Id","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortId, var__287) :: [])) -> ((Bool true) :: [])
(*{| rule ``isKVariable(#KToken(#token("Name","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortName, var__288) :: [])) -> ((Bool true) :: [])
(*{| rule ``isKVariable(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_289)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_dividesInt__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_dividesInt__INT and sort = 
SortBool in match c with 
(*{| rule `` `_dividesInt__INT`(I1,I2)=>`_==Int_`(`_%Int__INT`(I2,I1),#token("0","Int"))`` requires `_andBool_`(isInt(I1),isInt(I2)) ensures #token("true","Bool") [UNIQUE_ID(81f77f3fbad78d0c735f87bfe9eff8339b46a8ead5ca820f8d69aafef7cb551d) contentStartColumn(8) contentStartLine(409) org.kframework.attributes.Location(Location(409,8,409,58)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Int _ as varI1_290) :: []),((Int _ as varI2_291) :: [])) when ((true) && (true)) && (true) -> ((eval_'EqlsEqls'Int_(((eval_'Perc'Int__INT((varI2_291 :: []),(varI1_290 :: [])) config (-1))),((Lazy.force int0) :: [])) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval'Hash'stat'LPar'_'RPar'_K'Hyph'IO (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'stat'LPar'_'RPar'_K'Hyph'IO and sort = 
SortKItem in match c with 
| _ -> try IO.hook_stat c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalupdateList (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
LblupdateList and sort = 
SortList in match c with 
| _ -> try LIST.hook_updateAll c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let evalinitContCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitContCell and sort = 
SortContCell in match c with 
(*{| rule ``initContCell(.KList)=>`<cont>`(.K)`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(9ae3f63ba6a8508ad4e1712e7170da45c90d694ae480d00f73186c6370430ef6) initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'cont'_GT_',([])) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitContCell : k Lazy.t = lazy (evalinitContCell () interned_bottom (-1))
let evalSet'Coln'choice (c: k) (config: k) (guard: int) : k = let lbl = 
LblSet'Coln'choice and sort = 
SortKItem in match c with 
| _ -> try SET.hook_choice c lbl sort config freshFunction
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
let eval'Hash'write'LPar'_'Comm'_'RPar'_K'Hyph'IO (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'write'LPar'_'Comm'_'RPar'_K'Hyph'IO and sort = 
SortK in match c with 
| _ -> try IO.hook_write c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisRecCellFragment (c: k) (config: k) (guard: int) : k = let lbl = 
LblisRecCellFragment and sort = 
SortBool in match c with 
(*{| rule ``isRecCellFragment(`<rec>-fragment`(K0,K1,K2))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(isRchanCellOpt(K0),isBindCellOpt(K1)),isContCellOpt(K2)) ensures #token("true","Bool") []|}*)
| ((KApply3(Lbl'_LT_'rec'_GT_Hyph'fragment,(varK0_292 :: []),(varK1_293 :: []),(varK2_294 :: [])) :: [])) when (((((isTrue (evalisRchanCellOpt((varK0_292 :: [])) config (-1)))) && ((isTrue (evalisBindCellOpt((varK1_293 :: [])) config (-1)))))) && ((isTrue (evalisContCellOpt((varK2_294 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isRecCellFragment(#KToken(#token("RecCellFragment","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRecCellFragment, var__295) :: [])) -> ((Bool true) :: [])
(*{| rule ``isRecCellFragment(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_296)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalinitRchanCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitRchanCell and sort = 
SortRchanCell in match c with 
(*{| rule ``initRchanCell(.KList)=>`<rchan>`(.K)`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(cab1c86ccacb9bc40fb33b71a3b586c1243fa7873bb0dce6aa53edd70b629c57) initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'rchan'_GT_',([])) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitRchanCell : k Lazy.t = lazy (evalinitRchanCell () interned_bottom (-1))
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
let evalString2Float (c: k) (config: k) (guard: int) : k = let lbl = 
LblString2Float and sort = 
SortFloat in match c with 
| _ -> try STRING.hook_string2float c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Hash'stdout_K'Hyph'IO (c: unit) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'stdout_K'Hyph'IO and sort = 
SortInt in match c with 
(*{| rule `` `#stdout_K-IO`(.KList)=>#token("1","Int")`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(fd57288699ac44a10b4d3e3c65ee3ad16f98646109e64ed7a5ac726279e39ae9) contentStartColumn(8) contentStartLine(909) org.kframework.attributes.Location(Location(909,8,909,20)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| () -> ((Lazy.force int1) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let const'Hash'stdout_K'Hyph'IO : k Lazy.t = lazy (eval'Hash'stdout_K'Hyph'IO () interned_bottom (-1))
let eval_'And'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'And'Int__INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_and c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalinitBindCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitBindCell and sort = 
SortBindCell in match c with 
(*{| rule ``initBindCell(.KList)=>`<bind>`(.K)`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(c52e16e8178d7aa83e1cf8115c3dca4d8d4bfb17f00b8574228337bfda45fc8c) initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'bind'_GT_',([])) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitBindCell : k Lazy.t = lazy (evalinitBindCell () interned_bottom (-1))
let evallog2Int (c: k) (config: k) (guard: int) : k = let lbl = 
Lbllog2Int and sort = 
SortInt in match c with 
| _ -> try INT.hook_log2 c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Hash'stdin_K'Hyph'IO (c: unit) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'stdin_K'Hyph'IO and sort = 
SortInt in match c with 
(*{| rule `` `#stdin_K-IO`(.KList)=>#token("0","Int")`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(595a161d3d44d3c588fcd417f7279ef70547c573e159ef5bfc70692b22149da9) contentStartColumn(8) contentStartLine(908) org.kframework.attributes.Location(Location(908,8,908,19)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| () -> ((Lazy.force int0) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let const'Hash'stdin_K'Hyph'IO : k Lazy.t = lazy (eval'Hash'stdin_K'Hyph'IO () interned_bottom (-1))
let evalBase2String (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblBase2String and sort = 
SortString in match c with 
| _ -> try STRING.hook_base2string c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalListItem (c: k) (config: k) (guard: int) : k = let lbl = 
LblListItem and sort = 
SortList in match c with 
| _ -> try LIST.hook_element c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisStream (c: k) (config: k) (guard: int) : k = let lbl = 
LblisStream and sort = 
SortBool in match c with 
(*{| rule ``isStream(#buffer(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Hash'buffer,(varK0_297)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isStream(#KToken(#token("Stream","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortStream, var__298) :: [])) -> ((Bool true) :: [])
(*{| rule ``isStream(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_299)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_'_GT_Eqls'String__STRING (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'_GT_Eqls'String__STRING and sort = 
SortBool in match c with 
| _ -> try STRING.hook_ge c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_>=String__STRING`(S1,S2)=>`notBool_`(`_<String__STRING`(S1,S2))`` requires `_andBool_`(isString(S2),isString(S1)) ensures #token("true","Bool") [UNIQUE_ID(2e24bd4be2ac7aa21b58ac7fe4e1e4e70e5e69437dff6c98e3ff986df28f5b21) contentStartColumn(8) contentStartLine(551) org.kframework.attributes.Location(Location(551,8,551,63)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/nightly/k/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((String _ as varS1_300) :: []),((String _ as varS2_301) :: [])) when ((true) && (true)) && (true) -> ([Bool ((not ((isTrue (eval_'_LT_'String__STRING((varS1_300 :: []),(varS2_301 :: [])) config (-1))))))])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisRecsCellFragment (c: k) (config: k) (guard: int) : k = let lbl = 
LblisRecsCellFragment and sort = 
SortBool in match c with 
(*{| rule ``isRecsCellFragment(`<recs>-fragment`(K0))=>#token("true","Bool")`` requires isRecCellBag(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'recs'_GT_Hyph'fragment,(varK0_302 :: [])) :: [])) when (isTrue (evalisRecCellBag((varK0_302 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isRecsCellFragment(#KToken(#token("RecsCellFragment","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRecsCellFragment, var__303) :: [])) -> ((Bool true) :: [])
(*{| rule ``isRecsCellFragment(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_304)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
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
let evalisId (c: k) (config: k) (guard: int) : k = let lbl = 
LblisId and sort = 
SortBool in match c with 
(*{| rule ``isId(#KToken(#token("Id","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortId, var__305) :: [])) -> ((Bool true) :: [])
(*{| rule ``isId(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_306)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_SendCellBag_ (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_SendCellBag_ and sort = 
SortSendCellBag in match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisActivityCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisActivityCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isActivityCellOpt(#KToken(#token("ActivityCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortActivityCell, var__307) :: [])) -> ((Bool true) :: [])
(*{| rule ``isActivityCellOpt(#KToken(#token("ActivityCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortActivityCellOpt, var__308) :: [])) -> ((Bool true) :: [])
(*{| rule ``isActivityCellOpt(noActivityCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoActivityCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isActivityCellOpt(`<activity>`(K0))=>#token("true","Bool")`` requires isThreadCellBag(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'activity'_GT_',(varK0_309 :: [])) :: [])) when (isTrue (evalisThreadCellBag((varK0_309 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isActivityCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_310)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalsize (c: k) (config: k) (guard: int) : k = let lbl = 
Lblsize and sort = 
SortInt in match c with 
| _ -> try SET.hook_size c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_inList_ (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_inList_ and sort = 
SortBool in match c with 
| _ -> try LIST.hook_in c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisMap (c: k) (config: k) (guard: int) : k = let lbl = 
LblisMap and sort = 
SortBool in match c with 
| [Map (s,_,_)] when (s = SortMap) -> [Bool true]
(*{| rule ``isMap(#KToken(#token("Map","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortMap, var__311) :: [])) -> ((Bool true) :: [])
(*{| rule ``isMap(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_312)) -> ((Bool false) :: [])
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
let evalisTCellFragment (c: k) (config: k) (guard: int) : k = let lbl = 
LblisTCellFragment and sort = 
SortBool in match c with 
(*{| rule ``isTCellFragment(`<T>-fragment`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isActivityCellOpt(K0),isTuplespaceCellOpt(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl'_LT_'T'_GT_Hyph'fragment,(varK0_313 :: []),(varK1_314 :: [])) :: [])) when (((isTrue (evalisActivityCellOpt((varK0_313 :: [])) config (-1)))) && ((isTrue (evalisTuplespaceCellOpt((varK1_314 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isTCellFragment(#KToken(#token("TCellFragment","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortTCellFragment, var__315) :: [])) -> ((Bool true) :: [])
(*{| rule ``isTCellFragment(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_316)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_'LSqB'_'_LT_Hyph'_'RSqB'_MAP (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'LSqB'_'_LT_Hyph'_'RSqB'_MAP and sort = 
SortMap in match c with 
| _ -> try MAP.hook_update c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let eval'Hash'tell'LPar'_'RPar'_K'Hyph'IO (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'tell'LPar'_'RPar'_K'Hyph'IO and sort = 
SortInt in match c with 
| _ -> try IO.hook_tell c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalkeys (c: k) (config: k) (guard: int) : k = let lbl = 
Lblkeys and sort = 
SortSet in match c with 
| _ -> try MAP.hook_keys c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalinitRecCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitRecCell and sort = 
SortRecCell in match c with 
(*{| rule ``initRecCell(.KList)=>`<rec>`(initRchanCell(.KList),initBindCell(.KList),initContCell(.KList))`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(449b71b0f957b9dff0ffe056ac810f261b54690e5b497c4cf17ec40ec3abd4e4) initializer()]|}*)
| () -> (KApply3(Lbl'_LT_'rec'_GT_',((Lazy.force constinitRchanCell)),((Lazy.force constinitBindCell)),((Lazy.force constinitContCell))) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitRecCell : k Lazy.t = lazy (evalinitRecCell () interned_bottom (-1))
let eval'Stop'ThreadCellBag (c: unit) (config: k) (guard: int) : k = let lbl = 
Lbl'Stop'ThreadCellBag and sort = 
SortThreadCellBag in match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let const'Stop'ThreadCellBag : k Lazy.t = lazy (eval'Stop'ThreadCellBag () interned_bottom (-1))
let evalgetKLabel (c: k) (config: k) (guard: int) : k = let lbl = 
LblgetKLabel and sort = 
SortKItem in match c with 
| _ -> try KREFLECTION.hook_getKLabel c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalThreadCellBagItem (c: k) (config: k) (guard: int) : k = let lbl = 
LblThreadCellBagItem and sort = 
SortThreadCellBag in match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Hash'seekEnd'LPar'_'Comm'_'RPar'_K'Hyph'IO (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'seekEnd'LPar'_'Comm'_'RPar'_K'Hyph'IO and sort = 
SortK in match c with 
| _ -> try IO.hook_seekEnd c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalinitSendCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitSendCell and sort = 
SortSendCell in match c with 
(*{| rule ``initSendCell(.KList)=>`<send>`(initSchanCell(.KList),initMsgCell(.KList))`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(3d667910c8971558bcea704f7ab0a00be22e965a33463c1c78d465029ff3b2ff) initializer()]|}*)
| () -> (KApply2(Lbl'_LT_'send'_GT_',((Lazy.force constinitSchanCell)),((Lazy.force constinitMsgCell))) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitSendCell : k Lazy.t = lazy (evalinitSendCell () interned_bottom (-1))
let eval (c: normal_kitem) (config: k) : k = match c with KApply(lbl, kl) -> (match lbl with 
|Lbl'Hash'argv -> eval'Hash'argv (normalize0 kl) config (-1)
|LblisThreadCell -> evalisThreadCell (normalize1 kl) config (-1)
|LblnotBool_ -> evalnotBool_ (normalize1 kl) config (-1)
|Lbl_'_LT_Eqls'Int__INT -> eval_'_LT_Eqls'Int__INT (normalize2 kl) config (-1)
|LblMap'Coln'lookup -> evalMap'Coln'lookup (normalize2 kl) config (-1)
|Lbl'Hash'stderr_K'Hyph'IO -> eval'Hash'stderr_K'Hyph'IO (normalize0 kl) config (-1)
|LblisActivityCell -> evalisActivityCell (normalize1 kl) config (-1)
|Lbl'Hash'seek'LPar'_'Comm'_'RPar'_K'Hyph'IO -> eval'Hash'seek'LPar'_'Comm'_'RPar'_K'Hyph'IO (normalize2 kl) config (-1)
|Lbl_'EqlsEqls'Bool__BOOL -> eval_'EqlsEqls'Bool__BOOL (normalize2 kl) config (-1)
|LblsignExtendBitRangeInt -> evalsignExtendBitRangeInt (normalize3 kl) config (-1)
|LblisSet -> evalisSet (normalize1 kl) config (-1)
|Lbl'Hash'getenv -> eval'Hash'getenv (normalize1 kl) config (-1)
|LblisTuplespaceCell -> evalisTuplespaceCell (normalize1 kl) config (-1)
|LblintersectSet -> evalintersectSet (normalize2 kl) config (-1)
|LblinitMsgCell -> evalinitMsgCell (normalize0 kl) config (-1)
|Lbl_in_keys'LPar'_'RPar'_MAP -> eval_in_keys'LPar'_'RPar'_MAP (normalize2 kl) config (-1)
|LblisThreadCellBag -> evalisThreadCellBag (normalize1 kl) config (-1)
|LblfindChar -> evalfindChar (normalize3 kl) config (-1)
|LblSet'Coln'in -> evalSet'Coln'in (normalize2 kl) config (-1)
|LblisK -> evalisK (normalize1 kl) config (-1)
|LblString2Int -> evalString2Int (normalize1 kl) config (-1)
|Lbl_'_LT_Eqls'Set__SET -> eval_'_LT_Eqls'Set__SET (normalize2 kl) config (-1)
|LblinitThreadCell -> evalinitThreadCell (normalize1 kl) config (-1)
|LblisIOError -> evalisIOError (normalize1 kl) config (-1)
|Lbl'Hash'parse -> eval'Hash'parse (normalize2 kl) config (-1)
|LblisRchanCellOpt -> evalisRchanCellOpt (normalize1 kl) config (-1)
|LblmakeList -> evalmakeList (normalize2 kl) config (-1)
|Lbl_'LSqB'_'_LT_Hyph'undef'RSqB' -> eval_'LSqB'_'_LT_Hyph'undef'RSqB' (normalize2 kl) config (-1)
|Lbl'Hash'unlock'LPar'_'Comm'_'RPar'_K'Hyph'IO -> eval'Hash'unlock'LPar'_'Comm'_'RPar'_K'Hyph'IO (normalize2 kl) config (-1)
|Lbl_'EqlsEqls'Int_ -> eval_'EqlsEqls'Int_ (normalize2 kl) config (-1)
|Lbl_andThenBool__BOOL -> eval_andThenBool__BOOL (normalize2 kl) config (-1)
|Lbl'Hash'parseInModule -> eval'Hash'parseInModule (normalize3 kl) config (-1)
|Lbl'Hash'system -> eval'Hash'system (normalize1 kl) config (-1)
|LblisString -> evalisString (normalize1 kl) config (-1)
|Lbl_'Perc'Int__INT -> eval_'Perc'Int__INT (normalize2 kl) config (-1)
|Lbl_'_GT__GT_'Int__INT -> eval_'_GT__GT_'Int__INT (normalize2 kl) config (-1)
|LblisList -> evalisList (normalize1 kl) config (-1)
|LblisTuplespaceCellFragment -> evalisTuplespaceCellFragment (normalize1 kl) config (-1)
|LblreplaceAll'LPar'_'Comm'_'Comm'_'RPar'_STRING -> evalreplaceAll'LPar'_'Comm'_'Comm'_'RPar'_STRING (normalize3 kl) config (-1)
|LblfindString -> evalfindString (normalize3 kl) config (-1)
|Lbl_'Xor_'Int__INT -> eval_'Xor_'Int__INT (normalize2 kl) config (-1)
|LblabsInt -> evalabsInt (normalize1 kl) config (-1)
|Lbl_'_GT_'String__STRING -> eval_'_GT_'String__STRING (normalize2 kl) config (-1)
|LblisSendsCellFragment -> evalisSendsCellFragment (normalize1 kl) config (-1)
|Lbl_'EqlsEqls'String__STRING -> eval_'EqlsEqls'String__STRING (normalize2 kl) config (-1)
|LblisKConfigVar -> evalisKConfigVar (normalize1 kl) config (-1)
|LblisCell -> evalisCell (normalize1 kl) config (-1)
|Lblvalues -> evalvalues (normalize1 kl) config (-1)
|LblList'Coln'get -> evalList'Coln'get (normalize2 kl) config (-1)
|Lbl'Hash'lstat'LPar'_'RPar'_K'Hyph'IO -> eval'Hash'lstat'LPar'_'RPar'_K'Hyph'IO (normalize1 kl) config (-1)
|LblSendCellBagItem -> evalSendCellBagItem (normalize1 kl) config (-1)
|LblisThreadCellFragment -> evalisThreadCellFragment (normalize1 kl) config (-1)
|LblSetItem -> evalSetItem (normalize1 kl) config (-1)
|LblisTuplespaceCellOpt -> evalisTuplespaceCellOpt (normalize1 kl) config (-1)
|Lbl_'_LT_'Int__INT -> eval_'_LT_'Int__INT (normalize2 kl) config (-1)
|Lbl'Stop'List -> eval'Stop'List (normalize0 kl) config (-1)
|LblisSendCell -> evalisSendCell (normalize1 kl) config (-1)
|LblisSendsCellOpt -> evalisSendsCellOpt (normalize1 kl) config (-1)
|LblrandInt -> evalrandInt (normalize1 kl) config (-1)
|Lbl'Hash'configuration_K'Hyph'REFLECTION -> eval'Hash'configuration_K'Hyph'REFLECTION (normalize0 kl) config (-1)
|LblisSendsCell -> evalisSendsCell (normalize1 kl) config (-1)
|LblisFloat -> evalisFloat (normalize1 kl) config (-1)
|Lbl'Hash'close'LPar'_'RPar'_K'Hyph'IO -> eval'Hash'close'LPar'_'RPar'_K'Hyph'IO (normalize1 kl) config (-1)
|Lblkeys_list'LPar'_'RPar'_MAP -> evalkeys_list'LPar'_'RPar'_MAP (normalize1 kl) config (-1)
|LblisContCell -> evalisContCell (normalize1 kl) config (-1)
|LblfreshId -> evalfreshId (normalize1 kl) config (-1)
|LblchrChar -> evalchrChar (normalize1 kl) config (-1)
|LblisSchanCellOpt -> evalisSchanCellOpt (normalize1 kl) config (-1)
|Lbl_orElseBool__BOOL -> eval_orElseBool__BOOL (normalize2 kl) config (-1)
|Lbl_divInt__INT -> eval_divInt__INT (normalize2 kl) config (-1)
|Lbl_ThreadCellBag_ -> eval_ThreadCellBag_ (normalize2 kl) config (-1)
|LblList'Coln'range -> evalList'Coln'range (normalize3 kl) config (-1)
|LblisProc -> evalisProc (normalize1 kl) config (-1)
|Lbl_'Plus'Int_ -> eval_'Plus'Int_ (normalize2 kl) config (-1)
|LblisKCell -> evalisKCell (normalize1 kl) config (-1)
|Lbl_orBool__BOOL -> eval_orBool__BOOL (normalize2 kl) config (-1)
|Lbl_'_GT_Eqls'Int__INT -> eval_'_GT_Eqls'Int__INT (normalize2 kl) config (-1)
|LblisSendCellFragment -> evalisSendCellFragment (normalize1 kl) config (-1)
|LblupdateMap -> evalupdateMap (normalize2 kl) config (-1)
|LblisRecsCell -> evalisRecsCell (normalize1 kl) config (-1)
|LblInt2String -> evalInt2String (normalize1 kl) config (-1)
|Lbl_'EqlsSlshEqls'K_ -> eval_'EqlsSlshEqls'K_ (normalize2 kl) config (-1)
|Lbl'Hash'lock'LPar'_'Comm'_'RPar'_K'Hyph'IO -> eval'Hash'lock'LPar'_'Comm'_'RPar'_K'Hyph'IO (normalize2 kl) config (-1)
|LblcountAllOccurrences'LPar'_'Comm'_'RPar'_STRING -> evalcountAllOccurrences'LPar'_'Comm'_'RPar'_STRING (normalize2 kl) config (-1)
|Lbl_'_GT_'Int__INT -> eval_'_GT_'Int__INT (normalize2 kl) config (-1)
|LblfillList -> evalfillList (normalize4 kl) config (-1)
|LblbitRangeInt -> evalbitRangeInt (normalize3 kl) config (-1)
|LblisRecCell -> evalisRecCell (normalize1 kl) config (-1)
|Lbl_'_LT_'String__STRING -> eval_'_LT_'String__STRING (normalize2 kl) config (-1)
|Lbl_List_ -> eval_List_ (normalize2 kl) config (-1)
|Lbl'Hash'open'LPar'_'Comm'_'RPar'_K'Hyph'IO -> eval'Hash'open'LPar'_'Comm'_'RPar'_K'Hyph'IO (normalize2 kl) config (-1)
|Lbl_'PipeHyph_GT_'_ -> eval_'PipeHyph_GT_'_ (normalize2 kl) config (-1)
|Lbl_xorBool__BOOL -> eval_xorBool__BOOL (normalize2 kl) config (-1)
|Lbl_'Hyph'Map__MAP -> eval_'Hyph'Map__MAP (normalize2 kl) config (-1)
|LblisRecsCellOpt -> evalisRecsCellOpt (normalize1 kl) config (-1)
|Lbl'Stop'RecCellBag -> eval'Stop'RecCellBag (normalize0 kl) config (-1)
|Lbl_'EqlsEqls'K_ -> eval_'EqlsEqls'K_ (normalize2 kl) config (-1)
|Lbl'Hash'sort -> eval'Hash'sort (normalize1 kl) config (-1)
|Lbl'Hash'open'LPar'_'RPar'_K'Hyph'IO -> eval'Hash'open'LPar'_'RPar'_K'Hyph'IO (normalize1 kl) config (-1)
|LblisBindCellOpt -> evalisBindCellOpt (normalize1 kl) config (-1)
|Lbl_'LSqB'_'RSqB'_SUBSTITUTION -> eval_'LSqB'_'RSqB'_SUBSTITUTION (normalize2 kl) config (-1)
|LblreplaceFirst'LPar'_'Comm'_'Comm'_'RPar'_STRING -> evalreplaceFirst'LPar'_'Comm'_'Comm'_'RPar'_STRING (normalize3 kl) config (-1)
|LblisBindCell -> evalisBindCell (normalize1 kl) config (-1)
|Lbl'Hash'putc'LPar'_'Comm'_'RPar'_K'Hyph'IO -> eval'Hash'putc'LPar'_'Comm'_'RPar'_K'Hyph'IO (normalize2 kl) config (-1)
|Lbl'Stop'Map -> eval'Stop'Map (normalize0 kl) config (-1)
|Lbl'Hash'logToFile -> eval'Hash'logToFile (normalize2 kl) config (-1)
|Lbl_'EqlsSlshEqls'String__STRING -> eval_'EqlsSlshEqls'String__STRING (normalize2 kl) config (-1)
|Lbl'Hash'read'LPar'_'Comm'_'RPar'_K'Hyph'IO -> eval'Hash'read'LPar'_'Comm'_'RPar'_K'Hyph'IO (normalize2 kl) config (-1)
|LblisSendCellBag -> evalisSendCellBag (normalize1 kl) config (-1)
|LblId2String -> evalId2String (normalize1 kl) config (-1)
|LblisInt -> evalisInt (normalize1 kl) config (-1)
|LblisContCellOpt -> evalisContCellOpt (normalize1 kl) config (-1)
|Lbl'Hash'fresh -> eval'Hash'fresh (normalize1 kl) config (-1)
|LblMap'Coln'choice -> evalMap'Coln'choice (normalize1 kl) config (-1)
|Lbl_impliesBool__BOOL -> eval_impliesBool__BOOL (normalize2 kl) config (-1)
|Lbl'Hash'getc'LPar'_'RPar'_K'Hyph'IO -> eval'Hash'getc'LPar'_'RPar'_K'Hyph'IO (normalize1 kl) config (-1)
|Lbl_Set_ -> eval_Set_ (normalize2 kl) config (-1)
|LblinitActivityCell -> evalinitActivityCell (normalize1 kl) config (-1)
|Lbl_'Star'Int__INT -> eval_'Star'Int__INT (normalize2 kl) config (-1)
|LblisActivityCellFragment -> evalisActivityCellFragment (normalize1 kl) config (-1)
|LblmaxInt'LPar'_'Comm'_'RPar'_INT -> evalmaxInt'LPar'_'Comm'_'RPar'_INT (normalize2 kl) config (-1)
|LblisBool -> evalisBool (normalize1 kl) config (-1)
|Lbl'Tild'Int__INT -> eval'Tild'Int__INT (normalize1 kl) config (-1)
|Lbl_'_LT_Eqls'String__STRING -> eval_'_LT_Eqls'String__STRING (normalize2 kl) config (-1)
|LblordChar -> evalordChar (normalize1 kl) config (-1)
|LblrfindChar -> evalrfindChar (normalize3 kl) config (-1)
|Lbl_modInt__INT -> eval_modInt__INT (normalize2 kl) config (-1)
|Lbl_Map_ -> eval_Map_ (normalize2 kl) config (-1)
|Lbl_'Hyph'Int__INT -> eval_'Hyph'Int__INT (normalize2 kl) config (-1)
|LblinitSchanCell -> evalinitSchanCell (normalize0 kl) config (-1)
|LbldirectionalityChar -> evaldirectionalityChar (normalize1 kl) config (-1)
|LblFloat2String -> evalFloat2String (normalize1 kl) config (-1)
|Lbl'Hash'opendir'LPar'_'RPar'_K'Hyph'IO -> eval'Hash'opendir'LPar'_'RPar'_K'Hyph'IO (normalize1 kl) config (-1)
|LblinitKCell -> evalinitKCell (normalize1 kl) config (-1)
|LblRecCellBagItem -> evalRecCellBagItem (normalize1 kl) config (-1)
|LblsizeList -> evalsizeList (normalize1 kl) config (-1)
|Lbl'Stop'Set -> eval'Stop'Set (normalize0 kl) config (-1)
|LblinitTuplespaceCell -> evalinitTuplespaceCell (normalize0 kl) config (-1)
|LblString2Id -> evalString2Id (normalize1 kl) config (-1)
|Lbl_'EqlsSlshEqls'Bool__BOOL -> eval_'EqlsSlshEqls'Bool__BOOL (normalize2 kl) config (-1)
|LblisRchanCell -> evalisRchanCell (normalize1 kl) config (-1)
|LblremoveAll -> evalremoveAll (normalize2 kl) config (-1)
|LblisTCell -> evalisTCell (normalize1 kl) config (-1)
|Lbl_'LSqB'_'Slsh'_'RSqB'_SUBSTITUTION -> eval_'LSqB'_'Slsh'_'RSqB'_SUBSTITUTION (normalize3 kl) config (-1)
|Lbl_andBool_ -> eval_andBool_ (normalize2 kl) config (-1)
|LbllengthString -> evallengthString (normalize1 kl) config (-1)
|LblinitTCell -> evalinitTCell (normalize1 kl) config (-1)
|LblFloatFormat -> evalFloatFormat (normalize2 kl) config (-1)
|Lbl_'Plus'String__STRING -> eval_'Plus'String__STRING (normalize2 kl) config (-1)
|Lbl_'Xor_Perc'Int___INT -> eval_'Xor_Perc'Int___INT (normalize3 kl) config (-1)
|Lbl_RecCellBag_ -> eval_RecCellBag_ (normalize2 kl) config (-1)
|Lbl_'Pipe'Int__INT -> eval_'Pipe'Int__INT (normalize2 kl) config (-1)
|LblisMsgCellOpt -> evalisMsgCellOpt (normalize1 kl) config (-1)
|LblisKVariable -> evalisKVariable (normalize1 kl) config (-1)
|Lbl_dividesInt__INT -> eval_dividesInt__INT (normalize2 kl) config (-1)
|LblrfindString -> evalrfindString (normalize3 kl) config (-1)
|Lbl'Hash'stat'LPar'_'RPar'_K'Hyph'IO -> eval'Hash'stat'LPar'_'RPar'_K'Hyph'IO (normalize1 kl) config (-1)
|LblupdateList -> evalupdateList (normalize3 kl) config (-1)
|LblisMsgCell -> evalisMsgCell (normalize1 kl) config (-1)
|Lbl'Stop'SendCellBag -> eval'Stop'SendCellBag (normalize0 kl) config (-1)
|LblinitContCell -> evalinitContCell (normalize0 kl) config (-1)
|LblSet'Coln'choice -> evalSet'Coln'choice (normalize1 kl) config (-1)
|LblcategoryChar -> evalcategoryChar (normalize1 kl) config (-1)
|LblisName -> evalisName (normalize1 kl) config (-1)
|LblSet'Coln'difference -> evalSet'Coln'difference (normalize2 kl) config (-1)
|LblfreshInt -> evalfreshInt (normalize1 kl) config (-1)
|LblisKCellOpt -> evalisKCellOpt (normalize1 kl) config (-1)
|Lbl'Hash'write'LPar'_'Comm'_'RPar'_K'Hyph'IO -> eval'Hash'write'LPar'_'Comm'_'RPar'_K'Hyph'IO (normalize2 kl) config (-1)
|LblisRecCellFragment -> evalisRecCellFragment (normalize1 kl) config (-1)
|LblinitRchanCell -> evalinitRchanCell (normalize0 kl) config (-1)
|LblisSchanCell -> evalisSchanCell (normalize1 kl) config (-1)
|Lbl_xorInt__INT -> eval_xorInt__INT (normalize2 kl) config (-1)
|LblMap'Coln'lookupOrDefault -> evalMap'Coln'lookupOrDefault (normalize3 kl) config (-1)
|LblString2Float -> evalString2Float (normalize1 kl) config (-1)
|Lbl'Hash'if_'Hash'then_'Hash'else_'Hash'fi_K'Hyph'EQUAL -> eval'Hash'if_'Hash'then_'Hash'else_'Hash'fi_K'Hyph'EQUAL (normalize3 kl) config (-1)
|Lbl'Hash'stdout_K'Hyph'IO -> eval'Hash'stdout_K'Hyph'IO (normalize0 kl) config (-1)
|Lbl_'And'Int__INT -> eval_'And'Int__INT (normalize2 kl) config (-1)
|LblinitBindCell -> evalinitBindCell (normalize0 kl) config (-1)
|Lbl_'EqlsSlshEqls'Int__INT -> eval_'EqlsSlshEqls'Int__INT (normalize2 kl) config (-1)
|Lbl_'_LT__LT_'Int__INT -> eval_'_LT__LT_'Int__INT (normalize2 kl) config (-1)
|Lbllog2Int -> evallog2Int (normalize1 kl) config (-1)
|Lbl'Hash'stdin_K'Hyph'IO -> eval'Hash'stdin_K'Hyph'IO (normalize0 kl) config (-1)
|LblBase2String -> evalBase2String (normalize2 kl) config (-1)
|LblListItem -> evalListItem (normalize1 kl) config (-1)
|LblisStream -> evalisStream (normalize1 kl) config (-1)
|Lbl_'_GT_Eqls'String__STRING -> eval_'_GT_Eqls'String__STRING (normalize2 kl) config (-1)
|LblisRecsCellFragment -> evalisRecsCellFragment (normalize1 kl) config (-1)
|Lbl_'_LT_Eqls'Map__MAP -> eval_'_LT_Eqls'Map__MAP (normalize2 kl) config (-1)
|LblnewUUID_STRING -> evalnewUUID_STRING (normalize0 kl) config (-1)
|LblsizeMap -> evalsizeMap (normalize1 kl) config (-1)
|LblisId -> evalisId (normalize1 kl) config (-1)
|LblsubstrString -> evalsubstrString (normalize3 kl) config (-1)
|Lbl_SendCellBag_ -> eval_SendCellBag_ (normalize2 kl) config (-1)
|LblisActivityCellOpt -> evalisActivityCellOpt (normalize1 kl) config (-1)
|Lblsize -> evalsize (normalize1 kl) config (-1)
|Lblproject'Coln'Proc -> evalproject'Coln'Proc (normalize1 kl) config (-1)
|Lbl_inList_ -> eval_inList_ (normalize2 kl) config (-1)
|LblminInt'LPar'_'Comm'_'RPar'_INT -> evalminInt'LPar'_'Comm'_'RPar'_INT (normalize2 kl) config (-1)
|LblisMap -> evalisMap (normalize1 kl) config (-1)
|LblinitRecsCell -> evalinitRecsCell (normalize0 kl) config (-1)
|LblsrandInt -> evalsrandInt (normalize1 kl) config (-1)
|LblisKItem -> evalisKItem (normalize1 kl) config (-1)
|LblisRecCellBag -> evalisRecCellBag (normalize1 kl) config (-1)
|LblList'Coln'set -> evalList'Coln'set (normalize3 kl) config (-1)
|LblString2Base -> evalString2Base (normalize2 kl) config (-1)
|LblisTCellFragment -> evalisTCellFragment (normalize1 kl) config (-1)
|Lblreplace'LPar'_'Comm'_'Comm'_'Comm'_'RPar'_STRING -> evalreplace'LPar'_'Comm'_'Comm'_'Comm'_'RPar'_STRING (normalize4 kl) config (-1)
|Lbl_'Slsh'Int__INT -> eval_'Slsh'Int__INT (normalize2 kl) config (-1)
|Lbl_'LSqB'_'_LT_Hyph'_'RSqB'_MAP -> eval_'LSqB'_'_LT_Hyph'_'RSqB'_MAP (normalize3 kl) config (-1)
|Lbl'Hash'tell'LPar'_'RPar'_K'Hyph'IO -> eval'Hash'tell'LPar'_'RPar'_K'Hyph'IO (normalize1 kl) config (-1)
|Lblkeys -> evalkeys (normalize1 kl) config (-1)
|LblinitRecCell -> evalinitRecCell (normalize0 kl) config (-1)
|LblinitSendsCell -> evalinitSendsCell (normalize0 kl) config (-1)
|Lbl'Stop'ThreadCellBag -> eval'Stop'ThreadCellBag (normalize0 kl) config (-1)
|LblgetKLabel -> evalgetKLabel (normalize1 kl) config (-1)
|LblThreadCellBagItem -> evalThreadCellBagItem (normalize1 kl) config (-1)
|Lbl'Hash'seekEnd'LPar'_'Comm'_'RPar'_K'Hyph'IO -> eval'Hash'seekEnd'LPar'_'Comm'_'RPar'_K'Hyph'IO (normalize2 kl) config (-1)
|LblinitSendCell -> evalinitSendCell (normalize0 kl) config (-1)
| _ -> [denormalize c])
| _ -> [denormalize c]
let rec get_next_op_from_exp(c: kitem) : (k -> k * (step_function)) = step
and step (c:k) : k * step_function =
 try let config = c in match c with 
(*{| rule `<T>`(DotVar0,`<tuplespace>`(DotVar1,`<recs>`(`_RecCellBag_`(`<rec>`(_0,_1,`<cont>`(`` `Reify`(`Quote`(P))=>P``)),DotVar2)))) requires isProc(P) ensures #token("true","Bool") [UNIQUE_ID(ba213faa54c17dbd465f2a9d6830580a24c2a3cd5748128ec5c6f20dfd30e418) contentStartColumn(8) contentStartLine(107) org.kframework.attributes.Location(Location(107,8,107,38)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/Git/KFramework/Rho-Calc/./rho.k)) org.kframework.definition.Production(syntax RuleContent ::= K) structural()]|}*)
| (KApply2(Lbl'_LT_'T'_GT_',(varDotVar0_317),(KApply2(Lbl'_LT_'tuplespace'_GT_',(varDotVar1_318),(KApply1(Lbl'_LT_'recs'_GT_',((eval_RecCellBag_((KApply3(Lbl'_LT_'rec'_GT_',(var_0_319),(var_1_320),(KApply1(Lbl'_LT_'cont'_GT_',(KApply1(LblReify,(KApply1(LblQuote,(varP_321 :: [])) :: [])) :: [])) :: [])) :: []),(varDotVar2_322 :: [])) config (-1)) :: [])) :: [])) :: [])) :: []) when (isTrue (evalisProc((varP_321 :: [])) config (-1))) && (true) -> (((KApply2(Lbl'_LT_'T'_GT_',(varDotVar0_317),(KApply2(Lbl'_LT_'tuplespace'_GT_',(varDotVar1_318),(KApply1(Lbl'_LT_'recs'_GT_',((eval_RecCellBag_((KApply3(Lbl'_LT_'rec'_GT_',(var_0_319),(var_1_320),(KApply1(Lbl'_LT_'cont'_GT_',(varP_321 :: [])) :: [])) :: []),(varDotVar2_322 :: [])) config (-1)))) :: [])) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(DotVar0,`<tuplespace>`(DotVar1,`<recs>`(`_RecCellBag_`(`<rec>`(`<rchan>`(`` `Quote`(`Reify`(X))=>X``),_0,_1),DotVar2)))) requires isName(X) ensures #token("true","Bool") [UNIQUE_ID(f0dd8ed7da7c929b6709550ae9923c5b6487f8db6fe8652d2c97f95ec6bbe529) contentStartColumn(8) contentStartLine(101) org.kframework.attributes.Location(Location(101,8,101,40)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/Git/KFramework/Rho-Calc/./rho.k)) org.kframework.definition.Production(syntax RuleContent ::= K) structural()]|}*)
| (KApply2(Lbl'_LT_'T'_GT_',(varDotVar0_323),(KApply2(Lbl'_LT_'tuplespace'_GT_',(varDotVar1_324),(KApply1(Lbl'_LT_'recs'_GT_',((eval_RecCellBag_((KApply3(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'rchan'_GT_',(KApply1(LblQuote,(KApply1(LblReify,(varX_325 :: [])) :: [])) :: [])) :: []),(var_0_326),(var_1_327)) :: []),(varDotVar2_328 :: [])) config (-1)) :: [])) :: [])) :: [])) :: []) when (isTrue (evalisName((varX_325 :: [])) config (-1))) && (true) -> (((KApply2(Lbl'_LT_'T'_GT_',(varDotVar0_323),(KApply2(Lbl'_LT_'tuplespace'_GT_',(varDotVar1_324),(KApply1(Lbl'_LT_'recs'_GT_',((eval_RecCellBag_((KApply3(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'rchan'_GT_',(varX_325 :: [])) :: []),(var_0_326),(var_1_327)) :: []),(varDotVar2_328 :: [])) config (-1)))) :: [])) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(`<activity>`(`_ThreadCellBag_`(`<thread>`(`<k>`(`` `Par`(P,`Stop`(.KList))=>P``~>DotVar3)),DotVar1)),DotVar0) requires isProc(P) ensures #token("true","Bool") [UNIQUE_ID(2522ab025cc738db43f532b970d9f7da20243fe1b89f04c7ac5f7af9918c2b03) contentStartColumn(8) contentStartLine(86) org.kframework.attributes.Location(Location(86,8,86,25)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/Git/KFramework/Rho-Calc/./rho.k)) org.kframework.definition.Production(syntax RuleContent ::= K) structural()]|}*)
| (KApply2(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'activity'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(KApply2(LblPar,(varP_329 :: []),(KApply0(LblStop) :: [])) :: varDotVar3_330)) :: [])) :: []),(varDotVar1_331 :: [])) config (-1)) :: [])) :: []),(varDotVar0_332)) :: []) when (isTrue (evalisProc((varP_329 :: [])) config (-1))) && (true) -> (((KApply2(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'activity'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(varP_329 :: varDotVar3_330)) :: [])) :: []),(varDotVar1_331 :: [])) config (-1)))) :: []),(varDotVar0_332)) :: [])), (StepFunc step))
(*{| rule `<T>`(`<activity>`(`_ThreadCellBag_`(`` `<thread>`(`<k>`(`Stop`(.KList)))=>`.ThreadCellBag`(.KList)``,DotVar1)),DotVar0) requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(76547211e533ebf97409c1fcac17aa233526c17b9fd17a9ee54e08a59192e859) contentStartColumn(8) contentStartLine(92) org.kframework.attributes.Location(Location(92,8,92,47)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/Git/KFramework/Rho-Calc/./rho.k)) org.kframework.definition.Production(syntax RuleContent ::= K) structural()]|}*)
| (KApply2(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'activity'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(KApply0(LblStop) :: [])) :: [])) :: []),(varDotVar1_333 :: [])) config (-1)) :: [])) :: []),(varDotVar0_334)) :: []) -> (((KApply2(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'activity'_GT_',((eval_ThreadCellBag_(((Lazy.force const'Stop'ThreadCellBag)),(varDotVar1_333 :: [])) config (-1)))) :: []),(varDotVar0_334)) :: [])), (StepFunc step))
(*{| rule `<T>`(DotVar0,`<tuplespace>`(DotVar1,`<recs>`(`_RecCellBag_`(`<rec>`(_0,_1,`<cont>`(`` `Par`(P,`Stop`(.KList))=>P``)),DotVar2)))) requires isProc(P) ensures #token("true","Bool") [UNIQUE_ID(2bf748ee658d5ec106e1bdc9dade6d53e65a024a95399770f323bc12d7b06d90) contentStartColumn(8) contentStartLine(88) org.kframework.attributes.Location(Location(88,8,88,40)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/Git/KFramework/Rho-Calc/./rho.k)) org.kframework.definition.Production(syntax RuleContent ::= K) structural()]|}*)
| (KApply2(Lbl'_LT_'T'_GT_',(varDotVar0_335),(KApply2(Lbl'_LT_'tuplespace'_GT_',(varDotVar1_336),(KApply1(Lbl'_LT_'recs'_GT_',((eval_RecCellBag_((KApply3(Lbl'_LT_'rec'_GT_',(var_0_337),(var_1_338),(KApply1(Lbl'_LT_'cont'_GT_',(KApply2(LblPar,(varP_339 :: []),(KApply0(LblStop) :: [])) :: [])) :: [])) :: []),(varDotVar2_340 :: [])) config (-1)) :: [])) :: [])) :: [])) :: []) when (isTrue (evalisProc((varP_339 :: [])) config (-1))) && (true) -> (((KApply2(Lbl'_LT_'T'_GT_',(varDotVar0_335),(KApply2(Lbl'_LT_'tuplespace'_GT_',(varDotVar1_336),(KApply1(Lbl'_LT_'recs'_GT_',((eval_RecCellBag_((KApply3(Lbl'_LT_'rec'_GT_',(var_0_337),(var_1_338),(KApply1(Lbl'_LT_'cont'_GT_',(varP_339 :: [])) :: [])) :: []),(varDotVar2_340 :: [])) config (-1)))) :: [])) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(DotVar0,`<tuplespace>`(`<sends>`(`_SendCellBag_`(`<send>`(`<schan>`(`` `Quote`(`Reify`(X))=>X``),DotVar3),DotVar2)),DotVar1)) requires isName(X) ensures #token("true","Bool") [UNIQUE_ID(a4316a7cd66bce4570b45247620ecee2204837994aa301b7e4b9eca4e23218b0) contentStartColumn(8) contentStartLine(103) org.kframework.attributes.Location(Location(103,8,103,40)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/Git/KFramework/Rho-Calc/./rho.k)) org.kframework.definition.Production(syntax RuleContent ::= K) structural()]|}*)
| (KApply2(Lbl'_LT_'T'_GT_',(varDotVar0_341),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_((KApply2(Lbl'_LT_'send'_GT_',(KApply1(Lbl'_LT_'schan'_GT_',(KApply1(LblQuote,(KApply1(LblReify,(varX_342 :: [])) :: [])) :: [])) :: []),(varDotVar3_343)) :: []),(varDotVar2_344 :: [])) config (-1)) :: [])) :: []),(varDotVar1_345)) :: [])) :: []) when (isTrue (evalisName((varX_342 :: [])) config (-1))) && (true) -> (((KApply2(Lbl'_LT_'T'_GT_',(varDotVar0_341),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_((KApply2(Lbl'_LT_'send'_GT_',(KApply1(Lbl'_LT_'schan'_GT_',(varX_342 :: [])) :: []),(varDotVar3_343)) :: []),(varDotVar2_344 :: [])) config (-1)))) :: []),(varDotVar1_345)) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(`<activity>`(`_ThreadCellBag_`(`<thread>`(`<k>`(`` `Reify`(`Quote`(P))=>P``~>DotVar3)),DotVar1)),DotVar0) requires isProc(P) ensures #token("true","Bool") [UNIQUE_ID(574ab2101356b551355bf257c4105084450f6f6e4bf781e5ed4a2e3a0f4d8730) contentStartColumn(8) contentStartLine(105) org.kframework.attributes.Location(Location(105,8,105,23)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/Git/KFramework/Rho-Calc/./rho.k)) org.kframework.definition.Production(syntax RuleContent ::= K) structural()]|}*)
| (KApply2(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'activity'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(KApply1(LblReify,(KApply1(LblQuote,(varP_346 :: [])) :: [])) :: varDotVar3_347)) :: [])) :: []),(varDotVar1_348 :: [])) config (-1)) :: [])) :: []),(varDotVar0_349)) :: []) when (isTrue (evalisProc((varP_346 :: [])) config (-1))) && (true) -> (((KApply2(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'activity'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(varP_346 :: varDotVar3_347)) :: [])) :: []),(varDotVar1_348 :: [])) config (-1)))) :: []),(varDotVar0_349)) :: [])), (StepFunc step))
(*{| rule `<T>`(DotVar0,`<tuplespace>`(`<sends>`(`_SendCellBag_`(`<send>`(DotVar3,`<msg>`(`` `Quote`(`Reify`(X))=>X``)),DotVar2)),DotVar1)) requires isName(X) ensures #token("true","Bool") [UNIQUE_ID(19066adb637317169e650d248b155f69086766efab47ff8e32dffc272b20a9ad) contentStartColumn(8) contentStartLine(99) org.kframework.attributes.Location(Location(99,8,99,36)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/Git/KFramework/Rho-Calc/./rho.k)) org.kframework.definition.Production(syntax RuleContent ::= K) structural()]|}*)
| (KApply2(Lbl'_LT_'T'_GT_',(varDotVar0_350),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_((KApply2(Lbl'_LT_'send'_GT_',(varDotVar3_351),(KApply1(Lbl'_LT_'msg'_GT_',(KApply1(LblQuote,(KApply1(LblReify,(varX_352 :: [])) :: [])) :: [])) :: [])) :: []),(varDotVar2_353 :: [])) config (-1)) :: [])) :: []),(varDotVar1_354)) :: [])) :: []) when (isTrue (evalisName((varX_352 :: [])) config (-1))) && (true) -> (((KApply2(Lbl'_LT_'T'_GT_',(varDotVar0_350),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_((KApply2(Lbl'_LT_'send'_GT_',(varDotVar3_351),(KApply1(Lbl'_LT_'msg'_GT_',(varX_352 :: [])) :: [])) :: []),(varDotVar2_353 :: [])) config (-1)))) :: []),(varDotVar1_354)) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(`<activity>`(`_ThreadCellBag_`(`` `<thread>`(`<k>`(.K))=>`.ThreadCellBag`(.KList)``,DotVar1)),DotVar0) requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(8236ddfc6eb920764c04e2eff79e625d2e55f8c2f8d792e8b54a894d952518f4) contentStartColumn(8) contentStartLine(90) org.kframework.attributes.Location(Location(90,8,90,45)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/Git/KFramework/Rho-Calc/./rho.k)) org.kframework.definition.Production(syntax RuleContent ::= K) structural()]|}*)
| (KApply2(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'activity'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',([])) :: [])) :: []),(varDotVar1_355 :: [])) config (-1)) :: [])) :: []),(varDotVar0_356)) :: []) -> (((KApply2(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'activity'_GT_',((eval_ThreadCellBag_(((Lazy.force const'Stop'ThreadCellBag)),(varDotVar1_355 :: [])) config (-1)))) :: []),(varDotVar0_356)) :: [])), (StepFunc step))
(*{| rule `<T>`(`<activity>`(`_ThreadCellBag_`(`<thread>`(`<k>`(`` `Rec`(X,Y,P)=>.K``~>DotVar5)),DotVar3)),`<tuplespace>`(DotVar1,`<recs>`(`_RecCellBag_`(`` `.RecCellBag`(.KList)=>`<rec>`(`<rchan>`(X),`<bind>`(Y),`<cont>`(P))``,DotVar2)))) requires `_andBool_`(`_andBool_`(isName(Y),isProc(P)),isName(X)) ensures #token("true","Bool") [UNIQUE_ID(5872370a16ee0743294d5bd6aa8c697b6b42b5cf6089dfffdee465a08c7243d7) contentStartColumn(8) contentStartLine(74) org.kframework.attributes.Location(Location(74,8,79,24)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/Git/KFramework/Rho-Calc/./rho.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (KApply2(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'activity'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(KApply3(LblRec,(varX_357 :: []),(varY_358 :: []),(varP_359 :: [])) :: varDotVar5_360)) :: [])) :: []),(varDotVar3_361 :: [])) config (-1)) :: [])) :: []),(KApply2(Lbl'_LT_'tuplespace'_GT_',(varDotVar1_362),(KApply1(Lbl'_LT_'recs'_GT_',((eval_RecCellBag_(((Lazy.force const'Stop'RecCellBag) :: []),(varDotVar2_363 :: [])) config (-1)) :: [])) :: [])) :: [])) :: []) when (((((isTrue (evalisName((varY_358 :: [])) config (-1)))) && ((isTrue (evalisProc((varP_359 :: [])) config (-1)))))) && ((isTrue (evalisName((varX_357 :: [])) config (-1))))) && (true) -> (((KApply2(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'activity'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(varDotVar5_360)) :: [])) :: []),(varDotVar3_361 :: [])) config (-1)))) :: []),(KApply2(Lbl'_LT_'tuplespace'_GT_',(varDotVar1_362),(KApply1(Lbl'_LT_'recs'_GT_',((eval_RecCellBag_((KApply3(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'rchan'_GT_',(varX_357 :: [])) :: []),(KApply1(Lbl'_LT_'bind'_GT_',(varY_358 :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_359 :: [])) :: [])) :: []),(varDotVar2_363 :: [])) config (-1)))) :: [])) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(`<activity>`(`_ThreadCellBag_`(`<thread>`(`<k>`(`` `Send`(X,P)=>.K``~>DotVar5)),DotVar3)),`<tuplespace>`(`<sends>`(`_SendCellBag_`(`` `.SendCellBag`(.KList)=>`<send>`(`<schan>`(X),`<msg>`(`Quote`(P)))``,DotVar2)),DotVar1)) requires `_andBool_`(isProc(P),isName(X)) ensures #token("true","Bool") [UNIQUE_ID(91366c389c4c3553dd8cce08008ef1ff7164d145ad3b9969d9ae9aaa19bb9647) contentStartColumn(8) contentStartLine(67) org.kframework.attributes.Location(Location(67,8,71,25)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/Git/KFramework/Rho-Calc/./rho.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (KApply2(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'activity'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(KApply2(LblSend,(varX_364 :: []),(varP_365 :: [])) :: varDotVar5_366)) :: [])) :: []),(varDotVar3_367 :: [])) config (-1)) :: [])) :: []),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_(((Lazy.force const'Stop'SendCellBag) :: []),(varDotVar2_368 :: [])) config (-1)) :: [])) :: []),(varDotVar1_369)) :: [])) :: []) when (((isTrue (evalisProc((varP_365 :: [])) config (-1)))) && ((isTrue (evalisName((varX_364 :: [])) config (-1))))) && (true) -> (((KApply2(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'activity'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(varDotVar5_366)) :: [])) :: []),(varDotVar3_367 :: [])) config (-1)))) :: []),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_((KApply2(Lbl'_LT_'send'_GT_',(KApply1(Lbl'_LT_'schan'_GT_',(varX_364 :: [])) :: []),(KApply1(Lbl'_LT_'msg'_GT_',(KApply1(LblQuote,(varP_365 :: [])) :: [])) :: [])) :: []),(varDotVar2_368 :: [])) config (-1)))) :: []),(varDotVar1_369)) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(`<activity>`(`_ThreadCellBag_`(`_ThreadCellBag_`(`_ThreadCellBag_`(`<thread>`(`<k>`(`` `Par`(P1,P2)=>.K``~>DotVar2)),`` `.ThreadCellBag`(.KList)=>`<thread>`(`<k>`(P1))``),`` `.ThreadCellBag`(.KList)=>`<thread>`(`<k>`(P2))``),DotVar1)),DotVar0) requires `_andBool_`(isProc(P1),isProc(P2)) ensures #token("true","Bool") [UNIQUE_ID(83c63754c8ab3accdba0077fbab888af8fc8ad40d00f9310cadc544f56e5a6bd) contentStartColumn(8) contentStartLine(62) org.kframework.attributes.Location(Location(62,8,64,48)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/Git/KFramework/Rho-Calc/./rho.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (KApply2(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'activity'_GT_',((eval_ThreadCellBag_(((eval_ThreadCellBag_(((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(KApply2(LblPar,(varP1_370 :: []),(varP2_371 :: [])) :: varDotVar2_372)) :: [])) :: []),((Lazy.force const'Stop'ThreadCellBag) :: [])) config (-1)) :: []),((Lazy.force const'Stop'ThreadCellBag) :: [])) config (-1)) :: []),(varDotVar1_373 :: [])) config (-1)) :: [])) :: []),(varDotVar0_374)) :: []) when (((isTrue (evalisProc((varP1_370 :: [])) config (-1)))) && ((isTrue (evalisProc((varP2_371 :: [])) config (-1))))) && (true) -> (((KApply2(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'activity'_GT_',((eval_ThreadCellBag_(((eval_ThreadCellBag_(((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(varDotVar2_372)) :: [])) :: []),(KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(varP1_370 :: [])) :: [])) :: [])) config (-1))),(KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(varP2_371 :: [])) :: [])) :: [])) config (-1))),(varDotVar1_373 :: [])) config (-1)))) :: []),(varDotVar0_374)) :: [])), (StepFunc step))
(*{| rule `<T>`(`<activity>`(`_ThreadCellBag_`(`` `.ThreadCellBag`(.KList)=>`<thread>`(`<k>`(`_[_/_]_SUBSTITUTION`(P,Z,Y)))``,DotVar4)),`<tuplespace>`(`<sends>`(`_SendCellBag_`(`` `<send>`(`<schan>`(X),`<msg>`(Z))=>`.SendCellBag`(.KList)``,DotVar2)),`<recs>`(`_RecCellBag_`(`` `<rec>`(`<rchan>`(X),`<bind>`(Y),`<cont>`(P))=>`.RecCellBag`(.KList)``,DotVar3)))) requires `_andBool_`(`_andBool_`(`_andBool_`(isName(Y),isName(Z)),isProc(P)),isName(X)) ensures #token("true","Bool") [UNIQUE_ID(f0b72454b59b73c2a25d2e242ce6bdbe1ba67b4743ead213537124576c92ec52) comm() contentStartColumn(3) contentStartLine(114) org.kframework.attributes.Location(Location(114,3,123,49)) org.kframework.attributes.Source(Source(/home/isaac/Documents/Isaac/KFramework/Git/KFramework/Rho-Calc/./rho.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (KApply2(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'activity'_GT_',((eval_ThreadCellBag_(((Lazy.force const'Stop'ThreadCellBag) :: []),(varDotVar4_375 :: [])) config (-1)) :: [])) :: []),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_((KApply2(Lbl'_LT_'send'_GT_',(KApply1(Lbl'_LT_'schan'_GT_',(varX_376 :: [])) :: []),(KApply1(Lbl'_LT_'msg'_GT_',(varZ_377 :: [])) :: [])) :: []),(varDotVar2_378 :: [])) config (-1)) :: [])) :: []),(KApply1(Lbl'_LT_'recs'_GT_',((eval_RecCellBag_((KApply3(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'rchan'_GT_',(varX_379 :: [])) :: []),(KApply1(Lbl'_LT_'bind'_GT_',(varY_380 :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_381 :: [])) :: [])) :: []),(varDotVar3_382 :: [])) config (-1)) :: [])) :: [])) :: [])) :: []) when (((((((isTrue (evalisName((varY_380 :: [])) config (-1)))) && ((isTrue (evalisName((varZ_377 :: [])) config (-1)))))) && ((isTrue (evalisProc((varP_381 :: [])) config (-1)))))) && ((isTrue (evalisName((varX_379 :: [])) config (-1))))) && (((compare_kitem varX_379 varX_376) = 0) && true) -> (((KApply2(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'activity'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',((eval_'LSqB'_'Slsh'_'RSqB'_SUBSTITUTION((varP_381 :: []),(varZ_377 :: []),(varY_380 :: [])) config (-1)))) :: [])) :: []),(varDotVar4_375 :: [])) config (-1)))) :: []),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_(((Lazy.force const'Stop'SendCellBag)),(varDotVar2_378 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'recs'_GT_',((eval_RecCellBag_(((Lazy.force const'Stop'RecCellBag)),(varDotVar3_382 :: [])) config (-1)))) :: [])) :: [])) :: [])), (StepFunc step))
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
