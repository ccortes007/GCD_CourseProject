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
#resActivity <- res %>% group_by(Activity) %>% summarise_each(funs(mean))
#write.table(resActivity, file = "resActivity.txt", row.names = FALSE)
#resSubject  <- res %>% group_by(Subject)  %>% summarise_each(funs(mean))
#write.table(resSubject,  file = "resSubject.txt",  row.names = FALSE)

# Getting the second tidy dataset applying the mean to all values grouped by Activity and Subject
resActSub   <- res %>% group_by(Activity, Subject) %>% summarise_each(funs(mean))
# Eliminating from the output the Stage column that make no sense for this dataset
resActSub   <- select(resActSub, -Stage)
write.table(resActSub, file = "resActSub.txt", row.names = FALSE)
