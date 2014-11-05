# The American Community Survey distributes downloadable data about United States communities.
# Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv
# using the fread() command load the data into an R object: DT
library(rbenchmark)
library(data.table)

localFile <- "./data/Fss06pid.csv"
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv "

if(!file.exists("data")){dir.create("data")}

if(!file.exists(localFile)){
        download.file(fileUrl, destfile=localFile, method="curl")
        dateDownloaded <- date()
}

DT <- fread(localFile)


# Which of the following is the fastest way to calculate the average value of the variable
# 'pwgtp15' broken down by sex using the data.table package?

# mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15)
# rowMeans(DT)[DT$SEX==1]; rowMeans(DT)[DT$SEX==2]
# tapply(DT$pwgtp15,DT$SEX,mean)
# mean(DT$pwgtp15,by=DT$SEX)
# sapply(split(DT$pwgtp15,DT$SEX),mean)
# DT[,mean(pwgtp15),by=SEX]


fn1 <- function(DT) { mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15) }
fn2 <- function(DT) { rowMeans(DT)[DT$SEX==1]; rowMeans(DT)[DT$SEX==2] }
fn3 <- function(DT) { tapply(DT$pwgtp15,DT$SEX,mean) }
fn4 <- function(DT) { mean(DT$pwgtp15,by=DT$SEX) }
fn5 <- function(DT) { sapply(split(DT$pwgtp15,DT$SEX),mean) }
fn6 <- function(DT) { DT[,mean(pwgtp15),by=SEX] }

# Check that each function returns average for both sexes then benchmark them
# TODO automate this to read a list of functions, check for two outputs, then benchmark
benchmark(fn3(DT), replications = 1000)
benchmark(fn5(DT), replications = 1000)
benchmark(fn6(DT), replications = 1000)

