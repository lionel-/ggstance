#' Horizontal counting.
#'
#' Horizontal version of \code{\link[ggplot2]{stat_count}}().
#' @inheritParams ggplot2::stat_count
stat_counth <- function(mapping = NULL, data = NULL,
                        geom = "barh", position = "stackv",
                        ...,
                        width = NULL,
                        na.rm = FALSE,
                        show.legend = NA,
                        inherit.aes = TRUE) {
  ggplot2::layer(
    data = data,
    mapping = mapping,
    stat = StatCounth,
    geom = geom,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      na.rm = na.rm,
      width = width,
      ...
    )
  )
}

#' @rdname ggstance-ggproto
#' @format NULL
#' @usage NULL
#' @export
StatCounth <- flip_ggproto(ggplot2::StatCount)
