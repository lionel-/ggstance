#' @include utils.R
NULL

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
