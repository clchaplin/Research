## JOIN HEALTH OUTCOMES TO DEMOGRAPHIC DATA - BINARY

#load packages 
library (tidyverse)
library (dplyr)
library(stringr)
library(lubridate)
library(data.table)
library(readxl)


## load health outcomes
MASLD <- read.table("/home/ivm/Catriona_Chaplin/scripts/For_publication/Outputs/nafld_sub_ald.tab")
Liver_fail_transpl <- read_csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version008_2024_02/CustomPhenotypes/custom_phenotypes/Liver_failure_and_transplant/Liver_failure_and_transplant_summary_report.csv")
Liver_fibrosis <- read_csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version008_2024_02/CustomPhenotypes/custom_phenotypes/Liver_fibrosis_sclerosis_and_cirrhosis/Liver_fibrosis_sclerosis_and_cirrhosis_summary_report.csv")
Obesity <- read_csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version008_2024_02/CustomPhenotypes/custom_phenotypes/Obesity/Obesity_summary_report.csv")
T2DM  <- read_csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version008_2024_02/CustomPhenotypes/custom_phenotypes/Type_2_Diabetes/Type_2_Diabetes_summary_report.csv")
CKD <- read_csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version008_2024_02/CustomPhenotypes/custom_phenotypes/Chronic_Kidney_Disease/Chronic_Kidney_Disease_summary_report.csv")
Primary_malignancy_liver <- read_csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version008_2024_02/CustomPhenotypes/custom_phenotypes/Primary_malignancy_liver/Primary_malignancy_liver_summary_report.csv")
Chronic_viral_hep <- read_csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version008_2024_02/CustomPhenotypes/custom_phenotypes/Chronic_viral_hepatitis/Chronic_viral_hepatitis_summary_report.csv")
Alc_dep <- read.csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version008_2024_02/CustomPhenotypes/custom_phenotypes/Alcohol_dependence_and_related_disease/Alcohol_dependence_and_related_disease_summary_report.csv")
hf <- read.csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version008_2024_02/CustomPhenotypes/custom_phenotypes/Heart_failure/Heart_failure_summary_report.csv")
Coronary_artery_disease <-read_csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version008_2024_02/CustomPhenotypes/custom_phenotypes/Coronary_heart_disease/Coronary_heart_disease_summary_report.csv")
MI <- read_csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version008_2024_02/CustomPhenotypes/custom_phenotypes/GNH0005_MyocardialInfarction_extended/GNH0005_MyocardialInfarction_extended_summary_report.csv")  
Cerebro_VD <- read_csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version008_2024_02/CustomPhenotypes/custom_phenotypes/Cerebrovascular_disease/Cerebrovascular_disease_summary_report.csv")
pad <- read.csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version008_2024_02/CustomPhenotypes/custom_phenotypes/Peripheral_arterial_disease/Peripheral_arterial_disease_summary_report.csv")
htn <- read.csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version008_2024_02/CustomPhenotypes/custom_phenotypes/Hypertension/Hypertension_summary_report.csv")
death <- read_xlsx("/genesandhealth/library-red/genesandhealth/deceased_volunteers/2024_01_08_DeceasedVolunteers_cleaned_uniq.xlsx")


## load demographic data 
demographics <- read_delim("/genesandhealth/red/CatrionaChaplin/Data_exploration_scripts/curated_datasets/all_GH_patients_demographics.tab")

## load dataset containing quantitative values including values from primary care - values are lifetime means from all primary care values ever taken - used 'readings_at_unique_timepoints' for quantitative data
quant_variables <- read_delim("/home/ivm/Catriona_Chaplin/scripts/For_publication/Outputs/quantitative_values_lifetime_mean_readings_unique_timepoints.tab")


## add columns to identify health outcome 
MASLD <- MASLD %>% mutate(MASLD = "yes")
Liver_fail_transpl <- Liver_fail_transpl %>% mutate(Liver_fail = "yes")
Liver_fibrosis <- Liver_fibrosis %>% mutate(Liver_fibro_cirrho = "yes")
T2DM <- T2DM  %>% mutate(T2DM  = "yes")
CKD <- CKD %>% mutate(CKD = "yes")
Primary_malignancy_liver <- Primary_malignancy_liver %>% mutate(Primary_malignancy_liver = "yes")
Chronic_viral_hep <- Chronic_viral_hep %>% mutate(Chronic_viral_hep = "yes")
Obesity <- Obesity %>% mutate(Obese = "yes")
Cerebro_VD <-Cerebro_VD %>% mutate(cerebro_vd = "yes")
MI <-MI %>% mutate(MI = "yes")
Coronary_artery_disease <-Coronary_artery_disease %>% mutate(CAD = "yes")
hf <-hf %>% mutate(hf = "yes")
pad <- pad %>% mutate(pad = "yes")
death <- death %>% mutate(death = "yes")
htn <- htn %>% mutate(hypertension = "yes")

## rename columns with NHS number so all matching AND so 'age_at_event' identifiable to health outcome 
MASLD <- MASLD %>% rename(PseudoNHS = nhs_number, age_MASLD = age_at_event)
Obesity <- Obesity %>% rename(PseudoNHS = nhs_number, age_Obesity = age_at_event)
T2DM <- T2DM  %>% rename(PseudoNHS = nhs_number, age_T2DM = age_at_event)
CKD <- CKD %>% rename(PseudoNHS = nhs_number, age_ckd = age_at_event)
Chronic_viral_hep <- Chronic_viral_hep %>% rename(PseudoNHS = nhs_number, age_cvh = age_at_event)
Liver_fibrosis <- Liver_fibrosis %>% rename(PseudoNHS = nhs_number, age_liverfibrosis = age_at_event)
Liver_fail_transpl <- Liver_fail_transpl %>% rename(PseudoNHS = nhs_number, age_livfailure = age_at_event)
Primary_malignancy_liver <- Primary_malignancy_liver %>% rename(PseudoNHS = nhs_number, age_livmalignancy = age_at_event)
Cerebro_VD <- Cerebro_VD %>% rename(PseudoNHS = nhs_number, age_cerebrovd = age_at_event)
MI <- MI %>% rename(PseudoNHS = nhs_number, age_MI = age_at_event)
Coronary_artery_disease <- Coronary_artery_disease %>% rename(PseudoNHS = nhs_number, age_CAD = age_at_event)
hf <-hf %>% rename(PseudoNHS = nhs_number, age_hf = age_at_event)
pad <- pad %>% rename(PseudoNHS = nhs_number, age_pad = age_at_event)
death <- death %>% rename(PseudoNHS = PseudoNHS_2023_11_08)
htn <- htn %>% rename(PseudoNHS = nhs_number, age_htn = age_at_event)


## rename columns for joins
quant_variables <- quant_variables %>% rename(PseudoNHS = pseudo_nhs_number)


## join health outcomes to demographic data 
demographics_health_outcomes <- left_join(demographics, MASLD, by = "PseudoNHS")
demographics_health_outcomes <- left_join(demographics_health_outcomes, Obesity, by = "PseudoNHS")
demographics_health_outcomes <- left_join(demographics_health_outcomes, T2DM, by = "PseudoNHS")
demographics_health_outcomes <- left_join(demographics_health_outcomes, CKD, by = "PseudoNHS")
demographics_health_outcomes <- left_join(demographics_health_outcomes, Chronic_viral_hep, by = "PseudoNHS")
demographics_health_outcomes <- left_join(demographics_health_outcomes, Liver_fail_transpl, by = "PseudoNHS")
demographics_health_outcomes <- left_join(demographics_health_outcomes, Liver_fibrosis, by = "PseudoNHS")
demographics_health_outcomes <- left_join(demographics_health_outcomes, Primary_malignancy_liver, by = "PseudoNHS")
demographics_health_outcomes <- left_join(demographics_health_outcomes, MI, by = "PseudoNHS")
demographics_health_outcomes <- left_join(demographics_health_outcomes, Coronary_artery_disease, by = "PseudoNHS")
demographics_health_outcomes <- left_join(demographics_health_outcomes, Cerebro_VD, by = "PseudoNHS")
demographics_health_outcomes <- left_join(demographics_health_outcomes, hf, by = "PseudoNHS")
demographics_health_outcomes <- left_join(demographics_health_outcomes, pad, by = "PseudoNHS")
demographics_health_outcomes <- left_join(demographics_health_outcomes, death, by = "PseudoNHS")
demographics_health_outcomes <- left_join(demographics_health_outcomes, htn, by = "PseudoNHS")

## join to make a dataframe with both binary health outcomes and quantitative variables
demographics_health_outcomes <- left_join(demographics_health_outcomes, quant_variables, by = "PseudoNHS" )


## Create column for BMI above 27.5 and 23 
demographics_health_outcomes <- mutate(demographics_health_outcomes, BMI_27.5 = case_when(BMI_value >=27.5 ~ "Yes", BMI_value <27.5 ~ "No"))
demographics_health_outcomes <- mutate(demographics_health_outcomes, BMI_23 = case_when(BMI_value >=23 ~ "Yes", BMI_value <23 ~ "No"))



## select relevant columns in joint health outcomes df
demographics_health_outcomes <- select(demographics_health_outcomes, "PseudoNHS", "DOB",                                                                      
                                       "age_present", "age_entry_GH", "age_cat_entry", "fu_years", "Date_entry_study",
                                       "Sex", "Ethnicity","BMI_value","BMI_23", "BMI_27.5", "MASLD", "age_MASLD", "Obese", "age_Obesity", "T2DM" ,
                                       "age_T2DM","CKD","age_ckd" ,
                                       "Chronic_viral_hep",
                                       "age_cvh" ,
                                       "Liver_fail"  ,
                                       "age_livfailure",
                                       "Liver_fibro_cirrho",  
                                       "age_liverfibrosis",
                                       "Primary_malignancy_liver",
                                       "age_livmalignancy",
                                       "CAD","age_CAD", "MI", "age_MI", "cerebro_vd", "age_cerebrovd",
                                    "WC_value", "pad", "hf", "age_hf", "death", "YearOfDeath", "ast_value",
                                    "non_hdl_chol_value", "hypertension", "age_htn", "ggt_value", "hba1c_value", "plts_value", "creatinine_value", 
                                "HDL_value", "hr_value", "ldl_value", "systolic_value", "total_chol_value", 
                                    "triglyc_value", "weight_value", "age_pad", "diastolic_value", "alt_value", "fast_gluc_value",
                                "glucose_value", "crp_value", "wcc_value")
                                    





## Change NAs to NO for health outcomes column
demographics_health_outcomes$MASLD [is.na(demographics_health_outcomes$MASLD)] <- "no"
demographics_health_outcomes$Obese [is.na(demographics_health_outcomes$Obese)] <- "no"
demographics_health_outcomes$T2DM [is.na(demographics_health_outcomes$T2DM)] <- "no"
demographics_health_outcomes$Chronic_viral_hep [is.na(demographics_health_outcomes$Chronic_viral_hep)] <- "no"
demographics_health_outcomes$Liver_fail [is.na(demographics_health_outcomes$Liver_fail)] <- "no"
demographics_health_outcomes$Liver_fibro_cirrho [is.na(demographics_health_outcomes$Liver_fibro_cirrho)] <- "no"
demographics_health_outcomes$Primary_malignancy_liver [is.na(demographics_health_outcomes$Primary_malignancy_liver)] <- "no"
demographics_health_outcomes$CKD [is.na(demographics_health_outcomes$CKD)] <- "no"
demographics_health_outcomes$CAD [is.na(demographics_health_outcomes$CAD)] <- "no"
demographics_health_outcomes$MI [is.na(demographics_health_outcomes$MI )] <- "no"
demographics_health_outcomes$cerebro_vd [is.na(demographics_health_outcomes$cerebro_vd )] <- "no"
demographics_health_outcomes$pad [is.na(demographics_health_outcomes$pad )] <- "no"
demographics_health_outcomes$hf [is.na(demographics_health_outcomes$hf )] <- "no"
demographics_health_outcomes$death [is.na(demographics_health_outcomes$death )] <- "no"
demographics_health_outcomes$hypertension [is.na(demographics_health_outcomes$hypertension )] <- "no"


## Create column for CVD 
demographics_health_outcomes <- mutate(demographics_health_outcomes, CVD = case_when(CAD == "yes" | MI == "yes" | cerebro_vd == "yes" | pad == "yes" ~ "yes", TRUE ~ "no"))


## SAVE demographics linked to health outcomes data frame 
write_delim(demographics_health_outcomes,"/home/ivm/Catriona_Chaplin/scripts/For_publication/Outputs/health_outcomes_entire_cohort_primary_care_readings_unique_timepoint.tab")




