echo "$GROUP"
echo "$METHOD"
echo "$LOSS"
echo "$NUM1"

module load R
module load gcc/9.2.0

Rscript $SCRIPTDIR/en_bm.R $GROUP $LOSS $NUM1


