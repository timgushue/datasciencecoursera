## This function reads the outcome-of-care-measures.csv ﬁle and returns a 
## character vector with the name of the hospital that has the ranking 
## speciﬁed by the num argument

rankhospital <- function(state, outcome, num = "best") {
        ## Read outcome data
        raw.data <- read.csv("data/outcome-of-care-measures.csv", colClasses = "character")
        pruned.data <- raw.data[,c(2, 7, 11, 17, 23)]
        names(pruned.data)[c(1, 2, 3, 4, 5)] <- c("hospital", "state", "heart attack", "heart failure", "pneumonia")

        ## Check that state and outcome are valid
        clean.state <- toupper(state)
        outcome <- tolower(outcome)
        if (!(clean.state %in% state.abb)) stop("invalid state")
        if (!(outcome %in% names(pruned.data)[c(3, 4, 5)])) stop("invalid outcome")

        ## Sort rows by outcome data after removing missing entries
        state.data <- subset(pruned.data, pruned.data["state"] == clean.state)
        pruned.states <- subset(state.data, state.data[outcome] != "Not Available")
        pruned.states[outcome] <- sapply(pruned.states[outcome], as.numeric)
        ordered <- pruned.states[order(pruned.states[outcome], pruned.states["hospital"]),]

        ## Store results in a data frame (subset was causing column name problems)
        name <- as.vector(ordered[["hospital"]])
        rate <- as.vector(ordered[[outcome]])
        rank <- seq(dim(ordered)[1])
        result <- data.frame("Hospital Name"=name, "Rate"=rate, "Rank"=rank)

        ## Return hospital name in that state with the given rank 30-day death rate
        if (num == "best") return(as.vector(head(result,1)[[1]]))
        else if (num == "worst") return(as.vector(tail(result,1)[[1]]))
        else if (as.numeric(num) > length(rank)) return(as.vector(NA))
        else return(as.vector(result[num,1][1]))

}