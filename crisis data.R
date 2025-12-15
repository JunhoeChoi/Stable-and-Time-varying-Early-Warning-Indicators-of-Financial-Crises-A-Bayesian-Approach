install.packages("tidyverse")
install.packages("haven")
install.packages("lubridate")

library("tidyverse")
library("haven")
library("lubridate")

JST.org <- 
  read_dta("http://data.macrohistory.net/JST/JSTdatasetR5.dta")

JST.org %>% filter(JST.org$crisisJST!=JST.org$crisisJST_old) %>% View()
#Variables that we are using
# iy:         investment to GDP ratio
# ca :        Current account (nominal, local currency)
# narrowm:    Narrow money (nominal, local currency)
# money:      Broad money (nominal, local currency)
# hpnom       House prices (nominal index, 1990=100)
# debtgdp     Public debt-to-GDP ratio
# xrusd       USD exchange rate (local currency/USD)
# tloans      Total loans to non-financial private sector (nominal, local currency)
# tmort       Mortgage loans to non-financial private sector (nominal, local currency)
# thh         Total loans to households (nominal, local currency)
# bdebt       Corporate debt (nominal, local currency)
# eq_tr       Equity total return, nominal. r[t] = [[p[t] + d[t]] / p[t-1] ] - 1
# housing_tr     Housing total return, nominal. r[t] = [[p[t] + d[t]] / p[t-1] ] - 1
# bond_tr     Government bond total return, nominal. r[t] = [[p[t] + coupon[t]] / p[t-1] ] - 1
# bill_rate   Bill rate, nominal. r[t] = coupon[t] / p[t-1]
# eq_dp       Equity dividend yield. dp[t] = dividend[t]/p[t]
# ltd         Banks, loans-to-deposits ratio (in %)















df.JST.normalized
names(df.JST.normalized)
unique(df.JST.normalized$country)
# 18 countries 
# "Australia"   "Belgium"     "Canada"      "Denmark"     "Finland"     "France"     
# "Germany"     "Ireland"     "Italy"       "Japan"       "Netherlands" "Norway"     
# "Portugal"    "Spain"       "Sweden"      "Switzerland" "UK"          "USA"        




f.crisis.baseline <- 
  df.JST.normalized %>% 
  select(year, country, crisis, 
         # macro variables
         starts_with("diff.credit"),
         starts_with("level.slope"),
         starts_with("growth.cpi"),
         starts_with("diff.money"),
         starts_with("growth.equity"),
         starts_with("growth.hpreal"),
         starts_with("diff.iy"),
         diff.ca.dom,
         diff.dsr.dom,
         # bank balance sheet variables
         starts_with("level.lev")
  ) %>% 
  na.omit()

names(f.crisis.baseline)

f.crisis.baseline %>% 
  filter(crisis==1)%>%
  ggplot(aes(x=year,y=diff.credit.dom,color=country))+
  geom_point(size=5, alpha=0.5)

f.crisis.baseline %>% 
  filter(crisis==0)%>%
  ggplot(aes(x=year,y=diff.credit.dom,color=country))+
  geom_point(size=5, alpha=0.5)

f.crisis.baseline %>% 
  #filter(crisis==0)%>%
  ggplot(aes(x=year,y=level.lev.dom,color=crisis))+
  geom_point(size=3, alpha=0.5)

f.crisis.baseline %>% 
  #filter(crisis==0)%>%
  ggplot(aes(x=year,y=diff.credit.dom,color=crisis))+
  geom_point(size=3, alpha=0.5)

f.crisis.baseline %>% 
  #filter(crisis==1)%>%
  ggplot(aes(x=year,y=,color=country))+
  geom_point(size=5, alpha=0.5)

View(f.crisis.baseline)
write.csv(f.crisis.baseline, "/Users/choejunhoe/Desktop/Special Project/data/JST_final.csv")



