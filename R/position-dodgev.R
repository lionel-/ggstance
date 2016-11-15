#' @rdname position-vertical
#' @export
position_dodgev <- function(height = NULL) {
  ggproto(NULL, PositionDodgev, height = height)
}

#' @rdname ggstance-ggproto
#' @format NULL
#' @usage NULL
#' @export
PositionDodgev <- ggproto("PositionDodgev", Position,
  required_aes = "y",
  height = NULL,
  setup_params = function(self, data) {
    if (is.null(data$ymin) && is.null(data$ymax) && is.null(self$height)) {
      warning("Height not defined. Set with `position_dodge(height = ?)`",
        call. = FALSE)
    }
    list(height = self$height)
  },

  compute_panel = function(data, params, scales) {
    collidev(data, params$height, "position_dodgev", pos_dodgev, check.height = FALSE)
  }
)

pos_dodgev <- function(df, height) {
  n <- length(unique(df$group))
  if (n == 1) return(df)

  if (!all(c("ymin", "ymax") %in% names(df))) {
    df$ymin <- df$y
    df$ymax <- df$y
  }

  d_height <- max(df$ymax - df$ymin)

  # df <- data.frame(n = c(2:5, 10, 26), div = c(4, 3, 2.666666,  2.5, 2.2, 2.1))
  # ggplot(df, aes(n, div)) + geom_point()

  # Have a new group index from 1 to number of groups.
  # This might be needed if the group numbers in this set don't include all of 1:n
  groupidx <- match(df$group, sort(unique(df$group)))

  # Find the center for each group, then use that to calculate ymin and lmax
  df$y <- df$y + height * ((groupidx - 0.5) / n - .5)
  df$ymin <- df$y - d_height / n / 2
  df$ymax <- df$y + d_height / n / 2

  df
}
