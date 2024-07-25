##### These scripts will create a spreadsheet from the different csv files #####
##### The csv files contain dummy information that reflects the actual data ####
##### used to create the LTBI database ########

#### NO ACTUAL PATIENT INFORMATION IS CONTAINED IN THESE CSV FILES ######
#### Dummy data created by ChatGPT ###################

setwd("f:/Dissertation_Work/Aim_3/dummy_data/")
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



############################## Other testing data ################################################

#reading in demographic data
#### commented lines run correctly


dummy_IRGA_testing <- read.csv("dummy_igra_testing_by_date.csv")
dummy_TB_TST_IGRA_Results <- read.csv("dummy_tb_igra_results.csv")
dummy_TB_TST_Data_IGRA_Assesment <- read.csv("dummy_tb_tst_data_IGRA_assessment.csv")
dummy_TB_TST_Data_Treatment_Reason <- read.csv("dummy_tb_tst_data_treatment_reason.csv")
dummy_TB_TST_DATA_TST_Results <- read.csv("dummy_tb_tst_data_tst_result.csv")
dummy_TB_TST_Results <- read.csv("dummy_tb_tst_results.csv")


# #selecting first collection date for each patient


dummy_IRGA_testing_join <- dummy_IRGA_testing %>%
   select(Dummy_Patient_ID, Dummy_Date_Ordered) %>%
   group_by(Dummy_Patient_ID) %>%
   arrange(Dummy_Date_Ordered) %>%
   slice(1L)


dummy_TB_TST_IGRA_Results_join <- dummy_TB_TST_IGRA_Results %>%
   select(Dummy_Patient_ID, Dummy_DOB,Birth.Country, Date.Entry.US,Display_Value) %>%
   group_by(Dummy_Patient_ID) %>%
   arrange(Dummy_DOB) %>%
   slice(1L)

dummy_TB_TST_Data_IGRA_Assesment_join <- dummy_TB_TST_Data_IGRA_Assesment %>%
   select(Dummy_Patient_ID, Dummy_Date_Ordered) %>%
   group_by(Dummy_Patient_ID) %>%
   arrange(Dummy_Date_Ordered) %>%
   slice(1L)

dummy_TB_TST_Data_Treatment_Reason_join <- dummy_TB_TST_Data_Treatment_Reason %>%
   select(Dummy_Patient_ID, Dummy_Date_Ordered) %>%
   group_by(Dummy_Patient_ID) %>%
   arrange(Dummy_Date_Ordered) %>%
   slice(1L)

 dummy_TB_TST_DATA_TST_Results_join <- dummy_TB_TST_DATA_TST_Results %>%
   select(Dummy_Patient_ID, Dummy_Date_Ordered) %>%
   group_by(Dummy_Patient_ID) %>%
   arrange(Dummy_Date_Ordered) %>%
   slice(1L)

dummy_TB_TST_Results_join <- dummy_TB_TST_Results %>%
   select(Dummy_Patient_ID, Dummy_Date_Ordered) %>%
   group_by(Dummy_Patient_ID) %>%
   arrange(Dummy_Date_Ordered) %>%
   slice(1L)



#joining IGRA files
igra_join_1<- full_join(dummy_IRGA_testing_join, dummy_TB_TST_IGRA_Results_join, by="Dummy_Patient_ID") 
igra_join <- full_join(igra_join_1, dummy_TB_TST_Data_IGRA_Assesment_join, by="Dummy_Patient_ID")
  

#joining TST files

tst_join_1 <- full_join(dummy_TB_TST_Data_Treatment_Reason_join,
                        dummy_TB_TST_DATA_TST_Results_join,
                        by ="Dummy_Patient_ID")
tst_join_full <- full_join(tst_join_1,dummy_TB_TST_Results_join,
                        by="Dummy_Patient_ID")

testing <- full_join(igra_join,tst_join_full, by = "Dummy_Patient_ID") 

#### Changing to character for joining purposes
testing$Dummy_Patient_ID <- as.character(testing$Dummy_Patient_ID)

testing_data_1 <- full_join(clinical_data, testing, by="Dummy_Patient_ID")


################# Combine Testing Data with Dummy Demographic Data ########
patient_id <- read.csv("dummy_patient_data_linked.csv")

patient_id$Dummy_Patient_ID <- as.character(patient_id$Dummy_Patient_ID)


ltbi_data <- full_join(patient_id, testing_data_1, by = "Dummy_Patient_ID")

unique_ltbi <- ltbi_data %>%
  distinct(Dummy_Patient_ID)


#################  Displaying Data By County ####################
county <- ltbi_data %>%
  group_by(County) %>%
  summarise(frequency = n())
