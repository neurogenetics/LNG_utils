library(ggplot2)
library(grid)
library(gtable)

# Define colors for each facet
facet_colors <- c("setosa" = "lightpink", "versicolor" = "lightblue", "virginica" = "lightgreen")

# Create the base plot
p <- ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, color = Petal.Width)) +
   geom_point() +
   facet_wrap(~Species, ncol = 3) +
   theme_bw() +
   labs(title = "Iris Sepal Measurements by Species") +
   scale_color_viridis_c(name = "Petal Width") +
   # Add a dummy aesthetic for facet colors
   aes(fill = Species) +
   scale_fill_manual(name = "Species", values = facet_colors, guide = guide_legend(override.aes = list(shape = 21, size = 3)))+
   theme(strip.text = element_text(color = "transparent"))

# Build the plot
g <- ggplot_gtable(ggplot_build(p))

# Find the strip grobs
strip_indices <- which(grepl('strip-t', g$layout$name))

# Modify the fill of each strip
for (i in seq_along(strip_indices)) {
   j <- which(grepl('rect', g$grobs[[strip_indices[i]]]$grobs[[1]]$childrenOrder))
   g$grobs[[strip_indices[i]]]$grobs[[1]]$children[[j]]$gp$fill <- facet_colors[i]
}

# Draw the modified plot
grid.newpage()
grid.draw(g)
