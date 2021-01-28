library(arrow)
library(dplyr)
library(purrr)

test_that("marrow roundtrips data correctly", {

  months <- unique(airquality$Month)
  td <- file.path(tempdir(), "arrowmp")
  part_of_data <- function(month) {
    airquality[airquality$Month==month,]
  }
  td <- file.path(tempdir(), "arrowmp")
  aq_arrow_dir <- purrrow:::marrow_dir(.x = months, .f = part_of_data,
                                       .partitioning = "Month",
                                       .path = td)
  td <- file.path(tempdir(), "arrowmp2")
  aq_arrow_ds <- purrrow:::marrow_ds(.x = months, .f = part_of_data,
                                     .partitioning = "Month",
                                     .path = td)
  td <- file.path(tempdir(), "arrowmp3")
  aq_arrow_files <- purrrow:::marrow_files(.x = months, .f = part_of_data,
                                           .partitioning = "Month",
                                           .path = td)

  aq_purrred_ds <- map_dfr(aq_arrow_files, read_parquet)
  aq_opened_ds <- open_dataset(aq_arrow_dir)
  aq_collected <- collect(aq_opened_ds)

  expect_true(all_equal(aq_arrow_ds %>% dplyr::collect(), airquality))
  expect_true(all_equal(aq_arrow_ds %>% dplyr::collect(), airquality))
  expect_length(aq_arrow_files, length(months))
  expect_equal(nrow(aq_arrow_ds), nrow(aq_purrred_ds))
  expect_true(all_equal(aq_collected, airquality))
})
