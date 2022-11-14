context("flip")
library("ggplot2")

testthat::local_edition(3)

test_that("flipped geoms have correct `required_aes` failure messages", {
  p <- ggplot(mtcars) + geom_linerangeh()
  expect_snapshot({
    (expect_error(ggplot_build(p)))
  })
})

test_that("flipped stats have correct `required_aes` failure messages", {
  p <- ggplot(mtcars) + stat_binh(bins = 30)
  expect_snapshot({
    (expect_error(ggplot_build(p), "y$"))
  })
})
