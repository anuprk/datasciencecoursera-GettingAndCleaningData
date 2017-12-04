
# download dataset

#download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile="data.zip")
#unzip ( zipfile = "data.zip")

library(dplyr)

#activity lables
al <- read.table ("./UCI HAR Dataset/activity_labels.txt")
#features
f <- read.table("./UCI HAR Dataset/features.txt")
#training tables
xt <- read.table("./UCI HAR Dataset/train/X_train.txt")
yt <- read.table("./UCI HAR Dataset/train/Y_train.txt")
st <- read.table("./UCI HAR Dataset/train/subject_train.txt")
xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("./UCI HAR Dataset/test/Y_test.txt")
stest <- read.table("./UCI HAR Dataset/test/subject_test.txt")

#merge data
xdata <- rbind(xt, xtest)
ydata <- rbind(yt, ytest)
sdata <- rbind(st, stest)


tmp <- f[grep("mean\\(\\)|std\\(\\)",f[,2]),]
xdata <- xdata[,tmp[,1]]

#name columns
colnames(ydata) <- "activity"
ydata$activitylabel <- factor(ydata$activity, labels = as.character(al[,2]))
activitylabel <- ydata[,-1]

colnames(xdata) <- f[tmp[,1],2]

#create small tidy data set
colnames(sdata) <- "subject"
total <- cbind(xdata, activitylabel, sdata)
total_mean <- total %>% group_by(activitylabel, subject) %>% summarize_all(funs(mean))
write.table(total_mean, file = "./UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)

