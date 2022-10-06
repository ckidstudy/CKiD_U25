# R Code for calculating U25 eGFR  
# Reference: Pierce CB, Muñoz A, Ng DK, Warady BA, Furth SL, Schwartz GJ. 
# Age- and sex-dependent clinical equations to estimate glomerular filtration rates in children and young adults with chronic kidney disease. 
# Kidney Int. 2021 Apr;99(4):948-956. doi: 10.1016/j.kint.2020.10.047. Epub 2020 Dec 8. [ PMID: 33301749] 
# Online calculators access: https://ckid-gfrcalculator.shinyapps.io/eGFR/   or   https://qxmd.com/calculate/calculator_822/ckid-u25-egfr-calculator  # 

# Input:
# VARIABLE    DESCRIPTION
# female      sex, 0 for male, 1 for female
# age       age, years (value between 1 to 25 years)
# ht_m      height,  meters (value between 0.6 and 2 m)
# sCr       Serum creatinine, mg/dL (value between 0.1 and 10 mg/dL)
# cyc_ifcc    IFCC-calibrated Cystatin C, mg/L (value between 0.2-8 and IFCC-calibrated. 
#   A non-calibrated Siemens cystatin C value should be multiplied by 1.17 to approximate its equivalent IFCC-calibrated value.)
# 
# Output:
# VARIABLE    DESCRIPTION
# eGFRU25scr    U25 eGFR based on serum creatinine only
# eGFRU25cys    U25 eGFR based on IFCC-calibrated cystatin c only
# eGFRU25ave    U25 eGFR based on serum creatinine and IFCC-calibrated cystatin c as average of eGFRU25scr and eGFRU25cys
#

# Calculated from Shinyapps.io */
# Male, age 11, height 1.2, SCr 0.9, CysC 1.3  		U25GFRSCr= 51.6; CysC= 64.2; Avg= 57.9; */
# Female, age 11, height 1.2, SCr 0.9, CysC 1.3  		U25GFRSCr= 47.8; CysC= 61.2; Avg= 54.5; */
# Male, age 15, height 1.6, SCr 1.9, CysC 1.6  		U25GFRSCr= 37.5; CysC= 54.5; Avg= 46.0; */
# Female, age 15, height 1.6, SCr 1.9, CysC 1.6  		U25GFRSCr= 32.5; CysC= 46.1; Avg= 39.3; */
# Male, age 20, height 1.81, SCr 2.1, CysC 1.8  		U25GFRSCr= 43.8; CysC= 42.8; Avg= 43.3; */
# Female, age 20, height 1.81, SCr 2.1, CysC 1.8  		U25GFRSCr= 35.7; CysC= 37.9; Avg= 36.8; */

male <- c(1,0,1,0,1,0)
age <- c(11,11,15,15,20,20)
ht_m <- c(1.2, 1.2, 1.6, 1.6, 1.81,1.81)
scr <- c(0.9, 0.9, 1.9, 1.9, 2.1, 2.1)
cyc_c <- c(1.3, 1.3, 1.6, 1.6, 1.8, 1.8)


k_htdscr=(male)*((age_lt12)*(39.0*1.008^(age_m12))+(age_ge12*age_lt18)*(39.0*1.045^(age_m12))+((age_ge18)*50.8)) +
+(female)*((age_lt12)*(36.1*1.008^(age_m12))+(age_ge12*age_lt18)*(36.1*1.023^(age_m12))+((age_ge18)*41.4)),

eGFRU25scr= k_htdscr*(ht_m/scr),

k_cysc=(male)*((age_lt15)*(87.2*1.011^(age-15))+(age_ge15*age_lt18)*(87.2*0.960^(age-15))+((age_ge18)*77.1)) +
  +(female)*((age_lt12)*(79.9*1.004^(age-12))+(age_ge12*age_lt18)*(79.9*0.974^(age-12))+((age_ge18)*68.3)),

eGFRU25cys = k_cysc*(1/cyc_c),

eGFRU25ave = (eGFRU25scr + eGFRU25cys)/2

print(cbind(eGFRU25scr, eGFRU25cys, eGFRU25ave))