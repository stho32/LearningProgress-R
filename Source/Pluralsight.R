#
# Pluralsight.R
#
# Loads a lot of stats for a given public user
#

library('rvest')
library('readr')
library('jsonlite')
library('stringr')
library('httr')

source("./Config.R")

 
# This function grabs statistics 
Pluralsight.GetStatisticsFrom <- function(url) {
  result <- fromJSON(url)
  result$dateCompleted <- as.Date(result$dateCompleted)
  result <- result[order(result$percentile),]
  colnames(result)[2] <- "Tech"
  colnames(result)[6] <- "IQ"
  colnames(result)[8] <- "Last measured"
  return(result)
}

# neu :)
Pluralsight.Statistics <- Pluralsight.GetStatisticsFrom(pluralsight.skillmeasurementsUrl)
# alt, wegwerfen sobald möglich
pluralsight_details    <- Pluralsight.GetStatisticsFrom(pluralsight.skillmeasurementsUrl)
