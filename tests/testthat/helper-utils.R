
check_horizontal <- function(original, horizontal, fig_name,
                             skip_on_windows = FALSE) {
  suppressWarnings({
    sort <- function(x) x[order(names(x))]
    flipped <- function(fun) {
      function(x, ...) fun(flip_aes(x), ...)
    }

    set.seed(10)
    h <- ggplot_build(original)
    set.seed(10)
    v <- ggplot_build(horizontal)

    # h_data <- lapply(h$data, flipped(sort))
    # v_data <- lapply(v$data, sort)
    # expect_identical(h_data, v_data)

    if (skip_on_windows) {
      skip_on_os("windows")
    }
    expect_doppelganger(fig_name, horizontal)
  })
}

expect_doppelganger <- function(title, fig, ...) {
  testthat::skip_if_not_installed("vdiffr")
  vdiffr::expect_doppelganger(title, fig, ...)
}
