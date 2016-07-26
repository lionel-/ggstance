#' Flip a ggproto object
#'
#' S3 generic for flipping a ggproto object to horizontal orientation.
#' @param gg A ggproto object.
#' @param ... Methods to be overridden.
#' @export
flip_ggproto <- function(gg, ...) {
  UseMethod("flip_ggproto")
}

#' @export
flip_ggproto.Geom <- function(gg, ...) {
  ggflipped(gg,
    default_aes = flip_aes(gg$default_aes),
    required_aes = flip_aes(gg$required_aes),

    # setup_data() needs original data but is called by
    # compute_geom_1() with flipped data
    setup_data = flip_method_outer(gg$setup_data,
      what = "data", roundtrip = "data"),

    ...
  )
}

#' @export
flip_ggproto.Stat <- function(gg, ...) {
  ggflipped(gg,
    default_aes = flip_aes(gg$default_aes),

    setup_params = flip_method_outer(gg$setup_params,
      what = "data"),
    compute_layer = flip_method_outer(gg$compute_layer,
      what = c("data", "scales", "required_aes_error"),
      roundtrip = "data"),

    ...
  )
}

#' Clone a ggproto object to be flipped
#'
#' Clone a ggproto object and append \code{h} to its class name.
#' @inheritParams flip_ggproto
#' @export
ggflipped <- function(gg, ...) {
  new_class <- paste0(class(gg)[[1]], "h")
  ggclone(new_class, gg, gg, ...)
}

ggclone <- function(.class, .gg, .super, ...) {
  skeleton <- as.list(.gg, inherit = FALSE)
  clone <- list2env(skeleton, parent = emptyenv())
  clone$super <- .super

  clone <- ggmutate(clone, ...)
  structure(clone, class = c(.class, class(.super)))
}

ggmutate <- function(gg, ...) {
  dots <- list(...)
  if (length(dots)) {
    fields <- names(dots)
    if (!length(fields) || purrr::some(fields, `==`, "")) {
      stop("Unnamed ggproto fields", call. = FALSE)
    }
    purrr::walk2(names(dots), dots, assign, envir = gg)
  }
  gg
}
