#' Get the path to a bundled file
#'
#' @param path File name with extension, such as `"zomato_locations.csv"`.
#' @returns The full path to `path`, or the bundled file names if `path` is
#' `NULL`.
#' @export
#' @examples
#' path_to_file()
#' path_to_file("zomato_locations.csv")
#' head(read.csv(path_to_file("zomato_locations.csv")))
#' @source This function is adapted from `readxl::readxl_example()`.
path_to_file <- function(path = NULL) {
  if (is.null(path)) {
    dir(system.file("extdata", package = "weatherunion"))
  } else {
    system.file("extdata", path, package = "weatherunion", mustWork = TRUE)
  }
}
