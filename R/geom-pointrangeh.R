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
    geom = GeomPointrange,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...)
  )
}

flip_ggproto.GeomPointrange <- function(gg) {
  ggproto("GeomPointrangeh", GeomPointrange,
    draw_key = draw_key_pointrangeh,

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
}

#' @export
GeomPointrangeh <- flip_ggproto(GeomPointrange)
