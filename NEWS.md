# ggstance 0.3.5


# ggstance 0.3.4

* Compatibility with ggplot2 3.3.0.

  Since ggplot2 3.3.0 has now full support for horizontality, the
  ggstance package is superseded. It will continue to be maintained
  for some time, but please consider switching to ggplot2 horizontal
  features.


# ggstance 0.3.3

* Order of bars within groups is aligned with legend order (#21,
  contributed by @sowla and @friep).

* Compatibility with ggplot2 3.2.1.


# ggstance 0.3.2

* Compatibility with ggplot2 3.2.0.

* Aesthetics are now documented in the manual pages (#28).

* `geom_errorbarh()` now supports `height` for compatibility with
  ggplot2's version. It no longer matters whether ggplot2 or ggstance
  is loaded first (#27, #29).


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
