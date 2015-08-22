#Clean and merge trade data
library(dplyr)
library(readr)
library(reshape2)
options(scipen=999)
setwd("")

exports_all <- read_csv("exports_total.csv")
exports_all <- exports_all[c(2:10, 12:23, 25:53),]
exports_all <- melt(exports_all, id.vars = c("State"))
colnames(exports_all) <- c("state", "year", "exports_total")
exports_all$year <- rep(c(2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014), each = 50)
exports_all <- exports_all %>% filter(year >= 2008) %>% arrange(state, year)

imports_all <- read_csv("imports_total.csv")
imports_all <- imports_all[c(2:24, 26:32, 34:52, 54),]
imports_all <- melt(imports_all, id.vars = c("State"))
colnames(imports_all) <- c("state", "year", "imports_total")
imports_all$year <- rep(c(2008, 2009, 2010, 2011, 2012, 2013, 2014), each = 50)
imports_all <- imports_all %>% filter(year >= 2008) %>% arrange(state, year)

exports_china <- read_csv("exports_to_china.csv")
exports_china <- exports_china[c(-1, -28, -33, -54, -55),]
exports_china <- melt(exports_china, id.vars = c("State"))
colnames(exports_china) <- c("state", "year", "exports_china")
exports_china$year <- rep(c(2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014), each = 50)
exports_china <- exports_china %>% filter(year >= 2008) %>% arrange(state, year)

imports_china <- read_csv("imports_from_china.csv")
imports_china <- imports_china[c(-1, -31, -43, -54, -55),]
imports_china <- melt(imports_china, id.vars = c("State"))
colnames(imports_china) <- c("state", "year", "imports_china")
imports_china$year <- rep(c(2008, 2009, 2010, 2011, 2012, 2013, 2014), each = 50)
imports_china <- imports_china %>% filter(year >= 2008) %>% arrange(state, year)

trade_data <- cbind(exports_all, imports_all[,3], exports_china[,3], imports_china[,3])

econ <- read_csv("econ_stats.csv")
econ2 <- econ %>% filter(Description == "All industry total")
econ2 <- econ2[c(2:9, 11:52), c(2, 20:26)]
econ2 <- melt(econ2, id.vars = c("GeoName"))
colnames(econ2) <- c("state", "year", "GDP")
econ2$year <- rep(c(2008, 2009, 2010, 2011, 2012, 2013, 2014), each = 50)
econ2 <- econ2 %>% filter(year >= 2008) %>% arrange(state, year)

trade_data <- cbind(trade_data, econ2[,3])
colnames(trade_data) <- c("state", "year", "exports_total", "imports_total", "exports_china", "imports_china", "GDP_millions")
write.csv(trade_data, file = "trade_with_china_by_state.csv")
