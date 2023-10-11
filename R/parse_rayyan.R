#' parse_rayyan
#' @description A function to parse bibliographic dataframes outputted from Rayyan, splitting up the 'notes' column into Inclusion/Exclusion decision, Labels, and Exclusion Reasons
#' @details big ole messy function (beta) to remove any old inclusion labels from abstract screening (found in the labels or parsed as html paragraphs)
#' @author Matt Lloyd Jones
#' @param rayyan_df A rayyan exported bibliography file
#' @param nR Minimum number of reviewers for a decision (default is equals to or greater than 2)
#' @return A dataframe 
#' @export
parse_rayyan<-function(rayyan_df, nR=2){
  
  #1. Remove any old inclusion labels from previous screenings abstract screening (parsed as paragraphs)
  rayyan_df$notes<-sub("<p>.*</p> ","",rayyan_df$notes)
  
  #2. Split the Rayyan markers (in the notes column) up into a list of their constituent parts (Inclusion decision, Label(s) and Exclusion Reasons)
  rayyanmarkers_split<-strsplit(rayyan_df$notes, split='| ', fixed=TRUE)  
  
  #3. Remove any old inclusion labels from previous screenings which may be found as free text in the Labels
  for (e in 1:length(rayyanmarkers_split)){
    
    #for each label vector in each element of the string, remove the old inclusion bit
    rayyanmarkers_split[[e]][grep('RAYYAN-LABELS|RAYYAN-EXCLUSION',rayyanmarkers_split[[e]])]<-sub("RAYYAN-INCLUSION.*", "", rayyanmarkers_split[[e]][grep('RAYYAN-LABELS|RAYYAN-EXCLUSION',rayyanmarkers_split[[e]])])
    
  }
  
  #4. Create separate vectors/new columns for Inclusion decisions, Labels and Exclusion decisions
  #grep the inclusion decisions from the list
  rayyan_df$rayyan_decisions<-as.character(lapply(rayyanmarkers_split, function(x) x[grep('RAYYAN-INCLUSION:',x)]))
  #tidying up: remove weird paragraph marker bit from inclusion decisions
  rayyan_df$rayyan_decisions<-sub('<p>','',rayyan_df$rayyan_decisions)
  #grep the labels from the list
  rayyan_df$rayyan_labels<-as.character(lapply(rayyanmarkers_split, function(x) x[grep('RAYYAN-LABELS:',x)]))
  #grep the exclusion reasons from the list
  rayyan_df$rayyan_exclusionreasons<-as.character(lapply(rayyanmarkers_split, function(x) x[grep('RAYYAN-EXCLUSION-REASONS:',x)]))
  
  #5. Remove the Rayyan label bit
  rayyan_df$rayyan_decisions<-gsub('RAYYAN-INCLUSION:','',rayyan_df$rayyan_decisions)
  rayyan_df$rayyan_labels<-gsub('RAYYAN-LABELS:','',rayyan_df$rayyan_labels)
  rayyan_df$rayyan_exclusionreasons<-gsub('RAYYAN-EXCLUSION-REASONS:','',rayyan_df$rayyan_exclusionreasons)
  
  #6. Do some tidying up where there's no label
  rayyan_df$rayyan_decisions[rayyan_df$rayyan_decisions=='character(0)']<-NA
  rayyan_df$rayyan_labels[rayyan_df$rayyan_labels=='character(0)']<-NA
  rayyan_df$rayyan_exclusionreasons[rayyan_df$rayyan_exclusionreasons=='character(0)']<-NA
  
  #7. Identify the three types conflicts (N.B. We include Maybes-Inclusion/Exclusion as 'conflicts' unlike Rayyan). Code is quite janky right now.
  conflicts1<-grep("Excluded.*Included|Included.*Excluded",rayyan_df$rayyan_decisions)
  conflicts2<-grep("Excluded.*Maybe|Maybe.*Excluded",rayyan_df$rayyan_decisions)
  conflicts3<-grep("Included.*Maybe|Maybe.*Included",rayyan_df$rayyan_decisions)
  conflicts<-c(conflicts1,conflicts2,conflicts3)
  
  #8. Create new column identifying the final decision
  
  #create blank final decision vector
  rayyan_df$finaldecision<-rep(NA,nrow(rayyan_df))
  
  #change final decision to Conflicts for conflicts
  rayyan_df$finaldecision[conflicts]<-'Conflict'
  
  #count where 2 reviewers decided include
  included<-which(lengths(regmatches(rayyan_df$rayyan_decisions,gregexpr('Included',rayyan_df$rayyan_decisions)))>=nR)
  #change final decision to Included for these
  rayyan_df$finaldecision[included]<-'Included'
  
  #count where 2 reviewers decided exclude
  excluded<-which(lengths(regmatches(rayyan_df$rayyan_decisions,gregexpr('Excluded',rayyan_df$rayyan_decisions)))>=nR)
  #change final decision to Excluded for these
  rayyan_df$finaldecision[excluded]<-'Excluded'
  
  #count where 2 reviewers decided Maybe
  maybe<-which(lengths(regmatches(rayyan_df$rayyan_decisions,gregexpr('Maybe',rayyan_df$rayyan_decisions)))>=nR)
  #change final decision to Excluded for these
  rayyan_df$finaldecision[maybe]<-'Maybe'
  
  #9. Return the cleaned dataframe
  return(rayyan_df)
  
}
