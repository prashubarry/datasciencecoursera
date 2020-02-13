library("data.table")
setwd("H:\\pdf\\knowledge\\Knowledge\\RCoursera\\datasciencecoursera\\Course4\\")
# Read the data from the  file
powerDT <- data.table::fread(input = "household_power_consumption.txt",
                             na.strings = "?")

# powerDT[, Global_active_power := lapply(.SD, as.numeric), .SDcols = c("Global_active_power")]
# Check the data type of date variable
class(powerDT$Date) #character data type
# Change the Date column from character data type to Date data type
powerDT[, Date := lapply(.SD, as.Date, "%d/%m/%Y"), .SDcols = c("Date")]
# Changed date column data type check
class(powerDT$Date)
# Filter Dates from 2007-02-01 and 2007-02-02.
powerDT<-powerDT[(Date >= "2007-02-01") & (Date <= "2007-02-02")]

png("plot1.png", width  = 480, height = 480)

# Plot 1
hist(powerDT[, Global_active_power], main = "Global Active Power"
     , xlab = "Global Active Power (kilowatts)", ylab = "Frequency", col = "Red")

dev.off()
