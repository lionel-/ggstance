
REGENERATE_FIGS <- FALSE

# Update svglite version in DESCRIPTION
desc_path <- "../../DESCRIPTION"
desc <- devtools:::read_dcf(desc_path)
desc$svgliteNote <- as.character(utils::packageVersion("svglite"))
desc$ggplot2Note <- as.character(utils::packageVersion("ggplot2"))
devtools:::write_dcf(desc_path, desc)

save_svg <- function(p, name, file = paste0("../figs/", name)) {
  svglite::svglite(file)
  print(p)
  dev.off()
}

save_fig <- function(p, fig_name) {
  skip_on_cran()

  if (REGENERATE_FIGS) {
    save_svg(p, fig_name)
  } else {
    file <- tempfile(fig_name)
    save_svg(p, fig_name, file)
    check_fig(file, fig_name)
  }
}

check_fig <- function(actual_file, fig_name) {
  expected_file <- paste0("../figs/", fig_name)
  actual <- readChar(actual_file, file.info(actual_file)$size)
  expected <- readChar(expected_file, file.info(expected_file)$size)
  expect_equal(actual, expected)
}

