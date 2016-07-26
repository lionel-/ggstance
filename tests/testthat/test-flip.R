
context("flip")

test_that("Flipped layers inherit from both Layer and LayerH", {
  l <- geom_linerangeh()

  c("Layer", "Layerh") %in% class(l) %>%
    all() %>%
    expect_true()

  actual_method <- environment(l$compute_position)$f
  expected_method <- environment(Layerh$compute_position)$f
  expect_identical(actual_method, expected_method)
})

test_that("Flipped geoms have correct parent", {
  GeomLinerangeh <- flip_ggproto(GeomLinerange)
  expect_identical(GeomLinerangeh$super, ggplot2::GeomLinerange)
  expect_identical(GeomLinerangeh$super$super, ggplot2::Geom)
})

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
