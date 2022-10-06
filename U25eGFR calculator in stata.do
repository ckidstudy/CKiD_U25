
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

* to drop program after changes pro drop ProgramName
pro drop U25eGFR 

program U25eGFR
	args female age ht_m sCr cyc_ifcc
		drop _all
		quietly set obs 1
		 generate	ckidKscr = 39.0 * (1.008^(`age'-12))*(`female'==0 & `age'< 12)  ///
		 +39.0 * (1.045^(`age'-12))*(`female'==0 & `age'>= 12 & `age'< 18)  ///
		 +50.8                     *(`female'==0 & `age'>= 18)              ///
		 +36.1 * (1.008^(`age'-12))*(`female'==1 & `age'< 12)               ///
		 +36.1 * (1.023^(`age'-12))*(`female'==1 & `age'>= 12 & `age'< 18)  ///
		 +41.4                     *(`female'==1 & `age'>= 18)
		generate 	eGFRU25scr= ckidKscr*`ht_m'/`sCr'
		
		 generate	ckidKcyc = 87.2 * (1.011^(`age'-15))*(`female'==0 & `age'< 15)   ///
					+87.2 * (0.960^(`age'-15))*(`female'==0 & `age'>= 15 & `age'< 18)  ///
					+77.1                   * (`female'==0 & `age'>= 18)           ///
					+79.9 * (1.004^(`age'-12))*(`female'==1 & `age'< 12)             ///
					+79.9 * (0.974^(`age'-12))*(`female'==1 & `age'>= 12 & `age'< 18)  ///
					+68.3                   *(`female'==1 & `age'>= 18)		 
		 generate 	eGFRU25cyc= ckidKcyc * 1/`cyc_ifcc'
		 
		 generate	eGFRU25ave = (eGFRU25scr + eGFRU25cyc) / 2
		 
		 *display `female' 
		 *display `age' 
		 display "eGFRU25screatinine is"
		 display eGFRU25scr
		 display "eGFRU25cystatinC is"
		 display eGFRU25cyc
		 display "eGFRU25 as average of the sCreatinine's and cystatinC's is"
		 display eGFRU25ave
		 drop ckidKscr eGFRU25scr ckidKcyc eGFRU25cyc eGFRU25ave
		 quietly set obs 0
end

U25eGFR 0 13.91 1.59 2.8  4.02
U25eGFR 0 10.96 1.4  1.36 1.61   
U25eGFR 1 13.01 1.43 4.5  4.9     
U25eGFR 0  8.15 1.28  .69 1.45      

