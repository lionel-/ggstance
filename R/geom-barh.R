#' Bars, rectangles with bases on y-axis
#'
#' Horizontal version of \code{\link[ggplot2]{geom_bar}()}.
#' @inheritParams ggplot2::geom_bar
#' @inheritParams ggplot2::geom_point
#' @export
geom_barh <- function(mapping = NULL, data = NULL, stat = "count",
                      position = "stack", width = NULL,
                      binwidth = NULL, ..., na.rm = FALSE,
                      show.legend = NA, inherit.aes = TRUE) {
  layerh(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomBar,
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
