set more off

*use "C:\Users\CJ Nordman\Dropbox (IRD)\_Inde documents\_Projets_Recherche\_NEEMSIS\Data\Panel\Panel_occupations.dta", clear
use "C:\Users\Seb\Dropbox\NEEMSIS\Data\Panel\Panel_occupations.dta", clear


order villageid villagearea HHID HHINDID year sex age occupationid _2_c_occupation occupationname
sort villageid villagearea HHID HHINDID year occupationid


* check occup matching in balanced panel
replace occupationid=3 if _2_c_occupation=="AGRICULTURE COOLIE" & HHINDID=="ADEP42/1"
replace occupationid=1 if _2_c_occupation=="AGRICULTURE" & HHINDID=="ADEP42/1"
replace occupationid=2 if _2_c_occupation=="AGRICULTURE" & HHINDID=="RAKU150/1"
replace occupationid=2 if _2_c_occupation=="AGRI.COOLIE" & HHINDID=="RAKU150/2"
replace occupationid=2 if _2_c_occupation=="HOTEL WORK" & HHINDID=="RAKU150/3"
replace occupationid=3 if _2_c_occupation=="FLLOWER SHOP" & HHINDID=="SIEP63/2"
drop if HHINDID=="VENGP167/1" & _2_c_occupation=="HANDLOOM" & occupationid==2
replace occupationid=2 if _2_c_occupation=="NREGS" & HHINDID=="VENGP167/1"
drop if HHINDID=="VENGP167/2" & _2_c_occupation=="HANDLOOM" & occupationid==2
replace occupationid=2 if _2_c_occupation=="HELPER -COOKING" & HHINDID=="VENGP167/2"
drop if HHINDID=="VENGP167/5" & _2_c_occupation=="HANDLOOM" & occupationid==2

duplicates drop  HHINDID year occupationid, force

replace occupationid=1 if HHINDID=="PSKU132/2" & year==2010

********************************************************************************

* Main variables of panel 

********************************************************************************

** Generate Female variable
gen female=0
replace female=1 if sex==2
label var female "Female dummy"
label def female 0 "No" 1 "Yes"
label val female female


** dry/wet village
gen wet=(villageid==1|villageid==3|villageid==4|villageid==7|villageid==9)
lab var wet "Irrigated village dummy"
lab def wet 0"Dry" 1"Irrigated" 
label values wet wet
* wet: kar, orayur, manam: "semi agrarian settlements", wet lands, lots of agri
* ela, korator
* dry: man, sema: "peri urban settlements", close to roads, easy access towns
* gov,kuv, nat
gen village_type=0
replace village_type=1 if wet==1
lab def village_type 0"Dry" 1"Irrigated" 
label values village_type village_type
label var village_type "Village type"

**Village accessibility (distance from small dynamic cities, bus frequency, distance from main road, etc).
*****1: Good accessibility ; 2: Medium ; 3: Bad accessibility
gen village_access=.
replace village_access=1 if villageid==2 | villageid==6 | villageid==7 | villageid==10
replace village_access=2 if villageid==1 | villageid==5 | villageid==8 | villageid==9
replace village_access=3 if villageid==3 | villageid==4

label define village_access 1 "Good Accessibility" 2 "Medium Accessibility" 3 "Bad Accessibility"
label values village_access village_access
tab village_access, gen (village_access_)


*Cleaning caste
label define caste 2 "Paraiyar", modify
replace caste=2 if HHID=="PSKOR205" & caste==77  
replace caste=1 if HHID=="VENOR396" & caste==77  

gen dalit=0
replace dalit=1 if caste==2 | caste ==3
* SC (Paraiyar) & arunthathiyar
gen middlecaste=0
replace middlecaste=1 if caste==1 | caste ==5 | caste ==7 | caste ==8 | caste ==10| caste ==12| caste ==15| caste ==16
* vanniyar, gramani, navithar, asarai, nattar, Kulalar, muslims, padayachi
gen uppercaste=0
replace uppercaste=1 if caste==4 | caste ==6| caste ==9| caste ==11| caste ==13| caste ==17
* rediyar, naidu, settu, mudaliar, chettiyar, yathavar (category added during cleaning: not in castes list in questionnaire)




gen castecode=.
replace castecode=1 if dalit==1
replace castecode=2 if middlecaste==1
replace castecode=3 if uppercaste==1

label define castecode 1 "Dalit" 2 "Middle Caste" 3 "Upper Caste"
label values castecode castecode
label var castecode "Caste group"

**Caste realocation for 2 2010 HH with no castecode (77 other)
replace castecode=1 if castecode==. & HHID=="PSKOR205" // leaving in colony so realocated in Dalit 
replace castecode=2 if castecode==. & HHID=="VENOR396" //  realocated in middle caste because are "Vannan" clothes washer caste(Antoni)


**Age cat

gen age_cat=.
replace age_cat= 1 if age<15 & year==2010
replace age_cat= 2 if age>=15 & age<30 & year==2010
replace age_cat= 3 if age>=30 & age<50 & year==2010
replace age_cat= 4 if age>=50 & year==2010
label define agecat 1"<15 yo" 2 "15-29 yo" 3"30-49yo" 4">50yo"
label values age_cat agecat
label var age_cat "Age Category"


**age cat 2010
bys HHINDID: egen age_cat2010 = mean(age_cat)

gen age_cat3=. 
replace age_cat3= 1 if age<15 & year==2016
replace age_cat3= 2 if age>=15 & age<30 & year==2016
replace age_cat3= 3 if age>=30 & age<50 & year==2016
replace age_cat3= 4 if age>=50 & year==2016

**age cat 2016
bys HHINDID: egen age_cat2016 = mean(age_cat3)

replace age_cat=age_cat3 if year==2016
drop age_cat3

*age 2010-2016
bys HHINDID: egen age2010 = mean(age) if year==2010
bys HHINDID: egen age2016 = mean(age) if year==2016
bys HHINDID: egen age20102 = mean(age2010)
bys HHINDID: egen age20162 = mean(age2016) 

drop age2010 age2016
ren age20102 age2010
ren age20162 age2016

**Generate Age category detailed
gen age_cat2=.
replace age_cat2=1 if age<15
replace age_cat2=2 if age >=15 & age <25
replace age_cat2=3 if age >=25 & age <35
replace age_cat2=4 if age >=35 & age <50
replace age_cat2=5 if age >=50 & age <70
replace age_cat2=6 if age >=70
tab age_cat2 year, m
label define age_cat2 1"<15yo" 2"15-24yo" 3"25-34yo" 4"35-49yo" 5"50-69yo" 6">70yo"
label values age_cat2 age_cat2
label var age_cat2 "Age category detailed"


*ego 2010-2016
bys HHINDID: egen egoid2 = mean(egoid) 

*******************************************************************************

* Job location

*******************************************************************************

	**cleaning (3 HH with "-5" as distance)
replace jobdistance=5 if jobdistance<0
	
	**Distance occupation code
tab jobdistance 
tab joblocation


****2016
********

gen joblocationcode=. 
*Same Village
replace joblocationcode=1 if  joblocation=="*Same village" | joblocation==".Same village" | joblocation=="House itself" | ///
joblocation=="Own" | joblocation=="Same Village" | joblocation=="Same and nearest village" | joblocation=="Same and nearest villages"| joblocation=="Same and neighbour village"| ///
joblocation=="Same house" | joblocation=="Same vilage" |joblocation=="Same village" | joblocation=="Same village"  | joblocation=="Same village (Family house)" | ///
joblocation=="Same village (Semakottai)" | joblocation=="Same village (family house)" | joblocation=="Same village ,outside the village" | joblocation=="Same village and Sandi, Patti Kogan," | ///
joblocation=="Same village and near by village" | joblocation=="Same village and nearest" | joblocation=="Same village and nearest villages" | joblocation=="Same village and outside village in Tamil Nadu" | ///
joblocation=="Same village and semakotrai" | joblocation=="Same village(thotti)" | joblocation=="Same village, around thé village" | joblocation=="Same village, family land"| ///
joblocation=="Same village, oriyur," | joblocation=="Same village, outside the village" | joblocation=="Same village, perumpakkam" | joblocation=="Same village, sevalai, perumpakkam" | ///
joblocation=="Same village, veloor" | joblocation=="Same village, velore" | joblocation=="Same village,around thé village" | joblocation=="Same village,around thé village,big cities"| ///
joblocation=="Same village,cuddalore,panruti,villupuram" | joblocation=="Same village,outside the village" | joblocation=="Same village,outside thé village" | joblocation=="Same village,own house" | ///
joblocation=="Same villages" | joblocation=="Same villages and nearest villages" | joblocation=="Same villgae" | joblocation=="Same villlage" | joblocation=="Same vllage" | ///
joblocation=="Samebvillage" | joblocation=="Samevillage" | joblocation=="Samvillage" | joblocation=="Semé village" | joblocation=="Spam chamber, maampakkam , walaja" | ///
joblocation=="Spam, maampakkam" |joblocation=="Spm chamber, mampakkam" | joblocation=="Same" | joblocation=="Same village "
*Around Villages
replace joblocationcode=2 if joblocation=="Angucheti palayam" | joblocation=="Anguchetti palayam, manam thavizhntha puthur" | joblocation=="Anguchettipalayam, Nathan, manapakkam" | joblocation=="Anna gramam" | ///
 joblocation=="Around village" | joblocation=="Around villages" | joblocation=="C hinna elanthampattu" | joblocation=="Govulapuram" | joblocation=="In and around the village" | ///
 joblocation=="In and around village" | joblocation=="Karumbur" | joblocation=="Karumbur, seven hills PRIVATE school" | joblocation=="Karumbur,oraiyur" | joblocation=="Karumpur,oraiyur" | ///
 joblocation=="Kovulapuram" | joblocation=="Local" | joblocation=="Local area and puducherry" | joblocation=="Local areas" | joblocation=="Local water channels" | ///
 joblocation=="Local, tricky, tanjavur, dindigul" | joblocation=="Madras, Same village" | joblocation=="Manamazhthaputhur" | joblocation=="Manamthavhizhaputtur, Ponnian kuppam" | ///
 joblocation=="Manamthavizhinthaputhur" | joblocation=="Manamthavizhnthaputhur" | joblocation=="Manamthavizhthaputhur" | joblocation=="Mananavinthaputhur" | ///
 joblocation=="Manapakkam" | joblocation=="Manapakkam, anguchettipalayam,natham" | joblocation=="Manavinthaputhur" | joblocation=="Mannapakkam, semakottai" | joblocation=="NATHAM main road" | ///
 joblocation=="NATHAN LAKE" | joblocation=="Near by villages" | joblocation=="Nearby villages" | joblocation=="Nearest channels" | joblocation=="Nearest lake and channels" | ///
 joblocation=="Nearest villages" | joblocation=="Oraiyur" | joblocation=="Oraiyur,karumbur,manapakkam" | joblocation=="Oraiyur,karumpur" | joblocation=="Oraiyur,natham,panruti,cuddalore,pondicherry" | ///
 joblocation=="Orayur" | joblocation=="Orayur agri.field" | joblocation=="Orayur lake (palapttu road)" | joblocation=="Oriyur" | joblocation=="Outside the village" | ///
 joblocation=="Outside thé village" | joblocation=="Sarounded area" | joblocation=="Sarounded area and panruti" | joblocation=="Sarounded areas" | joblocation=="Sarounded villages" | ///
 joblocation=="Sarounding areas" | joblocation=="Sarouned villages" | joblocation=="Sarouned villages ad panruti" | joblocation=="Semakkottai" | joblocation=="Semakottai" | ///
 joblocation=="Semakottai, Manapakkam" | joblocation=="Semakottai, manapakkam" | joblocation=="Surrounded areas" | joblocation=="Surrounded villages" | joblocation=="Surrounding" | ///
 joblocation=="Surrounding area" | joblocation=="Surrounding village" | joblocation=="Thotti" | joblocation=="Thotti (kuvagam)" | joblocation=="Kadampuliyur" | ///
 joblocation=="Kadapuliyur" | joblocation=="Kandamangalam" | joblocation=="Kandamangallam" | joblocation=="Natham" | joblocation=="Vaiyapuripattinam" | ///
 joblocation=="Chitra chavade" | joblocation=="Kallakurichi" | joblocation=="Kuvagam village" | joblocation=="Madagadipet, puducherry" | joblocation=="Madakadipattu" | ///
 joblocation=="Manpakkam" | joblocation=="Thirubuvanai,pondicherry" | joblocation=="Thiruvennainallur" | joblocation=="Nalli kuppam" | joblocation=="Nellikuppam" | ///
 joblocation=="Periya sevalai" | joblocation=="Periyasevalai" | joblocation=="Tirukovilur, kallakurichi, salem" | joblocation=="Thirukovilur"
 *Rural area in Tamil Nadu
replace joblocationcode=3 if joblocation=="Aalur, villiyampakkam" | joblocation=="Aavadi" | joblocation=="Aavadi,chennai" | joblocation=="All other cities in Tamil nadu" | ///
 joblocation=="Ambatur (Chennai)" | joblocation=="Anathur" | joblocation=="Around Chengalpet" | joblocation=="Around chengalpet" | joblocation=="B.A.B chamber villiyampakkam, near Athurre" | ///
 joblocation=="B.A.B chamber, villiyampakkam, near athur" | joblocation=="B.A.B chamber, villiyampakkam, near athure" | joblocation=="BAB chamber" | ///
 joblocation=="BAB chamber, villiyampakkam, near Aathur" | joblocation=="Chengalpattu" | joblocation=="Chengalpet" | joblocation=="Chengalpet, waalaja" | joblocation=="Chennai , maangadu" | ///
 joblocation=="Chennai aavadi camp" | joblocation=="Chennai and local" | joblocation=="Chennai, Aavadi_Pakkam" | joblocation=="Kanchipuram" | joblocation=="Kanjepuram" | joblocation=="Kanjipuram" | ///
 joblocation=="P aalur, konanjeri" | joblocation=="P aalur, villiampakkam" | joblocation=="P aalur, villiampakkam," | joblocation=="Paakkam , chennai" | joblocation=="Paakkam, aavadi, chennai" | ///
 joblocation=="Paakkam,aavadi,chennai" | joblocation=="Paalur" | joblocation=="Paalur, villiyampakkam" | joblocation=="Paalur,villiyampakkam" | joblocation=="Pakkam, chennai" | ///
 joblocation=="Pallur,villiyampakkam" | joblocation=="Palur, villiyambakkam" | joblocation=="TKS,Chennai" | joblocation=="Tandayarpet (Chennai)" | joblocation=="Thipapliyur" | ///
 joblocation=="Thirpur" | joblocation=="Thirupur" | joblocation=="Viliyambakkam" | joblocation=="Villiambakkam" | joblocation=="Villiampaakkam" | ///
 joblocation=="Villiampaakkam VGN chamber" | joblocation=="Villiampakkam" | joblocation=="Villiampakkam BAB chamber" | joblocation=="Villiampakkam, near aathur" | ///
 joblocation=="Villivakkam, chennai" | joblocation=="Villivakkam,chennai" | joblocation=="Villiyambakkam" | joblocation=="Villiyambakkam, chengalpet" | ///
 joblocation=="Villiyampakkam" | joblocation=="Villiyampakkam chamber" | joblocation=="Villiyampakkam, near Aathur" | joblocation=="Chennai, mangadu" | ///
 joblocation=="Chennai, oragadam" | joblocation=="Chinna pudur" | joblocation=="DJS chamber works" | joblocation=="DJS chamber works(chennai)" | ///
 joblocation=="EBW, chamber, chamber" | joblocation=="Jeevajothi chamber, sembarambakkam" | joblocation=="Kumbakonam, Tangore" | joblocation=="Kumbakonam, tanjore" | ///
 joblocation=="TKS, chennai" | joblocation=="Walaja" | joblocation=="Walaja l.s.chamber" | joblocation=="Ponnikuppam, manapakkam" | joblocation=="Poonamalli,chennai" | ///
 joblocation=="Pudhupettai" | joblocation=="Puducottai" | joblocation=="Pudupettai" | joblocation=="Pudupettai, Panruti" | joblocation=="SENTHAMANGALAM" | ///
 joblocation=="Sembarampaakkam" | joblocation=="Sembarampaakkam, jeevajothi chamber" | joblocation=="Sembarampakkam" | joblocation=="ekkattuthangal,chennai" | joblocation=="Kadivetti" | ///
 joblocation=="Karimaruyham patti" | joblocation=="Kolapakkam" | joblocation=="Ksnjipuram" | joblocation=="Kumudipundi" | joblocation=="L.s chamber,chengalpet" | ///
 joblocation=="Marthandam, Chennai, thiruchi" | joblocation=="Mettukuppam" | joblocation=="Naavapalayam" | joblocation=="Thiruchi" | joblocation=="Thirukanur" | ///
 joblocation=="Thittakudi,virudhachalam" | joblocation=="Tiruvanmayur,chennai" | joblocation=="Tiruvannamalai, Chennai, bangalore" | ///
 joblocation=="V.G.N Chamber, villiyambakkam, chengalpet" | joblocation=="VSK chamber" | joblocation=="Vadamangalam(puducherry)" | joblocation=="Napalayam" | joblocation=="Osur" | ///
 joblocation=="Pallapalayam" | joblocation=="Panorama sivan palayam, salem district" | joblocation=="Sengundram" | joblocation=="Siruvathur" | joblocation=="Siruvathur, anguchettipalayam" | ///
 joblocation=="Sivaliyankulam, aavadi" | joblocation=="Somanur" | joblocation=="Somanur, thirupur" | joblocation=="Sriperumbuthur" | joblocation=="Sriperumputhur" | ///
 joblocation=="Per Periyankupam" | joblocation=="Periyakulam" | joblocation=="Ponnankuppam" | joblocation=="Reddipalayam, chengalpattu" | joblocation=="Sevalai, t.k.lur" | ///
 joblocation=="Shanmugapuram" | joblocation=="EBW, chamber, P aalur, villiambakkam" | | joblocation==" EBW, chamber, P aalur, villiambakkam" 
 *Small town of the area (Panruti, Cuddalore, Villupuram, etc.)
replace joblocationcode=4 if joblocation=="Cuddalore" | joblocation=="Cuddalore district" | joblocation=="Cuddalore, Pondichéry" | joblocation=="Cuddalore, panruti" | ///
 joblocation=="Panruti" | joblocation=="Panruti and around villages" | joblocation=="Panruti and nearest villages" | joblocation=="Panruti and sarounded area" | ///
 joblocation=="Panruti, Cuddalore, Manapakkam" | joblocation=="Panruti, Cuddalore, Manapakkam, Semakottai" | joblocation=="Panruti, Cuddalore, Pondichery" | joblocation=="Panruti, Nellikuppam, Neyvely" | ///
 joblocation=="Panruti, and festival times needed" | joblocation=="Panruti, cuddalore" | joblocation=="Panruti, pondicherry, villupuram" | joblocation=="Panruti, pondy, chennai" | ///
 joblocation=="Panruti, viruthachalam" | joblocation=="Panruti, vizhupuranm, pondy" | joblocation=="Panruti,a.c.palayam" | joblocation=="Panruti,ccuddalore" | ///
 joblocation=="Panruti,cuddalore" | joblocation=="Panruti,cuddalore,villupuram" | joblocation=="Panruti,cuddalore,villupuram,chennai." | joblocation=="Panruti,vim,Cuddalore" | ///
 joblocation=="Panruti,vpm,pry ,Cuddalore" | joblocation=="Pondy, cuddalore, panruti, villupuram" | joblocation=="Tindivanam" | joblocation=="Villupuram" | joblocation=="panruti" | ///
 joblocation=="Chennai, Villupuram, Cudalore, Panruti" | joblocation=="Chennai,pondicherry,cuddalore,ect.," | joblocation=="Ulunderpettai" | joblocation=="Ulundurpet" | joblocation=="Ulundurpettai" | ///
 joblocation=="Ulunthurepettai" | joblocation=="Ulunthurpet" | joblocation=="Vizhupuram" | joblocation=="Kudikaadu, Cuddalore" | joblocation=="Naivali" | ///
 joblocation=="Neyveli" | joblocation=="Sibcat Cuddalore" 
*Big cities of Tamil Nadu (Chennai, Pondicherry, Madurai, etc.)
 replace joblocationcode=5 if joblocation=="0Chennai" | joblocation=="Channai" | joblocation=="Coimbatore" | joblocation=="Madugarai" | joblocation=="Madurai" | ///
 joblocation=="Pondicherry" | joblocation=="Pondicherry,cuddalore,panruti" | joblocation=="Pondichery Bahour" | joblocation=="Ponds, cuddalore, thiruvannamalai" | ///
 joblocation=="Pondy, Bangalore and all over Tamil nadu" | joblocation=="Puducherry" | joblocation=="Chennai" | joblocation=="Tirupur" | ///
 joblocation=="Velacherry, chennai" | joblocation=="Palakadu, salem district" | joblocation=="Peniya Pudur, salem district" | joblocation=="Peniya pudur, salem district" | ///
 joblocation=="Perambur,chennai" | joblocation=="Salem"
*Outside TN
replace joblocationcode=6 if joblocation=="Bangalor" | joblocation=="Bangalore" | joblocation=="Bangalore ,tamilnadu,Andhra" | joblocation=="Bengaluru" | joblocation=="Delhi" | ///
 joblocation=="Karala" | joblocation=="Kerala" | joblocation=="Kerala(aluva pipeline, ernakulam)" | joblocation=="Kerla" | joblocation=="Kozhikode" 
 *Abroad
replace joblocationcode=7 if joblocation=="Etaly" | joblocation=="Gutar" | joblocation=="Bahrain" | joblocation=="Mascut" | joblocation=="Quatar"
 


****2010
********

tab _23_1_b_where
*Same Village
replace joblocationcode=1 if _23_1_b_where=="SAME VILLAGE" |  _23_1_b_where=="WITHIN THE VILLAGE"
*Around Villages
replace joblocationcode=2 if _23_1_b_where=="AROUND VILLAGE" | _23_1_b_where=="ANATHUR" | _23_1_b_where=="ANNAGIRAMAM" | _23_1_b_where=="BAHUR" | _23_1_b_where=="KALLAKURICHI" | ///
 _23_1_b_where=="OUTSIDE THE VILLAGE" | _23_1_b_where=="PANRUTTI AND AROUND VILLAGES" | _23_1_b_where=="ULUNDHURPETTAI" | _23_1_b_where=="ULUNDOORPETTAI" | ///
  _23_1_b_where=="THIRUKOVILUR" | _23_1_b_where=="THIRUGOVILUR" | _23_1_b_where=="THIRUBUVANAI" | _23_1_b_where=="SEVALAI" | _23_1_b_where=="NELLIKUPPAM" | ///
   _23_1_b_where=="KULLANCHAVADI" | _23_1_b_where=="KULLANCHAVI" | _23_1_b_where=="ORAIYUR" | _23_1_b_where=="ELANTHAMPATTU" | _23_1_b_where=="NATHAM, PERUMPAKKAM" | ///
   _23_1_b_where=="MADAPATTU" | _23_1_b_where=="AC PALAYAM"
*Rural area in Tamil Nadu
replace joblocationcode=3 if _23_1_b_where=="CHENGALPATTU" | _23_1_b_where=="CHENGALPET"  | _23_1_b_where=="THIRUVARURE" | _23_1_b_where=="TAMIL NADU" | _23_1_b_where=="SIRKALI" | ///
 _23_1_b_where=="SENGALPATTU" | _23_1_b_where=="SEERKAZHI" | _23_1_b_where=="PUDHUPETTAI" | _23_1_b_where=="PUDHUKOTTAI" | _23_1_b_where=="PATTUKOTTAI" | _23_1_b_where=="OOTY" | ///
  _23_1_b_where=="NO LIMITATION" | _23_1_b_where=="KUMBAGONAM" | _23_1_b_where=="KUMBAKONAM" | _23_1_b_where=="KUMARAMANGALAM" | _23_1_b_where=="PALOORE" | ///
  _23_1_b_where=="MANNARKUDI" | _23_1_b_where=="MAYAVARAM" | _23_1_b_where=="MEENJURE" | _23_1_b_where=="NAMAKKAL" | _23_1_b_where=="KURINJIBADI"
*Small town of the area (Panruti, Cuddalore, Villupuram, etc.)
replace joblocationcode=4 if _23_1_b_where=="CUDDALORE" | _23_1_b_where=="CUDDALORE ,CHENNAI" | _23_1_b_where=="PANRUTTI" | _23_1_b_where=="PONDICHERRY, CUDDALORE, VILLUPURAM" | ///
 _23_1_b_where=="PONDICHERRY, VILLUPURAM, PANRUTI" | _23_1_b_where=="PANRUTTI, VILLUPURAM, PONDICHERRY" | _23_1_b_where=="VILLUPURAM, CUDDALORE, PONDICHERRY" | ///
 _23_1_b_where=="VILLUPURAM, PONRUTI, PONDICHERRY" | _23_1_b_where=="PONDICHERRY, CHENNAI, VILLUPURAM" | _23_1_b_where=="VILLUPURAM"
*Big cities of Tamil Nadu (Chennai, Pondicherry, Madurai, etc.)
replace joblocationcode=5 if _23_1_b_where=="TRICHY" | _23_1_b_where=="TANJORE" | _23_1_b_where=="PONDICHERRY" | _23_1_b_where=="CHENNAI" | _23_1_b_where=="CHENNAI TO MUMBAI" | ///
 _23_1_b_where== "ERODE" | _23_1_b_where=="THIRUCHI" | _23_1_b_where=="SELAM"
*Outside TN
replace joblocationcode=6 if _23_1_b_where=="BANGALORE" | _23_1_b_where=="KERALA" | _23_1_b_where=="DELHI" | _23_1_b_where=="MUMBAI" | _23_1_b_where=="PERAVORANI" | /// 
 _23_1_b_where=="THINELVELY"
*Abroad
replace joblocationcode=7 if _23_1_b_where== "GULF COUNTRY" | _23_1_b_where== "BEHREIN"


	**No Job Location for some occuption: 330obs for 2016 (163 Agri and 167 Self-employed) & 444obs for 2010
bys year: tab occupationname if joblocationcode==.


 
		**For "Cultivators" & "Self-employed" no location... 
			*Job locations for "Cultivators" are reallocated in "same village" ; 
			*Job locations for "Self-employment" are reallocated according to their job name (-->based on my own opinion...)
	
	*SAME VILLAGE
replace joblocationcode=1 if joblocationcode==. & kindofwork==1
replace joblocationcode=1 if joblocationcode==. & year==2010 & occupationid!=.
replace joblocationcode=1 if occupationname=="AGRI" | occupationname=="AGRI BUSINESS" | occupationname=="AGRI CULTURE" | occupationname=="AGRICULTURE" | occupationname=="CHAIR BUSINESS" | /// 
 occupationname=="CLAY STOVE" | occupationname=="CLAY TOY" | occupationname=="CLAY TOY MAKING" | occupationname=="CLAY TOY SALE" | occupationname=="COW REARING" | ///
 occupationname=="Cattle rearing (milk production)" | occupationname=="Chicken centre" | occupationname=="Chicken rearing" | occupationname=="Clay toys maker" | occupationname=="Clay toys making"| ///
 occupationname=="Cow rearing" | occupationname=="Cow rearing  (milk selling)" | occupationname=="Doll making" | occupationname=="FANCY STORE" | occupationname=="FRUIT BUSINESS" | ///
 occupationname=="FRUIT PRODUCTION" | occupationname=="FRUIT SELLING" | occupationname=="FRUIT SHOP" | occupationname=="Fancy store (self-employment)" | occupationname=="Fish seller" | ///
 occupationname=="FISH SELLING" | occupationname=="Fish selling" | occupationname=="Fish vendor" | occupationname=="Fruit seller" | occupationname=="GENERAL STORE" | occupationname=="GROCERY SHOP" | ///
 occupationname=="GROSORY SHOP" | occupationname=="GROSSARY SHOP" | occupationname=="Gouva selling" | occupationname=="Gouva selling (self business)" | occupationname=="Grocery shop" | occupationname=="HANDLOOM" | ///
 occupationname=="HANDLOOMING" | occupationname=="HANLOOM" | occupationname=="Hand looming" | occupationname=="Handloom weaving agent" | occupationname=="Handloom weaving business" | ///
 occupationname=="Handloom weaving work" | occupationname=="Handloom work" | occupationname=="Horoscope" | occupationname=="IDLY SHOP" | occupationname=="IRNING CLOTHES" | ///
 occupationname=="Idli Shop" | occupationname=="Idly Shop" | occupationname=="JOSIYAM (CLAIVOYANT)" | occupationname=="Josiyam" | occupationname=="Josiyam parthal" | occupationname=="Josyam(self employment)" | ///
 occupationname=="MILK BUSINESS" | occupationname=="Milk productin" | occupationname=="Milk vendor" | occupationname=="Mobile tea selling" | occupationname=="NREGA" | occupationname=="NREGS" | ////
 occupationname=="PENTIONER" | occupationname=="PETTI SHOP" | occupationname=="PETTY SHOP" | occupationname=="PLOUGHING" | occupationname=="POT MAKING" | occupationname=="Petti shop" | ///
 occupationname=="Petti shop owner" | occupationname=="Petty shop" | occupationname=="Pot making" | occupationname=="Pottery making" | occupationname=="Pottory" | occupationname=="Rice selling" | ///
 occupationname=="SHOE MAKER" | occupationname=="STRAW BUSINESS" | occupationname=="Sculpture" | occupationname=="Sculpture (SELF business)" | occupationname=="Shop keeper" | occupationname=="TAILOR" | ///
 occupationname=="TAILORING" | occupationname=="TAILORING COOLIE" | occupationname=="TAMERIEND SEED BUSINESS" | occupationname=="TEA SHOP" | occupationname=="TEA STALL" | occupationname=="TYLERING" | ///
 occupationname=="Tailor" | occupationname=="Tailor (in home)" | occupationname=="Tailoring" | occupationname=="Tailoring work" | occupationname=="Tamarind seed business" | occupationname=="Tea and tiffan shop" | ///
 occupationname== "Tea shop ,mini hotel" | occupationname=="Tea stall" | occupationname=="Toys making" | occupationname=="Tyloring"| occupationname=="WELDING" | occupationname=="AGRI COOLI" | ///
 occupationname=="AGRI COOLIE" | occupationname=="AGRI.COOLIE" | occupationname=="AGRICULTURE COOLIE" | occupationname=="Idly shop" | occupationname=="Thari" | occupationname=="Tea stall with small petty shop" | ///
 occupationname=="Petti Shop,recharge, water cane sales" | occupationname=="Josiyam partial ( Samiyar )" | occupationname=="Biriyany and fast food centre" | occupationname=="Bar bar shop house itself"
	
	*Around Villages
replace joblocationcode=2 if occupationname=="Agri.sprayer machine" | occupationname=="Auto Driver (self-employed)" | occupationname=="Auto driving (own auto)" | ///
 occupationname=="BULLACAT" | occupationname=="BULLCART" | occupationname=="BULLOCART" | occupationname=="BULLOCCART" | occupationname=="BULLOCKCART" | occupationname=="Bullock cart" | ///
 occupationname=="Bullock cart business" | occupationname=="Bullock rider" | occupationname=="Bullockart" | occupationname=="Bulluck cart" | occupationname=="CARPENTAR" | occupationname=="CARPENTER" | ///
 occupationname=="CENTRING WORK (CONSTRUCTION)" | occupationname=="CONSTRUCTION" | occupationname=="CONSTRUCTION MAISTRY" | occupationname=="CONSTRUCTION WORK" | occupationname=="COOK" | ///
 occupationname=="COOLIE" | occupationname=="CORPENTOR" | occupationname=="CYCLE STORE" | occupationname=="Carpentor" | occupationname=="Cooking work" | occupationname=="Cycles services  shop" | ///
 occupationname=="DRIVER" | occupationname=="DRIVING" | occupationname=="Driver (own vehicle)" | occupationname=="Drums beating" | occupationname=="Drums beetter on death ceremonies" | occupationname=="ELECTRICIAN" | ///
 occupationname=="Elactetion work" | occupationname=="Electrician" | occupationname=="FLLOWER SHOP" | occupationname=="FLOOWER SHOP WORK" | occupationname=="GOODS CARRIER (TATA ACE)self business" | ///
 occupationname=="HOTEL" | occupationname=="HOTEL BUSINESS" | occupationname=="JUTE BAG BUSINES" | occupationname=="JUTE BAG BUSINESS" | occupationname=="JUTEBAG BUSINESS" | occupationname=="MASON" | ///
 occupationname=="MECHANIC" | occupationname=="MECHANIC WORK"| occupationname=="Mason maistry" | occupationname=="Money lending" | occupationname=="Old Paper and jute bags businesses" | ///
 occupationname=="Old jute bag business" | occupationname=="Old paper and jute bag business" | occupationname=="Own Xerox shop" | occupationname=="Own plugging machine driver" | ///
 occupationname=="PVT.SCHOOL TEACHER" | occupationname=="Pesticide spray machine rent" | occupationname=="Petrol seller" | occupationname=="SELF-POWER TILLER" | occupationname=="Salt seller" | ///
 occupationname=="TEMPO DRIVER" | occupationname=="TEMPO TRAVEL OWNER" | occupationname=="THAPPU ADITHAL (DRUMER)" | occupationname=="TOOK FISH POND LEASE" | occupationname=="TRACKTER OWN" | ///
 occupationname=="TRACTOR" | occupationname=="TRACTOR driver" | occupationname=="TRAINING TEACHER" | occupationname=="TV MECHANIC" | occupationname=="Taxi driving (own)" | occupationname=="Toys selling" | ///
 occupationname=="Tractor buying broker" | occupationname=="Tractor driver" | occupationname=="Tv and electronic service man" | occupationname=="Tv mechanic self employed" | ///
 occupationname=="VEGETABLE SELLING" | occupationname=="Vegetable seller" | occupationname=="Vessels rental shop"  | occupationname=="WASHERMAN" | occupationname=="WASTE PAPER BUSINESS" | ///
 occupationname=="WASTER PAPER BUSINESS" | occupationname=="Water cane business" | occupationname=="Goods transport (tata ace) self business" | occupationname=="Thavil vidvan" | ///
 occupationname=="Jute bag and tamarind seeds collection and sales" | occupationname=="NATURAL MANURE BUSINESS (fertilisant business)" | occupationname=="Scarab business" | occupationname=="Koil molam" | ///
 occupationname=="Own vegetables shop" | occupationname=="Shop rent collection"
	
	*Rural area TN
replace joblocationcode=3 if occupationname=="BRICK WORK" | occupationname=="CHAMBER" | occupationname=="CHAMBER MAISTRY" | occupationname=="CHAMBER OWN" | occupationname=="CHAMBER WORK" | ///
 occupationname=="Chamber" | occupationname=="LORRY DRIVER" | occupationname=="Lorry hiring" | occupationname=="Lorry transport" | occupationname=="MAISTHRI" | occupationname=="Meat shop" | ///
 occupationname=="OwnLorry load business" | occupationname=="Pottery selling (migration)" | occupationname=="SUGARCANE CUTTING" | occupationname=="SUGARCANE MAISTHRI" | ///
 occupationname=="Sugar cane Cutting" | occupationname=="Sugar cane Cutting maistry" | occupationname=="Sugarcane cutting -Maistri" | occupationname=="Sugarcane cutting maistri" | ///
 occupationname=="Tractor hiring" | occupationname=="Tractor vendor" | occupationname=="Transport business" | occupationname=="Brickling maistry" | ///
 occupationname=="Travels" | occupationname=="VAN DRIVER" | occupationname=="Truck driver (own)" | occupationname=="Maistry (contractor)"
	
	*Small local towns
replace joblocationcode=4 if occupationname=="Agriculture equipment seller" | occupationname=="Agriculture tractor and equipment" | occupationname=="BANK WATCHMAN" | ///
 occupationname=="BUS CONDUCTOR" | occupationname=="CAVERING JEWEL BUSINES" | occupationname=="COOLIE IN CENIMA THEATRE" | occupationname=="COOPERATIVE BANK WORKER" | occupationname=="COTTON BUSINESS" | ///
 occupationname=="CRISTAL BUSINESS" | occupationname=="CROPS BUSINESS" | occupationname=="ENGINEER BUILDING CONSTRUCTION" | occupationname=="GOVT.JOB" | occupationname=="Meat shop" | occupationname=="WATCHMAN" | ///
 occupationname=="PRIVATE COMPANY" | occupationname=="PVT.CO" | occupationname=="PVT.COMPANY" | occupationname=="Advocats"  
	
	*Big cities of Tamil Nadu (Chennai, Pondicherry, Madurai, etc.)
replace joblocationcode=5 if occupationname=="A/C Mechanic Own Shop at Chennai" 

*Label jobdistcancecode
label define joblocationcode 1 "Same village" 2 "Around Villages" 3 "Rural area in Tamil Nadu" 4 "Small town of the area" 5 "Big cities of TN" 6 "Outside TN" 7 "Abroad" 
label values joblocationcode joblocationcode


	**New codage with less categories: 1 "Local Area" 2 "Rural TN" 3 "Towns & Cities TN" 4 "Outside TN"
**joblocationcode2

gen joblocationcode2=.
	
	*"Local Area": Same village & Around villages
replace joblocationcode2=1 if joblocationcode==1 | joblocationcode==2
	
	*"Rural TN"
replace joblocationcode2=2 if joblocationcode==3
	
	*"Towns & Cities TN": Small town of the area (Panruti, Cuddalore, Villupuram, etc.) & Big cities of Tamil Nadu (Chennai, Pondicherry, Madurai, etc.) 
replace joblocationcode2=3 if joblocationcode==4 | joblocationcode==5
	
	*"Outside TN": Outside TN & Abroad
replace joblocationcode2=4 if joblocationcode==6 | joblocationcode==7 
*Label jobdistcancecode2
label define joblocationcode2 1 "Local Area" 2 "Rural TN" 3 "Towns & Cities TN" 4 "Outside TN"
label values joblocationcode2 joblocationcode2

**STATS Job Distance
tab joblocationcode
tab joblocationcode castecode, col
bys year: tab joblocationcode castecode, col
tab joblocationcode2 year, col
tab joblocationcode year if occupationid!=., m col


*******************************************************************************

* Occupation categories

*******************************************************************************

	*2016
	
	gen occup_sector= .
			
	* cultivators
	
	replace  occup_sector= 11 if  occupationname == "Agriculture (own land )" |  occupationname == "Own agriculture (Lease land)" ///
	|  occupationname == "Agriculture (Own land)" |  occupationname == "Agriculture  (own land )"|  occupationname == "Agriculture Own land" ///
	|  occupationname == "Agriculture in own land"|  occupationname == "Agticulture" |  occupationname == "Agriculture (Own Land)" ///
	|  occupationname == "Agriculture ( own land)" |  occupationname == "Agriculture Own Land"|  occupationname == "Agriculture (own)" ///
	|  occupationname == "Agriculture coolie (own land)" 	|  occupationname == "Agriculture coolie own land"|  occupationname == "Own land Agriculture" ///
	|  occupationname == "Agriculture in family land"|  occupationname == ".Agriculture" |  occupationname == "Agriculture own farm" ///
	|  occupationname == "Agriculture (lease Land)" |  occupationname == "Agriculture lease land" |  occupationname == "Agri in own form" ///
	|  occupationname == "Agriculture(lease land)"|  occupationname == "Agriculture own Land" |  occupationname == "Agriculture on own land" ///
	|  occupationname == "Agriculture own" |  occupationname == "Agri own" ///
	| occupationname == "Agriculture assistance for her husband" |  occupationname == "Agriculture Assistance for her husband" ///
	|  occupationname == "Agriculture assisting his father" |  occupationname == "Agriculture Assistance in her husband" ///
	|  occupationname == "Agriculture Assistance  in her husband" |  occupationname == "Agriculture Assistance to her husband" ///
	|  occupationname == "Agriculture assisting her husband" |  occupationname == "Agriculture support in her husband" |  occupationname == "Agriculture to support her husband" ///
	|  occupationname == "Agriculture assisting his son" |  occupationname == "Agriculture in support to his mother" |  occupationname == "Agriculture own Land(unpaid)" ///
	|  occupationname == "Agriculture own land (unpaid)" |  occupationname == "Agriculture own Land (unpaid)"|  occupationname == "Agriculture (own Land)unpaid" ///
	|  occupationname == "Agriculture (own Land) unpaid" |  occupationname == "Agriculture Assistance for her father..." ///
	|  occupationname == "Agriculture Assistance for his father" |  occupationname == "Agriculture to support his father" ///
	|  occupationname == "Agriculture lease land(unpaid worker)"|  occupationname == "Agriculture (unpaid worker)" |  occupationname == "Agriculture  (unpaid )" ///
	|  occupationname == "Agriculture  (unpaid)" |  occupationname == "Agriculture (unpaid)" |  occupationname == "Agriculture own land" |  occupationname == "Agriculture(own land)" ///
	|  occupationname == "Agriculture (own land)" |  occupationname== "Agriculture (lease land)" |  occupationname == "Agriculture" |  occupationname == "Own agriculture" ///
	|  occupationname == "Agriculture unpaid" |  occupationname == "Agriculture in own farm" |  occupationname == "Agriculture (own Land)" |  occupationname == "Agriculture  (own land)" ///
	|  occupationname == "Own agriculture (unpaid)" |  occupationname == "Own agriculture lease land(unpaid)" |  occupationname == "Agriculture Assistance for her father in law" ///
	|  occupationname == "Agriculture (own Land)" 
	
	
	* above job on own/leased land but are unpaid because agri family income only on one household member

	
	* Agricultural labourers
	
	replace  occup_sector= 12  if  occupationname== "Agri Coolie" |  occupationname == "Agri cooli" |  occupationname == "Agri.coolie" |  occupationname == "Agricooli" ///
	|  occupationname == "Agricultural coolie"  |  occupationname == "Agri.cooli" |  occupationname == "Agriculture Cooli" |  occupationname == "Agriculture Coolie" ///
	|  occupationname == "Agriculture colli" |  occupationname == "Agriculture cooli" |  occupationname == "Agriculture collie" |  occupationname == "Agri coolie" ///
	|  occupationname == "Agri.colie" |  occupationname == "Agriculture,cooli" |  occupationname == "Agriculture.coolie" |  occupationname == "Agri. coolie"  |  occupationname == "Agri coolie" ///
	|  occupationname == "Agriculture  Coolie" |  occupationname == "Agriculture  colli"|  occupationname == "' Agri.coolie" |  occupationname == "Agriculture work" ///
	|  occupationname== "Agriculture coolie" ///
	|  occupationname == "Horticulture coolie" ///
	|  occupationname== "Agriculture coolie"
	
	* Sugarcane plantation labourers
	
	replace  occup_sector= 13  if  occupationname == "Sugar cane cutting" ///
		|  occupationname == "Sugarcane cutter helper" |  occupationname == "Sugarcane cutting helper" |  occupationname == "Sugar cutting" |  occupationname == "Sugarcane cutting colli" ///
		|  occupationname == "Sugarcane harvest" |  occupationname == "Sugarcane work"  |  occupationname == "Sugar cane Cutting" ///
		|  occupationname == "Sugarcane cutting" |  occupationname == "Sugar cane Cutting" 
		
	* Other farm workers
	
	replace  occup_sector= 14 if  occupationname == "Cattle rearing (milk production)"|  occupationname == "Chicken rearing" ///
		|  occupationname == "Cow rearing" ///
		|  occupationname == "Milk productin" |  occupationname == "Cow rearing  (milk selling)" ///
		|  occupationname == "Chicken centre" |  occupationname == "Cow rearing" |  occupationname == "Cattle rearing" ///
		|  occupationname == "Agriculture  farm watchman" /// * permanent & monthly salary
		|  occupationname == "Agri.sprayer machine"  ///
		|  occupationname == "Garden colli" ///	
		|  occupationname == "Tree cutting" 
		
		
**** Production workers, transport equipment operators and labourers

	* electricians, mechanic, operators
			

	* Bricklayers and construction workers (chamber, roads)
	
	replace  occup_sector= 22 if  occupationname == "Construction Coolie" |  occupationname == "Construction labour" /// 
	|  occupationname == "Construction worker" |  occupationname == "Construction worker coolie" |  occupationname == "Sentring work" |  occupationname == "Centring work" |  occupationname == "Centringwork" ///
	|  occupationname == "Construction Worker" |  occupationname == "Construction labor" |  occupationname == "Construction mason" |  occupationname == "Construction helper" |  occupationname == "Construction work coolie" ///
	|  occupationname == "Construction coolie" |  occupationname == "Construction coolie worker" |  occupationname == "Construction wage sithaal" /// 
	|  occupationname == "Brick Works" |  occupationname == "Brick Work" |  occupationname == "Brick works (chamber)" |  occupationname == "Bricklin work" |  occupationname == "Bricklin work" /// *sengal soolai
	|  occupationname == "Briklin work" |  occupationname == "Brikline work" |  occupationname == "Brincklin work" |  occupationname == "Chamber work" |  occupationname == "Chamber worker" ///
	|  occupationname == "Agriculture coolie (bricklin work)" |  occupationname == "Bricklin" |  occupationname == "Bricklin worker" |  occupationname == "Sengal Sulai work" ///
	|  occupationname == "Sengal sulai work" |  occupationname == "Brick klin worker" |  occupationname == "Brick works (CHAMBER)" |  occupationname == "Chamber works" ///
	|  occupationname == "Chamber worker(RKV chamber chennai)" |  occupationname == "Brick klin work" |  occupationname == "Brick work" |  occupationname == "Bricklin work assistant" ///
	|  occupationname == "Chamber working" |  occupationname == "Bricklin work" |  occupationname == "Brick" |  occupationname == "bricklin work" |  occupationname == "Brick.assistant" ///
	|  occupationname == "Construction work (MAISON)" |  occupationname == "Construction work" ///
	|  occupationname == "Mason" |  occupationname == "Masan" 	|  occupationname == "Maison" |  occupationname == "Construction sithal"  ///
	|  occupationname == "Road work" |  occupationname == "Road worker" ///
	|  occupationname == "Chamber" |  occupationname == "Bricklin work" ///	
	|  occupationname == "Painting work" |  occupationname == "Painter" 	|  occupationname == "Painting" ///
	|  occupationname == "Painting worker" 
		
	* Spinners, Weavers, Knitters, Dyers
	
	replace  occup_sector= 23 if  occupationname == "Spinning coolie" ///
	|  occupationname == "Handloom weaving labour" |  occupationname == "Handloom weaving work" ///
	|  occupationname == "Labour in cotton mill"  |  occupationname == "Spinning mill" ///
	|  occupationname == "Thread rolling and helping work" |  occupationname == "Thread rolling and helper in power loom industry" ///
	|  occupationname == "Handlom weaving business"|  occupationname == "Handlom weaving labour" ///
	|  occupationname == "Hand looming"|  occupationname == "Handloom weaving business" ///
	|  occupationname == "Handloom weaving" |  occupationname == "Handloom weaving agent"|  occupationname == "Handloom weaving work" ///
	|  occupationname == "Handloom work" ///
	|  occupationname == "Handloom waving agent" ///
	|  occupationname == "Hand looming (thread rolling)" 		

	
	* Tailors, dress makers, sewers
	
	replace  occup_sector= 24 if  occupationname == "Tailoring work" |  occupationname == "Tyloring" |  occupationname == "Tailor (in home)" ///
	|  occupationname == "Tailoring" |  occupationname == "Tailor" ///	
	|  occupationname == "Tailoring" |  occupationname == "Leather bag tailoring labour" 

	* Clay workers, potters, sculptors, painters
	
	replace  occup_sector= 25 if  occupationname == "Toys selling"| occupationname == "Pottery selling (migration)" ///
		|  occupationname == "Clay toys making" ///
		|  occupationname == "Doll making" |  occupationname == "Pot making" |  occupationname == "Pottery making" ///
		|  occupationname == "Pottory" |  occupationname == "Toys making" |  occupationname == "Clay toys maker" ///
		|  occupationname == "Pottery making unpaid" 	/// unpaid below
	    |  occupationname == "Pottery making helper" ///
	 	|  occupationname == "Clay toy making assistant" |  occupationname == "Doll making assistant" ///
		|  occupationname == "Toys selling with wife" ///
		|  occupationname == "Pattory assistant" |  occupationname == "Pottery" ///
		|  occupationname == "Unpaid in doll making family business" ///
		|  occupationname == "Pottery making" ///
		|  occupationname == "Sculpture (coolie)" ///
		|  occupationname == "Sculpture" |  occupationname == "Sculpture (SELF business)" ///		

	* Electrical workers
	
	replace  occup_sector= 26 if  occupationname == "Electrician" ///
	|  occupationname == "Électricien" ///
	|  occupationname == "Wiring helper" |  occupationname == "Electrician (salaried)" ///
	|  occupationname == "Electrician (NlC)" |  occupationname == "Electrician work" ///
	|  occupationname == "Sai power serve" |  occupationname == "Sriram Battery Copany pvt" |  occupationname == "Électricity dept(govt)" ///	
	|  occupationname == "Electricity rent work" /// 
	|  occupationname == "Elactetion work" |  occupationname == "Electrician" ///
	|  occupationname == "Tv and electronic service man" |  occupationname =="Tv mechanic self employed"
	
	* Mechanic and machinery fitters/assemblers (except electrical)
	
	replace  occup_sector= 27 if  occupationname == "Fitter" ///
	|  occupationname == "Mechanic (car company)" |  occupationname == "Mechanic technician in private company" ///
	|  occupationname == "Mechanic Assistant in private company" |  occupationname == "Mechanic in PRIVATE company" |  occupationname == "Mechanic in private company in chennai" |  occupationname == "Mechanical work" ///
	|  occupationname == "A/C Mechanic at Chennai" |  occupationname == "A/c mechanic" |  occupationname == "AC mechanic" |  occupationname == "CNC Machine mechanic" ///	
	|  occupationname == "Mechanic" |  occupationname == "Mechanic (in Qatar)" ///
	|  occupationname == "Motor mechanic trainee" ///
	|  occupationname == "Junior mech. In a motor company" ///
	|  occupationname == "A/C Mechanic Own Shop at Chennai" ///
	|  occupationname == "Mechanic in a two wheeler workshop" |  occupationname == "Apprentice in Mechanic in private company" 
	
	* Transport Equipment operators	

	replace  occup_sector= 28 if  occupationname == "JCB Driver" |  occupationname == "JCB operator" |  occupationname == "JCB (Driver)" |  occupationname == "JCB driver" ///
	|  occupationname == "JCP operater" ///
	|  occupationname == "Tata ace driver" |  occupationname == "Driver (Tata ace)" ///
	|  occupationname == "Tanker Lorry Driver" |  occupationname == "Lorry Driver" |  occupationname == "Lorry driver" |  occupationname == "Driver(709 vehicle )" ///
	|  occupationname == "Tractor driver" ///	
	|  occupationname == "Lorry transport" ///
	|  occupationname == "GOODS CARRIER (TATA ACE)self business" |  occupationname == "OwnLorry load business" ///
	|  occupationname == "Goods transport (tata ace) self business" ///
	|  occupationname == "Truck driver (own)" |  occupationname == "Tractor driver" ///
	|  occupationname == "Tractor driver" |  occupationname == "Own plugging machine driver" ///
	|  occupationname == "Transport business" ///
	|  occupationname == "Container driver (chennai horbar)" ///
	|  occupationname == "Private company driver"  |  occupationname == "Draiver" |  occupationname =="Driver in private company in gutar" ///
	|  occupationname == "Tractor driving" ///
	|  occupationname == "Bullock cart" |  occupationname == "Bullock cart business" |  occupationname == "Bullock rider" |  occupationname ==  "Bullockart" |  occupationname == "Bulluck cart"
	
	
	* Stationery Engines and related equipment operators
	replace  occup_sector= 29 if  occupationname == "Power loom machine operator" ///
	|  occupationname == "Operator (suger mill)" |  occupationname == "Operator (sugar mill)"|  occupationname == "Pan man (suger mill)"
	
	
	* Material handling and related equipment operators (loaders/unloaders)
	replace  occup_sector= 30 if  occupationname == "Load man" ///
	|  occupationname == "Load man coolie" |  occupationname == "Loadman" |  occupationname == "Coolie (load man)" ///
	|  occupationname == "Supplyer in hotal" 


	* Other Industrial workers (glass, mining, chemicals, printing, welders)
	replace  occup_sector= 31 if  occupationname == "PVC company trainee" |  occupationname == "Mining assist. Nlc" |  occupationname == "Coolie worker in a soap company" |  occupationname == "Printing company (printer)" ///
	|  occupationname == "Welder (coolie)" |  occupationname == "Welder"  |  occupationname == "Welding labour" ///
	|  occupationname == "Private company Labour" |  occupationname == "Private company helper" |  occupationname == "Private company labour" |  occupationname == "Private company labour (trainee)" ///
	|  occupationname == "Company (work man)" |  occupationname == "Attender Contract labour in a company"

	
	* Other craftsworkers (Carpenters, tiles workers, Paper product makers)	
	replace  occup_sector= 32 if  occupationname == "Carpentor" |  occupationname == "Tiles work" |  occupationname == "Tiles & granite flooring work" ///
	|  occupationname == "Old Paper and jute bags businesses" |  occupationname == "Old paper and jute bag business" |  occupationname == "Old jute bag business" 
	
	* Other labour
	replace  occup_sector= 33 if  occupationname == "Coolie velai" |  occupationname == "Coolie" |  occupationname == "Coolie in kerela" ///
	|  occupationname == "Singer factory" /// * other
	|  occupationname == "Service man (sasun)" |  occupationname == "Service man, tata sky" ///
	|  occupationname == "(NOKIA) Private company worker" ///
	|  occupationname == "Wheel company" ///
	|  occupationname == "Biscuit company" ///
	|  occupationname == "Contract worker"

	
**** Qualified jobs

	* Teachers	
	replace  occup_sector= 41 if  occupationname == "Teacher in PRIVATE school" |  occupationname == "Private school teacher" |  occupationname == "Matriculation school teacher" ///
	|  occupationname == ".Anganwadi assistant (child care)" |  occupationname == "Teacher" ///
	|  occupationname == "Lecturer" |  occupationname == "Lecturer(E.S.Engineering college )" 
	
	* Architects, Engineers, ..
	replace  occup_sector= 42 if  occupationname == "Civil Engineering work" /// * engineering pu/pvt
	|  occupationname == "Chief engineer" ///
	|  occupationname == "Production engineer(Sai power serve)" ///
	|  occupationname == "Software developer" ///
	|  occupationname == "Plastic engineer" ///
	|  occupationname == "Engineer (Shasun chemicals)"

	* Engineering technicians
	replace  occup_sector= 43 if  occupationname == "Service engineering (lanson toyato)" ///
	|  occupationname == "Tech.assist.in a private company" |  occupationname == "Technical in PRIVATE company" /// 
	|  occupationname == "Technical officer in private company" |  occupationname == "Technician( hindustan liver)" ///
	|  occupationname == "Technician in car parts company at chennai" |  occupationname == "Car parts company technician" ///
	|  occupationname == "Technician" 

	* Scientific, medical and technical persons
	replace  occup_sector= 44 if   occupationname == "Medical representative" 
				
	* Nursing and health technicians
	replace  occup_sector= 45 if  occupationname == "CL (Pallava Hospital)" |  occupationname == "Nurse" |  occupationname == "Nurse in a private hospital" ///
		|  occupationname == "Nurse in private hospital" |  occupationname == "Nursing apprentice" |  occupationname == "Nursing training" ///
		|  occupationname == "Mid wife" ///
		|  occupationname == "108 ambulance technicien" 
	
	* Economists, Accountants, auditors
	replace  occup_sector= 46 if  occupationname == "Analyst in chemical company" ///
		|  occupationname == "Accountant (royal Enfield)" |  occupationname == "Accountant(Syria technology)" |  occupationname == "Accountant(Jayam trading company)" ///
		|  occupationname == "Quality Controller" ///
		|  occupationname == "Accountant in ration (gov job) no contract yet" 

	* Jurists
	replace  occup_sector= 47 if  occupationname == "Advocate" ///
		|  occupationname == "Advocats"

	
	
**** Administrative, executive and managerial workers

	* Administrative and executive officials government and local bodies
	replace  occup_sector= 51 if  occupationname == "Police" |  occupationname == "Police man" |  occupationname == "Police training" ///
		|  occupationname == "Civil supplies employer (ration shop)" ///
		|  occupationname == "B.D.O Office (S. L )" |  occupationname == "EB Officer" ///
		|  occupationname == "Horticulture officer (ADMINISTRATION WORK)" 

	* Working proprietors, directors, managers in mining, construction, manufacturing
	replace  occup_sector= 52 if  occupationname == "Line incharge (pondy polymers)" |  occupationname == "Marketing executive" |  occupationname == "Incharge ( hutson milk product)" ///
	
	
	
**** Independent labour contractors
	
	replace  occup_sector= 61 if  occupationname == "Sugar cane Cutting maistry" |  occupationname == "Sugarcane cutting -Maistri" |  occupationname == "Sugarcane cutting maistri" ///
		|  occupationname == "Mason maistry" |  occupationname =="Brickling maistry" 	|  occupationname == "Maistry (contractor)" ///
		|  occupationname == "Construction maistry"
 
	 
**** Clerical workers

	* Clerical and other supervisors
	
	replace  occup_sector= 71 if   occupationname == "Supervisor ( NREGA)" ///
		|  occupationname == "Nrega, organizer" /// * public service
		|  occupationname == "Supervisor in construction" |  occupationname == "Supervisor in private company" ///
		|  occupationname == "Construction supervisor" ///
	    |  occupationname == "Supervisor in hotel" ///
		|  occupationname == "Supervisor" 

	* Other clerical workers
	replace  occup_sector= 72 if  occupationname == "Admin work(Feron tech)" ///
		|  occupationname == "Office assistant in Co-operative bank" |  occupationname == "Secretary(primary agriculture cooperative bank)" ///
		|  occupationname == "Receptionist" ///
		|  occupationname == "Billing staff" ///
		|  occupationname == "Transport company staff" ///
		|  occupationname == "Data entry operater" ///
		|  occupationname == "Post master" |  occupationname == "Mail Gard (central goverment railways dept)"

	* Transport conductors and guards
	replace  occup_sector= 73 if  occupationname == "Private bus conductor"  |  occupationname == "Bus conductor" |  occupationname == "Bus conductor (TN govt)" ///
	|  occupationname == "Bus driver" |  occupationname == "Bus driver (govt) Chennai" |  occupationname == "Van Driver(school)" ///
	|  occupationname == "Toll gate worker" |  occupationname == "Security gaurd"
	

	
**** Sales workers

	* Shop keepers (wholesale and retail)
	replace  occup_sector= 81 if  occupationname == "Fancy store (self-employment)" ///
	|  occupationname == "Shop keeper" ///
	|  occupationname == "Petti shop owner" |  occupationname == "Petti shop" |  occupationname == "Petty shop" 	|  occupationname == "Own petty shop" ///
	|  occupationname == "Maligai store" |  occupationname == "Grocery shop" ///
	|  occupationname == "Water cane business"  |  occupationname == "Petti Shop,recharge, water cane sales" ///
	|  occupationname == "Flower tieing" |  occupationname == "Flower shop" ///
	|  occupationname == "Tea stall" |  occupationname == "Mobile tea selling" |  occupationname =="Tea stall with small petty shop" ///
	|  occupationname == "Tea shop" ///
	|  occupationname == "Idly shop" |  occupationname == "Idli Shop" ///
	|  occupationname == "Tea shop ,mini hotel" |  occupationname == "Tea shop, mini hotel" ///
	|  occupationname == "Tea and tiffan shop" ///
	|  occupationname == "Bar bar shop house itself" ///
	|  occupationname == "Meat shop" ///
	|  occupationname == "Own vegetables shop" |  occupationname == "Vegetable seller" ///
	|  occupationname == "Milk vendor"  |  occupationname == "Milk seller" ///
	|  occupationname == "Fish seller" |  occupationname == "Fish selling" |  occupationname == "Fish vendor" ///
	|  occupationname == "Fruit seller" |  occupationname == "Fruits sales" |  occupationname == "Gouva selling" |  occupationname =="Gouva selling (self business)" ///
	|  occupationname == "Tamarind seed business" |  occupationname == "Collecting tamarind seeds for subramani business" ///
	|  occupationname == "Jute bag and tamarind seeds collection and sales" ///
	|  occupationname == "Salt seller"  |  occupationname == "Rice selling" ///
	|  occupationname == "Gany merchent" /// ??
	|  occupationname == "Scarab business" /// ??
	|  occupationname == "Plastic seller" /// 
	|  occupationname == "Own Xerox shop" ///
	|  occupationname == "Jewel seller" ///
	|  occupationname == "Cycles services shop" ///
	|  occupationname == "Medical shop" ///
	|  occupationname == "Assistance for his husband in petti shop" |  occupationname == "Unpaid in husband's grocery shop"  |  occupationname == "Tea shop Assistance for his husband"  

	 
	* Agri equipment sellers
	replace  occup_sector= 82 if  occupationname == "Tractor vendor" |  occupationname == "Agriculture equipment seller" |  occupationname == "Agriculture tractor and equipment" 
		 
	* Rent shop/ activities
	replace  occup_sector= 83 if  occupationname == "Vessels rental shop" ///
	|  occupationname == "Shop rent collection" ///
    |  occupationname == "Pesticide spray machine rent" /// 
	|  occupationname == "Tractor hiring"|  occupationname == "Lorry hiring" 
		
	* Salesmen, shop assistants and related workers
	 replace  occup_sector= 84 if  occupationname == "Helper in grosory shop" |  occupationname == "Salaried work in a grossery shop" |  occupationname == "Salaried in a grossery shop" ///
	 |  occupationname == "Sweet seller in sweet shop"|  occupationname == "Salesman in sweet stall" ///
	 |  occupationname == "Salaried in shoe mart" |  occupationname == "Working in furniture mart as sales girl" ///
	 |  occupationname == "Sales girl" |  occupationname == "Cloth store" ///
	 |  occupationname == "Pookkadai (Thins coolie)" |  occupationname == "flower shop labour" |  occupationname == "Assistant in a flower shop" ///
	 |  occupationname == "Private Shop worker" |  occupationname == "labour in muthu silk house"  ///
	 |  occupationname == "Shoe company worker" ///
	 |  occupationname == "Assistant in Biriyani and fast food centre" ///
	 |  occupationname == "Flower shop labour" ///
	 |  occupationname == "Packing girl" 

	* Technical salesmen & commercial travellers
 	replace  occup_sector= 85 if  occupationname == "Bus contracter" /// 		
	|  occupationname == "Building contractor" ///* Insurance, real estate, securities and business service salesmen and auctioneers


	* Money lenders and pawn brokers	
	replace  occup_sector= 86 if   occupationname == "Money lending" ///	
	 |  occupationname == "Tractor buying broker" ///
	 |  occupationname == "Apraisser" |  occupationname == "Gold appriser" 
	
	

			
**** Service workers

	* Hotel and restaurant keepers
	replace  occup_sector= 91 if   occupationname == "Hotel master" ///
	|  occupationname == "Biriyany and fast food centre" 
	
	* Cooks, waiters
	replace  occup_sector= 92 if  occupationname == "Canteen (cooking)" |  occupationname == "Cooking work ( Government )" |  occupationname == "Cook in government hostel" ///* Hotel/restaurants
		|  occupationname == "Server(hotel)" |  occupationname == "Waiter" |  occupationname == "Waiter in a hotel" ///
		|  occupationname == "Sweet master" |  occupationname == "Cooking work" |  occupationname == "Cooking master" ///
		|  occupationname == "Catering work" 	|  occupationname == "Catering Coolie" ///
		|  occupationname == "Cookie in a hotel" ///
		|  occupationname == "Restaurant worker" 

	* Building caretakers, sweepers, cleaners	
	replace  occup_sector= 93 if   occupationname == "Cookie cleaner in a hotel" ///
		|  occupationname == "Sanitary worker in village panchayath" 	|  occupationname == "Meeniyal (Thotti)" ///
		|  occupationname == "Cleaner in hotal" |  occupationname == "Sweeper in temple" ///
		|  occupationname == "Broomstick cleanning" |  occupationname == "Broomstick work" 

	* Maids and house keeping service workers
	replace  occup_sector= 94 if  occupationname == "House keeping" |  occupationname == "House work" 

	* Hair dressers, barbers..
	replace  occup_sector= 95 if  occupationname == "Beauty Parlor Trainee"	

	* Private transportation
	replace  occup_sector= 96 if  occupationname == "Auto Driver (self-employed)" |  occupationname == "Auto driving (own auto)" ///
		|  occupationname == "Driver (own vehicle)" 	|  occupationname == "Taxi driving (own)" ///
		|  occupationname == "Travels" |  occupationname == "Driver" 

	* Other service workers
	replace  occup_sector= 97 if  occupationname == "Pétrol bunk (servant)" |  occupationname == "Petrol seller" ///


	
**** Performing artists
	
	replace  occup_sector= 101 if   occupationname == "Drums beetter on death ceremonies" |  occupationname == "Thavil vidvan" ///
	|  occupationname == "Drums beating" |  occupationname == "Koil molam" ///
	|  occupationname == "Drums Beeting" |  occupationname == "Drum beeter" |  occupationname == "Drummer at death ceremonies" ///
	|  occupationname == "Archestra" |  occupationname == "Archestra Singer" ///
	|  occupationname == "Archestra (instrument player)" ///
	|  occupationname == "Asst.in a studio" |  occupationname == "Camara man (cinima)" 

		
**** Astrologers 

	replace  occup_sector= 102 if occupationname == "Josiyam" |  occupationname == "Josyam(self employment)" |  occupationname == "Josiyam parthal" |  occupationname == "Josiyam partial ( Samiyar )" |  occupationname == "Horoscope" ///

**** Public works/ NREGA
	replace  occup_sector= 111 if  occupationname == "NREGA" |  occupationname == "NREGS" |  occupationname == "Nregs" |  occupationname == ".Nrega" ///
	|  occupationname == "nrega" |  occupationname == "Nrges" |  occupationname == "Nerega" |  occupationname == "Nrega" ///
	|  occupationname == "Bore Weller (goverment temporary worker)" 
	

	
**********************************************
**  Create 'occup_sector' variable for 2010 **			!! Pension and no occup not assigned to occup-sector (n=10) !!
**********************************************

	*Cultivators
replace occup_sector=11 if year==2010 & (_2_c_occupation=="AGRI" | _2_c_occupation=="AGRI BUSINESS" | _2_c_occupation=="AGRI CULTURE" ///
| _2_c_occupation=="AGRICULTURE" )

	*Agricultural labourers
replace occup_sector=12 if year==2010 & (_2_c_occupation=="AGRI COOLI" | _2_c_occupation=="AGRI COOLIE" | _2_c_occupation=="AGRI COOLLIE"  ///
| _2_c_occupation=="AGRI,COOLIE" | _2_c_occupation=="AGRI. COOLIE" | _2_c_occupation=="AGRI.COOLI" | _2_c_occupation=="AGRI.COOLIE" | _2_c_occupation=="AGRICOOLIE" ///
| _2_c_occupation=="AGRICULTURE COOLIE" | _2_c_occupation=="AGRI BASED WORK" | _2_c_occupation=="PLOUGHING" |  _2_c_occupation=="COOLIE IN KERALA")

	*Sugarcane plantation labourers
replace occup_sector=13 if year==2010 & (_2_c_occupation=="SUGARCANECUTTING" | _2_c_occupation=="SUGARCANE CUTTING" | _2_c_occupation=="SUGAR CANE CUTTING")

	*Other farm workers
replace occup_sector=14 if year==2010 & (_2_c_occupation=="COW REARING" | _2_c_occupation=="EID PARRY (sugar mill factory)" | _2_c_occupation=="MILK BUSINESS" ///
| _2_c_occupation=="MILK COLLECTION" |  _2_c_occupation=="FLOUR MILL" |  _2_c_occupation=="FRUIT PRODUCTION" |  _2_c_occupation=="SELF-POWER TILLER")

	*Bricklayers and construction workers (chamber, roads)
replace occup_sector=22 if year==2010 & (_2_c_occupation=="CHAMBER" |  _2_c_occupation=="CHAMBER OWN" ///
| _2_c_occupation=="CHAMBER WORK" | _2_c_occupation=="CHAMEBER WORK" |  _2_c_occupation=="CONSTRUCTION WORK" | _2_c_occupation=="CONSTRUCTION WORKER COOLIE" ///
| _2_c_occupation=="CONSTRUCTION WROK" | _2_c_occupation=="ROAD WORK" | _2_c_occupation=="BRICK WORK" ///
| _2_c_occupation=="CENTRING WORK (CONSTRUCTION)" | _2_c_occupation=="MASON" | _2_c_occupation=="CONSTRUCTION" | _2_c_occupation=="SUVELAI (CHAMBER)" | _2_c_occupation=="SULAI VELAI (CHAMBER)" ///
| _2_c_occupation=="PAINTER" | _2_c_occupation=="PAINTER, AGRI COOLIE" | _2_c_occupation=="WELDER" | _2_c_occupation=="WELDING" ///
| _2_c_occupation=="WELDING WORKSHOP") 

	*Spinners, Weavers, Knitters, Dyers
replace occup_sector=23 if year==2010 & (_2_c_occupation=="HANDLOOM" | _2_c_occupation=="HANDLOOM CO-OPRATIVE SOCIETY" | _2_c_occupation=="HANDLOOMING" ///
| _2_c_occupation=="HANLOOM"  )

	*Tailors, dress makers, sewers
replace occup_sector=24 if year==2010 & (_2_c_occupation=="TAILOR" | _2_c_occupation=="TAILORING" | _2_c_occupation=="TAILORING COOLIE" ///
| _2_c_occupation=="TYLERING" | _2_c_occupation=="TEXTILE SHOP WORK")

	*Clay workers, potters, sculptors, painters
replace occup_sector=25 if year==2010 & (_2_c_occupation=="CLAY TOY MAKING" | _2_c_occupation=="CLAY TOY" | _2_c_occupation=="CLAY STOVE" ///
| _2_c_occupation=="CLAY TOY SALE" | _2_c_occupation=="POT MAKING")

	*Electrical workers
replace occup_sector=26 if year==2010 & (_2_c_occupation=="ELECTRECIAN" | _2_c_occupation=="ELECTRICIAN")

	*Mechanic and machinery fitters/assemblers (except electrical)
replace occup_sector=27 if year==2010 & (_2_c_occupation=="MECHANIC" | _2_c_occupation=="MECHANIC WORK" | _2_c_occupation=="MOTOR WORKSHOP" | _2_c_occupation=="AC MECHANIC" ///
| _2_c_occupation=="TV MECHANIC" |  _2_c_occupation=="FITTER IN CHENNAI")

	*Transport Equipment operators
replace occup_sector=28 if year==2010 & (_2_c_occupation=="BULLACAT" | _2_c_occupation=="BULLCART" | _2_c_occupation=="BULLOCART" | _2_c_occupation=="BULLOCART DRIVER" ///
| _2_c_occupation=="BULLOCCART" | _2_c_occupation=="BULLOCKCART" | _2_c_occupation=="TRACKTER OWN" | _2_c_occupation=="TRACTOR" | _2_c_occupation=="TRACTOR driver" )

	*Stationery Engines and related equipment operators
replace occup_sector=29 if year==2010 & (_2_c_occupation=="WATER TANK OPERATOR")

	*Material handling and related equipment operators (loaders/unloaders)
replace occup_sector=30 if year==2010 & (_2_c_occupation=="LOAD MAN" | _2_c_occupation=="LOADMAN" | _2_c_occupation=="LOADMAN IN PVT COMPANY")
/*
	*Other Industrial workers (glass, mining, chemicals, printing, welders)
replace occup_sector=31 if year==2010 & ()
*/
*	Other craftsworkers (Carpenters, tiles workers, Paper product makers)
replace occup_sector=32 if year==2010 & ( _2_c_occupation=="CARPENTAR" | _2_c_occupation=="CARPENTER" | _2_c_occupation=="CORPENTOR")

	*Other labour
replace occup_sector=33 if year==2010 & (_2_c_occupation=="LABOUR" | _2_c_occupation=="PRIVATE COMPANY" | _2_c_occupation=="PRIVATE COMPANY WORK"  ///     Où mettre les "pvt company workers" ??
_| _2_c_occupation=="PRIVATE COMPANY WORKER" | _2_c_occupation=="PRIVATE COMPONY WORK" | _2_c_occupation=="PVT CO." | _2_c_occupation=="PVT COMPANY" ///
||_2_c_occupation=="PVT SECURITY" | _2_c_occupation=="PVT. CO" | _2_c_occupation=="PVT.CO" | _2_c_occupation=="PVT.CO." | _2_c_occupation=="PVT.CO.COOLIE" ///
 | _2_c_occupation=="PVT.COMPANY" | _2_c_occupation=="SECURITY" | _2_c_occupation=="WASHERMAN" | _2_c_occupation=="WATCHMAN" | _2_c_occupation=="WATERMAN IN BSNL" ///
 | _2_c_occupation=="WORK IN GULF" | _2_c_occupation=="WORKING IN PVT COMPANY" | _2_c_occupation=="WORKING IN WINE SHOP" | _2_c_occupation=="COOLIE" | _2_c_occupation=="HARTICULTURE WORK" ///
 | _2_c_occupation=="TENT HOUSE WORK")

	*Teachers
replace occup_sector=41 if year==2010 & (_2_c_occupation=="PVT.SCHOOL TEACHER" | _2_c_occupation=="TRAINING TEACHER")

	*Architects, Engineers, ...
replace occup_sector=42 if year==2010 & (_2_c_occupation=="ENGINEER" | _2_c_occupation=="ENGINEER BUILDING CONSTRUCTION")

	*Engineering technicians
replace occup_sector=43 if year==2010 & ( _2_c_occupation=="SERVICE ENG LG")

	*Scientific, medical and technical persons
replace occup_sector=44 if year==2010 & ( _2_c_occupation=="GOVT.HOSPITAL")

	*Nursing and health technicians
replace occup_sector=45 if year==2010 & (_2_c_occupation=="ANGANVADI STAFF (NURSERY SCHOOL JOB)" | _2_c_occupation=="ANGANWADI HELPER (NURSERY SCHOOL JOB)" ///
| _2_c_occupation=="ANGANWADI SERVANT  (NURSERY SCHOOL JOB)")

	*Economists, Accountants, auditors
replace occup_sector=46 if year==2010 & (_2_c_occupation=="ACCOUNTS OFFICER")
/*
	*Jurists
replace occup_sector=47 if year==2010 & ()
*/
	*Administrative and executive officials government and local bodies
replace occup_sector=51 if year==2010 & ( _2_c_occupation=="VILLAGE ASSISTANED" | _2_c_occupation=="VILLAGE ASST." | _2_c_occupation=="GOVT SERVANT" | _2_c_occupation=="GOVT.DRIVER" ///
|  _2_c_occupation=="GOVT.JOB" |  _2_c_occupation=="WORKING IN JEWELRY SHOP" | _2_c_occupation=="�UDITOR ASSISSTEND" | _2_c_occupation=="�UDITOR ASSISSTEND" )
/*
	*Working proprietors, directors, managers in mining, construction, manufacturing
replace occup_sector=52 if year==2010 & ()
*/
	*Independent labour contractors
replace occup_sector=61 if year==2010 & (_2_c_occupation=="SUGARCANE MAISTHRI" | _2_c_occupation=="MAISTHRI" | _2_c_occupation=="CHAMBER MAISTRY" /// 
| _2_c_occupation=="CONSTRUCTION MAISTRY" )

	*Clerical and other supervisors
replace occup_sector=71 if year==2010 & (_2_c_occupation=="SUPERVISOR IN PVT COMPANY")

	*Other clerical workers
replace occup_sector=72 if year==2010 & (_2_c_occupation=="BANK CLERK" | _2_c_occupation=="LIC AGENT (INSURANCE)" | _2_c_occupation=="POST OFFICE CLERK" ///
| _2_c_occupation=="CO-OP BANK" | _2_c_occupation=="AMN ASSISTANT (ARMY WORK)" | _2_c_occupation=="COOPERATIVE BANK WORKER")

	*Transport conductors and guards
replace occup_sector=73 if year==2010 & (_2_c_occupation=="BUS CONDUCTOR" | _2_c_occupation=="CONDUCTOR BUS" | _2_c_occupation=="GOVERNMENT DRVER" ///
| _2_c_occupation=="LORRY DRIVER")

	*Shop keepers (wholesale and retail)
replace occup_sector=81 if year==2010 & (_2_c_occupation=="CAVERING JEWEL BUSINES" | _2_c_occupation=="CAVERING JEWELS BUSINESS" | _2_c_occupation=="FANCY STORE" ///
| _2_c_occupation=="FISH SELLING" | _2_c_occupation=="FISH VENDOR" | _2_c_occupation=="FLLOWER SHOP" | _2_c_occupation=="FRUIT BUSINESS" | _2_c_occupation=="FRUIT SELLING" ///
| _2_c_occupation=="FRUIT SHOP" | _2_c_occupation=="GENERAL STORE" | _2_c_occupation=="GROCERY SHOP" | _2_c_occupation=="GROSORY SHOP" ///
| _2_c_occupation=="GROSSARY SHOP" | _2_c_occupation=="IDLY SHOP" | _2_c_occupation=="JUTE BAG BUSINES" | _2_c_occupation=="JUTE BAG BUSINESS" ///
| _2_c_occupation=="JUTEBAG BUSINESS" | _2_c_occupation=="PETTI SHOP" | _2_c_occupation=="PETTY SHOP" | _2_c_occupation=="TEA SHOP" | _2_c_occupation=="TEA STALL" ///
| _2_c_occupation=="TELEPHONE BOOTH" | _2_c_occupation=="VEGETABLE SELLING" | _2_c_occupation=="WASTE PAPER BUSINESS" | _2_c_occupation=="WASTER PAPER BUSINESS" ///
| _2_c_occupation=="TAMERIEND SEED BUSINESS" | _2_c_occupation=="COTTON BUSINESS" | _2_c_occupation=="CRISTAL BUSINESS" | _2_c_occupation=="CROPS BUSINESS" ///
| _2_c_occupation=="CYCLE STORE" | _2_c_occupation=="PRIVATE  SHOP" | _2_c_occupation=="STRAW BUSINESS"  ///
| _2_c_occupation=="NATURAL MANURE BUSINESS (fertilisant business)" |  _2_c_occupation=="CHAIR BUSINESS" )
/*
	*Agri equipment sellers
replace occup_sector=82 if year==2010 & ()

	*Rent shop/ activities
replace occup_sector=83 if year==2010 & ()
*/
	*Salesmen, shop assistants and related workers
replace occup_sector=84 if year==2010 & (_2_c_occupation=="BANK WATCHMAN" |  _2_c_occupation=="COLLIE IN CLOTH STORE" |  _2_c_occupation=="COOLIE IN FANCY STORE" | _2_c_occupation=="COOLIE IIN HOTEL" ///
| _2_c_occupation=="COOLIE IN CENIMA THEATRE" |  _2_c_occupation=="COOLIE IN SWEET STALL" |  _2_c_occupation=="FLLOWER SHOP COOLIE" ///
|  _2_c_occupation=="FLOOWER SHOP WORK" |  _2_c_occupation=="SHOP WORK" |  _2_c_occupation=="SHOP WORKER" | _2_c_occupation=="WORKING IN WINE SHOP" )
/*
	*Technical salesmen & commercial travellers
replace occup_sector=85 if year==2010 & ()

	*Money lenders and pawn brokers
replace occup_sector=86 if year==2010 & ()
*/
	*Hotel and restaurant keepers
replace occup_sector=91 if year==2010 & (_2_c_occupation=="HOTEL BUSINESS" | _2_c_occupation=="HOTEL") //vérifier si SE 

	*Cooks, waiters
replace occup_sector=92 if year==2010 & (_2_c_occupation=="COOK" | _2_c_occupation=="HELPER -COOKING" | _2_c_occupation=="HOSTEL COOK" |  _2_c_occupation=="COOLIE IN HOTEL" ///
|  _2_c_occupation=="HOTEL WORK" |  _2_c_occupation=="HOTEL WORKER" |  _2_c_occupation=="WORKING IN COOLDRINKS SHOP" |  _2_c_occupation=="WORKING IN JEWELLERY SHOP" |  _2_c_occupation=="WORKING IN JEWELRY SHOP")

	*Building caretakers, sweepers, cleaners
replace occup_sector=93 if year==2010 & (_2_c_occupation=="BUS CLEANER" |  _2_c_occupation=="CLEANER IN TRACTOR" )

	*Maids and house keeping service workers
replace occup_sector=94 if year==2010 & (_2_c_occupation=="HOUSE KEEPING"  )
/*
	*Hair dressers, barbers...
replace occup_sector=95 if year==2010 & ()
*/
	*Private transportation
replace occup_sector=96 if year==2010 & (_2_c_occupation=="CAR DRIVER" | _2_c_occupation=="TEMPO DRIVER" | _2_c_occupation=="TEMPO TRAVEL OWNER" | _2_c_occupation=="VAN DRIVER" ///
| _2_c_occupation=="DRIVER" | _2_c_occupation=="DRIVING")

	*Other service workers
replace occup_sector=97 if year==2010 & ( _2_c_occupation=="IRNING CLOTHES" | _2_c_occupation=="REAL ESTATE" | _2_c_occupation=="SHOE MAKER" ///
| _2_c_occupation=="SHOE MAKING" | _2_c_occupation=="INLAND FISHING" | _2_c_occupation=="TOOK FISH POND LEASE" ) ///  ????

	*Performing artists
replace occup_sector=101 if year==2010 & (_2_c_occupation=="BAND PLAYER" | _2_c_occupation=="TEMPLE DRUMS PLAYING" | _2_c_occupation=="THAPPU ADITHAL (DRUMER)")

	*Astrologers
replace occup_sector=102 if year==2010 & (_2_c_occupation=="JOSIYAM (CLAIVOYANT)")	

	*Public works/ NREGA
replace occup_sector=111 if year==2010 & (_2_c_occupation=="NREGA" | _2_c_occupation=="NREGS" | _2_c_occupation=="NRGEA")	

	
	
	
gen occup_sector2= 1 if occup_sector==11
replace occup_sector2= 2 if occup_sector>11 & occup_sector<20
replace occup_sector2= 3 if occup_sector>20 & occup_sector<40
replace occup_sector2= 4 if occup_sector>40 & occup_sector<50
replace occup_sector2= 5 if occup_sector>50 & occup_sector<60
replace occup_sector2= 6 if occup_sector>60 & occup_sector<70
replace occup_sector2= 7 if occup_sector>70 & occup_sector<80
replace occup_sector2= 8 if occup_sector>80 & occup_sector<90
replace occup_sector2= 9 if occup_sector>90 & occup_sector<100
replace occup_sector2= 10 if occup_sector>100 & occup_sector<110
replace occup_sector2= 11 if occup_sector>110 & occup_sector<120


label define sector 1 "Cultivators" 2 "Agricultural and plantation labourers" 3 "Production workers, transport equipment operators and labourers" ///
4 "Most qualified workers" 5 "Administrative, executive and managerial workers" 6 "Labour contractors" ///
7 "Clerical workers" 8 "Merchents and sellers" 9 "Service workers" 10 "Artists and astrologers" ///
11 "NREGA"
label values occup_sector2 sector 	
	
	
* make occup_sector2 comparable to 2010 
	
tab kindofwork occup_sector2 

replace kindofwork=3 if occup_sector2==2 & kindofwork==4
replace kindofwork=4 if occup_sector2==3 & kindofwork==3
replace kindofwork=4 if kindofwork==3 & occup_sector2==4
replace kindofwork=4 if kindofwork==3 & occup_sector2==7
replace kindofwork=4 if kindofwork==3 & occup_sector2==9
replace kindofwork=2 if occup_sector2==10
* attention !!!! malgré ces changements, details des occupations restent dans catégorie initiale (SE, salaried)


*recode handloom: recode to self-employed when job location is govulapuram or same village
replace kindofwork=2 if occup_sector==23 & kindofwork!=2 & joblocation=="Same village" ///
| occup_sector==23 & kindofwork!=2 & joblocation=="Govulapuram"		///
| occup_sector==23 & kindofwork!=2 & joblocation=="Same village,own house"		///
| occup_sector==23 & kindofwork!=2 & joblocation=="Same villlage"

**** attention: information about handloom workers will be in salaried workers module instead of self-employed module





************************ define occupcode2016 (replace occupcode)

		**"CULTIVATORS" 
gen occupcode2016= 1 if occup_sector2==1

		**"AGRI COOLIE" (in occup sector 2 but not self-employed)
replace occupcode2016= 2 if occup_sector2==2 & kindofwork!=2

		**"COOLIE NON-AGRI" (industry+service): employed, daily/seasonal/occasional job
			* industry workers (sector 3) 
			* coolies in shops	(sector 8)	
			* coolies in service (sector 9)

replace occupcode2016= 3 if occup_sector2==3 & kindofwork!=2 & salariedjobtype>=3 | occup_sector2==8 & kindofwork!=2 & salariedjobtype>=3 | occup_sector2==9 & kindofwork!=2 & salariedjobtype>=3

		**"REGULAR NON-QUALIFIED NON-AGRI" (industry+service): employed, fixed/permanent jobs, less than 10std or more than 10std but no monthly wage (only piece rate or daily)	
			* regular non qualified industry workers (sector 3): mostly in sector 22, 23= construction, handloom in thirupur)
			* Clerical workers (sector 7)
			* employed in shops (sector 8)		
			* employed service workers (sector 9)
			* qualified job but less than 10std (mid wife, assistant) (sector 4)
	
			
replace occupcode2016=4 if occup_sector2==3 & kindofwork!=2 & salariedjobtype<3 & classcompleted<10 | occup_sector2==3 & kindofwork!=2 & salariedjobtype<3 & everattendedschool==0 ///
			| occup_sector2==3 & kindofwork!=2 & salariedjobtype<3 & classcompleted>=10 & salariedwagetype!=3 ///
			| occup_sector2==7 & classcompleted<10 | occup_sector2==7 & classcompleted>=10 & salariedwagetype!=3 ///
			| occup_sector2==8 & kindofwork!=2 & salariedjobtype<3 | occup_sector2==9 & kindofwork!=2 & salariedjobtype<3 ///
			| occup_sector2==4 & classcompleted<10 

			
* créer sous catégorie de regular non qualified pour migrants (thiruppur et brick kiln) ??? quelle part représentent-ils dans cette catégorie ?
* using job location
* pour migrants: frontière coolie/regular est floue: une partie déclaré "permanent" jobs but all have piece rate/daily wages
			
		**"REGULAR QUALIFIED NON-AGRI" (industry+service): fixed/permanent jobs, more than 10std, and monthly wage
			* qualified and regular industry workers (sector 3): mostly in sector 26, 27, 31= electrician, mechanic, private comp)
			* Qualified jobs (sector 4), more than 10std
			* Administrative, executive and managerial workers (sector 5): all more than 10 std

replace occupcode2016=5 if occup_sector2==3 & kindofwork!=2 & salariedjobtype<3 & classcompleted>=10 & salariedwagetype==3 ///
			| occup_sector2==4 & classcompleted>=10 & salariedwagetype==3 | occup_sector2==5  ///

		
		**"SELF-EMPLOYMENT" 
			*small farm self employment (sector 2)
			*non-agri production business (tailoring, carpenter, handloom, pottery, electricians..) (sector 3)
			*labour contractors (maistries) (sector 6)
			*all kind of vendors/sellers (sector 8)
			*service self-employed (sector 9)
			*artists (sector 10)
		
replace occupcode2016=6 if kindofwork==2 & occup_sector2==2 | kindofwork==2 & occup_sector2==3 | occup_sector2==6 | kindofwork==2 & occup_sector2==8 | kindofwork==2 & occup_sector2==9 | occup_sector2==10


		**"NREGA" (sector 11)
replace occupcode2016=7 if occup_sector2==11


* recode non-agri coolie unpaid in HH/other business (mostly pottery) to self-employed
		* clay toys maker & petty shop, etc: recoded to self-employed (family business)
replace occupcode2016=6 if occupcode2016==3 & kindofwork==5
replace occupcode2016=6 if occupcode2016==3 & kindofwork==6
replace occupcode2016=6 if occupcode2016==3 & kindofwork==7
replace occupcode2016=6 if occupcode2016==4 & kindofwork==5
replace occupcode2016=6 if occupcode2016==4 & kindofwork==6

replace occupcode2016=6 if occupcode2016==3 & occup_sector2==8 & joblocation=="Own"


*** pour indsutry sector: frontiere floue entre non-agri coolie et regular non-qualified 

		*first step: all permanent jobs non-qualified coded in regular non-qualified
			* & non-permanent in non-agri coolie (code occupcode2016 above)	
		*second step: 
			* sector 23-24-28-29 (handloom &tailors labour, drivers, powerloom operators), even if some daily workers => regular non-qualified
			* sector 30 (loading), occasional tractor drivers (28), other coolie/helper, construction => non-agri coolie
			
			
* recode from non-agri coolie to regular non-qualified (drivers(28), tailors(24), construction)
replace occupcode2016=4 if occupcode2016==3 & occup_sector2==9 & occupationname=="Driver"
replace occupcode2016=4 if occupcode2016==3 & occup_sector2==3 & occup_sector==28 & salariedjobtype==3
replace occupcode2016=4 if occupcode2016==3 & occup_sector2==3 & occup_sector==24 & salariedjobtype==3
replace occupcode2016=4 if occupcode2016==3 & occupationname=="Masan"|occupcode2016==3 & occupationname=="Mason"| occupcode2016==3 & occupationname=="Painter" ///
| occupcode2016==3 & occupationname=="Painting work" | occupcode2016==3 & occupationname=="Painting" | occupcode2016==3 & occupationname=="Painting worker" ///
| occupcode2016==3 & occupationname=="Tiles work" | occupcode2016==3 & occupationname=="Construction mason"

* recode from self-employed to regular non-qualified (carpentor): ***this job info will still be in SE!!
replace occupcode2016=4 if occupcode2016==6 & occupationname=="Carpentor"

* recode from self-employed to regular qualified (electricians, mechanics): ***this job info will still be in SE!!
replace occupcode2016=5 if occupcode2016==6 & occupationname=="Elactetion work"|occupcode2016==6 & occupationname== "Electrician" ///
|occupcode2016==6 & occupationname== "A/C Mechanic Own Shop at Chennai" ///
|occupcode2016==6 & occupationname== "Tv mechanic self employed"

* recode from regular qualified to regular non-qualified (tailoring, drivers, operators, other industry labour)
replace occupcode2016=4 if occupcode2016==5 & occup_sector2==3 & occup_sector==24 |occupcode2016==5 & occup_sector2==3 & occup_sector>27

* recode from non-agri coolie to qualified (electricians)
replace occupcode2016=5 if occupcode2016==3 & occup_sector2==3 & occup_sector==26 & occupationname!="Wiring helper"
* recode from regular non-qualified to qualified (electricians, mechanics)
replace occupcode2016=5 if occupcode2016==4 & occup_sector2==3 & occup_sector==26
replace occupcode2016=5 if occupcode2016==4 & occup_sector2==3 & occup_sector==27

* recode from regular non-qualified to non-agri coolie (load man)
replace occupcode2016=3 if occupcode2016==4 & occup_sector2==3 & occup_sector==30
replace occupcode2016=3 if occupcode2016==4 & occup_sector2==3 & occupationname=="Sculpture (coolie)"


* former label
*label define occupcode 1 "Cultivators" 2 "Agri coolie" 3 "Non-agri coolie" 4 "Regular non-qualified" ///
*5 "Regular qualified" 6 "SE" 7 "NREGA"

label define occupcode 1 "Agri self-employed" 2 "Agri casual workers" 3 "Non-agri casual workers" 4 "Non-agri regular non-qualified workers" ///
5 "Non-agri regular qualified workers" 6 "Non-agri self-employed" 7 "Public employment scheme workers (NREGA)"


label values occupcode2016 occupcode

tab occupcode2016 if year==2016



* distinction non-agri coolie & regular non qualified pas très claire...
	* using job location: new category for migrant construction workers
	* shop labour: family business ? 5 are in non-agri coolies
	* occup_sector 31-33: flou


bys occup_sector2: tab occupationname  salariedwagetype  if occupcode2016==3 & occup_sector!=22
* list job coolie non-agri industry hors construction
tab occupationname occup_sector  if occupcode2016==3 & occup_sector2==3 & occup_sector!=22 
tab occupationname salariedwagetype  if occupcode2016==3 & occup_sector2==3 & occup_sector!=22 
tab occupationname salariedjobtype  if occupcode2016==3 & occup_sector2==3 & occup_sector!=22 
tab occupationname annualincome if occupcode2016==3 & occup_sector2==3 & occup_sector!=22 


bys occup_sector2: tab occupationname  salariedwagetype  if occupcode2016==4 & occup_sector!=22
* list job regular non-qualified industry hors construction
tab occupationname occup_sector  if occupcode2016==4 & occup_sector2==3 & occup_sector!=22 
tab occupationname salariedwagetype  if occupcode2016==4 & occup_sector2==3 & occup_sector!=22 
tab occupationname salariedjobtype  if occupcode2016==4 & occup_sector2==3 & occup_sector!=22 
tab occupationname annualincome if occupcode2016==4 & occup_sector2==3 & occup_sector!=22 


************************ define occupcode2010
	
/*_2_c_occupation_code2
1	Agriculture
2	Coolie
3	Agri Coolie
4	NREGS
5&8 S-E Investment
6	Employee
7	Service
9	Pension
10 no occup
*/	


*culti
gen occupcode2010=1 if _2_c_occupation_code2==1
*agri coolie
replace occupcode2010=2 if _2_c_occupation_code2==3 |_2_c_occupation=="AGRI COOLIE"

*non-agri coolie (industry, service)
replace occupcode2010=3 if _2_c_occupation== "CENTRING WORK (CONSTRUCTION)" ///
| _2_c_occupation=="CONSTRUCTION WROK"  ///
 | _2_c_occupation=="LORRY DRIVER"  ///
 | _2_c_occupation=="PRIVATE COMPANY WORK" & _23_1_g_work_type!=1 ///
 | _2_c_occupation=="BRICK WORK" | _2_c_occupation=="CHAMBER" | _2_c_occupation=="CHAMBER WORK"| _2_c_occupation=="CHAMEBER WORK" ///
 | _2_c_occupation=="CONSTRUCTION"  | _2_c_occupation=="CONSTRUCTION WORK"| _2_c_occupation=="CONSTRUCTION WORKER COOLIE" ///
 | _2_c_occupation=="COOLIE" | _2_c_occupation=="COOLIE IN KERALA" | _2_c_occupation=="LABOUR" | _2_c_occupation=="LOAD MAN" ///
 | _2_c_occupation=="CLEANER IN TRACTOR" | _2_c_occupation=="LOADMAN"| _2_c_occupation=="LOADMAN IN PVT COMPANY" ///
 | _2_c_occupation=="PVT.CO.COOLIE" | _2_c_occupation=="ROAD WORK" | _2_c_occupation=="SULAI VELAI (CHAMBER)"| _2_c_occupation=="SUVELAI (CHAMBER)" ///
 | _2_c_occupation=="TAILORING COOLIE"| _2_c_occupation=="BULLOCART DRIVER" ///
 |_2_c_occupation=="BUS CLEANER" | _2_c_occupation=="HELPER -COOKING" ///
 | _2_c_occupation=="HOTEL WORK" | _2_c_occupation=="HOTEL WORKER" | _2_c_occupation=="TEMPO DRIVER" ///
 | _2_c_occupation=="COOLIE IIN HOTEL"| _2_c_occupation=="COOLIE IN CENIMA THEATRE" | _2_c_occupation=="COOLIE IN HOTEL" ///
 | _2_c_occupation=="TENT HOUSE WORK" 

 
* regular non-qualified (clerical, industry, shops)
replace occupcode2010=4 if _2_c_occupation=="BANK CLERK" | _2_c_occupation=="BANK WATCHMAN" ///
| _2_c_occupation=="BUS CONDUCTOR" | _2_c_occupation=="GOVT.DRIVER" | _2_c_occupation=="GOVERNMENT DRVER" ///
| _2_c_occupation== "GOVT SERVANT" ///
| _2_c_occupation=="WATCHMAN" | _2_c_occupation=="VAN DRIVER" | _2_c_occupation=="POST MAN Rtd" |_2_c_occupation=="PVT SECURITY" ///
| _2_c_occupation=="POST OFFICE CLERK"| _2_c_occupation=="VILLAGE ASSISTANED" | _2_c_occupation=="VILLAGE ASST."  ///
| _2_c_occupation=="WATER TANK OPERATOR" | _2_c_occupation=="PAINTER" | _2_c_occupation=="MASON" ///
| _2_c_occupation=="CARPENTAR" | _2_c_occupation=="CARPENTER" | _2_c_occupation=="CORPENTOR" ///
| _2_c_occupation=="FITTER IN CHENNAI" | _2_c_occupation=="FLOUR MILL" ///
| _2_c_occupation=="GROSORY SHOP" | _2_c_occupation=="WORKING IN COOLDRINKS SHOP" ///
| _2_c_occupation=="WORKING IN JEWELLERY SHOP" | _2_c_occupation=="WORKING IN JEWELRY SHOP" ///
| _2_c_occupation=="WORKING IN WINE SHOP" | _2_c_occupation=="FLLOWER SHOP COOLIE"| _2_c_occupation=="FLOOWER SHOP WORK" ///
| _2_c_occupation=="TEXTILE SHOP WORK" | _2_c_occupation=="DRIVER"| _2_c_occupation=="DRIVING" 


* regular qualified  
replace occupcode2010=5 if _2_c_occupation=="AMN ASSISTANT (ARMY WORK)"| _2_c_occupation=="ANGANVADI STAFF (NURSERY SCHOOL JOB)" ///
| _2_c_occupation=="ANGANWADI HELPER (NURSERY SCHOOL JOB)" | _2_c_occupation=="ANGANWADI SERVANT  (NURSERY SCHOOL JOB)" ///
| _2_c_occupation=="EID PARRY (sugar mill factory)" | _2_c_occupation=="ENGINEER" ///
| _2_c_occupation=="PRIVATE COMPANY WORK" & _23_1_g_work_type==1 | _2_c_occupation=="SERVICE ENG LG" ///
| _2_c_occupation=="TRAINING TEACHER" | _2_c_occupation=="�UDITOR ASSISSTEND"  ///
| _2_c_occupation=="PVT CO." | _2_c_occupation=="PVT.COMPANY" | _2_c_occupation=="WORKING IN PVT COMPANY" | _2_c_occupation== "PRIVATE COMPANY WORKER" ///
| _2_c_occupation== "PVT COMPANY"  | _2_c_occupation== "PVT.CO" ///
| _2_c_occupation=="COOPERATIVE BANK WORKER" | _2_c_occupation=="GOVT.JOB" | _2_c_occupation=="LIC AGENT (INSURANCE)" ///
| _2_c_occupation=="MECHANIC" | _2_c_occupation=="MECHANIC WORK" ///
| _2_c_occupation=="ELECTRECIAN" | _2_c_occupation=="ELECTRICIAN" 
 
*SE
replace occupcode2010=6 if _2_c_occupation_code2==8| _2_c_occupation_code2==5 |_2_c_occupation=="MOTOR WORKSHOP" ///
| _2_c_occupation=="CHAMBER MAISTRY" | _2_c_occupation=="CONSTRUCTION MAISTRY" |_2_c_occupation=="CLAY TOY MAKING" 

* recode from SE to regular non qualified (welders)
replace occupcode2010=4 if occupcode2010==6 & _2_c_occupation=="WELDER"|occupcode2010==6 & _2_c_occupation=="WELDING" |occupcode2010==6 & _2_c_occupation=="WELDING WORKSHOP" 
replace occupcode2010=4 if occupcode2010==6 & _2_c_occupation=="CONDUCTOR BUS"|occupcode2010==6 & _2_c_occupation=="WELDING" |occupcode2010==6 & _2_c_occupation=="WELDING WORKSHOP"

* recode from SE to regular qualified (mechanics)
replace occupcode2010=5 if occupcode2010==6 & _2_c_occupation=="AC MECHANIC" |occupcode2010==6 & _2_c_occupation=="MOTOR WORKSHOP" |occupcode2010==6 & _2_c_occupation=="TV MECHANIC"


*NREGA
replace occupcode2010=7 if _2_c_occupation_code2==4

*reste=pension 

************************ same occupcode2 for 2010 & 2016 
 
gen occupcode2=occupcode2016 if year==2016
replace occupcode2=occupcode2010 if year==2010
label values occupcode2 occupcode

replace occupationname=_2_c_occupation if occupationname=="" 
bys year: tab occupationname if occupcode2==4


replace occupcode2=5 if occupcode2==. & occupationname=="Advocate"
replace occupcode2=4 if occupcode2==. & occupationname=="Bus driver"
replace occupcode2=4 if occupcode2==. & occupationname=="Office assistant in Co-operative bank"
replace occupcode2=4 if occupcode2==. & occupationname=="Water company private"
replace occupcode2=4 if occupcode2==. & occupationname=="Accountant in ration (gov job) no contract yet"
replace occupcode2=4 if occupcode2==. & occupationname=="Secretary(primary agriculture cooperative bank)"

replace occupcode2=5 if occupcode2==. & occupationname=="PENSION FOR RETAIRED POST MAN"
replace occupcode2=5 if occupcode2==. & occupationname=="PENSION FOR RETAIRED TEACHER"
replace occupcode2=5 if occupcode2==. & occupationname=="PENTIONER"
replace occupcode2=5 if occupcode2==. & occupationname=="TEACHER Rtd"
replace occupcode2=4 if occupcode2==. & HHINDID=="PSOR384/3" & year==2010 & occupationid==1


replace occupationid=. if occupationname=="No occupation"


tab occupcode2 year, column
 
 
************************ Define construction sector dummies (sector 22,26,31,32)
 
gen construction_coolie=( _2_c_occupation== "CENTRING WORK (CONSTRUCTION)"| _2_c_occupation=="CONSTRUCTION WROK"  ///
 | _2_c_occupation=="BRICK WORK" | _2_c_occupation=="CHAMBER" | _2_c_occupation=="CHAMBER WORK"| _2_c_occupation=="CHAMEBER WORK" ///
 | _2_c_occupation=="CONSTRUCTION"  | _2_c_occupation=="CONSTRUCTION WORK"| _2_c_occupation=="CONSTRUCTION WORKER COOLIE" ///
 | _2_c_occupation=="ROAD WORK" | _2_c_occupation=="SULAI VELAI (CHAMBER)"| _2_c_occupation=="SUVELAI (CHAMBER)") if occupcode2010==3
 tab occupationname occup_sector if occup_sector2==3 & occupcode2016==3
replace construction_coolie=(occupcode2016==3 & occup_sector==22|occupcode2016==3 & occup_sector==26|occupcode2016==3 & occup_sector==31) if year==2016

  
gen construction_regular = (_2_c_occupation=="PAINTER" | _2_c_occupation=="MASON" ///
| _2_c_occupation=="CARPENTAR" | _2_c_occupation=="CARPENTER" | _2_c_occupation=="CORPENTOR") if occupcode2010==4
tab occupationname occup_sector if occup_sector2==3 & occupcode2016==4
replace construction_regular=(occupcode2016==4 & occup_sector==22|occupcode2016==4 & occupationname=="Welder"|occupcode2016==4 & occupationname=="Welding labour"|occupcode2016==4 & occup_sector==32) if year==2016


gen construction_qualified = ( _2_c_occupation=="ELECTRECIAN" | _2_c_occupation=="ELECTRICIAN" ///
| _2_c_occupation=="CHAMBER MAISTRY" | _2_c_occupation=="CONSTRUCTION MAISTRY" | _2_c_occupation=="REAL ESTATE" ///
| _2_c_occupation=="CHAMBER OWN") if occupcode2010==5| occupcode2010==6
tab occupationname occup_sector if occup_sector2==3 & occupcode2016==5
tab occupationname occup_sector if occupcode2016==5
tab occupationname occup_sector if occup_sector2==3 & occupcode2016==6
tab occupationname occup_sector if occupcode2016==6
replace construction_qualified = (occupcode2016==5 & occup_sector==26 & occupationname!="Tv mechanic self employed" ///
|occupcode2016==6 & occup_sector==61 & occupationname!="Mason maistry" ///
|occupcode2016==6 & occup_sector==61 & occupationname =="Brickling maistry" | occupcode2016==6 & occup_sector==61 & occupationname =="Maistry (contractor)" ///
|occupcode2016==6 & occup_sector==61 & occupationname == "Construction maistry" |occupcode2016==6 & occup_sector== 85 & occupationname == "Building contractor") if year==2016	



gen cc=.
replace cc=0 if construction_coolie==0 & occupcode2==3
replace cc=1 if construction_coolie==1 & occupcode2==3
drop construction_coolie
ren cc construction_coolie
tab construction_coolie year, column

gen cr=.
replace cr=0 if construction_regular==0 & occupcode2==4
replace cr=1 if construction_regular==1 & occupcode2==4
drop construction_regular
ren cr construction_regular
tab construction_regular year, column

gen cq=.
replace cq=0 if construction_qualified==0 & occupcode2==5
replace cq=1 if construction_qualified==1 & occupcode2==5
drop construction_qualified
ren cq construction_qualified
tab construction_qualified year, column


* occupcode3 includes individuals counted in working pop but not working 
gen occupcode3=occupcode2 
replace occupcode3=0 if occupationid==.

label define occupcode 0 "No occupation", modify
label values occupcode3 occupcode




*************************************

/*
replace occupcode=5 if occup_sector2==3 & kindofwork!=2
replace occupcode=6 if occup_sector2==9 & kindofwork==4
replace occupcode=7 if occup_sector2==8 & kindofwork!=2
replace occupcode=8 if occup_sector2==4 | occup_sector2==5 
replace occupcode=9 if occup_sector2==7 | occup_sector2==6 & kindofwork==4 


label define occupcode 1 "Cultivators" 2 "Agricultural and plantation labourers" 3 "Self-employed(production,services,selling,artists)" 4 "NREGA" ///
5 "Non-agri production labourers" 6 "Service workers(employed)" 7 "Sellers/shops workers(employed)" 8 "Qualified,executive & managerial jobs" 9 "Clerical workers & maistries", modify
label values occupcode occupcode

tab kindofwork occupcode 
tab occupationname if occupcode==9

gen occupcode2= occupcode
replace occupcode2=6 if occupcode2==7
replace occupcode2=7 if occupcode2==8
replace occupcode2=7 if occupcode2==9

label define occupcode2 1 "Cultivators" 2 "Agricultural and plantation labourers" 3 "Self-employed(production,services,selling,artists)" 4 "NREGA" ///
5 "Non-agri production labourers" 6 "Service/sellers/shop workers(employed)" 7 "Qualified jobs,Clerical workers & maistries", modify
label values occupcode2 occupcode2


gen occupcode3=1 if occupcode2==1
replace occupcode3=2 if occupcode2==2
replace occupcode3=3 if occupcode2==5 
replace occupcode3=4 if occupcode2==5 & occup_sector==22
replace occupcode3=5 if occupcode2==3
replace occupcode3=6 if occupcode2==6
replace occupcode3=7 if occupcode2==7
replace occupcode3=8 if occupcode2==4

label define occupcode3 1 "Cultivators" 2 "Agricultural and plantation labourers" 3 "Non-agri production labourers (no const)" 4 "Construction production labourers"  ///
5 "Self-employed(production,services,selling,artists)" 6 "Service/sellers/shop workers(employed)" 7 "Qualified jobs,Clerical workers & maistries" 8 "NREGA", modify
label values occupcode3 occupcode3

tab occupcode3 year, column
*/


* Labelisation of key variables of occupations
	
		**label PROFESSION of workers (occup_sector)
	rename occup_sector occupation1
	label var occupation1 "Detailed occupations of workers"
	label define occupation1 11 "Cultivators" 12 "Agricultural labourers" 13"Sugarcane plantation labourers" 14 "Other farm workers" 22 "Bricklayers and construction workers (chamber, roads)" ///
	23 "Spinners, Weavers, Knitters, Dyers" 24 "Tailors, dress makers, sewers" 25 "Clay workers, potters, sculptors, painters" 26 "Electrical workers" 27 "Mechanic and machinery fitters/assemblers (except electrical)" ///
	28 "Transport Equipment operators" 29 "Stationery Engines and related equipment operators" 30 "Material handling and related equipment operators (loaders/unloaders)" ///
	31 "Other Industrial workers (glass, mining, chemicals, printing, welders)" 32 "Other craftsworkers (Carpenters, tiles workers, Paper product makers)" 33 "Other labour" ///
	41 "Teachers" 42 "Architects, Engineers, ..." 43 "Engineering technicians" 44 "Scientific, medical and technical persons" 45 "Nursing and health technicians" 46 "Economists, Accountants, auditors" ///
	47 "Jurists" 51 "Administrative and executive officials government and local bodies" 52 "Working proprietors, directors, managers in mining, construction, manufacturing" ///
	61 "Independent labour contractors" 71 "Clerical and other supervisors" 72 "Other clerical workers" 73 "Transport conductors and guards" 81 "Shop keepers (wholesale and retail)" ///
	82 "Agri equipment sellers" 83 "Rent shop/ activities" 84 "Salesmen, shop assistants and related workers" 85 "Technical salesmen & commercial travellers" 86 "Money lenders and pawn brokers" ///
	91 "Hotel and restaurant keepers" 92 "Cooks, waiters" 93 "Building caretakers, sweepers, cleaners" 94 "Maids and house keeping service workers" 95 "Hair dressers, barbers..." 96 "Private transportation" ///
	97 "Other service workers" 101 "Performing artists" 102 "Astrologers" 111 "Public works/ NREGA"
	label value occupation1 occupation1

		**label Occupations of workers
	rename occupcode2 occupation2
	label var occupation2 "Occupations of workers"
		
		**label Occupations of workers + unoccupied individuals
	rename occupcode3 occupation3
	label var occupation3 "Occupations of workers + unoccupied individuals"

		**Generate and label occupation variable only for population on working age (15-60 included)
	gen occupation4=.
	replace occupation4=occupation3 if age>14 & age<71
	label define occupcode 0 "Unoccupied working age individuals", modify
	label var occupation4 "Occupations of workers + unoccupied working age indiv (15-70)"
	label values occupation4 occupcode

		**Generate active and inactive population in the same variable
		
	gen working_pop=.
	replace working_pop = 1 if occupation4==.
	replace working_pop = 2 if occupation4==0	
	replace working_pop = 3 if occupation4>0 & occupation4!=.
	label define working_pop 1 "Inactive" 2 "Unoccupied active" 3 "Occupied active", modify
	label var working_pop "Distribution of inactive and active population accord. to criteria of age 15-70"
	label values working_pop working_pop


rename occupation1 profession
rename occupation2 occupation
rename occupation3 occupa_unemployed
rename occupation4 occupa_unemployed_15_70
rename castecode caste_group
rename caste jatis
	
*save "C:\Users\CJ Nordman\Dropbox (IRD)\_Inde documents\_Projets_Recherche\_NEEMSIS\Data\Panel\Panel databases for analysis\Panel_occupations_clean.dta", replace
save "C:\Users\Seb\Dropbox\NEEMSIS\Data\Panel\Panel databases for analysis\Panel_occupations_clean.dta", replace


$$$$$$ THE END $$$$$$$$$$$

