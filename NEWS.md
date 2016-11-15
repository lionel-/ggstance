
# ggstance 0.3

The package was rewritten to make it more robust to ggplot2 updates.
In addition, this version features:

* New stat_summaryh() (#7)


# ggstance 0.2

## Major change

ggstance has been reorganised to make it more modular. Before, it
would create horizontal layer by automatically flipping Geoms and
Stats. Now it creates regular ggplot2 layer to which you provide
horizontal Geoms, Stats, and vertical Positions. This allows you to
reuse some of these components in regular layers. Vertical positions
in particular can be useful.

## Bug fixes

* Fix error messages when required aesthetics are not provided (#5)


# ggstance 0.1

Initial release
