#' Horizontal key drawing functions
#'
#' @inheritParams ggplot2::draw_key
#' @return A grid grob.
#' @name draw_key
globalVariables(c("alpha", ".pt"))

#' @rdname draw_key
#' @export
draw_key_hpath <- function(data, params, size) {
  grid::segmentsGrob(0.1, 0.5, 0.9, 0.5,
    gp = grid::gpar(
      col = ggplot2::alpha(data$colour, data$alpha),
      lwd = data$size * .pt,
      lty = data$linetype,
      lineend = "butt"
    ),
    arrow = params$arrow
  )
}

#' @rdname draw_key
#' @export
draw_key_pointrangeh <- function(data, params, size) {
  grid::grobTree(
    draw_key_hpath(data, params, size),
    ggplot2::draw_key_point(transform(data, size = data$size * 4), params)
  )
}

#' @rdname draw_key
#' @export
draw_key_crossbarh <- function(data, params, size) {
  grid::grobTree(
    grid::rectGrob(height = 0.75, width = 0.5),
    grid::linesGrob(0.5, c(0.125, 0.875)),
    gp = grid::gpar(
      col = data$colour,
      fill = ggplot2::alpha(data$fill, data$alpha),
      lwd = data$size * .pt,
      lty = data$linetype
    )
  )
}

#' @rdname draw_key
#' @export
draw_key_boxploth <- function(data, params, size) {
  grid::grobTree(
    grid::linesGrob(c(0.1, 0.25), 0.5),
    grid::linesGrob(c(0.75, 0.9), 0.5),
    grid::rectGrob(height = 0.75, width = 0.5),
    grid::linesGrob(0.5, c(0.125, 0.875)),
    gp = grid::gpar(
      col = data$colour,
      fill = ggplot2::alpha(data$fill, data$alpha),
      lwd = data$size * .pt,
      lty = data$linetype
    )
  )
}
