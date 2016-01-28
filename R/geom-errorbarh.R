
#' @rdname geom_linerangeh
#' @export
geom_errorbarh <- function(mapping = NULL, data = NULL,
                           stat = "identity", position = "identity",
                           na.rm = FALSE, show.legend = NA,
                           inherit.aes = TRUE, ...) {
  layerh(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomErrorbar,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      na.rm = na.rm,
      ...
    )
  )
}

#' @export
flip_ggproto.GeomErrorbar <- function(gg) {
  gg <- NextMethod()

  ggmutate(gg,
    draw_panel = flip_method_inner(GeomErrorbar$draw_panel)
  )
}
