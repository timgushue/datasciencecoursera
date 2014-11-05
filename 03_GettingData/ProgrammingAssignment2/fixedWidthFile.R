# Read this data set into R and report the sum of the numbers in the fourth column. 
# https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for 
# Original source of the data: http://www.cpc.ncep.noaa.gov/data/indices/wksst8110.for 
# (Hint this is a fixed width file format)
library(data.table)

localFile <- "./data/Fwksst8110.for"
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"

if(!file.exists("data")){dir.create("data")}

if(!file.exists(localFile)){
        download.file(fileUrl, destfile=localFile, method="curl")
        dateDownloaded <- date()
}

# Brute force all the columns and spaces
foo <- read.fwf(localFile,  skip = 4, widths = c(10, 5, 4, 4, 5, 4, 4, 5, 4, 4, 5, 4, 4))
# Keep only the columns and sum the 4th one
bar <- foo[,c(1, 3, 4, 6, 7, 9, 10, 12, 13)]
sum(bar[,4])