#' Horizontal summary.
#'
#' Horizontal version of \code{\link[ggplot2]{stat_summary}}().
#'
#' @inheritParams ggplot2::stat_summary
#' @param fun.data A function that is given the complete data and should
#'   return a data frame with variables \code{xmin}, \code{x}, and \code{xmax}.
#' @param fun.xmin,fun.x,fun.xmax Alternatively, supply three individual
#'   functions that are each passed a vector of x's and should return a
#'   single number.
#' @export
stat_summaryh <- function(mapping = NULL, data = NULL,
                          geom = "pointrangeh", position = "identity",
                          ...,
                          fun.data = NULL,
                          fun.x = NULL,
                          fun.xmax = NULL,
                          fun.xmin = NULL,
                          fun.args = list(),
                          na.rm = FALSE,
                          show.legend = NA,
                          inherit.aes = TRUE) {
  layer(
    data = data,
    mapping = mapping,
    stat = StatSummaryh,
    geom = geom,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      fun.data = fun.data,
      fun.x = fun.x,
      fun.xmax = fun.xmax,
      fun.xmin = fun.xmin,
      fun.args = fun.args,
      na.rm = na.rm,
      ...
    )
  )
}

StatSummaryh <- ggproto("StatSummaryh", StatSummary,
  compute_panel = function(data, scales, fun.data = NULL, fun.x = NULL,
                           fun.xmax = NULL, fun.xmin = NULL, fun.args = list(),
                           na.rm = FALSE) {

    fun <- make_summary_fun(fun.data, fun.x, fun.xmax, fun.xmin, fun.args)
    summarise_by_y(data, fun)
  }
)

uniquecols <- generate("uniquecols")

summarise_by_y <- function(data, summary, ...) {
  summary <- plyr::ddply(data, c("group", "y"), summary, ...)
  unique <- plyr::ddply(data, c("group", "y"), uniquecols)
  unique$x <- NULL

  merge(summary, unique, by = c("y", "group"), sort = FALSE)
}

make_summary_fun <- function(fun.data, fun.x, fun.xmax, fun.xmin, fun.args) {
  if (!is.null(fun.data)) {
    # Function that takes complete data frame as input
    fun.data <- match.fun(fun.data)
    function(df) {
      do.call(fun.data, c(list(quote(df$x)), fun.args))
    }
  } else if (!is.null(fun.x) || !is.null(fun.xmax) || !is.null(fun.xmin)) {
    # Three functions that take vectors as inputs

    call_f <- function(fun, x) {
      if (is.null(fun)) return(NA_real_)
      do.call(fun, c(list(quote(x)), fun.args))
    }

    function(df, ...) {
      data.frame(
        xmin = call_f(fun.xmin, df$x),
        x = call_f(fun.x, df$x),
        xmax = call_f(fun.xmax, df$x)
      )
    }
  } else {
    message("No summary function supplied, defaulting to `mean_se()")
    function(df) {
      mean_se(df$x)
    }
  }
}
