# BioChem Demo

# How to connect to BioChem through R

# install.packages('ROracle')
library(ROracle)
library(tidyverse)

# load in your biochem credentials - DO NOT load this file to github
source('biochem_creds.R')

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

# Look at the replicates the averaged records:

query <- paste(scan(file='Query_replicates.sql', what=ls(), sep="\n"), collapse=" ")
query <- gsub(x = query, pattern = 'cruisename', replacement = cruisename)
data2 <- dbGetQuery(conn, query)



