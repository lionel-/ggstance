#' Horizontal binning.
#'
#' Horizontal version of \code{\link[ggplot2]{stat_bin}}().
#'
#' @eval rd_aesthetics("stat", "binh")
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

  layer(
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
StatBinh <- ggproto("StatBinh", Stat,
  setup_params = function(data, params) {
    if (!is.null(data$x) || !is.null(params$x)) {
      stop("stat_bin() must not be used with a x aesthetic.", call. = FALSE)
    }
    if (is.integer(data$y)) {
      stop('StatBin requires a continuous y variable the y variable is discrete. Perhaps you want stat="count"?',
        call. = FALSE)
    }

    if (!is.null(params$drop)) {
      warning("`drop` is deprecated. Please use `pad` instead.", call. = FALSE)
      params$drop <- NULL
    }
    if (!is.null(params$origin)) {
      warning("`origin` is deprecated. Please use `boundary` instead.", call. = FALSE)
      params$boundary <- params$origin
      params$origin <- NULL
    }
    if (!is.null(params$right)) {
      warning("`right` is deprecated. Please use `closed` instead.", call. = FALSE)
      params$closed <- if (params$right) "right" else "left"
      params$right <- NULL
    }
    if (!is.null(params$width)) {
      stop("`width` is deprecated. Do you want `geom_barh()`?", call. = FALSE)
    }
    if (!is.null(params$boundary) && !is.null(params$center)) {
      stop("Only one of `boundary` and `center` may be specified.", call. = FALSE)
    }

    if (is.null(params$breaks) && is.null(params$binheight) && is.null(params$bins)) {
      message_wrap("`stat_bin()` using `bins = 30`. Pick better value with `binwidth`.")
      params$bins <- 30
    }

    params
  },

  compute_group = function(data, scales, binwidth = NULL, bins = NULL,
                           center = NULL, boundary = NULL,
                           closed = c("right", "left"), pad = FALSE,
                           # The following arguments are not used, but must
                           # be listed so parameters are computed correctly
                           breaks = NULL, origin = NULL, right = NULL,
                           drop = NULL, width = NULL) {
    if (!is.null(breaks)) {
      bins <- bin_breaks(breaks, closed)
    } else if (!is.null(binwidth)) {
      bins <- bin_breaks_width(scales$y$dimension(), binwidth, center = center,
        boundary = boundary, closed = closed)
    } else {
      bins <- bin_breaks_bins(scales$y$dimension(), bins, center = center,
        boundary = boundary, closed = closed)
    }
    data <- bin_vector(data$y, bins, weight = data$weight, pad = pad)
    flip_aes(data)
  },

  default_aes = aes(x = ..count..),
  required_aes = c("y")
)

bin_breaks <- generate("bin_breaks")
bin_breaks_width <- generate("bin_breaks_width")
bin_breaks_bins <- generate("bin_breaks_bins")
bin_vector <- generate("bin_vector")
