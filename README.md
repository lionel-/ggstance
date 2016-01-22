
# gghorizon

gghorizon implements horizontal versions of common ggplot2 geoms.


## Installation

Get the development version from Github with:

```R
# install.packages("devtools")
devtools::install_github("lionel-/gghorizon")
```


## Horizontal geoms

While `coord_flip()` can only flip a plot as a whole, gghorizon lets
you flip individual layers. It also provides flipped versions of
legend keys to keep the appearance of your plots consistent.

gghorizon tries hard to flip every component of the layer behind the
scene. You should be able to use any ggplot2 Stats and Positions with
gghorizon's layers.

The supported Geoms are:

- `geom_barh()`
- `geom_histogramh()`
- `geom_linerangeh()`
- `geom_pointrangeh()`
- `geom_crossbarh()`
- `geom_boxploth()`
- `geom_violinh()`
