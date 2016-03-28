rm(list=ls())
setwd("/Users/Reza/Desktop/UCI HAR Dataset/")
features<-read.table("features.txt",header=FALSE)
activity_label<-read.table("activity_labels.txt",header=FALSE)
subject_train<-read.table("train/subject_train.txt",header=FALSE)
xTrain<-read.table("train/x_train.txt",header=FALSE)
yTrain<-read.table("train/y_train.txt",header=FALSE)
subjectTest<-read.table("test/subject_test.txt",header=FALSE)
x_test<-read.table("test/x_test.txt",header=FALSE)
y_test<-read.table("test/y_test.txt",header=FALSE)
colnames(activity_label)<-c("activity_id","activity_label");
colnames(subject_train)<-"subject_id";
colnames(xTrain)<-features[,2]; 
colnames(yTrain)<-"activity_id";
colnames(subjectTest)<-"subject_id";
colnames(x_test)<-features[,2]; 
colnames(y_test)<-"activity_id";
merged_train_data<-cbind(yTrain,subject_train,xTrain);
merged_test_data<-cbind(y_test,subjectTest,x_test);
merged_data<-rbind(merged_train_data,merged_test_data);
colNames<-colnames(merged_data); 
temp_vector<-(grepl("activity..",colNames)|grepl("subject..",colNames)|grepl("-mean..",colNames)&!grepl("-meanFreq..",colNames)&!grepl("mean..-",colNames)|grepl("-std..",colNames)&!grepl("-std()..-",colNames))
merged_data<-merged_data[temp_vector==TRUE];
merged_data<-merge(merged_data,activity_label,by="activity_id",all.x=TRUE);
colNames<-colnames(merged_data); 
for (i in 1:length(colNames)){
  colNames[i]<-gsub("\\()","",colNames[i])
  colNames[i]<-gsub("-std$","StdDev",colNames[i])
  colNames[i]<-gsub("-mean","Mean",colNames[i])
  colNames[i]<-gsub("^(t)","time",colNames[i])
  colNames[i]<-gsub("^(f)","freq",colNames[i])
  colNames[i]<-gsub("([Gg]ravity)","Gravity",colNames[i])
  colNames[i]<-gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",colNames[i])
  colNames[i]<-gsub("[Gg]yro","Gyro",colNames[i])
  colNames[i]<-gsub("AccMag","AccMagnitude",colNames[i])
  colNames[i]<-gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",colNames[i])
  colNames[i]<-gsub("JerkMag","JerkMagnitude",colNames[i])
  colNames[i]<-gsub("GyroMag","GyroMagnitude",colNames[i])
}
colnames(merged_data)<-colNames;
merged_data_without_activity_label<-merged_data[,names(merged_data)!="activity_label"];
final_data<-aggregate(merged_data_without_activity_label[,names(merged_data_without_activity_label)!=c("activity_id","subject_id")],by=list(activity_id=merged_data_without_activity_label$activity_id,subject_id = merged_data_without_activity_label$subject_id),mean);
final_data<-merge(final_data,activity_label,by="activity_id",all.x=TRUE);
write.table(final_data, "final_data.txt",row.names=TRUE,sep="\t");