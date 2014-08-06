# This assignment uses data from the UC Irvine Machine Learning Repository, a popular
# repository for machine learning datasets. In particular, we will be using the
# “Individual household electric power consumption Data Set” which I have made 
# available on the course web site:
#   Dataset: Electric power consumption [20Mb]
#   Description: Measurements of electric power consumption in one household with 
#     a one-minute sampling rate over a period of almost 4 years. Different 
#     electrical quantities and some sub-metering values are available.
library(data.table)


# Download the data if it doesn't exist locally
localFile <- "./data/household_power_consumption.txt"
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

if(!file.exists(localFile)){
        # create a temporary directory and placeholder file
        td <- tempdir()
        tf <- tempfile(tmpdir=td, fileext=".zip")

        # download into the placeholder file and unzip into the local directory
        download.file(fileUrl, tf, method="curl")
        dateDownloaded <- date()
        unzip(tf, overwrite=TRUE, exdir="./data")
}

# Subset the data from the dates 2007-02-01 and 2007-02-02.
rawData   <- fread(localFile, na.strings="?")
dateData  <- transform(rawData, Date = as.Date(Date, format='%d/%m/%Y'))
smallData <- subset(dateData, Date >= as.Date("2007-02-01") & Date <= as.Date("2007-02-02"))

# Drop Date and Time after merging them into a single column.
dateTime  <- strptime(paste(smallData[,Date], smallData[,Time]), format="%Y-%m-%d %H:%M:%S")
dateTime  <- as.POSIXct(dateTime)
smallData <- cbind(DateTime = dateTime, smallData)
smallData[,Date:=NULL]
smallData[,Time:=NULL]

# Retype the numeric cloumns
smallData <- transform(smallData,
                      Global_active_power   = as.numeric(Global_active_power),
                      Global_reactive_power = as.numeric(Global_reactive_power),
                      Voltage               = as.numeric(Voltage),
                      Global_intensity      = as.numeric(Global_intensity),
                      Sub_metering_1        = as.numeric(Sub_metering_1),
                      Sub_metering_2        = as.numeric(Sub_metering_2),
                      Sub_metering_3        = as.numeric(Sub_metering_3)
              )


# Plot1
png("plot1.png")
hist(smallData$Global_active_power, col = "red", main = "Global Active Power", xlab = "Global Active Power (kilowatts)")
dev.off()