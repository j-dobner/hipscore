library(caret)
library(tidyverse)
library(caretEnsemble)
set.seed(1337)
#Load Dataset
df_ml <- readRDS("hipscore_ml_4class_model_data.rds")
#Prepare Data (Training/Testing) and store in a list
intrain_list <- createDataPartition(y = unlist(df_ml[,1]), p = 0.7)[[1]]
training_list <- df_ml[intrain_list,]
testing_list <- df_ml[-intrain_list,]
algo_list <- c("ranger", "svmLinear", "pcaNNet", "JRip", "C5.0", "rpart")
levels(training_list$diff_type) <- make.names(levels(factor(training_list$diff_type)))
levels(training_list$diff_type) <- make.names(levels(factor(training_list$diff_type)))
#Train multiple models
trainControl <- trainControl(method = "repeatedcv",
                             number=10,
                             index = createResample(training_list$diff_type, 10),
                             repeats=3,
                             classProbs=TRUE,
                             sampling="smote",
                             savePredictions='final')
models <- caretList(as_factor(diff_type) ~ ., 
                    data = as.data.frame(training_list %>% dplyr::select(-sample_ID)), 
                    trControl = trainControl, 
                    methodList = algo_list,
                    metric = 'ROC')
#Assess model performance and select best model (models$"model_name" contains the final trained models)
results <- resamples(models)
summary(results)