# Register an application with the Github API here https://github.com/settings/applications.
# Access the API to get information on your instructors repositories
# (hint: this is the url you want "https://api.github.com/users/jtleek/repos").
# Use this data to find the time that the datasharing repo was created. What time was it created?
# This tutorial may be useful (https://github.com/hadley/httr/blob/master/demo/oauth2-github.r).
# You may also need to run the code in the base R package and not R studio.

library(httr)
library(jsonlite)
source("../../credentials.R")

# Authorize this application through the API (opens web browser)
myapp <- oauth_app("github",key=github_key,secret=github_secret)
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)


jsonData <- fromJSON("https://api.github.com/users/jtleek/repos")
result <- jsonData[,c("name", "created_at"), drop=FALSE]
subset(result, result$name==datasharing)