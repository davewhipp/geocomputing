#!/bin/bash -l
#SBATCH --account=<YOUR-PROJECT>
#SBATCH -J r_multi_proc
#SBATCH -o output.txt
#SBATCH -e errors.txt
#SBATCH -t 00:05:00
#Reserve cores for 1 master + 3 workers
#SBATCH --ntasks=4
#Test partition is used for testing, for real jobs use either serial or parallel depending on how many nodes you need.
#SBATCH -p test
#SBATCH --mem-per-cpu=1000

module load r-env-singularity

if test -f ~/.Renviron; then
    sed -i '/TMPDIR/d' ~/.Renviron
fi

# Specify a temp folder path
echo "TMPDIR=/scratch/<project>" >> ~/.Renviron

srun singularity_wrapper exec RMPISNOW --no-save --slave -f Calc_contours_future.R
