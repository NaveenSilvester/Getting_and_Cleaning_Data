##############################################################################################
## Name of the Script: run_analysis
## Author: Naveen Silvester
## Date: 21 May 2015
###############################################################################################

###############################################################################################
# Loading required Libraries
###############################################################################################
library(plyr)
library(reshape2)

###############################################################################################
# This section of the code reads the required data files provided for the project
# Files include: activity_labels.txt, features.txt, features_info.txt, feature_labels.txt
#				 X_train, y_train, X_test.txt, y_test.txt, subject_train.txt, subject_test.txt
###############################################################################################
activity_labels <- read.table("activity_labels.txt")
features <- read.table("features.txt")
features_info <- readLines("features_info.txt")
X_train <- read.table("./train/X_train.txt")
Y_train <- read.table("./train/y_train.txt")
Subject_train <- read.table("./train/subject_train.txt")
X_test <- read.table("./test/X_test.txt")
Y_test <- read.table("./test/y_test.txt")
Subject_test <- read.table("./test/subject_test.txt")

###############################################################################################
# This section of the code combines the Train and the Test set togther as OneDataSet
###############################################################################################
OneDataSet <- rbind(X_train, X_test)
# write.table(OneDataSet, file="OneDataSet.txt", sep="\t", row.names=FALSE)

###############################################################################################
# This section of the code genearates a vector containing the names of the variables which has
# mean or std in their variable name (Column headers)
###############################################################################################
feature_labels <- as.character(features[,2])
mean_std_cols <- grep("mean\\(|std\\(", feature_labels, value=TRUE)

###############################################################################################
# This section of the code adds the column headers to the OneDataSet and creates a new datafame
# named OneDataSetWithHeader
###############################################################################################
OneDataSetWithHeader <- OneDataSet
colnames(OneDataSetWithHeader) <- feature_labels

###############################################################################################
# This section of the code creates a data frame named "MeanStdData" where only those columns
# with the column name containing either mean or std is selected
###############################################################################################
MeanStdData <- data.frame(ncols=length(mean_std_cols))
for (i in 1:length(mean_std_cols))
{
	ColumnName <- mean_std_cols[i]
	print (i)
	print (ColumnName)
	ColumnData <- OneDataSetWithHeader[,ColumnName]
	MeanStdData <- cbind(MeanStdData,ColumnData)
}
MeanStdData <- MeanStdData[,-1]
colnames(MeanStdData) <- mean_std_cols
# write.table(MeanStdData, "MeanStdData.txt", sep="\t", row.names=FALSE)
# write.table(OneDataSetWithHeader, "OneDataSetWithHeader.txt", sep="\t", row.names=FALSE)


###############################################################################################
# This section of the code adds Activity Codes for the MeanStdData and creates a new dataframe
# named ActivityCodedAddedMeanStdData
###############################################################################################
ActivityCodes <- rbind(Y_train, Y_test)
ActivityCodedAddedMeanStdData <- cbind(ActivityCodes, MeanStdData)
colnames(ActivityCodedAddedMeanStdData) <- c("ActivityCode", mean_std_cols)
colnames(activity_labels) <- c("ActivityCode","Activity")

###############################################################################################
# This section of the code adds Subject Codes for the ActivityCodedAddedMeanStdData
#  and creates a new dataframe named TotalData
###############################################################################################
SubjectCode <- rbind(Subject_train,Subject_test)
TotalData <- cbind(SubjectCode,ActivityCodedAddedMeanStdData)
colnames(TotalData) <- c("SubjectCode","ActivityCode", mean_std_cols)

###############################################################################################
# This section of the code maps the Activity Code to its Activity Label
###############################################################################################
plyr1 <- join(TotalData, activity_labels, by = "ActivityCode")
plyr1 <- cbind(plyr1[,1], plyr1[,69], plyr1[,2:68])
colnames(plyr1) <- c("SubjectCode", "Activity", "ActivityCode", mean_std_cols)

###############################################################################################
# This section of the code Melts the data frame plyr1 based on SubjectCode and Activity as index
# for the mean and std cols to create a data frame named plyr1Melt. This plyr1Melt dataframe
# is then again dcasted as mean for all the std and mean variables based on SubjectCode and Activity
# to create the final Data frame named TidyDataSet
###############################################################################################
plyr1Melt <- melt(plyr1, id = c("SubjectCode", "Activity"), measure.vars=mean_std_cols)
TidyDataSet <- dcast(plyr1Melt, SubjectCode + Activity ~ variable, mean)
write.table(TidyDataSet, "TidyDataSet.txt", sep="\t", row.names=FALSE)
