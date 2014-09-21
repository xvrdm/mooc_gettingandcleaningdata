library(reshape2)

download.file(
	"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
	"galaxyS.zip",
	method="wget"
	)

unzip("galaxyS.zip", exdir="galaxySdata")
setwd("galaxySdata/UCI HAR Dataset/")

# Function to load data and merge it with labels. Can be used both with test/train
create_full_set <- function(x_txt, y_txt, subject_txt, features_txt, activity_txt) {
	# Loading x data file
	# & label columns with the names from the features file
	x_set <- read.table(x_txt)
	col_names <- read.table(features_txt, sep="")[,2]
	names(x_set) <- col_names
	
	# Filter the data to keep only cols related to "std" or "mean"
	# Goal 2 - Extracts only the measurements on the mean and standard deviation for each measurement. 
	col_filter <- grepl("std|mean", names(x_set))
	x_set <- x_set[,col_filter]
	
	#  Loading y data file and adding a label column from activity_txt
	# Goal 3 - Uses descriptive activity names to name the activities in the data set
	y_set <- read.table(y_txt)
	names(y_set) <- c("activity.Index")
	activity_labels <- read.table(activity_txt)
	y_set$activity.Label <- activity_labels[y_set$activity.Index,2]
	
	# Loading subject data file 
	subject_set <- read.table(subject_txt)
	names(subject_set) = "subject"
	
	# Return one single dataset with all 3 sets combined
	cbind(subject_set, y_set, x_set)
}

# Create the full test subjects set
test_set <- create_full_set("test/X_test.txt",
		       "test/y_test.txt",
		       "test/subject_test.txt",
		       "features.txt","activity_labels.txt")

# Create the full train subjects set
train_set <- create_full_set("train/X_train.txt",
		   	"train/y_train.txt",
		   	"train/subject_train.txt",
		 	"features.txt","activity_labels.txt")

# Put test and train subjects in one table
# Goal 1 - Merges the training and the test sets to create one data set.
study_set <- rbind(test_set, train_set)

study_melt <- melt(study_set, id.vars=c("subject","activity.Label"),
		   measure.vars=names(study_set)[-(1:3)])

study_means <- dcast(study_melt, subject + activity.Label ~ variable, mean)

# Goal 5 - a second, independent tidy data set 
# with the average of each variable for each activity and each subject.
write.table(study_means, "study_means.txt", row.names=FALSE)


