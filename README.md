
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
- `geom_errorbarh()`
- `geom_crossbarh()`
- `geom_boxploth()`
- `geom_violinh()`


## Examples

Violins and Boxplots:

```r
# Vertical
ggplot(mpg, aes(class, hwy, fill = factor(cyl))) + geom_boxplot()

# Horizontal
ggplot(mpg, aes(hwy, class, fill = factor(cyl))) + geom_boxploth()
```

```r
# Vertical
ggplot(mtcars, aes(factor(cyl), mpg, fill = factor(am))) + geom_violin()

# Horizontal
ggplot(mtcars, aes(mpg, factor(cyl), fill = factor(am))) + geom_violinh()
```


Horizontal pointranges also work with `position_dodge()`:

```r
range_df <- data.frame(
  trt = factor(c(1, 1, 2, 2)),
  resp = c(1, 5, 3, 4),
  group = factor(c(1, 2, 1, 2)),
  upper = c(1.1, 5.3, 3.3, 4.2),
  lower = c(0.8, 4.6, 2.4, 3.6)
)
p_v <- ggplot(range_df, aes(trt, resp, fill = group))
p_h <- ggplot(range_df, aes(resp, trt, fill = group))

# Vertical
p_v + geom_pointrange(aes(ymin = lower, ymax = upper, color = group),
  position = position_dodge(0.2))

# Horizontal
p_h + geom_pointrangeh(aes(xmin = lower, xmax = upper, color = group),
  position = position_dodge(0.2))
```

