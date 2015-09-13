#!/bin/sh

# as simple BASH script to run fastStructure
# it assumes:
#
# 1. the input file is names infile as in the same
#    path as this script
# 
# The output:
# 	The script will output

# keeping track of how long each run takes
START=$(date +%s)

# parameters supplied by the user/command-line
# these are positional parameters and should appear
# in the specified order

# path to fastStructure Python script
# e.g., ~/bin/fastStructure/structure.py
path_exe=$1

# path to infile
# test/test.bed
# ~/analysis/infile
path_infile=$2

# prior to use, can be 'simple' or 'logistic'
prior=$3

# data format, can be 'str' or 'bed'
data_fmt=$4

# maximum number of times to repeat analysis
# with given K
max_rep=$5

# a number indicating the actual number of the
# the analysis being currently run. This is
# sequential, and will run from 0 to total number
# of runs minus 1. So, if running range of K from
# 1 to 5, with 10 replicates each, there will be a
# total of 50 runs, and task_id will range from
# 0 to 49.
task_id=$6

# parameters set by program during each run 
# *** DO NOT CHANGE ***

# sets K for the current run
K=$[1+($task_id/$max_rep)]

# sets the rep number for the K, used in 
# naming files
rep=$[($K*$max_rep)-$task_id]

# sets the seed. important if running 
# parallel runs, because otherwise the seed
# is set by the computer clock, and simultaneous
# runs will have the same seed
seed=`eval od -vAn -N4 -tu4 < /dev/urandom`

seed=`echo $seed`

python $path_exe -K $K --input=$path_infile --output=output_${prior}_$rep --format=str --seed=$seed --prior=$prior --format=$4

END=$(date +%s)

DIFF=$(echo "$END - $START" | bc)

echo "Finished job K=$K, replicate=$rep, and took $DIFF seconds."
