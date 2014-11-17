# Library Used 

library(nycflights13)
library(arules)
library(ggplot2)
library(arulesViz)

====================
  
# Flights dataset loaded with following command
data(flights)

====================
# Data prep

data satistics
dim(flights)
head(flights,5)
str(flights)
summary(flights)

====================
Use of association requires we turn the variables into factors
time is give in military format 2400 = 12am =0

convert time into  12hrs format

flights.clean$dep_time[flights.clean$dep_time==2400] = 0
flights.clean$arr_time[flights.clean$arr_time==2400] = 0


Convert variables into factor

flightsF = data.frame(origin = factor(flights.clean$origin),
                      carrier = factor(flights.clean$carrier))
flightsF$month = factor(flights.clean$month)
flightsF$dest=factor(flights.clean$dest)
flightsF$dep_hour = factor(trunc(flights.clean$dep_time/100))
flightsF$arr_hour = factor(trunc(flights.clean$arr_time/100))

plot some variables to decide how break down some variables into sub categories and then convert as factor

qplot(data=flights.clean,x=dep_delay,color='red') 
qplot(data=flights.clean,x=arr_delay,color='red')
qplot(data=flights.clean,x=air_time,color='red')
# set binwidth 

convert to categorical variables

flightsF$dep_delay=cut(flights.clean$dep_delay, breaks=c(-Inf,15,Inf),labels=c(no delay,delayed))
flightsF$arr_delay = cut(flights.clean$arr_delay,breaks = c(-Inf, 15, Inf),labels = c(no delay,delayed))
flightsF$air_time = cut(flights.clean$air_time,breaks = c(-Inf, 392, Inf),labels = c(below 392, above 392))
flightsF$distance = cut(flights.clean$distance, breaks = c(-Inf, 2408, Inf),labels = c(domestic flight,nternational flight))

============================
  
Association Rules

1. between Variables and dep_delay

lhs.vars = c('origin','carrier', 'air_time','distance',
             'month', 'dep_hour','arr_hour','dest')
rhs.var = 'dep_delay'
rhs.values = c('dep_delay=no delay',
               'dep_delay=delayed')
apriori.appearance = list(rhs=rhs.values,
                          default='lhs')
apriori.parameter = list(support=0.01,
                         confidence=0.01,
                         minlen=1,
                         maxlen=3)

rules = apriori(flightsF[,c(lhs.vars, rhs.var)],
                parameter=apriori.parameter,
                appearance=apriori.appearance)

rules.sorted.by.lift = sort(rules, by='lift')
inspect(rules.sorted.by.lift[1:20])

2. between variables and arr_delay

rhs.var1 = 'arr_delay'
rhs.values1 = c('arr_delay=no delay',
                'arr_delay=delayed')
apriori.appearance = list(rhs=rhs.values1,
                          default='lhs')
apriori.parameter = list(support=0.01,
                         confidence=0.01,
                         minlen=1,
                         maxlen=3)

rules1 = apriori(flightsF[,c(lhs.vars, rhs.var1)],
                 parameter=apriori.parameter,
                 appearance=apriori.appearance)

rules.sorted.by.lift1 = sort(rules1, by='lift')
inspect(rules.sorted.by.lift1[1:20])

==============================
plot analysis

plot(rules.sorted.by.lift[1:500])
plot(rules.sorted.by.lift1[1:500])

plot(rules.sorted.by.lift[1:20], method='graph',control=list(type='items'))
plot(rules.sorted.by.lift1[1:20], method='graph',control=list(type='items'))



