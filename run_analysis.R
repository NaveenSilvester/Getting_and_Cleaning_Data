setwd("C:/SSNAVE/FY15/Coursera/DataScience/GettingAndCleaningData/Assignment/Dataset")

library(plyr)
activity_labels <- read.table("activity_labels.txt")
features <- read.table("features.txt")
features_info <- readLines("features_info.txt")
X_train <- read.table("./train/X_train.txt")
Y_train <- read.table("./train/y_train.txt")
Subject_train <- read.table("./train/subject_train.txt")
X_test <- read.table("./test/X_test.txt")
Y_test <- read.table("./test/y_test.txt")
Subject_test <- read.table("./test/subject_test.txt")
OneDataSet <- rbind(X_train, X_test)
write.table(OneDataSet, file="OneDataSet.txt", sep="\t", row.names=FALSE)
feature_labels <- as.character(features[,2])
mean_std_cols <- grep("mean\\(|std\\(", feature_labels, value=TRUE)
OneDataSetWithHeader <- OneDataSet
colnames(OneDataSetWithHeader) <- feature_labels
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

write.table(MeanStdData, "MeanStdData.txt", sep="\t", row.names=FALSE)
write.table(OneDataSetWithHeader, "OneDataSetWithHeader.txt", sep="\t", row.names=FALSE)




ActivityCodes <- rbind(Y_train, Y_test)
ActivityCodedAddedMeanStdData <- cbind(ActivityCodes, MeanStdData)
colnames(ActivityCodedAddedMeanStdData) <- c("ActivityCode", mean_std_cols)
colnames(activity_labels) <- c("ActivityCode","Activity")

SubjectCode <- rbind(Subject_train,Subject_test)
TotalData <- cbind(SubjectCode,ActivityCodedAddedMeanStdData)
colnames(TotalData) <- c("SubjectCode","ActivityCode", mean_std_cols)

plyr1 <- join(TotalData, activity_labels, by = "ActivityCode")
plyr1 <- cbind(plyr1[,1], plyr1[,69], plyr1[,2:68])
colnames(plyr1) <- c("SubjectCode", "Activity", "ActivityCode", mean_std_cols)

aro <- colnames(plyr1)

#plyr1Melt <- melt(plyr1, id = c("SubjectCode", "Activity"), measure.vars=c("tBodyAcc-mean()-X"))
plyr1Melt <- melt(plyr1, id = c("SubjectCode", "Activity"), measure.vars=mean_std_cols)
TidyDataSet <- dcast(plyr1Melt, SubjectCode + Activity ~ variable, mean)

ddply(plyr1, c("SubjectCode","Activity"), function(plyr1)mean(plyr1[,c("tBodyAcc-mean()-X")]))
