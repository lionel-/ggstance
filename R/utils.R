
insert <- function(x, where, vals) {
  out <- vector(typeof(x), length(x) + length(vals))
  out[-where] <- x
  out[where] <- vals
  out
}

ggname <- function(prefix, grob) {
  grob$name <- grid::grobName(grob, prefix)
  grob
}

ggmutate <- function(gg, ...) {
  dots <- list(...)
  if (length(dots)) {
    fields <- names(dots)
    if (!length(fields) || purrr::some(fields, `==`, "")) {
      stop("Internal error: Unnamed ggproto fields")
    }
    purrr::walk2(names(dots), dots, assign, envir = gg)
  }
  gg
}

names2 <- function(x) {
  names(x) %||% rep("", length(x))
}

lhs <- function(tilde) deparse(tilde[[2]])
rhs <- function(tilde) deparse(tilde[[3]])
