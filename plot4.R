## R script for plot 4
##fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip?accessType=DOWNLOAD"
##download.file(fileUrl, destfile = "household_power_consumption.zip")
library(dplyr)
library(lubridate)
library(datasets)

##read table to data frame.
##used read.table instead of fread since POSIXlt is not compatible with data.tables
##ensure strings are not converted to factors
dt_hhp <- read.table("household_power_consumption.txt", header = TRUE, sep=";", stringsAsFactors = FALSE
                     , na.strings = "?")

##convert fields to numeric.
dt_hhp$Global_active_power <- as.numeric(dt_hhp$Global_active_power)
dt_hhp$Global_reactive_power <- as.numeric(dt_hhp$Global_reactive_power)
dt_hhp$Voltage <- as.numeric(dt_hhp$Voltage)
dt_hhp$Global_intensity <- as.numeric(dt_hhp$Global_intensity)
dt_hhp$Sub_metering_1 <- as.numeric(dt_hhp$Sub_metering_1)
dt_hhp$Sub_metering_2 <- as.numeric(dt_hhp$Sub_metering_2)
dt_hhp$Sub_metering_3 <- as.numeric(dt_hhp$Sub_metering_3)

##create new field by combining date and time
##convert this to POSIXlt to easily determine day of week
dt_hhp$Datetime <- paste(dt_hhp$Date, dt_hhp$Time)
dt_hhp$Datetime <- strptime(dt_hhp$Datetime, "%d/%m/%Y %H:%M:%S")
dt_hhp$Weekday <- lubridate::wday(dt_hhp$Datetime, label = TRUE, abbr = TRUE)

##subset the data to plot
dt_subset <- subset(dt_hhp, Date == "2/2/2007" | Date == "1/2/2007")

##set graphics device to png
png("plot4.png", width = 480, height = 480)
par(mfcol = c(2,2), mar = c(4,4,2,1))


##contruct the 1st line chart
with(dt_subset, plot(Global_active_power, type = "l", xlab = "", ylab = "Global Active Power (kilowatts)", xaxt = "n"))
##set axis labels at start of each day using (60*24 = 1440), since measurements are
##taken every minute
axis(1, c(1, 1440, 2880), c("Thu", "Fri", "Sat"))
axis(2, c(0, 2, 4, 6), c("0", "2", "4", "6"))

##contruct the 2nd line chart
with(dt_subset, plot(Sub_metering_1, type = "l", xlab = "", ylab = "Energy Sub Metering", xaxt = "n"))
##add multiple series to plot
lines(dt_subset$Sub_metering_2, type = "l", col = 2)
lines(dt_subset$Sub_metering_3, type = "l", col = 4)
##set axis labels at start of each day using (60*24 = 1440), since measurements are
##taken every minute
axis(1, c(1, 1440, 2880), c("Thu", "Fri", "Sat"))
##add legend
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
       , lty = c(1,1,1), col = c(1,2,4)
       , bty = "n")

##contruct the 3rd line chart
with(dt_subset, plot(Voltage, type = "l", xlab = "datetime", ylab = "Voltage", xaxt = "n"))
axis(1, c(1, 1440, 2880), c("Thu", "Fri", "Sat"))

##contruct the 4th line chart
with(dt_subset, plot(Global_reactive_power, type = "l", xlab = "datetime", ylab = "Global_reactive_power", xaxt = "n"))
axis(1, c(1, 1440, 2880), c("Thu", "Fri", "Sat"))

##close png graphics device
dev.off()