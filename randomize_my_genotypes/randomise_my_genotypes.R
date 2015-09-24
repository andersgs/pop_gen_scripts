###############################################################################
### randomise_my_genotypes.R --- a script to generate random/admixed ge
###   genotypes
###
###  By Anders Goncalves da Silva
###############################################################################

####
# load libraries
library(adegenet)
library(stringi)

#####
# load your data
#   - assumes your data is in genepop format 
#
infile = "~/Downloads/1K_Aber_Lach_CatDam_data.txt"
if (grepl(pattern = "\\.txt$",x = infile)) {
  new_name = stri_replace(infile, replacement = "gen", regex = "txt")
  system(paste("mv", infile, new_name, sep = " "))
  infile = new_name
}

dat <- read.genepop(file = infile)

# create L resampled lists
n_loc <- length(levels(dat@loc.fac))
n_ind <- nrow(dat@tab)
randomised_order <- sapply(1:n_loc, function(i) sample(1:n_ind, replace = F))
dat_loc_list <- seploc(x = dat)
new_locs <- lapply(1:n_loc, function(i) {
  i = 1
  tmp <- dat_loc_list[[i]]@tab
  n_all <- ncol(tmp)
  n_entries <- length(tmp)
  randomised_order <- sample(1:n_entries, replace = F)
  new_tab <- sapply(1:n_all, function(i) tmp[randomised_order[,i],i])
  colnames(new_tab) <- colnames(tmp)
  new_tab
})
new_tab <- do.call(cbind, new_locs)
row.names(new_tab) <- 1:n_ind
new_dat <- genind(tab = new_tab, loc.fac = dat@loc.fac, loc.n.all = dat@loc.n.all, all.names = dat@all.names)
genind2df(new_dat)
