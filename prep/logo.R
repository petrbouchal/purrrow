library(tidyverse)
# pak::pkg_install("dmi3kno/bunny")
library(bunny)
library(magick)

# https://pkgdown.r-lib.org/reference/build_favicon.html
# https://pkgdown.r-lib.org/reference/build_home.html
# https://www.ddrive.no/post/making-hex-and-twittercard-with-bunny-and-magick/

hex_border <- image_canvas_hexborder(border_color = "#000000", border_size = 2)
hex_canvas <- image_canvas_hex(border_color = "#000000",
                               border_size = 5, fill_color = "white")

img_hex <- hex_canvas %>%
  image_annotate("a", size = 400, gravity = "south", location = "-430+500",
                 font = "EB Garamond", color = "grey", style = "italic") %>%
  image_annotate("purrr", size = 400, gravity = "south", location = "-280+500",
                 font = "Lucida Console", color = "#c30011", style = "italic") %>%
  image_annotate("rrow", size = 400, gravity = "south", location = "+320+500",
                 font = "Lato", color = "black", weight = "bold") %>%
  image_annotate("^._.^=∫", size = 400, gravity = "north", location = "+220+450",
                 font = "IBM Plex Sans Condensed", color = "#c30011", weight = "bold",
                 kerning = -20) %>%
  image_annotate("⟩⟩⟩", size = 420, gravity = "north", location = "-530+400",
                 font = "Charis SIL", kerning = -120,
                 color = "black", weight = "bold") %>%
  # bunny::image_compose(hex_border, gravity = "center", operator = "Over") %>%
  image_annotate("petrbouchal.xyz/purrrow",
                 size = 70, gravity = "south", location = "+400+310",
                 degrees = 330,
                 font = "sans", color = "grey")
img_hex

img_hex %>%
  image_convert("png") %>%
  image_write("prep/logo.png")

img_hex %>%
  image_scale("300x300")

img_hex %>%
  image_scale("1200x1200") %>%
  image_write("prep/logo_hex_large.png", density = 600)

img_hex_for_pkgdown <- img_hex %>%
  image_scale("480x556") %>%
  image_write(here::here("prep/logo.png"), density = 600, quality = 100)

img_hex_gh <- img_hex %>%
  image_scale("400x400")

gh_logo <- bunny::github %>%
  image_scale("40x40") %>%
  image_colorize(70, "#00f")

gh <- image_canvas_ghcard("white") %>%
  image_compose(img_hex_gh, gravity = "East", offset = "+80+0") %>%
  image_annotate("Out-of-memory data collation\ninto Arrow datasets in R", gravity = "West", location = "+96-60",
                 color = "#00f", size = 40, font = "IBM Plex Sans") %>%
  image_compose(gh_logo, gravity = "West", offset = "+110+45") %>%
  image_annotate("petrbouchal/purrrow", gravity = "West", location = "+160+45",
                 size = 35, font="IBM Plex Sans", color = "#00f") %>%
  image_annotate("petrbouchal.xyz/purrrow", gravity = "West", location = "+105+105",
                 size = 35, font="IBM Plex Sans", color = "#00f") %>%
  image_border_ghcard("#00f")

gh %>% image_scale("500")

gh %>%
  image_write("prep/purrrow_ghcard.png")

