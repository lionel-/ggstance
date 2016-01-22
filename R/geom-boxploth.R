
#' @export
geom_boxploth <- function(mapping = NULL, data = NULL,
                          stat = "boxplot", position = "dodge",
                          outlier.colour = NULL, outlier.shape = 19,
                          outlier.size = 1.5, outlier.stroke = 0.5,
                          notch = FALSE, notchwidth = 0.5,
                          varwidth = FALSE, na.rm = FALSE,
                          show.legend = NA, inherit.aes = TRUE, ...) {
  layerh(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomBoxplot,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      outlier.colour = outlier.colour,
      outlier.shape = outlier.shape,
      outlier.size = outlier.size,
      outlier.stroke = outlier.stroke,
      notch = notch,
      notchwidth = notchwidth,
      varwidth = varwidth,
      na.rm = na.rm,
      ...
    )
  )
}

#' @export
flip_ggproto.GeomBoxplot <- function(gg) {
  gg <- NextMethod()

  ggmutate(gg,
    draw_group = flip_method_inner(GeomBoxplot$draw_group)
  )
}
