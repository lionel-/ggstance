# flipped geoms have correct `required_aes` failure messages

    Code
      (expect_error(ggplot_build(p)))
    Output
      <error/rlang_error>
      Error in `geom_linerangeh()`:
      ! Problem while setting up geom.
      i Error occurred in the 1st layer.
      Caused by error in `compute_geom_1()`:
      ! `geom_linerangeh()` requires the following missing aesthetics: y, xmin, and xmax

# flipped stats have correct `required_aes` failure messages

    Code
      (expect_error(ggplot_build(p), "y$"))
    Output
      <error/rlang_error>
      Error in `stat_binh()`:
      ! Problem while computing stat.
      i Error occurred in the 1st layer.
      Caused by error in `compute_layer()`:
      ! `stat_binh()` requires the following missing aesthetics: y

