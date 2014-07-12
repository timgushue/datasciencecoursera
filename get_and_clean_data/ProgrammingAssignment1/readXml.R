# Read the XML data on Baltimore restaurants from here:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml
library(XML)

localFile <- "./data/restaurants.xml"
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml "

if(!file.exists("data")){dir.create("data")}

if(!file.exists(localFile)){
        download.file(fileUrl, destfile=localFile, method="curl")
        dateDownloaded <- date()
}


doc <- xmlTreeParse(localFile, useInternal=TRUE)
rootNode <- xmlRoot(doc)

# How many restaurants have zipcode 21231?

zipCodes <- xpathSApply(rootNode,"//zipcode", xmlValue)
sum(ifelse(zipCodes == 21231, 1, 0))