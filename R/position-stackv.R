#' @rdname position-vertical
#' @param hjust Horizontal adjustment for geoms that have a position
#'   (like points or lines), not a dimension (like bars or areas). Set to
#'   `0` to align with the left side, `0.5` for the middle,
#'   and `1` (the default) for the right side.
#' @export
position_stackv <- function(hjust = 1, reverse = FALSE) {
  ggproto(NULL, PositionStackv, hjust = hjust, reverse = reverse)
}

#' @rdname ggstance-ggproto
#' @format NULL
#' @usage NULL
#' @export
PositionStackv <- ggproto("PositionStackv", Position,
  type = NULL,
  hjust = 1,
  fill = FALSE,
  reverse = FALSE,

  setup_params = function(self, data) {
    list(
      var = self$var %||% stack_varv(data),
      fill = self$fill,
      hjust = self$hjust,
      reverse = self$reverse
    )
  },

  setup_data = function(self, data, params) {
    if (is.null(params$var)) {
      return(data)
    }

    data$xmax <- switch(params$var,
      x = data$x,
      xmax = ifelse(data$xmax == 0, data$xmin, data$xmax)
    )

    remove_missing(
      data,
      vars = c("y", "ymin", "ymax", "x"),
      name = "position_stack"
    )
  },

  compute_panel = function(data, params, scales) {
    if (is.null(params$var)) {
      return(data)
    }

    negative <- data$xmax < 0
    neg <- data[negative, , drop = FALSE]
    pos <- data[!negative, , drop = FALSE]

    if (any(negative)) {
      neg <- collidev(neg, NULL, "position_stackv", pos_stackv,
        hjust = params$hjust,
        fill = params$fill,
        reverse = params$reverse
      )
    }
    if (any(!negative)) {
      pos <- collidev(pos, NULL, "position_stackv", pos_stackv,
        hjust = params$hjust,
        fill = params$fill,
        reverse = params$reverse
      )
    }

    rbind(neg, pos)[match(seq_len(nrow(data)), c(which(negative), which(!negative))),]
  }
)

pos_stackv <- function(df, height, hjust = 1, fill = FALSE) {
  n <- nrow(df) + 1
  x <- ifelse(is.na(df$x), 0, df$x)
  widths <- c(0, cumsum(x))

  if (fill) {
    widths <- widths / abs(widths[length(widths)])
  }

  df$xmin <- pmin(widths[-n], widths[-1])
  df$xmax <- pmax(widths[-n], widths[-1])
  df$x <- (1 - hjust) * df$xmin + hjust * df$xmax
  df
}

stack_varv <- function(data) {
  if (!is.null(data$xmax)) {
    if (any(data$xmin != 0 & data$xmax != 0, na.rm = TRUE)) {
      warning("Stacking not well defined when not anchored on the axis", call. = FALSE)
    }
    "xmax"
  } else if (!is.null(data$x)) {
    "x"
  } else {
    warning(
      "Stacking requires either xmin & xmin or x aesthetics.\n",
      "Maybe you want position = 'identity'?",
      call. = FALSE
    )
    NULL
  }
}

#' @rdname position-vertical
#' @export
position_fillv <- function() {
  PositionFillv
}

#' @rdname ggstance-ggproto
#' @format NULL
#' @usage NULL
#' @export
PositionFillv <- ggproto("PositionFillv", PositionStackv,
  fill = TRUE
)
