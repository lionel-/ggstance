
# ggstance 0.3.1

This version updates all ggstance layers to feature parity with
ggplot2 3.0.0.

* New horizontal `geom_colh()` layer.

* `stat_counth()` is now exported (#22).

* `position_stackv()` gains `hjust` and `reverse` arguments (#17).

* New horizontal summary functions `mean_se_h()`, `mean_cl_boot_h()`,
  `mean_cl_normal_h()`, `mean_sdl_h()` and `median_hilow_h()` (#13,
  thanks to @rjbgoudie).

* Change minimal R version to 3.1.0, to be consistent with ggplot2.


In addition a few bugs have been fixed:

* `geom_barh()` now uses the `counth` statistic by default instead of
  `count`. This fixes many issues with this layer (#19, thanks to
  @erocoar).

* `geom_violinh()` can now be passed `draw_quantiles` argument (#16,
  thanks to @iamamutt).

* Fix horizontal boxplot issue when y scale is continuous.


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
