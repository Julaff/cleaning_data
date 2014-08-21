# Reading the train and test datasets
XTrain <- read.table("UCI HAR Dataset/train/X_train.txt")
yTrain <- read.table("UCI HAR Dataset/train/y_train.txt")
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")

XTest <- read.table("UCI HAR Dataset/test/X_test.txt")
yTest <- read.table("UCI HAR Dataset/test/y_test.txt")
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt")

# Binding the 3 train sets by column
trainData <- cbind(subjectTrain, yTrain, XTrain)
# Binding the 3 test sets by column
testData <- cbind(subjectTest, yTest, XTest)

# Binding the big train and test datasets by row to create a unique dataset
fullData <- rbind(trainData, testData)

# Reading the features dataset
features <- read.table("UCI HAR Dataset/features.txt")

# Getting the indices of the measurements on the mean and on the
# standard deviation for each measurement (double backslash \\ before a parenthisis to select it as a string)
meanIndices <- grep("mean\\(\\)", features[,2])
stdIndices <- grep("std\\(\\)", features[,2])
extractedIndices <- sort(c(meanIndices,stdIndices))
# The new dataset will not contain the removed columns
# The deletion starts after the 2 columns describing the subject and the activity
removedColumns <- features[-extractedIndices,1] + 2
extractedData <- fullData[,-removedColumns]

# Replacing the numeric values of the activities by their label
# which is written in the activity_labels file
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
extractedData[,2] <- activityLabels[extractedData[,2],2]

# The first two columns are the activity and subject variables
colnames(extractedData)[1] <- "Subject"
colnames(extractedData)[2] <- "Activity"
# The names of each column is taken from the features dataset
colnames(extractedData)[3:ncol(extractedData)] <- as.character(features[extractedIndices,2])

# To create the tidy dataset, we first prepare an empty dataframe of the correct dimension
# The number of columns is the same as extratedData
# The number of rows is the number of subjects multiplied by the number of possible activities (30*6 = 180)
tidyData <- data.frame(matrix(nrow = length(unique(extractedData$Subject))*length(unique(extractedData$Activity)),ncol = ncol(extractedData)))
# The columns will have the same name as the extratedData dataset
colnames(tidyData) <- colnames(extractedData)

# We will know iterate the colMeans function for each subject and each activity
# We fill successively fill the lines of the dataset with the average of each column of extractedData corresponding to both the subject and the activity
l <- 1
for(s in sort(unique(extractedData$Subject))){
  for(a in sort(unique(extractedData$Activity))){
    tidyData[l,1] <- s
    tidyData[l,2] <- a
    tidyData[l,3:ncol(tidyData)] <- colMeans(extractedData[extractedData$Subject == s & extractedData$Activity == a, 3:ncol(extractedData)])
    l <- l + 1
  }
}

# Finally we export the tidy data into a text file
write.table(tidyData,"tidy_data.txt",row.name=FALSE)
