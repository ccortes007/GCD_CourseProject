=================================
1) Description of the variables
=================================
Original Data
The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. (t=time) 
The acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) 
Body linear acceleration and gyroscope velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). 
The magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 
A Fast Fourier Transform (FFT) was applied to some of these signals producing frequencies: fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. 
(Note the 'f' to indicate frequency domain signals). 

To make the labels more descriptive and use them as R language column names:
a) The prefixes were changed:
   t = time
   f = freq 
b) The "(", ")" characters were eliminated from the labels
c) The "-"      character  was  replaced   by "_"

===========================
2) Description of the data
===========================
============
Input data:
============
a) "getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt"
   Containing 561 labels describing the columns of the measurement files
b) "getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt"
   Containing the 6 labels of activities measured by the study
c) "getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt"
   Containing a the ID of the persons subjects of the study in the training stage
d) "getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt"
   Containing a the ID of the activities the subjects were doing in the training stage
e) "getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt"
   Containing a the measurements of the activities the subjects were doing in the training stage
f) "getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt"
   Containing a the ID of the persons subjects of the study in the testing stage
g) "getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt"
   Containing a the ID of the activities the subjects were doing in the testing stage
h) "getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_train.txt"
   Containing a the measurements of the activities the subjects were doing in the testing stage
=============
Output data:
=============
a) "getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/resActSub.txt"
   Containing an independent tidy data set (from the data set in step 4) with the average of each variable for each activity and each subject
   This dataset contains the following columns:

Subject             num     ID of the person in the study
Stage               factor  1) "Testing" 2) "Training"  (** This column was eliminated only from the file since the mean didn't make sense 
                                                            since the grouping was requested by Subject and Activity **)
Activity            factor  1) "WALKING" 2) "WALKING_UPSTAIRS" 3) "WALKING_DOWNSTAIRS" 4) "SITTING" 5) "STANDING" 6) "LAYING"
                    The following are numeric measurements that follow the naming convention of the original data with the following changes
                    To make the labels more descriptive and use them as R language column names:
                    a) The prefixes were changed:
                       t = time
                       f = freq 
                    b) The "(", ")" characters were eliminated from the labels
                    c) The "-"      character  was  replaced   by "_"
					d) We get all the columns with "mean" and "std" in the label 
					e) We didn't get all the "meanFreq" or "angle" columns
timeBodyAcc_mean_X   
timeBodyAcc_mean_Y  
timeBodyAcc_mean_Z
timeBodyAcc_std_X
timeBodyAcc_std_Y
timeBodyAcc_std_Z   
timeGravityAcc_mean_X
timeGravityAcc_mean_Y
timeGravityAcc_mean_Z
timeGravityAcc_std_X
timeGravityAcc_std_Y
timeGravityAcc_std_Z
timeBodyAccJerk_mean_X
timeBodyAccJerk_mean_Y
timeBodyAccJerk_mean_Z
timeBodyAccJerk_std_X
timeBodyAccJerk_std_Y
timeBodyAccJerk_std_Z
timeBodyGyro_mean_X
timeBodyGyro_mean_Y
timeBodyGyro_mean_Z
timeBodyGyro_std_X
timeBodyGyro_std_Y
timeBodyGyro_std_Z
timeBodyGyroJerk_mean_X
timeBodyGyroJerk_mean_Y
timeBodyGyroJerk_mean_Z
timeBodyGyroJerk_std_X
timeBodyGyroJerk_std_Y
timeBodyGyroJerk_std_Z
timeBodyAccMag_mean
timeBodyAccMag_std
timeGravityAccMag_mean
timeGravityAccMag_std
timeBodyAccJerkMag_mean
timeBodyAccJerkMag_std
timeBodyGyroMag_mean
timeBodyGyroMag_std
timeBodyGyroJerkMag_mean
timeBodyGyroJerkMag_std
freqBodyAcc_mean_X
freqBodyAcc_mean_Y
freqBodyAcc_mean_Z
freqBodyAcc_std_X
freqBodyAcc_std_Y
freqBodyAcc_std_Z
freqBodyAccJerk_mean_X
freqBodyAccJerk_mean_Y
freqBodyAccJerk_mean_Z
freqBodyAccJerk_std_X
freqBodyAccJerk_std_Y
freqBodyAccJerk_std_Z
freqBodyGyro_mean_X
freqBodyGyro_mean_Y
freqBodyGyro_mean_Z
freqBodyGyro_std_X
freqBodyGyro_std_Y
freqBodyGyro_std_Z
freqBodyAccMag_mean
freqBodyAccMag_std
freqBodyAccJerkMag_mean
freqBodyAccJerkMag_std
freqBodyGyroMag_mean
freqBodyGyroMag_std
freqBodyGyroJerkMag_mean
freqBodyGyroJerkMag_std

# ===========================================================   
# 3) Transformations or work performed to clean up the data
# ===========================================================
# Notes: 
# a) The script ProjectGCD.R must be in the "[YourDirectoryOption]/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset" to work
# b) This is an example of what I used: setwd("C:/Cousera_GCD/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset") 
#
# Procedure: 
library(dplyr)
# Reading features.txt, select columns and fixing names 
features <- read.table("features.txt") %>%
                # Getting only the rows we need
                filter(grepl("mean|std", V2) & !grepl("meanFreq", V2)) %>%
                # Eliminating "(", ")" and changing "-" by "_"
                mutate(V2 = sub("\\-", "\\_" ,sub("\\-", "\\_", sub("\\)", "", sub("\\(", "", V2))))) %>%
                # Eliminating errors in names
                mutate(V2 = sub("fBodyBody", "fBody" ,V2)) %>%
                # Friendly names
                mutate(V2 = sub("tBody", "timeBody" ,V2)) %>%
                # Friendly names
                mutate(V2 = sub("fBody", "freqBody" ,V2)) %>%
                # Friendly names
                mutate(V2 = sub("tGravity", "timeGravity" ,V2))
GoodCols   <- features$V1
GoodCNames <- features$V2
# Creating the stages factor to add a column so we don't loose the Stage for the study.
stages <- factor(c(1,2), labels=c("Testing", "Training"))
# Reading activity_labels.txt
activities <- read.table("activity_labels.txt")
# Reading training files
#       Subjects
strain <- read.table("./train/subject_train.txt") %>%
                #Adding the Stage column 
                mutate(V2 = stages[2])
colnames(strain) <- c("Subject", "Stage")
#       Activities
ytrain <- read.table("./train/y_train.txt") %>%
                mutate(V1 = activities$V2[V1])
colnames(ytrain) <- "Activity"
#       Measurements
xtrain <- read.table("./train/X_train.txt") %>% select(GoodCols)
colnames(xtrain) <- GoodCNames
# Reading test files
#       Subjects
stest <- read.table("./test/subject_test.txt") %>%
                mutate(V2 = stages[1])
colnames(stest) <- c("Subject", "Stage")
#       Activities
ytest <- read.table("./test/y_test.txt") %>%
        mutate(V1 = activities$V2[V1])
colnames(ytest) <- "Activity"
#       Measurements
xtest  <- read.table("./test/X_test.txt") %>% select(GoodCols)
colnames(xtest) <- GoodCNames
# Joining training data frames by columns
resTrain <- cbind(strain, ytrain, xtrain)
# Joining test     data frames by columns
resTest  <- cbind(stest,  ytest,  xtest)
# Joining Training and test data to get the first tidy dataset
res      <- rbind(resTrain, resTest)
# Getting the second tidy dataset applying the mean to all values grouped by Activity and Subject
resActSub   <- res %>% group_by(Activity, Subject) %>% summarise_each(funs(mean))
# Eliminating from the output the Stage column that make no sense for this dataset
resActSub   <- select(resActSub, -Stage)
write.table(resActSub, file = "resActSub.txt", row.names = FALSE)
