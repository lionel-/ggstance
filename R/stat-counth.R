#' Horizontal counting.
#'
#' Horizontal version of \code{\link[ggplot2]{stat_count}}().
#' @inheritParams ggplot2::stat_count
#' @eval rd_aesthetics("stat", "counth")
#' @export
stat_counth <- function(mapping = NULL, data = NULL,
                        geom = "barh", position = "stackv",
                        ...,
                        width = NULL,
                        na.rm = FALSE,
                        show.legend = NA,
                        inherit.aes = TRUE) {
  layer(
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
StatCounth <- ggproto("StatCounth", Stat,
  required_aes = "y",
  default_aes = aes(x = ..count.., weight = 1),

  setup_params = function(data, params) {
    if (!is.null(data$x)) {
      stop("stat_counth() must not be used with a x aesthetic.", call. = FALSE)
    }
    params
  },

  compute_group = function(self, data, scales, width = NULL) {
    y <- data$y
    weight <- data$weight %||% rep(1, length(y))
    width <- width %||% (resolution(y) * 0.9)

    count <- as.numeric(tapply(weight, y, sum, na.rm = TRUE))
    count[is.na(count)] <- 0

    data.frame(
      count = count,
      prop = count / sum(abs(count)),
      y = sort(unique(y)),
      width = width
    )
  }
)
