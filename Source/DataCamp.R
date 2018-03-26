#
# DataCamp.R
#
# Load a lot of user stats from Data Camp
#

library('rvest')
library('readr')
library('jsonlite')
library('stringr')
library('httr')

source("./Config.R")

#
# Grab the points from DataCamp
#
DataCamp.GetPoints <- function(url) {
  result <- html_session(datacamp.profile) %>%
    html_node(".profile-header__stats") %>%
    html_node(".stats-block__number") %>%
    html_text() %>%
    readr::parse_number()
  
  return(result)
}

