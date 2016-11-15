#' Horizontal box and whiskers plot.
#'
#' Horizontal version of \code{\link[ggplot2]{geom_boxplot}()}.
#' @inheritParams ggplot2::geom_boxplot
#' @inheritParams ggplot2::geom_point
#' @param outlier.colour,outlier.color,outlier.shape,outlier.size,outlier.stroke
#'   Default aesthetics for outliers. Set to \code{NULL} to inherit from the
#'   aesthetics used for the box.
#'
#'   In the unlikely event you specify both US and UK spellings of colour, the
#'   US spelling will take precedence.
#' @export
geom_boxploth <- function(mapping = NULL, data = NULL,
                          stat = "boxploth", position = "dodgev",
                          ...,
                          outlier.colour = NULL,
                          outlier.color = NULL,
                          outlier.shape = 19,
                          outlier.size = 1.5,
                          outlier.stroke = 0.5,
                          notch = FALSE,
                          notchwidth = 0.5,
                          varwidth = FALSE,
                          na.rm = FALSE,
                          show.legend = NA,
                          inherit.aes = TRUE) {
  layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomBoxploth,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      outlier.colour = outlier.colour,
      outlier.shape = outlier.shape,
      outlier.size = outlier.size,
      outlier.stroke = outlier.stroke,
      notch = notch,
      notchwidth = notchwidth,
      varwidth = varwidth,
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
GeomBoxploth <- ggproto("GeomBoxploth", Geom,
  setup_data = function(data, params) {
    data$width <- data$width %||%
      params$width %||% (resolution(data$y, FALSE) * 0.9)

    if (!is.null(data$outliers)) {
      suppressWarnings({
        out_min <- vapply(data$outliers, min, numeric(1))
        out_max <- vapply(data$outliers, max, numeric(1))
      })

      data$xmin_final <- pmin(out_min, data$xmin)
      data$xmax_final <- pmax(out_max, data$xmax)
    }

    # if `varwidth` not requested or not available, don't use it
    if (is.null(params) || is.null(params$varwidth) || !params$varwidth || is.null(data$relvarwidth)) {
      data$ymin <- data$y - data$width / 2
      data$ymax <- data$y + data$width / 2
    } else {
      # make `relvarwidth` relative to the size of the largest group
      data$relvarwidth <- data$relvarwidth / max(data$relvarwidth)
      data$ymin <- data$y - data$relvarwidth * data$width / 2
      data$ymax <- data$y + data$relvarwidth * data$width / 2
    }
    data$width <- NULL
    if (!is.null(data$relvarwidth)) data$relvarwidth <- NULL

    data
  },

  draw_group = function(data, panel_scales, coord, fatten = 2,
                        outlier.colour = NULL, outlier.fill = NULL,
                        outlier.shape = 19,
                        outlier.size = 1.5, outlier.stroke = 0.5,
                        outlier.alpha = NULL,
                        notch = FALSE, notchwidth = 0.5, varwidth = FALSE) {

    common <- data.frame(
      colour = data$colour,
      size = data$size,
      linetype = data$linetype,
      fill = alpha(data$fill, data$alpha),
      group = data$group,
      stringsAsFactors = FALSE
    )

    whiskers <- data.frame(
      y = data$y,
      yend = data$y,
      x = c(data$upper, data$lower),
      xend = c(data$xmax, data$xmin),
      alpha = NA,
      common,
      stringsAsFactors = FALSE
    )

    box <- data.frame(
      ymin = data$ymin,
      ymax = data$ymax,
      xmin = data$lower,
      x = data$middle,
      xmax = data$upper,
      ynotchlower = ifelse(notch, data$notchlower, NA),
      ynotchupper = ifelse(notch, data$notchupper, NA),
      notchwidth = notchwidth,
      alpha = data$alpha,
      common,
      stringsAsFactors = FALSE
    )

    if (!is.null(data$outliers) && length(data$outliers[[1]] >= 1)) {
      outliers <- data.frame(
        x = data$outliers[[1]],
        y = data$y[1],
        colour = outlier.colour %||% data$colour[1],
        fill = outlier.fill %||% data$fill[1],
        shape = outlier.shape %||% data$shape[1],
        size = outlier.size %||% data$size[1],
        stroke = outlier.stroke %||% data$stroke[1],
        fill = NA,
        alpha = outlier.alpha %||% data$alpha[1],
        stringsAsFactors = FALSE
      )
      outliers_grob <- GeomPoint$draw_panel(outliers, panel_scales, coord)
    } else {
      outliers_grob <- NULL
    }

    ggname("geom_boxploth", grobTree(
      outliers_grob,
      GeomSegment$draw_panel(whiskers, panel_scales, coord),
      GeomCrossbarh$draw_panel(box, fatten = fatten, panel_scales, coord)
    ))
  },

  draw_key = draw_key_boxploth,

  default_aes = aes(weight = 1, colour = "grey20", fill = "white", size = 0.5,
    alpha = NA, shape = 19, linetype = "solid"),

  required_aes = c("y", "lower", "upper", "middle", "xmin", "xmax")
)

