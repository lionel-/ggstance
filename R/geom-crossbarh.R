
#' @rdname geom_linerangeh
#' @export
geom_crossbarh <- function(mapping = NULL, data = NULL,
                           stat = "identity", position = "identity",
                           ...,
                           fatten = 2.5,
                           na.rm = FALSE,
                           show.legend = NA,
                           inherit.aes = TRUE) {
  ggplot2::layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomCrossbarh,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      fatten = fatten,
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
GeomCrossbarh <- flip_geom(ggplot2::GeomCrossbar,
  draw_key = draw_key_crossbarh,
  draw_panel = flip_method_inner(ggplot2::GeomCrossbar$draw_panel)
)
