#' @rdname position-vertical
#' @export
position_jitterdodgev <- function(jitter.height = NULL, jitter.width = 0,
                                  dodge.height = 0.75, seed = NA) {
  if (!is.null(seed) && is.na(seed)) {
    seed <- sample.int(.Machine$integer.max, 1L)
  }

  ggproto(NULL, PositionJitterdodgev,
    jitter.width = jitter.width,
    jitter.height = jitter.height,
    dodge.height = dodge.height,
    seed = seed
  )
}

#' @rdname ggstance-ggproto
#' @format NULL
#' @usage NULL
#' @export
PositionJitterdodgev <- ggproto("PositionJitterdodgev", Position,
  jitter.width = NULL,
  jitter.height = NULL,
  dodge.height = NULL,

  required_aes = c("x", "y"),

  setup_params = function(self, data) {
    height <- self$jitter.height %||% (resolution(data$y, zero = FALSE) * 0.4)
    # Adjust the x transformation based on the number of 'dodge' variables
    dodgecols <- intersect(c("fill", "colour", "linetype", "shape", "size", "alpha"), colnames(data))
    if (length(dodgecols) == 0) {
      stop("`position_jitterdodge()` requires at least one aesthetic to dodge by", call. = FALSE)
    }
    ndodge    <- lapply(data[dodgecols], levels)  # returns NULL for numeric, i.e. non-dodge layers
    ndodge    <- length(unique(unlist(ndodge)))

    list(
      dodge.height = self$dodge.height,
      jitter.width = self$jitter.width,
      jitter.height = height / (ndodge + 2),
      seed = self$seed
    )
  },

  compute_panel = function(data, params, scales) {
    data <- collidev(data, params$dodge.height, "position_jitterdodgev", pos_dodgev,
      check.height = FALSE)

    trans_x <- if (params$jitter.width > 0) function(x) jitter(x, amount = params$jitter.width)
    trans_y <- if (params$jitter.height > 0) function(x) jitter(x, amount = params$jitter.height)

    with_seed_null(params$seed, ggplot2::transform_position(data, trans_x, trans_y))
  }
)

with_seed_null <- function(seed, code) {
  if (is.null(seed)) {
    code
  } else {
    withr::with_seed(seed, code)
  }
}
