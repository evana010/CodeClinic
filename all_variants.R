#!/bin/Rscript
library(conflicted)  
library(readr)
library(tidyverse)
conflict_prefer("filter", "dplyr")
conflict_prefer("lag", "dplyr")

#create list of file names
filenames <- list.files('/data/home/hhz060/Exomiser_variants')
#create empty array to append files to
all_var <- data.frame()
all_rank <- data.frame()

#read in files and append to empty dataframe
for (i in filenames) {
  df <- data.frame(read_tsv(paste0('/data/home/hhz060/Exomiser_variants/',i), show_col_types = FALSE))
  rank <- df %>% select(ID, RANK)
  df_col_rem <- df %>% select(ID, RS_ID, GENE_SYMBOL, CONTIG, FUNCTIONAL_CLASS, EXOMISER_ACMG_CLASSIFICATION, HGVS, ALL_PATH, MAX_FREQ, EXOMISER_VARIANT_SCORE)
  all_var <- rbind(all_var, df_col_rem)
  all_rank <- rbind(all_rank, rank)
}

#remove duplicate entries
all_var_dup_rem <- unique(all_var)

#create list of all variants
variants <- as.vector(all_var_dup_rem$ID)
#empty list to append variant count to
var_count <- data.frame()
rank_list_all <- c()

# count variants in all samples
for (variant in variants){
  var_count <- rbind(var_count, sum(str_detect(all_var$ID, variant)))
  rank_list <- all_rank %>% subset(ID == variant) %>% pull(RANK)
  rank_list_all <- append(rank_list_all, paste(rank_list, collapse=", "))
}

# add variant count to df
all_var_count <- cbind(all_var_dup_rem, var_count)
all_var_count <- cbind(all_var_count, rank_list_all)
names(all_var_count)[names(all_var_count) == 'X27L'] <- 'VARIANT_COUNT'
names(all_var_count)[names(all_var_count) == 'rank_list_all'] <- 'RANK_LIST'

# merge genotype from each VCF to df
for (i in filenames) {
  df <- data.frame(read_tsv(paste0('/data/home/hhz060/Exomiser_variants/',i), show_col_types = FALSE))
  df <- df %>% select(ID, GENOTYPE)
  names(df)[names(df) == 'GENOTYPE'] <- i
  all_var_count <- merge(x = all_var_count, y = df, by = "ID", all = TRUE)
}

all_var_count <- unique(all_var_count)

# write to csv
write.csv(all_var_count, "/data/home/hhz060/All_variants/all_variants.csv")
