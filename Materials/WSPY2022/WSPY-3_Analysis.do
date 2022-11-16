*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*November 15, 2022
*-----
*WSPY 2022
*-----
do "https://raw.githubusercontent.com/arnaudnatal/odriis/main/Materials/WSPY2022/_WSPY22.do"
*-------------------------

*https://www.ideasforindia.in/topics/poverty-inequality/spatial-disparities-in-household-earnings-in-india.html

log using WSPY2022.log, replace


****************************************
* Ineq at HH level
***************************************
use"panel_HH_wide", clear

/*
Revenu du travail par mois des menages.
En roupies de 2010 --> donc nous pouvons comparer.
*/


********** Descriptive
tabstat monthlyincome2010 monthlyincome2016 monthlyincome2020, stat(n mean sd cv)
/*
CV de :
0.74 en 2010;
1.00 en 2016-17;
1.05 en 2020-21.
Les inegalites de revenu augmentent entre 2010 et 2020-21.
*/

preserve
use"panel_HH_long", clear

*** Kernel
twoway ///
(kdensity monthlyincome if year==2010 & monthlyincome<=100000, bwidth(2000)) ///
(kdensity monthlyincome if year==2016 & monthlyincome<=100000, bwidth(2000)) ///
(kdensity monthlyincome if year==2020 & monthlyincome<=100000, bwidth(2000)) ///
, xtitle("Monthly income per household") ytitle("Kernel density") ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3)) note("Kernel: epanechnikov" "Bandwidth=2000", size(vsmall))
graph export "kincHH.pdf", replace
/*
L'etendue de la fonction de densite augmente avec les annees.
On peut donc supposer que les inegalites augmentent.
*/

* Box plot
recode year (2010=1) (2016=2) (2020=3)
stripplot monthlyincome, over(year) vert ///
stack width(500) jitter(1) ///
box(barw(0.2)) boffset(-0.2) pctile(90) ///
ms(oh) msize(small) mc(black%30) ///
xmtick(0.9(0)2.5) xtitle("") ///
ytitle("Monthly income per household") xlabel(1 "2010" 2 "2016-17" 3 "2020-21",angle(0))
graph export "bincHH.pdf", replace
/*

Les boites sont de plus en plus grandes, donc l'intervalle entre p25 et p75 s'accroit.

Les barres au dessus et en dessous permettent d'interger 80% de la pop : 
- le haut de la barre du haut represente p90
- le bas de la barre du bas represente p10
L'etendue de la boite + moustaches s'etend au cours du temps : les revenus sont de plus en plus disperses = plus d'inegalites.
*/
restore



********** Indicators of inequalities

*** Quantile share ratio
foreach i in 2010 2016 2020 {
qui sum monthlyincome`i', det
gl p90p10_`i'=r(p90)/r(p10)
gl p90p50_`i'=r(p90)/r(p50)
gl p75p25_`i'=r(p75)/r(p25)
}

dis $p90p10_2010 
dis $p90p10_2016
dis $p90p10_2020
/*
En 2010, les 10 % des menages les plus riches sont plus de 4x plus riches que les 10 % des menages les plus pauvres.
En 2016-17, nous passons a presque 8x.
En 2020-21, presque 13x.
Les inegalites augmentent 
*/

dis $p90p50_2010 
dis $p90p50_2016
dis $p90p50_2020
/*
En 2010, les 10 % des menages les plus riches sont plus de 2x plus riches que les 50 % des menages les plus pauvres.
En 2016-17, nous passons a presque 2.5x.
En 2020-21, presque 2.7x.
Les inegalites augmentent 
*/

dis $p75p25_2010 
dis $p75p25_2016
dis $p75p25_2020
/*
En 2010, les 25 % des menages les plus riches sont plus de 2x plus riches que les 25 % des menages les plus pauvres.
En 2016-17, nous passons a 3x.
En 2020-21, presque 4x.
Les inegalites augmentent 
*/




*** Percentile share
pshare estimate monthlyincome2010 monthlyincome2016 monthlyincome2020
pshare stack
graph export "psHH.pdf", replace
/*
On voit que la part des revenus detenu par les 20% les plus riches augmente au cours du temps.
Le segment noir qui s'aggrandit.
*/


*** Gini
pshare estimate monthlyincome2010 monthlyincome2016 monthlyincome2020, gini
/*
Gini, compris entre 0 et 1.
0 represen l'egalite parfaite, 1 l'inegalite parfaite.
Nous voyons que le Gini passe de .32 a .44 puis .49.
Les inegalites augmentent.
*/


*** Lorenz
lorenz estimate monthlyincome2010 monthlyincome2016 monthlyincome2020
lorenz graph, overlay
graph export "loHH.pdf", replace
/*
Plus la courbe est convexe, plus il y a des inegalites.
La premiere bissectrice represente le niveau d'egalite parfaite :
Les a % de la population les plus pauvres detiennent a % des revenus.

Il y a un gap entre 2010 et 2016-17 / 2020-21.
Creusement des inegalites consequent.
Entre 2016-17 et 2020-21, les inegalites se creusent, mais moins fort.
*/




********** Contribution of transferts
* Desc
tabstat monthlyincome2010 monthlytotinc2010, stat(n mean sd cv)
tabstat monthlyincome2016 monthlytotincbis2016, stat(n mean sd cv)
tabstat monthlyincome2020 monthlytotincbis2020, stat(n mean sd cv)

* Gini
pshare est monthlyincome2010 monthlytotinc2010, gini
pshare est monthlyincome2016 monthlytotincbis2016, gini
pshare est monthlyincome2020 monthlytotincbis2020, gini 
/*
Les transferts ne reduisent pas les inegalites.
Nous pouvons enlever je pense.
*/





********** Decomposition par source
descogini annualincome2010 incomeagri2010 incomenonagri2010
sum shareincomeagri2010 shareincomenonagri2010
/*
En 2010 :
- 21% de l'inegalite totale est liee aux activites agri
- 79% au non-agri

Alors que agri represente en moyenne 43% du revenu total.
Et non-agri represente en moyenne 57% du revenu total.

Conclusion: 
Donc non-agri activite inegalisatrice
*/

descogini annualincome2016 incomeagri2016 incomenonagri2016
sum shareincomeagri2016 shareincomenonagri2016
/*
En 2016-17 :
- 22% de l'inegalite totale est liee aux activites agri
- 78% au non-agri

Alors que agri represente en moyenne 32% du revenu total.
Et non-agri represente en moyenne 68% du revenu total.

Conclusion: 
Donc non-agri activite inegalisatrice
*/

descogini annualincome2020 incomeagri2020 incomenonagri2020
sum shareincomeagri2020 shareincomenonagri2020
/*
En 2020-21 :
- 22% de l'inegalite totale est liee aux activites agri
- 78% au non-agri

Alors que agri represente en moyenne 35% du revenu total.
Et non-agri represente en moyenne 65% du revenu total.

Conclusion: 
Donc non-agri activite inegalisatrice
*/
 
 
/*
Quand Sk est inf a share, alors composante inegalisatrice
% Change : elasticite, mais signe surtout -> si + alors inegalisatrice, si - egalisatrice
*/




********** Inegalites entre les castes
foreach i in 2010 2016 2020 {
stripplot monthlyincome`i', over(caste) vert ///
stack width(500) jitter(1) ///
box(barw(0.2)) boffset(-0.2) pctile(90) ///
ms(oh) msize(small) mc(black%30) ///
xmtick(0.9(0)2.5) xtitle("") ///
ytitle("Monthly income per household in `i'") xlabel(1 "Dalits" 2 "Middle castes" 3 "Upper castes",angle(0)) name(binccaste_`i', replace)
graph export "bincaste`i'.pdf", replace
}

/*
En 2010 : Il semble qu'il y a plus d'inegalites au sein des castes eleves (la boite est plus haute)
De plus, la boite est legerement au dessus des autres, donc les upper castes sont plus riches


En 2016-17 : Boite middle et upper a peu pres la même taille et plus grandes que dalits, donc plus d'inegalites chez les middle et upper que chez les dalits
De plus, boite middle au dessus de dalits et boite upper au dessus de middle
Donc inegalites entre les castes, en faveurs des uppers et en defaveurs des dalits

En 2020-21 : la tendance de 2016-17 se poursuit
*/



****************************************
* END










****************************************
* What about individual level?
***************************************
use"panel_indiv_wide", clear

********** Descriptive
tabstat monthlyincome2010 monthlyincome2016 monthlyincome2020, stat(n mean sd cv min max)
/*
CV de :
1.05 en 2010;
1.55 en 2016-17;
1.50 en 2020-21.
Les inegalites de revenu augmentent entre 2010 et 2020-21.
Beaucoup plus de var que pour les HH
*/



********** Indicators of inequalities
*** Quantile share ratio
foreach i in 2010 2016 2020 {
qui sum monthlyincome`i', det
gl p90p10_`i'=r(p90)/r(p10)
gl p90p50_`i'=r(p90)/r(p50)
gl p75p25_`i'=r(p75)/r(p25)
}

dis $p90p10_2010 
dis $p90p10_2016
dis $p90p10_2020

dis $p90p50_2010 
dis $p90p50_2016
dis $p90p50_2020

dis $p75p25_2010 
dis $p75p25_2016
dis $p75p25_2020

/*
Il y a vraiment beaucoup plus d'inegalites entre les individus qu'entre les menages
*/


*** Percentile share
pshare estimate monthlyincome2010 monthlyincome2016 monthlyincome2020
pshare stack
graph export "psindiv.pdf", replace
/*
Même constat: inegalites beaucoup plus fortes entre les indiv qu'entre les menages.
*/


*** Gini
pshare estimate monthlyincome2010 monthlyincome2016 monthlyincome2020, gini 
/*
Gini passe de .44 a .58 a .57
Pour les menages nous passions de .32 a .44 puis .49.
Plus d'inegalites entre les indiv plutot qu'entre les menages.
*/




********** Constat
/*
On voit donc qu'il y a beaucoup plus d'inegalites entre les individus plutot qu'entre les menages.

Pourquoi ?
*/






********** Reponse
/*
a l'echelle des menages, les inegalites entre les sexes sont lissees
*/

/*
foreach i in 2010 2016 2020 {
twoway ///
(kdensity monthlyincome2020 if sex==1 & monthlyincome`i'<=100000, bwidth(2000)) ///
(kdensity monthlyincome2020 if sex==2 & monthlyincome`i'<=100000, bwidth(2000)) ///
, xtitle("Monthly income per individual in `i'") ytitle("Kernel density") ///
legend(order(1 "Male" 2 "Female") pos(6) col(3)) note("Kernel: epanechnikov" "Bandwidth=2000", size(vsmall)) name(kinc_`i', replace)
}
*/

foreach i in 2010 2016 2020 {
stripplot monthlyincome`i', over(sex) vert ///
stack width(500) jitter(1) ///
box(barw(0.2)) boffset(-0.2) pctile(90) ///
ms(oh) msize(small) mc(black%30) ///
xmtick(0.9(0)2.5) xtitle("") ///
ytitle("Monthly income per individual in `i'") xlabel(1 "Male" 2 "Female",angle(0)) ///
name(binc_`i', replace)
graph export "bincsex_`i'.pdf", replace
}
/*
La boite des hommes est toujours au-dessus de celle des femmes : les hommes ont un revenu plus eleve.
La boite est aussi beaucoup plus etalee, donc plus d'inegalites chez les hommes que chez les femmes.
C'est normal :
Soit les femmes ne travaillent pas,
Soit elles ont un tres faible revenu.

Pour les hommes, il y en a qui travaillent, d'autres non, des riches, des pauvres.
Plus d'inegalites.
*/

****************************************
* END










****************************************
* Decomposition
***************************************
/*
En prenant les donnees 2020-21, en ne gardant que les individus qui travaillent
En ne prenant que les egos car competences cognitives

Nous allons explorer le gender dap
*/

use"wave3", clear

********** Clean
fre egoid
drop if egoid==0

ta caste, gen(caste_)
ta edulevel, gen(edulevel_)
fre mainocc_occupation_indiv
ta mainocc_occupation_indiv, gen(occup_)

fre sex
replace sex="1" if sex=="Male"
replace sex="2" if sex=="Female"
destring sex, replace
label define sex 1"Male" 2"Female"
label values sex sex
replace sex=sex-1
fre sex

destring age, replace

drop if mainocc_annualincome_indiv==0
drop if mainocc_annualincome_indiv==.


********** Decomposition
decompose mainocc_annualincome_indiv age caste_2 caste_3 edulevel_2 edulevel_3 edulevel_4 edulevel_5 edulevel_6 mainocc_tenureday_indiv occup_1 occup_3 occup_4 occup_5 occup_6 occup_7, by(sex)

/*

Y = revenu annuel

X = age, caste, education, nb de jour d'anciennete, type d'emploi

*/


decompose mainocc_annualincome_indiv age caste_2 caste_3 edulevel_2 edulevel_3 edulevel_4 edulevel_5 edulevel_6 mainocc_tenureday_indiv raven_tt num_tt lit_tt occup_1 occup_3 occup_4 occup_5 occup_6 occup_7, by(sex)

/*

Y = revenu annuel

X = age, caste, education, nb de jour d'anciennete, type d'emploi

+ Raven, numeracy, literacy.

*/


decompose mainocc_annualincome_indiv age caste_2 caste_3 edulevel_2 edulevel_3 edulevel_4 edulevel_5 edulevel_6 mainocc_tenureday_indiv raven_tt num_tt lit_tt locus occup_1 occup_3 occup_4 occup_5 occup_6 occup_7, by(sex)

/*

Y = revenu annuel

X = age, caste, education, nb de jour d'anciennete, type d'emploi

+ Raven, numeracy, literacy.

+ Locus

*/

****************************************
* END


log close
graphlog using "WSPY2022.log", lspacing(1) fsize(10) replace
