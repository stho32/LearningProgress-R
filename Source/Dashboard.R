#
# Dashboard.R
#
# All processing behind that R-Markdown-file, just without the visuals
#

source("./Config.R")
source("./CodeSchool.R")
source("./TeamTreehouse.R")
source("./Pluralsight.R")
source("./DataCamp.R")
source("./Mark.R")

# Grab all stats that you can find

## CodeSchool
codeschool <- CodeSchool.GetUserInformation(codeschool.username)
codeschool_points <- CodeSchool.GetPoints(codeschool.profile)

## TeamTreehouse
treehouse.points_detailed <- TeamTreehouse.GetStatistics(treehouse.profile)
treehouse_points <- treehouse.points_detailed$points$total
teamTreehouseStatisticsPerTech <- TeamTreehouse.GetStatisticsPerTech(treehouse.points_detailed, overagedDate)

## DataCamp
datacamp_points <- DataCamp.GetPoints(datacamp.profile)

## Pluralsight
#...


# Now lets mix them up a bit, create some structures that will help us make 
# nice tables
Dashboard.TotalOverviewPerPortal <- function() {
  
  points <- c(datacamp_points, treehouse_points, codeschool_points)
  names(points) <- c("DataCamp", "TeamTreehouse", "CodeSchool")
  maxPoints <- c(50696, 131540, 72)
  asPercentages <- points / maxPoints * 100 
  
  names(asPercentages) <- paste(names(points))
  asPercentages = asPercentages[order(-asPercentages)]
  
  result <- as.data.frame(asPercentages)
  colnames(result)[1] <- "Learning progress %"
  result$`Learning progress %` <- round(result$`Learning progress %`, digits = 2)
  
  result <- data.frame( portal = rownames(result), `Learning progress %` = result)
  
  colnames(result) <- c("portal", "Learning progress %")
  rownames(result) <- NULL
  
  return(result)
}


Dashboard.TechnologyKnowledgeOverview <- function(treehouseStatisticsPerTech) {

  # Create a data frame in which we can place all information we have...
  overviewPerTech <- data.frame(list(
    tech = character(),
    pluralsight_score_in_percent = numeric(),
    mark = numeric(),
    codeschool_progress = numeric(),
    treehouse_progress = numeric(),
    dataCamp_progress = numeric(),
    certificate = character()
  ))
  
  # This function creates a row for the data frame from the parameters given.
  # This gives me a way for shortcuts...
  techinfo <- function (name, certificate, pluralsightTopics, codeschoolPercent = NA, dataCamp = NA,
                        teamTreehouseTopics = NULL) {
    pluralsight_score <- NA
    pluralsight_mark  <- NA
    
    # in case pluralsight topics are given, we collect the points of all named topics
    # and calculate an average
    if (length(pluralsightTopics) > 0) {
      pluralsight_score <- mean(pluralsight_details[pluralsight_details$id %in% pluralsightTopics,]$score)
      pluralsight_score <- round(pluralsight_score / 300 * 100, 2)
      pluralsight_mark  <- MarkR.AsMark(pluralsight_score)
    }
    
    treehouseProgress <- NA
    # in case treehouse topics are given, we collect the points of all named topics 
    # and calculate an average
    if (!is.null(teamTreehouseTopics)) {
      treehouseProgress <- mean(treehouseStatisticsPerTech[treehouseStatisticsPerTech$tech %in% teamTreehouseTopics,]$`Progress %`)
      treehouseProgress <- round(treehouseProgress, 2)
    }
    
    return(
      list(
        tech = name,
        pluralsight_score_in_percent = pluralsight_score,
        mark = pluralsight_mark,
        codeschool_progress = codeschoolPercent,
        treehouse_progress = treehouseProgress,
        dataCamp_progress = round(dataCamp, digits = 2),
        certificate = certificate
      ))
  }
  
  # Bind all the different techs to the overview...
  overviewPerTech<-rbind(overviewPerTech, techinfo("HTML, CSS, JS", "MS (70-480, 2016)", c("javascript", "jquery", "css", "html5"), 
                                                   codeschoolPercent = mean( c(codeschool$htmlCssPercent, codeschool$javascriptPercent)),
                                                   teamTreehouseTopics = c("HTML", "CSS", "JavaScript")
                                                   ))
  overviewPerTech<-rbind(overviewPerTech, techinfo("ASP.Net", "-", c("aspnet-mvc-5")))
  
  overviewPerTech<-rbind(overviewPerTech, techinfo("C#", "-", c("c-sharp"), codeschoolPercent = codeschool$netPercent,
                                                   teamTreehouseTopics = c("C#")))
  
  overviewPerTech<-rbind(overviewPerTech, techinfo("MS SQL Server", "-", c(), codeschoolPercent = codeschool$databasePercent,
                                                   teamTreehouseTopics = c("Databases")))
  
  overviewPerTech<-rbind(overviewPerTech, techinfo("Powershell", "-", c("powershell")))
  overviewPerPortal <- Dashboard.TotalOverviewPerPortal()
  overviewPerTech<-rbind(overviewPerTech, techinfo("R", "-", c(), dataCamp = overviewPerPortal[overviewPerPortal$portal == "DataCamp",]$`Learning progress %`, 
                                                   codeschoolPercent =   codeschool$rPercent,
                                                   teamTreehouseTopics = c("Data.Analysis")))
  
  overviewPerTech<-rbind(overviewPerTech, techinfo("PHP", "-", c(), codeschoolPercent = codeschool$phpPercent,
                                                   teamTreehouseTopics = c("PHP")))
  overviewPerTech<-rbind(overviewPerTech, techinfo("MySQL", "-", c("mysql"), codeschoolPercent = codeschool$databasePercent,
                         teamTreehouseTopics = c("Databases")))
  overviewPerTech<-rbind(overviewPerTech, techinfo("C++", "-", c("c-plus-plus")))
  
  colnames(overviewPerTech) <- c("tech", "Pluralsight score in %", "equals mark", "CodeSchool Progress %", "Treehouse Progress %", "DataCamp Progress %", "certificate")
  
  return(overviewPerTech) 
}

#
# Pluralsight score average
# 
Dashboard.PluralsightAverage <- function (overviewPerTech) {
  return (mean(overviewPerTech$`Pluralsight score in %`, na.rm=TRUE))
}

#
# Pluralsight knowledge by tech category (A, A/B, B, C)
#
Dashboard.PluralsightAverageByCategory <- function (overviewPerTech) {
  result <- list()
  
  result$A  <- round(Dashboard.PluralsightAverage(overviewPerTech[which(overviewPerTech$tech %in% c("HTML, CSS, JS", "ASP.Net", "C#", "MS SQL Server")),]), digits = 2)
  result$AB <- round(Dashboard.PluralsightAverage(overviewPerTech[which(overviewPerTech$tech %in% c("Powershell", "R")),]), digits = 2)
  result$B  <- round(Dashboard.PluralsightAverage(overviewPerTech[which(overviewPerTech$tech %in% c("PHP", "MySQL")),]), digits = 2)
  result$C  <- round(Dashboard.PluralsightAverage(overviewPerTech[which(overviewPerTech$tech %in% c("C++")),]), digits = 2)
  
  return (result)
}

# The total mastery percentage is the average of all shown percentages
# in the overview per tech datatable, excluding values that are NA
Dashboard.TotalMasteryPercentage <- function(overviewPerTech) {
  
  pluralsightAverage <- Dashboard.PluralsightAverage(overviewPerTech)
  codeschoolAverage <- mean(overviewPerTech$`CodeSchool Progress %`, na.rm=TRUE)
  treehouseAverage <- mean(overviewPerTech$`Treehouse Progress %`, na.rm=TRUE)
  datacampAverage <- mean(overviewPerTech$`DataCamp Progress %`, na.rm=TRUE)
  
  totalAverage <- mean(c(pluralsightAverage, codeschoolAverage, treehouseAverage, datacampAverage))
  totalAverage <- round(totalAverage, digits = 2)
  
  return (totalAverage)
  
}

# Collect statistics for tool knowledge 
# Actually this is a list of all paths with ids contained in the 
# configuration pluralsight.pathsForTools variable.
Dashboard.ToolOverview <- function() {
  pluralsight.pathsForTools = c("docker")
  toolKnowledge <- Pluralsight.Statistics[Pluralsight.Statistics$id %in% pluralsight.pathsForTools,]
  toolKnowledge$ScoreInPercent <- round( toolKnowledge$score / 300 * 100, digits = 2 )
  toolKnowledge$mark <- MarkR.AsMark(toolKnowledge$ScoreInPercent)
  toolKnowledge$url <- NULL
  toolKnowledge$thumbnailUrl <- NULL
  toolKnowledge$id <- NULL
  return (toolKnowledge)
}

#overview <- Dashboard.TechnologyKnowledgeOverview(teamTreehouseStatisticsPerTech)


