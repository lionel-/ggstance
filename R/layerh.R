
#' @export
Layerh <- ggproto("Layerh", Layer,
  # compute_aesthetics() is the main entry point of data in
  # ggplot_build(). Flipping here means most of subsequent methods
  # receive flipped data

  # Flip mapping. Override plot mapping if no layer mapping found.
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

#' @export
layerh <- function(...) {
  flip_ggproto(layer(...))
}


flip_ggproto.LayerInstance <- function(gg) {
  ggclone("LayerInstanceh", gg, Layerh,
    stat = flip_ggproto(gg$stat),
    geom = flip_ggproto(gg$geom)
  )
}

flip_ggproto.Stat <- function(gg) {
  ggflipped(gg,
    default_aes = flip_aes(gg$default_aes)
  )
}

flip_ggproto.Geom <- function(gg) {
  ggflipped(gg,
    required_aes = flip_aes(gg$required_aes)
  )
}
