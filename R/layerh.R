
get_layer <- function() {
  ggplot2::geom_point()$super
}

Layer <- get_layer()

Layerh <- ggproto("Layerh", Layer,
  # Scales and positions are trained, flip the data as if the layer
  # was vertical. Panel object containing scales has now been created,
  # flip it vertically as well.
  compute_statistic = flip_method_outer(Layer$compute_statistic,
    what = c("data", "scales")),

  # Temporary flip data back to vertical since map_statistic() relies
  # on vertical mapping specifications.
  map_statistic = flip_method_outer(Layer$map_statistic,
    what = "data", roundtrip = "data"),

  # Flip everything back to horizontal stance before retraining /
  # remapping of positions
  compute_position = flip_method_outer(Layer$compute_position,
    what = "", roundtrip = c("data", "scales")
  )
)

print.Layerh <- function(x, ...) {
  cat("[Horizontal layer]\n")
  NextMethod()
}

#' Create a flipped layer
#'
#' The layer, geom and stat will be flipped to horizontal orientation.
#' @param ... Arguments passed to \code{\link[ggplot2]{layer}()}.
#' @export
layerh <- function(...) {
  flip_ggproto(layer(...))
}


#' @export
flip_ggproto.LayerInstance <- function(gg) {
  ggclone("LayerInstanceh", gg, Layerh,
    stat = flip_ggproto(gg$stat),
    geom = flip_ggproto(gg$geom)
  )
}

# `default_aes` needs to be flipped because it's used in
# compute_aesthetics(). At that point, we haven't flipped the data
# yet. On the other hand, `required_aes` is used in the Stat
# compute_layer() method, where the data has been flipped.

#' @export
flip_ggproto.Geom <- function(gg) {
  ggflipped(gg,
    # handle_na() is called at print time after the data is flipped
    # back to normal, and thus needs temporarily flipped data
    handle_na = flip_method_outer(gg$handle_na, roundtrip = "data"),
    default_aes = flip_aes(gg$default_aes)
  )
}

#' @export
flip_ggproto.Stat <- function(gg) {
  ggflipped(gg,
    default_aes = flip_aes(gg$default_aes)
  )
}
