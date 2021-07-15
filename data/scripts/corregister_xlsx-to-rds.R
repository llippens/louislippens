library(readxl)
library(readr)
x <- read_xlsx("C:/Users/lglippen/Documents/Personal blog/louislippens/data/corregister.xlsx")
write_rds(x, "C:/Users/lglippen/Documents/Personal blog/louislippens/data/corregister.RDS")