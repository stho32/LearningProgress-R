#
# CodeSchool.R
#
# Loads a lot of stats for a given public user
#

options(stringsAsFactors = TRUE)

library('rvest')
library('readr')
library('jsonlite')
library('stringr')
library('httr')

CodeSchool.GetUserInformation <- function (username) {
  # Basic information about the user
  codeschool_user.profile <-
    paste("https://www.codeschool.com/users/",
          username,
          ".json",
          sep = "")
  
  
  codeschool_user.json <- fromJSON(codeschool_user.profile)
  codeschool_user.completedCourses <-
    str_replace(codeschool_user.json$courses$completed$url,
                "http://www.codeschool.com",
                "")
  
  # Information about codeschool courseware
  codeschool.importantPaths <- c(
    "https://www.codeschool.com/learn/html-css",
    "https://www.codeschool.com/learn/javascript",
    "https://www.codeschool.com/learn/git",
    "https://www.codeschool.com/learn/net",
    "https://www.codeschool.com/learn/php",
    "https://www.codeschool.com/learn/database"
  )
  
  codeschool.getCoursesCompletePercent <- function(courses) {
    return(sum(courses %in% codeschool_user.completedCourses) / length(courses) * 100)
  }
  
  codeschool.getPathPercentComplete <- function(url) {
    uastring <- "httr"
    
    links <- html_session(url, user_agent(uastring)) %>% html_nodes("a") %>% html_attr("href")
    courses <- unique(links[startsWith(links, "/courses/")])
    return(codeschool.getCoursesCompletePercent(courses))
  }
  
  codeschool = list()
  
  codeschool$htmlCssPercent    <-
    codeschool.getPathPercentComplete("https://www.codeschool.com/learn/html-css")
  codeschool$javascriptPercent <-
    codeschool.getPathPercentComplete("https://www.codeschool.com/learn/javascript")
  codeschool$gitPercent        <-
    codeschool.getPathPercentComplete("https://www.codeschool.com/learn/git")
  codeschool$netPercent        <-
    codeschool.getPathPercentComplete("https://www.codeschool.com/learn/net")
  codeschool$phpPercent        <-
    codeschool.getPathPercentComplete("https://www.codeschool.com/learn/php")
  codeschool$databasePercent   <-
    codeschool.getPathPercentComplete("https://www.codeschool.com/learn/database")
  codeschool$rPercent          <-
    codeschool.getCoursesCompletePercent(c("/courses/try-r"))
  
  return(codeschool)
}

CodeSchool.GetUserInformation("stho")
