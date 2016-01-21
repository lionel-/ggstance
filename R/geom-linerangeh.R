#' @include legend-draw.R
NULL

#' @export
geom_linerangeh <- function(mapping = NULL, data = NULL,
                            stat = "identity", position = "identity",
                            na.rm = FALSE, show.legend = NA,
                            inherit.aes = TRUE, ...) {
  layerh(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomLinerangeh,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...)
  )
}

flip_ggproto.GeomLinerange <- function(gg) {
  ggproto("GeomLinerangeh", GeomLinerange,
    draw_key = draw_key_hpath,

    draw_panel = flip_method_inner(GeomLinerange$draw_panel)
  )
}

#' @export
GeomLinerangeh <- flip_ggproto(GeomLinerange)
