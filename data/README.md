======================
benchmark_results
======================

This folder contains all of the benchmarking results for the 
EZtune and tidymodels performance comparison. These are the files
that were used to create the tables and plots in the article. Each
individual files contains the results for ten EZtune or
tidymodels runs using the same set of arguments and dataset. 

Note that there are some benchmarking files that are not included
in the article. Tests were done using mean absolute error and using
AUC as the loss function for tuning as well as for several other
function arguments. Ultimately, these were left
out of the paper because the results were so similar to the 
models using MSE and classification error as a loss function for
hyperparameter tuning. They are included in the repository for 
completeness. 


======================
data_files
======================

The files in the directory contain any external data and the
R scripts used to prepare all of the data for benchmark testing. 

The R scripts retrieve the data from the R package or the 
file location and format it for the shell scripts. The only 
file that is not part of an existing R package is 'Crime_Story.txt'
and it is included in this directory. 


======================
tables
======================

This folder contains the tables compiled from the benchmarking files. 
The scripts for making those tables is in the Rscripts folder. 
