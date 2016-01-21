
import::from("magrittr", `%>%`)
import::from("ggplot2", ggplot, aes, ggplot_build)
import::from("ggplot2", geom_linerange)

range_df <- data.frame(
  trt = factor(c(1, 1, 2, 2)),
  resp = c(1, 5, 3, 4),
  group = factor(c(1, 2, 1, 2)),
  upper = c(1.1, 5.3, 3.3, 4.2),
  lower = c(0.8, 4.6, 2.4, 3.6)
)

range_p <- ggplot(range_df, aes(resp, trt, color = group))

final_aes <- function(p, col, layer = 1) {
  p_data <- ggplot_build(p)$data
  p_data[[layer]][[col]]
}
