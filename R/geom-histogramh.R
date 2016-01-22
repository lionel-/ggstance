
#' @export
geom_histogramh <- function(mapping = NULL, data = NULL, stat = "bin",
                            binwidth = NULL, bins = NULL,
                            origin = NULL, right = FALSE,
                            position = "stack", na.rm = FALSE,
                            show.legend = NA, inherit.aes = TRUE, ...) {
  layerh(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomBar,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      binwidth = binwidth,
      bins = bins,
      origin = origin,
      right = right,
      na.rm = na.rm,
      ...
    )
  )
}
