library(data.table)

localFile <- "./data/repdata-data-StormData.csv.bz2"
fileUrl <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"

if(!file.exists("data")){dir.create("data")}

if(!file.exists(localFile)){
    download.file(fileUrl, destfile=localFile, method="curl")
    dateDownloaded <- date()
    
}

data <- data.table(read.csv(bzfile(localFile)))

# Rank EVTYPE by health and financial risks
# Health risk is FATALITIES and INJURIES
healthData <- data[,list(FATALITIES=sum(FATALITIES), INJURIES=sum(INJURIES)), by=EVTYPE]
healthData$HEALTHRISK <- healthData[,FATALITIES+INJURIES]
healthData <- healthData[order(-HEALTHRISK)]
barplot(head(healthData$HEALTHRISK, 10), log="y")
# Financial risk is PROPDMG and CROPDMG (check *EXP)
financialData <- data[,list(PROPDMG=sum(PROPDMG), CROPDMG=sum(CROPDMG)), by=EVTYPE]
financialData$FINANCIALRISK <- financialData[,PROPDMG+CROPDMG]
financialData <- financialData[order(-FINANCIALRISK)]
barplot(head(financialData$FINANCIALRISK, 10), log="y")
# merge data 
comboRisk <- merge(financialData, healthData, by='EVTYPE')
comboRisk$TOTALRISK <- comboRisk[, FINANCIALRISK+HEALTHRISK]
comboRisk <- comboRisk[order(-TOTALRISK)]
# top total combined risks
head(comboRisk[order(-comboRisk$TOTALRISK)], 10)
# top crop damage
head(comboRisk[order(-comboRisk$CROPDMG)], 10)
# top property damage
head(comboRisk[order(-comboRisk$PROPDMG)], 10)
# top injuries
head(comboRisk[order(-comboRisk$INJURIES)], 10)
# top fatalities
head(comboRisk[order(-comboRisk$FATALITIES)], 10)

