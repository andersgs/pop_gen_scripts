###############################################################################
### randomise_my_genotypes.R --- a script to generate random/admixed ge
###   genotypes
###
###  By Anders Goncalves da Silva
###############################################################################

###############################################################################
### IMPORTANT ASSUMPTIONS:
###
### 1. The infile must have extension .gen (e.g., my genepop_file.gen)
### 2. The file must be formatted in strict genepop format style. This
###   means that the locus list must not have the extra bits used by 
###   oneSamp:
###      Loc1, 2 # is NOT acceptable 
###      Loc2, 2 # is NOT acceptable
###      Loc3    # is acceptable
###      Loc4    # is acceptable
### 3. The output will be suitable for oneSamp, but assumes that all loci
###    are from dinucleotide repeat microsatellites
###############################################################################


####
# load libraries
# if you don't have the libraries run:
# install.packages(c("adegenet", "stringi", "data.table"))
library(adegenet)
library(stringi)
library(data.table)

####
# Variables you must set
# after setting the variables, select the whole script and run
infile = NULL # the path to your genpop file (e.g., /home/user/my.gen)
reps = NULL # an integer with how many random files you want to create (e.g., 100)
out_prefix = NULL # a string with the prefix to use when writing the 
                  # new genpop files ready for oneSamp. E.g., "random"
                  # if using "random", outfiles will be named "random_2.gen"
                  # where the digit is replicate number
seed = 889999 # if you want to reproduce what you did later


###############################################################################
#### DON'T EDIT PASS THIS POINT UNLESS YOU KNOW WHAT YOU ARE DOING! ###########
###############################################################################

#######
# The main function
randomise_my_genotypes <- function(infile, reps, out_prefix, seed) {
  #set the seed
  set.seed(seed)
  # loading and cleaning the data
  dat <- read.genepop(file = infile, ncode = 3)
  new_dat <- genind2df(dat, sep = "", oneColPerAll = T)
  new_dat <- data.table(new_dat[,-c(1)])
  # create L resampled lists
  n_loc <- 2*length(levels(dat@loc.fac))
  n_ind <- nrow(dat@tab)
  for (rep in 1:reps){
    print(paste("Generating replicate ", rep, sep = ""))
    randomised_order <- sapply(1:n_loc, function(i) sample(1:n_ind, replace = F))
    #create a new table of genotypes
    new_genos <- do.call(cbind, sapply(1:n_loc, function(i) {
      new_dat[randomised_order[,i], i, with = F]
    }))
    
    #format for output
    formated_genos <- paste0(apply(new_genos, 1, function(geno) {
      tmp <-  paste(geno, c("", " "), sep = "", collapse = "")
      tmp <- gsub(" $", "", tmp)
      tmp <- paste("Ind", paste0(sample(LETTERS, 6), collapse = ""), ", ", tmp, "\n", sep = "")
    }), 
    collapse = "")
    
    #generate the output
    outfn <- paste(out_prefix, "_", rep, ".gen", sep = "")
    title = paste("Random genotypes generated with randomise_my_genotypes.R:0.1 --- rep ", rep, "\n", sep = "")
    locs = paste(1:n_loc, ", 2", "\n", sep = "")
    pop = "pop\n"
    cat(title, locs, pop, formated_genos, file = outfn)
  }
}

randomise_my_genotypes(infile = infile, 
                       reps = reps, 
                       out_prefix = out_prefix, 
                       seed = seed)
