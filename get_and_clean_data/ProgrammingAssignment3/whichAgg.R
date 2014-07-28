# Create a logical vector that identifies the households on greater than 10 acres 
# who sold more than $10,000 worth of agriculture products. Assign that logical 
# vector to the variable agricultureLogical. Apply the which() function like this 
# to identify the rows of the data frame where the logical vector is TRUE. 
# which(agricultureLogical) What are the first 3 values that result?
library(data.table)

localFile <- "./data/Fss06hid.csv"
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv "

if(!file.exists("data")){dir.create("data")}

if(!file.exists(localFile)){
        download.file(fileUrl, destfile=localFile, method="curl")
        dateDownloaded <- date()
}

file <- fread(localFile)

# How many households on greater than 10 acres and sold more than $10,000 worth 
# of agriculture products?
agricultureLogical <- file$ACR==3 & file$AGS==6

# What are the first 3 values that result?
head(which(agricultureLogical), n=3)