#####################################
# GP Windbelt                       #
# Calculate descriptive statistics: #
#                                   #
#####################################


#install.packages("pdftools", "devtools")
library(pdftools)
library(tm)
# library(tm.plugin.lexisnexis)
library(devtools)
# install.packages("tidytext")
library(tidytext)
library(broom)
# install.packages("tidyverse")
library(data.table)
library(tidyverse)
library(purrr)
library(lubridate)

library(googledrive)

#########
# Pull ventyx dataset
# 
# drive_auth()
# Windbelt_Data_id <- "1lvoVfdeUjft6sFtXwZ7OZo5ly3B7VZ9g?ogsrc=32"
# 
# Windbelt_Data_gfolder <- googledrive::drive_ls(googledrive::as_id(Windbelt_Data_id))
# ventyx_dataset <- Windbelt_Data_gfolder$name[Windbelt_Data_gfolder$name == "ventyx_converted_11_27_2018_PopDensity_Income_Viewshed_lowhighimpact_doc_names.csv"]
# length(ventyx_dataset)
# 
# local_folder <- "G:/Data/VENTYX_DATASET/"
# 
# drive_read(Windbelt_Data_gfolder[1], fun = read_csv, fun_args = list())
#             
# 
# length(ventyx_dataset))
# file_downloader <- function(templates_dribble, local_folder){
#   # download all pdfs
#   for (i in 1:nrow(templates_dribble)){
#     drive_download(as_id(templates_dribble$id[[i]]), 
#                    file.path(local_folder, templates_dribble$name[[i]]),
#                    overwrite = TRUE) #check if overwrite is neede here
#   }
# }
# 
# file_downloader(ventyx_dataset, local_folder)
# 
# View(team_drive_find(pattern = "ventyx_converted_11_27_2018_popdensity_income_viewshed_lowhighimpact_doc_names.csv"))

#################

Ventyx_dataset <- read_csv(file = "G:/Data/VENTYX_DATASET/ventyx_converted_11_27_2018_PopDensity_Income_Viewshed_lowhighimpact_doc_names.csv") %>% 
  filter(!is.na(lr_tif))
  
View(Ventyx_dataset)

dim(Ventyx_dataset)

# split data of latest date to get earliest date/oldest date: 
Ventyx_dataset<-separate(Ventyx_dataset,
                         PhaseHistory,
                         into = c("PhaseHistory", 'PhaseHistory_date'), sep = ":")

class(Ventyx_dataset$PhaseHistory_date)

Ventyx_dataset$PhaseHistory_date <- as.Date(Ventyx_dataset$PhaseHistory_date, "%m/%d/%Y")

class(Ventyx_dataset$PhaseHistory_date)

min(Ventyx_dataset$PhaseHistory_date)
max(Ventyx_dataset$PhaseHistory_date)

### low-high impact:

length(Ventyx_dataset$lr_tif[Ventyx_dataset$lr_tif == 0])
length(Ventyx_dataset$lr_tif[Ventyx_dataset$lr_tif == 1])

# Low impact area by state:
ventyx_lowimpact <- Ventyx_dataset %>% 
  filter(lr_tif == 1) %>% 
  group_by(State) %>% 
  summarise(count=n())

sum(ventyx_lowimpact$count) # verifying all low impact areas are somewhere
View(ventyx_nonlowimpact)

ventyx_nonlowimpact <- Ventyx_dataset %>% 
  filter(lr_tif == 0) %>% 
  group_by(State) %>% 
  summarise(count=n())

Ventyx_dataset_lowhighimpact_totals <- Ventyx_dataset %>%
  select(ProjectName, ProjectDeveloper, State, lr_tif) %>%
  group_by(State) %>% 
  summarise(count= n()) %>% 
  summarise(low_impact = sum(lr_tif == 1))
  
View(Ventyx_dataset_lowhighimpact_totals)


## developer stats:
ProjDev_nonlowimpact <- Ventyx_dataset %>% 
  filter(lr_tif == 0) %>% 
  group_by(ProjectDeveloper) %>% 
  summarise(count=n()) %>% 
  sort(decreasing = T)
  
ProjDev_lowimpact <- Ventyx_dataset %>% 
  filter(lr_tif == 1) %>% 
  group_by(ProjectDeveloper) %>% 
  summarise(count=n()) 
  
View(ProjDev_lowimpact)
View(ProjDev_nonlowimpact)

ProjDev_lowhighimpact_totals <- Ventyx_dataset %>%
  select(ProjectDeveloper, lr_tif) %>%
  group_by(ProjectDeveloper) %>% 
  summarise(count= n())

View(ProjDev_lowhighimpact_totals)

## timeline stats

mean(Ventyx_dataset$TimelineDays)
min(Ventyx_dataset$TimelineDays)
max(Ventyx_dataset$TimelineDays)

# low impact
all_ventyx_lowimpact <- Ventyx_dataset %>% 
  filter(lr_tif == 1)
mean(all_ventyx_lowimpact$TimelineDays)
max(all_ventyx_lowimpact$TimelineDays)
min(all_ventyx_lowimpact$TimelineDays)

all_ventyx_nonlowimpact <- Ventyx_dataset %>% 
  filter(lr_tif == 0)

mean(all_ventyx_nonlowimpact$TimelineDays)
max(all_ventyx_nonlowimpact$TimelineDays)
min(all_ventyx_nonlowimpact$TimelineDays)





