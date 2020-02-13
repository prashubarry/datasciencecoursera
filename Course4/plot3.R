# Plot 3
powerDT2 <- data.table::fread(input = "household_power_consumption.txt",
                              na.strings = "?")
# powerDT1[, Global_active_power := lapply(.SD, as.numeric), .SDcols = c("Global_active_power")]
# Change Date format to POSIXct date capable of being filtered by time of the day
powerDT2[, dateTime := as.POSIXct(paste(Date, Time), format = "%d/%m/%Y %H:%M:%S")]

# Filter Dates from 2007-02-01 and 2007-02-02.
powerDT2<-powerDT2[(dateTime >= "2007-02-01") & (dateTime <= "2007-02-03")]

png("plot3.png", width = 480, height = 480)

plot(powerDT2[, dateTime], powerDT2[, Sub_metering_1], type = "l", xlab = "", ylab = "Energy sub metering")
lines(powerDT2[, dateTime], powerDT2[, Sub_metering_2], col = "red")
lines(powerDT2[, dateTime], powerDT2[, Sub_metering_3], col = "blue")
legend("topright",
       col = c("black", "red", "blue")
       , c("Sub_metering_1 ","Sub_metering_2 ", "Sub_metering_3 ")
       , lty = c(1,1), lwd = c(1,1))
dev.off()