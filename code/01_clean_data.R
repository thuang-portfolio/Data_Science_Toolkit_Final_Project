# load packages
library(tidyverse)
library(janitor)

# specify file location
here::i_am("code/01_clean_data.R")

# read in raw data
path_to_data <- here::here("raw_data/Bullying_2018.csv")
data <- read.delim(path_to_data, na.strings=c("", "NA"), sep = ";") %>%
  clean_names()

# remove missing values
completedata <- replace(data, data == ' ', NA)
completedata <- na.omit(completedata)

# recode variables
physical_attack_data <- completedata %>% 
  dplyr::select(physically_attacked, parents_understand_problems, close_friends, 
                were_obese, most_of_the_time_or_always_felt_lonely, sex, 
                other_students_kind_and_helpful) %>%
  mutate(physical_attack_severity = case_when(
    grepl("0 times", physically_attacked) ~ "Low",
    grepl("1 time", physically_attacked) ~ "Low",
    grepl("2 or 3 times", physically_attacked) ~ "Medium",
    grepl("4 or 5 times", physically_attacked) ~ "Medium",
    grepl("6 or 7 times", physically_attacked) ~ "Medium",
    grepl("8 or 9 times", physically_attacked) ~ "High",
    grepl("10 or 11 times", physically_attacked) ~ "High",
    grepl("12 or more times", physically_attacked) ~ "High"),
    parents_understand_problems = case_when(
      grepl("Always", parents_understand_problems) ~ "Yes",
      grepl("Most of the time", parents_understand_problems) ~ "Yes",
      grepl("Sometimes", parents_understand_problems) ~ "No",
      grepl("Rarely", parents_understand_problems) ~ "No",
      grepl("Never", parents_understand_problems) ~ "No"),
    other_students_kind_and_helpful = case_when(
      grepl("Always", other_students_kind_and_helpful) ~ "Yes",
      grepl("Most of the time", other_students_kind_and_helpful) ~ "Yes",
      grepl("Sometimes", other_students_kind_and_helpful) ~ "No",
      grepl("Rarely", other_students_kind_and_helpful) ~ "No",
      grepl("Never", other_students_kind_and_helpful) ~ "No"),
    close_friends = case_when(grepl("0", close_friends) ~ "Low",
                              grepl("1", close_friends) ~ "Low",
                              grepl("2", close_friends) ~ "Low",
                              grepl("3 or more", close_friends) ~ "High"),
    physical_attack_severity = factor(physical_attack_severity, 
                                      levels = c("Low", "Medium", "High")),
    parents_understand_problems = as.factor(parents_understand_problems),
    close_friends = as.factor(close_friends),
    were_obese = as.factor(were_obese),
    most_of_the_time_or_always_felt_lonely = 
      as.factor(most_of_the_time_or_always_felt_lonely),
    sex = as.factor(sex),
    other_students_kind_and_helpful = 
      as.factor(other_students_kind_and_helpful)) %>%
  # remove physically attacked variable
  select(-physically_attacked)

# export cleaned data to `cleaned_data` folder
saveRDS(
  physical_attack_data,
  file = here::here("cleaned_data/physical_attack_data.rds")
)
