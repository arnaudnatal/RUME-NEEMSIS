*-------------------------
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*-----
*Family composition
*-----
*-------------------------

********** Clear
clear all
macro drop _all

********** Path to working directory directory
global directory = "C:\Users\Arnaud\Documents\Dropbox\RUME-NEEMSIS\Data\Construction"
cd"$directory"

********** Database names
global data = "RUME-HH"

********** Scheme
set scheme plotplain_v2
grstyle init
grstyle set plain, box nogrid

********** Deflate
*https://data.worldbank.org/indicator/FP.CPI.TOTL?locations=IN
*(100/158) if year==2016
*(100/184) if year==2020









****************************************
* Family composition
****************************************
use"$data", clear


*** To keep
keep HHID2010 INDID2010 name age sex relationshiptohead livinghome
ta livinghome
*Dans le doute je garde tout le monde car je ne suis pas sûr de comprendre à 100% cette question.
drop livinghome


*** Corr
merge m:m HHID2010 using "ODRIIS-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
merge m:m HHID_panel INDID2010 using "ODRIIS-Indiv_wide", keepusing(INDID_panel agecorr2010 sex2010 relationshiptohead2010 age2010)
keep if _merge==3
drop _merge
order HHID_panel INDID_panel HHID2010 INDID2010

* V1
ta sex sex2010
drop sex2010

* V2
ta relationshiptohead relationshiptohead2010
drop relationshiptohead2010

* V3
destring age2010, replace
gen test=age-age2010
ta test
drop test age2010

* V4
destring agecorr2010, replace
gen test=age-agecorr2010
ta test
drop test age
rename agecorr2010 age


*** Nb male/female
fre sex
gen male=0
replace male=1 if sex==1

gen female=0
replace female=1 if sex==2


*** Nb over age
egen age_group=cut(age), at(0 14 18 25 30 35 40 50 60 70 80 100)
ta age_group
ta age age_group
ta age_group, gen(agegroup_)
rename agegroup_1 agegrp_0_13
rename agegroup_2 agrgrp_14_17
rename agegroup_3 agegrp_18_24
rename agegroup_4 agrgrp_25_29
rename agegroup_5 agrgrp_30_34
rename agegroup_6 agegrp_35_39
rename agegroup_7 agegrp_40_49
rename agegroup_8 agegrp_50_59
rename agegroup_9 agegrp_60_69
rename agegroup_10 agegrp_70_79
rename agegroup_11 agegrp_80_100


*** Age and sex
ta age_group sex
foreach x in agegrp_0_13 agrgrp_14_17 agegrp_18_24 agrgrp_25_29 agrgrp_30_34 agegrp_35_39 agegrp_40_49 agegrp_50_59 agegrp_60_69 agegrp_70_79 agegrp_80_100 {
gen male_`x'=0
gen female_`x'=0
}

foreach x in agegrp_0_13 agrgrp_14_17 agegrp_18_24 agrgrp_25_29 agrgrp_30_34 agegrp_35_39 agegrp_40_49 agegrp_50_59 agegrp_60_69 agegrp_70_79 agegrp_80_100 {
replace male_`x'=1 if male==1 & `x'==1
replace female_`x'=1 if female==1 & `x'==1 
}


*** Relationship to head
ta relationshiptohead
fre relationshiptohead
ta relationshiptohead, gen(relation_)
rename relation_1 relation_head
rename relation_2 relation_wife
rename relation_3 relation_mother
rename relation_4 relation_father
rename relation_5 relation_son
rename relation_6 relation_daughter
rename relation_7 relation_daughterinlaw
rename relation_8 relation_soninlaw
rename relation_9 relation_sister
rename relation_10 relation_motherinlaw
rename relation_11 relation_fatherinlaw
rename relation_12 relation_brotherelder
rename relation_13 relation_brotheryounger
rename relation_14 relation_grandchildren
rename relation_15 relation_other


*** HH level
global var male female agegrp_0_13 agrgrp_14_17 agegrp_18_24 agrgrp_25_29 agrgrp_30_34 agegrp_35_39 agegrp_40_49 agegrp_50_59 agegrp_60_69 agegrp_70_79 agegrp_80_100 male_agegrp_0_13 female_agegrp_0_13 male_agrgrp_14_17 female_agrgrp_14_17 male_agegrp_18_24 female_agegrp_18_24 male_agrgrp_25_29 female_agrgrp_25_29 male_agrgrp_30_34 female_agrgrp_30_34 male_agegrp_35_39 female_agegrp_35_39 male_agegrp_40_49 female_agegrp_40_49 male_agegrp_50_59 female_agegrp_50_59 male_agegrp_60_69 female_agegrp_60_69 male_agegrp_70_79 female_agegrp_70_79 male_agegrp_80_100 female_agegrp_80_100 relation_head relation_wife relation_mother relation_father relation_son relation_daughter relation_daughterinlaw relation_soninlaw relation_sister relation_motherinlaw relation_fatherinlaw relation_brotherelder relation_brotheryounger relation_grandchildren relation_other

foreach x in $var {
bysort HHID2010: egen _temp`x'=sum(`x')
drop `x'
rename _temp`x' `x'
}


*** HH size
bysort HHID2010: egen HHsize=sum(1)

keep HHID2010 $var HHsize
duplicates drop


*** Clean
rename male nbmale
rename female nbfemale


save"_temp\RUME-family1", replace
****************************************
* END






****************************************
* Type of family
****************************************
use"$data", clear


*** To keep
keep HHID2010 INDID2010 name age sex relationshiptohead livinghome
ta livinghome
sort HHID2010 INDID2010


*** Reshape
bysort HHID2010 (INDID2010): gen n=_n
rename INDID2010 INDID
reshape wide INDID name age sex relationshiptohead livinghome, i(HHID2010) j(n)

forvalues i=1/9 {
decode relationshiptohead`i', gen(relation`i')
}

*** Concat
egen family=concat(relation1 relation2 relation3 relation4 relation5 relation6 relation7 relation8 relation9), p(" / ")
drop relation1 relation2 relation3 relation4 relation5 relation6 relation7 relation8 relation9

forvalues i=1/16{
replace family=substr(family, 1, strlen(family)-1) if substr(family,strlen(family),1)=="/"
replace family=substr(family, 1, strlen(family)-1) if substr(family,strlen(family),1)==" "
}

*** Display all choices
preserve
duplicates drop family, force
sort family
*list family, clean noobs
restore

*** Categories
gen typeoffamily=""

replace typeoffamily="joint-stem" if family=="Head / Father / Mother / Wife / Brother younger / Brother younger / Other / Sister"
replace typeoffamily="joint-stem" if family=="Head / Wife / Brother younger / Other / Mother / Father-in-law / Other / Sister / Sister"
replace typeoffamily="joint-stem" if family=="Head / Wife / Mother / Brother elder"
replace typeoffamily="joint-stem" if family=="Head / Wife / Mother / Brother younger / Grand children / Grand children / Brother younger"
replace typeoffamily="joint-stem" if family=="Head / Wife / Son / Son / Head / Wife"
replace typeoffamily="stem" if family=="Father / Mother / Head / Wife / Daughter / Daughter"
replace typeoffamily="nuclear" if family=="Head / Daughter / Daughter"
replace typeoffamily="nuclear" if family=="Head / Daughter / Daughter / Daughter / Son / Son"
replace typeoffamily="nuclear" if family=="Head / Daughter / Daughter / Son"
replace typeoffamily="nuclear" if family=="Head / Daughter / Daughter / Son / Daughter"
replace typeoffamily="nuclear" if family=="Head / Daughter / Son"
replace typeoffamily="stem" if family=="Head / Daughter / Son / Daughter-in-law / Son / Son / Grand children"
replace typeoffamily="stem" if family=="Head / Daughter / Son / Son / Mother-in-law"
replace typeoffamily="nuclear" if family=="Head / Daughter / Son / Son / Son"
replace typeoffamily="stem" if family=="Head / Daughter / Son-in-law / Grand children / Grand children"
replace typeoffamily="stem" if family=="Head / Father / Wife / Daughter / Son / Sister"
replace typeoffamily="nuclear" if family=="Head / Son"
replace typeoffamily="nuclear" if family=="Head / Son / Daughter"
replace typeoffamily="nuclear" if family=="Head / Son / Daughter / Son"
replace typeoffamily="stem" if family=="Head / Son / Daughter-in-law / Grand children"
replace typeoffamily="stem" if family=="Head / Son / Daughter-in-law / Grand children / Grand children"
replace typeoffamily="stem" if family=="Head / Son / Daughter-in-law / Grand children / Grand children / Grand children"
replace typeoffamily="nuclear" if family=="Head / Son / Son"
replace typeoffamily="nuclear" if family=="Head / Son / Son / Daughter"
replace typeoffamily="nuclear" if family=="Head / Son / Son / Daughter / Daughter"
replace typeoffamily="nuclear" if family=="Head / Son / Son / Daughter / Son"
replace typeoffamily="nuclear" if family=="Head / Son / Son / Son / Daughter"
replace typeoffamily="stem" if family=="Head / Son / Son / Son / Daughter-in-law / Daughter-in-law / Daughter-in-law"
replace typeoffamily="stem" if family=="Head / Son / Son / Son / Daughter-in-law / Grand children"
replace typeoffamily="stem" if family=="Head / Son / Son / Son / Daughter-in-law / Grand children / Grand children"
replace typeoffamily="stem" if family=="Head / Son-in-law / Daughter / Grand children / Grand children"
replace typeoffamily="nuclear" if family=="Head / Wife"
replace typeoffamily="nuclear" if family=="Head / Wife / Daughter"
replace typeoffamily="nuclear" if family=="Head / Wife / Daughter / Daughter"
replace typeoffamily="nuclear" if family=="Head / Wife / Daughter / Daughter / Daughter"
replace typeoffamily="nuclear" if family=="Head / Wife / Daughter / Daughter / Daughter / Daughter"
replace typeoffamily="nuclear" if family=="Head / Wife / Daughter / Daughter / Daughter / Daughter / Daughter"
replace typeoffamily="nuclear" if family=="Head / Wife / Daughter / Daughter / Daughter / Daughter / Son"
replace typeoffamily="nuclear" if family=="Head / Wife / Daughter / Daughter / Daughter / Son"
replace typeoffamily="stem" if family=="Head / Wife / Daughter / Daughter / Father"
replace typeoffamily="nuclear" if family=="Head / Wife / Daughter / Daughter / Son"
replace typeoffamily="nuclear" if family=="Head / Wife / Daughter / Daughter / Son / Daughter"
replace typeoffamily="nuclear" if family=="Head / Wife / Daughter / Daughter / Son / Daughter / Son"
replace typeoffamily="stem" if family=="Head / Wife / Daughter / Daughter / Son / Mother"
replace typeoffamily="nuclear" if family=="Head / Wife / Daughter / Daughter / Son / Son"
replace typeoffamily="stem" if family=="Head / Wife / Daughter / Mother"
replace typeoffamily="stem" if family=="Head / Wife / Daughter / Mother / Daughter"
replace typeoffamily="nuclear" if family=="Head / Wife / Daughter / Son"
replace typeoffamily="nuclear" if family=="Head / Wife / Daughter / Son / Daughter"
replace typeoffamily="stem" if family=="Head / Wife / Daughter / Son / Daughter / Daughter / Father"
replace typeoffamily="stem" if family=="Head / Wife / Daughter / Son / Daughter / Daughter / Mother"
replace typeoffamily="stem" if family=="Head / Wife / Daughter / Son / Daughter / Mother"
replace typeoffamily="stem" if family=="Head / Wife / Daughter / Son / Father"
replace typeoffamily="stem" if family=="Head / Wife / Daughter / Son / Father / Mother"
replace typeoffamily="stem" if family=="Head / Wife / Daughter / Son / Mother"
replace typeoffamily="nuclear" if family=="Head / Wife / Daughter / Son / Son"
replace typeoffamily="nuclear" if family=="Head / Wife / Daughter / Son / Son / Daughter"
replace typeoffamily="nuclear" if family=="Head / Wife / Daughter / Son / Son / Son"
replace typeoffamily="stem" if family=="Head / Wife / Father / Mother"
replace typeoffamily="stem" if family=="Head / Wife / Father-in-law / Mother-in-law / Son / Daughter / Son"
replace typeoffamily="stem" if family=="Head / Wife / Grand children"
replace typeoffamily="stem" if family=="Head / Wife / Mother"
replace typeoffamily="nuclear" if family=="Head / Wife / Son"
replace typeoffamily="nuclear" if family=="Head / Wife / Son / Daughter"
replace typeoffamily="stem" if family=="Head / Wife / Son / Daughter / Brother younger / Brother younger / Mother / Father"
replace typeoffamily="nuclear" if family=="Head / Wife / Son / Daughter / Daughter"
replace typeoffamily="stem" if family=="Head / Wife / Son / Daughter / Daughter / Mother"
replace typeoffamily="nuclear" if family=="Head / Wife / Son / Daughter / Daughter / Son"
replace typeoffamily="stem" if family=="Head / Wife / Son / Daughter / Father / Mother / Mother-in-law"
replace typeoffamily="nuclear" if family=="Head / Wife / Son / Daughter / Son"
replace typeoffamily="stem" if family=="Head / Wife / Son / Daughter / Son / Mother"
replace typeoffamily="stem" if family=="Head / Wife / Son / Daughter / Son / Mother-in-law"
replace typeoffamily="nuclear" if family=="Head / Wife / Son / Daughter / Son / Son"
replace typeoffamily="stem" if family=="Head / Wife / Son / Daughter-in-law"
replace typeoffamily="stem" if family=="Head / Wife / Son / Daughter-in-law / Daughter / Grand children / Grand children / Grand children / Grand children"
replace typeoffamily="stem" if family=="Head / Wife / Son / Daughter-in-law / Grand children"
replace typeoffamily="stem" if family=="Head / Wife / Son / Daughter-in-law / Grand children / Daughter"
replace typeoffamily="stem" if family=="Head / Wife / Son / Daughter-in-law / Grand children / Grand children"
replace typeoffamily="stem" if family=="Head / Wife / Son / Daughter-in-law / Grand children / Grand children / Grand children"
replace typeoffamily="stem" if family=="Head / Wife / Son / Daughter-in-law / Grand children / Grand children / Son / Son"
replace typeoffamily="stem" if family=="Head / Wife / Son / Daughter-in-law / Grand children / Mother"
replace typeoffamily="stem" if family=="Head / Wife / Son / Daughter-in-law / Grand children / Son"
replace typeoffamily="joint-stem" if family=="Head / Wife / Son / Daughter-in-law / Grand children / Son / Daughter-in-law"
replace typeoffamily="stem" if family=="Head / Wife / Son / Daughter-in-law / Other"
replace typeoffamily="stem" if family=="Head / Wife / Son / Daughter-in-law / Son"
replace typeoffamily="stem" if family=="Head / Wife / Son / Daughter-in-law / Son / Daughter / Son / Daughter"
replace typeoffamily="joint-stem" if family=="Head / Wife / Son / Daughter-in-law / Son / Daughter-in-law / Grand children / Grand children"
replace typeoffamily="stem" if family=="Head / Wife / Son / Daughter-in-law / Son / Grand children"
replace typeoffamily="stem" if family=="Head / Wife / Son / Daughter-in-law / Son / Son / Daughter / Son"
replace typeoffamily="stem" if family=="Head / Wife / Son / Father"
replace typeoffamily="stem" if family=="Head / Wife / Son / Mother"
replace typeoffamily="nuclear" if family=="Head / Wife / Son / Son"
replace typeoffamily="nuclear" if family=="Head / Wife / Son / Son / Daughter"
replace typeoffamily="nuclear" if family=="Head / Wife / Son / Son / Daughter / Daughter"
replace typeoffamily="stem" if family=="Head / Wife / Son / Son / Daughter / Daughter / Mother"
replace typeoffamily="stem" if family=="Head / Wife / Son / Son / Daughter-in-law"
replace typeoffamily="joint-stem" if family=="Head / Wife / Son / Son / Daughter-in-law / Son / Daughter-in-law"
replace typeoffamily="stem" if family=="Head / Wife / Son / Son / Grand children"
replace typeoffamily="stem" if family=="Head / Wife / Son / Son / Mother"
replace typeoffamily="stem" if family=="Head / Wife / Son / Son / Mother-in-law"
replace typeoffamily="nuclear" if family=="Head / Wife / Son / Son / Son"
replace typeoffamily="nuclear" if family=="Head / Wife / Son / Son / Son / Daughter / Daughter"
replace typeoffamily="nuclear" if family=="Head / Wife / Son / Son / Son / Daughter / Son"
replace typeoffamily="stem" if family=="Head / Wife / Son / Son / Son / Daughter-in-law"
replace typeoffamily="stem" if family=="Head / Wife / Son / Son / Son / Daughter-in-law / Grand children"
replace typeoffamily="stem" if family=="Head / Wife / Son / Son / Son / Mother"
replace typeoffamily="nuclear" if family=="Head / Wife / Son / Son / Son / Son"
replace typeoffamily="stem" if family=="Head / Wife / Son / Son / Son / Son / Daughter / Father"
replace typeoffamily="stem" if family=="Head / Wife / Son-in-law / Daughter / Grand children"
replace typeoffamily="stem" if family=="Head / Wife / Son-in-law / Daughter / Son / Grand children / Grand children"
replace typeoffamily="nuclear" if family=="Head / Wife / Wife / Son"


*** Pb
ta typeoffamily
gen pb=0
replace pb=1 if family=="Head / Father / Mother / Wife / Brother younger / Brother younger / Other / Sister"
replace pb=1 if family=="Head / Wife / Brother younger / Other / Mother / Father-in-law / Other / Sister / Sister"
replace pb=1 if family=="Head / Wife / Mother / Brother elder"
replace pb=1 if family=="Head / Wife / Mother / Brother younger / Grand children / Grand children / Brother younger"
replace pb=1 if family=="Head / Wife / Son / Son / Head / Wife"
replace pb=1 if family=="Head / Wife / Grand children"
replace pb=1 if family=="Head / Wife / Son / Daughter-in-law / Other"
replace pb=1 if family=="Head / Wife / Wife / Son"

sort HHID2010
order HHID2010 family
*br if pb==1
gen remark=""

replace typeoffamily="joint-stem" if HHID2010=="ANDMTP324" 
replace pb=. if HHID2010=="ANDMTP324"

replace typeoffamily="joint-stem" if HHID2010=="ANTMTP319"
replace pb=. if HHID2010=="ANTMTP319"

replace typeoffamily="nuclear" if HHID2010=="PSKOR201"
replace remark="polygamous" if HHID2010=="PSKOR201"
replace pb=. if HHID2010=="PSKOR201"

replace typeoffamily="nuclear" if HHID2010=="RAKARU259"
replace remark="couple + grandchildren" if HHID2010=="RAKARU259"
replace pb=. if HHID2010=="RAKARU259"

replace typeoffamily="stem" if HHID2010=="RAMPO24"
replace pb=. if HHID2010=="RAMPO24"

replace typeoffamily="stem" if HHID2010=="SISEM107"
replace pb=. if HHID2010=="SISEM107"

replace typeoffamily="stem" if HHID2010=="SISEM109"
replace pb=. if HHID2010=="SISEM109"

replace typeoffamily="stem" if HHID2010=="VENGP165"
replace pb=. if HHID2010=="VENGP165"

drop pb

keep HHID2010 family typeoffamily remark
ta typeoffamily

save"_temp\RUME-family2", replace
****************************************
* END







****************************************
* Head characteristics
****************************************
use"$data", clear

keep if relationshiptohead==1
duplicates tag HHID2010, gen(tag)
ta tag
*br HHID2010 INDID2010 name age sex jatis caste if tag!=0
drop if HHID2010=="VENGP165" & INDID2010=="F5"
drop tag

keep HHID2010 INDID2010 name age sex relationshiptohead
gen dummyhead=1


*** Add occupation
merge 1:1 HHID2010 INDID2010 using "outcomes/RUME-occup_indiv", keepusing(dummyworkedpastyear working_pop mainocc_profession_indiv mainocc_occupation_indiv mainocc_sector_indiv mainocc_annualincome_indiv mainocc_occupationname_indiv annualincome_indiv nboccupation_indiv)
drop if _merge==2
drop _merge

rename mainocc_profession_indiv mocc_profession
rename mainocc_occupation_indiv mocc_occupation
rename mainocc_sector_indiv mocc_sector
rename mainocc_annualincome_indiv mocc_annualincome
rename mainocc_occupationname_indiv mocc_occupationname
rename annualincome_indiv annualincome
rename nboccupation_indiv nboccupation

*** Add education
merge 1:1 HHID2010 INDID2010 using "outcomes/RUME-education"
drop if _merge==2
drop _merge


*** Rename
foreach x in INDID2010 name sex relationshiptohead age dummyhead dummyworkedpastyear working_pop mocc_profession mocc_occupation mocc_sector mocc_annualincome mocc_occupationname annualincome nboccupation edulevel {
rename `x' head_`x'
}

save"_temp\RUME-head", replace
****************************************
* END












****************************************
* Merge all
****************************************
use"$data", clear

keep HHID2010 caste jatis
duplicates drop

merge 1:1 HHID2010 using "_temp\RUME-family1"
drop _merge

merge 1:1 HHID2010 using "_temp\RUME-family2"
drop _merge

merge 1:1 HHID2010 using "_temp\RUME-head"
drop _merge

save"outcomes\RUME-family", replace
****************************************
* END