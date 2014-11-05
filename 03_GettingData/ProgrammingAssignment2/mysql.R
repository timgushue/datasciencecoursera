# The sqldf package allows for execution of SQL commands on R data frames.
# We will use the sqldf package to practice the queries we might send with the dbSendQuery command in RMySQL.
# Download the American Community Survey data and load it into an R object called: asc
library(data.table)

localFile <- "./data/Fss06pid.csv"
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"

if(!file.exists("data")){dir.create("data")}

if(!file.exists(localFile)){
        download.file(fileUrl, destfile=localFile, method="curl")
        dateDownloaded <- date()
}

acs <- fread(localFile)

# Which of the following commands will select only the data for the probability weights pwgtp1 with ages less than 50?
# sqldf("select * from acs where AGEP < 50 and pwgtp1")
# sqldf("select * from acs where AGEP < 50")
# sqldf("select pwgtp1 from acs where AGEP < 50")
# sqldf("select * from acs")

pwgtp1 <- sqldf("select pwgtp1 from acs where AGEP < 50")
names(pwgtp1)

# what is the equivalent function to unique(acs$AGEP)
AGEP <- sqldf("select distinct AGEP from acs")
