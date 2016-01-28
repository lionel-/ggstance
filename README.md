
# ggstance

ggstance implements horizontal versions of common ggplot2 geoms.


## Installation

Get the development version from Github with:

```R
# install.packages("devtools")
devtools::install_github("lionel-/ggstance")
```


## Horizontal geoms

While `coord_flip()` can only flip a plot as a whole, ggstance lets
you flip individual layers. It also provides flipped versions of
legend keys to keep the appearance of your plots consistent.

ggstance tries hard to flip every component of the layer behind the
scene. You should be able to use any ggplot2 Stats and Positions with
ggstance's layers.

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

### Basics ###

To create a horizontal layer in ggplot2 with `coord_flip()`, you have
to supply aesthetics as if they were to be drawn vertically:

```r
library("ggplot2")

# Vertical
ggplot(mpg, aes(class, hwy, fill = factor(cyl))) +
  geom_boxplot()

# Horizontal with coord_flip()
ggplot(mpg, aes(class, hwy, fill = factor(cyl))) +
  geom_boxplot() +
  coord_flip()
```

In ggstance, you supply aesthetics in their natural order:

```r
library("ggstance")

# Horizontal with ggstance
ggplot(mpg, aes(hwy, class, fill = factor(cyl))) +
  geom_boxploth()
```


### Facetting with Free Scales

Some plots are hard to produce with `coord_flip()`. One case is
facetting with free scales. Here is an example from @smouksassi:

```r
library("ggplot2")
library("ggstance")

df <- data.frame(
  Group = factor(rep(1:3, each = 4), labels = c("Drug A", "Drug B", "Control")),
  Subject = factor(rep(1:6, each = 2), labels = c("A", "B", "C", "D", "E", "F")),
  Result = rnorm(12)
)

vertical <- ggplot(df, aes(Subject, Result))+
  geom_boxplot(aes(fill = Group))+
  facet_grid(. ~ Group, scales = "free_x")
vertical
```

How do we flip this plot? With `coord_flip()`, the free scales are not
flipped correctly:

```r
vertical + coord_flip()
vertical + facet_grid(Group ~ ., scales = "free_x") + coord_flip()
```

On the other hand a ggstance horizontal layer will work properly:

```r
horizontal <- ggplot(df, aes(Result, Subject))+
  geom_boxploth(aes(fill = Group))+
  facet_grid(Group ~ ., scales = "free_y")
horizontal
```
