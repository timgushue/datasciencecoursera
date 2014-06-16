## 'directory' is a character vector of length 1 indicating
## the location of the CSV files

## 'threshold' is a numeric vector of length 1 indicating the
## number of completely observed observations (on all
## variables) required to compute the correlation between
## nitrate and sulfate; the default is 0

## Return a numeric vector of correlations
corr <- function(directory = "specdata", threshold = 150) {
        files_list <- list.files(directory, pattern = ".csv", full.names = TRUE)
        n <- length(files_list)
        raw.data <- data.frame()
        result <-vector("numeric")
        for (i in 1:n) 
        {
                raw.data <- read.csv(files_list[i])
                complete <- raw.data[complete.cases(raw.data),]
                sumComplete <- nrow(complete)
                if (sumComplete > threshold) 
                {
                        current.result  <- cor(complete["sulfate"], complete["nitrate"])
                        result <- c(result, current.result)
                }
        }
        result
}
