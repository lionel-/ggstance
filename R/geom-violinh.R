#' Horizontal violin plot.
#'
#' Horizontal version of \code{\link[ggplot2]{geom_violin}()}.
#' @inheritParams ggplot2::geom_violin
#' @inheritParams ggplot2::geom_point
#' @export
geom_violinh <- function(mapping = NULL, data = NULL,
                         stat = "xdensity", position = "dodgev",
                         ...,
                         draw_quantiles = NULL,
                         trim = TRUE,
                         scale = "area",
                         na.rm = FALSE,
                         show.legend = NA,
                         inherit.aes = TRUE) {
  layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomViolinh,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      trim = trim,
      scale = scale,
      draw_quantiles = draw_quantiles,
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
GeomViolinh <- ggproto("GeomViolinh", Geom,
  setup_data = function(data, params) {
    data$width <- data$width %||%
      params$width %||% (resolution(data$y, FALSE) * 0.9)

    # ymin, ymax, xmin, and xmax define the bounding rectangle for each group
    plyr::ddply(data, "group", transform,
      ymin = y - width / 2,
      ymax = y + width / 2
    )
  },

  draw_group = function(self, data, ..., draw_quantiles = NULL) {
    # Find the points for the line to go all the way around
    data <- transform(data,
      yminv = y - violinwidth * (y - ymin),
      ymaxv = y + violinwidth * (ymax - y)
    )

    # Make sure it's sorted properly to draw the outline
    newdata <- rbind(
      plyr::arrange(transform(data, y = yminv), x),
      plyr::arrange(transform(data, y = ymaxv), -x)
    )

    # Close the polygon: set first and last point the same
    # Needed for coord_polar and such
    newdata <- rbind(newdata, newdata[1,])

    # Draw quantiles if requested, so long as there is non-zero y range
    if (length(draw_quantiles) > 0 & !scales::zero_range(range(data$x))) {
      stopifnot(all(draw_quantiles >= 0), all(draw_quantiles <= 1))

      # Compute the quantile segments and combine with existing aesthetics
      quantiles <- create_quantile_segment_frame(data, draw_quantiles)
      aesthetics <- data[
        rep(1, nrow(quantiles)),
        setdiff(names(data), c("x", "y")),
        drop = FALSE
      ]
      aesthetics$alpha <- rep(1, nrow(quantiles))
      both <- cbind(quantiles, aesthetics)
      quantile_grob <- GeomPath$draw_panel(both, ...)

      ggname("geom_violin", grobTree(
        GeomPolygon$draw_panel(newdata, ...),
        quantile_grob)
      )
    } else {
      ggname("geom_violin", GeomPolygon$draw_panel(newdata, ...))
    }
  },

  draw_key = draw_key_polygon,

  default_aes = aes(weight = 1, colour = "grey20", fill = "white", size = 0.5,
    alpha = NA, linetype = "solid"),

  required_aes = c("x", "y")
)
