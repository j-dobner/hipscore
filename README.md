# hiPSCore
![logo](https://github.com/user-attachments/assets/9895ad83-a4f3-48b6-839f-2396e7de61b3)

**Code for hiPSCore machine learning models**

The purpose of this repository is to provide access to the code which was used to train the machine learning models of the article "Reassessment of Marker Genes in Human Induced Pluripotent Stem Cells for Enhanced Quality Control" by Dobner et al.
These machine learning models are used to classify human induced pluripotent stem cells (hiPSCs)-derived early germ layer samples obtained by directed trilineage differentiation by two different approaches:

1.) Samples are classified by a combinatorial approach based on binary classification of four individual subtests for each of the early hiPSC differentiation states undifferentiated/pluripotent, endoderm, ectoderm, and mesoderm. The code for the training of these models is stored in the file 2024-07-17_ml_code_hipscore.R and accompanied by the underlying data used for training stored in hipscore_ml_data.rds. This dataset contains qPCR-based delta Ct values of individual target genes used for primary germ layer classification (three genes per germlayer and the undifferentiated state) normalized to two reference genes.
The obtained models can be applied for prediction by use of the predict function of R, e.g. ``predict(model, data, type = "prob")``, for the respective germ layers. The final hiPSCore can be calculated as a sum of four germ layer subtests and is considered to pass if each subtest is passed with at least 0.75 p prediction confidence.

2.) (BETA feature) Samples are classified into one of four differentiation states (pluripotent/undifferentiated, endoderm, ectoderm, mesoderm) based on multi class classification. The code for the training of this model is stored in the file 2024-07-17_ml_code_hipscore_4_class_beta.R and accompanied by the underlying data used for training stored in hipscore_ml_4class_model_data.rds.
This dataset contains qPCR-based delta Ct values of all hiPSCore target genes (12 genes) normalized to two reference genes.
The obtained model can be applied for prediction by use of the predict function of R, e.g. ``predict(model, data, type = "prob")``, for a given sample. The prediction results in classification into the differentiation state with the highest lieklihood.
Because of the relatively small sample size approach 2.) is currently a beta-level feature.

The described models have been implemented in a R shiny-based web-application which can be accessed under https://jdobner.shinyapps.io/hipscore/. The web-application can be employed by using the test data set and replacing the delta Ct values with experimentally obtained qPCR-based values. To analyze samples according to 1.) (prediction mode: „default“), the Control sample has to contain all fourteen hiPSCore genes (12 differentiation/germ layer-specific plus two reference genes) in duplicates, while the individual subtest samples have to contain three differentiation/germ layer-specific genes (totalling five genes) in duplicates. As negative control „a.dest“ has to be selected.
For 2.) (prediction mode: „gl“), up to three samples can be analyzed for which all fourteen hiPSCore genes (12 differentiation/germ layer-specific plus two reference genes) in duplicates have to be entered, and the negative control identifier has to be not „a.dest“.

In both cases, after successful upload of the data by the Upload button, press ‚Get your hiPSCore!‘ for scoring results.

The models used for the web-application are based on the code described in this repository.
Further details on the background can be found in the corresponding publication which will be linked here after acceptance.
If you encounter any problems using the code and/or the web-application, please contact the corresponding author and/or the owner of this repository.
