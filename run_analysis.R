#Getting and Cleaning Data Course Project

library(plyr)
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" 
download.file(fileUrl, destfile = "./data/projectfiles.zip", method ="curl")
unzip("./data/20Dataset.zip")
unzip("./data/projectfiles.zip")
list.files(".")
list.files("./UCI HAR Dataset")
list.files("./UCI HAR Dataset/test")
list.files("./UCI HAR Dataset/train")

# Step 1

# Merges the training and the test sets to create one data set

##############################################################################
## read Train set
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
## read Test set
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

## Marge Train data and Test data

x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)
colnames(x_data)        = features[,2]
colnames(y_data)        = "activityId"

###############################################################################

# Step 2
# Extracts only the measurements on the mean and standard deviation for each measurement
features <- read.table("./UCI HAR Dataset/features.txt")

# select only columns with "mean" or "std" in their names
mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])

# subset the desired columns
x_data <- x_data[, mean_and_std_features]
names(x_data) <- features[mean_and_std_features, 2]


###############################################################################


# Step 3
# Uses descriptive activity names to name the activities in the data set

activities <- read.table("./UCI HAR Dataset/activity_labels.txt")

# update values with correct activity names
y_data[, 1] <- activities[y_data[, 1], 2]

# set column name
names(y_data) <- "activity"

###############################################################################


# Step 4

# Appropriately label the data set with descriptive variable names
# correct column name

names(subject_data) <- "subject"

# bind all the data in a single data set

all_data <- cbind(x_data, y_data, subject_data)

###############################################################################


# Step 5
# Create a second, independent tidy data set with the average of each variable
# for each activity and each subject

averages_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(averages_data, "averages_data.txt", row.name=FALSE)

