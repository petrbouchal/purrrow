random_string <- function(n, length) {
  purrr::map_chr(1:n,
     ~paste0(sample(letters, length, replace = T), collapse = "")
  )
}

random_string(10, 2)
