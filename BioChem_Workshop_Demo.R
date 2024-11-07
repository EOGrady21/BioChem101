# BioChem Demo

# How to connect to BioChem through R

# install.packages('ROracle')
library(ROracle)
library(tidyverse)

# load in your biochem credentials
source('c:/users/ogradye/desktop/biochem_creds.R')
# biochem.user <- 
# biochem.password <- 

# test connection
conn <- dbConnect(dbDriver("Oracle"), biochem.user, biochem.password, dbname = "PTRAN")

# try out a simple query
query <- "select * FROM biochem.discrete_data WHERE name = 'TEL2022010'" # note lack of ';'

# query BioChem
data <- dbGetQuery(conn, query)


# Let's try a more complicated query
cruisename <- 'BCD2022666'
query <- stringr::str_c(readLines('Query.sql'), collapse = " ")
query <- gsub(x = query, pattern = 'cruisename', replacement = cruisename)

# query BioChem
data <- dbGetQuery(conn, query)


# we can adjust the data, filter, or manipulate!

# Note that column types have been auto detected - dates will be in POSIXct format
# to export to csv, we can reformat dates
posixct_columns <- sapply(data, inherits, "POSIXct")
posixct_indices <- which(posixct_columns)

for (i in 1:length(posixct_indices)){
  data[[posixct_indices[[i]]]] <- as.character(format(data[[posixct_indices[[i]]]],
                                                      '%d-%b-%y'))
}

# Then we can export to csv
write.csv(data, 'BCD2022666_June_BioChem.csv', row.names = FALSE)



