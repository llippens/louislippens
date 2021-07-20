library(readxl)
library(readr)
# Correspondence test register data
x <- read_xlsx("C:/Users/lglippen/Documents/Personal blog/louislippens/data/corregister.xlsx")
write_rds(x, "C:/Users/lglippen/Documents/Personal blog/louislippens/data/corregister.RDS")

# Treatment classification data
y <- read_xlsx("C:/Users/lglippen/Documents/Personal blog/louislippens/data/treatmentclassification.xlsx")
write_rds(y, "C:/Users/lglippen/Documents/Personal blog/louislippens/data/treatmentclassification.RDS")