
#' @export
geom_violinh <- function(mapping = NULL, data = NULL,
                         stat = "ydensity", draw_quantiles = NULL,
                         position = "dodge", trim = TRUE,
                         scale = "area", na.rm = FALSE,
                         show.legend = NA, inherit.aes = TRUE, ...) {
  layerh(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomViolin,
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

#' @export
flip_ggproto.GeomViolin <- function(gg) {
  gg <- NextMethod()

  ggmutate(gg,
    draw_group = flip_method_inner(GeomViolin$draw_group)
  )
}
