library(arrow)
library(dplyr)
library(purrr)

test_that("marrow roundtrips data correctly", {

  months <- unique(airquality$Month)

  aq_day1only <- airquality[airquality$Day == 1,]

  td <- file.path(tempdir(), "arrowmp")
  part_of_data <- function(month, day) {
    aq1 <- airquality[airquality$Month==month,]
    aq1[aq1$Day==day,]
  }
  td <- file.path(tempdir(), "arrowmp")
  aq_arrow_dir <- purrrow:::marrow_dir(.x = months, .f = part_of_data,
                                       .partitioning = "Month",
                                       .path = td, day = 1)
  td <- file.path(tempdir(), "arrowmp2")
  aq_arrow_ds <- purrrow:::marrow_ds(.x = months, .f = part_of_data,
                                     .partitioning = "Month",
                                     .path = td, day = 1)
  td <- file.path(tempdir(), "arrowmp3")
  aq_arrow_files <- purrrow:::marrow_files(.x = months, .f = part_of_data,
                                           .partitioning = "Month",
                                           .path = td, day = 1)

  aq_purrred_ds <- map_dfr(aq_arrow_files, read_parquet)
  aq_opened_ds <- open_dataset(aq_arrow_dir)
  aq_collected <- collect(aq_opened_ds)

  expect_true(all_equal(aq_arrow_ds %>% dplyr::collect(), aq_day1only))
  expect_true(all_equal(aq_arrow_ds %>% dplyr::collect(), aq_day1only))
  expect_length(aq_arrow_files, length(months))
  expect_equal(nrow(aq_arrow_ds), nrow(aq_purrred_ds))
  expect_true(all_equal(aq_collected, aq_day1only))
})
