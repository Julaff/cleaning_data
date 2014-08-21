Getting and Cleaning Data - Course Project
==========================================
Preparing tidy data from smartphones accelerometers measurements
----------------------------------------------------------------
The data comes from an experiment carried out with a group of 30 volunteers wearing a smartphone on which measurements have been taken from it's accelerometer while the subjects were performing specific activities.  
The full description is available in the `README.txt` file inside the `UCI HAR Dataset` folder.
***
### Description of the run_analysis.R script
The goal of this script is to build tidy data out of a set of raw data, following the five steps presented in the assignment :

#### Step 1 - Merging the training and the test data sets to create one data set
First of all, the train and test datasets are read into R with the `read.table` function.  
Both train and test datasets consist of three files :

* The file describing which one of the 30 volunteers (subjects) was used in each measurement.
* The file describing y, the activity that was being done by the volunteer in each of the measurements
* The file describing X, the set of the 561 variables measured, in each of the measurements performed on the volunteers

This total of 6 files is merged into one big file in such way : `subject`, `y`, and `X` are binded by colums for each of the train and test datasets.  
Then the 2 resulting files are binded by rows to create the big `fullData` dataset.

#### Step 2 - Extracting only the measurements on the mean and standard deviation for each measurement
To know which variables correspond to these measurements, we need to read the `features.txt` file into R.

As the assignment isn't 100% clear about that, I assumed that the required variables were only those ending either with `mean()` or with `std()`. For that I used the `grep` function on the second row of the features file.

Then, I removed from the full dataset the columns that didn't contain `mean()` or `std()` in their name. I put the result in a new dataset, called `extractedData`.

#### Step 3 - Using descriptive activity names to name the activities in the data set
To give the actual name of the activity in the dataset, instead of a non-explicit integer, I read the `activity_labels.txt` file into R.  
For each integer of the column decribing the activity (the second of the dataset), i applied the name corresponding to that integer inside of the `activity_labels` file.

#### Step 4 - Appropriately labelling the data set with descriptive variable names
The first two columns describing the activity and the subject are named manually.  
I then applied the name of each feature as column names in the data set. To do so, I applied the name from the features file corresponding to the indices used in step 2.

#### Step 5 - Creating a second, independent tidy data set with the average of each variable for each activity and each subject
First we calculate the dimension of the tidy data set. It has as many columns as `extractedData`. The number of rows is the number of subjects multiplied by the number of possible activities. The columns will have the same name as the `extractedData` dataset.

Then, for each subject and for each activity, we apply on each column, with the `colMeans` function, the average of each measurement of the `extractedData` dataset, corresponding to both the subject and the activity.

Finally, once the tidy dataset is built, we write it in a file, with the `write.table` function.
