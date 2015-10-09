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

# create plot
plot(feb$Time, feb$Sub_metering_1, type = "l", col="black", xlab = " ", ylab = "Energy sub metering", ylim = c(0, max(feb$Sub_metering_1)))
lines(feb$Time, feb$Sub_metering_2, col="red")
lines(feb$Time, feb$Sub_metering_3, col="blue")

legend("topright", lty = 1, cex=0.6, pt.cex=2, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

# copy plot to file
dev.copy(png, file="plot3.png")
dev.off()