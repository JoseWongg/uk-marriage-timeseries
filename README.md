# UK Marriages Forecasting with Time Series Models (R)

Time series modelling to forecast the number of marriages for **England & Wales** and for the **United Kingdom** as a whole. 
The analysis explores historical patterns and compares model performance to recommend a suitable approach for forecasting.

## Repository Structure
```
uk-marriages-timeseries/
├── data/
│   └── Vital statistics in the UK.xlsx     # Source workbook (use the “Marriage” sheet)
├── scripts/
│   ├── england_wales_ets.R                 # ETS modelling for England & Wales
│   └── uk_arima.R                          # ARIMA modelling for the UK
├── reports/
│   └── time_series_analysis_report.pdf     # Full report with methodology, outputs, and discussion
├── LICENSE
└── README.md
```

## What’s Inside
- Initial exploration of the time series (visualisation, simple trend smoothing, decomposition where applicable).
- **England & Wales**: Exponential Smoothing State Space (ETS) model.
- **United Kingdom**: ARIMA(1,1,1) model after first-order differencing.
- Model diagnostics: residual plots, ACF of residuals, Ljung–Box test.
- Ten‑year forecasts and interpretation.
- Comparison of models with error metrics (e.g., MAE, RMSE) and a recommendation.

## Data
The dataset is stored in `data/Vital statistics in the UK.xlsx` and the analysis uses the **“Marriage”** worksheet. 
Rows containing “:” are treated as missing values, and numeric columns are coerced to numeric before modelling. 
The workbook contains annual counts; no within‑year seasonality is assumed.

## Getting Started (R / RStudio)
1. Set the working directory to the repository root:
   ```r
   setwd("path/to/uk-marriages-timeseries")
   ```
2. Install required packages (first run only):
   ```r
   install.packages(c("readxl", "dplyr", "TTR", "forecast", "tseries"))
   ```
3. Run the scripts:
   - England & Wales (ETS):
     ```r
     source("scripts/england_wales_ets.R")
     ```
   - United Kingdom (ARIMA):
     ```r
     source("scripts/uk_arima.R")
     ```

## Notes
- The England & Wales script expects the “England & Wales” column; the UK script expects the “United Kingdom” column.
- Both scripts read from the **Marriage** sheet and skip the header rows according to the workbook layout.
- Diagnostic checks include stationarity (ADF), autocorrelation (ACF/PACF), and residual independence (Ljung–Box).

## Authorship & Contact
Developed by **Jose Wong**  
j.wong@mail.com  
https://www.linkedin.com/in/jose-wongg  
https://github.com/JoseWongg

## License
MIT — see the [LICENSE](LICENSE) file for details.
