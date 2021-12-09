echo "$GROUP"
echo "$METHOD"
echo "$OPT"
echo "$FAST"
echo "$CROSS"
echo "$LOSS"
echo "$NUM1"

module load R

Rscript $SCRIPTDIR/ez_bm.R $GROUP $METHOD $OPT $FAST $CROSS $LOSS $NUM1


