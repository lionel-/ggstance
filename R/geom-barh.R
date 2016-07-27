#' Bars, rectangles with bases on y-axis
#'
#' Horizontal version of \code{\link[ggplot2]{geom_bar}()}.
#' @inheritParams ggplot2::geom_bar
#' @inheritParams ggplot2::geom_point
#' @export
geom_barh <- function(mapping = NULL, data = NULL,
                      stat = "counth", position = "stackv",
                      ...,
                      width = NULL,
                      binwidth = NULL,
                      na.rm = FALSE,
                      show.legend = NA,
                      inherit.aes = TRUE) {
  ggplot2::layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomBarh,
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
GeomBarh <- flip_geom(ggplot2::GeomBar)
