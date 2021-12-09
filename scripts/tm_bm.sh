echo "$GROUP"
echo "$METHOD"
echo "$TEST"
echo "$GRID"
echo "$BAYES"
echo "$NUM1"

module load R

Rscript $SCRIPTDIR/tm_bm.R $GROUP $METHOD $TEST $GRID $BAYES $NUM1


