#' Vertical Positions
#'
#' Vertical versions of \code{\link[ggplot2]{position_dodge}()},
#' \code{\link[ggplot2]{position_jitterdodge}()},
#' \code{\link[ggplot2]{position_fill}()},
#' \code{\link[ggplot2]{position_stack}()},
#' @name position-vertical
#' @inheritParams ggplot2::position_jitterdodge
#' @inheritParams ggplot2::position_nudge
#' @inheritParams ggplot2::position_dodge
#' @param height Dodging height, when different to the height of the individual
#'   elements. This is useful when you want to align narrow geoms with taller
#'   geoms.
#' @param dodge.height the amount to dodge in the y direction. Defaults to 0.75,
#'   the default \code{position_dodgev()} height.
NULL
collidev_setup <- function(data, height = NULL, name, strategy,
                           check.height = TRUE, reverse = FALSE) {
  # Determine height
  if (!is.null(height)) {
    # Width set manually
    if (!(all(c("ymin", "ymax") %in% names(data)))) {
      data$ymin <- data$y - height / 2
      data$ymax <- data$y + height / 2
    }
  } else {
    if (!(all(c("ymin", "ymax") %in% names(data)))) {
      data$ymin <- data$y
      data$ymax <- data$y
    }

    # Width determined from data, must be floating point constant
    heights <- unique(data$ymax - data$ymin)
    heights <- heights[!is.na(heights)]

#   # Suppress warning message since it's not reliable
#     if (!zero_range(range(heights))) {
#       warning(name, " requires constant height: output may be incorrect",
#         call. = FALSE)
#     }
    height <- heights[1]
  }

  list(data = data, height = height)
}

collidev <- function(data, height = NULL, name, strategy,
                     ..., check.height = TRUE, reverse = FALSE) {
  dlist <- collidev_setup(data, height, name, strategy, check.height, reverse)
  data <- dlist$data
  height <- dlist$height

  # Reorder by x position, then on group. The default stacking order reverses
  # the group in order to match the legend order.
  if (reverse) {
    data <- data[order(data$ymin, data$group), ]
  } else {
    data <- data[order(data$ymin, -data$group), ]
  }


  # Check for overlap
  intervals <- as.numeric(t(unique(data[c("ymin", "ymax")])))
  intervals <- intervals[!is.na(intervals)]

  if (length(unique(intervals)) > 1 & any(diff(scale(intervals)) < -1e-6)) {
    warning(name, " requires non-overlapping y intervals", call. = FALSE)
    # This is where the algorithm from [L. Wilkinson. Dot plots.
    # The American Statistician, 1999.] should be used
  }

  if (!is.null(data$xmax)) {
    plyr::ddply(data, "ymin", strategy, ..., height = height)
  } else if (!is.null(data$x)) {
    data$xmax <- data$x
    data <- plyr::ddply(data, "ymin", strategy, ..., height = height)
    data$x <- data$xmax
    data
  } else {
    stop("Neither x nor xmax defined")
  }
}

# Alternate version of collidev() used by position_dodgev2()
collide2v <- function(data, height = NULL, name, strategy,
                      ..., check.height = TRUE, reverse = FALSE) {
  dlist <- collidev_setup(data, height, name, strategy, check.height, reverse)
  data <- dlist$data
  height <- dlist$height

  # Reorder by x position, then on group. The default stacking order is
  # different than for collide() because of the order in which pos_dodge2 places
  # elements
  if (reverse) {
    data <- data[order(data$y, -data$group), ]
  } else {
    data <- data[order(data$y, data$group), ]
  }

  pos <- match.fun(strategy)
  pos(data, height, ...)
}
