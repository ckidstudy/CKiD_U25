
/* STATA Code for calculating U25 eGFR  */
/* Reference: Pierce CB, Muñoz A, Ng DK, Warady BA, Furth SL, Schwartz GJ. Age- and sex-dependent clinical equations to estimate glomerular filtration rates in children and young adults
with chronic kidney disease. Kidney Int. 2021 Apr;99(4):948-956. doi: 10.1016/j.kint.2020.10.047. Epub 2020 Dec 8. [ PMID: 33301749]*/
/* Online calculators access: https://ckid-gfrcalculator.shinyapps.io/eGFR/   or   https://qxmd.com/calculate/calculator_822/ckid-u25-egfr-calculator  # 

Input:
VARIABLE 		DESCRIPTION
female 			sex, 0 for male, 1 for female
age 			age, years (value between 1 to 25 years)
ht_m 			height,  meters (value between 0.6 and 2 m)
sCr 			Serum creatinine, mg/dL (value between 0.1 and 10 mg/dL)
cyc_ifcc		IFCC-calibrated Cystatin C, mg/dL (value between 0.2-8 and IFCC-calibrated. 
				A non-calibrated Siemens cystatin C value should be multiplied by 1.17 to approximate its equivalent IFCC-calibrated value.)

Output:
VARIABLE 		DESCRIPTION
eGFRU25scr		U25 eGFR based on serum creatinine only
eGFRU25cys		U25 eGFR based on IFCC-calibrated cystatin c only
eGFRU25ave		U25 eGFR based on serum creatinine and IFCC-calibrated cystatin c as average of eGFRU25scr and eGFRU25cys
*/

infile ID female age ht_m sCr cyc_ifcc using "filepath\U25eGFRtest.dat", clear

gen		ckidKscr = 39.0 * (1.008^(age-12)) if (female==0 & age< 12)
replace	ckidKscr = 39.0 * (1.045^(age-12)) if (female==0 & age>= 12 & age< 18)
replace	ckidKscr = 50.8                    if (female==0 & age>= 18)
replace	ckidKscr = 36.1 * (1.008^(age-12)) if (female==1 & age< 12)
replace ckidKscr = 36.1 * (1.023^(age-12)) if (female==1 & age>= 12 & age< 18)
replace ckidKscr = 41.4                    if (female==1 & age>= 18)

gen eGFRU25scr= ckidKscr * ht_m / sCr

gen		ckidKcyc = 87.2 * (1.011^(age-15)) if (female==0 & age< 15)
replace	ckidKcyc = 87.2 * (0.960^(age-15)) if (female==0 & age>= 15 & age< 18)
replace	ckidKcyc = 77.1                    if (female==0 & age>= 18)
replace	ckidKcyc = 79.9 * (1.004^(age-12)) if (female==1 & age< 12)
replace ckidKcyc = 79.9 * (0.974^(age-12)) if (female==1 & age>= 12 & age< 18)
replace ckidKcyc = 68.3                    if (female==1 & age>= 18)

gen eGFRU25cyc= ckidKcyc / cyc_ifcc

gen eGFRU25average= (eGFRU25scr + eGFRU25cyc) / 2

list