#setwd 
setwd("/home/ivm/Catriona_Chaplin/scripts/For_publication/Outputs/")

#load packages 
library (tidyverse)
library (dplyr)
library (lubridate)



### READ IN FILES ###

# G&H Primary questionnaire information
GH_questionnaire <- read_delim("/genesandhealth/library-red/genesandhealth/phenotypes_rawdata/QMUL__Stage1Questionnaire/2024_04_30__S1QST_redacted.tab")


# G&H Lab_collect information 
GH_Lab_collect <- read_delim("/genesandhealth/library-red/genesandhealth/phenotypes_rawdata/QMUL__Stage1LabCollector/Stage1LabCollector_2024-04-26.tab")

# Oragene mapped to pseudoNHS number 
oragene_pseudoNHS <- read_delim("/genesandhealth/library-red/genesandhealth/2024_05_03_OrageneID_PseudoNHS_Gender_withmissing_forTRE.tab")


# convert into character from numeric data
GH_questionnaire$S1QST_Gender <- as.factor(GH_questionnaire$S1QST_Gender)
GH_questionnaire$S1QST_ParentsBloodRelated <- as.factor(GH_questionnaire$S1QST_ParentsBloodRelated) 
GH_questionnaire$S1QST_ParentsBloodRelated2 <- as.factor(GH_questionnaire$S1QST_ParentsBloodRelated2) 
GH_questionnaire$S1QST_EthnicGroup <- as.factor(GH_questionnaire$S1QST_EthnicGroup)
GH_questionnaire$S1QST_EthnicGroupOther <- as.factor(GH_questionnaire$S1QST_EthnicGroupOther)
GH_questionnaire$S1QST_Diabetes <- as.factor(GH_questionnaire$S1QST_Diabetes)
GH_questionnaire$S1QST_HealthWellbeing <- as.factor(GH_questionnaire$S1QST_HealthWellbeing)
GH_questionnaire$S1QST_HealthWellbeing <- as.factor(GH_questionnaire$S1QST_HealthWellbeing)
GH_questionnaire$S1QST_ParentsBloodRelatedOther <- as.factor(GH_questionnaire$S1QST_ParentsBloodRelatedOther)



# rename and remove columns so they match ready for joins
demographics_all <- rename(GH_questionnaire, "OrageneID" = "S1QST_Oragene_ID", "Sex" = "S1QST_Gender", "Ethnicity" = "S1QST_EthnicGroup",
                       "Diabetes" = "S1QST_Diabetes", "Parents_related" = "S1QST_ParentsBloodRelated", "Type_relation" = "S1QST_ParentsBloodRelated2",
                       "Health_status" = "S1QST_HealthWellbeing")

GH_Lab_collect <- rename(GH_Lab_collect,"OrageneID" = "LABCO_OrageneID")


# Join oragene and Lab collect by Oragene ID 
oragene_pseudoNHS <- left_join(oragene_pseudoNHS, GH_Lab_collect, by = "OrageneID")


# Create column for years of follow up (from present date from joining the study) 
oragene_pseudoNHS$`LABCO_YYYY-MM_DateInLab` <- paste(oragene_pseudoNHS$`LABCO_YYYY-MM_DateInLab`,"-01", sep="")

oragene_pseudoNHS <- oragene_pseudoNHS %>% mutate(fu_years = as.numeric(as.Date(now()) - as.Date(`LABCO_YYYY-MM_DateInLab`))/365)


# De-duplicate patients who have taken part in the study multiple times so that only their first oragene entry is left (with longest fu time)
oragene_pseudoNHS <- oragene_pseudoNHS %>% arrange(oragene_pseudoNHS, "PseudoNHS_2024-05-03", -fu_years) 
oragene_pseudoNHS <- distinct(oragene_pseudoNHS, `PseudoNHS_2024-05-03`, .keep_all = TRUE)


                                                       
# Join GH_questionnaire (demographics) with OrageneID+Lab_collect) 
demographics_all <- left_join(demographics_all, oragene_pseudoNHS, by = "OrageneID")


# rename and remove columns 
demographics_all <- rename(demographics_all, "PseudoNHS" = "PseudoNHS_2024-05-03")


# Remove duplicates => unique psuedo NHS numbers only 
demographics_all <- demographics_all[!duplicated(demographics_all$PseudoNHS),]


## generate current age from DOB (age from present, not from admission to study)
getagefrom_mmyyyy <- function(x) {
  return(
    as.numeric(as.Date(now()) - 
                 as.Date(paste("01-",x,sep=""),
                         format="%d-%m-%Y")
    )/365
  )
}

demographics_all$age_present <- sapply(demographics_all$S1QST_MM.YYYY_ofBirth,getagefrom_mmyyyy)



## generate age at recruitment (subtracting S1QST_MM-YYYY_of_Birth from LABCO_MM-YYYY_DateInLab)

demographics_all$S1QST_MM.YYYY_ofBirth <- as.Date(paste("01-", demographics_all$S1QST_MM.YYYY_ofBirth, sep= ""),format="%d-%m-%Y")

demographics_all <- demographics_all %>% mutate(age_entry_GH = as.numeric(as.Date(`LABCO_YYYY-MM_DateInLab`) - as.Date(`S1QST_MM.YYYY_ofBirth`))/365)
                        


## Select COLUMNS 
demographics_all <- demographics_all %>% dplyr::select(PseudoNHS, S1QST_MM.YYYY_ofBirth, age_present, age_entry_GH, fu_years,"LABCO_YYYY-MM_DateInLab", Sex, Ethnicity, Diabetes, Health_status, 
                                                       Parents_related, Type_relation, "Number of OrageneIDs with this NHS number (i.e. taken part twice or more)") 
demographics_all <- demographics_all %>% rename(DOB = S1QST_MM.YYYY_ofBirth)
demographics_all <- demographics_all %>% rename(Date_entry_study = "LABCO_YYYY-MM_DateInLab")


# create age categories 
demographics_all <- mutate(demographics_all, age_cat_entry = case_when(age_entry_GH <30 ~ "19_29", age_entry_GH >=30 & age_entry_GH <40 ~ "30_39",
                                                               age_entry_GH >=40 & age_entry_GH <50 ~ "40_49", age_entry_GH >=50 & age_entry_GH <60 ~ "50_59",
                                                               age_entry_GH >=60 & age_entry_GH <70 ~ "60_69", age_entry_GH >=70 & age_entry_GH <80 ~ "70_79",
                                                               age_entry_GH >=80 & age_entry_GH <90 ~ "80_89", age_entry_GH >=90 & age_entry_GH <100 ~ "90_99",
                                                               age_entry_GH >=100 ~ "100"))

# save cleaned demographics dataframe 
write_delim(demographics_all, "all_GH_patients_demographics.tab")



