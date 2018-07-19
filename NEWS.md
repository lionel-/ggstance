
# ggstance 0.3.0.9000

* `geom_violinh()` can now be passed `draw_quantiles` argument (#16,
  thanks to @iamamutt).

* New horizontal summary functions `mean_se_h()`, `mean_cl_boot_h()`,
  `mean_cl_normal_h()`, `mean_sdl_h()` and `median_hilow_h()` (#13,
  thanks to @rjbgoudie).

* Compatibility with ggplot2 3.0.0

* Fix horizontal boxplot issue when y scale is continuous.

* Change minimal R version to 3.1.0, to be consistent with ggplot2.


# ggstance 0.3.0

The package was rewritten to make it more robust to ggplot2 updates.
In addition, this version features:

* New stat_summaryh() (#7)


# ggstance 0.2.0

## Major change

ggstance has been reorganised to make it more modular. Before, it
would create horizontal layer by automatically flipping Geoms and
Stats. Now it creates regular ggplot2 layer to which you provide
horizontal Geoms, Stats, and vertical Positions. This allows you to
reuse some of these components in regular layers. Vertical positions
in particular can be useful.

## Bug fixes

* Fix error messages when required aesthetics are not provided (#5)


# ggstance 0.1.0

Initial release
