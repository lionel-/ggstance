#' @rdname position-vertical
#' @export
position_dodgev <- function(height = NULL, preserve = c("total", "single")) {
  ggproto(NULL, PositionDodgev,
    height = height,
    preserve = match.arg(preserve)
  )
}

#' @rdname ggstance-ggproto
#' @format NULL
#' @usage NULL
#' @export
PositionDodgev <- ggproto("PositionDodgev", Position,
  height = NULL,
  preserve = "total",
  setup_params = function(self, data) {
    if (is.null(data$ymin) && is.null(data$ymax) && is.null(self$height)) {
      warning("Height not defined. Set with `position_dodge(height = ?)`",
        call. = FALSE)
    }

    if (identical(self$preserve, "total")) {
      n <- NULL
    } else {
      n <- max(table(data$xmin))
    }

    list(
      width = self$width,
      n = n
    )
  },

  setup_data = function(self, data, params) {
    if (!"y" %in% names(data) && all(c("ymin", "ymax") %in% names(data))) {
      data$y <- (data$ymin + data$ymax) / 2
    }
    data
  },

  compute_panel = function(data, params, scales) {
    collide(
      data,
      params$width,
      name = "position_dodge",
      strategy = pos_dodge,
      n = params$n,
      check.width = FALSE
    )
  }
)

# Dodge overlapping interval.
# Assumes that each set has the same horizontal position.
pos_dodge <- function(df, width, n = NULL) {
  if (is.null(n)) {
    n <- length(unique(df$group))
  }

  if (n == 1)
    return(df)

  if (!all(c("xmin", "xmax") %in% names(df))) {
    df$xmin <- df$x
    df$xmax <- df$x
  }

  d_width <- max(df$xmax - df$xmin)

  # Have a new group index from 1 to number of groups.
  # This might be needed if the group numbers in this set don't include all of 1:n
  groupidx <- match(df$group, sort(unique(df$group)))

  # Find the center for each group, then use that to calculate xmin and xmax
  df$x <- df$x + width * ((groupidx - 0.5) / n - .5)
  df$xmin <- df$x - d_width / n / 2
  df$xmax <- df$x + d_width / n / 2

  df
}
