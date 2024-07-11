##### These scripts will create a spreadsheet from the different csv files #####
##### The csv files contain dummy information that reflects the actual data ####
##### used to create the LTBI database ########

#### NO ACTUAL PATIENT INFORMATION IS CONTAINED IN THESE CSV FILES ######

#loading library 

library(tidyverse)

####### Clinical results data #########

#Reading in and editing flowsheet data
flowsheet <- read.csv("dummy_flowsheet_for_github_page.csv")

#Changing date column from character to date

flowsheet$Dummy_Collection_Date <- as.Date(flowsheet$Dummy_Collection_Date, format = "%m/%d/%Y") 

flowsheet$Dummy_Patient_ID <- as.character(flowsheet$Dummy_Patient_ID)

#creating dataset for joining to reduce data and unique values from flowsheet data
flowsheet_join <- flowsheet %>%
  select(Dummy_Patient_ID, Dummy_Collection_Date, Display.Value) %>%
  filter(Display.Value == "Latent TB Infection") %>%
  group_by(Dummy_Patient_ID) %>%
  arrange(Dummy_Collection_Date) %>%
  slice(1L) 



#Reading in and editing ICD data
ICD <- read.csv("icd_dummy_for_github.csv")

#changing date column from character to date
ICD$Dummy_Posting_Date <- as.Date(ICD$Dummy_Posting_Date, format = "%m/%d/%Y")
ICD$Patient_ID <- as.character(ICD$Dummy_Patient_ID)

#creating dataset for joining to reduce data and unique values from ICD data

ICD_join <- ICD %>%
  select(Dummy_Patient_ID, Dummy_Posting_Date, Diag1.Icd10) %>%
  group_by(Dummy_Patient_ID) %>%
  arrange(Dummy_Posting_Date) %>%
  slice(1L)

ICD_join$Dummy_Patient_ID <- as.character(ICD_join$Dummy_Patient_ID)

#Joining clinical datasets for clinical dataset
#Doing full_join to ensure all rows from both datasets are accounted for

clinical_data <- full_join(flowsheet_join, ICD_join, by = "Dummy_Patient_ID")



############################## Demographic data ################################################

#reading in demographic data
IRGA_testing <- read.csv("IGRA_dummy_data_1.csv")

#selecting first collection date

IRGA_join <- IRGA_testing %>%
  select(Dummy_Patient_ID, Dummy_Date_Ordered, County, Ethnicity, Race, Genderid) %>%
  group_by(Dummy_Patient_ID) %>%
  arrange(Dummy_Date_Ordered) %>%
  slice(1L)

IRGA_join$Dummy_Patient_ID <- as.character(IRGA_join$Dummy_Patient_ID)

clinical_data <- full_join(clinical_data,IRGA_join,by="Dummy_Patient_ID")

#############################  combine with demographic data ###############################

patient_id <- read.csv("igra_dummy_address_list_generated_by_chatgrp.csv")

patient_id$Dummy_Patient_ID <- as.character(patient_id$Dummy_Patient_ID)

ltbi_testing <- full_join(patient_id, clinical_data, by = "Dummy_Patient_ID")

