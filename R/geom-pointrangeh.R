
#' @rdname geom_linerangeh
#' @export
geom_pointrangeh <- function(mapping = NULL, data = NULL,
                             stat = "identity", position = "identity",
                             ...,
                             fatten = 4,
                             na.rm = FALSE,
                             show.legend = NA,
                             inherit.aes = TRUE) {
  layer(
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
GeomPointrangeh <- ggproto("GeomPointrangeh", Geom,
  default_aes = aes(colour = "black", size = 0.5, linetype = 1, shape = 19,
    fill = NA, alpha = NA, stroke = 1),

  draw_key = draw_key_pointrangeh,

  required_aes = c("x", "y", "xmin", "xmax"),

  draw_panel = function(data, panel_scales, coord, fatten = 4) {
    if (is.null(data$x))
      return(GeomLinerangeh$draw_panel(data, panel_scales, coord))

    ggname("geom_pointrangeh",
      gTree(children = gList(
        GeomLinerangeh$draw_panel(data, panel_scales, coord),
        GeomPoint$draw_panel(transform(data, size = size * fatten), panel_scales, coord)
      ))
    )
  }
)
