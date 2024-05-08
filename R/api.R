#' Get list of localities supported by Zomato
#' @returns A list of locations with latitudes and longitudes
#'
#' @importFrom utils read.csv
#' @export
available_locations <- function() {
  locations <- read.csv(file = path_to_file(path = "zomato_locations.csv"))
  return(locations)
}

#' Get current weather at a particular latitude and longitude
#' @param api_key API key
#' @param latitude Latitude
#' @param longitude Longitude
#' @returns A dataframe with current weather statistics
#' including: temperature, humidity, wind_speed, wind_direction
#' rain_intensity rain_accumulation latitude
#'
#' @importFrom httr2 request req_headers req_url_path_append req_url_query req_perform resp_body_json
#' @importFrom magrittr %>%
#' @export
get_weather <- function(api_key, latitude, longitude) {
  BASE_URL <- "https://www.weatherunion.com/gw/weather/external/v0"
  req <- request(base_url = BASE_URL)
  response <- req %>%
    req_headers(`x-zomato-api-key` = api_key) %>%
    req_url_path_append("get_weather_data") %>%
    req_url_query(`latitude` = latitude, `longitude` = longitude) %>%
    req_perform()
  json.reponse <- response %>% resp_body_json()
  locality_weather_data <- json.reponse$locality_weather_data
  df <- as.data.frame(x = t(x = locality_weather_data))
  df$latitude <- as.numeric(x = latitude)
  df$longitude <- as.numeric(x = longitude)
  df$device_type <- json.reponse$device_type
  df$status <- json.reponse$status
  df$message <- json.reponse$message
  df[is.null(x = df)] <- NA
  return(df)
}
