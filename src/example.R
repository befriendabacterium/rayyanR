# EXAMPLE SCRIPT ----------------------------------------------------------
# Uses the exported bibliography of the 'TINEA UPDATE' public review from Rayyan
rm(list=ls())

#install.packages('synthesisr')
#install.packages('plyr')
library(synthesisr)
library(plyr)

#source the 'parse_rayyan' function from github
source("https://raw.githubusercontent.com/befriendabacterium/rayyanR/main/src/parse_rayyan.R")

#read in a rayyan exported bibliography file (example here is the Tinea Update one from Rayyan)
rayyan_biblio<-synthesisr::read_ref('https://raw.githubusercontent.com/befriendabacterium/rayyanR/main/example_inputs/tinea_update.ris')

#parse rayyan biblio
rayyan_biblio_cleaned<-parse_rayyan(rayyan_df = rayyan_biblio)

#print the outputs AND CHECK THEM AGAINST YOUR RAYYAN BIBLIOGRAPHY TO VALIDATE. The total number of records should remain the same and Inclusions and exclusions should equate straightforwardly. However, Maybes here (unlike in Rayyan) are only Maybes by if all reviewers marked them as so, and Conflicts include Maybe-Inclusion/Exclusion type conflicts (in Rayyan a 'conflict' is only an Inclusion-Exclusion type conflict).

summary_df<-plyr::count(rayyan_biblio_cleaned$finaldecision)
colnames(summary_df)<-c('decision','records_n')
print(summary_df)
