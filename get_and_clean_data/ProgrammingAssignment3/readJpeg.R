# Using the jpeg package read in the following picture of your instructor into R.
library(jpeg)

localFile <- "./data/jeff.jpg"
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"

if(!file.exists("data")){dir.create("data")}

if(!file.exists(localFile)){
        download.file(fileUrl, destfile=localFile, method="curl")
        dateDownloaded <- date()
}

# Use the parameter native=TRUE. What are the 30th and 80th quantiles of the 
# resulting data?
file <- readJPEG(localFile, native=TRUE)

quantile(file, c(.30, .80))
