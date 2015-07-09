## R script for plot 1
##fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip?accessType=DOWNLOAD"
##download.file(fileUrl, destfile = "household_power_consumption.zip")
library(dplyr)
library(lubridate)
library(data.table)
dt_hhp <- read.table("household_power_consumption.txt", header = TRUE, sep=";", stringsAsFactors = FALSE
                , na.strings = "?")
dt_hhp$Global_active_power <- as.numeric(dt_hhp$Global_active_power)
dt_hhp$Global_reactive_power <- as.numeric(dt_hhp$Global_reactive_power)
dt_hhp$Voltage <- as.numeric(dt_hhp$Voltage)
dt_hhp$Global_intensity <- as.numeric(dt_hhp$Global_intensity)
dt_hhp$Sub_metering_1 <- as.numeric(dt_hhp$Sub_metering_1)
dt_hhp$Sub_metering_2 <- as.numeric(dt_hhp$Sub_metering_2)
dt_hhp$Sub_metering_3 <- as.numeric(dt_hhp$Sub_metering_3)
dt_hhp$Datetime <- paste(dt_hhp$Date, dt_hhp$Time)
dt_hhp$Datetime <- strptime(dt_hhp$Datetime, "%d/%m/%Y %H:%M:%S")

dt_test <- dt_hhp
dt_test$Weekday <- lubridate::wday(dt_test$Datetime, label = TRUE, abbr = TRUE)
dt_subset <- subset(dt_test, Date == "2/2/2007" | Date == "1/2/2007")
hist(dt_subset$Global_active_power, main = "Global Active Power", xlab = "Global Active Power (kilowatts)", col = "red")


