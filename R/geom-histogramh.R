#' Horizontal histograms and frequency polygons.
#'
#' Horizontal version of \code{\link[ggplot2]{geom_histogram}()}.
#' @inheritParams ggplot2::geom_histogram
#' @inheritParams ggplot2::geom_point
#' @export
geom_histogramh <- function(mapping = NULL, data = NULL,
                            stat = "binh", position = "stackv",
                            ...,
                            binwidth = NULL,
                            bins = NULL,
                            na.rm = FALSE,
                            show.legend = NA,
                            inherit.aes = TRUE) {
  layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomBarh,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      binwidth = binwidth,
      bins = bins,
      na.rm = na.rm,
      pad = FALSE,
      ...
    )
  )
}
