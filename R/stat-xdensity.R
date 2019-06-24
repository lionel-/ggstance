#' Density computation on x axis.
#'
#' Horizontal version of \code{\link[ggplot2]{stat_ydensity}}().
#' @inheritParams ggplot2::stat_ydensity
#' @eval rd_aesthetics("stat", "xdensity")
#' @export
stat_xdensity <- function(mapping = NULL, data = NULL,
                          geom = "violinh", position = "dodgev",
                          ...,
                          bw = "nrd0",
                          adjust = 1,
                          kernel = "gaussian",
                          trim = TRUE,
                          scale = "area",
                          na.rm = FALSE,
                          show.legend = NA,
                          inherit.aes = TRUE) {
  scale <- match.arg(scale, c("area", "count", "width"))

  layer(
    data = data,
    mapping = mapping,
    stat = StatXdensity,
    geom = geom,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      bw = bw,
      adjust = adjust,
      kernel = kernel,
      trim = trim,
      scale = scale,
      na.rm = na.rm,
      ...
    )
  )
}

calc_bw <- generate("calc_bw")
compute_density <- generate("compute_density")

#' @rdname ggstance-ggproto
#' @format NULL
#' @usage NULL
#' @export
StatXdensity <- ggproto("StatXdensity", Stat,
  required_aes = c("x", "y"),
  non_missing_aes = "weight",

  compute_group = function(data, scales, width = NULL, bw = "nrd0", adjust = 1,
                           kernel = "gaussian", trim = TRUE, na.rm = FALSE) {
    if (nrow(data) < 3) return(data.frame())
    range <- range(data$x, na.rm = TRUE)
    modifier <- if (trim) 0 else 3
    bw <- calc_bw(data$x, bw)
    dens <- compute_density(data$x, data$w, from = range[1] - modifier*bw, to = range[2] + modifier*bw,
      bw = bw, adjust = adjust, kernel = kernel)

    # dens$y <- dens$x
    dens$y <- mean(range(data$y))

    # Compute width if x has multiple values
    if (length(unique(data$y)) > 1) {
      width <- diff(range(data$y)) * 0.9
    }
    dens$width <- width

    dens
  },

  compute_panel = function(self, data, scales, width = NULL, bw = "nrd0", adjust = 1,
                           kernel = "gaussian", trim = TRUE, na.rm = FALSE,
                           scale = "area") {
    data <- ggproto_parent(Stat, self)$compute_panel(
      data, scales, width = width, bw = bw, adjust = adjust, kernel = kernel,
      trim = trim, na.rm = na.rm
    )

    # choose how violins are scaled relative to each other
    data$violinwidth <- switch(scale,
      # area : keep the original densities but scale them to a max width of 1
      #        for plotting purposes only
      area = data$density / max(data$density),
      # count: use the original densities scaled to a maximum of 1 (as above)
      #        and then scale them according to the number of observations
      count = data$density / max(data$density) * data$n / max(data$n),
      # width: constant width (density scaled to a maximum of 1)
      width = data$scaled
    )
    data
  }

)

