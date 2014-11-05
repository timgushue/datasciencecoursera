# Load the Gross Domestic Product data for the 190 ranked countries in this data set: 
#   https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv 
# Load the educational data from this data set: 
#   https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv 
library(data.table)

gdpFile <- "./data/FGDP.csv"
gdpFileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"

eduFile <- "./data/FEDSTATS_Country.csv"
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

setnames(gdp,
         c("V1",          "V2",   "V3", "V4",      "V5",  "V6", "V7", "V8", "V9", "V10"),
         c("CountryCode", "Rank", "V3", "Country", "GDP", "V6", "V7", "V8", "V9", "V10")
         )

setkey(gdp, "CountryCode")
setkey(edu, "CountryCode")

# Match the data based on the country shortcode. How many of the IDs match?
# Sort the data frame in descending order by GDP rank (so United States is last).
# What is the 13th country in the resulting data frame? 
foo <- merge(edu, gdp)
bar <- foo[, c("Rank", "Country"), with=FALSE]
qux <- bar[order(as.numeric(Rank), decreasing=TRUE, na.last=TRUE)]

# What is the average GDP ranking for the "High income: OECD" and "High income: nonOECD" group?
OECD <- foo[foo$"Income Group" %in% "High income: OECD", ]
nonOECD <- foo[foo$"Income Group" %in% "High income: nonOECD", ]

mean(as.numeric(OECD$Rank))
mean(as.numeric(nonOECD$Rank))


# Cut the GDP ranking into 5 separate quantile groups. Make a table versus Income.Group.
# How many countries are Lower middle income but among the 38 nations with highest GDP?
bar <- foo[, c("GDP", "Income Group"), with=FALSE]
bar$GDP <- gsub( "[,.]", "", bar$GDP)
bar$GDP <- bar$GDP <- as.numeric(bar$GDP, na.rm=T)
bar <- bar[complete.cases(bar),]
bar <- bar[order(as.numeric(GDP), decreasing=TRUE, na.last=TRUE)]

bar$quartile <- with(bar, cut(GDP, breaks=quantile(GDP, probs=seq(0,1, by=0.20), na.rm=T), include.lowest=TRUE))
bar <- bar[order(as.numeric(quartile), decreasing=TRUE, na.last=TRUE)]
bar$quartile <- as.numeric(bar$quartile)

high <- subset(bar, quartile==5)
sum(high$"Income Group"=="Lower middle income")
