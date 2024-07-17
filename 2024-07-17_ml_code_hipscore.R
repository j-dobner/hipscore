library(caret)
library(tidyverse)
set.seed(1337)
#Load Dataset
m_list <- readRDS("hipscore_ml_data.rds")
#Prepare Data (Training/Testing) and store in a list
intrain_list <- list()
training_list <- list()
testing_list <- list()
for(i in 1:length(unique(gene_set))) {
  intrain_list[[i]] <- createDataPartition(y = unlist(m_list[[i]][,1]), p = 0.7)[[1]]
  training_list[[i]] <- m_list[[i]][intrain_list[[i]],]
  testing_list[[i]] <- m_list[[i]][-intrain_list[[i]],]
}
names(training_list) <- unique(gene_set)
#Train multiple models
results_list <- list()
models_list <- list()
algo_list <- c("ranger", "svmLinear", "pcaNNet", "JRip", "C5.0", "rpart", "rotationForest", "gbm")
for(i in 1:4){
  levels(training_list[[i]]$qsc) <- make.names(levels(factor(training_list[[i]]$qsc)))
  trainControl <- trainControl(method = "repeatedcv",
                               number=10,
                               index = createResample(training_list[[i]]$qsc, 10),
                               repeats=3,
                               classProbs=TRUE,
                               summaryFunction = twoClassSummary,
                               savePredictions='final')
  
  
  models_list[[i]] <- caretList(as_factor(qsc) ~ ., 
                                data = as.data.frame(training_list[[i]]), 
                                trControl = trainControl, 
                                methodList = algo_list,
                                metric = "ROC")
  results_list[[i]] <- resamples(models_list[[i]])
}
#Assess model performance and select best model (models_list[[i]] contains the final trained models)
summary(results_list[[1]])
summary(results_list[[2]])
summary(results_list[[3]])
summary(results_list[[4]])