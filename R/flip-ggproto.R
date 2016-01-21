
ggflipped <- function(gg, ...) {
  new_class <- paste0(class(gg)[[1]], "h")
  parent_class <- paste0(class(gg$super)[[1]], "h")
  if (exists(parent_class)) {
    parent <- get(parent_class)
  } else {
    parent <- gg$super
  }
  ggclone(new_class, gg, parent, ...)
}

ggclone <- function(.class, .gg, .super, ...) {
  skeleton <- as.list(.gg, inherit = FALSE)
  clone <- list2env(skeleton, parent = emptyenv())
  clone$super <- .super

  clone <- ggmutate(clone, ...)
  structure(clone, class = c(.class, class(.super)))
}

flip_ggproto <- function(gg) {
  UseMethod("flip_ggproto")
}

flip_ggproto.default <- identity
