#setwd("F:/Projects/Airport Inspector")
library(caret)
library(tidyverse)


# Load data
airstrip_data <- read_csv("data/airports_geocoded.csv")
dataset <- airstrip_data %>% dplyr::select(4:6,13) # renamed
colnames(dataset) <- c("Latitude", "Longitude", "Elevation", "Province.Name")
dataset$Province.Name <- as.factor(dataset$Province.Name)
# create a list of 80% of the rows in the original dataset we can use for training
validation_index <- createDataPartition(dataset$Province.Name, p=0.80, list=FALSE)
# select 20% of the data for validation
validation <- dataset[-validation_index,]
# use the remaining 80% of data to training and testing the models
dataset <- dataset[validation_index,]
# Run algorithms using 10-fold cross validation
control <- trainControl(method="cv", number=10)
metric <- "Accuracy"
# Random Forest
set.seed(7)
fit.rf <- train(Province.Name~., data=dataset, method="rf", metric=metric, trControl=control)

#save model
#save(fit.rf, file="fit.rf.rda")
#load("fit.rf.rda")
