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

# alt, wegwerfen sobald möglich
pluralsight_details <- fromJSON("https://app.pluralsight.com/profile/data/skillmeasurements/f68703d3-cf25-4d49-96ae-ef5f005e9d7e")

# neu :)
pluralsight.SkillMeasurements <- fromJSON(pluralsight.skillmeasurementsUrl)