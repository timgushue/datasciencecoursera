# You can use the quantmod (http://www.quantmod.com/) package to get historical stock prices
# for publicly traded companies on the NASDAQ and NYSE. Use the following code to download
# data on Amazon's stock price and get the times the data was sampled.
library(quantmod)

amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)


# How many values were collected in 2012? How many values were collected on Mondays in 2012?

year <- grep("2012-", sampleTimes)
length(year)

days <- format(as.Date(sampleTimes[year]), format="%A")
length(grep("Monday", days))
