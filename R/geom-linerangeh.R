#' Horizontal intervals: lines, crossbars & errorbars.
#'
#' Horizontal versions of \code{\link[ggplot2]{geom_linerange}()},
#' \code{\link[ggplot2]{geom_pointrange}()},
#' \code{\link[ggplot2]{geom_errorbar}()} and
#' \code{\link[ggplot2]{geom_crossbar}()}.
#' @inheritParams ggplot2::geom_linerange
#' @inheritParams ggplot2::geom_point
#' @eval rd_aesthetics("geom", "linerangeh")
#' @export
geom_linerangeh <- function(mapping = NULL, data = NULL,
                            stat = "identity", position = "identity",
                            ...,
                            na.rm = FALSE,
                            show.legend = NA,
                            inherit.aes = TRUE) {
  layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomLinerangeh,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
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
GeomLinerangeh <- ggproto("GeomLinerangeh", Geom,
  default_aes = aes(colour = "black", size = 0.5, linetype = 1, alpha = NA),

  draw_key = draw_key_hpath,

  required_aes = c("y", "xmin", "xmax"),

  draw_panel = function(data, panel_params, coord) {
    data <- transform(data, yend = y, x = xmin, xend = xmax)
    ggname("geom_linerangeh", GeomSegment$draw_panel(data, panel_params, coord))
  }
)
