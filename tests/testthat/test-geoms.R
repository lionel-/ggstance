
context("Geoms")

range_p <- ggplot(range_df, aes(resp, trt, color = group))
range_p_orig <- ggplot(range_df, aes(trt, resp, color = group))

check_horizontal <- function(original, horizontal, fig_name) {
  sort <- function(x) x[order(names(x))]
  flipped <- function(fun) {
    function(x, ...) fun(flip_aes(x), ...)
  }

  h <- ggplot2::ggplot_build(original)
  v <- ggplot2::ggplot_build(horizontal)

  h_data <- lapply(h$data, flipped(sort))
  v_data <- lapply(v$data, sort)
  expect_identical(h_data, v_data)

  save_fig(horizontal, paste0(fig_name, ".svg"))
}


test_that("geom_linerangeh() flips", {
  v <- range_p_orig + geom_linerange(aes(ymin = lower, ymax = upper))
  h <- range_p + geom_linerangeh(aes(xmin = lower, xmax = upper))
  check_horizontal(v, h, "geom_linerangeh")
})

test_that("geom_pointangeh() flips", {
  v <- range_p_orig + geom_pointrange(aes(ymin = lower, ymax = upper))
  h <- range_p + geom_pointrangeh(aes(xmin = lower, xmax = upper))
  check_horizontal(v, h, "geom_pointrangeh")

  v_facet <- ggplot(range_df, aes(trt, resp)) + facet_wrap(~group) +
    geom_pointrange(aes(ymin = lower, ymax = upper))
  h_facet <- ggplot(range_df, aes(resp, trt)) + facet_wrap(~group) +
    geom_pointrangeh(aes(xmin = lower, xmax = upper))
  check_horizontal(v_facet, h_facet, "geom_pointrangeh-facet")
})

test_that("geom_crossbarh() flips", {
  v <- range_p_orig + geom_crossbar(aes(ymin = lower, ymax = upper))
  h <- range_p + geom_crossbarh(aes(xmin = lower, xmax = upper))
  check_horizontal(v, h, "geom_crossbarh")
})

test_that("geom_errorbarh() flips", {
  v <- range_p_orig + geom_errorbar(aes(ymin = lower, ymax = upper))
  h <- range_p + geom_errorbarh(aes(xmin = lower, xmax = upper))
  check_horizontal(v, h, "geom_errorbarh")
})

test_that("geom_barh() flips", {
  v <- range_p_orig + geom_bar(aes(ymin = lower, ymax = upper, fill = group),
    stat = "identity", position = "dodge")
  h <- range_p + geom_barh(aes(xmin = lower, xmax = upper, fill = group),
    stat = "identity", position = "dodge")
  check_horizontal(v, h, "geom_barh")

  v_facet <- ggplot(range_df, aes(trt, resp)) + facet_wrap(~group) +
    geom_bar(position = "dodge", stat = "identity")
  h_facet <- ggplot(range_df, aes(resp, trt)) + facet_wrap(~group) +
    geom_barh(position = "dodge", stat = "identity")
  check_horizontal(v_facet, h_facet, "geom_barh-facet")
})

test_that("geom_violinh() flips", {
  v <- ggplot(mtcars, aes(factor(cyl), mpg, fill = factor(am))) + geom_violin()
  h <- ggplot(mtcars, aes(mpg, factor(cyl), fill = factor(am))) + geom_violinh()
  check_horizontal(v, h, "geom_violinh")

  v_facet <- ggplot(mtcars, aes(factor(cyl), mpg, fill = factor(am))) + facet_wrap(~vs) + geom_violin()
  h_facet <- ggplot(mtcars, aes(mpg, factor(cyl), fill = factor(am))) + facet_wrap(~vs) + geom_violinh()
  check_horizontal(v_facet, h_facet, "geom_violinh-facet")
})

test_that("geom_boxploth() flips", {
  v <- ggplot(mpg, aes(class, hwy)) + geom_boxplot()
  h <- ggplot(mpg, aes(hwy, class)) + geom_boxploth()
  check_horizontal(v, h, "geom_boxploth")

  v_fill <- ggplot(mpg, aes(class, hwy, fill = factor(cyl))) + geom_boxplot()
  h_fill <- ggplot(mpg, aes(hwy, class, fill = factor(cyl))) + geom_boxploth()
  check_horizontal(v_fill, h_fill, "geom_boxploth-facet")

  v_facet_fill <- ggplot(mpg, aes(class, hwy, fill = factor(cyl))) + facet_wrap(~model) + geom_boxplot()
  h_facet_fill <- ggplot(mpg, aes(hwy, class, fill = factor(cyl))) + facet_wrap(~model) + geom_boxploth()
  check_horizontal(v_facet_fill, h_facet_fill, "geom_boxploth-facet-fill")
})
