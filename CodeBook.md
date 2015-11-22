# Code Book for the Get and Clean Data Course Project

## Description of the *run_analysis* Script
The script takes the folder of the unzipped datafolder as an input. By default it assumes that the current work directory contains the unzipped data folder.

It needs the _dplyr_ and the _data.table_ package and tries to load them into the library.

Next it sets the working directory and loads the datasets (_X\_train/test.txt_,y\_train/test.txt,) in ./train and ./test and uses _rbind()_ to attach the subsets to each other (X,y). 
The subject IDs (_subjects_), variable names (_varNames_) and activity codes (_activities_) are loaded as well. 

_varNames_ is then manipulated to contain only valid characters, i.e. alphanumeric signs and dots to separate words with the help of _make.names()_.
Multiple occurances of "." are removed with _gsub()_.

The columns of _X_ are named with the values of _varNames_. Using the _grepl()_
function a logical vector is generated that gives _TRUE_ for each column of _X_ that has either _mean_ or _std_ in its name.

_subjects_, _y_ and _X_ are joined as one _data.frame_, named _joinedData_. Making use of the _group\_by_ function of the _dplyr_ package, the _joinedData_ is grouped by _subject_ and by _activity_.

The _joinedData\_grouped_ is then summarized in _tidy\_group_ and contains only the _mean()_ of each column for each _subject_ and each _activity_. For this purpose the _summarize\_each_ function of the _dplyr_ package is used. It recognizes the grouping from _group\_by()_ and gives the mean according to the group by passing the _mean()_ function in the _funs()_ argument.

The result is sorted in ascending subject ID with the _arrange()_ function.

In the last step, the activity codes are encoded with the values of _activities_ to be human readable.

Both _tidy\_group_ and _joinedData_ are put together in the _return\_data_ list and the latter is the reurn value of the function. Both data.frames are, hence, returned and can be accessed. 





## Variable Naming
Excerpt from the features_info.txt file provided in the original dataset:

_The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz._ 

_Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag).__ 

_Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals)._ 

_These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions._

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

_The set of variables that were estimated from these signals are:_ 

mean: Mean value
std: Standard deviation

_Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:_

gravityMean
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
tBodyGyroJerkMean*

By selecting only columns that contain a mean or standard deviation value, we end up with thefollowing variable names:
```
 [1] "subject"              subject ID                    
 [2] "activity"             corresponding activity        
 [3] "tBodyAcc.mean.X"              
 [4] "tBodyAcc.mean.Y"              
 [5] "tBodyAcc.mean.Z"              
 [6] "tBodyAcc.std.X"               
 [7] "tBodyAcc.std.Y"               
 [8] "tBodyAcc.std.Z"               
 [9] "tGravityAcc.mean.X"           
[10] "tGravityAcc.mean.Y"           
[11] "tGravityAcc.mean.Z"           
[12] "tGravityAcc.std.X"            
[13] "tGravityAcc.std.Y"            
[14] "tGravityAcc.std.Z"            
[15] "tBodyAccJerk.mean.X"          
[16] "tBodyAccJerk.mean.Y"          
[17] "tBodyAccJerk.mean.Z"          
[18] "tBodyAccJerk.std.X"           
[19] "tBodyAccJerk.std.Y"           
[20] "tBodyAccJerk.std.Z"           
[21] "tBodyGyro.mean.X"             
[22] "tBodyGyro.mean.Y"             
[23] "tBodyGyro.mean.Z"             
[24] "tBodyGyro.std.X"              
[25] "tBodyGyro.std.Y"              
[26] "tBodyGyro.std.Z"              
[27] "tBodyGyroJerk.mean.X"         
[28] "tBodyGyroJerk.mean.Y"         
[29] "tBodyGyroJerk.mean.Z"         
[30] "tBodyGyroJerk.std.X"          
[31] "tBodyGyroJerk.std.Y"          
[32] "tBodyGyroJerk.std.Z"          
[33] "tBodyAccMag.mean"             
[34] "tBodyAccMag.std"              
[35] "tGravityAccMag.mean"          
[36] "tGravityAccMag.std"           
[37] "tBodyAccJerkMag.mean"         
[38] "tBodyAccJerkMag.std"          
[39] "tBodyGyroMag.mean"            
[40] "tBodyGyroMag.std"             
[41] "tBodyGyroJerkMag.mean"        
[42] "tBodyGyroJerkMag.std"         
[43] "fBodyAcc.mean.X"              
[44] "fBodyAcc.mean.Y"              
[45] "fBodyAcc.mean.Z"              
[46] "fBodyAcc.std.X"               
[47] "fBodyAcc.std.Y"               
[48] "fBodyAcc.std.Z"               
[49] "fBodyAcc.meanFreq.X"          
[50] "fBodyAcc.meanFreq.Y"          
[51] "fBodyAcc.meanFreq.Z"          
[52] "fBodyAccJerk.mean.X"          
[53] "fBodyAccJerk.mean.Y"          
[54] "fBodyAccJerk.mean.Z"          
[55] "fBodyAccJerk.std.X"           
[56] "fBodyAccJerk.std.Y"           
[57] "fBodyAccJerk.std.Z"           
[58] "fBodyAccJerk.meanFreq.X"      
[59] "fBodyAccJerk.meanFreq.Y"      
[60] "fBodyAccJerk.meanFreq.Z"      
[61] "fBodyGyro.mean.X"             
[62] "fBodyGyro.mean.Y"             
[63] "fBodyGyro.mean.Z"             
[64] "fBodyGyro.std.X"              
[65] "fBodyGyro.std.Y"              
[66] "fBodyGyro.std.Z"              
[67] "fBodyGyro.meanFreq.X"         
[68] "fBodyGyro.meanFreq.Y"         
[69] "fBodyGyro.meanFreq.Z"         
[70] "fBodyAccMag.mean"             
[71] "fBodyAccMag.std"              
[72] "fBodyAccMag.meanFreq"         
[73] "fBodyBodyAccJerkMag.mean"     
[74] "fBodyBodyAccJerkMag.std"      
[75] "fBodyBodyAccJerkMag.meanFreq" 
[76] "fBodyBodyGyroMag.mean"        
[77] "fBodyBodyGyroMag.std"         
[78] "fBodyBodyGyroMag.meanFreq"    
[79] "fBodyBodyGyroJerkMag.mean"    
[80] "fBodyBodyGyroJerkMag.std"     
[81] "fBodyBodyGyroJerkMag.meanFreq"
```

The original names stored in _features.txt_ have been modified with the _make.names()_ function, to contain only valid column-name characters (alphanumeric and dots). Multiple occurances of "." have been removed with the _gsub()_ function.