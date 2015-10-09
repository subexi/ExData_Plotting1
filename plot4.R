library(dplyr)
# read data file
file <- tbl_df(read.table("household_power_consumption.txt", header=TRUE, sep= ";", na.strings = c("?","")))

# convert col Date
file$Date <- as.Date(file$Date, format = "%d/%m/%Y")

#create temporary col to combine Date and Time
file$timetemp <- paste(file$Date, file$Time)

# convert col Time into POSIXct object
file$Time <- as.POSIXct(strptime(file$timetemp, format = "%Y-%m-%d %H:%M:%S"))

# filter the requested two days in to separate tables
feb01<-filter(file, Date == "2007-02-01")
feb02<-filter(file, Date == "2007-02-02")

# join the two days
feb<- full_join(feb01, feb02)

# delete temporary col
feb<- subset(feb, select=-timetemp)

# create plots
# get them right as png
png("plot4.png", width = 480, height=480)

# two rows with two columns
par(mfrow = c(2, 2))

# Top left
with(feb, plot(Time, Global_active_power, type="l", xlab = " ", ylab = "Global Active Power (kilowatts)"))

# Top right
with(feb, plot(Time, Voltage, type="l", xlab = "datetime", ylab = "Voltage"))

# Bottom left
plot(feb$Time, feb$Sub_metering_1, type = "l", col="black", xlab = " ", ylab = "Energy sub metering", ylim = c(0, max(feb$Sub_metering_1)))
lines(feb$Time, feb$Sub_metering_2, col="red")
lines(feb$Time, feb$Sub_metering_3, col="blue")
legend("topright", lty = 1, bty = "n", cex=0.7, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

# Bottom right
with(feb, plot(Time, Global_reactive_power, type="h", xlab = "datetime"))

# finish output
dev.off()