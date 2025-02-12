*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*October 30, 2024
*-----
*NEEMSIS-2 HH last clean
*-----
********** Clear
clear all
macro drop _all
********** Path to do
global dofile = "C:\Users\Arnaud\Documents\GitHub\odriis\NEEMSIS-2"
********** Path to working directory directory
global directory = "C:\Users\Arnaud\Documents\MEGA\Data\2020-NEEMSIS2\Data\4team"
cd"$directory"
********** Scheme
set scheme plotplain_v2
grstyle init
grstyle set plain, box nogrid
********** Split var
do"C:\Users\Arnaud\Documents\GitHub\odriis\NEEMSIS-2\splitvarmcq.do"
do"C:\Users\Arnaud\Documents\GitHub\odriis\NEEMSIS-2\newn.do"
do"C:\Users\Arnaud\Documents\GitHub\odriis\NEEMSIS-2\repmi.do"
********** Deflate
*https://data.worldbank.org/indicator/FP.CPI.TOTL?locations=IN
*(100/158) if year==2016
*(100/184) if year==2020
*-------------------------










****************************************
* Alters cleaning label et var
****************************************
use"Last\Lastlast\Corrected\Lastcorrection\NEEMSIS2-alters", clear

replace friend=0 if dummyfam==1 & friend==.
replace friend=0 if dummyhh==1 & friend==.

fre networkpurpose1
replace friend=0 if networkpurpose1==12 & friend==.
replace labourrelation=1 if networkpurpose1==3 & labourrelation==.

* Si prêteur = rela alors il n'est pas amis
* 11865 alters
preserve
use"Last\Lastlast\NEEMSIS2-loans_mainloans", clear
keep if loan_database=="FINANCE"
save"_temp", replace
restore

preserve
keep HHID2020 INDID2020 alterid friend loanid
drop if loanid==""
split loanid, p(,)
destring loanid1 loanid2 loanid3 loanid4 loanid5 loanid6 loanid7, replace
rename loanid loanidcomp
reshape long loanid, i(HHID2020 INDID2020 alterid) j(n)
drop if loanid==.
merge 1:1 HHID2020 INDID2020 loanid using "_temp", keepusing(loanlender)
keep if _merge==3
drop _merge
reshape wide loanid loanlender, i(HHID2020 INDID2020 alterid) j(n)
fre loanlender1
replace friend=0 if loanlender1==2 & friend==.
ta friend, m
ta loanlender1 if friend==.
keep HHID2020 INDID2020 alterid loanidcomp friend
rename loanidcomp loanid
rename friend friendloan
save"_temp2", replace
restore

ta networkpurpose1
merge 1:1 HHID2020 INDID2020 alterid loanid using "_temp2", keepusing(friendloan)
drop _merge
replace friend=friendloan if friend==. & friendloan!=.
drop friendloan
ta friend, m
ta networkpurpose1 if friend==.


*
fre networkpurpose1
* drop les 4 help asso sans friend
drop if networkpurpose1==5 & friend==.
* drop les thandal
ta networkpurpose1 if friend==.
drop if networkpurpose1==1 & friend==.


*
gen relative_network=cond( ///
networkpurpose1==12 | ///
networkpurpose2==12 | ///
networkpurpose3==12 | ///
networkpurpose4==12 | ///
networkpurpose5==12 | ///
networkpurpose6==12 | ///
networkpurpose7==12 | ///
networkpurpose8==12 | ///
networkpurpose9==12 | ///
networkpurpose10==12 | ///
networkpurpose11==12 | ///
networkpurpose12==12  ///
,1,0)
tab relative_network
*

ta relative_network friend
replace friend=0 if relative_network==1
drop relative_network




save "Last\Lastlast\Corrected\Lastcorrection\Lastlastcorrection\NEEMSIS2-alters", replace
****************************************
* END
