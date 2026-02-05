## CREATE ALT CONTROL GROUP  

## setwd 
setwd("/home/ivm/Catriona_Chaplin/scripts/Data_exploration_scripts/alt/make_case_controls_for_GWAS/")

#load packages 
library (tidyverse)
library (dplyr)


## Definition of controls 
## Anyone who has had an ALT value taken who was not defined as having 'chronically elevated ALT' and is 
## without concurrent liver pathology inclusive of liver fibrosis/cirrhosis, HCC, CVH, nafld, chronic viral hepatitis


## load dataset of all ALT values 
ALT_QC <- read.csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version009_2024_05/data/ALT_readings_at_unique_timepoints_2024-05-07.csv")


## rename to facilitate joins 
ALT_QC <- ALT_QC %>% rename(nhs_number = pseudo_nhs_number)



##filter ALT_QC so only patients left (rather than all ALT values) 
ALT_QC <- ALT_QC %>% distinct(nhs_number)


## load dataset of all patients in the 'chronically elevated ALT' cohort
ALT_chronic <- read.table("/home/ivm/Catriona_Chaplin/scripts/For_publication/Outputs/chronic_ALT_CASES.tab")



## load datasets containing patients with other liver pathology 
Chronic_viral_hep <- read.csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version008_2024_02/CustomPhenotypes/custom_phenotypes/Chronic_viral_hepatitis/Chronic_viral_hepatitis_summary_report.csv")
ALD <- read.csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version008_2024_02/CustomPhenotypes/custom_phenotypes/Alcohol_dependence_and_related_disease/Alcohol_dependence_and_related_disease_summary_report.csv")
Wilson <- read.csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version008_2024_02/4digitICD10/4-digit-ICD/E83.0/E83.0_summary_report.csv")
Haemo <- read.csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version008_2024_02/4digitICD10/4-digit-ICD/E83.1/E83.1_summary_report.csv")
autoimmune_hep <- read.csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version008_2024_02/CustomPhenotypes/custom_phenotypes/Autoimmune_liver_disease/Autoimmune_liver_disease_summary_report.csv")
Liver_fail_transpl <- read_csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version008_2024_02/CustomPhenotypes/custom_phenotypes/Liver_failure_and_transplant/Liver_failure_and_transplant_summary_report.csv")
Liver_fibrosis <- read_csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version008_2024_02/CustomPhenotypes/custom_phenotypes/Liver_fibrosis_sclerosis_and_cirrhosis/Liver_fibrosis_sclerosis_and_cirrhosis_summary_report.csv")
Primary_malignancy_liver <- read_csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version008_2024_02/CustomPhenotypes/custom_phenotypes/Primary_malignancy_liver/Primary_malignancy_liver_summary_report.csv")
nafld <- read.csv("/home/ivm/Catriona_Chaplin/scripts/For_publication/Outputs/nafld_sub_ald.tab")
                

## add identifying column to each health outcomes
Chronic_viral_hep <- Chronic_viral_hep %>% mutate(CVH = "Yes")
ALD <- ALD %>% mutate(AlD = "Yes")
Wilson <- Wilson %>% mutate(wilsons = "Yes")
Haemo <- Haemo %>% mutate(haemo = "Yes")
autoimmune_hep <- autoimmune_hep %>% mutate(autohep = "Yes")
Liver_fail_transpl <- Liver_fail_transpl %>% mutate(failure = "Yes")
Liver_fibrosis <- Liver_fibrosis %>% mutate(fibrosis = "Yes")
Primary_malignancy_liver <- Primary_malignancy_liver %>% mutate(liver_cancer = "Yes")
nafld <- nafld %>% mutate(nafld = "Yes")

##filter ALT_QC so only patients left (rather than all ALT values) 
control <- anti_join(ALT_QC, ALT_chronic, by = "nhs_number")
control <- anti_join(control, Wilson, by = "nhs_number")
control <- anti_join(control, Haemo, by = "nhs_number")
control <- anti_join(control, Chronic_viral_hep, by = "nhs_number")
control <- anti_join(control, autoimmune_hep, by = "nhs_number")
control <- anti_join(control, ALD, by = "nhs_number")
control <- anti_join(control, Liver_fail_transpl, by = "nhs_number")
control <- anti_join(control, Liver_fibrosis, by = "nhs_number")
control <- anti_join(control, Primary_malignancy_liver, by = "nhs_number")
control <- anti_join(control, nafld, by = "nhs_number")


## save control group 
write.table(control,"/home/ivm/Catriona_Chaplin/scripts/For_publication/Outputs/chronic_ALT_CONTROLS.tab")


