# weatherunion

R package to fetch temperature, wind soeed, precipitation and related information from Zomato's [weatherunion.com](https://www.weatherunion.com/) API.


## Installation

``` r
remotes::install_github("saketkc/weatherunion")
```

## Usage

```r
library(weatherunion)
available_locations() # get a list of available locations
```

```r
> head(available_locations())
   cityName           localityName localityId latitude longitude                  device_type
1 Delhi NCR           Sarita Vihar  ZWL005764 28.53176  77.29397 1 - Automated weather system
2 Delhi NCR Faridabad Sector 41-50  ZWL008752 28.46090  77.30476 1 - Automated weather system
3 Delhi NCR     New Friends Colony  ZWL005996 28.56527  77.27497 1 - Automated weather system
4 Delhi NCR      Sector 26 (Noida)  ZWL005243 28.57440  77.33418 1 - Automated weather system
5 Delhi NCR    New Industrial Town  ZWL009032 28.37570  77.29944 1 - Automated weather system
6 Delhi NCR            Tilak Nagar  ZWL005428 28.64137  77.09469 1 - Automated weather system
```

Fetch weather for a particular station:

```r
api_key <- "XXXXXX"
weather <- get_weather(api_key = api_key, latitude = 19.27813, longitude = 72.87472)
```

```r
> weather
  temperature humidity wind_speed wind_direction rain_intensity rain_accumulation latitude longitude
1       27.87    78.65       1.17           26.8              0                 0 19.27813  72.87472
  device_type status message
1           1    200
```
