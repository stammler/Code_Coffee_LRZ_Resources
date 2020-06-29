#!/bin/bash
#SBATCH -J mat_mat_mult
#SBATCH -o ./%x.%j.%N.out
#SBATCH -D ./
#SBATCH --get-user-env
#SBATCH --clusters=serial
#SBATCH --partition=serial_std
#SBATCH --mail-type=end
#SBATCH --mem=16mb
#SBATCH --cpus-per-task=1
#SBATCH --mail-user=			<--- ENTER EMAIL ADDRESS HERE !!! 
#SBATCH --export=NONE
#SBATCH --time=24:00:00
 
./matrix_matrix_multiplication
