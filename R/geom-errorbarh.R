#' @rdname geom_linerangeh
#' @section Different between ggplot2 and ggstance:
#'
#' `ggplot2::geom_errorbarh()` uses the `height` aesthetic. The
#' ggstance version uses the `width` aesthetic. This is for
#' consistency with the direction of the geom and other ggstance
#' functions. You can still supply `height` for compatibility.
#' @eval rd_aesthetics("geom", "errorbarh")
#' @export
geom_errorbarh <- function(mapping = NULL, data = NULL,
                           stat = "identity", position = "identity",
                           ...,
                           na.rm = FALSE,
                           show.legend = NA,
                           inherit.aes = TRUE) {
  params <- list(na.rm = na.rm, ...)
  params$width <- params$width %||% params$height
  params$height <- NULL

  layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomErrorbarh,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = params
  )
}

#' @rdname ggstance-ggproto
#' @format NULL
#' @usage NULL
#' @include legend-draw.R
#' @export
GeomErrorbarh <- ggproto("GeomErrorbarh", Geom,
  default_aes = aes(colour = "black", size = 0.5, linetype = 1, width = 0.5,
    alpha = NA),

  draw_key = draw_key_path,

  required_aes = c("y", "xmin", "xmax"),

  setup_data = function(data, params) {
    data$width <- data$width %||%
      params$width %||% (resolution(data$y, FALSE) * 0.9)

    transform(data,
      ymin = y - width / 2, ymax = y + width / 2, width = NULL
    )
  },

  draw_panel = function(data, panel_params, coord, width = NULL) {
    GeomPath$draw_panel(data.frame(
      y = as.vector(rbind(data$ymin, data$ymax, NA, data$y,    data$y,    NA, data$ymin, data$ymax)),
      x = as.vector(rbind(data$xmax, data$xmax, NA, data$xmax, data$xmin, NA, data$xmin, data$xmin)),
      colour = rep(data$colour, each = 8),
      alpha = rep(data$alpha, each = 8),
      size = rep(data$size, each = 8),
      linetype = rep(data$linetype, each = 8),
      group = rep(1:(nrow(data)), each = 8),
      stringsAsFactors = FALSE,
      row.names = 1:(nrow(data) * 8)
    ), panel_params, coord)
  }
)
