
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

names2 <- function(x) {
  names(x) %||% rep("", length(x))
}

lhs <- function(tilde) deparse(tilde[[2]])
rhs <- function(tilde) deparse(tilde[[3]])
