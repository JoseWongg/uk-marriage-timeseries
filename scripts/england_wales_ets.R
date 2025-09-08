#install.packages("readxl")
#install.packages("dplyr")
#install.packages("TTR")
#install.packages("forecast")
#install.packages("tseries")

library(readxl) # for reading excel files
library(dplyr) # for data manipulation
library(TTR) # for technical analysis
library(forecast) # for forecasting
library(tseries) # for time series analysis

# Read the file
ew_data <- read_excel("Vital statistics in the UK.xlsx", sheet = "Marriage", skip = 5)

# Inspect the first rows
head(ew_data)

# Inspect the last rows
tail(ew_data)

# Inspect the structure of the data
str(ew_data)

# summary of the data
summary(ew_data)

# Extract marriages data
ew_marriages_data <- ew_data %>% select(Year, "England & Wales")

# Check for missing values
sum(is.na(ew_marriages_data$"England & Wales"))

# Check for null values
sum(is.null(ew_marriages_data$"England & Wales"))


###Data Cleaning and Preparation######

# Remove rows where "England & Wales" column has ":"
ew_marriages_clean <- ew_marriages_data %>% filter(`England & Wales` != ":")

# Verify that the rows have been removed
head(ew_marriages_clean)

# Convert the "England & Wales" column to numeric
ew_marriages_clean$"England & Wales" <- as.numeric(ew_marriages_clean$"England & Wales")

# Verify that the column has been converted to numeric
str(ew_marriages_clean)

# Reorder the data by year in ascending order
ew_marriages_clean<- ew_marriages_clean %>% arrange(Year)

# Verify that the data has been reordered
head(ew_marriages_clean)

# convert the data to a time series object
ew_marriages_ts <- ts(ew_marriages_clean$"England & Wales", start = c(1862), frequency = 1)

# Verify that the data has been converted to a time series object
str(ew_marriages_ts)

# Plot the time series data
plot(ew_marriages_ts, main = "Marriages in England & Wales (1862-2019)", xlab = "Year", ylab = "Number of Marriages")



# Plot the time series data
plot(ew_marriages_ts, main = "Marriages in England & Wales (1862-2019)", 
     xlab = "Year", ylab = "Number of Marriages")


###### MOdelling and Evaluation 

# Apply ETS model
ets_model <- ets(ew_marriages_ts)
summary(ets_model)



# Residuals of the ETS model
ets_residuals <- residuals(ets_model)
# Plot residuals to check for randomness
plot(ets_residuals, main = "Residuals of ETS Model", ylab = "Residuals")

# ACF of residuals to check for autocorrelation
acf(ets_residuals, main = "ACF of Residuals")

# Ljung-Box test for white noise
Box.test(ets_residuals, lag = 10, type = "Ljung-Box")


# Forecasting using ETS
ets_forecast <- forecast(ets_model, h = 10)
plot(ets_forecast, main = "ETS Forecast for Marriages in England & Wales (2020-2029)", 
     xlab = "Year", ylab = "Number of Marriages")

