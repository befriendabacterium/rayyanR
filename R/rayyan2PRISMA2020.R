#' rayyan2PRISMA2020
#'
#' gets a review from the rayyan API and outputs the results a tidied R object
#' @param identification_databases a list of search databases
#' @param identification_duplicates dataframe of duplicates
#' @param screening_recordsandreports dataframe of review results for all screened records produced by rayyanR::reviewresults, with results at both records and reports stage for each record
#' @param nofulltext_string string used for denoting no full text available
#' @param exclusionreasons_reports vector of strings for exclusion reasons to be tallied
#' @param included_studies_n number of included studies (not reports) at end
#' @keywords internal
#' @return the R object containing the result of the API call  
#' @export
rayyan2PRISMA2020<-function(identification_databases=NULL,
                            identification_duplicates=NULL,
                            screening_recordsandreports=NULL,
                            nofulltext_string = 'No full text available',
                            exclusionreasons_reports=NULL,
                            included_studies_n=NULL
                            ){

# CALCULATE NUMBERS FOR PRISMA ------------------------------------------------------------
  
## 1.1: PREVIOUS STUDIES -------------------------------------------------------
  
#Not applicable
  
## 1.2: RECORDS IDENTIFIED FROM DATABASES AND REGISTERS -------------------------------------------------------

#bind dataframes in list together
S1.2_database_results<-dplyr::bind_rows(identification_databases)
S1.2_database_results_n<-nrow(S1.2_database_results)
  
#paste together database names and nrows to get the string for the box
S1.2_database_specific_results_n<-paste(paste(names(identification_databases),', ',sapply(identification_databases, nrow),';', sep=''), collapse=' ')
S1.2_database_specific_results_n
  
## 1.3: RECORDS FROM DATABASES AND REGISTERS REMOVED BEFORE SCREENING --------------
  
S1.3_duplicates_n<-nrow(identification_duplicates)

## 2.2: ABSTRACT SCREENING: SCREENED RECORDS FROM DATABASES AND REGISTERS ------------------------------------------------------
  
S2.2_records_screened<-screening_recordsandreports
S2.2_records_screened_n<-nrow(S2.2_records_screened)
  
# abstracts_original_all_incdecs<-c("undecided"=0,"maybe"=0,"included"=0,"excluded"=0,"conflict"=0)

#records_screened_n<-sum(abstracts_original_all_incdecs)
  
#check search results minus duplicates equal number screened
(S1.2_database_results_n-S1.3_duplicates_n)==S2.2_records_screened_n
  
## 2.3: ABSTRACT SCREENING: EXCLUDED RECORDS RFROM DATABASES AND REGISTERS ------------------------------------------------------

S2.3_records_excluded<-S2.2_records_screened[S2.2_records_screened$record_decision_consensus=='excluded',]
S2.3_records_excluded_n<-nrow(S2.3_records_excluded)
  
#check records screened minus excluded equals reports sought for retrieval
(S2.2_records_screened_n-S2.3_records_excluded_n)==nrow(screening_recordsandreports)

## 3.2: FULL TEXT RETRIEVAL: RECORDS SOUGHT FROM DATABASES AND REGISTERS ------------------------------------------------------
  
#assign full texts to sought reports (equivalent in our implementation)
S3.2_sought_reports<-screening_recordsandreports[!is.na(screening_recordsandreports$fulltextscreening_id),]
S3.2_sought_reports_n<-nrow(S3.2_sought_reports)

#check records screened minus excluded equals reports sought for retrieval
(S2.2_records_screened_n-S2.3_records_excluded_n)==S3.2_sought_reports_n
  
## 3.3: FULL TEXT RETRIEVAL: RECORDS NOT RETRIVED FROM DATABASES AND REGISTERS ------------------------------------------------------
  
#reformat way Rayyan has in column names
nofulltext_colstring<-stringr::str_replace_all(nofulltext_string,' |/','.')
  
#make a 'column finder' vector by appending the column prefix
colfinder<-paste('report.*',nofulltext_colstring, sep='')
  
#identify columns holding the exclusion reasons
nofulltext_columns<-grep(colfinder,colnames(S3.2_sought_reports))

#make default not retrieved 0
S3.3_notretrieved_reports_n<-0

if(length(nofulltext_columns)!=0){

#dataframe of records for which full text was not retrieved
ifelse (is.na(nofulltext_columns),
  #if there is not a 'no full text' column (i.e. nofulltext_columns == NA) then make empty dataframe
  S3.3_notretrieved_reports<-data.frame(author=character()),
  #else if there is a 'no full text' column then subset out rows where no full text available (==1)
  S3.3_notretrieved_reports<-S3.2_sought_reports[which(S3.2_sought_reports[,nofulltext_columns]==1),])
  #number of not retrieved
  S3.3_notretrieved_reports_n<-nrow(S3.3_notretrieved_reports)
}

## 4.2: REPORTS ASSESSED FOR ELIGIBILITY ------------------------------------------------------

#make default not retrieved 0
S4.2_assessed_reports<-S3.2_sought_reports

if(length(nofulltext_columns)!=0){
  
#dataframe of records for which full text was not retrieved
ifelse (is.na(nofulltext_columns),
        #if there is not a 'no full text' column (i.e. nofulltext_columns == NA) then assessed reports equals all sought reports
        S4.2_assessed_reports<-S3.2_sought_reports,
        #else if there is a 'no full text' column then subset out rows where no full text available (==1)
        S4.2_assessed_reports<-S3.2_sought_reports[which(is.na(S3.2_sought_reports[,nofulltext_columns])),])
}

S4.2_assessed_reports_n<-nrow(S4.2_assessed_reports)
S4.2_assessed_reports_n
  
## 4.3: REPORTS EXCLUDED ------------------------------------------------------

S4.3_excluded_reports<-S4.2_assessed_reports[S4.2_assessed_reports$report_decision_consensus=='excluded',]
S4.3_excluded_reports_n<-nrow(S4.3_excluded_reports)
S4.3_excluded_reports_n

#reformat way Rayyan has in column names
exclusionreasons_colstrings<-stringr::str_replace_all(exclusionreasons_reports,' |/','.')

for (c in 1:length(exclusionreasons_colstrings)){
  
  #find matching columns
  matchingcols<-
    grep(exclusionreasons_colstrings[c],
         colnames(S4.3_excluded_reports))
  
  #if no matching columns...
  if(length(matchingcols)==0){
  #add the column for that exclusion reason to the dataframe, filled with zeros 
  S4.3_excluded_reports[,paste('report_label_',exclusionreasons_colstrings[c], sep='')]<-0
  }
  
  #if one matching column...
  if(length(matchingcols)==1){
    #make new column with right name, duplicated from old one with wrong name
    replacement<-S4.3_excluded_reports[,matchingcols]
    #delete original column to avoid confusion
    S4.3_excluded_reports[,matchingcols]<-NULL
    #replace with new column with right name
    S4.3_excluded_reports[,paste('report_label_',exclusionreasons_colstrings[c], sep='')]<-replacement
  }
  
  #if more than one matching columns (due to weird Rayyan behaviour that adds a reviewer ID for second reviewer in front of label if they labelled it such as well?)
  if(length(matchingcols)>1){
    
    #coalesce the columns into a single, temporary vector
    coalesced<-do.call(coalesce,S4.3_excluded_reports[,matchingcols])
    #delete both original columns to avoid confusion
    S4.3_excluded_reports[,matchingcols]<-NULL
    #replace with new column with right name
    S4.3_excluded_reports[,paste('report_label_',exclusionreasons_colstrings[c], sep='')]<-coalesced
  }
}

#make a 'column finder' vector by appending the column prefix
colfinder <- paste(paste("report.*", exclusionreasons_colstrings, 
                         sep = ""), collapse ='|')

#identify columns holding the exclusion reasons
exclusion_reason_columns<-grep(colfinder,colnames(S4.3_excluded_reports))

#tally up the reasons for exclusion
exclusion_reasons_tally<-colSums(S4.3_excluded_reports[,exclusion_reason_columns], na.rm=T)

#make names human readable again
names(exclusion_reasons_tally)<-exclusionreasons_reports
  
#check have exclusion reasons for all articles
  
#format in correct way for PRISMA
S4.3_exclusionreasons_reports_n<-paste(paste(names(exclusion_reasons_tally), ', ', exclusion_reasons_tally, ';', sep=''), collapse=' ')
  
## 5.2: REPORTS OF NEW INCLUDED STUDIES ------------------------------------------------------
  
S5.2_included_reports<-S4.2_assessed_reports[S4.2_assessed_reports$report_decision_consensus=='included',]
S5.2_included_reports_n<-nrow(S5.2_included_reports)
S5.2_included_reports_n
  
S5.2_included_studies_n<-included_studies_n
  
# FILL OUT PRISMA DATAFRAME: ASSESSED/EXCLUDED RECORDS FROM DATABASES AND REGISTERS ------------------------------------------------------

csvFile <- system.file("extdata", "PRISMA.csv", package = "PRISMA2020")
PRISMAdata <-read.csv(csvFile)

###1.2: FULL TEXT SCREENING: ASSESSED/EXCLUDED RECORDS FROM DATABASES AND REGISTERS ------------------------------------------------------

PRISMAdata$n[which(PRISMAdata$data=='database_results')]<-S1.2_database_results_n
PRISMAdata$n[which(PRISMAdata$data=='database_specific_results')]<-S1.2_database_specific_results_n

PRISMAdata$n[which(PRISMAdata$data=='register_results')]<-NA

## 1.3: RECORDS FROM DATABASES AND REGISTERS REMOVED BEFORE SCREENING --------------

#add to PRISMA data
PRISMAdata$n[which(PRISMAdata$data=='duplicates')]<-S1.3_duplicates_n

## 2.2: ABSTRACT SCREENING: SCREENED RECORDS FROM DATABASES AND REGISTERS ------------------------------------------------------

#add to PRISMA data
PRISMAdata$n[which(PRISMAdata$data=='records_screened')]<-S2.2_records_screened_n

## 2.3: ABSTRACT SCREENING: EXCLUDED RECORDS RFROM DATABASES AND REGISTERS ------------------------------------------------------

#add to PRISMA data
PRISMAdata$n[which(PRISMAdata$data=='records_excluded')]<-S2.3_records_excluded_n

## 3.2: FULL TEXT RETRIEVAL: RECORDS SOUGHT FROM DATABASES AND REGISTERS ------------------------------------------------------

#add to PRISMA data
PRISMAdata$n[which(PRISMAdata$data=='dbr_sought_reports')]<-S3.2_sought_reports_n

## 3.3: FULL TEXT RETRIEVAL: RECORDS NOT RETRIVED FROM DATABASES AND REGISTERS ------------------------------------------------------

#add to PRISMA data
PRISMAdata$n[which(PRISMAdata$data=='dbr_notretrieved_reports')]<-S3.3_notretrieved_reports_n

## 4.2: REPORTS ASSESSED FOR ELIGIBILITY ------------------------------------------------------

#add to PRISMA data
PRISMAdata$n[which(PRISMAdata$data=='dbr_assessed')]<-S4.2_assessed_reports_n

## 4.3: REPORTS EXCLUDED ------------------------------------------------------

PRISMAdata$n[which(PRISMAdata$data=='dbr_excluded')]<-S4.3_exclusionreasons_reports_n

## 5.2: REPORTS OF NEW INCLUDED STUDIES ------------------------------------------------------

PRISMAdata$n[which(PRISMAdata$data=='new_studies')]<-S5.2_included_studies_n
PRISMAdata$n[which(PRISMAdata$data=='new_reports')]<-S5.2_included_reports_n

# MAKE DIAGRAM ------------------------------------------------------------

library(PRISMA2020)
PRISMAdata_list<-PRISMA2020::PRISMA_data(PRISMAdata)
PRISMAdiagram<-PRISMA2020::PRISMA_flowdiagram(PRISMAdata_list, previous = F, detail_databases = T, other = F, fontsize = 12)

#append the list used to make the diagram to the object as handy to have
PRISMAdiagram[['data']]<-PRISMAdata

return(PRISMAdiagram)

}
