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
    geom_point(position = position_jitterdodge(seed = 100))
  h <- ggplot(dsub, aes(carat, cut, color = clarity)) +
    geom_point(position = position_jitterdodgev(seed = 100))

  check_horizontal(v, h, "position-jitterdodge", TRUE)
})

test_that("position_stackv() supports `hjust` argument", {
  df <- data.frame(
    x = c("a", "a", "b", "b", "b"),
    y = c(1, 2, 1, 3, -1),
    grp = c("x", "y", "x", "y", "y")
  )

  v <- ggplot(data = df, aes(x, y, group = grp)) +
    geom_col(aes(fill = grp)) +
    geom_text(aes(label = grp), position = position_stack(vjust = 0.5))
  h <- ggplot(data = df, aes(y, x, group = grp)) +
    geom_colh(aes(fill = grp)) +
    geom_text(aes(label = grp), position = position_stackv(hjust = 0.5))

  check_horizontal(v, h, "position-stackv() with `hjust` argument")
})
