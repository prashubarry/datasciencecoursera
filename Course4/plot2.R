# Plot 2

powerDT1 <- data.table::fread(input = "household_power_consumption.txt",
                              na.strings = "?")
# powerDT1[, Global_active_power := lapply(.SD, as.numeric), .SDcols = c("Global_active_power")]
# Change Date format to POSIXct date capable of being filtered by time of the day
powerDT1[, dateTime := as.POSIXct(paste(Date, Time), format = "%d/%m/%Y %H:%M:%S")]

# Filter Dates from 2007-02-01 and 2007-02-02.
powerDT1<-powerDT1[(dateTime >= "2007-02-01") & (dateTime <= "2007-02-03")]

png("plot2.png", width = 480, height = 480)

plot(x = powerDT1[, dateTime]
     , y = powerDT1[,Global_active_power]
     , type = "l", xlab = "", ylab = "Global Active Power (kilowatts)")

dev.off()