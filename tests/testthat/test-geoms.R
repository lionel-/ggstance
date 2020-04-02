context("Geoms")
library("ggplot2")

test_that("geom_linerangeh() flips", {
  v <- range_p_orig + geom_linerange(aes(ymin = lower, ymax = upper))
  h <- range_p + geom_linerangeh(aes(xmin = lower, xmax = upper))
  check_horizontal(v, h, "geom_linerangeh()")
})

test_that("geom_pointangeh() flips", {
  v <- range_p_orig + geom_pointrange(aes(ymin = lower, ymax = upper))
  h <- range_p + geom_pointrangeh(aes(xmin = lower, xmax = upper))
  check_horizontal(v, h, "geom_pointrangeh()")

  v_facet <- ggplot(range_df, aes(trt, resp)) + facet_wrap(~group) +
    geom_pointrange(aes(ymin = lower, ymax = upper))
  h_facet <- ggplot(range_df, aes(resp, trt)) + facet_wrap(~group) +
    geom_pointrangeh(aes(xmin = lower, xmax = upper))
  check_horizontal(v_facet, h_facet, "geom_pointrangeh() + facet_wrap()")

  v_dodge <- range_p_orig + geom_pointrange(aes(ymin = lower, ymax = upper),
    position = position_dodge(0.3))
  h_dodge <- range_p + geom_pointrangeh(aes(xmin = lower, xmax = upper),
    position = position_dodgev(0.3))
  check_horizontal(v_dodge, h_dodge, "geom_pointrangeh() + position_dodgev()")
})

test_that("geom_crossbarh() flips", {
  v <- range_p_orig + geom_crossbar(aes(ymin = lower, ymax = upper))
  h <- range_p + geom_crossbarh(aes(xmin = lower, xmax = upper))
  check_horizontal(v, h, "geom_crossbarh()")
})

test_that("geom_errorbarh() flips", {
  v <- range_p_orig + geom_errorbar(aes(ymin = lower, ymax = upper))
  h <- range_p + geom_errorbarh(aes(xmin = lower, xmax = upper))
  check_horizontal(v, h, "geom_errorbarh()")
})

test_that("geom_barh() flips", {
  v <- range_p_orig + geom_bar(aes(fill = group),
    stat = "identity", position = "dodge")
  h <- range_p + geom_barh(aes(fill = group),
    stat = "identity", position = "dodgev")
  check_horizontal(v, h, "geom_barh()")

  v_facet <- ggplot(range_df, aes(trt, resp)) + facet_wrap(~group) +
    geom_bar(position = "dodge", stat = "identity")
  h_facet <- ggplot(range_df, aes(resp, trt)) + facet_wrap(~group) +
    geom_barh(position = "dodgev", stat = "identity")
  check_horizontal(v_facet, h_facet, "geom_barh() + facet_wrap()")

  v <- ggplot(mpg, aes(x = class)) + geom_bar()
  h <- ggplot(mpg, aes(y = class)) + geom_barh()
  check_horizontal(v, h, "geom_barh() with count stat")
})

test_that("geom_colh() flips", {
  df <- data.frame(trt = c("a", "b", "c"), outcome = c(2.3, 1.9, 3.2))
  v <- ggplot(df, aes(trt, outcome)) + geom_col()
  h <- ggplot(df, aes(outcome, trt)) + geom_colh()
  check_horizontal(v, h, "geom_colh()")
})

test_that("geom_histogramh() flips", {
  v <- ggplot(mtcars, aes(drat)) + geom_histogram(bins = 10)
  h <- ggplot(mtcars, aes(y = drat)) + geom_histogramh(bins = 10)
  check_horizontal(v, h, "geom_histogramh()", TRUE)

  v_fill_stack <- ggplot(mtcars, aes(drat, fill = factor(cyl))) + geom_histogram(bins = 10, position = position_stack())
  h_fill_stack <- ggplot(mtcars, aes(y = drat, fill = factor(cyl))) + geom_histogramh(bins = 10, position = position_stackv())
  check_horizontal(v_fill_stack, h_fill_stack, "geom_histogramh() + position_stack() with fill", TRUE)

  v_fill_facet_nudge <- ggplot(mtcars, aes(drat, fill = factor(cyl))) + facet_wrap(~am) + geom_histogram(bins = 10, position = position_nudge())
  h_fill_facet_nudge <- ggplot(mtcars, aes(y = drat, fill = factor(cyl))) + facet_wrap(~am) + geom_histogramh(bins = 10, position = position_nudge())
  check_horizontal(v_fill_facet_nudge, h_fill_facet_nudge, "geom_histogramh() + position_nudge() with fill")
})

test_that("geom_violinh() flips", {
  v <- ggplot(mtcars, aes(factor(cyl), mpg, fill = factor(am))) + geom_violin()
  h <- ggplot(mtcars, aes(mpg, factor(cyl), fill = factor(am))) + geom_violinh()
  check_horizontal(v, h, "geom_violinh()")

  v_facet <- ggplot(mtcars, aes(factor(cyl), mpg, fill = factor(am))) + facet_wrap(~vs) + geom_violin()
  h_facet <- ggplot(mtcars, aes(mpg, factor(cyl), fill = factor(am))) + facet_wrap(~vs) + geom_violinh()
  check_horizontal(v_facet, h_facet, "geom_violinh() + facet_wrap()")

  set.seed(111)
  dat <- data.frame(x = LETTERS[1:3], y = rnorm(90))
  dat <- dat[dat$x != "C" | c(TRUE, FALSE), ] # Keep half the C's

  v <- ggplot(dat, aes(x = x, y = y)) + geom_violin(draw_quantiles = c(0.25, 0.5, 0.75))
  h <- ggplot(dat, aes(x = y, y = x)) + geom_violinh(draw_quantiles = c(0.25, 0.5, 0.75))
  check_horizontal(v, h, "geom_violinh() + draw_quantiles")
})

test_that("geom_boxploth() flips", {
  v <- ggplot(mpg, aes(class, hwy)) + geom_boxplot()
  h <- ggplot(mpg, aes(hwy, class)) + geom_boxploth()
  check_horizontal(v, h, "geom_boxploth()")

  v_fill <- ggplot(mpg, aes(class, hwy, fill = factor(cyl))) + geom_boxplot()
  h_fill <- ggplot(mpg, aes(hwy, class, fill = factor(cyl))) + geom_boxploth()
  check_horizontal(v_fill, h_fill, "geom_boxploth() with fill")

  v_facet_fill <- ggplot(mpg, aes(class, hwy, fill = factor(cyl))) + facet_wrap(~model) + geom_boxplot()
  h_facet_fill <- ggplot(mpg, aes(hwy, class, fill = factor(cyl))) + facet_wrap(~model) + geom_boxploth()
  check_horizontal(v_facet_fill, h_facet_fill, "geom_boxploth() + facet_wrap() with fill")

  df <- data.frame(x = 1:10, y = rep(1:2, 5))
  h_continuous <- ggplot(df) + geom_boxploth(aes(x = x, y = y, group = 1))
  v_continuous <- ggplot(df) + geom_boxplot(aes(x = y, y = x, group = 1))
  check_horizontal(v_continuous, h_continuous, "geom_boxploth() and continuous y scale")
})

test_that("facet_grid() with free scales flips", {
  v <- ggplot(mtcars, aes(factor(cyl), disp)) + geom_boxplot() + facet_grid(am ~ ., scales = "free")
  h <- ggplot(mtcars, aes(disp, factor(cyl))) + geom_boxploth() + facet_grid(. ~ am, scales = "free")
  check_horizontal(v, h, "facet_grid() with free scales")
})

test_that("scale information is preserved", {
  v <- range_p_orig +
    geom_pointrange(aes(ymin = lower, ymax = upper))+
    scale_y_continuous(breaks = c(1, 2, 3, 4, 5),
      labels = c("1/1", "2/1", "3/1", "4/1", "5/1"))

  h <- range_p +
    geom_pointrangeh(aes(xmin = lower, xmax = upper)) +
    scale_x_continuous(breaks = c(1, 2, 3, 4, 5),
      labels = c("1/1", "2/1", "3/1", "4/1", "5/1"))

  check_horizontal(v, h, "scales")
})
