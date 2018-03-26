#
# TeamTreehouse.R
#
# Load a lot of user stats from Team Treehouse
#

library('rvest')
library('readr')
library('jsonlite')
library('stringr')
library('httr')
library(data.table)

source("./Config.R")

treehouse.maximalePunkte.letztesUpdate <- as.Date("2018-02-03");

TeamTreehouse.GetStatistics <- function(url) {
  return(fromJSON(url))
}

TeamTreehouse.GetStatisticsPerTech <- function(statistics, overagedDate) {
  if ( treehouse.maximalePunkte.letztesUpdate <= overagedDate ) {
    print("Please visit https://teamtreehouse.com/community/leaderboards and update the maximum points per category using the points of the current leaders per category!")
  }
  
  treehouse.wichtigeKategorien <- c(
    "HTML", "CSS", "Design", "JavaScript", "PHP", "WordPress", "Development.Tools",
    "C.", "Databases", "Data.Analysis", "APIs", "Security", "Quality.Assurance")
  
  treehouse.maximalePunkte <- list(
    HTML = 6933,
    CSS = 11423,
    Design = 5033,
    JavaScript = 29958,
    PHP = 8166,
    WordPress = 8192,
    Development.Tools = 4649,
    C. = 12527, # C#
    Databases = 5728,
    Data.Analysis = 908,
    APIs = 756,
    Security = 852,
    Quality.Assurance = 221
  )
  
  treehouse.gefiltert <- t(as.data.frame(treehouse.points_detailed$points))
  treehouse.gefiltert <- subset(treehouse.gefiltert, row.names(treehouse.gefiltert) %in% treehouse.wichtigeKategorien)
  
  treehouse.gefiltert <- cbind(treehouse.gefiltert, treehouse.maximalePunkte)
  treehouse.gefiltert <- cbind(treehouse.gefiltert, round(unlist(treehouse.gefiltert[,1]) / unlist(treehouse.gefiltert[,2]) * 100, digits = 2))
  
  colnames(treehouse.gefiltert)[1] <- "My Points"
  colnames(treehouse.gefiltert)[2] <- "Max. Points"
  colnames(treehouse.gefiltert)[3] <- "Progress %"
  
  rownames(treehouse.gefiltert)[which(rownames(treehouse.gefiltert) == "C.")] <- "C#"
  
  # Add row names as first column
  treehouse.gefiltert <- as.data.frame(treehouse.gefiltert)
  setDT(treehouse.gefiltert, keep.rownames = TRUE)[]
  
  colnames(treehouse.gefiltert)[1] <- "tech"
  
  treehouse.gefiltert$`My Points` <- unlist(treehouse.gefiltert$`My Points`)
  treehouse.gefiltert$`Max. Points` <- unlist(treehouse.gefiltert$`Max. Points`)
  treehouse.gefiltert$`Progress %` <- unlist(treehouse.gefiltert$`Progress %`)

  return(treehouse.gefiltert)
}


