#' @importFrom purrr map map_if walk2 keep map_at splice invoke some
#'   walk partial set_names %||%
#' @importFrom grid grobName grobTree gTree gList gpar rectGrob linesGrob
#'   segmentsGrob
#' @import ggplot2
generate <- function(fn) {
  get(fn, -1, environment(ggplot_build))
}

ggname <- function(prefix, grob) {
  grob$name <- grobName(grob, prefix)
  grob
}

#' Base ggproto classes for ggstance
#'
#' @seealso ggproto
#' @keywords internal
#' @name ggstance-ggproto
NULL
