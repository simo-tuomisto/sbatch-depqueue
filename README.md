# sbatch-depqueue

This is a simple bash script that one can use to submit a
queue of identical jobs that all depend on the previous
job.

Running jobs in this way is useful for bypassing time
limits for jobs that can continue from checkpoints.

Script utilizes the `--dependency=afterok:jobid`-flag in `sbatch` for
submission, so if the job exits with a failure code, the subsequent
jobs hang in the queue.

## Usage

```sh
bash sbatch-depqueue.sh my_slurm_script.sh number_of_dependency_jobs
```

## Example

`examples/depqueue-example.sh` contains a simple example script that
prints some information about the job and waits a minute.

### Running the example without dependency queue

Submit a single job with sbatch

```sh
$ sbatch examples/depqueue-example.sh 
Submitted batch job 10371520
```

Looking at the job in the queue it looks like this:

```sh
$ squeue -u $USER
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
          10371520 batch-csl depqueue tuomiss1 PD       0:00      1 (None)
```

### Running the example as dependency queue

Submit a job with three dependencies as a queue

```sh
$ ./sbatch-depqueue.sh examples/depqueue-example.sh 3
Submitting initial job.
Submitting dependency number 1 that depends on job number 10371878.
Submitting dependency number 2 that depends on job number 10371879.
Submitting dependency number 3 that depends on job number 10371880.
All submissions done. Listing your currently submitted jobs:
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
          10371881 batch-csl depqueue tuomiss1 PD       0:00      1 (Dependency)
          10371880 batch-csl depqueue tuomiss1 PD       0:00      1 (Dependency)
          10371879 batch-csl depqueue tuomiss1 PD       0:00      1 (Dependency)
          10371878 batch-csl depqueue tuomiss1 PD       0:00      1 (None)
```

After the submission, the jobs will be in the queue and they will start in order.

```sh
$ squeue -u $USER
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
          10371878 batch-csl depqueue tuomiss1  R       0:20      1 csl47
          10371881 batch-csl depqueue tuomiss1 PD       0:00      1 (Dependency)
          10371880 batch-csl depqueue tuomiss1 PD       0:00      1 (Dependency)
          10371879 batch-csl depqueue tuomiss1 PD       0:00      1 (Dependency)
```
