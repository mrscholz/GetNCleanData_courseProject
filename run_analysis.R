run_analysis <- function(path="./UCI HAR Dataset"){
    ## load packages 
    library(dplyr) # dplyr to easily group and summarize data 
    library(data.table) # data.table to have access to the fread, for faster file reading
    
    ## set working directory; default assumes you are in the folder that contains the unzipped dataset folder
    setwd(path)
    
    ## read in the test data; large files are read with fread() from the data.table package
    print("reading data...")
    X <- fread("./test/X_test.txt")
    y <- fread("./test/y_test.txt",col.names="activity")
    
    
    ## read in the train data and attach to the test data with rbind()
    X <- rbind(X, fread("./train/X_train.txt"))
    y <- rbind(y, fread("./train/y_train.txt",col.names="activity"))
    
    ## I transform data.tables back to data.frames; this is not absolutely necessary 
    #  but there are some issues with naming of columns and merging the data, which 
    #  I was just to lazy to figure out
    X <- data.frame(X)
    y <- data.frame(y)
    
    ## read in subject-IDs, variable names, and activities encoder
    subjects <- read.table("./test/subject_test.txt",col.names="subject")
    subjects <- rbind(subjects,fread("./train/subject_train.txt",col.names="subject"))
    varNames <- read.table("./features.txt")
    activities <- read.table("./activity_labels.txt")
    activities <- as.character(activities[,2])
    
    ## bring variable names in an at least tidyer format
    varNames <- make.names(as.character(varNames[,2]),unique=TRUE)
    varNames <- gsub("...",".",varNames,fixed=TRUE)
    varNames <- gsub("..","",varNames,fixed=TRUE)
    
    ## name the columns accordingly
    colnames(X) <- varNames
    
    ## get rid of unnecessary columns, keep only names with mean and std in it
    use <- varNames[grepl("mean|std",varNames)]
    X <- X[,use]
    
    ## glue everything together: subjects, activities and data
    joinedData <- data.frame(subjects,y,X)
    
    ## group the data by subjects and activities 
    joinedData_grouped <- group_by(joinedData,subject,activity)
    
    ## calculate the mean of each data column by subject and by activity
    tidy_group <- joinedData_grouped %>% summarize_each(funs(mean))
    
    ## sort the data in ascending subject ID
    tidy_group <- arrange(tidy_group,subject)
    
    ## encode activities for readability
    for(i in 1:length(activities)){
         logi <- tidy_group$activity==i
         tidy_group[logi,2] <- activities[i]
    }
    
    ## I want both data.frames (tidy_group and joinedData) returned by the script
    #  so I store them in a list
    write.table(tidy_group, file="./tidy_data.txt", row.names=FALSE)
    return_data <- list(tidy_group,joinedData)
    return_data
}