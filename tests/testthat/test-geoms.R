
context("Geoms")

test_range_geoms <- function(geom) {
  geom_fun <- match.fun(geom)

  p <- range_p + geom_fun(aes(xmin = lower, xmax = upper))
  final_aes(p, "xmin") %>% expect_equal(range_df$lower)

  save_svg(p, paste0(geom, ".svg"))
}


test_that("geom_linerangeh() flips", {
  test_range_geoms("geom_linerangeh")
})

test_that("geom_pointangeh() flips", {
  test_range_geoms("geom_pointrangeh")
})

test_that("geom_crossbarh() flips", {
  test_range_geoms("geom_crossbarh")
})

test_that("geom_errorbarh() flips", {
  test_range_geoms("geom_errorbarh")
})


test_that("geom_barh() flips", {
  p <- range_p + geom_barh(aes(xmin = lower, xmax = upper, fill = group),
    stat = "identity", position = "dodge")

  final_aes(p, "x") %>% expect_equal(c(1, 5, 3, 4))
  save_svg(p, "geom_barh.svg")
})
