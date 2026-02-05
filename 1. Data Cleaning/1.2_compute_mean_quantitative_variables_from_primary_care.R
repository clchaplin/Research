## Generate a dataframe with the mean lifetime values for all quantitative variables (primary care values only)

##change timezone 
Sys.setenv(TZ="GMT")


#load packages 
library (tidyverse)
library (dplyr)
library(stringr)
library(lubridate)
library(data.table)
library(readxl)


## load demographics dataset 
demographics <- read_delim("/genesandhealth/red/CatrionaChaplin/Data_exploration_scripts/curated_datasets/all_GH_patients_demographics.tab")

## change name of id column to facilitate joins
demographics <- demographics  %>% rename(pseudo_nhs_number = PseudoNHS)

##load data sets containing all lab values from primary care with some light cleaning by the G&H team (secondary care values excluded)
ALT_mean <- read.csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version009_2024_05/data/ALT_readings_at_unique_timepoints_2024-05-07.csv")
BMI_mean <- read.csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version009_2024_05/data/BMI_readings_at_unique_timepoints_2024-05-07.csv")
WC_mean <- read.csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version009_2024_05/data/Waist_circumference_readings_at_unique_timepoints_2024-05-07.csv")
Plts_mean <- read.csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version009_2024_05/data/Platelets_readings_at_unique_timepoints_2024-05-07.csv")
AST_mean <- read.csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version009_2024_05/data/AST_readings_at_unique_timepoints_2024-05-07.csv")
NonHDL_chlstrl_mean <- read.csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version009_2024_05/data/Non_HDL_cholesterol_readings_at_unique_timepoints_2024-05-07.csv")
GGT_mean <- read.csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version009_2024_05/data/GGT_readings_at_unique_timepoints_2024-05-07.csv")
HbA1c_mean <- read_csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version009_2024_05/data/HbA1c_readings_at_unique_timepoints_2024-05-07.csv")
diastolic  <- read_csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version009_2024_05/data/Diastolic_BP_readings_at_unique_timepoints_2024-05-07.csv")
systolic <- read_csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version009_2024_05/data/Systolic_BP_readings_at_unique_timepoints_2024-05-07.csv")
bilirubin <- read_csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version009_2024_05/data/Bilirubin_readings_at_unique_timepoints_2024-05-07.csv")
creatinine <- read_csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version009_2024_05/data/creatinine_readings_at_unique_timepoints_2024-05-07.csv")
fasting_glucose <- read_csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version009_2024_05/data/Fasting_glucose_readings_at_unique_timepoints_2024-05-07.csv")
glucose_nofast <-read_csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version009_2024_05/data/Glucose_non_fasting_readings_at_unique_timepoints_2024-05-07.csv")
HDL_chol <-read_csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version009_2024_05/data/HDL-C_readings_at_unique_timepoints_2024-05-07.csv")
heart_rate <- read_csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version009_2024_05/data/Heart_Rate_readings_at_unique_timepoints_2024-05-07.csv")
ldl_chol <- read_csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version009_2024_05/data/LDL-C_readings_at_unique_timepoints_2024-05-07.csv")
total_chol <- read_csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version009_2024_05/data/Total_cholesterol_readings_at_unique_timepoints_2024-05-07.csv")
trigylcerides <- read_csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version009_2024_05/data/Triglycerides_readings_at_unique_timepoints_2024-05-07.csv")
weight <- read_csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version009_2024_05/data/Weight_readings_at_unique_timepoints_2024-05-07.csv")
crp <- read_csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version009_2024_05/data/CRP_readings_at_unique_timepoints_2024-05-07.csv")
wcc <- read_csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version009_2024_05/data/WBC_readings_at_unique_timepoints_2024-05-07.csv")


## calculate mean per person throughout lifetime 
ALT_mean <- ALT_mean  %>% group_by(pseudo_nhs_number) %>% summarise(alt_value = mean(value))
AST_mean  <- AST_mean  %>% group_by(pseudo_nhs_number) %>% summarise(ast_value = mean(value))
bilirubin <- bilirubin %>% group_by(pseudo_nhs_number) %>% summarise(bilirubin_value = mean(value))
creatinine <- creatinine %>% group_by(pseudo_nhs_number) %>% summarise(creatinine_value = mean(value))
diastolic <- diastolic %>% group_by(pseudo_nhs_number) %>% summarise(diastolic_value = mean(value))
fasting_glucose <- fasting_glucose %>% group_by(pseudo_nhs_number) %>% summarise(fast_gluc_value = mean(value))
GGT_mean <- GGT_mean  %>% group_by(pseudo_nhs_number) %>% summarise(ggt_value = mean(value))
glucose_nofast  <- glucose_nofast  %>% group_by(pseudo_nhs_number) %>% summarise(glucose_value = mean(value))
HbA1c_mean <- HbA1c_mean %>% group_by(pseudo_nhs_number) %>% summarise(hba1c_value = mean(value))
HDL_chol <- HDL_chol %>% group_by(pseudo_nhs_number) %>% summarise(HDL_value = mean(value))
heart_rate <- heart_rate %>% group_by(pseudo_nhs_number) %>% summarise(hr_value = mean(value))
ldl_chol <- ldl_chol %>% group_by(pseudo_nhs_number) %>% summarise(ldl_value = mean(value))
NonHDL_chlstrl_mean <- NonHDL_chlstrl_mean %>% group_by(pseudo_nhs_number) %>% summarise(non_hdl_chol_value = mean(value))
Plts_mean <- Plts_mean %>% group_by(pseudo_nhs_number) %>% summarise(plts_value = mean(value))
systolic <- systolic %>% group_by(pseudo_nhs_number) %>% summarise(systolic_value = mean(value))
total_chol <- total_chol %>% group_by(pseudo_nhs_number) %>% summarise(total_chol_value = mean(value))
trigylcerides <- trigylcerides %>% group_by(pseudo_nhs_number) %>% summarise(triglyc_value = mean(value))
WC_mean <- WC_mean %>% group_by(pseudo_nhs_number) %>% summarise(WC_value = mean(value)) 
weight  <- weight %>% group_by(pseudo_nhs_number) %>% summarise(weight_value = mean(value)) 
BMI_mean <- BMI_mean  %>% group_by(pseudo_nhs_number) %>% summarise(BMI_value = mean(value))
crp <- crp  %>% group_by(pseudo_nhs_number) %>% summarise(crp_value = mean(value))
wcc <- wcc  %>% group_by(pseudo_nhs_number) %>% summarise(wcc_value = mean(value))



## Join all lab values together 
demographics_health_outcomes <- left_join(demographics, BMI_mean, by = "pseudo_nhs_number") 
demographics_health_outcomes <- left_join(demographics_health_outcomes, WC_mean, by = "pseudo_nhs_number")
demographics_health_outcomes <- left_join(demographics_health_outcomes, AST_mean, by = "pseudo_nhs_number")
demographics_health_outcomes <- left_join(demographics_health_outcomes, ALT_mean, by = "pseudo_nhs_number")
demographics_health_outcomes <- left_join(demographics_health_outcomes, GGT_mean, by = "pseudo_nhs_number")
demographics_health_outcomes <- left_join(demographics_health_outcomes, HbA1c_mean, by = "pseudo_nhs_number")
demographics_health_outcomes <- left_join(demographics_health_outcomes, Plts_mean, by = "pseudo_nhs_number")
demographics_health_outcomes <- left_join(demographics_health_outcomes, NonHDL_chlstrl_mean, by = "pseudo_nhs_number")
demographics_health_outcomes <- left_join(demographics_health_outcomes, bilirubin, by = "pseudo_nhs_number")
demographics_health_outcomes <- left_join(demographics_health_outcomes, creatinine, by = "pseudo_nhs_number")
demographics_health_outcomes <- left_join(demographics_health_outcomes, diastolic, by = "pseudo_nhs_number")
demographics_health_outcomes <- left_join(demographics_health_outcomes, fasting_glucose, by = "pseudo_nhs_number")
demographics_health_outcomes <- left_join(demographics_health_outcomes, HDL_chol, by = "pseudo_nhs_number")
demographics_health_outcomes <- left_join(demographics_health_outcomes, heart_rate, by = "pseudo_nhs_number")
demographics_health_outcomes <- left_join(demographics_health_outcomes, glucose_nofast, by = "pseudo_nhs_number")
demographics_health_outcomes <- left_join(demographics_health_outcomes, ldl_chol, by = "pseudo_nhs_number")
demographics_health_outcomes <- left_join(demographics_health_outcomes, systolic, by = "pseudo_nhs_number")
demographics_health_outcomes <- left_join(demographics_health_outcomes, total_chol, by = "pseudo_nhs_number")
demographics_health_outcomes <- left_join(demographics_health_outcomes, trigylcerides, by = "pseudo_nhs_number")
demographics_health_outcomes <- left_join(demographics_health_outcomes, weight, by = "pseudo_nhs_number")
demographics_health_outcomes <- left_join(demographics_health_outcomes, crp, by = "pseudo_nhs_number")
demographics_health_outcomes <- left_join(demographics_health_outcomes, wcc, by = "pseudo_nhs_number")

demographics_health_outcomes <- demographics_health_outcomes %>% rename(oragene = "Number of OrageneIDs with this NHS number (i.e. taken part twice or more)" )

demographics_health_outcomes <- subset(demographics_health_outcomes, select=-c(DOB, age_present, age_entry_GH, fu_years,Date_entry_study, 
                                                                               Sex, Ethnicity, Diabetes, Health_status, Parents_related,
                                                                               Type_relation, age_cat_entry, oragene))


write_delim(demographics_health_outcomes,"/home/ivm/Catriona_Chaplin/scripts/For_publication/Outputs/quantitative_values_lifetime_mean_readings_unique_timepoints.tab")
