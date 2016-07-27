#' Horizontal intervals: lines, crossbars & errorbars.
#'
#' Horizontal versions of \code{\link[ggplot2]{geom_linerange}()},
#' \code{\link[ggplot2]{geom_pointrange}()},
#' \code{\link[ggplot2]{geom_errorbar}()} and
#' \code{\link[ggplot2]{geom_crossbar}()}.
#' @inheritParams ggplot2::geom_linerange
#' @inheritParams ggplot2::geom_point
#' @export
geom_linerangeh <- function(mapping = NULL, data = NULL,
                            stat = "identity", position = "identity",
                            ...,
                            na.rm = FALSE,
                            show.legend = NA,
                            inherit.aes = TRUE) {
  ggplot2::layer(
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
GeomLinerangeh <- flip_geom(ggplot2::GeomLinerange,
  draw_key = draw_key_hpath,
  draw_panel = flip_method_inner(ggplot2::GeomLinerange$draw_panel)
)
