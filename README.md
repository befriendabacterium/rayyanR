
# rayyanR

[![Project Status: Active - The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![](https://img.shields.io/github/last-commit/befriendabacterium/rayyanR.svg)](https://github.com/befriendabacterium/rayyanR/commits/main)

R ‘package’ to process Rayyan outputs

### Overview and installation

RayyanR, an R ‘package’ to process dataframes outputted from the Rayyan
screening platform for systematic review (<https://rayyan.ai>).

``` r
remotes::install_github("https://github.com/befriendabacterium/rayyanR")
```

### Issues and suggestions

Please report any issues and suggestions on the [issues
link](https://github.com/befriendabacterium/rayyanR/issues) for the
repository.

### Package overview

Currently a one-function (‘parse_rayyan()’) package to parse
bibliographic dataframes outputted from Rayyan, splitting up the ‘notes’
column into Inclusion/Exclusion decision, Labels, and Exclusion Reasons.

``` r
#install.packages('synthesisr')
#install.packages('plyr')
library(synthesisr)
library(plyr)
```

``` r
library(rayyanR)
#read in a rayyan exported bibliography file (example here is the Tinea Update one from Rayyan)
rayyan_biblio<-synthesisr::read_ref('https://raw.githubusercontent.com/befriendabacterium/rayyanR/main/example_inputs/tinea_update.ris')

#parse rayyan biblio
rayyan_biblio_cleaned<-rayyanR::parse_rayyan(rayyan_df = rayyan_biblio)

#print the outputs AND CHECK THEM AGAINST YOUR RAYYAN BIBLIOGRAPHY TO VALIDATE. The total number of records should remain the same and Inclusions and exclusions should equate straightforwardly. However, Maybes here (unlike in Rayyan) are only Maybes by if all reviewers marked them as so, and Conflicts include Maybe-Inclusion/Exclusion type conflicts (in Rayyan a 'conflict' is only an Inclusion-Exclusion type conflict).
summary_df<-plyr::count(rayyan_biblio_cleaned$finaldecision)
colnames(summary_df)<-c('decision','records_n')
print(summary_df)
```
    ##   decision records_n
    ## 1 Conflict         1
    ## 2 Excluded         1
    ## 3 Included         2
    ## 4     <NA>        10

### Citing this package

Please cite this package as: Jones ML & Grainger MJ (2021). rayyanR: An R package to process outputs of the Rayyan screening platform for systematic reviews. <a href="https://github.com/befriendabacterium/rayyanR" target="_blank">https://github.com/befriendabacterium/rayyanR</a>.
