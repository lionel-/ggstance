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
      panels <- unname(split(data, data$PANEL))
      ns <- vapply(panels, function(panel) max(table(panel$ymin)), double(1))
      n <- max(ns)
    }

    list(
      height = self$height,
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
    collidev(
      data,
      params$height,
      name = "position_dodgev",
      strategy = pos_dodgev,
      n = params$n,
      check.height = FALSE
    )
  }
)

# Dodge overlapping interval.
# Assumes that each set has the same horizontal position.
pos_dodgev <- function(df, height, n = NULL) {
  if (is.null(n)) {
    n <- length(unique(df$group))
  }

  if (n == 1)
    return(df)

  if (!all(c("ymin", "ymax") %in% names(df))) {
    df$ymin <- df$y
    df$ymax <- df$y
  }

  d_height <- max(df$ymax - df$ymin)

  # Have a new group index from 1 to number of groups.
  # This might be needed if the group numbers in this set don't include all of 1:n
  groupidy <- match(df$group, sort(unique(df$group)))

  # Find the center for each group, then use that to calculate ymin and ymax
  df$y <- df$y + height * ((groupidy - 0.5) / n - .5)
  df$ymin <- df$y - d_height / n / 2
  df$ymax <- df$y + d_height / n / 2

  df
}
