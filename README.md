# READ_ME

This repository contains the full code pipeline used in the study:

[insert finalised paper title]

It includes all the steps used to clean the phenotype data, define the case and control phenotypes, and perform health-outcome analyses. The data used for this analysis cannot be shared due to confidentiality, but all scripts and workflow details needed to reproduce the analysis on permitted datasets are provided.

Repository structure:
├── 01_data_cleaning/
│   ├── 1.1_clean_baseline_demographics.R
│   ├── 1.2_compute_mean_quantitative_variables_from_primary_care.R
│   ├── 1.3_create_NAFLD_cohort_excluding_ALD.R
│   └── 1.4_join_binary_and_quantitative_outcomes_to_demographics.R
│
├── 02_case_control_phenotype_definition/
│   ├── 2.1_define_cALT_cases_for_GWAS.R
│   └── 2.2_define_control_group_for_GWAS.R
│
└── 03_health_outcomes_analysis/
    ├── 3.1_join_health_outcomes_to_cases_and_controls.R
    └── 3.2_cases_vs_controls_health_outcomes_analysis.R


## Data Provenance and Preprocessing
Some of the data used in this analysis was provisionally cleaned and curated by the Genes and Health Team. The majority of phenotypes used for the binary health outcomes (e.g. hypertension, diabetes) were curated by the G&H team (codelist available publicly at: https://docs.google.com/spreadsheets/d/1ipwdF2j_owfr_QbkDYk1rk0TW3KtdfQYVQn-Vf-o38s/edit?gid=750982921#gid=750982921. Health outcome phenotypes generated ourselves include cardiovascular disease, ethnically adjusted BMI categories and NAFLD. 

For quantitative data used in this study, values from primary care were used that had already had the following preprocessing steps applied by the G&H data team prior to our analysis:
1)	Upload data from all available electronic healthcare records including primary and secondary care 
2)	Exclude non-numeric values 
3)	Use of custom codelists to identify all occurrences of a specific outcome variable in the electronic health records 
4)	Harmonise all units – exclusion of any test results which did not have units that could be simply converted to IU/L
5)	Exclude readings outside pre-specified min/max ranges (aim to remove results which are likely a result of technical or lab errors)
6)	Exclude test results obtained before the age of 18 years 
7)	Exclude test results with a missing date 
8)	De-duplicate test results 
a.	Deduplicated test results for the same patient if two results with exact same value in 10 day period
9) exclude all data values from secondary care
    
Our analysis uses this pre-cleaned dataset, and additional analysis-specific cleaning steps are applied in the scripts below.


## Workflow

1. Data Cleaning (01_data_cleaning/)

These scripts prepare the demographic and clinical dataset for case/control construction.

1.1_clean_baseline_demographics.R
Cleans and formats the demographic dataset, including variables such as age, sex, and ethnicity. 

1.2_compute_mean_quantitative_variables_from_primary_care
This script calculates the lifetime mean values for quantitative continuous clinical markers (e.g., ALT, AST, bilirubin, weight), using all available values from primary care. The quantitative values utilised have already had some cleaning performed on them by the Genes & Health team - the steps of this cleaning are outlined above in 'data provenance and reprocessing'. 

1.3_create_NAFLD_cohort_excluding_ALD.R
Creates a NAFLD cohort by applying phenotype rules, while explicitly removing individuals with alcohol-related liver disease (ALD).

1.4_join_binary_and_quantitative_outcomes_to_demographics.R
Combines processed phenotype outcomes with demographic information to create a unified analysis-ready dataset.


| Script | Purpose | Input | Output |
|--------|--------|------|-------|
| `01_data_cleaning/1.1_clean_baseline_demographics.R` | Cleans demographic data | Raw demographic file | Cleaned demographic dataset |
| `01_data_cleaning/1.2_compute_mean_quantitative_variables_from_primary_care.R` | Computes lifetime mean values for quantitative markers | Pre-cleaned quantitative data | Summary table of mean values |


| Script | Purpose |
|--------|--------|
| [`1.1_clean_baseline_demographics.R`](01_data_cleaning/1.1_clean_baseline_demographics.R) | Cleans demographic data |


| Script | Purpose | Input | Output |
|--------|--------|-------|--------|
| `01_data_cleaning/1.1_clean_baseline_demographics.R` | Cleans and formats the demographic dataset | Raw demographic dataset | Cleaned demographic dataset |
| `01_data_cleaning/1.2_compute_mean_quantitative_variables_from_primary_care.R` | Computes lifetime mean values for quantitative markers | Pre-cleaned quantitative data | Summary table of mean values |


| Script | Purpose |
|--------|--------|
| [`1.1_clean_baseline_demographics.R`](01_data_cleaning/1.1_clean_baseline_demographics.R) | Cleans demographic data |



2. Case–Control Definition (folder: case_control_creation)

2.1_define_cALT_cases_for_GWAS.R
Defines cases with chronic ALT elevation (cALT) according to study-specific thresholds and temporal rules.

2.2_define_control_group_for_GWAS.R
Constructs a high-quality control cohort by excluding individuals with liver disease, significant alcohol intake, or other confounding medical conditions.


3. Health Outcomes Analysis (folder: health_outcomes_analysis)

3.1_join_health_outcomes_to_cases_and_controls.R
Links health-outcome variables (e.g., diagnoses, events, biomarkers) to previously defined cases and controls.

3.2_cases_vs_controls_health_outcomes_analysis.R
Performs statistical comparisons between cALT cases and controls, producing summary tables and results for baseline characteristics and clinical outcomes.


Software Requirements

This repository uses R.
Recommended version: R ≥ 4.0
Required R packages (as used in the analysis):

data.table
dplyr
ggplot2
readr
optparse
table1 


Data availability 
Due to data-use agreements and participant confidentiality the data used in the study cannot be shared.
All scripts are provided so the workflow can be reproduced on approved datasets with similar structure.


Citation
If you use this workflow, please cite the associated research article:

[INSERT FINAL PAPER NAME)









