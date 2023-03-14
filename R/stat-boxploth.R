#' Horizontal boxplot computation.
#'
#' Horizontal version of \code{\link[ggplot2]{stat_boxplot}}().
#' @inheritParams ggplot2::stat_boxplot
#' @eval rd_aesthetics("stat", "boxploth")
#' @export
stat_boxploth <- function(mapping = NULL, data = NULL,
                          geom = "boxploth", position = "dodge2v",
                          ...,
                          coef = 1.5,
                          na.rm = FALSE,
                          show.legend = NA,
                          inherit.aes = TRUE) {
  layer(
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
StatBoxploth <- ggproto("StatBoxploth", Stat,
  required_aes = c("x", "y"),
  non_missing_aes = "weight",

  setup_params = function(data, params) {
    params$width <- params$width %||% (resolution(data$y) * 0.75)

    if (is.double(data$y) && !has_groups(data) && any(data$y != data$y[1L])) {
      warning(
        "Continuous y aesthetic -- did you forget aes(group=...)?",
        call. = FALSE)
    }

    params
  },

  compute_group = function(data, scales, width = NULL, na.rm = FALSE, coef = 1.5) {
    qs <- c(0, 0.25, 0.5, 0.75, 1)

    if (!is.null(data$weight)) {
      if (!requireNamespace("quantreg", quietly = TRUE)) {
        stop("'quantreg' is required for compute_group() with weights")
      }
      mod <- quantreg::rq(x ~ 1, weights = weight, data = data, tau = qs)
      stats <- as.numeric(stats::coef(mod))
    } else {
      stats <- as.numeric(stats::quantile(data$x, qs))
    }
    names(stats) <- c("xmin", "xlower", "xmiddle", "xupper", "xmax")
    iqr <- diff(stats[c(2, 4)])

    outliers <- data$x < (stats[2] - coef * iqr) | data$x > (stats[4] + coef * iqr)
    if (any(outliers)) {
      stats[c(1, 5)] <- range(c(stats[2:4], data$x[!outliers]), na.rm = TRUE)
    }

    if (length(unique(data$y)) > 1)
      width <- diff(range(data$y)) * 0.9

    df <- as.data.frame(as.list(stats))
    df$outliers <- list(data$x[outliers])

    if (is.null(data$weight)) {
      n <- sum(!is.na(data$x))
    } else {
      # Sum up weights for non-NA positions of y and weight
      n <- sum(data$weight[!is.na(data$x) & !is.na(data$weight)])
    }

    df$notchupper <- df$xmiddle + 1.58 * iqr / sqrt(n)
    df$notchlower <- df$xmiddle - 1.58 * iqr / sqrt(n)

    df$y <- if (is.factor(data$y)) data$y[1] else mean(range(data$y))
    df$width <- width
    df$relvarwidth <- sqrt(n)
    df
  }
)

has_groups <- generate("has_groups")
