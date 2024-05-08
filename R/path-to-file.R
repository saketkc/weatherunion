#' Get file path to `zomato_locations.csv` file
#'
#' weatherunion comes bundled with a csv file in `inst/extdata`
#' directory. This function make them easy to access.
#'
#' @param path Name of file in quotes with extension;
#' `"zomato_locations.csv"` will work.
#' If `NULL`, the example files will be listed.
#' @export
#' @examples
#' \dontrun{
#' path_to_file()
#' path_to_file("zomato_locations.csv")
#' head(read.csv(path_to_file("zomato_locations.csv")))
#' }
#' @source This function is adapted from `readxl::readxl_example()`.
path_to_file <- function(path = NULL) {
  if (is.null(path)) {
    dir(system.file("extdata", package = "weatherunion"))
  } else {
    system.file("extdata", path, package = "weatherunion", mustWork = TRUE)
  }
}
