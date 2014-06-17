## This function reads the outcome-of-care-measures.csv ﬁle and returns a 
## character vector with the name of the hospital that has the best 
## (i.e. lowest) 30-day mortality for the speciﬁed outcome in that state.

best <- function(state, outcome) {
## Read outcome data
raw.data <- read.csv("data/outcome-of-care-measures.csv", colClasses = "character")
sub.set <- raw.data[,c(2, 7, 11, 17, 23)]
names(sub.set)[c(1, 2, 3, 4, 5)] <- c("hospital", "state", "heart attack", "heart failure", "pneumonia")

## Check that state and outcome are valid

## Return hospital name in that state with lowest 30-day death rate
}
