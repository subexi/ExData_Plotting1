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
with(feb, plot(Time, Global_active_power, type="l", xlab = " ", ylab = "Global Active Power (kilowatts)"))

# copy plot to file
dev.copy(png, file="plot2.png")
dev.off()



