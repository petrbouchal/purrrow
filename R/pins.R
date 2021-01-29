
#' FUNCTION_TITLE
#'
#' FUNCTION_DESCRIPTION
#'
#' @param x DESCRIPTION.
#' @param name DESCRIPTION.
#' @param description DESCRIPTION.
#' @param board DESCRIPTION.
#' @param ... DESCRIPTION.
#'
#' @return RETURN_DESCRIPTION
#' @method pin Dataset
#' @export
#' @examples
#' # ADD_EXAMPLES_HERE
pin.Dataset <- function(x, name = NULL, description = NULL, board = NULL, ...) {
  path <- tempfile()
  dir.create(path)
  dir.create(path)
  dir.create(file.path(path, "arrow_files"))
  on.exit(unlink(path))

  arrow::write_dataset(x, file.path(path, "arrow_files"), format = "parquet")

  metadata <- list(
    columns = names(x))

  print(path)
  print(list.files(path))
  print(list.files(file.path(path, "arrow_files")))
  pins::board_pin_store(board, path, name, description, type = "arrow_dataset",
                        metadata, retrieve = F, ...)
}


#' FUNCTION_TITLE
#'
#' FUNCTION_DESCRIPTION
#'
#' @param x DESCRIPTION.
#' @param name DESCRIPTION.
#' @param description DESCRIPTION.
#' @param board DESCRIPTION.
#' @param ... DESCRIPTION.
#'
#' @return RETURN_DESCRIPTION
#' @method pin arrow_dplyr_query
#' @examples
#' # ADD_EXAMPLES_HERE
#' @export
pin.arrow_dplyr_query <- pin.Dataset

#' FUNCTION_TITLE
#'
#' FUNCTION_DESCRIPTION
#'
#' @param path DESCRIPTION.
#' @param ... DESCRIPTION.
#'
#' @return RETURN_DESCRIPTION
#' @method pin_load arrow_dataset
#' @examples
#' # ADD_EXAMPLES_HERE
#' @export
pin_load.arrow_dataset <- function(path, ...) {
  arrow::open_dataset(file.path(path, "arrow_files"))
}


#' FUNCTION_TITLE
#'
#' FUNCTION_DESCRIPTION
#'
#' @param x DESCRIPTION.
#' @param ... DESCRIPTION.
#'
#' @return RETURN_DESCRIPTION
#' @method pin_preview arrow_dataset
#' @examples
#' # ADD_EXAMPLES_HERE
#' @export
pin_preview.arrow_dataset <- function(x, ...) {
  x %>% head()
}
