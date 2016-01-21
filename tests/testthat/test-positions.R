
context("Positions")

test_that("position_dodge() flips", {
  p <- range_p + geom_pointrangeh(aes(xmin = lower, xmax = upper),
    position = position_dodge(0.3))
  final_aes(p, "y") %>% expect_equal(c(0.925, 1.075, 1.925, 2.075))

  save_svg(p, "position_dodge.svg")
})
