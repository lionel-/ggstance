#' Vertical Positions
#'
#' Vertical versions of \code{\link[ggplot2]{position_dodge}()},
#' \code{\link[ggplot2]{position_jitterdodge}()},
#' \code{\link[ggplot2]{position_fill}()},
#' \code{\link[ggplot2]{position_stack}()},
#' @name position-vertical
#' @inheritParams ggplot2::position_jitterdodge
#' @inheritParams ggplot2::position_nudge
#' @param height Dodging height, when different to the height of the individual
#'   elements. This is useful when you want to align narrow geoms with taller
#'   geoms.
#' @param dodge.height the amount to dodge in the y direction. Defaults to 0.75,
#'   the default \code{position_dodgev()} height.
NULL

#' @export
flip_ggproto.Position <- function(gg, ...) {
  ggflipped(gg,
    setup_params = flip_method_outer(gg$setup_params),

    # Need to flip once again because setup_params() does not return data
    setup_data = flip_method_outer(gg$setup_data),

    compute_layer = flip_method_outer(gg$compute_layer, what = NULL, roundtrip = "data"),

    ...
  )
}

#' @rdname ggstance-ggproto
#' @format NULL
#' @usage NULL
#' @export
PositionDodgev <- flip_ggproto(ggplot2::PositionDodge)

#' @rdname ggstance-ggproto
#' @format NULL
#' @usage NULL
#' @export
PositionNudgev <- flip_ggproto(ggplot2::PositionNudge)

#' @rdname ggstance-ggproto
#' @format NULL
#' @usage NULL
#' @export
PositionFillv <- flip_ggproto(ggplot2::PositionFill)

#' @rdname ggstance-ggproto
#' @format NULL
#' @usage NULL
#' @export
PositionStackv <- flip_ggproto(ggplot2::PositionStack)

#' @rdname ggstance-ggproto
#' @format NULL
#' @usage NULL
#' @export
PositionJitterdodgev <- flip_ggproto(ggplot2::PositionJitterdodge)

#' @rdname position-vertical
#' @export
position_dodgev <- function(height = NULL) {
  ggplot2::ggproto(NULL, PositionDodgev, width = height)
}

#' @rdname position-vertical
#' @export
position_nudgev <- function(x = 0, y = 0) {
  ggplot2::ggproto(NULL, PositionNudgev,
    x = y,
    y = x
  )
}

#' @rdname position-vertical
#' @export
position_fillv <- function() {
  PositionFillv
}

#' @rdname position-vertical
#' @export
position_stackv <- function() {
  PositionStackv
}

#' @rdname position-vertical
#' @export
position_jitterdodgev <- function(jitter.height = NULL, jitter.width = 0,
                                  dodge.height = 0.75) {
  ggplot2::ggproto(NULL, PositionJitterdodgev,
    jitter.width = jitter.height,
    jitter.height = jitter.width,
    dodge.width = dodge.height
  )
}
