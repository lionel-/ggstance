context("Stats")

skip_if_not_installed("Hmisc")

test_that("stat_summaryh() flips", {

  fn_data_v <- function(x) {
    stats::setNames(
      boxplot.stats(x)$stats,
      c("ymin","lower", "middle","upper","ymax")
    )
  }
  fn_data_h <- function(x) {
    stats::setNames(
      boxplot.stats(x)$stats,
      c("xmin","xlower", "xmiddle","xupper","xmax")
    )
  }
  v <- ggplot(mtcars, aes(x = factor(cyl), y = mpg)) +
    stat_summary(fun.data = fn_data_v, geom = "boxplot")
  h <- ggplot(mtcars, aes(x = mpg, y = factor(cyl))) +
    stat_summaryh(fun.data = fn_data_h, geom = "boxploth")
  check_horizontal(v, h, "stat_summaryh() with fun.data()")

  fn_xmin <- function(x) fn_data_h(x)[["xmin"]]
  fn_xmax <- function(x) fn_data_h(x)[["xmax"]]
  fn_x <- function(x) fn_data_h(x)[["xmiddle"]]

  v <- ggplot(mtcars, aes(x = factor(cyl), y = mpg)) +
    stat_summary(
      fun = fn_x,
      fun.min = fn_xmin,
      fun.max = fn_xmax,
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

test_that("stat_summaryh() flips, with median_hilow_h summary", {
  v <- ggplot(mtcars, aes(x = factor(cyl), y = mpg)) +
    stat_summary(fun.data = median_hilow)
  h <- ggplot(mtcars, aes(x = mpg, y = factor(cyl))) +
    stat_summaryh(fun.data = median_hilow_h)
  check_horizontal(v, h, "stat_summaryh() with median_hilow_h()")
})
