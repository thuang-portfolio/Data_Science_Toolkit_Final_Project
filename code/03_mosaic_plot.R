# load packages
library(tidyverse)
library(ggmosaic)

# specify file location
here::i_am("code/03_mosaic_plot.R")

# read in cleaned data
physical_attack_data <- readRDS(
  file = here::here("cleaned_data/physical_attack_data.rds")
)

# create mosaic plot
mosaic_plot <- ggplot(data = physical_attack_data) +
                geom_mosaic(aes(x = product(physical_attack_severity, 
                            most_of_the_time_or_always_felt_lonely), 
                            fill=physical_attack_severity)) +
                scale_fill_discrete(name = "Physical Attack Severity Levels") +
                labs(x = "Most of the Time or Always Felt Lonely", 
                     y = "Physical Attack Severity", 
                     title = "Association between Physical Attack Severity and Loneliness")

# export plot to output folder
ggsave(
  here::here("outputs/mosaic_plot.png"),
  plot = mosaic_plot,
  device = "png"
)
