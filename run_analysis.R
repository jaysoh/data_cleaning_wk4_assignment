#This R script does the following:
#1. Merges the training and the test sets to create one data set.
#2. Extracts only the measurements on the mean and standard deviation for each measurement.
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive variable names.
#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for 
#each activity and each subject.

#Read train data set and name columns
x_train <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/x_train.txt")
y_train <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt", col.names = "ActivityKey")
subject_train <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt", col.names = "Subject")

#Read test data set and name columns
x_test <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/x_test.txt")
y_test <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt", col.names = "ActivityKey")
subject_test <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt", col.names = "Subject")


#Label activity_labels columns
activity_labels <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")
names(activity_labels) <- c("ActivityKey", "Activity")


#combine x data in a single data frame
x <- rbind(x_test, x_train)
#Read features data set and rename columns for x
features <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt")
names(x)<- features$V2

#combine y data in a single data frame
y <- rbind(y_test, y_train)

#combine subject data in a single data frame
subject <- rbind(subject_test, subject_train)


#combine columns of all data
data <- cbind(x, subject, y)

#Extracts only the measurements on the mean and standard deviation for each measurement.
features.std.mean <- features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)]
selectedNames <- c(as.character(features.std.mean), "Subject", "ActivityKey" )
data <- subset(data,select=selectedNames)

#Uses descriptive activity names to name the activities in the data set
names(data)<-gsub("^t", "time", names(data))
names(data)<-gsub("^f", "frequency", names(data))
names(data)<-gsub("Acc", "Accelerometer", names(data))
names(data)<-gsub("Gyro", "Gyroscope", names(data))
names(data)<-gsub("Mag", "Magnitude", names(data))
names(data)<-gsub("BodyBody", "Body", names(data))

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for 
#each activity and each subject.
data2 <- aggregate(. ~Subject + ActivityKey, data, mean)
data2 <- data2[order(data2$Subject,data2$ActivityKey),]
write.table(data2, file = "tidydata.txt",row.name=FALSE)


