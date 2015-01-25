library(plyr)


## Read files from 'train' folder and combine them

subject_train = read.table('train/subject_train.txt')
X_train = read.table('train/X_train.txt')
y_train = read.table('train/y_train.txt')

train = cbind(subject_train, X_train, y_train)


## Read files from 'test' folder and combine them

subject_test = read.table('test/subject_test.txt')
X_test = read.table('test/X_test.txt')
y_test = read.table('test/y_test.txt')

test = cbind(subject_test, X_test, y_test)

## Combine 'train' and 'test' data.frames in one set
test_train = rbind(test, train)

## Read Features Names text file
features = read.table('features.txt')

colnames(test_train)[2:562]   <- as.character(features[,2])
colnames(test_train)[c(1,563)]   <- c('Subject','Activity')

# Required features/Column Names
reqFeatures <- grep(".*mean.*|.*std.*", names(test_train), ignore.case=T)
ex_df <- test_train[,c(1, 563, reqFeatures)]

#Read activity labels file
activity_labels = read.table('activity_labels.txt')

 i = 1
for (activity in activity_labels[,2])
{
  ex_df$Activity[ex_df$Activity == as.character(i)] = activity
  i = i +1
}

ex_df$Subject = as.factor(ex_df$Subject)
ex_df$Activity = as.factor(ex_df$Activity)

tidy = aggregate(ex_df, by=list(Activity = ex_df$Activity, Subject=ex_df$Subject), mean)

# remove subject and activity mean column
tidy[,3]=NULL
tidy[,3]=NULL

write.table(tidy, 'tidy.txt', row.name=FALSE, sep='\t')





