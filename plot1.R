fileURL <-
    "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zipfilename <- file.path(getwd(), "household_power_consumption.zip")
filename <- file.path(getwd(), "household_power_consumption.txt")
plotimage <- file.path(getwd(), "plot1.png")

## Download and unzip the dataset:
if (!file.exists(filename)) {
    if (!file.exists(zipfilename)) {
        print("downloading")
        download.file(fileURL, zipfilename)
    }
    print("Unzipping")
    unzip(zipfilename)
    file.remove(zipfilename)
}

data <-
    read.table(
        "household_power_consumption.txt",
        header = TRUE,
        sep = ";",
        na.strings = "?",
        colClasses = c(
            'character',
            'character',
            'numeric',
            'numeric',
            'numeric',
            'numeric',
            'numeric',
            'numeric',
            'numeric'
        )
    )

## Format date to Type Date
data$Date <- as.Date(data$Date, "%d/%m/%Y")

## Filter data set from Feb. 1, 2007 to Feb. 2, 2007
data <-
    subset(data, Date >= as.Date("2007-2-1") &
               Date <= as.Date("2007-2-2"))

## Remove incomplete observation
data <- data[complete.cases(data), ]

## Combine Date and Time column
dateTime <- paste(data$Date, data$Time)

## Name the vector
dateTime <- setNames(dateTime, "DateTime")

## Remove Date and Time column
data <- data[, !(names(data) %in% c("Date", "Time"))]

## Add DateTime column
data <- cbind(dateTime, data)

## Format dateTime Column
data$dateTime <- as.POSIXct(dateTime)
png(plotimage, width = 480, height = 480)
with(
    data,
    hist(
        Global_active_power,
        col = "red",
        main = "Global Active Power",
        xlab = "Global Active Power (kilowatts)"
    )
)
dev.off()