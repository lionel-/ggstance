context("geom-errorbarh")

test_that("can supply `height` for compatibility with ggplot2 version of errorbarh (#27, #29)", {
  w <- range_p + geom_errorbarh(aes(xmin = lower, xmax = upper), width = 0.5)
  h <- range_p + geom_errorbarh(aes(xmin = lower, xmax = upper), height = 0.5)
  for (p in list(w, h)) {
    expect_doppelganger("height and width aesthetics are equivalent", p)
  }
})
