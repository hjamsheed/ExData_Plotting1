# Plot2

rm(list=ls())

library(data.table)
library(lubridate)

"%+%" <- function(a,b){paste0(a,b)}

PROJ_DIR=getwd()
DATA_DIR= PROJ_DIR%+% "/data"
OUTPUT_DIR=PROJ_DIR%+% "/output"


if(!file.exists(OUTPUT_DIR)){dir.create(OUTPUT_DIR)}

ElectricPowerConsumption <-fread(DATA_DIR%+%"/household_power_consumption.txt",na.strings="NA"
                                 ,colClasses=c("character","numeric","numeric","numeric","numeric","numeric"
                                               ,"numeric","numeric","numeric"))



ElectricPowerConsumption[,DateTime:=parse_date_time(Date%+% " "%+% Time,"%d/%m/%Y %H:%M:%S")]

ElectricPowerConsumption[,Date:=as.Date(Date, format="%d/%m/%Y")]
ElectricPowerConsumption=ElectricPowerConsumption[between(Date, "2007-02-01", "2007-02-02"),]




ElectricPowerConsumption[,weekdayLabel:=weekdays(Date,abbreviate=T)]
ElectricPowerConsumption[,weekdayNum:=wday(Date)]

ElectricPowerConsumption[,timeOfDayMinutes:=minute(DateTime)+hour(DateTime)*60+second(DateTime)/60]

ElectricPowerConsumption[,unique(weekdayNum)]

ElectricPowerConsumption[,timeofWeekMinuts:=timeOfDayMinutes+(weekdayNum-5)*24*60]

setkey(ElectricPowerConsumption,weekdayNum,timeofWeekMinuts)

png(file=OUTPUT_DIR%+%"/plot2.png")
plot(ElectricPowerConsumption[,timeofWeekMinuts], ElectricPowerConsumption[,Global_active_power]
     ,type="l"
     ,ylab="Global Active Power(kilowatts)"
     ,xlab=""
     ,xaxt="n"
)

marks=c(0,24*60,24*60*2)
axis(1,at=marks,labels=c("Thu","Fri","Sat"))
dev.off()