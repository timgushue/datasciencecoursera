# The American Community Survey distributes downloadable data about United States communities.
# Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv
# and load the data into R. The code book, describing the variable names is here:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
library(data.table)

localFile <- "./data/Fss06hid.csv"
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv "

if(!file.exists("data")){dir.create("data")}

if(!file.exists(localFile)){
        download.file(fileUrl, destfile=localFile, method="curl")
        dateDownloaded <- date()
}

file <- fread(localFile)

# How many housing units in this survey were worth more than $1,000,000?
file[,sum(VAL==24, na.rm=TRUE)]