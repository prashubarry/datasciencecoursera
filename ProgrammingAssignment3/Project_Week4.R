# 1.Merges the training and the test sets to create one data set.
# 2.Extracts only the measurements on the mean and standard deviation for each measurement.
# 3.Uses descriptive activity names to name the activities in the data set
# 4.Appropriately labels the data set with descriptive variable names.
# 5.From the data set in step 4, creates a second, 
# independent tidy data set with the average of each variable for each activity and each subject.

# Collect the data
packages <- c("data.table","reshape2")
#sapply(packages, require, character.only = TRUE, quietly= TRUE)
#path <- getwd()
#url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#download.file(url, file.path(path, "data_files.zip"))
#unzip(zipfile = "data_files.zip")

# Load the activity lables+features
activityLabels <- fread(file.path(path,"UCI HAR Dataset/activity_labels.txt"), col.names = c("classLabels", "activityName"))
features <- fread(file.path(path,"UCI HAR Dataset/features.txt"),col.names = c("index","featureNames"))

#The below provides the index of featureNames containing the mean or std name
featuresWanted <- grep("(mean|std)\\(\\)",features[,featureNames])
#Combine the features wanted and the featureNames and assign to the measurements variable
measurements <- features[featuresWanted, featureNames]
#Remove the () sign from the measurement data table
measurements <- gsub('[()]','',measurements)

# Load the training data sets
train <- fread(file.path(path,"UCI HAR Dataset/train/X_train.txt"))[,featuresWanted, with = FALSE]
data.table::setnames(train, colnames(train), measurements)
trainActivites <- fread(file.path(path, 'UCI HAR Dataset/train/y_train.txt'), col.names = c("Activity"))
trainSubjects <- fread(file.path(path,  'UCI HAR Dataset/train/subject_train.txt'),col.names = c("SubjectNum"))
train <- cbind(trainSubjects, trainActivites, train)

#Load the test datasets
test <- fread(file.path(path,"UCI HAR Dataset/test/X_test.txt"))[,featuresWanted, with = FALSE]
data.table::setnames(test, colnames(test), measurements)
testActivites <- fread(file.path(path, 'UCI HAR Dataset/test/y_test.txt'), col.names = c("Activity"))
testSubjects <- fread(file.path(path,  'UCI HAR Dataset/test/subject_test.txt'),col.names = c("SubjectNum"))
test <- cbind(testSubjects, testActivites, test)

#Merge Datasets
combined_datsets <- rbind(train, test)

# Convert class label to ActivityName as shown below
combined_datsets[["Activity"]] <- factor(combined_datsets[,Activity]
                                         , levels = activityLabels[["classLabels"]],
                                         , labels = activityLabels[["activityName"]])

combined_datsets[['SubjectNum']] <- as.factor(combined_datsets[,SubjectNum])

combined_datsets <- reshape2::melt(data = combined_datsets, id = c("SubjectNum", "Activity"))
combined_datsets <- reshape2::dcast(data = combined_datsets, SubjectNum + Activity ~ variable, fun.aggregate = mean)
data.table::fwrite(x= combined_datsets, file = "tidyData.txt", quote = FALSE)