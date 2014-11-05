# Download the Excel spreadsheet on Natural Gas Aquisition Program here:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx
# Read rows 18-23 and columns 7-15 into R and assign the result to a variable called:
#  dat
# What is the value of:
#  sum(dat$Zip*dat$Ext,na.rm=T)
library(xlsx)

localFile <- "./data/gov_NGAP.xlsx"
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"

if(!file.exists("data")){dir.create("data")}

if(!file.exists(localFile)){
        download.file(fileUrl, destfile=localFile, method="curl")
        dateDownloaded <- date()
}


# Read rows 18-23 and columns 7-15 into R and assign the result to a variable called: dat
colIndex <- 7:15
rowIndex <- 18:23
dat <- read.xlsx(localFile, sheetIndex=1, colIndex=colIndex, rowIndex=rowIndex)

# What is the value of:
sum(dat$Zip*dat$Ext,na.rm=T)