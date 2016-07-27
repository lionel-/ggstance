
#' @rdname geom_linerangeh
#' @export
geom_pointrangeh <- function(mapping = NULL, data = NULL,
                             stat = "identity", position = "identity",
                             ...,
                             fatten = 4,
                             na.rm = FALSE,
                             show.legend = NA,
                             inherit.aes = TRUE) {
  ggplot2::layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomPointrangeh,
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
GeomPointrangeh <- flip_geom(ggplot2::GeomPointrange,
  draw_key = draw_key_pointrangeh,
  draw_panel = flip_method_inner(ggplot2::GeomPointrange$draw_panel)
)
