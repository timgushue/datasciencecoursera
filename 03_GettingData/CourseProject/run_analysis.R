# run_analysis.R does the following:
# - Merges the training and the test sets to create one data set.
# - Extracts only the measurements on the mean and standard deviation for each measurement. 
# - Uses descriptive activity names to name the activities in the data set
# - Appropriately labels the data set with descriptive variable names. 
# - Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(data.table)
library(reshape2)



# ============================== Load the raw data set ========================================

localFile <- "./UCI\ HAR\ Dataset"
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if(!file.exists(localFile)){
        # create a temporary directory and placeholder file
        td <- tempdir()
        tf <- tempfile(tmpdir=td, fileext=".zip")

        # download into the placeholder file and unzip into the local directory
        download.file(fileUrl, tf, method="curl")
        dateDownloaded <- date()
        unzip(tf, overwrite=TRUE)
}




# ========== Process the raw data into a single a single intermediate data table ==============

# Append x_train to x_test
xTest  <- read.table(paste(localFile, "test", "X_test.txt", sep="/"))
xTrain <- read.table(paste(localFile, "train", "X_train.txt", sep="/"))
xFull  <- rbind(xTest, xTrain)


# Apply the feature labels and prune columns without mean of std using regex
features     <- read.table(paste(localFile, "features.txt", sep="/"))
names(xFull) <- features$V2

pruneFreq   <- grep("(?=Freq)", names(xFull), perl=TRUE, invert=TRUE, value=TRUE)
xFull       <- xFull[ , pruneFreq]
keepMeanStd <- grep("(?=mean)|(?=std)", names(xFull), perl=TRUE, value=TRUE)
xFull       <- xFull[ , keepMeanStd]


# Append y_train to y_test 
yTest  <- read.table(paste(localFile, "test", "y_test.txt", sep="/"))
yTrain <- read.table(paste(localFile, "train", "y_train.txt", sep="/"))
yFull  <- rbind(yTest, yTrain)

# replace the activity code with it's label by pattern matching and add it as a column
activity <- read.table(paste(localFile, "activity_labels.txt", sep="/"))
yLabels  <- as.character(yFull$V1)

for(i in 1:length(activity$V1)) {
        pattern    <- as.character(activity$V1[i])
        replacment <- as.character(activity$V2[[i]])
        yLabels    <- gsub(pattern, replacment, yLabels)
}
labeledActivity <- data.table(Activity=yLabels)
xFullActivity   <- cbind(labeledActivity, xFull)


# Add the subjects column
subjectTest           <- read.table(paste(localFile, "test", "subject_test.txt", sep="/"))
subjectTrain          <- read.table(paste(localFile, "train", "subject_train.txt", sep="/"))
joinedSubjects        <- rbind(subjectTest, subjectTrain)
names(joinedSubjects) <- c("Subject")

processedData <- cbind(joinedSubjects, xFullActivity)

# Do a little cleanup of them with gsub(). 
# Remove characters in the names that cause problems in R
# Seperate words with periods
# Expand abbreviated labels to their full text
# Fix the "BodyBody" double naming error

colNames <- names(processedData)
colNames <- gsub("BodyBody", "Body", colNames)
colNames <- gsub("^t", "Time.", colNames)
colNames <- gsub("^f", "Frequency.", colNames)
colNames <- gsub("[()]", "" , colNames)
colNames <- gsub("[-]", "" , colNames)
colNames <- gsub("Acc", "Acceleration." , colNames)
colNames <- gsub("Mag", "Magnitude." , colNames)
colNames <- gsub("Body", "Body." , colNames)
colNames <- gsub("Gravity", "Gravity." , colNames)
colNames <- gsub("Gyro", "Gyroscope." , colNames)
colNames <- gsub("Jerk", "Jerk." , colNames)
colNames <- gsub("X", ".X" , colNames)
colNames <- gsub("Y", ".Y" , colNames)
colNames <- gsub("Z", ".Z" , colNames)

names(processedData) <- colNames


# ============= Tidy the data table into 1 observation per row ==============

dataMelt <- melt(processedData, id = c(1,2), measure.vars = c(3:68))

# For each of the 6 activities, calculate the mean of each variable for each subject
standingMelt <- subset(dataMelt, Activity=="STANDING")
standingMean <- dcast(standingMelt, Subject ~ variable, mean)
standing <- cbind(Activity=c("STANDING"), standingMean)

sittingMelt <- subset(dataMelt, Activity=="SITTING")
sittingMean <- dcast(sittingMelt, Subject ~ variable, mean)
sitting <- cbind(Activity=c("SITTING"), sittingMean)

layingMelt <- subset(dataMelt, Activity=="LAYING")
layingMean <- dcast(layingMelt, Subject ~ variable, mean)
laying <- cbind(Activity=c("LAYING"), layingMean)

walkingMelt <- subset(dataMelt, Activity=="WALKING")
walkingMean <- dcast(walkingMelt, Subject ~ variable, mean)
walking <- cbind(Activity=c("WALKING"), walkingMean)

walkingDownstairsMelt <- subset(dataMelt, Activity=="WALKING_DOWNSTAIRS")
walkingDownstairsMean <- dcast(walkingDownstairsMelt, Subject ~ variable, mean)
walkingDownstairs <- cbind(Activity=c("WALKING_DOWNSTAIRS"), walkingDownstairsMean)

walkingUpstairsMelt <- subset(dataMelt, Activity=="WALKING_UPSTAIRS")
walkingUpstairsMean <- dcast(walkingUpstairsMelt, Subject ~ variable, mean)
walkingUpstairs <- cbind(Activity=c("WALKING_UPSTAIRS"), walkingUpstairsMean)

# Combine each activity data table and sort by subject and activity
tidy <- rbind(standing, sitting, laying, walking, walkingDownstairs, walkingUpstairs)
tidy <- tidy[c(2,1,3:68)]
tidy <- tidy[order(tidy$Subject, tidy$Activity), ]

# Update names to indicate column is the mean of it's value
colNames <- names(tidy)
colNames <- gsub("^Time", "Mean.Of.Time", colNames)
colNames <- gsub("^Frequency", "Mean.Of.Frequency", colNames)
names(tidy) <- colNames

write.table(tidy, "tidy.txt", sep="\t", row.names = FALSE)

