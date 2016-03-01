
REGENERATE_FIGS <- TRUE
DIFF_ON_FAILURE <- TRUE

if (REGENERATE_FIGS) {
  # Update svglite version in DESCRIPTION
  desc_path <- "../../DESCRIPTION"
  desc <- devtools:::read_dcf(desc_path)
  desc$svgliteNote <- as.character(utils::packageVersion("svglite"))
  desc$ggplot2Note <- as.character(utils::packageVersion("ggplot2"))
  devtools:::write_dcf(desc_path, desc)
}

save_svg <- function(p, file) {
  svglite::svglite(file)
  on.exit(dev.off())
  print(p)
}

check_fig <- function(p, fig_name) {
  ## skip_on_cran()

  expected_file <- normalizePath(paste0("../figs/", fig_name, ".svg"))

  if (REGENERATE_FIGS) {
    save_svg(p, expected_file)
    return()
  }

  if (!file.exists(expected_file)) {
    cat("\nGenerating ", fig_name, "\n")
    save_svg(p, expected_file)
    return()
  }

  testcase_file <- tempfile(fig_name, fileext = ".svg")
  save_svg(p, testcase_file)

  testcase <- readChar(testcase_file, file.info(testcase_file)$size)
  expected <- readChar(expected_file, file.info(expected_file)$size)
  result <- expect_equal(testcase, expected)

  if (should_diff(result)) {
    print(vdiffr::transition(expected_file, testcase_file))
  }
}

should_diff <- function(result) {
  DIFF_ON_FAILURE && !result$passed && !result$error && !result$skipped
}
