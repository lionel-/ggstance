context("Stats")

test_that("stat_summaryh() flips", {
  fn_data_v <- function(x) {
    set_names(
      boxplot.stats(x)$stats,
      c("ymin","lower", "middle","upper","ymax")
    )
  }
  fn_data_h <- function(x) {
    set_names(
      boxplot.stats(x)$stats,
      c("xmin","lower", "middle","upper","xmax")
    )
  }
  v <- ggplot(mtcars, aes(x = factor(cyl), y = mpg)) +
    stat_summary(fun.data = fn_data_v, geom = "boxplot")
  h <- ggplot(mtcars, aes(x = mpg, y = factor(cyl))) +
    stat_summaryh(fun.data = fn_data_h, geom = "boxploth")
  check_horizontal(v, h, "stat_summaryh() with fun.data()")

  fn_xmin <- function(x) fn_data_h(x)[["xmin"]]
  fn_xmax <- function(x) fn_data_h(x)[["xmax"]]
  fn_x <- function(x) fn_data_h(x)[["middle"]]

  v <- ggplot(mtcars, aes(x = factor(cyl), y = mpg)) +
    stat_summary(
      fun.y = fn_x,
      fun.ymin = fn_xmin,
      fun.ymax = fn_xmax,
      geom = "pointrange"
    )
  h <- ggplot(mtcars, aes(x = mpg, y = factor(cyl))) +
    stat_summaryh(
      fun.x = fn_x,
      fun.xmin = fn_xmin,
      fun.xmax = fn_xmax,
      geom = "pointrangeh"
    )
  check_horizontal(v, h, "stat_summaryh() with fun.x*()")
})
