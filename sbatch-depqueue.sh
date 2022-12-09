#!/bin/bash

usage() {
  cat << EOF

Usage:

  $0 SBATCH_SCRIPT NDEPS

    Submit the SBATCH_SCRIPT NDEPS-times
    where each submission depends on the
    previous one.

EOF
  exit 1
}

[ $# -lt 2 ] && echo "Need two arguments." && usage

SBATCH_SCRIPT=$1
NDEPS=$2

[ ! -f $SBATCH_SCRIPT ] && echo "No file found called $SBATCH_SCRIPT." && usage
[ "$NDEPS" -gt 0 ] 2> /dev/null || echo "NDEPS need to be bigger than 0."

echo "Submitting initial job."
JOB_ID=$(sbatch --parsable $SBATCH_SCRIPT)

for i in $(seq 1 $NDEPS); do
  echo "Submitting dependency number $i that depends on job number $JOB_ID."
  JOB_ID=$(sbatch --parsable --dependency=afterok:$JOB_ID $SBATCH_SCRIPT)
done

echo "All submissions done. Listing your currently submitted jobs:"
squeue -u $USER
