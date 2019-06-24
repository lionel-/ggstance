
#' @rdname geom_linerangeh
#' @eval rd_aesthetics("geom", "crossbarh")
#' @export
geom_crossbarh <- function(mapping = NULL, data = NULL,
                           stat = "identity", position = "identity",
                           ...,
                           fatten = 2.5,
                           na.rm = FALSE,
                           show.legend = NA,
                           inherit.aes = TRUE) {
  layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomCrossbarh,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      fatten = fatten,
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
GeomCrossbarh <- ggproto("GeomCrossbarh", Geom,
  setup_data = function(data, params) {
    GeomErrorbarh$setup_data(data, params)
  },

  default_aes = aes(colour = "black", fill = NA, size = 0.5, linetype = 1,
    alpha = NA),

  required_aes = c("x", "y", "xmin", "xmax"),

  draw_key = draw_key_crossbarh,

  draw_panel = function(data, panel_params, coord, fatten = 2.5, width = NULL) {
    middle <- transform(data, y = ymin, yend = ymax, xend = x, size = size * fatten, alpha = NA)

    has_notch <- !is.null(data$ynotchlower) && !is.null(data$ynotchupper) &&
      !is.na(data$ynotchlower) && !is.na(data$ynotchupper)

    if (has_notch) {
      if (data$ynotchlower < data$xmin  ||  data$ynotchupper > data$xmax)
        message("notch went outside hinges. Try setting notch=FALSE.")

      notchindent <- (1 - data$notchwidth) * (data$ymax - data$ymin) / 2

      middle$y <- middle$y + notchindent
      middle$yend <- middle$yend - notchindent

      box <- data.frame(
        y = c(
          data$ymin, data$ymin, data$ymin + notchindent, data$ymin, data$ymin,
          data$ymax, data$ymax, data$ymax - notchindent, data$ymax, data$ymax,
          data$ymin
        ),
        x = c(
          data$xmax, data$ynotchupper, data$x, data$ynotchlower, data$xmin,
          data$xmin, data$ynotchlower, data$x, data$ynotchupper, data$xmax,
          data$xmax
        ),
        alpha = data$alpha,
        colour = data$colour,
        size = data$size,
        linetype = data$linetype, fill = data$fill,
        group = seq_len(nrow(data)),
        stringsAsFactors = FALSE
      )
    } else {
      # No notch
      box <- data.frame(
        y = c(data$ymin, data$ymin, data$ymax, data$ymax, data$ymin),
        x = c(data$xmax, data$xmin, data$xmin, data$xmax, data$xmax),
        alpha = data$alpha,
        colour = data$colour,
        size = data$size,
        linetype = data$linetype,
        fill = data$fill,
        group = seq_len(nrow(data)), # each bar forms it's own group
        stringsAsFactors = FALSE
      )
    }

    ggname("geom_crossbarh", gTree(children = gList(
      GeomPolygon$draw_panel(box, panel_params, coord),
      GeomSegment$draw_panel(middle, panel_params, coord)
    )))
  }
)
