# EZtune_files
Contains the data and scripts used to create the figures and tables for the EZtune paper

This repostitory contains the data files and scripts used to create the tables and graphs in the EZtune paper. The runs were done on a high performance computer cluster using a package called EZtuneTest that is available on github. The scripts require that the EZtune and EZtuneTest packages are downloaded. EZtune is available from CRAN, but EZtune should be downloaded using the following command: 

devtools::install_github("jillbo1000/EZtuneTest")

# Data
The original datafiles are mostly available from R packages on CRAN or the files are included in the data folder of this repository. 

# Test runs
The computations done to compare EZtune with tidy models were computationally expensive so they were done using a high performance computer cluster. The R and shell scripts are available in the scripts folder. 

# Tables and graphs
The tables and graphs can be recreated using the functions from EZtuneTest and the data files created form the benchmarking runs done on the computer cluster. The benchmarking data are included in the data folder and the scripts are in the Rscripts folder. 
