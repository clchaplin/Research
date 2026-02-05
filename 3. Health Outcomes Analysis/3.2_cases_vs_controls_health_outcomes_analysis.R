## STATS ON HEALTH OUTCOMES 

#load packages 
library (tidyverse)
library (dplyr)
library(psych)
library(ggplot2)
library(vcd)
library(table1)
library(flextable)

## load health outcomes for cases and controls(with quant variables from primary care, quant variables taken from 'readings-at-unique-timepoints')
chronic_alt_outcomes <- read_table("/home/ivm/Catriona_Chaplin/scripts/For_publication/Outputs/cALT_gwas_healthcomes_primary_care_readings_unique_timepoints.tab")
control_alt_outcomes <- read_table("/home/ivm/Catriona_Chaplin/scripts/For_publication/Outputs/controlALT_health_outcomes_primary_care_readings_unique_timepoints.tab")


## add identifying column for cases and controls 
control_alt_outcomes <-control_alt_outcomes %>% mutate(chronic_ALT = "Controls")

##remove gender column from chronic df so all columns match 
chronic_alt_outcomes <- subset(chronic_alt_outcomes, select=-c(gender))

## bind cases and controls
cases_controls <- rbind(control_alt_outcomes, chronic_alt_outcomes)


## create function to calculate p-value for continuous / categorical variables

pvalue <- function(x, ...){
  ## construct vectors of data y and groups g
  y <- unlist(x)
  g <- factor(rep(1:length(x), times=sapply(x, length)))
  if(!is.numeric(y)) {
    ##for categorical variables perform a chi square test 
    p <- chisq.test(table(y,g))$p.value
  } else if(is.numeric(y) & (skew(y) <=1 & skew(y) > -1)) {
    ##for continuous variables w parametric distr perform t test
    p <- t.test(y ~ g, alternative = "two.sided", var.equal = TRUE)$p.value
  } else {
    ##for continuous vriables with nonparametric distr perform wilcox rank sum 
    p <- wilcox.test(y ~ g, alternative = "two.sided", var.equal = TRUE)$p.value
  }
  c("", sub("<","&lt;",format.pval(p, digits=3, eps=0.0011)))
}



## MAKE PHENOTYPE TABLES  

## change name of variables and column names 

cases_controls$Sex <- factor(cases_controls$Sex, levels = c(1,2),
                             labels = c("Male", "Female"))

cases_controls$chronic_ALT <- factor(cases_controls$chronic_ALT, levels = c("Yes", "Controls"),
                             labels = c("Chronic ALT", "Controls"))

cases_controls$Ethnicity <- factor(cases_controls$Ethnicity, levels = c(1,2,3),
                                     labels = c("Bangladeshi", "Pakistani", "Other"))

## change 'no yes' to 'Yes No' for all categorical variables
cases_controls$death <- factor(cases_controls$death, levels = c("yes", "no"), labels = c("Yes", "No"))
cases_controls$MASLD <- factor(cases_controls$MASLD, levels = c("yes", "no"), labels = c("Yes", "No"))
cases_controls$T2DM <- factor(cases_controls$T2DM, levels = c("yes", "no"), labels = c("Yes", "No"))
cases_controls$hypertension <- factor(cases_controls$hypertension, levels = c("yes", "no"), labels = c("Yes", "No"))
cases_controls$CKD <- factor(cases_controls$CKD, levels = c("yes", "no"), labels = c("Yes", "No"))
cases_controls$CVD <- factor(cases_controls$CVD, levels = c("yes", "no"), labels = c("Yes", "No"))
cases_controls$CAD <- factor(cases_controls$CAD, levels = c("yes", "no"), labels = c("Yes", "No"))
cases_controls$MI <- factor(cases_controls$MI, levels = c("yes", "no"), labels = c("Yes", "No"))
cases_controls$pad <- factor(cases_controls$pad, levels = c("yes", "no"), labels = c("Yes", "No"))
cases_controls$hf <- factor(cases_controls$hf, levels = c("yes", "no"), labels = c("Yes", "No"))
cases_controls$cerebro_vd <- factor(cases_controls$cerebro_vd, levels = c("yes", "no"), labels = c("Yes", "No"))


##work out how to manage the missing values here 
##cases_controls$BMI_23 <- factor(cases_controls$BMI_23, levels = c("Yes", "No", "Missing"), labels = c("Yes", "No", "NA"))
##cases_controls$BMI_27.5 <- factor(cases_controls$BMI_27.5, levels = c("Yes", "No"), labels = c("Yes", "No"))

label(cases_controls$age_entry_GH) <-("Age at recruitment")
label(cases_controls$MASLD) <-("NAFLD")
label(cases_controls$T2DM) <- ("Type 2 Diabetes")
label(cases_controls$BMI_value) <- ("BMI")
label(cases_controls$CVD) <- ("Cardiovascular disease")
label(cases_controls$CKD) <- ("Chronic Kidney Disease")
label(cases_controls$BMI_27.5) <- ("Obesity")
label(cases_controls$age_MASLD) <- ("Age NAFLD documented")
label(cases_controls$death) <- ("Mortality")
label(cases_controls$hf) <- ("Heart Failure")
label(cases_controls$pad) <- ("Peripheral arterial disease")
label(cases_controls$cerebro_vd) <- ("Cerebrovascular disease")
label(cases_controls$MI) <- ("Acute Coronary Syndrome")
label(cases_controls$CAD) <- ("Coronary artery disease")
label(cases_controls$hr_value) <- ("Heart rate")
label(cases_controls$diastolic_value) <- ("Diastolic blood pressure")
label(cases_controls$systolic_value) <- ("Systolic blood pressure")
label(cases_controls$fu_years) <- ("Follow up")
label(cases_controls$BMI_23) <- ("Overweight")
label(cases_controls$WC_value) <- ("Waist circumference")
label(cases_controls$weight_value) <- ("Weight")
label(cases_controls$hypertension) <- ("Hypertension")


label(cases_controls$age_CAD) <- ("Coronary artery disease")
label(cases_controls$age_MASLD) <- ("NAFLD")
label(cases_controls$age_hf) <- ("Heart Failure")
label(cases_controls$age_pad) <- ("Peripheral arterial disease")
label(cases_controls$age_ckd) <- ("Chronic Kidney Disease")
label(cases_controls$age_MI) <- ("Acute coronary syndrome")
label(cases_controls$age_cerebrovd) <- ("Cerebrovascular disease")
label(cases_controls$age_T2DM) <- ("Type 2 Diabetes")
label(cases_controls$age_Obesity) <- ("Obesity")


label(cases_controls$plts_value) <- ("Platelets")
label(cases_controls$ldl_value) <- ("Low-density lipoprotein")
label(cases_controls$total_chol_value) <- ("Total cholesterol")
label(cases_controls$ast_value) <- ("Aspartate Aminotransferase")
label(cases_controls$non_hdl_chol_value) <- ("Non HDL Cholesterol")
label(cases_controls$ggt_value) <- ("Gamma glutamyltransferase")
label(cases_controls$hba1c_value) <- ("HbA1c")
label(cases_controls$plts_value) <- ("Platelets")
label(cases_controls$creatinine_value) <- ("Creatinine")
label(cases_controls$total_chol_value) <- ("Total cholesterol")
label(cases_controls$HDL_value) <- ("High-density lipoprotein")
label(cases_controls$triglyc_value) <- ("Triglycerides")
label(cases_controls$alt_value) <- ("Alanine aminotransferase")
label(cases_controls$fast_gluc_value) <- ("Fasting glucose")
label(cases_controls$glucose_value) <- ("Non-fasting glucose")



## add units 
units(cases_controls$BMI_value) <- "kg/m^2"
units(cases_controls$fu_years) <- "years"
units(cases_controls$BMI_23) <- "BMI >=23"
units(cases_controls$BMI_27.5) <- "BMI >=27.5"
units(cases_controls$WC_value) <- "m"
units(cases_controls$systolic_value) <- "mmHg"
units(cases_controls$diastolic_value) <- "mmHg"
units(cases_controls$hr_value) <- "bpm"
units(cases_controls$systolic_value) <- "mmHg"

units(cases_controls$ast_value) <- "U/L"
units(cases_controls$non_hdl_chol_value) <- "mmol/L"
units(cases_controls$ggt_value) <- "U/L"
units(cases_controls$alt_value) <- "U/L"
units(cases_controls$hba1c_value) <- "mmol/mol"
units(cases_controls$plts_value) <- "mcL"
units(cases_controls$creatinine_value) <- "umol/L"
units(cases_controls$HDL_value) <- "mmol/L"
units(cases_controls$ldl_value) <- "mmol/L"
units(cases_controls$total_chol_value) <- "mmol/L"
units(cases_controls$triglyc_value) <- "mmol/L"
units(cases_controls$glucose_value) <- "mmol/L"
units(cases_controls$fast_gluc_value) <- "mmol/L"




## make table with health outcomes including p-values, no totals totals column 
table1(~ Sex + age_entry_GH + Ethnicity + fu_years + MASLD + T2DM + BMI_value + 
         BMI_27.5 + BMI_23 + WC_value + weight_value + hypertension + systolic_value + 
         diastolic_value + hr_value + CKD + CVD  + CAD + MI + cerebro_vd + pad + hf + death 
       | chronic_ALT, data = cases_controls,
       overall=F, extra.col=list('P-value'=pvalue))


## make table with age of onset health outcomes 
table1(~ age_T2DM + age_Obesity + age_ckd + age_MI + age_hf +
          age_pad + age_cerebrovd + age_htn | chronic_ALT, data = cases_controls,
        overall=F, extra.col=list('P-value'=pvalue))
 
 

## make table with lab results 
table1(~ ast_value + alt_value + ggt_value + hba1c_value + plts_value +
         creatinine_value + HDL_value + ldl_value + non_hdl_chol_value + total_chol_value + triglyc_value + 
        fast_gluc_value + glucose_value + crp_value + wcc_value | chronic_ALT, data = cases_controls,
       overall=F, extra.col=list('P-value'=pvalue))

