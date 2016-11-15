context("Positions")
library("ggplot2")

test_that("position_dodge() flips", {
  v <- ggplot(mtcars, aes(cyl, disp, group = am)) +
    geom_point(position = position_dodge(0.5))
  h <- ggplot(mtcars, aes(disp, cyl, group = am)) +
    geom_point(position = position_dodgev(0.5))

  check_horizontal(v, h, "position-dodge")
})

test_that("position_jitterdodge() flips", {
  dsub <- diamonds[1:100, ]

  v <- ggplot(dsub, aes(cut, carat, color = clarity)) +
    geom_point(position = position_jitterdodge())
  h <- ggplot(dsub, aes(carat, cut, color = clarity)) +
    geom_point(position = position_jitterdodgev())

  check_horizontal(v, h, "position-jitterdodge", TRUE)
})
