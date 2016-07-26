#' Horizontal boxplot computation.
#'
#' Horizontal version of \code{\link[ggplot2]{stat_boxplot}}().
#' @inheritParams ggplot2::stat_boxplot
#' @export
stat_boxploth <- function(mapping = NULL, data = NULL,
                         geom = "boxploth", position = "dodgev",
                         ...,
                         coef = 1.5,
                         na.rm = FALSE,
                         show.legend = NA,
                         inherit.aes = TRUE) {
  ggplot2::layer(
    data = data,
    mapping = mapping,
    stat = StatBoxploth,
    geom = geom,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      na.rm = na.rm,
      coef = coef,
      ...
    )
  )
}

#' @rdname ggstance-ggproto
#' @format NULL
#' @usage NULL
#' @export
StatBoxploth <- flip_ggproto(ggplot2::StatBoxplot)
