#!/bin/sh

# script to submit 1 job for dataset model type combo for 
# tidymodels and EZtune

OUTDIR=/eztune_tests/tidymodels/out
SLURMIO=/eztune_tests/tidymodels/_slurm
SCRIPTDIR=/eztune_tests/tidymodels/scripts
DATDIR=data/data_files

export SLURMIO
export SCRIPTDIR
export DATDIR
export OUTDIR

export LC_ALL=en_US.utf-8
export LANG=en_US.utf-8

# Make project directories 
for GROUP in Abalone BostonHousing BreastCancer CO2 Crime Lichen Mullein Pima Sonar; 
do 
	mkdir -p $OUTDIR/$GROUP/$MODEL
	export GROUP
done

for GROUP in Abalone BostonHousing CO2 Crime; 
do
	export GROUP
	for METHOD in svm gbm;
	do
		export METHOD
		for OPT in hjn ga;
		do
			for FAST in 1 0.5 0.75 0;
			do
				export FAST
				for CROSS in 10;
				do
					export CROSS
					for LOSS in mae mse;
					do
						export LOSS
						for NUM1 in 1 2 3 4 5 6 7 8 9 10;
						do
							export NUM1
							
							sbatch -J ez\_$METHOD\_FAST\_$GROUP -n 2 -N 1 \
							-t 2-12:00 --mem 10G \
							-o $SLURMIO/map_%x_%j.out \
							-e $SLURMIO/map_%x_%j.err \
							--wrap="sh $SCRIPTDIR/ez_bm.sh"
						done
					done
				done
			done
		done
	done
done

for GROUP in BreastCancer Lichen Mullein Pima Sonar; 
do
	export GROUP
	for METHOD in svm gbm;
	do
		export METHOD
		for OPT in hjn ga;
		do
			for FAST in 1 0.5 0.75 0;
			do
				export FAST
				for CROSS in 10;
				do
					export CROSS
					for LOSS in class auc
					do
						export LOSS
						for NUM1 in 1 2 3 4 5 6 7 8 9 10;
						do
							export NUM1
							
							sbatch -J ez\_$METHOD\_FAST\_$GROUP -n 2 -N 1 \
							-t 2-12:00 --mem 10G \
							-o $SLURMIO/map_%x_%j.out \
							-e $SLURMIO/map_%x_%j.err \
							--wrap="sh $SCRIPTDIR/ez_bm.sh"
						done
					done
				done
			done
		done
	done
done

# Tidymodels benchmarking

for GROUP in Abalone BostonHousing CO2 Crime BreastCancer Lichen Mullein Pima Sonar; 
do
	export GROUP
	for METHOD in svm gbm;
	do
		export METHOD
		for TEST in grid bayes;
		do
			export TEST
			if [ $TEST = "grid" ]; then
				for GRID 5 10;
				do
					export GRID
					for NUM1 1 2 3 4 5 6 7 8 9 10;
					do
						export NUM1
						sbatch -J tm\_$METHOD\_g\_$GROUP -n 2 -N 1 \
						-t 2-12:00 --mem 10G \
						-o $SLURMIO/map_%x_%j.out \
						-e $SLURMIO/map_%x_%j.err \
						--wrap="sh $SCRIPTDIR/tm_bm.sh"					
					done
				done
			else
				for BAYES 5 10;
				do
					export BAYES
					for NUM1 1 2 3 4 5 6 7 8 9 10;
					do
						export NUM1
						sbatch -J tm\_$METHOD\_b\_$GROUP -n 2 -N 1 \
						-t 2-12:00 --mem 10G \
						-o $SLURMIO/map_%x_%j.out \
						-e $SLURMIO/map_%x_%j.err \
						--wrap="sh $SCRIPTDIR/tm_bm.sh"					
					done
				done
			fi
		done
	done
done
				

