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
data <- read_excel("Vital statistics in the UK.xlsx", sheet = "Marriage", skip = 5)

# Inspect the first rows
head(data)

# Inspect the structure of the data
str(data)

# summary of the data
summary(data)

# Extract marriages data
uk_marriages_data <- data %>% select(Year, "United Kingdom")

# Check for missing values
sum(is.na(uk_marriages_data$"United Kingdom"))

# Check for null values
sum(is.null(uk_marriages_data$"United Kingdom"))



###Data Cleaning and Preparation######

# Remove rows where "United Kingdom" column has ":"
uk_marriages_clean <- uk_marriages_data %>% filter(`United Kingdom` != ":")

# Verify that the rows have been removed
head(uk_marriages_clean)

# Convert the "United Kingdom" column to numeric
uk_marriages_clean$"United Kingdom" <- as.numeric(uk_marriages_clean$"United Kingdom")

# Verify that the column has been converted to numeric
str(uk_marriages_clean)

# Reorder the data by year in ascending order
uk_marriages_clean<- uk_marriages_clean %>% arrange(Year)

# Verify that the data has been reordered
head(uk_marriages_clean)

# convert the data to a time series object
uk_marriages_ts <- ts(uk_marriages_clean$"United Kingdom", start = c(1887), frequency = 1)

# Verify that the data has been converted to a time series object
str(uk_marriages_ts)

# Plot the time series data
plot(uk_marriages_ts, main = "Marriages in the United Kingdom (1887-2019)", 
     xlab = "Year", ylab = "Number of Marriages")


# Check for trends in the data

# Calculate the moving average with different values of n
plot.ts(uk_marriages_ts, main="Annual Marriages with Different Trend Lines", ylab="Number of Marriages", col="blue")
# Short-term trend. Best for small fluctuations  but noisy as it fits the data too closely
lines(SMA(uk_marriages_ts, n=3), col="red", lwd=2)  
# Medium-term trend. Captures moderate fluctuations
lines(SMA(uk_marriages_ts, n=5), col="green", lwd=2)
# Long-term trend. Smooth trend but oversimplifies the data
lines(SMA(uk_marriages_ts, n=10), col="purple", lwd=2)  
legend("topright", legend=c("n=3", "n=5", "n=10"), col=c("red", "green", "purple"), lty=1, lwd=2)

# Simple Moving Average (SMA) with n=5 as it seems to smooth noise but capture the important trends
trend <- SMA(uk_marriages_ts, n=5)

# Plot the original data and the trend
plot(uk_marriages_ts, main = "Marriages in the United Kingdom (1887-2019)", 
     xlab = "Year", ylab = "Number of Marriages")
lines(trend, col="red")


##### Modelling#####

# Data does not have seasonal component because it is annual data

# Check for stationarity (Stationarity data has constant mean and variance over time)
# Augmented Dickey-Fuller test
adf.test(uk_marriages_ts)

# Dickey-Fuller test indicate that the time series is not stationary, as the p-value = 0.9247, which is much greater than 0.05.
# We will apply first-order differencing to remove trends and check stationarity again

# First-order to remove trends
# differencing computes the difference between consecutive observations
uk_marriages_diff <- diff(uk_marriages_ts, differences = 1)

# Plot the differenced series
plot.ts(uk_marriages_diff,
        main = "First Differenced Marriages Time Series", ylab = "Differenced Values")

# recheck for stationarity
adf.test(uk_marriages_diff)

# The differenced time series plot shows fluctuations around a constant mean with no obvious trend
# suggesting that the series is stationary. The Augmented Dickey-Fuller test also confirms this
# as the p-value = -6.221, which is less than 0.05.

# We use an ARIYA model to fit the data

# Analyse ACF and PACF plots to determine the order of the ARIMA parameters (p, d, q)
# We already know that d=1 because we applied first-order differencing
# Plot ACF and PACF
acf(uk_marriages_diff, main = "ACF of Differenced Series")
pacf(uk_marriages_diff, main = "PACF of Differenced Series")


# ACF Plot (Autocorrelation Function) shows a large spike at lag 1 and a gradual decline which suggests
# the presence of an MA(1) component.

# PACF Plot (Partial Autocorrelation Function) shows a large spike at lag 1 and a gradual decline which suggests
# the presence of an AR(1) component.

# Fit the ARIMA model
uk_arima_model <- arima(uk_marriages_ts, order = c(1, 1, 1))

# Summary of the ARIMA model
summary(uk_arima_model)



# Diagnostics of the ARIMA model

# Plot residuals to check for randomness
plot(uk_arima_model$residuals, main = "Residuals of ARIMA Model", ylab = "Residuals")

# ACF of residuals to check for autocorrelation
acf(uk_arima_model$residuals, main = "ACF of Residuals")

# Ljung-Box test for white noise
Box.test(uk_arima_model$residuals, lag = 10, type = "Ljung-Box")


# Forecasting the number of marriages for the next 10 year
forecast_uk_marriages <- forecast(uk_arima_model, h = 10)
plot(forecast_uk_marriages, main = "Forecast of Marriages in the United Kingdom (2020-2029)", 
     xlab = "Year", ylab = "Number of Marriages")

























