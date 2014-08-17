# Fine particulate matter (PM2.5) is an ambient air pollutant for which there is strong evidence
# that it is harmful to human health. In the United States, the Environmental Protection Agency
# (EPA) is tasked with setting national ambient air quality standards for fine PM and for tracking
# the emissions of this pollutant into the atmosphere. Approximatly every 3 years, the EPA releases
# its database on emissions of PM2.5. This database is known as the National Emissions Inventory
# (NEI). You can read more information about the NEI at the EPA National Emissions Inventory web site
# (http://www.epa.gov/ttn/chief/eiinformation.html).

# For each year and for each type of PM source, the NEI records how many tons of PM2.5 were emitted
# from that source over the course of the entire year. The data that you will use for this assignment
# are for 1999, 2002, 2005, and 2008.
library(ggplot2)

summaryFile <- "./data/exdata-data-NEI_data/summarySCC_PM25.rds"
classFile   <- "./data/exdata-data-NEI_data/Source_Classification_Code.rds"
fileUrl     <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

if(!file.exists(summaryFile) && !file.exists(classFile)){
        # create a temporary directory and placeholder file
        td <- tempdir()
        tf <- tempfile(tmpdir=td, fileext=".zip")

        # download into the placeholder file and unzip into the local data directory
        download.file(fileUrl, tf, method="curl")
        dateDownloaded <- date()
        if(!file.exists("data")){dir.create("data")}
        unzip(tf, exdir = "./data", overwrite=TRUE)
}

NEI <- readRDS("./data/exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("./data/exdata-data-NEI_data/Source_Classification_Code.rds")

# Compare emissions from motor vehicle sources in Baltimore City with emissions from motor
# vehicle sources in Los Angeles County, California (fips == "06037"). Which city has seen
# greater changes over time in motor vehicle emissions?
cities <- NEI[NEI$fips %in% c("24510", "06037"),]

# Find the SCC codes that intersect emission category(mobile) and industry(vehicle)
vehicleRelatedRows <- intersect(grep("Mobile", SCC$SCC.Level.One), grep("Vehicle",SCC$SCC.Level.Two))
keys <- SCC[vehicleRelatedRows, "SCC"]
vehicles <- cities[cities$SCC %in% keys, ]

png("plot6.png")
ggplot(cities, aes(year, Emissions)) +
        geom_point(alpha=0.5, color="steelblue") +
        geom_smooth(method="lm") +
        facet_wrap(~ fips) +
        labs(title="PM Emissions from Motor Vehicle Sources in \n Los Angeles County(06037) and Baltimore City(24510)") +
        labs(y=expression('Tons of emitted PM'[2.5])) +
        scale_x_continuous(breaks = c(1999,2002,2005,2008))
dev.off()