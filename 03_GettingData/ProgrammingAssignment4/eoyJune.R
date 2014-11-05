# Load the Gross Domestic Product data for the 190 ranked countries in this data set: 
#   https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv 
# Load the educational data from this data set: 
#   https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv 
library(data.table)

gdpFile <- "./data/GDP.csv"
gdpFileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"

eduFile <- "./data/EDSTATS_Country.csv"
eduFileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"

if(!file.exists("data")){dir.create("data")}

if(!file.exists(gdpFile)){
        download.file(gdpFileUrl, destfile=gdpFileUrl, method="curl")
        dateDownloaded <- date()
}

if(!file.exists(eduFile)){
        download.file(eduFileUrl, destfile=eduFile, method="curl")
        dateDownloaded <- date()
}

gdp <- fread(gdpFile)
edu <- fread(eduFile)

# Only first 190 rows are data
gdp <- gdp[1:190,]


# Match the data based on the country shortcode. Of the countries for which the end
# of the fiscal year is available, how many end in June? 
setnames( gdp, "V1", "CountryCode")
full <- merge(gdp, edu, by="CountryCode")

notes <- full$"Special Notes"
length(grep("Fiscal year end: June", notes))
