
get_layer <- function() {
  ggplot2::geom_point()$super
}

Layer <- get_layer()

Layerh <- ggproto("Layerh", get_layer(),
  # Roundtrip data so that positions and scales can be trained
  # properly.
  compute_aesthetics = flip_method_outer(Layer$compute_aesthetics,
    what = c("mapping", "plot_scales"),
    roundtrip = c("data", "mapping", "plot_scales")
  ),

  # Scales and positions are trained, flip the data back to
  # horizontal. Panel object containing scales has now been
  # created, flip it horizontally.
  compute_statistic = flip_method_outer(Layer$compute_statistic,
    what = c("data", "scales")),

  map_statistic = flip_method_outer(Layer$map_statistic,
    what = "mapping", roundtrip = "mapping"),

  # Final method, flip everything back
  compute_position = flip_method_outer(Layer$compute_position,
    what = "", roundtrip = "data"
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

#' @export
flip_ggproto.Geom <- function(gg) {
  ggflipped(gg,
    # handle_na() is called at print time after the data is flipped
    # back to normal, and thus needs temporarily flipped data
    handle_na = flip_method_outer(gg$handle_na, roundtrip = "data")
  )
}
