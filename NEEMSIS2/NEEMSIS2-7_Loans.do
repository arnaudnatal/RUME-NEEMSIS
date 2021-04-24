/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
03/03/21
-----
TITLE: PANEL pour dette cog

description: 	Réunir tous les prêts dans la même base
-------------------------
*/



****************************************
* INITIALIZATION
****************************************
clear all
macro drop _all
cls
********** Path to folder "data" folder.
global directory = "D:\Documents\_Thesis\_DATA\NEEMSIS2\DATA\APPEND"
cd "$directory\CLEAN"

********** SSC to install
*ssc install dropmiss, replace
*ssc install fre, replace

****************************************
* END










****************************************
* MERGING
****************************************
*1. Nettoyage de la base prêts
use "NEEMSIS_APPEND-detailsloanbyborrower.dta", clear
split parent_key, p(/)
drop parent_key parent_key2 parent_key3
rename parent_key1 parent_key
	drop if parent_key=="uuid:2cca6f5f-3ecb-4088-b73f-1ecd9586690d"
	drop if parent_key=="uuid:1ea7523b-cad1-44da-9afa-8c4f96189433"
	drop if parent_key=="uuid:b283cb62-a316-418a-80b5-b8fe86585ef8"
	drop if parent_key=="uuid:5a19b036-4004-4c71-9e2a-b4efd3572cf3"
	drop if parent_key=="uuid:7fc65842-447f-4b1d-806a-863556d03ed3"
	drop if parent_key=="uuid:9b931ac2-ef49-43e9-90cd-33ae0bf1928f"
save"NEEMSIS2-loans.dta", replace


*2. Merge: borrower with loan to have indiv details with loan
use "NEEMSIS_APPEND-hhquestionnaire-financialpracticesgroup-loans-loansbyborrower.dta", clear
keep if nbloansbyborrower!=.
rename setofdetailsloanbyborrower setofdetailsloanbyborrower_o
rename setofloansbyborrower setofdetailsloanbyborrower
sort parent_key borrowerid
merge 1:m setofdetailsloanbyborrower using "NEEMSIS2-loans.dta"
sort _merge
drop _merge
fre loansettled  // 428
*drop if loansettled==1
tab loanbalance, m  // ok 428
save "NEEMSIS2-loans_v2.dta", replace


*3. Merge: second with main loans 
use "NEEMSIS2-loans_v2.dta", clear
fre loanlender
destring borrowerid, replace  
destring loanid, replace
gen mainloanid=.
replace	mainloanid =	1	if 	borrowerid ==	1	&	loanid ==	1
replace	mainloanid =	2	if 	borrowerid ==	1	&	loanid ==	2
replace	mainloanid =	3	if 	borrowerid ==	1	&	loanid ==	3
replace	mainloanid =	4	if 	borrowerid ==	1	&	loanid ==	4
replace	mainloanid =	5	if 	borrowerid ==	1	&	loanid ==	5
replace	mainloanid =	6	if 	borrowerid ==	1	&	loanid ==	6
replace	mainloanid =	7	if 	borrowerid ==	1	&	loanid ==	7
replace	mainloanid =	8	if 	borrowerid ==	1	&	loanid ==	8
replace	mainloanid =	9	if 	borrowerid ==	2	&	loanid ==	1
replace	mainloanid =	10	if 	borrowerid ==	2	&	loanid ==	2
replace	mainloanid =	11	if 	borrowerid ==	2	&	loanid ==	3
replace	mainloanid =	12	if 	borrowerid ==	2	&	loanid ==	4
replace	mainloanid =	13	if 	borrowerid ==	2	&	loanid ==	5
replace	mainloanid =	14	if 	borrowerid ==	2	&	loanid ==	6
replace	mainloanid =	15	if 	borrowerid ==	2	&	loanid ==	7
replace	mainloanid =	16	if 	borrowerid ==	2	&	loanid ==	8
replace	mainloanid =	17	if 	borrowerid ==	3	&	loanid ==	1
replace	mainloanid =	18	if 	borrowerid ==	3	&	loanid ==	2
replace	mainloanid =	19	if 	borrowerid ==	3	&	loanid ==	3
replace	mainloanid =	20	if 	borrowerid ==	3	&	loanid ==	4
replace	mainloanid =	21	if 	borrowerid ==	3	&	loanid ==	5
replace	mainloanid =	22	if 	borrowerid ==	3	&	loanid ==	6
replace	mainloanid =	23	if 	borrowerid ==	3	&	loanid ==	7
replace	mainloanid =	24	if 	borrowerid ==	3	&	loanid ==	8
replace	mainloanid =	25	if 	borrowerid ==	4	&	loanid ==	1
replace	mainloanid =	26	if 	borrowerid ==	4	&	loanid ==	2
replace	mainloanid =	27	if 	borrowerid ==	4	&	loanid ==	3
replace	mainloanid =	28	if 	borrowerid ==	4	&	loanid ==	4
replace	mainloanid =	29	if 	borrowerid ==	4	&	loanid ==	5
replace	mainloanid =	30	if 	borrowerid ==	4	&	loanid ==	6
replace	mainloanid =	31	if 	borrowerid ==	4	&	loanid ==	7
replace	mainloanid =	32	if 	borrowerid ==	4	&	loanid ==	8
replace	mainloanid =	33	if 	borrowerid ==	5	&	loanid ==	1
replace	mainloanid =	34	if 	borrowerid ==	5	&	loanid ==	2
replace	mainloanid =	35	if 	borrowerid ==	5	&	loanid ==	3
replace	mainloanid =	36	if 	borrowerid ==	5	&	loanid ==	4
replace	mainloanid =	37	if 	borrowerid ==	5	&	loanid ==	5
replace	mainloanid =	38	if 	borrowerid ==	5	&	loanid ==	6
replace	mainloanid =	39	if 	borrowerid ==	5	&	loanid ==	7
replace	mainloanid =	40	if 	borrowerid ==	5	&	loanid ==	8
replace	mainloanid =	41	if 	borrowerid ==	6	&	loanid ==	1
replace	mainloanid =	42	if 	borrowerid ==	6	&	loanid ==	2
replace	mainloanid =	43	if 	borrowerid ==	6	&	loanid ==	3
replace	mainloanid =	44	if 	borrowerid ==	6	&	loanid ==	4
replace	mainloanid =	45	if 	borrowerid ==	6	&	loanid ==	5
replace	mainloanid =	46	if 	borrowerid ==	6	&	loanid ==	6
replace	mainloanid =	47	if 	borrowerid ==	6	&	loanid ==	7
replace	mainloanid =	48	if 	borrowerid ==	6	&	loanid ==	8
replace	mainloanid =	49	if 	borrowerid ==	7	&	loanid ==	1
replace	mainloanid =	50	if 	borrowerid ==	7	&	loanid ==	2
replace	mainloanid =	51	if 	borrowerid ==	7	&	loanid ==	3
replace	mainloanid =	52	if 	borrowerid ==	7	&	loanid ==	4
replace	mainloanid =	53	if 	borrowerid ==	7	&	loanid ==	5
replace	mainloanid =	54	if 	borrowerid ==	7	&	loanid ==	6
replace	mainloanid =	55	if 	borrowerid ==	7	&	loanid ==	7
replace	mainloanid =	56	if 	borrowerid ==	7	&	loanid ==	8
replace	mainloanid =	57	if 	borrowerid ==	15	&	loanid ==	1
replace	mainloanid =	58	if 	borrowerid ==	15	&	loanid ==	2
replace	mainloanid =	59	if 	borrowerid ==	15	&	loanid ==	3
replace	mainloanid =	60	if 	borrowerid ==	15	&	loanid ==	4
replace	mainloanid =	61	if 	borrowerid ==	15	&	loanid ==	5
replace	mainloanid =	62	if 	borrowerid ==	15	&	loanid ==	6
replace	mainloanid =	63	if 	borrowerid ==	15	&	loanid ==	7
replace	mainloanid =	64	if 	borrowerid ==	15	&	loanid ==	8
replace	mainloanid =	65	if 	borrowerid ==	16	&	loanid ==	1
replace	mainloanid =	66	if 	borrowerid ==	16	&	loanid ==	2
replace	mainloanid =	67	if 	borrowerid ==	16	&	loanid ==	3
replace	mainloanid =	68	if 	borrowerid ==	16	&	loanid ==	4
replace	mainloanid =	69	if 	borrowerid ==	16	&	loanid ==	5
replace	mainloanid =	70	if 	borrowerid ==	16	&	loanid ==	6
replace	mainloanid =	71	if 	borrowerid ==	16	&	loanid ==	7
replace	mainloanid =	72	if 	borrowerid ==	16	&	loanid ==	8
replace	mainloanid =	73	if 	borrowerid ==	17	&	loanid ==	1
replace	mainloanid =	74	if 	borrowerid ==	17	&	loanid ==	2
replace	mainloanid =	75	if 	borrowerid ==	17	&	loanid ==	3
replace	mainloanid =	76	if 	borrowerid ==	17	&	loanid ==	4
replace	mainloanid =	77	if 	borrowerid ==	17	&	loanid ==	5
replace	mainloanid =	78	if 	borrowerid ==	17	&	loanid ==	6
replace	mainloanid =	79	if 	borrowerid ==	17	&	loanid ==	7
replace	mainloanid =	80	if 	borrowerid ==	17	&	loanid ==	8
tostring mainloanid, replace
tab loanbalance, m
merge m:1 parent_key mainloanid using "NEEMSIS_APPEND-hhquestionnaire-financialpracticesgroup-loans-mainloans.dta"
rename _merge merge_mainloans
rename borrowerid INDID
fre loansettled  // 428
*drop if loansettled==1
*drop if loanamount==.
tab loanbalance, m  // 428 ok
gen loan_database="FINANCE"

tab loanreasongiven
tab loanreasongiven2 if loanreasongiven==.
fre loanreasongiven2
tab loanotherreasongiven if loanreasongiven==. & loanreasongivenlabel=="Other"

replace loanreasongiven=6 if loanotherreasongiven=="Auto perches"
replace loanreasongiven=2 if loanotherreasongiven=="Baby shower"
replace loanreasongiven=6 if loanotherreasongiven=="Bike perches"
replace loanreasongiven=2 if loanotherreasongiven=="Bike purchase"
replace loanreasongiven=2 if loanotherreasongiven=="Buying Auto"
replace loanreasongiven=2 if loanotherreasongiven=="Buying auto"
replace loanreasongiven=2 if loanotherreasongiven=="Buying bike"
replace loanreasongiven=2 if loanotherreasongiven=="Buying motor"
replace loanreasongiven=2 if loanotherreasongiven=="Buying phone"
replace loanreasongiven=1 if loanotherreasongiven=="Buying tractor"
replace loanreasongiven=5 if loanotherreasongiven=="Buying tv"
replace loanreasongiven=5 if loanotherreasongiven=="Buying washing machine"
replace loanreasongiven=2 if loanotherreasongiven=="Car purchase"
replace loanreasongiven=2 if loanotherreasongiven=="Cell phone due"
replace loanreasongiven=1 if loanotherreasongiven=="Cow purchase"
replace loanreasongiven=1 if loanotherreasongiven=="Crop loan"
replace loanreasongiven=6 if loanotherreasongiven=="Davalap shop"
replace loanreasongiven=6 if loanotherreasongiven=="Develap shop"
replace loanreasongiven=6 if loanotherreasongiven=="Develop shop"
replace loanreasongiven=6 if loanotherreasongiven=="Developed by a shop"
replace loanreasongiven=6 if loanotherreasongiven=="Developed shop"
replace loanreasongiven=8 if loanotherreasongiven=="Engagement"
replace loanreasongiven=5 if loanotherreasongiven=="Exchange of TATA a/c"
replace loanreasongiven=6 if loanotherreasongiven=="Groceries in shop"
replace loanreasongiven=6 if loanotherreasongiven=="Grocery for Rs.1000"
replace loanreasongiven=6 if loanotherreasongiven=="Grocery from uvarani shop for Rs.1000"
replace loanreasongiven=6 if loanotherreasongiven=="Hotel development"
replace loanreasongiven=5 if loanotherreasongiven=="House  construction work"
replace loanreasongiven=5 if loanotherreasongiven=="House built"
replace loanreasongiven=5 if loanotherreasongiven=="House construction"
replace loanreasongiven=5 if loanotherreasongiven=="Housing loan"
replace loanreasongiven=6 if loanotherreasongiven=="Invest in a work"
replace loanreasongiven=6 if loanotherreasongiven=="Land perches"
replace loanreasongiven=2 if loanotherreasongiven=="Milk expenses"
replace loanreasongiven=2 if loanotherreasongiven=="Mobile deu"
replace loanreasongiven=2 if loanotherreasongiven=="Mobile loan"
replace loanreasongiven=5 if loanotherreasongiven=="Purchase TATA ac"
replace loanreasongiven=7 if loanotherreasongiven=="Recover jewelry"
replace loanreasongiven=7 if loanotherreasongiven=="Renewal gold"
replace loanreasongiven=6 if loanotherreasongiven=="School van perches"
replace loanreasongiven=6 if loanotherreasongiven=="Scooter perches"
replace loanreasongiven=6 if loanotherreasongiven=="Shop development"
replace loanreasongiven=5 if loanotherreasongiven=="TATA a/c purchase"
replace loanreasongiven=5 if loanotherreasongiven=="Tata AC purchase"
replace loanreasongiven=6 if loanotherreasongiven=="To buy a Grocery"
replace loanreasongiven=1 if loanotherreasongiven=="To buy a cow"
replace loanreasongiven=7 if loanotherreasongiven=="To buy a new jewel"
replace loanreasongiven=2 if loanotherreasongiven=="To buy auto"
replace loanreasongiven=1 if loanotherreasongiven=="To buy land"
replace loanreasongiven=6 if loanotherreasongiven=="To buy load carrier"
replace loanreasongiven=6 if loanotherreasongiven=="To buy new lorry"
replace loanreasongiven=2 if loanotherreasongiven=="To buy two wheeler"
replace loanreasongiven=1 if loanotherreasongiven=="Tractor purchase"
replace loanreasongiven=2 if loanotherreasongiven=="Two wheeler loan"
replace loanreasongiven=6 if loanotherreasongiven=="Van perches"
tab loanreasongiven, m
sort loanreasongiven
label define lenders 1"Well-know people" 2"Relatives" 3"Friend" 4"Employer" 5"Maistry" 6"Colleague" 7"Pawnbroker" 8"Shop keeper" 9"Microcredit: individual loan" 10"Microcredit: non-SHG group loan" 11"Microcredit: SHG" 12"Finance: daily finance/thandal" 13"Finance: other type of finance" 14"Bank: no coop" 15"Bank: coop" 16"Sugar mill loan", replace
label values loanlender lenders
tab loanlender

order INDID , first

global financeloans loanamount loandate loanreasongiven loanreasongiven2 loaneffectivereason loaneffectivereason2 loanotherreasongiven loanothereffectivereason loanlender snmoneylenderdummyfam snmoneylenderfriend snmoneylenderwkp snmoneylenderlabourrelation snmoneylendersex snmoneylenderage snmoneylenderlabourtype snmoneylendercastes snmoneylendercastesother snmoneylendereduc snmoneylenderoccup snmoneylender2 snmoneylenderemployertype snmoneylenderoccupother snmoneylender3 snmoneylenderliving snmoneylenderruralurban snmoneylendermapdistrict snmoneylenderdistrict snmoneylenderlivingname snmoneylendercompared snmoneylenderduration snmoneylendermeet snmoneylendermeetfrequency snmoneylenderinvite snmoneylenderreciprocity1 snmoneylenderintimacy snmoneylenderphonenb snmoneylenderphoto snmoneylendermeetother otherlenderservices guarantee allloans3 guaranteeother otherlenderservicesother guaranteetype loansettled dummyinterest interestpaid covfrequencyinterest covamountinterest alloans4 loanbalance totalrepaid covfrequencyrepayment covrepaymentstop mainloanid mainloanname lenderfirsttime additionalloan borrowerservices borrowerservicesother plantorepay plantorepayother termsofrepayment repayduration1 repayduration2 dummyinteret interestfrequency interestloan dummyproblemtorepay problemdelayrepayment problemdelayrepaymentother settleloanstrategy settleloanstrategyother loanproductpledge loanproductpledgeother loanproductpledgeaamount dummyhelptosettleloan helptosettleloan dummyrecommendation dummyguarantor recommenddetailscaste recommendloanrelation guarantordetailscaste guarantorloanrelation dummyincomeassets incomeassets

foreach x in $financeloans{
capture confirm v `x'
if _rc==0{
}
else{
gen `x'=""
}
}

*All loans
order borrowername nbloansbyborrower loanid loanamount loandate loanreasongiven loanreasongiven2 loaneffectivereason loaneffectivereason2 loanotherreasongiven loanothereffectivereason loanlender lendername snmoneylenderdummyfam snmoneylenderfriend snmoneylenderwkp snmoneylenderlabourrelation snmoneylendersex snmoneylenderage snmoneylenderlabourtype snmoneylendercastes snmoneylendercastesother snmoneylendereduc snmoneylenderoccup snmoneylender2 snmoneylenderemployertype snmoneylenderoccupother snmoneylender3 snmoneylenderliving snmoneylenderruralurban snmoneylendermapdistrict snmoneylenderdistrict snmoneylenderlivingname snmoneylendercompared snmoneylenderduration snmoneylendermeet snmoneylendermeetfrequency snmoneylenderinvite snmoneylenderreciprocity1 snmoneylenderintimacy snmoneylenderphonenb snmoneylenderphoto snmoneylendermeetother otherlenderservices guarantee allloans3 guaranteeother otherlenderservicesother guaranteetype loansettled dummyinterest interestpaid covfrequencyinterest covamountinterest alloans4 loanbalance totalrepaid covfrequencyrepayment covrepaymentstop, after(INDID)



*Mains loans
order mainloanid mainloanname lenderfirsttime additionalloan borrowerservices borrowerservicesother plantorepay plantorepayother termsofrepayment repayduration1 repayduration2 dummyinteret interestfrequency interestloan dummyproblemtorepay problemdelayrepayment problemdelayrepaymentother settleloanstrategy settleloanstrategyother loanproductpledge loanproductpledgeother loanproductpledgeaamount dummyhelptosettleloan helptosettleloan dummyrecommendation dummyguarantor recommenddetailscaste recommendloanrelation guarantordetailscaste guarantorloanrelation dummyincomeassets incomeassets, after(covrepaymentstop)

dropmiss $financeloans, force
drop otherlenderservices_2 otherlenderservices_4 otherlenderservices_5 otherlenderservices_1 otherlenderservices_3 guarantee_1 guarantee_4 guarantee_6 guarantee_5 guarantee_77 guarantee_2 guarantee_3 otherlenderservices_77 borrowerservices_3 borrowerservices_4 borrowerservices_1 plantorepay_77 plantorepay_5 plantorepay_2 plantorepay_6 plantorepay_4 plantorepay_3 plantorepay_1 problemdelayrepayment_1 problemdelayrepayment_2 problemdelayrepayment_3 problemdelayrepayment_4 problemdelayrepayment_5 problemdelayrepayment_77 settleloanstrategy_1 settleloanstrategy_8 settleloanstrategy_7 settleloanstrategy_4 settleloanstrategy_6 settleloanstrategy_3 settleloanstrategy_9 settleloanstrategy_77 settleloanstrategy_10 settleloanstrategy_5 loanproductpledge_16 loanproductpledge_1 loanproductpledge_15 loanproductpledge_8 loanproductpledge_6 helptosettleloan_7 helptosettleloan_1 helptosettleloan_2 helptosettleloan_12 helptosettleloan_3 recommendloanrelation_2 recommendloanrelation_5 recommendloanrelation_10 recommendloanrelation_1 guarantorloanrelation_2 guarantorloanrelation_5 guarantorloanrelation_8 guarantorloanrelation_1 borrowerservices_2 settleloanstrategy_2 helptosettleloan_14 helptosettleloan_13 helptosettleloan_6 helptosettleloan_8 helptosettleloan_4 recommendloanrelation_8 recommendloanrelation_99 guarantorloanrelation_99 recommendloanrelation_6

*destring
foreach x in snmoneylenderdummyfam snmoneylenderfriend snmoneylenderwkp snmoneylenderlabourrelation snmoneylendersex snmoneylenderage snmoneylenderlabourtype snmoneylendercastes snmoneylendereduc snmoneylenderemployertype snmoneylenderoccupother snmoneylenderliving snmoneylenderruralurban snmoneylenderdistrict snmoneylendermeet snmoneylendermeetfrequency snmoneylenderinvite snmoneylenderreciprocity1 snmoneylenderintimacy snmoneylenderphonenb covrepaymentstop mainloanid {
destring `x', replace
}

save "NEEMSIS2-loans_v3.dta", replace
****************************************
* END









****************************************
* MARRIAGE
****************************************
*5. Finance marriage
use"NEEMSIS_APPEND-marriagefinance.dta", clear
gen loan_database="MARRIAGE"
keep if marriageloanid!=""
rename marrigeloandate marriageloandate
foreach x in marriageloanid marriageloanamount marriageloanlender marriageloanlistsn marriageloanlendername marriageloanlendersex marriageloanlenderoccup marriageloancaste marriagelenderfrom marriageloansettled marriageloanbalance marriageloandate{
local newname=substr("`x'",9,.)
rename `x' `newname'
}
gen loanreasongiven=8
gen loaneffectivereason=8
rename loanlendername lendername
rename loanlistsn snmoneylender
rename loanlendersex snmoneylendersex
rename loanlenderoccup snmoneylenderoccup 
rename loancaste snmoneylendercastes
rename lenderfrom snmoneylenderliving

order loanid loanamount loandate loanreasongiven loaneffectivereason loanlender lendername snmoneylender snmoneylendersex snmoneylenderoccup snmoneylendercastes snmoneylenderliving loansettled loanbalance

fre loansettled  // 12
*drop if loansettled==1
rename parent_key setofmarriagegroup
tab loanbalance,m  // 12 ok
merge m:m setofmarriagegroup using "NEEMSIS_APPEND-hhquestionnaire-marriage-marriagegroup_v3.dta", keepusing(marriedid marriedname)
keep if _merge==3
drop _merge
tab loanbalance, m  // 12 ok
*rename marriedname namefromearlier
destring marriedid, replace
destring loanid, replace
rename marriedid INDID

split setofmarriagegroup, p(/)
drop setofmarriagegroup2
rename setofmarriagegroup1 parent_key

append using "NEEMSIS2-loans_v3.dta"
tab loanbalance, m  // 12 + 428 = 440 ok
tab loanlender
label define lenders 1"Well-know people" 2"Relatives" 3"Friend" 4"Employer" 5"Maistry" 6"Colleague" 7"Pawnbroker" 8"Shop keeper" 9"Microcredit: individual loan" 10"Microcredit: non-SHG group loan" 11"Microcredit: SHG" 12"Finance: daily finance/thandal" 13"Finance: other type of finance" 14"Bank: no coop" 15"Bank: coop" 16"Sugar mill loan", replace
label values loanlender lenders
tab loanlender, m

save"NEEMSIS2-loans_v4.dta", replace
*erase "NEEMSIS_APPEND-hhquestionnaire-marriage-marriagegroup_v3.dta"
****************************************
* END


****************************************
* GOLD
****************************************
*6. Gold
use"NEEMSIS_APPEND-hhquestionnaire-financialpracticesgroup-goldgroup-gold.dta", clear
gen loan_database="GOLD"
keep if loanamount!=.
rename goldownername namefromearlier 
rename goldnumber INDID
rename loanamountgold loanamount
rename loanlendergold loanlender
rename loandategold loandate
rename goldreasonpledge loanreasongiven_MCQ
rename loanbalancegold loanbalance
rename loansettledgold loansettled
rename lenderfromgold lenderfrom
rename lenderscastegold lenderscaste
destring INDID, replace
fre loansettled  // 18 
*drop if loansettled==1
tab loanbalance, m  
tab loanbalance loansettled, m  //  314 loanbalance .
tab loanreasongiven_MCQ
split loanreasongiven_MCQ
destring loanreasongiven_MCQ1, replace
rename loanreasongiven_MCQ1 loanreasongiven
drop loanreasongiven_MCQ2 loanreasongiven_MCQ3 loanreasongiven_MCQ4 loanreasongiven_MCQ5 loanreasongiven_MCQ6 loanreasongiven_MCQ7 loanreasongiven_MCQ8
replace loanreasongiven=2 if loanreasongiven_MCQ=="1 2 3 4"
replace loanreasongiven=2 if loanreasongiven_MCQ=="1 2 3 4 5 6 9 10"
replace loanreasongiven=4 if loanreasongiven_MCQ=="1 2 4"
replace loanreasongiven=10 if loanreasongiven_MCQ=="1 2 4 10"
replace loanreasongiven=10 if loanreasongiven_MCQ=="1 2 4 9 10"
replace loanreasongiven=4 if loanreasongiven_MCQ=="1 2 5 7 10"
replace loanreasongiven=2 if loanreasongiven_MCQ=="1 2 9 10"
replace loanreasongiven=1 if loanreasongiven_MCQ=="1 3"
replace loanreasongiven=3 if loanreasongiven_MCQ=="1 3 5 11"
replace loanreasongiven=1 if loanreasongiven_MCQ=="1 4"
replace loanreasongiven=8 if loanreasongiven_MCQ=="1 8"
replace loanreasongiven=9 if loanreasongiven_MCQ=="1 9"
replace loanreasongiven=10 if loanreasongiven_MCQ=="2 10"
replace loanreasongiven=3 if loanreasongiven_MCQ=="2 3"
replace loanreasongiven=2 if loanreasongiven_MCQ=="2 3 10"
replace loanreasongiven=4 if loanreasongiven_MCQ=="2 3 4"
replace loanreasongiven=10 if loanreasongiven_MCQ=="2 3 4 10"
replace loanreasongiven=4 if loanreasongiven_MCQ=="2 3 4 5"
replace loanreasongiven=9 if loanreasongiven_MCQ=="2 3 4 9"
replace loanreasongiven=8 if loanreasongiven_MCQ=="2 3 8"
replace loanreasongiven=2 if loanreasongiven_MCQ=="2 4"
replace loanreasongiven=4 if loanreasongiven_MCQ=="2 4 10"
replace loanreasongiven=5 if loanreasongiven_MCQ=="2 4 5"
replace loanreasongiven=10 if loanreasongiven_MCQ=="2 4 5 10"
replace loanreasongiven=2 if loanreasongiven_MCQ=="2 4 5 7"
replace loanreasongiven=7 if loanreasongiven_MCQ=="2 4 7"
replace loanreasongiven=4 if loanreasongiven_MCQ=="2 4 7 10"
replace loanreasongiven=8 if loanreasongiven_MCQ=="2 4 7 8"
replace loanreasongiven=8 if loanreasongiven_MCQ=="2 4 7 8 10 11"
replace loanreasongiven=8 if loanreasongiven_MCQ=="2 4 8"
replace loanreasongiven=8 if loanreasongiven_MCQ=="2 4 8 10"
replace loanreasongiven=9 if loanreasongiven_MCQ=="2 4 9 10"
replace loanreasongiven=5 if loanreasongiven_MCQ=="2 5"
replace loanreasongiven=5 if loanreasongiven_MCQ=="2 5 9"
replace loanreasongiven=7 if loanreasongiven_MCQ=="2 7"
replace loanreasongiven=8 if loanreasongiven_MCQ=="2 8"
replace loanreasongiven=2 if loanreasongiven_MCQ=="2 9"
replace loanreasongiven=3 if loanreasongiven_MCQ=="3 10"
replace loanreasongiven=3 if loanreasongiven_MCQ=="3 4"
replace loanreasongiven=3 if loanreasongiven_MCQ=="3 5"
replace loanreasongiven=3 if loanreasongiven_MCQ=="3 7"
replace loanreasongiven=4 if loanreasongiven_MCQ=="4 10"
replace loanreasongiven=4 if loanreasongiven_MCQ=="4"
replace loanreasongiven=5 if loanreasongiven_MCQ=="4 5"
replace loanreasongiven=7 if loanreasongiven_MCQ=="4 5 7"
replace loanreasongiven=10 if loanreasongiven_MCQ=="4 5 8 10"
replace loanreasongiven=6 if loanreasongiven_MCQ=="4 6"
replace loanreasongiven=6 if loanreasongiven_MCQ=="5 6"
replace loanreasongiven=8 if loanreasongiven_MCQ=="5 8"
replace loanreasongiven=8 if loanreasongiven_MCQ=="8 9"
replace loanreasongiven=9 if loanreasongiven_MCQ=="9 10"
replace loanreasongiven=9 if loanreasongiven_MCQ=="9 11"
replace loanreasongiven=9 if loanreasongiven_MCQ=="9 77"
tab loanreasongiven, m
tab loanlender, m
label define lenders 1"Well-know people" 2"Relatives" 3"Friend" 4"Employer" 5"Maistry" 6"Colleague" 7"Pawnbroker" 8"Shop keeper" 9"Microcredit: individual loan" 10"Microcredit: non-SHG group loan" 11"Microcredit: SHG" 12"Finance: daily finance/thandal" 13"Finance: other type of finance" 14"Bank: no coop" 15"Bank: coop" 16"Sugar mill loan", replace
label values loanlender lenders
tab loanlender, m

clonevar loaneffectivereason=loanreasongiven
rename lenderscaste snmoneylendercastes
rename lenderfrom snmoneylenderliving

order loanamount loandate loanreasongiven loaneffectivereason loanlender snmoneylendercastes loansettled loanbalance loan_database

keep parent_key INDID key loanamount loandate loanreasongiven loaneffectivereason loanlender snmoneylendercastes loansettled loanbalance loan_database

append using "NEEMSIS2-loans_v4.dta"

save"NEEMSIS2-loans_v5.dta", replace
****************************************
* END








****************************************
* CLEAN
****************************************
use"NEEMSIS2-loans_v5.dta", clear

tab loandate, m
tab loanbalance, m  // 314 miss pour l'or, le reste pour settled

merge m:1 parent_key using "NEEMSIS_APPEND.dta", keepusing(HHID_panel HHID2010 submissiondate version)
sort _merge
keep if _merge==3
drop _merge

/*
merge m:1 householdid using "C:\Users\Arnaud\Desktop\NEEMSIS2\dofileNEEMSIS2cleaning\unique_identifier_panel.dta", keepusing(villageid villageareaid dummynewHH dummydemonetisation caste HHID2010)
keep if _merge==3
drop _merge
order householdid2020 HHID2010 INDID namefromearlier villageid caste 
*/
gen year=2020
tab loanlender, m
clonevar loanlender_new2020=loanlender
replace loanlender=1 if loanlender_new2020==1
replace loanlender=2 if loanlender_new2020==2
replace loanlender=3 if loanlender_new2020==4
replace loanlender=4 if loanlender_new2020==5
replace loanlender=5 if loanlender_new2020==6
replace loanlender=6 if loanlender_new2020==7
replace loanlender=7 if loanlender_new2020==8
replace loanlender=8 if loanlender_new2020==12
replace loanlender=8 if loanlender_new2020==13
replace loanlender=8 if loanlender_new2020==9
replace loanlender=8 if loanlender_new2020==10
replace loanlender=9 if loanlender_new2020==3
replace loanlender=10 if loanlender_new2020==11
replace loanlender=11 if loanlender_new2020==14
replace loanlender=12 if loanlender_new2020==15

tab loanlender loanlender_new2020

*Order
global all HHID2010 INDID borrowername nbloansbyborrower loanid loanamount loandate loanreasongiven loanreasongiven2 loaneffectivereason loaneffectivereason2 loanotherreasongiven loanothereffectivereason loanlender lendername snmoneylenderdummyfam snmoneylenderfriend snmoneylenderwkp snmoneylenderlabourrelation snmoneylendersex snmoneylenderage snmoneylenderlabourtype snmoneylendercastes snmoneylendercastesother snmoneylendereduc snmoneylenderoccup snmoneylender2 snmoneylenderemployertype snmoneylenderoccupother snmoneylender3 snmoneylenderliving snmoneylenderruralurban snmoneylendermapdistrict snmoneylenderdistrict snmoneylenderlivingname snmoneylendercompared snmoneylenderduration snmoneylendermeet snmoneylendermeetfrequency snmoneylenderinvite snmoneylenderreciprocity1 snmoneylenderintimacy snmoneylenderphonenb snmoneylenderphoto snmoneylendermeetother otherlenderservices guarantee allloans3 guaranteeother otherlenderservicesother guaranteetype loansettled dummyinterest interestpaid covfrequencyinterest covamountinterest alloans4 loanbalance totalrepaid covfrequencyrepayment covrepaymentstop mainloanid mainloanname lenderfirsttime additionalloan borrowerservices borrowerservicesother plantorepay plantorepayother termsofrepayment repayduration1 repayduration2 dummyinteret interestfrequency interestloan dummyproblemtorepay problemdelayrepayment problemdelayrepaymentother settleloanstrategy settleloanstrategyother loanproductpledge loanproductpledgeother loanproductpledgeaamount dummyhelptosettleloan helptosettleloan dummyrecommendation dummyguarantor recommenddetailscaste recommendloanrelation guarantordetailscaste guarantorloanrelation dummyincomeassets incomeassets
foreach x in $all{
capture confirm v `x'
if _rc==0{
}
else{
gen `x'=""
}
}
order $all, first
dropmiss $all, force


*new var for panel
clonevar lenderscaste=snmoneylendercastes

fre snmoneylenderdummyfam snmoneylenderfriend snmoneylenderwkp snmoneylenderlabourrelation
gen lenderrelation=.
replace lenderrelation=2 if snmoneylenderdummyfam==1
replace lenderrelation=10 if snmoneylenderfriend==1
replace lenderrelation=8 if snmoneylenderwkp==1
replace lenderrelation=1 if snmoneylenderlabourrelation==1

fre snmoneylenderliving
gen lenderfrom=.
replace lenderfrom=1 if snmoneylenderliving==1
replace lenderfrom=1 if snmoneylenderliving==2
replace lenderfrom=2 if snmoneylenderliving==3
replace lenderfrom=2 if snmoneylenderliving==4
replace lenderfrom=2 if snmoneylenderliving==5
replace lenderfrom=2 if snmoneylenderliving==6

tab lendername loan_database, m
clonevar lendersex=snmoneylendersex
clonevar lenderoccup=snmoneylenderoccup

*Add caste, etc
merge m:1 HHID2010 INDID using "NEEMSIS2-HH_v14.dta", keepusing(parent_key HHID_panel HHID2010 householdid2020 villageid villagearea jatis caste INDID INDID_total INDID_former INDID_new INDID_left egoid name sex age edulevel)
drop if _merge==2

save"NEEMSIS2-loans_v6.dta", replace
****************************************
* END








****************************************
* INDIV & HH level
****************************************
use"NEEMSIS2-loans_v6.dta", clear

egen INDID2010=concat(HHID2010 INDID), p(/)

tab loan_database loansettled
*Conditions
drop if loansettled==1

*Total loan amount
bysort INDID2010: egen totalloanamount_indiv=sum(loanamount)

*Number of loans
gen nbloans=1
bysort INDID2010: egen totalnumberloans_indiv=sum(nbloans)
drop nbloans

*Total loan balance
bysort INDID2010: egen totalloanbalance_indiv=sum(loanbalance)

*Keep HH level variables
bysort INDID2010: gen n=_n
keep if n==1
keep INDID2010 totalloanamount_indiv totalnumberloans_indiv totalloanbalance_indiv

save"NEEMSIS2-loans_v6_indiv.dta", replace


*Merge with HH base
use"NEEMSIS2-HH_v14.dta", clear

drop INDID2010
egen INDID2010=concat(HHID2010 INDID), p(/)


merge m:1 INDID2010 using "NEEMSIS2-loans_v6_indiv.dta"
drop _merge

*HH level
bysort HHID2010: egen totalloanamount=sum(totalloanamount_indiv)
bysort HHID2010: egen totalnumberloans=sum(totalnumberloans_indiv)
bysort HHID2010: egen totalloanbalance=sum(totalloanbalance_indiv)


save"NEEMSIS2-HH_v14_loans.dta", replace
****************************************
* END












****************************************
* CLEANING 2
****************************************
use"NEEMSIS2-loans_v6.dta", clear
fre loansettled
drop if loansettled==1  // 440 + 18 gold

*Change date format of submissiondate
rename submissiondate submissiondate_o
gen submissiondate=dofc(submissiondate_o)
format submissiondate %td

*Loan duration
gen loanduration=submissiondate-loandate

*Type of loan
gen informal=.
gen semiformal=.
gen formal=.
foreach i in 1 2 3 4 5 7 9 13{
replace informal=1 if loanlender==`i'
}
foreach i in 6 10{
replace semiformal=1 if loanlender==`i'
}
foreach i in 8 11 12 14{
replace formal=1 if loanlender==`i'
}

*Purpose of loan
replace loanreasongiven=loanreasongiven2 if loanreasongiven==. & loanreasongiven2!=.

label define loanreasongiven 1"Agriculture" 2"Family" 3"Health" 4"Repay previous loan" 5"House expenses" 6"Investment" 7"Ceremonies" 8"Marriage" 9"Education" 10"Relatives" 11"Death" 12"No reason" 77"Other"
label values loanreasongiven loanreasongiven
tab loanreasongiven

gen economic=.
gen current=.
gen humancap=.
gen social=.
gen house=.
foreach i in 1 6{
replace economic=1 if loanreasongiven==`i'
}
foreach i in 2 4 10{
replace current=1 if loanreasongiven==`i'
}
foreach i in 3 9{
replace humancap=1 if loanreasongiven==`i'
}
foreach i in 7 8 11{
replace social=1 if loanreasongiven==`i'
}
foreach i in 5{
replace house=1 if loanreasongiven==`i'
}

*Verif
egen test=rowtotal(informal semiformal formal economic current humancap social house)
tab test
sort test
drop test

*Purpose of loan 2
gen incomegen=.
gen noincomegen=.
replace incomegen=1 if economic==1
replace noincomegen=1 if current==1 | humancap==1 | social==1 | house==1

*In amount
foreach x in economic current humancap social house incomegen noincomegen informal formal semiformal{
gen `x'_amount=loanamount if `x'==1
}

save"NEEMSIS2-loans_v7.dta", replace
****************************************
* END











****************************************
* NEW LENDER VAR
****************************************
use "NEEMSIS2-loans_v7.dta", clear
fre loanlender
label define loanlender 1"WKP" 2"Relatives" 3"Employer" 4"Maistry" 5"Colleague" 6"Pawn Broker" 7"Shop keeper" 8"Finance (moneylenders)" 9"Friends" 10"SHG" 11"Banks" 12"Coop bank" 14"Group finance" 15"Thandal"  // Thandal = daily finance; door to door; small amount; it mean "immediat" in tamil
label values loanlender loanlender
fre loanlender
*Recode loanlender pour que les intérêts soient plus justes
gen lender2=.
replace lender2=1 if loanlender==1
replace lender2=2 if loanlender==2
replace lender2=3 if loanlender==3 | loanlender==4 | loanlender==5  // labour relation 
replace lender2=4 if loanlender==6
replace lender2=5 if loanlender==7
replace lender2=6 if loanlender==8
replace lender2=7 if loanlender==9
replace lender2=8 if loanlender==10 | loanlender==14  // SHG & group finance
replace lender2=9 if loanlender==11 | loanlender==12 | loanlender==13  // bank & coop & sugar mill loan
replace lender2=10 if loanlender==15  // thandal
label define lender2 1 "WKP" 2 "Relatives" 3 "Labour" 4 "Pawn broker" 5 "Shop keeper" 6 "Moneylenders" 7 "Friends" 8"SHG & grp fin" 9 "Banks" 10"Thandal", replace
label values lender2 lender2
fre lender2

*Including relationship to the lender
gen lender3=lender2
replace lender3=1 if snmoneylenderwkp==1  // WKP
replace lender3=2 if snmoneylenderdummyfam==1  // Relatives
replace lender3=3 if snmoneylenderlabourrelation==1  // labour
replace lender3=7 if snmoneylenderfriend==1  // Friends
label define lender3 1 "WKP" 2 "Relatives" 3 "Labour" 4 "Pawn broker" 5 "Shop keeper" 6 "Moneylenders" 7 "Friends" 8 "Microcredit" 9 "Bank" 10 "Thandal"
label values lender3 lender3
tab lender3 lender2

*correction of the moneylenders category with info from the main loan variable "lendername" 
gen lender4=lender3
tab lendername
replace lender4=8 if strpos(lendername, "finance") & lendername!="Daily finance"
replace lender4=8 if strpos(lendername, "Finance")
replace lender4=8 if strpos(lendername, "Therinjavanga")
replace lender4=10 if strpos(lendername, "thandal")
 replace lender4=10 if strpos(lendername, "Thandal")
label values lender4 lender3
label var lender4 "version def (lendername)"
fre lender4

save "NEEMSIS2-loans_v8.dta", replace
****************************************
* END











****************************************
* COHERENCE
****************************************
use"NEEMSIS2-loans_v8.dta", clear
*label define loanreasongiven 1"Agriculture" 2"Family expenses" 3"Health" 4"Repay previous" 5"House" 6"Investment" 7"Ceremonies" 8"Marriage" 9"Education" 10"Relatives" 11"Death" 12"No reason" 77"Other"
*label values loanreasongiven loanreasongiven
gen loanduration_month=loanduration/30.467
replace loanduration_month=1 if loanduration_month<1
tab loanduration_month

dropmiss, force

*As Elena, for gold
replace loanbalance=loanamount if loan_database=="GOLD"

*66 as .
replace interestpaid=. if interestpaid==55 | interestpaid==66
replace totalrepaid=. if totalrepaid==66
replace loanamount=. if loanamount==66
drop if loanamount==.

***Priority to balance or priority to totalrepaid/interestpaid ?
*Test Balance
gen test=loanamount-loanbalance
tab test  // 1/2228 weird loan : 0.04%
drop test

*Test Paid
gen test=totalrepaid-interestpaid
tab test  // 43/650 weird loan : 6.61%
drop test
/*
Check with Isabelle and Elena, but i prefer to use balance as good measure instead of totalrepaid and interestpaid
*/

*Cleaning for coherence
gen totalrepaid2=totalrepaid
gen interestpaid2=interestpaid
gen principalpaid=loanamount-loanbalance


*replace totalrepaid2=interestpaid if interestpaid>=totalrepaid

replace totalrepaid2=principalpaid+interestpaid // if interestpaid>=totalrepaid

*replace interestpaid2=totalrepaid-principalpaid if interestpaid<totalrepaid

*Coherence
gen coherence=loanamount-loanbalance-principalpaid
tab coherence
drop coherence
gen coherence=totalrepaid2-principalpaid-interestpaid2
tab coherence
drop coherence

save "NEEMSIS2-loans_v9.dta", replace
****************************************
* END


















****************************************
* BALANCE
****************************************
use"NEEMSIS2-loans_v9.dta", clear

replace loanbalance=0 if loansettled==1
/*
*update loanbalance with principalpaid for microcredits (interest checked, plausible)
replace loanbalance=loanamount-principalpaid if lender4==8 & loanbalance>loanamount & loanbalance!=.
replace loanbalance=loanamount if loanbalance>loanamount & loanbalance!=. & principalpaid==. 

*verif balance
gen test=loanamount-principalpaid - loanbalance
tab test
gen test2=test*100/loanamount
tab test2
* 0 :  55 %
*20% inf, 25% sup
tab lender4 if test!=0 & test!=.
*1/3 de microcredit dans ceux qui ne matchent pas
drop test

*** loans with pb "identified" + POSITIVE AMOUNTS of principal paid different selon principal paid et loanbalance:
*apres check: on ne peut pas faire grand chose. considere que principalpaid prevaut sur loanbalance.

gen test=loanamount-principalpaid - loanbalance
tab test
replace loanbalance=loanamount - principalpaid if test!=0 & test!=. &
drop test
gen test=loanamount-principalpaid - loanbalance
tab test
drop test

tab loanbalance
*/
save "NEEMSIS2-loans_v10.dta", replace
*************************************
*** END



















****************************************
* ANNUALIZED
****************************************
use"NEEMSIS2-loans_v10.dta", clear

*****
*Arnaud test yrate
gen yratepaid=interestpaid2*100/loanamount if loanduration<=365

gen _yratepaid=interestpaid2*365/loanduration if loanduration>365
gen _loanamount=loanamount*365/loanduration if loanduration>365

replace yratepaid=_yratepaid*100/_loanamount if loanduration>365
drop _loanamount _yratepaid

tab yratepaid
sort yratepaid
tab loanamount if loanamount<1000
drop if loanamount<1000

tabstat yratepaid if interestpaid2>0 & interestpaid2!=., by(lender4) stat(n mean p50 min max)
drop yratepaid
*****
/*
     lender4 |         N      mean       p50       min       max
-------------+--------------------------------------------------
         WKP |       200   42.3452  30.83333  .8333333       600
   Relatives |        16  29.14617  23.33333         3  72.00001
      Labour |        71  23.31925        20       2.4       108
 Shop keeper |         5  29.38424        30  .9212121  70.00001
Moneylenders |        21  12.91653  11.11111  .7272727        40
     Friends |       260  20.51602      14.5  .0057143       120
 Microcredit |        50  18.88545        10   .007875        80
        Bank |        88  16.28453  12.83333       .21  86.66666
     Thandal |        70   10.8256        10         2        60
-------------+--------------------------------------------------
       Total |       781  24.94044      15.5  .0057143       600
----------------------------------------------------------------

*/

save"NEEMSIS2-loans_v11.dta", replace
*************************************
* END



















****************************************
* IMPUTATION
****************************************
use"NEEMSIS2-loans_v11.dta", clear
merge m:m HHID2010 INDID using "NEEMSIS2-HH_v14.dta", keepusing(totalincome_indiv totalincome_HH) keep(3) nogen

*Debt service pour ML
gen debt_service=.
replace debt_service=totalrepaid2 if loanduration<=365
replace debt_service=totalrepaid2*365/loanduration if loanduration>365
replace debt_service=0 if loanduration==0 & totalrepaid2==0 | loanduration==0 & totalrepaid2==.

*Interest service pour ML
gen interest_service=.
replace interest_service=interestpaid2 if loanduration<=365
replace interest_service=interestpaid2*365/loanduration if loanduration>365
replace interest_service=0 if loanduration==0 & totalrepaid2==0 | loanduration==0 & totalrepaid2==.
replace interest_service=0 if dummyinterest==0 & interestpaid2==0 | dummyinterest==0 & interestpaid2==.

*Imputation du principal
gen imp_principal=.
replace imp_principal=loanamount-loanbalance if loanduration<=365 & debt_service==.
replace imp_principal=(loanamount-loanbalance)*365/loanduration if loanduration>365 & debt_service==.

*Imputation interest for moneylenders and microcredit
gen imp1_interest=.
replace imp1_interest=0.129*loanamount if lender4==6 & loanduration<=365 & debt_service==.
replace imp1_interest=0.129*loanamount*365/loanduration if lender4==6 & loanduration>365 & debt_service==.
replace imp1_interest=0.189*loanamount if lender4==8 & loanduration<=365 & debt_service==.
replace imp1_interest=0.189*loanamount*365/loanduration if lender4==8 & loanduration>365 & debt_service==.
replace imp1_interest=0 if lender4!=6 & lender4!=8 & debt_service==. & loandate!=.

*Imputation total
gen imp1_totalrepaid_year=imp_principal+imp1_interest

*Calcul service de la dette pour tout
gen imp1_debt_service=debt_service
replace imp1_debt_service=imp1_totalrepaid_year if debt_service==.

*Calcul service des interets pour tout
gen imp1_interest_service=interest_service
replace imp1_interest_service=imp1_interest if debt_service==.

*INDIV
bysort HHID2010 INDID: egen imp1_ds_tot=sum(imp1_debt_service)
bysort HHID2010 INDID: egen imp1_is_tot=sum(imp1_interest_service)
bysort HHID2010 INDID: egen loanamount_indiv=sum(loanamount)

gen IDR=imp1_is_tot*100/loanamount_indiv
gen DSDR=imp1_ds_tot*100/loanamount_indiv
gen DSR=imp1_ds_tot*100/totalincome_indiv
gen ISR=imp1_is_tot*100/totalincome_indiv

*HH
bysort HHID2010: egen imp1_ds_tot_HH=sum(imp1_debt_service)
bysort HHID2010: egen imp1_is_tot_HH=sum(imp1_interest_service)
bysort HHID2010: egen loanamount_HH=sum(loanamount)

gen DSR_HH=imp1_ds_tot_HH*100/totalincome_HH
gen ISR_HH=imp1_is_tot_HH*100/totalincome_HH
gen IDHDR=loanamount_indiv*100/loanamount_HH


*INDIV
preserve
bysort HHID2010 INDID: gen n=_n
keep if n==1
drop n
tabstat IDHDR IDR DSDR DSR ISR, stat(n mean sd q) long
restore
/*
   stats |     IDHDR       IDR      DSDR       DSR       ISR
---------+--------------------------------------------------
       N |       816       816       816       741       741
    mean |  50.73529  6.590457  17.17377  190.7965  66.21291
      sd |  32.43795  8.075231  16.05805  524.7983  329.5351
     p25 |  21.92382         0  4.731352  5.391846         0
     p50 |  48.79501  4.017708  14.39649  32.54378  7.172533
     p75 |  80.07936  10.37299  24.16565  161.0716  33.84861
------------------------------------------------------------
*/



*HH
preserve
bysort HHID2010: gen n=_n
keep if n==1
drop n
tabstat DSR_HH ISR_HH, stat(n mean sd q min max) long
restore
/*
   stats |    DSR_HH    ISR_HH
---------+--------------------
       N |       392       392
    mean |  64.54962  22.63208
      sd |  124.2718  55.02093
     p25 |  10.92517  2.245014
     p50 |  24.32352  7.590003
     p75 |  64.17494  18.36802
     min |         0         0
     max |  1147.561  581.3826
------------------------------
*/

save"NEEMSIS2-loans_v12.dta", replace
*************************************
* END














****************************************
* Other measure
****************************************
use"NEEMSIS2-loans_v12.dta", clear

rename HHID2010 HHID

*Informal debt ratio
bysort HHID INDID: egen _temp1=sum(informal_amount)
bysort HHID INDID: egen _temp2=sum(semiformal_amount)
gen InfoDR=(_temp1+_temp2)*100/loanamount_indiv
drop _temp1 _temp2

*Formal debt ratio
bysort HHID INDID: egen _temp=sum(formal_amount)
gen FoDR=_temp*100/loanamount_indiv
drop _temp

*Income gen debt ratio
bysort HHID INDID: egen _temp=sum(incomegen_amount)
gen IncDR=_temp*100/loanamount_indiv
drop _temp

*Non income gen debt ratio
bysort HHID INDID: egen _temp=sum(noincomegen_amount)
gen NoincDR=_temp*100/loanamount_indiv
drop _temp

*Problem to repay loan
bysort HHID INDID: egen _temp=sum(dummyproblemtorepay)
tab _temp
recode _temp (2=1) (3=1)
rename _temp PRdummy

*Help to settle loan
bysort HHID INDID: egen _temp=sum(dummyhelptosettleloan)
tab _temp
recode _temp (2=1) (3=1)
rename _temp HSdummy

*Interest
bysort HHID INDID: egen _temp=sum(dummyinterest)
tab _temp
forvalues i=1(1)11{
recode _temp (`i'=1)
}
tab _temp
rename _temp ILdummy

rename HHID HHID2010

save"NEEMSIS2-loans_v13.dta", replace
*************************************
*** END



****************************************
* Individual level
****************************************
use"NEEMSIS2-loans_v13.dta", clear

bysort HHID2010 INDID: gen n=_n
keep if n==1
drop n
keep HHID2010 householdid2020 INDID imp1_ds_tot imp1_is_tot loanamount_indiv IDR DSDR DSR ISR IDHDR InfoDR FoDR IncDR NoincDR PRdummy HSdummy ILdummy DSR_HH ISR_HH

save"NEEMSIS2-loans_v13_indiv.dta", replace

use"NEEMSIS2-HH_v14_loans.dta", clear

merge 1:1 HHID2010 INDID using "NEEMSIS2-loans_v13_indiv.dta"

save"NEEMSIS2-HH_v15.dta", replace
*************************************
* END
