#Title: parse_rayyan 
#Author: Matt Lloyd Jones
#Date: 26/11/21
#Description: A function to parse bibliographic dataframes outputted from Rayyan, splitting up the 'notes' column into Inclusion/Exclusion decision, Labels, and Exclusion Reasons


# FUNCTION ----------------------------------------------------------------

#big ole messy function (beta) to remove any old inclusion labels from abstract screening (found in the labels or parsed as html paragraphs)
parse_rayyan<-function(rayyan_df){
  
  #1. Split the Rayyan markes (in the notes column) up into a list of their constituent parts (Inclusion decision, Label(s) and Exclusion Reasons)
  rayyanmarkers_split<-strsplit(rayyan_df$notes, split='| ', fixed=TRUE)  
  
  #2. Remove any relictual inclusion labels from previous screenings which may be found as free text in the Labels or parsed as HTML paragraphs (latter is a weird bug in the Rayyan output?)
  for (e in 1:length(rayyanmarkers_split)){
    
    #for each label vector in each element of the string, remove the old inclusion bit
    rayyanmarkers_split[[e]][grep('RAYYAN-LABELS|RAYYAN-EXCLUSION',rayyanmarkers_split[[e]])]<-sub("RAYYAN-INCLUSION.*", "", rayyanmarkers_split[[e]][grep('RAYYAN-LABELS|RAYYAN-EXCLUSION',rayyanmarkers_split[[e]])])
    
    #remove any old inclusion labels from abstract screening (parsed as paragraphs)
    rayyanmarkers_split<-lapply(rayyanmarkers_split, function(x) sub("<p>.*</p> ", "",x))
    
  }
  
  #3. Create separate vectors/new columns for Inclusion decisions, Labels and Exclusion decisions
  #grep the inclusion decisions from the list
  rayyan_df$rayyan_decisions<-as.character(lapply(rayyanmarkers_split, function(x) x[grep('RAYYAN-INCLUSION:',x)]))
  #tidying up: remove weird paragraph marker bit from inclusion decisions
  rayyan_df$rayyan_decisions<-sub('<p>','',rayyan_df$rayyan_decisions)
  #grep the labels from the list
  rayyan_df$rayyan_labels<-as.character(lapply(rayyanmarkers_split, function(x) x[grep('RAYYAN-LABELS:',x)]))
  #grep the exclusion reasons from the list
  rayyan_df$rayyan_exclusionreasons<-as.character(lapply(rayyanmarkers_split, function(x) x[grep('RAYYAN-EXCLUSION-REASONS:',x)]))
  
  #4. Remove the Rayyan label bit
  rayyan_df$rayyan_decisions<-gsub('RAYYAN-INCLUSION:','',rayyan_df$rayyan_decisions)
  rayyan_df$rayyan_labels<-gsub('RAYYAN-LABELS:','',rayyan_df$rayyan_labels)
  rayyan_df$rayyan_exclusionreasons<-gsub('RAYYAN-EXCLUSION-REASONS:','',rayyan_df$rayyan_exclusionreasons)
  
  #5. Do some tidying up where there's no label
  rayyan_df$rayyan_decisions[rayyan_df$rayyan_decisions=='character(0)']<-NA
  rayyan_df$rayyan_labels[rayyan_df$rayyan_labels=='character(0)']<-NA
  rayyan_df$rayyan_exclusionreasons[rayyan_df$rayyan_exclusionreasons=='character(0)']<-NA
  
  #6. Identify the three types conflicts (N.B. We include Maybes-Inclusion/Exclusion as 'conflicts' unlike Rayyan). Code is quite janky right now.
  conflicts1<-grep("Excluded.*Included|Included.*Excluded",rayyan_df$rayyan_decisions)
  conflicts2<-grep("Excluded.*Maybe|Maybe.*Excluded",rayyan_df$rayyan_decisions)
  conflicts3<-grep("Included.*Maybe|Maybe.*Included",rayyan_df$rayyan_decisions)
  conflicts<-c(conflicts1,conflicts2,conflicts3)
  
  #7. Create new column identifying the final decision
  
  #create blank final decision vector
  rayyan_df$finaldecision<-rep(NA,nrow(rayyan_df))
  
  #change final decision to Conflicts for conflicts
  rayyan_df$finaldecision[conflicts]<-'Conflict'
  
  #count where 2 reviewers decided include
  included<-which(lengths(regmatches(rayyan_df$rayyan_decisions,gregexpr('Included',rayyan_df$rayyan_decisions)))==2)
  #change final decision to Included for these
  rayyan_df$finaldecision[included]<-'Included'
  
  #count where 2 reviewers decided exclude
  excluded<-which(lengths(regmatches(rayyan_df$rayyan_decisions,gregexpr('Excluded',rayyan_df$rayyan_decisions)))==2)
  #change final decision to Excluded for these
  rayyan_df$finaldecision[excluded]<-'Excluded'
  
  #count where 2 reviewers decided Maybe
  maybe<-which(lengths(regmatches(rayyan_df$rayyan_decisions,gregexpr('Maybe',rayyan_df$rayyan_decisions)))==2)
  #change final decision to Excluded for these
  rayyan_df$finaldecision[maybe]<-'Maybe'
  
  #8. Return the cleaned dataframe
  return(rayyan_df)
  
}
