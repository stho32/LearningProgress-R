# 
# Config.Sample.R
#
# This is a configuration file prototype. Copy this file to Config.R and 
# add your profile information as needed.
#

# Some critical R options... 
options(scipen=999)
options(stringsAsFactors=FALSE)
options(knitr.kable.NA = '')
#

datacamp.profile <- "https://www.datacamp.com/profile/sthoffmann";
treehouse.profile <- "https://teamtreehouse.com/stefanhoffmann.json";

codeschool.username <- "stho";
codeschool.profile <- paste("https://www.codeschool.com/users/", codeschool.username, sep="");

pluralsight.skillmeasurementsUrl = "https://app.pluralsight.com/profile/data/skillmeasurements/f68703d3-cf25-4d49-96ae-ef5f005e9d7e";

# Skill measurements taken older than this need renewal
overagedDate <- Sys.Date() - 30*6

#certificates <- read.csv()