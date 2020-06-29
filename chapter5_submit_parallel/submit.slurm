#!/bin/bash
#SBATCH -J mat_mat_mult_par
#SBATCH -o ./%x.%j.%N.out
#SBATCH -D ./
#SBATCH --get-user-env
#SBATCH --clusters=cm2_tiny
#SBATCH --partition=cm2_tiny
#SBATCH --nodes=1-1
#SBATCH --cpus-per-task=8
#SBATCH --mail-type=end
#SBATCH --mail-user=            <--- ENTER EMAIL ADDRESS HER !!!
#SBATCH --export=NONE
#SBATCH --time=08:00:00
module load slurm_setup
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export MKL_NUM_THREADS=$SLURM_CPUS_PER_TASK
 
./matrix_matrix_multiplication_parallel
