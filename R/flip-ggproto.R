#' Flip ggproto objects
#'
#' These functions flip standard ggproto components to horizontal
#' orientation.
#' @param .gg A Stat, Geom or Position ggproto.
#' @param ... Methods to be overridden.
#' @name flip_ggproto
NULL

#' @rdname flip_ggproto
#' @export
flip_geom <- function(.gg, ...) {
  ggflipped(.gg,
    default_aes = flip_aes(.gg$default_aes),
    required_aes = flip_aes(.gg$required_aes),

    # setup_data() needs original data but is called by
    # compute_geom_1() with flipped data
    setup_data = flip_method_outer(.gg$setup_data,
      what = "data", roundtrip = "data"),

    ...
  )
}

#' @rdname flip_ggproto
#' @export
flip_stat <- function(.gg, ...) {
  ggflipped(.gg,
    default_aes = flip_aes(.gg$default_aes),

    setup_params = flip_method_outer(.gg$setup_params,
      what = "data"),
    compute_layer = flip_method_outer(.gg$compute_layer,
      what = c("data", "scales", "required_aes_error"),
      roundtrip = "data"),

    ...
  )
}

# Clones a ggproto object and append \code{h} to its class name.
ggflipped <- function(.gg, ...) {
  new_class <- paste0(class(.gg)[[1]], "h")
  ggclone(new_class, .gg, .gg, ...)
}

ggclone <- function(.class, .gg, .super, ...) {
  skeleton <- as.list(.gg, inherit = FALSE)
  clone <- list2env(skeleton, parent = emptyenv())
  clone$super <- function() .super

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
