#' @importFrom rlang %||%
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


rd_aesthetics <- function(type, name) {
  # Initialised at load time
}

.onLoad <- function(lib, pkg) {
  rd_aesthetics <<- rlang::ns_env("ggplot2")$rd_aesthetics
}

imports <- function() {
  cli::cli_abort
}
