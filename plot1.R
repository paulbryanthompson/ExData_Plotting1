## R script for plot 1
##only uncomment the next two lines when downloading the data for the first time!
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

##contruct the line chart
hist(dt_subset$Global_active_power
     , main = "Global Active Power"
     , xlab = "Global Active Power (kilowatts)"
     , col = "red")

##export to png
dev.copy(png, file="plot1.png")
dev.off()

