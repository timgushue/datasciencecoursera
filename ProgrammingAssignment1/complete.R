## 'directory' is a character vector of length 1 indicating
## the location of the CSV files

## 'id' is an integer vector indicating the monitor ID numbers
## to be used

## where 'id' is the monitor ID number and 'nobs' is the
## number of complete cases

complete <- function(directory, id = 1:332) {
        filenames <- list.files(directory, pattern="*.csv", full.names=TRUE)
        data.matrix <- sapply(filenames, read.csv)
        nitrates <- lapply(lapply(data.matrix["nitrate",], function(x) complete.cases(x)), sum)
        sulfates <- lapply(lapply(data.matrix["sulfate",], function(x) complete.cases(x)), sum)

        data <- data.frame(unlist(nitrates),unlist(sulfates))
        minimum <- ifelse(data[,1] < data[,2], data[,1], data[,2])
        order <- seq(length(minimum))

        observation <- minimum[id]
        identifier <- order[id]
        data.frame(id=identifier, nobs=observation)
}