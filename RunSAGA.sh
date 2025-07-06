#!/bin/bash
#SBATCH --job-name=SAGA_Bending
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=3G

/shared/Apps/MATLAB/R2022a/bin/matlab -nosplash -nodisplay -nodesktop -r SAGA_Bending
