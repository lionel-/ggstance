#' Horizontal key drawing functions
#'
#' @inheritParams ggplot2::draw_key
#' @return A grid grob.
#' @name draw_key
globalVariables(c("alpha", ".pt"))

#' @rdname draw_key
#' @export
draw_key_hpath <- function(data, params, size) {
  segmentsGrob(0.1, 0.5, 0.9, 0.5,
    gp = gpar(
      col = alpha(data$colour, data$alpha),
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
  grobTree(
    draw_key_hpath(data, params, size),
    draw_key_point(transform(data, size = data$size * 4), params)
  )
}

#' @rdname draw_key
#' @export
draw_key_crossbarh <- function(data, params, size) {
  grobTree(
    rectGrob(height = 0.75, width = 0.5),
    linesGrob(0.5, c(0.125, 0.875)),
    gp = gpar(
      col = data$colour,
      fill = alpha(data$fill, data$alpha),
      lwd = data$size * .pt,
      lty = data$linetype
    )
  )
}

#' @rdname draw_key
#' @export
draw_key_boxploth <- function(data, params, size) {
  grobTree(
    linesGrob(c(0.1, 0.25), 0.5),
    linesGrob(c(0.75, 0.9), 0.5),
    rectGrob(height = 0.75, width = 0.5),
    linesGrob(0.5, c(0.125, 0.875)),
    gp = gpar(
      col = data$colour,
      fill = alpha(data$fill, data$alpha),
      lwd = data$size * .pt,
      lty = data$linetype
    )
  )
}
