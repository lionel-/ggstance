#' Horizontal binning.
#'
#' Horizontal version of \code{\link[ggplot2]{stat_bin}}().
#' @inheritParams ggplot2::stat_bin
#' @export
stat_binh <- function(mapping = NULL, data = NULL,
                      geom = "barh", position = "stackv",
                      ...,
                      binwidth = NULL,
                      bins = NULL,
                      center = NULL,
                      boundary = NULL,
                      closed = c("right", "left"),
                      pad = FALSE,
                      na.rm = FALSE,
                      show.legend = NA,
                      inherit.aes = TRUE) {

  ggplot2::layer(
    data = data,
    mapping = mapping,
    stat = StatBinh,
    geom = geom,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      binwidth = binwidth,
      bins = bins,
      center = center,
      boundary = boundary,
      closed = closed,
      pad = pad,
      na.rm = na.rm,
      ...
    )
  )
}

#' @rdname ggstance-ggproto
#' @format NULL
#' @usage NULL
#' @export
StatBinh <- flip_ggproto(ggplot2::StatBin)
