#' Density computation on x axis.
#'
#' Horizontal version of \code{\link[ggplot2]{stat_ydensity}}().
#' @inheritParams ggplot2::stat_ydensity
#' @export
stat_xdensity <- function(mapping = NULL, data = NULL,
                          geom = "violinh", position = "dodgev",
                          ...,
                          bw = "nrd0",
                          adjust = 1,
                          kernel = "gaussian",
                          trim = TRUE,
                          scale = "area",
                          na.rm = FALSE,
                          show.legend = NA,
                          inherit.aes = TRUE) {
  scale <- match.arg(scale, c("area", "count", "width"))

  ggplot2::layer(
    data = data,
    mapping = mapping,
    stat = StatXdensity,
    geom = geom,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      bw = bw,
      adjust = adjust,
      kernel = kernel,
      trim = trim,
      scale = scale,
      na.rm = na.rm,
      ...
    )
  )
}

#' @rdname ggstance-ggproto
#' @format NULL
#' @usage NULL
#' @export
StatXdensity <- flip_stat(ggplot2::StatYdensity)
