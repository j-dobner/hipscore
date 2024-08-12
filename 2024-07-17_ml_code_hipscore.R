library(caret)
library(tidyverse)
library(caretEnsemble)
set.seed(1337)
#Load Dataset
m_list <- readRDS("hipscore_ml_data.rds")
#Prepare Data (Training/Testing) and store in a list
intrain_list <- list()
training_list <- list()
testing_list <- list()
gene_set = c("undifferentiated", "endoderm", "ectoderm", "mesoderm")
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
#1: undifferentiated; 2: endoderm; 3: ectoderm; 4: mesoderm
summary(results_list[[1]])
summary(results_list[[2]])
summary(results_list[[3]])
summary(results_list[[4]])

#Perform predictions on delta Ct-normalized values (exemplary values)
#ranger chosen as final model
undiff_table <- tibble(SPP1 = c(8,12,5),
                       NANOG = c(10,14,4),
                       CNMD = c(6, 13, 6))
undiff_preds <- predict(models_list[[1]]$ranger, undiff_table, type="prob") |> 
  pull(X1)
endo_table <- tibble(GATA6 = c(12,12,5),
                     EOMES = c(11,13,4),
                     CER1 = c(10,11,1.2))
endo_preds <- predict(models_list[[2]]$ranger, endo_table, type="prob") |>
  pull(X1)
ecto_table <- tibble(PAX6 = c(13,10,7),
                     HES5  = c(12,14,8),
                     PAMR1  = c(16, 12, 7))
ecto_preds <- predict(models_list[[3]]$ranger, ecto_table, type="prob") |> 
  pull(X1)
meso_table <- tibble(HAND1 = c(16,8,7),
                     APLNR = c(12, 5, 8),
                     HOXB7 = c(17,7,8))
meso_preds <-predict(models_list[[4]]$ranger, meso_table, type="prob") |> 
  pull(X1)

#Calculate hiPSCores
calculate_hipscore <- function(undiff_preds, endo_preds, ecto_preds, meso_preds) {
tibble(undiff_preds, endo_preds, ecto_preds, meso_preds) |> 
  rowwise() |> 
  dplyr::transmute(hipscore = sum(undiff_preds, endo_preds, ecto_preds, meso_preds)) |> 
  dplyr::mutate(hipscore_result = case_when(
    hipscore >3 ~ "PASS",
    hipscore >2 & hipscore <=3 ~ "WARNING",
    hipscore <=2 ~ "FAIL"
  ))
}
calculate_hipscore(undiff_preds, endo_preds, ecto_preds, meso_preds)
