cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
September 16, 2021
-----
TITLE: Other file
-------------------------
*/

clear all
macro drop _all
cls
********** Path to folder "data" folder.
*global directory = "D:\Documents\_Thesis\_DATA\NEEMSIS2\DATA\APPEND"
global directory = "C:\Users\anatal\Downloads\_Thesis\_DATA\NEEMSIS2\DATA\APPEND"
global directorybis = "C:\Users\anatal\Downloads\_Thesis\_DATA\NEEMSIS2\DATA"
cd"$directory"
clear all










****************************************
* Variables Arnaud
****************************************
use"$directory\CLEAN\NEEMSIS2-HH_v19.dta", clear


drop setoffamilymembers setofeducation setofindividualid setoflefthome setofremreceivedidgroup setofremsentidgroup setofmigrationidgroup setofloansbyborrower setoflendingmoney setofrecommendationgiven setofchitfund setofsavings setofgold setofinsurance setofschemenregaind setofcashassistancemarriagegroup setofgoldmarriagegroup setofschemepension1group setofschemepension2group setofschemepension3group setofschemepension4group setofschemepension5group setofschemepension6group setofschemepension7group

drop age_newfromearlier age_autofromearlier agefromearlier1 agefromearlier2

drop marriagegift_count 

drop setofmarriagefinance setofmarriagegift

drop raw_curious rr_curious raw_interestedbyart rr_interestedbyart raw_repetitivetasks rr_repetitivetasks raw_inventive rr_inventive raw_liketothink rr_liketothink raw_newideas rr_newideas raw_activeimagination rr_activeimagination raw_organized rr_organized raw_makeplans rr_makeplans raw_workhard rr_workhard raw_appointmentontime rr_appointmentontime raw_putoffduties rr_putoffduties raw_easilydistracted rr_easilydistracted raw_completeduties rr_completeduties raw_enjoypeople rr_enjoypeople raw_sharefeelings rr_sharefeelings raw_shywithpeople rr_shywithpeople raw_enthusiastic rr_enthusiastic raw_talktomanypeople rr_talktomanypeople raw_talkative rr_talkative raw_expressingthoughts rr_expressingthoughts raw_workwithother rr_workwithother raw_understandotherfeeling rr_understandotherfeeling raw_trustingofother rr_trustingofother raw_rudetoother rr_rudetoother raw_toleratefaults rr_toleratefaults raw_forgiveother rr_forgiveother raw_helpfulwithothers rr_helpfulwithothers raw_managestress rr_managestress raw_nervous rr_nervous raw_changemood rr_changemood raw_feeldepressed rr_feeldepressed raw_easilyupset rr_easilyupset raw_worryalot rr_worryalot raw_staycalm rr_staycalm raw_tryhard rr_tryhard raw_stickwithgoals rr_stickwithgoals raw_goaftergoal rr_goaftergoal raw_finishwhatbegin rr_finishwhatbegin raw_finishtasks rr_finishtasks raw_keepworking rr_keepworking

drop remreceivedtotalamount_indiv remreceivedtotalamount_HH incomeassets_HH incomeassets_indiv otherhouserent_HH otherhouserent_indiv pension_indiv pension_HH  imp1_ds_tot_indiv imp1_is_tot_indiv informal_indiv semiformal_indiv formal_indiv economic_indiv current_indiv humancap_indiv social_indiv house_indiv incomegen_indiv noincomegen_indiv economic_amount_indiv current_amount_indiv humancap_amount_indiv social_amount_indiv house_amount_indiv incomegen_amount_indiv noincomegen_amount_indiv informal_amount_indiv formal_amount_indiv semiformal_amount_indiv marriageloan_indiv marriageloanamount_indiv dummyproblemtorepay_indiv dummyhelptosettleloan_indiv dummyinterest_indiv loanbalance_indiv mean_yratepaid_indiv mean_monthlyinterestrate_indiv sum_otherlenderservices_1 sum_otherlenderservices_2 sum_otherlenderservices_3 sum_otherlenderservices_4 sum_otherlenderservices_5 sum_borrowerservices_1 sum_borrowerservices_2 sum_borrowerservices_3 sum_borrowerservices_4 sum_plantorepay_1 sum_plantorepay_2 sum_plantorepay_3 sum_plantorepay_4 sum_plantorepay_5 sum_plantorepay_6 sum_settleloanstrategy_1 sum_settleloanstrategy_2 sum_settleloanstrategy_3 sum_settleloanstrategy_4 sum_settleloanstrategy_5 sum_settleloanstrategy_6 sum_settleloanstrategy_7 sum_settleloanstrategy_8 sum_settleloanstrategy_9 sum_settleloanstrategy_10 sum_debtrelation_shame imp1_ds_tot_HH imp1_is_tot_HH informal_HH semiformal_HH formal_HH economic_HH current_HH humancap_HH social_HH house_HH incomegen_HH noincomegen_HH economic_amount_HH current_amount_HH humancap_amount_HH social_amount_HH house_amount_HH incomegen_amount_HH noincomegen_amount_HH informal_amount_HH formal_amount_HH semiformal_amount_HH marriageloan_HH marriageloanamount_HH dummyproblemtorepay_HH dummyhelptosettleloan_HH dummyinterest_HH 

drop memberlistpreload2016_count lefthome_count individualid_count familymembers_count education_count employment_count migrationgroup_count remreceivedgroup_count remsentgroup_count loansbyborrower_count mainloans_count lendingmoney_count recommendationgiven_count chitfund_count savings_count gold_count insurance_count marriagegroup_count schemenregaind_count cashassistancemarriagegroup_coun goldmarriagegroup_count schemepension1group_count schemepension2group_count schemepension3group_count schemepension4group_count schemepension5group_count schemepension6group_count indoccupmonths_count businessloandetails_count businesspaymentinkindgroup_count snrecruitworkergroup_count wagejobpaymentinkindgroup_count formalsocialcapital_count snfindcurrentjobgroup_count snfindjobgroup_count snrecommendforjobgroup_count snrecojobsuccessgroup_count sntalkthemostgroup_count snhelpemergencygroup_count sncloserelouthhgroup_count covsnhelpreceivedgroup_count covsntypehelpreceivedgroup_count covsnhelpgivengroup_count covsntypehelpgivengroup_count contactgroup_count count_eligible_1825 count_eligible_2635 count_eligible_36 show_draws_count show_draws_2_count show_draws_3_count migrationjobidgroup_count detailsloanbyborrower_count detailschitfunds_count detailssavingaccounts_count setofdetailssavingaccounts detailsinsurance_count marriagefinance_count products_count livestock_count equipmentowned_count detailsgoods_count setofmemberlistpreload2016 setofmainloans setofdetailschitfunds setofdetailsinsurance

drop indiv loanbalance_HH mean_yratepaid_HH mean_monthlyinterestrate_HH

drop nameego2fromearlier nameego1fromearlierhh nameego1fromearlier indexego2fromearlier indexego2firststep indexego2 indexego1fromearlier indexego1firststep indexego1finalstep indexego1final indexego1 ego3positionname ego3position ego2position ego2index_36 ego2index_2635 ego2index_1825 ego2herefromearlier ego1herefromearlier

drop familymembersindex educationindex employmentindex sex_new age_new username_str Chithra_and_Radhika Suganya_and_Malarvizhi Vivek_Radja HHID dummynewHH dummydemonetisation villageid_new villageid_new_comments tracked namefrompreload


foreach x in migrantlist remrecipientlist remsenderlist borrowerlist hhlenderlist recommendgivenlist marriedlist nregarecipientlist schemeslist chitfundbelongerid savingsownerid goldownerid insuranceownerid schemerecipientlist3 schemerecipientlist4 schemerecipientlist5 schemerecipientlist6 schemerecipientlist7 schemerecipientlist8 schemerecipientlist9 schemerecipientlist10 {
rename `x'_ dummy_`x'
}


foreach x in curious interestedbyart repetitivetasks inventive liketothink newideas activeimagination organized makeplans workhard appointmentontime putoffduties easilydistracted completeduties enjoypeople sharefeelings shywithpeople enthusiastic talktomanypeople talkative expressingthoughts workwithother understandotherfeeling trustingofother rudetoother toleratefaults forgiveother helpfulwithothers managestress nervous changemood feeldepressed easilyupset worryalot staycalm tryhard stickwithgoals goaftergoal finishwhatbegin finishtasks keepworking {
rename `x' `x'_recode
rename `x'_old `x'
}




global arnaud orga_HHagri nboccupation_indiv nboccupation_HH occinc_indiv_agri occinc_indiv_agricasual occinc_indiv_nonagricasual occinc_indiv_nonagriregnonqual occinc_indiv_nonagriregqual occinc_indiv_selfemp occinc_indiv_nrega occinc_HH_agri occinc_HH_agricasual occinc_HH_nonagricasual occinc_HH_nonagriregnonqual occinc_HH_nonagriregqual occinc_HH_selfemp occinc_HH_nrega mainocc_kindofwork_indiv mainocc_profession_indiv mainocc_occupation_indiv mainocc_sector_indiv mainocc_hoursayear_indiv mainocc_annualincome_indiv mainocc_jobdistance_indiv mainocc_occupationname_indiv mainocc_kindofwork_HH mainocc_occupation_HH dummy_respondent2020 edulevel goodtotalamount2 assets assets_noland ra1 rab1 rb1 ra2 rab2 rb2 ra3 rab3 rb3 ra4 rab4 rb4 ra5 rab5 rb5 ra6 rab6 rb6 ra7 rab7 rb7 ra8 rab8 rb8 ra9 rab9 rb9 ra10 rab10 rb10 ra11 rab11 rb11 ra12 rab12 rb12 set_a set_ab set_b raven_tt refuse num_tt lit_tt ars ars2 ars3 cr_curious cr_interestedbyart cr_repetitivetasks cr_inventive cr_liketothink cr_newideas cr_activeimagination cr_organized cr_makeplans cr_workhard cr_appointmentontime cr_putoffduties cr_easilydistracted cr_completeduties cr_enjoypeople cr_sharefeelings cr_shywithpeople cr_enthusiastic cr_talktomanypeople cr_talkative cr_expressingthoughts cr_workwithother cr_understandotherfeeling cr_trustingofother cr_rudetoother cr_toleratefaults cr_forgiveother cr_helpfulwithothers cr_managestress cr_nervous cr_changemood cr_feeldepressed cr_easilyupset cr_worryalot cr_staycalm cr_tryhard cr_stickwithgoals cr_goaftergoal cr_finishwhatbegin cr_finishtasks cr_keepworking cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit OP CO EX AG ES Grit totalincome_indiv totalincome_HH loans_indiv loanamount_indiv caste egoid dummyego understandotherfeeling_recode expressingthoughts_recode helpfulwithothers_recode appointmentontime_recode activeimagination_recode talktomanypeople_recode easilydistracted_recode trustingofother_recode repetitivetasks_recode interestedbyart_recode finishwhatbegin_recode toleratefaults_recode stickwithgoals_recode completeduties_recode workwithother_recode shywithpeople_recode sharefeelings_recode feeldepressed_recode putoffduties_recode managestress_recode forgiveother_recode enthusiastic_recode rudetoother_recode liketothink_recode keepworking_recode goaftergoal_recode finishtasks_recode enjoypeople_recode easilyupset_recode changemood_recode worryalot_recode talkative_recode organized_recode makeplans_recode inventive_recode workhard_recode staycalm_recode newideas_recode tryhard_recode nervous_recode curious_recode

foreach v of varlist $arnaud {
label variable `v' `"Arnaud `: variable label `v''"'
}

order $arnaud, last
order parent_key HHID_panel HHID householdid2020 startdate startquestionnaire enddate endquestionnaire submissiondate version_HH version_agri year

drop orga_HHagri

rename startquestionnaire start_HH_quest
rename endquestionnaire end_HH_quest

rename startdate start_agri_quest
rename enddate end_agri_quest

order start_HH_quest end_HH_quest start_agri_quest end_agri_quest, last


***Preload à ranger
*Comefrom
replace comefrom=comefrompreload2016 if comefrom=="" & comefrompreload2016!=""
drop comefrompreload2016

*Caste
drop castepreload2016 numfamilypreload2016 dummyeverhadlandpreload2016 ownlandpreload2016 sizeownlandpreload2016



***Sort data
sort HHID_panel INDID_panel


***From earlier
drop namefromearlier4 namefromearlier5 workedpastyearfromearlier mainoccupationfromearlier attendedschoolfromearlier namefromearlier sexfromearlier agefromearlier namefromearlier2 livinghomefromearlier2 namefromearlier3


***Selected
foreach x in selected_occupposition selected_occupname selected_months selected_months_monthsid {
rename `x'_ `x'
}


*** Order
order HHID_panel submissiondate year INDID_panel name sex age egoid jatis address villageid


*** Il en reste
drop everattendedschoolfromearlier everattendschoolfinal

*** drop
drop if HHID_panel==""

*** Verif
preserve
sort canread
drop if INDID_left!=.
drop if livinghome==4
drop if livinghome==3
sort canread
restore



save"$directory\CLEAN\NEEMSIS2-HH_v20.dta", replace
****************************************
* END












****************************************
* Loans
****************************************
use"$directory\CLEAN\NEEMSIS2-loans_v11", clear

drop _merge key3 key2 loanreasongivenlabel

order setofmarriagefinance setofmarriagegroup setofloansbyborrower setofdetailsloanbyborrower setofmainloans, last

foreach v in loan_database version_HH loanlender_new2020 edulevel {
label variable `v' `"Arnaud `: variable label `v''"'
}

order HHID_panel INDID_panel name sex age jatis edulevel egoid loan_database loanamount

drop if HHID_panel==""
drop caste informal semiformal formal economic current humancap social house incomegen noincomegen economic_amount current_amount humancap_amount social_amount house_amount incomegen_amount noincomegen_amount informal_amount formal_amount semiformal_amount lender2 lender3 detailsloanbyborrower_count totalrepaid2 interestpaid2 principalpaid yratepaid monthlyinterestrate setofmarriagefinance setofmarriagegroup setofloansbyborrower setofdetailsloanbyborrower setofmainloans

save"$directory\CLEAN\NEEMSIS2-loans_v14", replace
****************************************
* END










****************************************
* Cleaning des fichiers CLEAN
****************************************
cd"$directory\CLEAN"
clear all
filelist, dir("$directory\CLEAN") pattern(*.dta)
gen tomove=0
gen todrop=0

*To move
split filename, p("-")
replace tomove=1 if filename2=="hhquestionnaire"
drop filename1 filename2 filename3 filename4 filename5 filename6
forvalues i=4(1)18{
replace tomove=1 if filename=="NEEMSIS2-HH_v`i'.dta"
}
replace tomove=1 if filename=="NEEMSIS_APPEND-generalinformation-lefthome.dta"
replace tomove=1 if filename=="NEEMSIS_APPEND-detailschitfunds.dta"
replace tomove=1 if filename=="NEEMSIS_APPEND-detailschitfunds_wide.dta"
replace tomove=1 if filename=="NEEMSIS_APPEND-detailsinsurance.dta"
replace tomove=1 if filename=="NEEMSIS_APPEND-detailsinsurance_wide.dta"
replace tomove=1 if filename=="NEEMSIS_APPEND-detailsloanbyborrower.dta"
replace tomove=1 if filename=="NEEMSIS_APPEND-detailssavingaccounts.dta"
replace tomove=1 if filename=="NEEMSIS_APPEND-detailssavingaccounts_wide.dta"
replace tomove=1 if filename=="NEEMSIS_APPEND-individualid.dta"
replace tomove=1 if filename=="NEEMSIS2-HH_v5_bis.dta"
replace tomove=1 if filename=="NEEMSIS2-HH_v5-_tocomp.dta"
replace tomove=1 if filename=="NEEMSIS_Agriculture_APPEND.dta"
replace tomove=1 if filename=="NEEMSIS_Agriculture_APPEND_v2.dta"
replace tomove=1 if filename=="NEEMSIS_Agriculture_APPEND_v3.dta"
forvalues i=1(1)13{
replace tomove=1 if filename=="NEEMSIS2-loans_v`i'.dta"
}
replace tomove=1 if filename=="NEEMSIS2-loans.dta"
foreach x in Agriculture APRIL DEC DECEMBER DEC_Agriculture DECEMBER_Agriculture FEB FEBRUARY FEB_NEW_Agriculture FEBRUARY_Agriculture LAST NEW_APRIL NEW_JUNE{
replace tomove=1 if filename=="NEEMSIS2_`x'.dta"
}
replace tomove=1 if filename=="NEEMSIS_APPEND-occupations.dta"
foreach i in 1 2 3 5 {
replace tomove=1 if filename=="NEEMSIS_APPEND-occupations_v`i'.dta"
}
replace tomove=1 if filename=="NEEMSIS_APPEND-salaried-infoemployer.dta"
replace tomove=1 if filename=="NEEMSIS_APPEND-remsentidgroup.dta"
replace tomove=1 if filename=="NEEMSIS_APPEND-remreceivedsourceidgroup.dta"
replace tomove=1 if filename=="NEEMSIS_APPEND-marriagegift.dta"
replace tomove=1 if filename=="NEEMSIS_APPEND-memberlistpreload2016.dta"
replace tomove=1 if filename=="NEEMSIS_APPEND-migrationjobidgroup.dta"
replace tomove=1 if filename=="NEEMSIS_APPEND-selfemploy-labourers-businesslabourers.dta"
replace tomove=1 if filename=="NEEMSIS_APPEND-marriagefinance.dta"

*To drop
replace todrop=1 if filename=="NEEMSIS_Agriculture_APPEND_merge1.dta"
replace todrop=1 if filename=="NEEMSIS_Agriculture_APPEND_merge23.dta"
replace todrop=1 if filename=="indiv2020.dta"
replace todrop=1 if filename=="indiv2020_temp.dta"
replace todrop=1 if filename=="indiv2020_temp2.dta"
replace todrop=1 if filename=="indiv2020_v2.dta"
replace todrop=1 if filename=="NEEMSIS_APPEND.dta"
replace todrop=1 if filename=="NEEMSIS_APPEND-occupations_v4_HH.dta"
replace todrop=1 if filename=="NEEMSIS_APPEND-occupations_v4_indiv.dta"
replace todrop=1 if filename=="NEEMSIS2-loans_v13_HH.dta"
replace todrop=1 if filename=="NEEMSIS2-loans_v13_indiv.dta"
replace todrop=1 if filename=="NEEMSIS_APPEND-remreceived_indiv.dta"

*Only one var
gen status=.
replace status=1 if tomove==0 & todrop==0
replace status=2 if tomove==1 & todrop==0
replace status=3 if tomove==0 & todrop==1
label define status 1"Work with" 2"To move" 3"To drop"
label values status
fre status

preserve
keep if status==2
tempfile myfiles
save "`myfiles'"
local obs=_N
forvalues i=1/`obs' {
	*set trace on
	use "`myfiles'" in `i', clear
	local f = filename
	use "$directory\CLEAN\\`f'", clear
	save "$directory\CLEAN\_tomove\\`f'", replace	
	erase "$directory\CLEAN\\`f'"
	tempfile save`i'
}
restore

preserve
keep if status==3
tempfile myfiles
save "`myfiles'"
local obs=_N
forvalues i=1/`obs' {
	*set trace on
	use "`myfiles'" in `i', clear
	local f = filename
	use "$directory\CLEAN\\`f'", clear
	save "$directory\CLEAN\_todrop\\`f'", replace	
	erase "$directory\CLEAN\\`f'"
	tempfile save`i'
}
restore
****************************************
* END
