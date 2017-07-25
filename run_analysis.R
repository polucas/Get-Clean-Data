getwd()
#Read train set data (downlaod and stored on local drive)
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
#Read test set data
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)
#Read features and activity labels
features <- read.table("./UCI HAR Dataset/features.txt", header = FALSE)
activities <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE)
#Isolate the vector with feature names
dim(features)
summary(features)
features <- features[,2]
# 1 Bind test and train data together
datax <- rbind(x_train, x_test)
activity <- rbind(y_train, y_test)      
subject <- rbind(subject_train, subject_test)
# 1 Add corresponding column names to the 3 merged data
names(datax) <- features
names(activity) <- c("activity")
names(subject) <- c("subject")
# 1 Merge the whole data 
all_data1 <- cbind(activity, subject)
all_data <- cbind(datax, all_data1)
dim(all_data)


# 2 Find names (columns) with 'mean' and 'std' parameters
subsetNames <- features[grep("mean\\(\\)|std\\(\\)", features)]
# 2 Extract (subset) the desired columns from the whole data set
desiredNames <- c(as.character(subsetNames), "activity", "subject")
str(desiredNames)
data <- subset(all_data, select=desiredNames)
dim(data)
str(data)


# 3 Label each activity with its corresponding label 
summary(activities)
data$activity <- factor(data$activity, labels=activities[,2])
head(data)

# 4 Label the data set with descriptive variable names
# change Acc for Accelerator and Gyro for Gyroscope
names(data) <- gsub("Acc", "Accelerator", names(data))
names(data) <- gsub("Gyro", "Gyroscope", names(data))
# change BodyBody for Body and Mag for Magnitued
names(data) <- gsub("BodyBody", "Body", names(data))
names(data) <- gsub("Mag", "Magnitude", names(data))
# change t for Time and f for Frequency
names(data) <- gsub("^f", "Frequency", names(data))
names(data) <-gsub("^t", "Time", names(data))
names(data)

# 5 Create a new tidy data set with the average of each
# variable for each activity and each subject
tidydata <- aggregate(. ~subject+activity, data, mean)
names(tidydata)      
write.table(tidydata, "tidy_set.txt", row.names=FALSE)





