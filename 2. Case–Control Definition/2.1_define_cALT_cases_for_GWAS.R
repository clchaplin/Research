#setwd 
setwd("/genesandhealth/red/CatrionaChaplin/Data_exploration_scripts")

#load packages 
library (tidyverse)
library (dplyr)
library (readxl)


## CREATING A 'CHRONICALLY RAISED ALT' DATA SET 

## Load all ALT values available (data below are all the ALT values from primary care ONLY)

##Read in G&H QC ALT values (primary care ONLY)
ALT_QC <- read.csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version009_2024_05/data/ALT_readings_at_unique_timepoints_2024-05-07.csv")



## Load all patients coded with 'other' liver diagnoses to include (viral hepatitis, haemachromatosis, ALD, ETOH excess, NAFLD)
## These patients need to be removed from the chronically raised ALT dataframe 

Chronic_viral_hep <- read.csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version008_2024_02/CustomPhenotypes/custom_phenotypes/Chronic_viral_hepatitis/Chronic_viral_hepatitis_summary_report.csv")

ALD <- read.csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version008_2024_02/CustomPhenotypes/custom_phenotypes/Alcohol_dependence_and_related_disease/Alcohol_dependence_and_related_disease_summary_report.csv")

Wilson <- read.csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version008_2024_02/4digitICD10/4-digit-ICD/E83.0/E83.0_summary_report.csv")

Haemo <- read.csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version008_2024_02/4digitICD10/4-digit-ICD/E83.1/E83.1_summary_report.csv")

autoimmune_hep <- read.csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version008_2024_02/CustomPhenotypes/custom_phenotypes/Autoimmune_liver_disease/Autoimmune_liver_disease_summary_report.csv")



## Add column to each df identifying patient as having condition 
Chronic_viral_hep <- Chronic_viral_hep %>% mutate(CVH = "Yes")
ALD <- ALD %>% mutate(AlD = "Yes")
Wilson <- Wilson %>% mutate(wilsons = "Yes")
Haemo <- Haemo %>% mutate(haemo = "Yes")
autoimmune_hep <- autoimmune_hep %>% mutate(autohep = "Yes")


## rename columns to facilitate joins 
ALT_QC <- ALT_QC %>% rename(nhs_number = pseudo_nhs_number)


## Identify patients who have 'CHRONICALLY RAISED ALT'

## 1. Identify all patients who have a 'raised' ALT (based on >40 for men or >30 for women) and filter so only elevated ALT values left 
ALT_QC <- mutate(ALT_QC, Abnormal_ALT = case_when(value >=40 & gender == "M" ~ "Yes", value <40 & gender == "M" ~ "No", value >=30 & gender == "F" ~ "Yes" ,
                                                  value <30 & gender == "F" ~ "No")) %>% filter(Abnormal_ALT == "Yes")



## CHRONIC ALT FUNCTION - takes a patient's nhs number and ALT test date (age at test), and returns whether or not
# there is more than one positive test within a timespan that is more than 6 months but less than 2 years

check_ALT_chronic <- function(patient, age_at_test2) {
  
  ageattestdate <- as.numeric(age_at_test2) 
  
  if (
    nrow(
      ALT_QC %>% filter(
        # filter so only entries from one patient
      nhs_number == patient,
        # remove tests occurring within 6 months of another
      abs(as.numeric(age_at_test) - as.numeric(age_at_test2)) >= 0.5,
        # remove tests more than 2 years apart
      abs(as.numeric(age_at_test) - as.numeric(age_at_test2)) <= 2
      )
      )
      )
   {
    return("Yes")
  } else {
    return("No")
  }
}



#Apply function to AL_QC to identify all chronic ALT patients 
ALT_QC$chronic_ALT <- apply(ALT_QC, MARGIN=1,
                           function(x) check_ALT_chronic(x['nhs_number'], x['age_at_test']) )

print("done")


#filter df for chronic ALT 
ALT_chronic <- ALT_QC %>% filter(chronic_ALT == "Yes")

#filter df so only one patient per row  
ALT_chronic <- ALT_chronic %>% distinct(nhs_number, .keep_all = TRUE)


## join health outcomes to ALT_QC and select relevant column 
ALT_chronic_only <- left_join(ALT_chronic, ALD, by = "nhs_number") 
ALT_chronic_only <- left_join(ALT_chronic_only, Chronic_viral_hep, by = "nhs_number") 
ALT_chronic_only <- left_join(ALT_chronic_only, Wilson, by = "nhs_number") 
ALT_chronic_only <- left_join(ALT_chronic_only, Haemo, by = "nhs_number")
ALT_chronic_only <- left_join(ALT_chronic_only, autoimmune_hep, by = "nhs_number") 


ALT_chronic_only <- ALT_chronic_only %>% select("nhs_number", "gender", "chronic_ALT","CVH", "AlD", 
                                                "wilsons", "haemo", "autohep")


#Remove all patients who have chronic viral hepatitis, ALD or ETOH excess, wilsons, autoimmune or haemochromatosis
ALT_chronic_only <- ALT_chronic_only  %>% filter(is.na(AlD) & is.na(CVH) & is.na(wilsons) & is.na(haemo) 
                                                 & is.na(autohep))
                          
#select
ALT_chronic_only <- ALT_chronic_only %>% select("nhs_number", "gender", "chronic_ALT")



# Save dataframe of all patients who are classified as having a 'Chronic ALT' 
write.table(ALT_chronic_only,"/home/ivm/Catriona_Chaplin/scripts/For_publication/Outputs/chronic_ALT_CASES.tab")






## OLD CODE



## Calculate total number of ALT tests had by each individual
ALT_test_number <- ALT_QC %>% group_by(pseudo_nhs_number, Abnormal_ALT) %>% summarise(number_ALTs = n())

## Identify max time difference between patients firt and last test (in years, based on age_at_test)
ALT_multiple <- ALT_QC %>% group_by(pseudo_nhs_number) %>% summarise(max_time_between_tests = max(age_at_test) - min(age_at_test)) 

## Join above to the baeline ALT data 
ALT_chronic <- left_join(ALT_QC, ALT_multiple, by = "pseudo_nhs_number")
ALT_chronic <- left_join(ALT_chronic , ALT_test_number, by = "pseudo_nhs_number")


## Filter out all patients who have had only 1 ALT test or only 2 tests less than six months apart 
ALT_chronic <- ALT_chronic %>% filter(max_time_between_tests >0.5)


test <- ALT_chronic %>% filter(number_ALTs == 2 & max_time_between_tests <=2)    




