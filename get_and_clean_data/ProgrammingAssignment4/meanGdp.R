# Load the Gross Domestic Product data for the 190 ranked countries in this data set: 
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
# Original data sources: http://data.worldbank.org/data-catalog/GDP-ranking-table
library(data.table)

localFile <- "./data/GDP.csv"
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"

if(!file.exists("data")){dir.create("data")}

if(!file.exists(localFile)){
        download.file(fileUrl, destfile=localFile, method="curl")
        dateDownloaded <- date()
}

# Remove the commas from the GDP numbers in millions of dollars and average them. What is the average? 
file <- fread(localFile)

# Tricky here: only the first 190 rows are part of the table
gdp <- file[1:190, "V5", with=FALSE]
gdp <- gsub("[,]", "", gdp$V5)
gdp <- as.numeric(gdp)
mean(gdp)