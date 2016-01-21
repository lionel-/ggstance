
flip_ggproto.Stat <- function(gg) {
  ggflipped(gg,
    default_aes = flip_aes(gg$default_aes)
  )
}

#' @export
StatBinh <- flip_ggproto(StatBin)
