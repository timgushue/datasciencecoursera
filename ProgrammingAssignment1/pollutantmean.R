## 'directory' is a character vector of length 1 indicating
## the location of the CSV files

## 'pollutant' is a character vector of length 1 indicating
## the name of the pollutant for which we will calculate the
## mean; either "sulfate" or "nitrate".

## 'id' is an integer vector indicating the monitor ID numbers
## to be used

## Return the mean of the pollutant across all monitors list
## in the 'id' vector (ignoring NA values)
pollutantmean <- function(directory, pollutant, id = 1:332) {
        filenames <- list.files(directory, pattern="*.csv", full.names=TRUE)
        data.matrix <- sapply(filenames[id], read.csv)
        data.vector <- unlist(data.matrix[pollutant,])
        mean(data.vector, na.rm=T)
}