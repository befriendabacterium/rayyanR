# rayyanR
Work-in-progress 'package' to process Rayyan outputs in R

### Overview and installation

This is the development repository for RayyanR, a not-yet R 'package' to process dataframes outputted from the Rayyan screening platform for systematic review (https://rayyan.ai).

The only function, 'parse_rayyan()' can be sourced from this repository as
follows:

``` r
source("https://raw.githubusercontent.com/befriendabacterium/rayyanR/main/src/parse_rayyan.R")
```

### Issues and suggestions

Please report any issues and suggestions on the [issues
link](https://github.com/befriendabacterium/rayyanR/issues) for the repository.

### Package overview

Current a one-function ('parse_rayyan()')package to parse bibliographic dataframes outputted from Rayyan, splitting up the 'notes' column into Inclusion/Exclusion decision, Labels, and Exclusion Reasons. Very early stages so I go easy and I suggest you use the following pipeline with validation:

``` r
install.packages('synthesisr')
install.packages('plyr')
library(synthesisr)
library(plyr)

#read in a rayyan exported bibliography file
rayyan_biblio<-synthesisr::read_refs('https://raw.githubusercontent.com/befriendabacterium/rayyanR/main/example_inputs/tinea_update.ris')

#parse rayyan biblio
rayyan_biblio_cleaned<-parse_rayyan(rayyan_df = rayyan_biblio)

#print the outputs AND CHECK THEM AGAINST YOUR RAYYAN BIBLIOGRAPHY TO VALIDATE. The total number of records should remain the same and Inclusions and exclusions should equate straightforwardly. However, Maybes here (unlike in Rayyan) are only Maybes by if all reviewers marked them as so, and Conflicts include Maybe-Inclusion/Exclusion type conflicts (in Rayyan a 'conflict' is only an Inclusion-Exclusion type conflict).

summary_df<-plyr::count(rayyan_biblio_cleaned$finaldecision)
colnames(summary_df)<-c('decision','records_n')
print(summary_df)

```
