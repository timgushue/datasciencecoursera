

-------- Study Design --------------------

The data consumed by this script was collected from the accelerometers from the
Samsung Galaxy S smartphone. A full description taken from the site where the
data was obtained:
  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
is as follows:

  "The experiments have been carried out with a group of 30 volunteers within
  an age bracket of 19-48 years. Each person performed six activities (WALKING,
  WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a 
  smartphone (Samsung Galaxy S II) on the waist. Using its embedded 
  accelerometer and gyroscope, we captured 3-axial linear acceleration and 
  3-axial angular velocity at a constant rate of 50Hz. The experiments have been
  video-recorded to label the data manually. The obtained dataset has been 
  randomly partitioned into two sets, where 70% of the volunteers was selected 
  for generating the training data and 30% the test data. 

  The sensor signals (accelerometer and gyroscope) were pre-processed by 
  applying noise filters and then sampled in fixed-width sliding windows of 2.56
  sec and 50% overlap (128 readings/window). The sensor acceleration signal, 
  which has gravitational and body motion components, was separated using a 
  Butterworth low-pass filter into body acceleration and gravity. The 
  gravitational force is assumed to have only low frequency components, 
  therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a
  vector of features was obtained by calculating variables from the time and 
  frequency domain."

The raw data for the project can be downloaded at: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The run_analysis.R script consumes the above file and does the following:
  1. Merges the training and the test sets to create one data set.
  2. Extracts only the measurements on the mean and standard deviation for each 
     measurement. 
  3. Uses the text to label the activities in the data set
  4. Appropriately labels the data set with descriptive variable names, with 
     details given in CodeBook.md
  5. Produces an independent tidy data set with the average of each variable for
     each activity and each subject. 

Only measurements of the mean and standard deviations in the time or frequency 
experiments were kept.


-------- Code Book --------------------

A description for each variable can be found in the accompaning file: CodeBook.md

-------- Instructions --------------------

- Running the script
To generate a tidy data set, run_analysis.R can be executed from the R 
command-line interpreter:
  > source("run_analysis.R")
or launched directly from the bash (or a bash like) shell:
  $ R CMD BATCH run_analysis.R

- Raw Data
The script looks for data locally in a file named "UCI HAR Dataset" otherwise it
will attempt to download it to the local directory from:
  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
The files necessary to run_analysis.R are:
  UCI HAR Dataset/activity_labels.txt
  UCI HAR Dataset/features.txt
  UCI HAR Dataset/test/X_test.txt
  UCI HAR Dataset/test/y_test.txt
  UCI HAR Dataset/test/subject_test.txt
  UCI HAR Dataset/train/X_train.txt
  UCI HAR Dataset/train/y_train.txt
  UCI HAR Dataset/train/subject_train.txt

- Processing steps
The UCI HAR Dataset/test/X_test.txt and UCI HAR Dataset/train/X_train.txt are 
joined together.  The UCI HAR Dataset/test/y_test.txt and 
UCI HAR Dataset/train/y_train.txt are also joined and then merged together with 
the joined x data into a data table. The file features.txt is used as the column
labels and all coulmns are filtered out that don't show the mean or std.  The 
subjects_test.txt files from test and train folders are joined and merged in as 
the "Subjects" column.  The activity_labels.txt is used to substitute the 
activity name for it's code and it is merged into the data frame.  Finally all 
the labels are cleaned to make them more human readable and easily processed by 
the script.

-Tidy Data
For each of the six activities, the average was calculated for each variable for
each subject.  The six resulting data tables were combined into a final tidy 
data set with each row coresponding to one distinct activity, subject and (mean 
of an) experiment.  The data table is sorted by subject, then activity and 
finally outputed using write.table to the local directory as tidy.txt.
