#' Horizontal violin plot.
#'
#' Horizontal version of \code{\link[ggplot2]{geom_violin}()}.
#' @inheritParams ggplot2::geom_violin
#' @inheritParams ggplot2::geom_point
#' @export
geom_violinh <- function(mapping = NULL, data = NULL,
                         stat = "xdensity", position = "dodgev",
                         ...,
                         draw_quantiles = NULL,
                         trim = TRUE,
                         scale = "area",
                         na.rm = FALSE,
                         show.legend = NA,
                         inherit.aes = TRUE) {
  ggplot2::layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomViolinh,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      trim = trim,
      scale = scale,
      draw_quantiles = draw_quantiles,
      na.rm = na.rm,
      ...
    )
  )
}

#' @rdname ggstance-ggproto
#' @format NULL
#' @usage NULL
#' @include legend-draw.R
#' @export
GeomViolinh <- flip_ggproto(ggplot2::GeomViolin,
  draw_group = flip_method_inner(ggplot2::GeomViolin$draw_group)
)
