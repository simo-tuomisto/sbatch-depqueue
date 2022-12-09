#!/bin/bash
#SBATCH --time=00:10:00
#SBATCH --mem=100M
#SBATCH --output=depqueue-example-%j.out

echo 'Jobid     : '$SLURM_JOB_ID
echo 'Waiting for 60 seconds.'
echo 'Time is '$(date)

sleep 60

echo 'Finishing up.'
echo 'Time is '$(date)
