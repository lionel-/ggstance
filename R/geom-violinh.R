#' Horizontal violin plot.
#'
#' Horizontal version of \code{\link[ggplot2]{geom_violin}()}.
#' @inheritParams ggplot2::geom_violin
#' @inheritParams ggplot2::geom_point
#' @eval rd_aesthetics("geom", "violinh")
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


# Returns a data.frame with info needed to draw quantile segments.
create_quantile_segment_frame <- function(data, draw_quantiles) {

  dens <- cumsum(data$density) / sum(data$density)
  ecdf <- stats::approxfun(dens, data$x)
  xs <- ecdf(draw_quantiles) # these are all the x-values for quantiles

  # Get the violin bounds for the requested quantiles.
  violin.yminvs <- (stats::approxfun(data$x, data$yminv))(xs)
  violin.ymaxvs <- (stats::approxfun(data$x, data$ymaxv))(xs)

  # We have two rows per segment drawn. Each segment gets its own group.
  data.frame(
    x = rep(xs, each = 2),
    y = interleave(violin.yminvs, violin.ymaxvs),
    group = rep(xs, each = 2)
  )
}


# Interleave (or zip) multiple units into one vector
interleave <- function(...) UseMethod("interleave")
#' @export
interleave.unit <- function(...) {
  do.call("unit.c", do.call("interleave.default", plyr::llply(list(...), as.list)))
}
#' @export
interleave.default <- function(...) {
  vectors <- list(...)

  # Check lengths
  lengths <- unique(setdiff(plyr::laply(vectors, length), 1))
  if (length(lengths) == 0) lengths <- 1
  stopifnot(length(lengths) <= 1)

  # Replicate elements of length one up to correct length
  singletons <- plyr::laply(vectors, length) == 1
  vectors[singletons] <- plyr::llply(vectors[singletons], rep, lengths)

  # Interleave vectors
  n <- lengths
  p <- length(vectors)
  interleave <- rep(1:n, each = p) + seq(0, p - 1) * n
  unlist(vectors, recursive = FALSE)[interleave]
}
