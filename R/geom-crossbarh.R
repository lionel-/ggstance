#' @include legend-draw.R
NULL

#' @export
geom_crossbarh <- function(mapping = NULL, data = NULL,
                           stat = "identity", position = "identity",
                           na.rm = FALSE, show.legend = NA,
                           inherit.aes = TRUE, ...) {
  layerh(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomCrossbarh,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...)
  )
}

flip_ggproto.GeomCrossbar <- function(gg) {
  gg <- NextMethod()

  ggmutate(gg,
    draw_key = draw_key_crossbarh,

    draw_panel = flip_method_inner(GeomCrossbar$draw_panel)
  )
}

#' @export
GeomCrossbarh <- flip_ggproto(GeomCrossbar)
