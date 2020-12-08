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
#' @eval rd_aesthetics("stat", "summaryh")
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

#' Horizontal versions of summary functions from Hmisc
#'
#' @description
#' These are horizontal versions of the wrappers around functions from
#' \pkg{Hmisc} designed to make them easier to use with
#' \code{\link{stat_summaryh}}. The corresponding vertical versions are
#' \code{\link[ggplot2]{hmisc}()}. See the Hmisc documentation for more details:
#'
#' \itemize{
#'  \item \code{\link[Hmisc]{smean.cl.boot}}
#'  \item \code{\link[Hmisc]{smean.cl.normal}}
#'  \item \code{\link[Hmisc]{smean.sdl}}
#'  \item \code{\link[Hmisc]{smedian.hilow}}
#' }
#' @param x a numeric vector
#' @param ... other arguments passed on to the respective Hmisc function.
#' @return A data frame with columns \code{x}, \code{xmin}, and \code{xmax}.
#' @name hmisc_h
#' @examples
#' if (requireNamespace("Hmisc")) {
#'   x <- rnorm(100)
#'   mean_cl_boot_h(x)
#'   mean_cl_normal_h(x)
#'   mean_sdl_h(x)
#'   median_hilow_h(x)
#' }
NULL

wrap_hmisc_h <- function(fun) {

  function(x, ...) {
    if (!requireNamespace("Hmisc", quietly = TRUE))
      stop("Hmisc package required for this function", call. = FALSE)

    fun <- getExportedValue("Hmisc", fun)
    result <- do.call(fun, list(x = quote(x), ...))

    plyr::rename(
      data.frame(t(result)),
      c(Median = "x", Mean = "x", Lower = "xmin", Upper = "xmax"),
      warn_missing = FALSE
    )
  }
}

#' @export
#' @rdname hmisc_h
mean_cl_boot_h <- wrap_hmisc_h("smean.cl.boot")
#' @export
#' @rdname hmisc_h
mean_cl_normal_h <- wrap_hmisc_h("smean.cl.normal")
#' @export
#' @rdname hmisc_h
mean_sdl_h <- wrap_hmisc_h("smean.sdl")
#' @export
#' @rdname hmisc_h
median_hilow_h <- wrap_hmisc_h("smedian.hilow")


#' Calculate mean and standard error
#'
#' For use with \code{\link{stat_summaryh}}. Corresponding function for
#' vertical geoms is \code{\link[ggplot2]{mean_se}()}
#'
#' @param x numeric vector
#' @param mult number of multiples of standard error
#' @return A data frame with columns \code{x}, \code{xmin}, and \code{xmax}.
#' @export
#' @examples
#' x <- rnorm(100)
#' mean_se_h(x)
mean_se_h <- function(x, mult = 1) {
  x <- stats::na.omit(x)
  se <- mult * sqrt(stats::var(x) / length(x))
  mean <- mean(x)
  data.frame(x = mean, xmin = mean - se, xmax = mean + se)
}
