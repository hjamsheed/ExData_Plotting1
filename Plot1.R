# Plot1

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

ElectricPowerConsumption[,Date:=as.Date(Date, format="%d/%m/%Y")]

ElectricPowerConsumption=ElectricPowerConsumption[between(Date, "2007-02-01", "2007-02-02"),]

ElectricPowerConsumption[,wday(Date)]

ElectricPowerConsumption[,Global_active_power:=as.numeric(Global_active_power)]


png(file=OUTPUT_DIR%+%"/plot1.png")
hist(ElectricPowerConsumption[,Global_active_power],col="red"
     , freq=T,xlab="Global Active Power(kilowatts)"
     , main="Global Active Power")
dev.off()
