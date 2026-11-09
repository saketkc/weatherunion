#' List Weather Union localities
#'
#' Reads the bundled catalog. Works offline.
#'
#' @returns A data frame with columns `cityName`, `localityName`, `localityId`,
#' `latitude`, `longitude` and `device_type`.
#'
#' @examples
#' head(available_locations())
#'
#' @importFrom utils read.csv
#' @export
available_locations <- function() {
  locations <- read.csv(file = path_to_file(path = "zomato_locations.csv"))
  return(locations)
}

# httr2 only suggests jsonlite, which resp_body_json() needs.

#' Get current weather at a location
#'
#' Needs an API key from <https://www.weatherunion.com/>. Rejected requests
#' raise an error with the API's message.
#'
#' @param api_key API key.
#' @param latitude Latitude.
#' @param longitude Longitude.
#' @returns A one-row data frame with numeric readings (`temperature`,
#' `humidity`, `wind_speed`, `wind_direction`, `rain_intensity`,
#' `rain_accumulation` and others), plus `latitude`, `longitude`, `device_type`,
#' `status` and `message`. Missing readings are `NA`. `message` can report an
#' outage, such as `"temporarily unavailable"`.
#'
#' @examples
#' \dontrun{
#' get_weather(
#'   api_key = Sys.getenv("ZOMATO_API_KEY"),
#'   latitude = 19.27813,
#'   longitude = 72.87472
#' )
#' }
#'
#' @importFrom httr2 request req_error req_headers req_url_path_append req_url_query req_perform resp_body_json
#' @importFrom jsonlite fromJSON
#' @importFrom magrittr %>%
#' @export
get_weather <- function(api_key, latitude, longitude) {
  if (!is.character(api_key) || length(api_key) != 1 || is.na(api_key) || !nzchar(api_key)) {
    stop("`api_key` must be a non-empty string.", call. = FALSE)
  }
  latitude <- as_coordinate(latitude, "latitude")
  longitude <- as_coordinate(longitude, "longitude")

  BASE_URL <- "https://www.weatherunion.com/gw/weather/external/v0"
  response <- request(base_url = BASE_URL) %>%
    req_headers(`x-zomato-api-key` = api_key, .redact = "x-zomato-api-key") %>%
    req_url_path_append("get_weather_data") %>%
    req_url_query(`latitude` = latitude, `longitude` = longitude) %>%
    req_error(body = api_error_message) %>%
    req_perform()
  parse_weather(body = resp_body_json(response), latitude = latitude, longitude = longitude)
}

# apply() over a data frame passes strings.
as_coordinate <- function(x, name) {
  value <- if (is.numeric(x) || is.character(x)) suppressWarnings(as.numeric(unname(x)))
  if (length(value) != 1 || !is.finite(value)) {
    stop("`", name, "` must be a single number.", call. = FALSE)
  }
  value
}

api_error_message <- function(resp) {
  tryCatch(resp_body_json(resp)$message, error = function(e) NULL)
}

empty_to_na <- function(x) {
  if (length(x) == 0) NA else x
}

parse_weather <- function(body, latitude, longitude) {
  readings <- lapply(body$locality_weather_data, function(x) as.numeric(empty_to_na(x)))
  as.data.frame(c(readings, list(
    latitude = latitude,
    longitude = longitude,
    device_type = empty_to_na(body$device_type),
    status = empty_to_na(body$status),
    message = empty_to_na(body$message)
  )))
}
