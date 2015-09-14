# Batch parallel fastStructure

This is `bash` script combined with a `makefile` that runs multiple replicates
of `fastStructure` across a range of `K`.

# Dependencies

You must have installed:
	* GNU Parallel
	* fastStructure

# Running the script

There are two main files. To make the program work edit the `make_faststruct` file
using a text editor like `vi`. You should change the folowing:

	* REPS <int> - Number of replicates for each K
	* MAX_K <int> - Biggest K value for which the model should be run
	* PATH_STRUCTURE_PY <string> - The path to the structure.py file of fastStructure
	* PATH_CHOOSE_PY <string> - The path to the chooseK.py file of fastStructure
	* PRIOR <string> - Either simple or logistic depending on the prior you want to use
	* DATA_FORMAT <string> - Either bed or str (structure) format
	* PATH_INFILE <string> - Path to the infile

Once the parameters have been set correctly, save the file, and run the following 
on the command line

	make -f make_faststruct

If it fails for some reason, run the following to clean up the directory before
running the script again:

	make -f make_faststruct clean

# Output

A text file named `estimateK.res`. The file containes the output of running `chooseK.py` for
each replicate run. The results are separated by the marker '--', and so can
be easily split into separate files if necessary.

**Currently** the output of `fastStructure` and this script is directed to the same
directory where the script is being held. 

# Author

Anders Goncalves da Silva [andersgs at gmail dot com]


