
# Author: Frank Bosco

library(tidyverse)

#- Open the variable-level database (not containing effect sizes)
varDb <- read.csv("C:/Storage/Dropbox/alphaHacking/VarDB_2018_09_09.csv")

#- Remove NAs for reliability value
varDb <- filter(varDb, !is.na(Var1RelValue))

#- Remove reliability types other than alpha
varDb <- filter(varDb, tolower(Var1Alpha) == "y")

#- Subset dataframe
varDb <- varDb[,c("DOI", "journal", "ArticleID", "PubYear", "Var1", "Var1PathFB", "Var1N", "Var1RelValue", "Var1Locate")]

#- Read list of to-be-searched taxonomic IDs (Note: This DOES NOT remove any rows, it only attempts to classify the major topics requested in the CSV (e.g., attitudes, behaviors), and assigns "OTHER" to the unclassified)
queryList <- read.csv("C:/Storage/Dropbox/alphaHacking/shared/queryList.csv")

#--- Normalize metaBUS country names (Note: I can easily look up the country names to get a variety of values [e.g., Hofstede: Above vs. below mean IND/COL, UNM49 Region, Ronen & Shenkar's cultural clusters, etc.])
varDb$Var1Locate[varDb$Var1Locate == "Thailand "] <- "Thailand"
varDb$Var1Locate[varDb$Var1Locate == "Samoa "] <- "Samoa"
varDb$Var1Locate[varDb$Var1Locate == "Swaziland "] <- "Swaziland"
varDb$Var1Locate[varDb$Var1Locate == "australia"] <- "Australia"
varDb$Var1Locate[varDb$Var1Locate == "belgium"] <- "Belgium"
varDb$Var1Locate[varDb$Var1Locate == "italy"] <- "Italy"
varDb$Var1Locate[varDb$Var1Locate == "MIxed"] <- "Mixed"
varDb$Var1Locate[varDb$Var1Locate == "netherlands"] <- "Netherlands"
varDb$Var1Locate[varDb$Var1Locate == "NETHERLANDS"] <- "Netherlands"
varDb$Var1Locate[varDb$Var1Locate == "singapore"] <- "Singapore"
varDb$Var1Locate[varDb$Var1Locate == "Spain "] <- "Spain"
varDb$Var1Locate[varDb$Var1Locate == "turkey"] <- "Turkey"
varDb$Var1Locate[varDb$Var1Locate == "united kingdom"] <- "United Kingdom"
varDb$Var1Locate[varDb$Var1Locate == "United kingdom"] <- "United Kingdom"
varDb$Var1Locate[varDb$Var1Locate == "united States"] <- "United States"
varDb$Var1Locate[varDb$Var1Locate == "Korea, South"] <- "South Korea"
varDb <- filter(varDb, Var1Locate != "Scale ranges for variables X1-X8 span from 1 (low) to 5 (high). Scale ranges for variables X9 and X10 span from 0(low) to 1(high). More details on the measures appear in Appendix 1.")
varDb <- filter(varDb, Var1Locate != "A country in South East Asia")

table(varDb$Var1Locate)

#- Generate taxonomic categories
queryList_L3 <- queryList[queryList$level == 3,]
for (i in 1:nrow(queryList_L3)){
varDb$constructCat[grepl(as.character(queryList_L3[i,3]), varDb$Var1PathFB)] <- as.character(queryList_L3[i,2])
}
queryList_L2 <- queryList[queryList$level == 2,]
for (i in 1:nrow(queryList_L2)){
varDb$constructCat[grepl(as.character(queryList_L2[i,3]), varDb$Var1PathFB) & is.na(varDb$constructCat)] <- as.character(queryList_L2[i,2])
}
queryList_L1 <- queryList[queryList$level == 1,]
for (i in 1:nrow(queryList_L1)){
varDb$constructCat[grepl(as.character(queryList_L1[i,3]), varDb$Var1PathFB) & is.na(varDb$constructCat)] <- as.character(queryList_L1[i,2])
}
varDb$constructCat[is.na(varDb$constructCat)] <- "Z_Other"

nrow(varDb)
as.data.frame(table(varDb$constructCat))
nrow(varDb[is.na(varDb$constructCat),])
saveRDS(varDb, file = "C:/Storage/Dropbox/alphaHacking/shared/alphaDb_clean_metaBUS_2018_09_09.rds")
