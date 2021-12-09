#!/bin/sh

# script to submit 1 job for dataset model type combo for 
# tidymodels and EZtune

OUTDIR=/eztune_tests/tidymodels/out
SLURMIO=/eztune_tests/tidymodels/_slurm
SCRIPTDIR=/eztune_tests/tidymodels/scripts
DATDIR=/data/data_files

export SLURMIO
export SCRIPTDIR
export DATDIR
export OUTDIR

export LC_ALL=en_US.utf-8
export LANG=en_US.utf-8

# Make project directories 
# for GROUP in Abalone BostonHousing BreastCancer CO2 Crime Lichen Mullein Pima Sonar; 
# do 
# 	mkdir -p $OUTDIR/$GROUP/$MODEL
# 	export GROUP
# done

for GROUP in Abalone BostonHousing CO2 Crime; 
do
	export GROUP
	for LOSS in mae mse;
	do
		export LOSS
		for NUM1 in 1 2 3 4 5 6 7 8 9 10;
		do
			export NUM1
			sbatch -J en\_$GROUP -n 2 -N 1 \
			-t 2-12:00 --mem 10G \
			-o $SLURMIO/map_%x_%j.out \
			-e $SLURMIO/map_%x_%j.err \
			--wrap="sh $SCRIPTDIR/en_bm.sh"
		done
	done
done

