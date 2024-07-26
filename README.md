# hiPSCore
code for hiPSCore machine learning models

The purpose of this repository is to enable access to the code (2024-07-17_ml_code_hipscore.R) which was used to train the machine learning models of the article "Reassessment of Marker Genes in Human Induced Pluripotent Stem Cells for Enhanced Quality Control" by Dobner et al.
These machine learning models are used to classify human induced pluripotent stem cells (hiPSCs)-derived early germ layer samples in a combinatorial approach based on binary classification of four individual subtests for each of the early hiPSC differentiation states undifferentiated/pluripotent, endoderm, ectoderm, and mesoderm. 
The underlying data is part of this repository and contains qPCR-based delta Ct values of individual target genes normalized to two reference genes.
The respective models can be applied by using the predict function of R, e.g. predict(model, data, type = "prob") for the respective germ layers. The final hiPSCore is calculated as a sum of four germ layer subtests and is considered to pass if each subtest is passed with at least 0.75 p prediction confidence.
The models have been implemented in a R shiny-based web-application which can be accessed under https://jdobner.shinyapps.io/hipscore/.
Details on the background can be found in the corresponding publication which will be linked here after acceptance.
If you encounter any problems using the code and/or the web-application, please contact the corresponding author and/or the owner of this repository.
