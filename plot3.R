## Unzip file
dname <- dir("data",full.names = T)
unzip(dname,exdir="data")

## Load data into data frame using fread
library(data.table)
dt <- fread("data/household_power_consumption.txt",sep=";",header=T)

## Convert first column to date format
set(dt, j = 1L, value = as.Date(dt[,Date],"%d/%m/%Y"))

## Subset
dts <- dt[Date=="2007-02-01" | Date=="2007-02-02"]

## Convert columns to numeric
cols <- names(dts)[3:8]
for (col in cols) set(dts, j = col, value = as.numeric(dts[[col]]))

# Make the datetime column
library(lubridate)
check <- strptime(dts[,Time],"%H:%M:%S")
dts[,datetime:=wday(dts$Date)+hour(check)/24
    +minute(check)/(24*60)]

## Plot3
png("plot3.png",width = 480,height = 480,units = "px")
plot(dts$datetime,dts$Sub_metering_1,type = "l",xlab="",
     ylab="Energy sub metering",xaxt="n")
axis(1,at=c(5,6,7),labels=c("Thu","Fri","Sat"))
lines(dts$datetime, dts$Sub_metering_2,col="Red")
lines(dts$datetime, dts$Sub_metering_3,col="Blue")
legend("topright",legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       col=c("Black","Red","Blue"),lty=1)
dev.off()