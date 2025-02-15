#!/bin/bash
#SBATCH --account=project_200xxxx    # Choose the project to be billed
#SBATCH --output=slurm-%j.out  # File to write the standard output to. %j is replaced by the job ID.
#SBATCH --error=slurm-%j.err  # File to write the standard error to. %j is replaced by the job ID. Defaults to slurm-%j.out if not provided. 
#SBATCH --time=0:05:00  # Maximum duration of the job. Upper limit depends on partition.
#SBATCH --partition=test  # Which queue to use. Defines maximum time, memory, tasks, nodes and local storage for job
#SBATCH --nodes=1  # Number of compute nodes. Upper limit depends on partition.
#SBATCH --ntasks=1  # Number of tasks. Upper limit depends on partition.
#SBATCH --mem-per-cpu=4000  # Minimum memory required per usable allocated CPU.  Default units are megabytes.

module load qgis

GRASS_DIR=/scratch/project_2000599/grass
GRASS_DB_DIR=$GRASS_DIR/db
GRASS_LOCATION_DIR=$GRASS_DB_DIR/3067
MAPSET_DIR=$GRASS_LOCATION_DIR/PERMANENT/
SCRIPTS_DIR=/scratch/project_2000599/geocomputing/grass/01_serial_cli

# create a directory to hold the location used for processing
mkdir -p $GRASS_DB_DIR/db

# create new temporary location for the job, exit after creation of this location
grass -c epsg:3067 $GRASS_LOCATION_DIR -e

# define job file as environmental variable
# Make sure first that job file has executing rights, use chmod command for fixing
export GRASS_BATCH_JOB=$SCRIPTS_DIR/grass_cli.sh

# now we can use this new location and run the job defined via GRASS_BATCH_JOB
grass $MAPSET_DIR

#### 3) CLEANUP
# switch back to interactive mode, for the next GRASS GIS session
unset GRASS_BATCH_JOB

# delete temporary location 
rm -rf $GRASS_LOCATION_DIR
