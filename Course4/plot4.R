powerDT2 <- data.table::fread(input = "household_power_consumption.txt",
                              na.strings = "?")
# powerDT1[, Global_active_power := lapply(.SD, as.numeric), .SDcols = c("Global_active_power")]
# Change Date format to POSIXct date capable of being filtered by time of the day
powerDT2[, dateTime := as.POSIXct(paste(Date, Time), format = "%d/%m/%Y %H:%M:%S")]

# Filter Dates from 2007-02-01 and 2007-02-02.
powerDT2<-powerDT2[(dateTime >= "2007-02-01") & (dateTime <= "2007-02-03")]

# Plot 4
png("plot4.png", width = 480, height = 480)

par(mfrow= c(2,2))

# Plot 1
plot(powerDT2[, dateTime], powerDT2[, Global_active_power], type = "l", xlab="", ylab="Global Active Power")

# Plot 2
plot(powerDT2[, dateTime], powerDT2[, Voltage], type = "l", xlab ="dateTime", ylab = "Voltage")

# Plot 3
plot(powerDT2[, dateTime], powerDT2[, Sub_metering_1], type = "l", xlab = "", ylab = "Energy sub metering")
lines(powerDT2[, dateTime], powerDT2[, Sub_metering_2], col = "red")
lines(powerDT2[, dateTime], powerDT2[, Sub_metering_3], col = "blue")
legend("topright",
       col = c("black", "red", "blue")
       , c("Sub_metering_1 ","Sub_metering_2 ", "Sub_metering_3 ")
       , lty = c(1,1), lwd = c(1,1)
       , cex = .5)

# Plot 4
plot(powerDT2[, dateTime], powerDT2[, Global_reactive_power], type = "l", xlab= "dateTime", ylab = "Global Reacive Power")

dev.off()