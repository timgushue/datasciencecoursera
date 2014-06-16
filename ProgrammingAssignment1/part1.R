
#Part1
pollutantmean <- function(directory, pollutant, id = 1:332) {
        filenames <- list.files(directory, pattern="*.csv", full.names=TRUE)
        data.matrix <- sapply(filenames[id], read.csv)
        data.vector <- unlist(data.matrix[pollutant,])
        mean(data.vector, na.rm=T)
}

complete <- function(directory, id = 1:332) {
        filenames <- list.files(directory, pattern="*.csv", full.names=TRUE)
        data.matrix <- sapply(filenames, read.csv)
        nitrates <- lapply(lapply(data.matrix["nitrate",], function(x) !is.na(x)), sum)
        sulfates <- lapply(lapply(data.matrix["sulfate",], function(x) !is.na(x)), sum)

        data <- data.frame(unlist(nitrates),unlist(sulfates))
        minimum <- ifelse(data[,1] < data[,2], data[,1], data[,2])
        order <- seq(length(minimum))

        observation <- minimum[id]
        identifier <- order[id]
        data.frame(id=identifier, nobs=observation)
}

corr <- function(directory = "specdata", threshold = 150) {
  
  files_list <- list.files(directory, pattern = ".csv", full.names = TRUE)
  n <- length(files_list)
  dat <- data.frame()
  dat1<-vector("numeric")
  for (i in 1:n) 
  {
    dat <- read.csv(files_list[i])
    complete <- dat[complete.cases(dat),]
    sumComplete <- nrow(complete)
    if (sumComplete > threshold) 
    {
      dat2  <- cor(complete["sulfate"], complete["nitrate"])
      dat1 <- c(dat1, dat2)
    }
  }
  return(dat1)
}






