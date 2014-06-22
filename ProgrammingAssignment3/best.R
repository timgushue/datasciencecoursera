## This function reads the outcome-of-care-measures.csv ﬁle and returns a 
## character vector with the name of the hospital that has the best 
## (i.e. lowest) 30-day mortality for the speciﬁed outcome in that state.

best <- function(state, outcome) {
        ## Read outcome data
        raw.data <- read.csv("data/outcome-of-care-measures.csv", colClasses = "character")
        pruned.data <- raw.data[,c(2, 7, 11, 17, 23)]
        names(pruned.data)[c(1, 2, 3, 4, 5)] <- c("hospital", "state", "heart attack", "heart failure", "pneumonia")

        ## Check that state and outcome are valid
        clean.state <- toupper(state)
        outcome <- tolower(outcome)
        if (!(clean.state %in% state.abb)) stop("invalid state")
        if (!(outcome %in% names(pruned.data)[c(3, 4, 5)])) stop("invalid outcome")

        ## Return hospital name in that state with lowest 30-day death rate
        state.data <- subset(pruned.data, pruned.data["state"] == clean.state)
        pruned.states <- subset(state.data, state.data[outcome] != "Not Available")
        min.value <- min(sapply(pruned.states[outcome],as.numeric))
        pos.values <- sapply(pruned.states[outcome], as.numeric)
        min.matrix <- pos.values <= min.value
        result <- subset(pruned.states, min.matrix)
        return(result["hospital"][[1]])
}
