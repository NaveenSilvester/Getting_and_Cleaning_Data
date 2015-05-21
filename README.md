# Getting_and_Cleaning_Data
Hello This is the Assignment Data for the Getting and Cleaning Data course in Coursera

# Here is the details (sequential order) on how the Code run_analysis.R works 

## Loading the required packages
* plyr
* reshape2

## Read all the data files pertaining to the project Assignment
* activity_labels.txt
* features.txt
* features_info.txt
* X_train.txt
* y_train.txt
* X_test.txt
* y_test.txt
* Subject_train.txt
* Subject_test.txt

## Combines the Train and the Test Datasets togehter to create a new data frame named 'OneDataSet'
* Data frame : OneDataSet

## Creation of a vector containing names of the columns containig either mean or std
* mean_std_cols (Name of the Vector)

## Add Column header to the combined dataset OneDataSet to create a new dataframe
* OneDataSetWithHeader (Name of the dataframe)

## Create a data frame where only the columns with variable names mean and std 
* MeanStdData (Name of the dataframe)

## Add Activity Code and Subject Code to the Data frame MeanStdData
* TotalData (Name of the dataframe)

## Map the activity code to their corresponding Activity Labels
* plyr1 (Name of the dataframe)

## Creates the TidyDataset (dcasted as mean for all the std and mean variables based on SubjectCode and Activity
* TidyDataset (Name of the Final Dataframe)
