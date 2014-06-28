## This function reads the outcome-of-care-measures.csv ﬁle and returns a 
## 2-column data frame containing the hospital in each state that has the
## ranking speciﬁed in num.

rankall <- function(outcome, num = "best") {
        ## Read outcome data
        raw.data <- read.csv("data/outcome-of-care-measures.csv", colClasses = "character")
        pruned.data <- raw.data[,c(2, 7, 11, 17, 23)]
        names(pruned.data)[c(1, 2, 3, 4, 5)] <- c("hospital", "state", "heart attack", "heart failure", "pneumonia")

        ## Check that the outcome is valid
        outcome <- tolower(outcome)
        if (!(outcome %in% names(pruned.data)[c(3, 4, 5)])) stop("invalid outcome")

        ## For each state, find the hospital of the given rank
        keeps <- c("hospital", "state", outcome)
        pruned.data <- pruned.data[keeps]
        cleaned <- subset(pruned.data, pruned.data[outcome] != "Not Available")
        cleaned[outcome] <- sapply(cleaned[outcome], as.numeric)
        ordered <- cleaned[order(cleaned[outcome], cleaned["hospital"]),]
        sorted <- split(ordered, ordered$state)

        ## Return a data frame with the hospital names and the (abbreviated) state name
        result <- data.frame()
        for (i in 1:length(sorted)) {
                current <- sorted[[i]]
                current <- current[c("hospital", "state")]
                rows <- nrow(current)
                if (num == "best")               result <- rbind(result, current[1,])
                else if (num == "worst")         result <- rbind(result, current[rows,])
                else if (as.numeric(num) > rows) result <- rbind(result, data.frame("hospital"=NA, "state"=current$state[1]))
                else                             result <- rbind(result, current[num,])
        }
        row.names(result) <- result$state
        return(result)
}