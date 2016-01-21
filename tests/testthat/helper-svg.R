
save_svg <- function(p, name) {
  skip_on_cran()
  svglite::svglite(paste0("../figs/", name))
  print(p)
  dev.off()
}

# Update svglite version in DESCRIPTION
desc_path <- "../../DESCRIPTION"
desc <- devtools:::read_dcf(desc_path)
desc$svgliteNote <- as.character(utils::packageVersion("svglite"))
desc$ggplot2Note <- as.character(utils::packageVersion("ggplot2"))
devtools:::write_dcf(desc_path, desc)
