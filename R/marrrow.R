
marrow <- function(.x, .f, ..., .path, .partitioning = c(),
                       .format = "parquet", output) {
  arrow_temp_dirs <- file.path(tempdir(),
                               random_string(n = length(.x), length = 30))

  purrr::walk2(.x, arrow_temp_dirs, ~{
    ft <- .f(.x)
    arrow::write_dataset(ft, path = .y, format = "parquet")
  })

  arrow_datasets <- purrr::map(arrow_temp_dirs, arrow::open_dataset, format = "parquet")
  arrow_combined <- arrow::open_dataset(arrow_datasets)
  arrow::write_dataset(arrow_combined, path = .path,
                       partitioning = .partitioning, format = .format)
  unlink(arrow_temp_dirs, recursive = T)

  otpt <- switch(output,
                 dir = .path,
                 ds = arrow::open_dataset(.path),
                 files = list.files(.path, recursive = T, full.names = T))
  return(otpt)
}

#' Iteratively collate output of function into an Arrow dataset out of memory
#'
#'`r lifecycle::badge('experimental')`
#' map + arrow: iterate over a function and collate the results into
#'   an Arrow dataset. This happens without the whole dataset being in memory,
#'   so is suitable for large data objects. The function must return a data.frame or
#'   tibble. The returned value is a path to the directory containing the
#'   Arrow dataset.
#'
#' @param .x vector or list of values for .f to iterate over
#' @param .f function; must return a data.frame/tibble
#' @param ... other arguments to .f
#' @param .path path to directory where collated Arrow dataset will be stored.
#'   will be created if it does not exist
#' @param .partitioning character vector of columns to use for partitioning.
#'   Columns must exist in output of .f.
#' @param .format "parquet" (the default) or "arrow".
#' @describeIn marrow Return path to directory containing dataset
#'
#' @return path to new dataset directory; character string of length one.
#' @examples
#' months <- unique(airquality$Month)
#' td <- tempdir()
#' part_of_aq <- function(month) {
#'   airquality[airquality$Month==month,]
#' }
#'
#' aq_arrow <- purrrow:::marrow_dir(months, part_of_aq,
#'                                   .path = td)
#' @export
marrow_dir <- function(.x, .f, ..., .path, .partitioning = c(),
                       .format = "parquet") {
  marrow(.x, .f, ..., .path = .path, .partitioning = .partitioning,
         .format = .format, output = "dir")
}

#' @describeIn marrow Return Arrow Dataset
#' @return an Arrow Dataset
#' @export
marrow_ds <- function(.x, .f, ...,  .path, .partitioning = c(),
                      .format = "parquet") {
  marrow(.x, .f, ..., .path = .path, .partitioning = .partitioning,
         .format = .format, output = "ds")
}

#' @describeIn marrow Return paths to all files in dataset dir
#' @return character vector containing paths to all files in dataset dir
#' @export
marrow_files <- function(.x, .f, ...,  .path,  .partitioning = c(),
                         .format = "parquet") {
  marrow(.x, .f, ..., .path = .path, .partitioning = .partitioning,
         .format = .format, output = "files")
}

marrow2_dir <- function(.x, .y, .f, ..., .path, .partitioning = c(), .format = "parquet") {
  arrow_temp_dirs <- file.path(tempdir(),
                               random_string(n = length(.x), length = 30))

  purrr::pwalk(.l = list(.x, .y, arrow_temp_dirs), ~{
    ft <- .f(..1, ..2)
    stopifnot(is.data.frame(ft))
    arrow::write_dataset(ft, path = ..3, format = "parquet")
  })

  arrow_datasets <- purrr::map(arrow_temp_dirs, arrow::open_dataset, format = "parquet")
  arrow_combined <- arrow::open_dataset(arrow_datasets)
  arrow::write_dataset(arrow_combined, path = .path,
                       partitioning = .partitioning, format = .format)
  unlink(arrow_temp_dirs, recursive = T)
  return(.path)
}
