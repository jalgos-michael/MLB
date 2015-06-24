# This code creates the initial SQLite data base containing all MLB data to 17th June 2015 using pitchRx

library(dplyr)
library(pitchRx)

setwd("/home/michael/MLB")

sink.reset <- function(){
	for(i in seq_len(sink.number())){
	sink(NULL)
	}
}

sink.reset()
sink(file="mlb_scrape.txt", split=TRUE)

# Create SQLite table		
mlb_db <- src_sqlite("pitchRx.sqlite3", #create=TRUE
	create=FALSE) 	# WARNING: create=TRUE overwrites existing file, only use once.

# Initiate scrape for entire Pitch F/X era. Note MLB releases data 1 day after game and allow for time difference with Paris.
# scrape(start="2008-01-01", end=Sys.Date()-2, connect=mlb_db$con)

# update_db(mlb_db$con) ¢ WARNING: seems to corrupt data when update fails.

# Check for write failures: scrape() exports batch to .csv if SQLite write fails.
scrape_export <- list.files(".", pattern="*export*)
if(length(scrape_export)>0 {
	export_dir<-paste("scrape_export",Sys.Date()-2,sep="_")	
	dir.create(export_dir)
	for(i in seq(along=scrape_export)){
		file.copy(scrape_export[i],export_dir)
		file.remove(scrape_export[i])
	}
}
	

