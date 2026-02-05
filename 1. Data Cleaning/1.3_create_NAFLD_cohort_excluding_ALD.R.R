## Create own NAFLD phenotype 


## load G&H curated NAFLD phenotype 
nafld <- read_csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version008_2024_02/CustomPhenotypes/custom_phenotypes/Non-alcoholic_fatty_liver_disease_and_steatohepatitis/Non-alcoholic_fatty_liver_disease_and_steatohepatitis_summary_report.csv")


## load dataframe patients coded with ICD10 code K70
ald <- read_csv("/genesandhealth/library-red/genesandhealth/phenotypes_curated/version008_2024_02/3digitICD10/3-digit-ICD/K70/K70_summary_report.csv")


## create column to tag patients with ALD 
ald <- ald %>% mutate(ald = "yes")
ald <- ald %>% select(nhs_number, ald)


## remove patients with inppropriate ICD10 or snomed codes in nafld 
nafld_sub_ald <- nafld %>% filter(code != "K700") %>% filter(code != "50325005")


## join patients from list of ICD10 cohort who have ald - check have removed all of these patients 
nafld_sub_ald <- left_join(nafld_sub_ald, ald, by = "nhs_number")
nafld_sub_ald <- nafld_sub_ald %>% filter(is.na(ald))
nafld_sub_ald <- nafld_sub_ald %>% select(nhs_number, age_at_event)

## save new NAFLD cohort 
write.csv(nafld_sub_ald,"/home/ivm/Catriona_Chaplin/scripts/For_publication/Outputs/nafld_sub_ald.tab", row.names = FALSE)






