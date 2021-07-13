library(readxl)
library(readr)
x <- read_xlsx("./data/corregister.xlsx")
write_rds(x, "./data/corregister.RDS")