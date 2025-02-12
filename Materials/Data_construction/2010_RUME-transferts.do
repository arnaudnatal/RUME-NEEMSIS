*-------------------------
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*-----
*Transferts construction
*-----
*-------------------------

********** Clear
clear all
macro drop _all

********** Path to working directory directory
global directory = "C:\Users\Arnaud\Documents\MEGA\Data\NEEMSIS-Construction"
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
* Remittances net
***************************************
use"$data", clear

egen remreceived_HH=rowtotal(remrectotalamount1 remrectotalamount2 remrectotalamount3)

egen remsent_indiv=rowtotal(remsenttotalamount1 remsenttotalamount2 remsenttotalamount3)
bysort HHID2010: egen remsent_HH=sum(remsent_indiv)
sort HHID2010 INDID2010

gen remittnet_HH=remreceived_HH-remsent_HH


keep HHID2010 remreceived_HH remsent_HH remittnet_HH
duplicates drop

*Pensions
preserve
use"RUME-occupations", clear
fre kindofwork
keep if kindofwork==9
bysort HHID2010: egen pension_HH=sum(annualincome)

keep HHID2010 pension_HH
duplicates drop
save"_temp/pensi", replace
restore

merge 1:1 HHID2010 using "_temp/pensi"
drop if _merge==2
drop _merge
recode pension_HH (.=0)

save"outcomes\RUME-transferts_HH", replace
****************************************
* END
