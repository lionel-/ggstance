
# ScalesList is not exported so we derive from it at print-time.
scales_listh <- function(ScalesList) {
  ggproto("ScalesListh", ScalesList,
    add = function(self, scale) {
      scale$aesthetics <- flip_aes(scale$aesthetics)
      self$super$add(scale)
    }
  )
}
