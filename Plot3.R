# Plot3

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


ElectricPowerConsumption[,c("Sub_metering_1","Sub_metering_2","Sub_metering_3" ):=
                           list(as.numeric(Sub_metering_1)
                                ,as.numeric(Sub_metering_2)
                                ,as.numeric(Sub_metering_3))]

ElectricPowerConsumption[,weekdayLabel:=weekdays(Date,abbreviate=T)]
ElectricPowerConsumption[,weekdayNum:=wday(Date)]

ElectricPowerConsumption[,timeOfDayMinutes:=minute(DateTime)+hour(DateTime)*60+second(DateTime)/60]

ElectricPowerConsumption[,unique(weekdayNum)]

ElectricPowerConsumption[,timeofWeekMinuts:=timeOfDayMinutes+(weekdayNum-5)*24*60]

setkey(ElectricPowerConsumption,weekdayNum,timeofWeekMinuts)

png(file=OUTPUT_DIR%+%"/plot3.png")
plot(ElectricPowerConsumption[,timeofWeekMinuts], ElectricPowerConsumption[,Sub_metering_1]
     ,type="l"
     ,ylab="Energy sub meetings"
     ,xlab=""
     ,xaxt="n"
)
par(new=T)

points(ElectricPowerConsumption[,timeofWeekMinuts], ElectricPowerConsumption[,Sub_metering_2]
       ,type="l"
       ,col="red"
)

par(new=T)
points(ElectricPowerConsumption[,timeofWeekMinuts], ElectricPowerConsumption[,Sub_metering_3]
       ,type="l"
       ,col="blue"
)
par(new=F)
marks=c(0,24*60,24*60*2)
axis(1,at=marks,labels=c("Thu","Fri","Sat"))

legend("topright",lty=c(1,1,1),
       col=c("black","red","blue"),
       legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3" ),
       cex=.7)
dev.off()