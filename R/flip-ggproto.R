#' @include utils.R
NULL

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

#' @export
flip_ggproto <- function(gg) {
  UseMethod("flip_ggproto")
}

#' @export
flip_ggproto.default <- function(gg) gg
