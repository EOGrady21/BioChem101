# BioChem Demo
# How to connect to BioChem through R

# # Install the ROracle library - the "Sys.setenv" functions below should set the paths to your copy of Oracle so ROracle can find the files it needs to install properly.
# Sys.setenv("OCI_LIB64" = "C:\\Oracle\\12.2.0_x64\\cli\\bin")
# Sys.setenv("OCI_INC" = "C:\\Oracle\\12.2.0_x64\\cli\\oci\\include")
# install.packages('ROracle')

library(ROracle)
library(tidyverse)

# load in your biochem credentials - DO NOT load this file to github
source('biochem_creds.R') # this file should contain the 2 lines below with your own biochem username and password
# biochem.user <- "YOUR_BIOCHEM_USERNAME"
# biochem.password <- "YOUR_BIOCHEM_PASSWORD"

# create connection
conn <- dbConnect(dbDriver("Oracle"), biochem.user, biochem.password, dbname = "PTRAN")


#************************

# write a simple query
query <- "SELECT * FROM biochem.bcdiscrete_mv WHERE name = 'TEL2022010'" # note lack of ';'

# query BioChem
data <- dbGetQuery(conn, query)

# print results
str(data)


#************************

# Let's try a more complicated query:

# read the sql file containing the query (the result is a string)
query <- paste(scan(file='Query.sql', what=ls(), sep="\n"), collapse=" ")

# replace the string "cruisename" in the query with the cruisename you define here
cruisename <- 'BCD2022666'
query <- gsub(x = query, pattern = 'cruisename', replacement = cruisename)

# query BioChem
data1 <- dbGetQuery(conn, query)


# we can adjust the data, filter, or manipulate!

# Note that column types have been auto detected - dates will be in POSIXct format
# to export to csv, we can reformat dates
posixct_columns <- sapply(data1, inherits, "POSIXct")
posixct_indices <- which(posixct_columns)

for (i in 1:length(posixct_indices)){
  data1[[posixct_indices[[i]]]] <- format(data1[[posixct_indices[[i]]]],'%d-%b-%y')
}

# Then we can export to csv
write.csv(data1, 'BCD2022666_June_BioChem.csv', row.names = FALSE)


#************************

# Look at the replicates of the averaged records:

# get all columns from the flat table
query <- "SELECT * FROM biochem.bcdiscrete_mv WHERE name = 'BCD2022666'"
data2a <- dbGetQuery(conn, query)

# get all columns from the replicates table
query <- paste(scan(file='Query_replicates.sql', what=ls(), sep="\n"), collapse=" ")
query <- gsub(x = query, pattern = 'cruisename', replacement = cruisename)
data2b <- dbGetQuery(conn, query)

# join the flat table to the replicates table
data2a <- data2a %>% 
  dplyr::rename(DISCRETE_VALUE=DATA_VALUE, DISCRETE_QC=DATA_QC_CODE) %>%
  dplyr::select(DISCRETE_DETAIL_SEQ, NAME, EVENT_START, HEADER_START_DEPTH,
                COLLECTOR_SAMPLE_ID, METHOD, DISCRETE_QC, DISCRETE_VALUE, AVERAGED_DATA)
data2b <- data2b %>%
  dplyr::rename(REPLICATE_VALUE=DATA_VALUE, REPLICATE_QC=DATA_QC_CODE) %>%
  dplyr::select(DISCRETE_DETAIL_SEQ, REPLICATE_QC, REPLICATE_VALUE)
data2 <- dplyr::full_join(data2a, data2b, by="DISCRETE_DETAIL_SEQ")

data2

