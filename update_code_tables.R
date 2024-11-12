
# Generate most recent code tables from BioCHEM

rm(list=ls())
library(ROracle)
library(tidyverse)

# load in your biochem credentials
source('biochem_creds.R')

# create a subfolder to store code tables
dir.create("code_tables", showWarnings=FALSE)

# create connection to BioCHEM
conn <- dbConnect(dbDriver("Oracle"), biochem.user, biochem.password, dbname = "PTRAN")

# list of tables to read
tables <- c('BCACTIVITIES','BCANALYSES','BCCOLLECTIONMETHODS','BCDATACENTERS','BCDATARETRIEVALS','BCDATATYPECLASSES','BCDATATYPES','BCDERIVATIONS','BCGEARS','BCLIFEHISTORIES','BCMISSIONS','BCNATNLTAXONCODES','BCPRESERVATIONS','BCPROCEDURES','BCQUALCODES','BCSAMPLEHANDLINGS','BCSEXES','BCSTORAGES','BCTROPHICDESCRIPTORS','BCUNITS','BCVOLUMEMETHODS')

# for each table, read the contents and write to csv file in the "code_tables" subfolder
for (table in tables) {
  query <- paste0("SELECT DISTINCT biochem.",table,".* FROM biochem.",table)
  data <- dbGetQuery(conn, query)
  write.csv(data, file=paste0("code_tables/",table,"_",format(Sys.Date(),"%Y%m%d"),".csv"), row.names=FALSE, na="")
}
