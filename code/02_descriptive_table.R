# load package
library(tidyverse)
library(gtsummary)

# specify file location
here::i_am("code/02_descriptive_table.R")

# read in cleaned data
physical_attack_data <- readRDS(
  file = here::here("cleaned_data/physical_attack_data.rds")
)

# rename column variables for table
table_data <- physical_attack_data
names(table_data)[names(table_data)=="parents_understand_problems"] <-  "Parents Understand Problems"
names(table_data)[names(table_data)=="close_friends"] <- "Close Friends"
names(table_data)[names(table_data)=="were_obese"] <- "Were Obese"
names(table_data)[names(table_data)=="most_of_the_time_or_always_felt_lonely"] <- "Most of the Time or Always Felt Lonely"
names(table_data)[names(table_data)=="sex"] <- "Sex"
names(table_data)[names(table_data)=="other_students_kind_and_helpful"] <- "Other Students Kind and Helpful"

# create summary table 
table <- tbl_summary(table_data, by = "physical_attack_severity", 
            type = all_dichotomous() ~ "categorical") %>% 
            add_overall() %>%
            modify_caption("**Distribution of Variables Across 
                       Physical Attack Severity Levels**")

# export table to outputs folder
saveRDS(
  table,
  file = here::here("outputs/table.rds")
)