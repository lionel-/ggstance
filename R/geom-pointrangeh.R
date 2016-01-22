#' @include legend-draw.R
NULL

#' @export
geom_pointrangeh <- function(mapping = NULL, data = NULL,
                             stat = "identity", position = "identity",
                             na.rm = FALSE, show.legend = NA,
                             inherit.aes = TRUE, ...) {
  layerh(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomPointrangeh,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...)
  )
}

flip_ggproto.GeomPointrange <- function(gg) {
  gg <- NextMethod()

  ggmutate(gg,
    draw_key = draw_key_pointrangeh,

    draw_panel = flip_method_inner(gg$draw_panel)
  )
}

#' @export
GeomPointrangeh <- flip_ggproto(GeomPointrange)
