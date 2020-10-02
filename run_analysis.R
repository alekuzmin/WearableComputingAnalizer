# get data
x_test <- read.table("./data/test/X_test.txt", header = FALSE)
y_test <- read.table("./data/test/y_test.txt", header = FALSE)
subject_test <- read.table("./data/test/subject_test.txt", header = FALSE)
x_train <- read.table("./data/train/X_train.txt", header = FALSE)
y_train <- read.table("./data/train/y_train.txt", header = FALSE)
subject_train <- read.table("./data/train/subject_train.txt", header = FALSE)

# build datasets
x_ds <- rbind(x_test, x_train)
y_ds <- rbind(y_test, y_train)
subject_ds <- rbind(subject_test, subject_train)

# set names
labels <- read.table("./data/activity_labels.txt")
y_ds[, 1] <- labels[y_ds[, 1], 2]

names(subject_ds) <- c("subject")
names(y_ds) <- c("activity")
features <- read.table("./data/features.txt")
names(x_ds) <- features$V2

# select interest's columns 
ff <- c(grep("mean\\(\\)", features[, 2]),grep("std\\(\\)", features[, 2]))
x_data_set <- subset(x_ds, select=as.numeric(ff))
f_names <- names(x_data_set)
f_names = gsub('-mean', 'Mean', f_names)
f_names = gsub('-std', 'Std', f_names)
f_names <- gsub('[-()]', '', f_names)
names(x_data_set) <- f_names

# buiding total dataset 
data <- cbind(subject_ds, y_ds)
data_total <- cbind(data, x_data_set)

#  export result 
data_result  <-  aggregate(. ~subject + activity, data_total, mean)
data_result <- data_result[order(data_result$subject, data_result$activity), ]
write.table(data_result, file = "tidyData.txt", row.name=FALSE)   
