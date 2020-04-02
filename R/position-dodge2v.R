#' @export
#' @rdname position-vertical
#' @param padding Padding between elements at the same position. Elements are
#'   shrunk by this proportion to allow space between them. Defaults to 0.1.
position_dodge2v <- function(height = NULL, preserve = c("single", "total"),
                             padding = 0.1, reverse = TRUE) {
  ggproto(NULL, PositionDodge2v,
    height = height,
    preserve = match.arg(preserve),
    padding = padding,
    reverse = reverse
  )
}

#' @rdname ggstance-ggproto
#' @format NULL
#' @usage NULL
#' @include position-dodgev.R
#' @export
PositionDodge2v <- ggproto("PositionDodge2v", PositionDodgev,
  preserve = "total",
  padding = 0.1,
  reverse = TRUE,

  setup_params = function(self, data) {
    if (is.null(data$ymin) && is.null(data$ymax) && is.null(self$height)) {
      warning("Height not defined. Set with `position_dodge2v(height = ?)`",
        call. = FALSE)
    }

    if (identical(self$preserve, "total")) {
      n <- NULL
    } else {
      panels <- unname(split(data, data$PANEL))
      if ("y" %in% names(data)) {
        # Point geom
        groups <- lapply(panels, function(panel) table(panel$y))
      } else {
        # Interval geom
        groups <- lapply(panels, find_y_overlaps)
      }
      n_groups <- vapply(groups, max, double(1))
      n <- max(n_groups)
    }

    list(
      height = self$height,
      n = n,
      padding = self$padding,
      reverse = self$reverse
    )
  },

  compute_panel = function(data, params, scales) {
    collide2v(
      data,
      params$height,
      name = "position_dodge2v",
      strategy = pos_dodge2v,
      n = params$n,
      padding = params$padding,
      check.height = FALSE,
      reverse = params$reverse
    )
  }
)

pos_dodge2v <- function(df, height, n = NULL, padding = 0.1) {
  if (!all(c("ymin", "ymax") %in% names(df))) {
    df$ymin <- df$y
    df$ymax <- df$y
  }

  # yid represents groups of boxes that share the same position
  df$yid <- find_y_overlaps(df)

  # based on yid find newy, i.e. the center of each group of overlapping
  # elements. for boxes, bars, etc. this should be the same as original y, but
  # for arbitrary rects it may not be
  newy <- (tapply(df$ymin, df$yid, min) + tapply(df$ymax, df$yid, max)) / 2
  df$newy <- newy[df$yid]

  if (is.null(n)) {
    # If n is null, preserve total widths of elements at each position by
    # dividing widths by the number of elements at that position
    n <- table(df$yid)
    df$new_height <- (df$ymax - df$ymin) / as.numeric(n[df$yid])
  } else {
    df$new_height <- (df$ymax - df$ymin) / n
  }

  # Find the total height of each group of elements
  group_sizes <- stats::aggregate(
    list(size = df$new_height),
    list(newy = df$newy),
    sum
  )

  # Starting ymin for each group of elements
  starts <- group_sizes$newy - (group_sizes$size / 2)

  # Set the elements in place
  for (i in seq_along(starts)) {
    divisions <- cumsum(c(starts[i], df[df$yid == i, "new_height"]))
    df[df$yid == i, "ymin"] <- divisions[-length(divisions)]
    df[df$yid == i, "ymax"] <- divisions[-1]
  }

  # y values get moved to between ymin and ymax
  df$y <- (df$ymin + df$ymax) / 2

  # If no elements occupy the same position, there is no need to add padding
  if (!any(duplicated(df$yid))) {
    return(df)
  }

  # Shrink elements to add space between them
  df$pad_height <- df$new_height * (1 - padding)
  df$ymin <- df$y - (df$pad_height / 2)
  df$ymax <- df$y + (df$pad_height / 2)

  df$yid <- NULL
  df$newy <- NULL
  df$new_height <- NULL
  df$pad_height <- NULL

  df
}

# Find groups of overlapping elements that need to be dodged from one another
find_y_overlaps <- function(df) {
  overlaps <- numeric(nrow(df))
  overlaps[1] <- counter <- 1

  for (i in seq_asc(2, nrow(df))) {
    if (df$ymin[i] >= df$ymax[i - 1]) {
      counter <- counter + 1
    }
    overlaps[i] <- counter
  }
  overlaps
}

seq_asc <- function(to, from) {
  if (to > from) {
    integer()
  } else {
    to:from
  }
}
