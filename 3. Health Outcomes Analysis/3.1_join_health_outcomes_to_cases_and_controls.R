# JOIN DEMOGRAPHICS AND HEALTH OUTCOMES TO CHRONIC ALT COHORT AND CONTROL GROUP

#load packages 
library (tidyverse)
library (dplyr)
library(psych)
library(ggplot2)


## load chronic ALT cohort 
chronic_alt <- read.table("/home/ivm/Catriona_Chaplin/scripts/For_publication/Outputs/chronic_ALT_CASES.tab")

## load ALT control group (EXCLUDING NAFLD)
control <- read.table("/home/ivm/Catriona_Chaplin/scripts/For_publication/Outputs/chronic_ALT_CONTROLS.tab")

## load up joint health outcomes and demographics (quantitative from primary care only, quantitative data based on readings at unique timepoints)
demographics_health_outcomes <- read_delim("/home/ivm/Catriona_Chaplin/scripts/For_publication/Outputs/health_outcomes_entire_cohort_primary_care_readings_unique_timepoint.tab")


##rename nhs_number to PseudoNHS for joining 
chronic_alt <- chronic_alt %>% rename(PseudoNHS = nhs_number)
control <- control %>% rename(PseudoNHS = nhs_number)


## join demographics + health outcomes to chronic_ALT cohort 
chronic_alt_outcomes <- left_join(chronic_alt, demographics_health_outcomes, by = "PseudoNHS") 
control_alt_outcomes <- left_join(control, demographics_health_outcomes, by = "PseudoNHS") 


## SAVE JOINT CHRONIC ALT and health outcomes

## save joint chronic ALT and health outcomes 
write_delim(chronic_alt_outcomes,"~/Catriona_Chaplin/Curated_dfs/cALT_gwas_healthcomes_primary_care_readings_unique_timepoints.tab")
write_delim(control_alt_outcomes,"~/Catriona_Chaplin/Curated_dfs/controlALT_health_outcomes_primary_care_readings_unique_timepoints.tab")



## save joint chronic ALT and health outcomes 
write_delim(chronic_alt_outcomes,"/home/ivm/Catriona_Chaplin/scripts/For_publication/Outputs/cALT_gwas_healthcomes_primary_care_readings_unique_timepoints.tab")
write_delim(control_alt_outcomes,"/home/ivm/Catriona_Chaplin/scripts/For_publication/Outputs/controlALT_health_outcomes_primary_care_readings_unique_timepoints.tab")








