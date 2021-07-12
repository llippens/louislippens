library(readxl)
library(readr)
x <- read_xlsx("./data/corregisterv6.xlsx")
write_rds(x, "./data/corregisterv6.RDS")