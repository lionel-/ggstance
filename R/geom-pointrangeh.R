
#' @rdname geom_linerangeh
#' @export
geom_pointrangeh <- function(mapping = NULL, data = NULL,
                             stat = "identity", position = "identity",
                             ...,
                             fatten = 4,
                             na.rm = FALSE,
                             show.legend = NA,
                             inherit.aes = TRUE) {
  layerh(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomPointrange,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      fatten = fatten,
      na.rm = na.rm,
      ...
    )
  )
}

#' @export
flip_ggproto.GeomPointrange <- function(gg) {
  gg <- NextMethod()

  ggmutate(gg,
    draw_key = draw_key_pointrangeh,

    draw_panel = flip_method_inner(gg$draw_panel)
  )
}
