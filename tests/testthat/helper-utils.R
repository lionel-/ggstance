
import::from("magrittr", `%>%`)

check_horizontal <- function(original, horizontal, fig_name) {
  sort <- function(x) x[order(names(x))]
  flipped <- function(fun) {
    function(x, ...) fun(flip_aes(x), ...)
  }

  set.seed(10)
  h <- ggplot2::ggplot_build(original)
  set.seed(10)
  v <- ggplot2::ggplot_build(horizontal)

  h_data <- lapply(h$data, flipped(sort))
  v_data <- lapply(v$data, sort)
  expect_identical(h_data, v_data)

  vdiffr::expect_doppelganger(horizontal, fig_name)
}
