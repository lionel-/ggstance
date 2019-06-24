#' @rdname geom_barh
#' @eval rd_aesthetics("geom", "colh")
#' @export
geom_colh <- function(mapping = NULL, data = NULL,
                      position = "stackv",
                      ...,
                      width = NULL,
                      na.rm = FALSE,
                      show.legend = NA,
                      inherit.aes = TRUE) {

  layer(
    data = data,
    mapping = mapping,
    stat = "identity",
    geom = GeomColh,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      width = width,
      na.rm = na.rm,
      ...
    )
  )
}

#' @rdname ggstance-ggproto
#' @format NULL
#' @usage NULL
#' @export
GeomColh <- ggproto("GeomColh", ggplot2::GeomRect,
  required_aes = c("y", "x"),

  setup_data = function(data, params) {
    data$width <- data$width %||%
      params$width %||% (resolution(data$y, FALSE) * 0.9)
    transform(data,
      xmin = pmin(x, 0), xmax = pmax(x, 0),
      ymin = y - width / 2, ymax = y + width / 2, width = NULL
    )
  },

  draw_panel = function(self, data, panel_params, coord, width = NULL) {
    # Hack to ensure that height is detected as a parameter
    ggproto_parent(ggplot2::GeomRect, self)$draw_panel(data, panel_params, coord)
  }
)
