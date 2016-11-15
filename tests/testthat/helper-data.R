
range_df <- data.frame(
  trt = factor(c(1, 1, 2, 2)),
  resp = c(1, 5, 3, 4),
  group = factor(c(1, 2, 1, 2)),
  upper = c(1.1, 5.3, 3.3, 4.2),
  lower = c(0.8, 4.6, 2.4, 3.6)
)

range_p <- ggplot2::ggplot(range_df, ggplot2::aes(resp, trt, color = group))
range_p_orig <- ggplot2::ggplot(range_df, ggplot2::aes(trt, resp, color = group))
