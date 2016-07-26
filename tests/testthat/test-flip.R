
context("flip")

test_that("we didn't flip original ggproto by reference", {
  StatBin$default_aes %>% expect_identical(aes(y = ..count..))
})

test_that("Name of flipped geom is appended with `h`", {
  p <- ggplot(mtcars) + geom_linerangeh()
  expect_error(ggplot_build(p), "geom_linerangeh")
})

test_that("Symbols of function bodies are correctly flipped", {
  get_body <- function(method) body(environment(method)$f)
  original <- ggplot2::GeomCrossbar$draw_panel
  roundtrip <- flip_method_inner(flip_method_inner(ggplot2::GeomCrossbar$draw_panel))
  identical(get_body(roundtrip), get_body(original))
})

test_that("flipped geoms have correct `required_aes` failure messages", {
  p <- ggplot(mtcars) + geom_linerangeh()
  expect_error(ggplot_build(p), "y, xmin, xmax$")
})

test_that("flipped stats have correct `required_aes` failure messages", {
  p <- ggplot(mtcars) + stat_binh()
  expect_error(ggplot_build(p), "y$")
})
