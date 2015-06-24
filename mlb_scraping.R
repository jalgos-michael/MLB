setwd("Coding/Jalgos/MLB")
# We want to create a log file to detect any scraping errors. Following is like Stata
# command capture(logclose)
sink.reset <- function(){
  for(i in seq_len(sink.number())){
    sink(NULL)
  }
}
sink.reset()
sink(file="mlb_scrape.txt", split=TRUE)

library(dplyr)
library(pitchRx)
#mlb_db <- src_sqlite("pitchRx.sqlite3", create = TRUE)
#scrape(start = "2008-01-01", end = Sys.Date()-2, connect = mlb_db$con)
#update_db(mlb_db$con)

#atbats<-tbl(mlb_db, 'atbat')  #Selects the atbat table

# Scrape exports batch to 
atbat_export_vars<-colnames(tbl(mlb_db,'atbat_export'))
scrape_atbat_export<-paste(list.files(path=".",pattern="atbat_export*"))
if (length(scrape_atbat_export)>0){
  for (i in 1:length(scrape_atbat_export)) {
    atbat_export_vars<-union(atbat_export_vars,names(read.csv(scrape_atbat_export[i],nrows=1)))
  }
}
atbat_vars<-colnames(tbl(mlb_db,'atbat'))
atbat_vars_missing<-setdiff(atbat_export_vars,atbat_vars)
for (i in 1:length(atbat_vars_missing)) {
  mutate(tbl(mlb_db,'atbat'),atbat_vars_missing[i])
}

# Housekeeping
if (length(scrape_export)>0) {
  export_dir<-paste("scrape_export","2015-06-17",sep="_")
  dir.create(export_dir)
  for (i in seq(along=scrape_export)){
    file.copy(scrape_export[i],"export_dir")
    file.remove(scrape_export[i])
  }
}


