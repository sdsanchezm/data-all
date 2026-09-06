# ggplot2

ggplot2 is R's most popular plotting library, based on the "Grammar of Graphics" — you build plots by layering components (data, aesthetics, geometries, stats, scales, themes) rather than issuing one big plot command.

## 1. Install and Load

```r
install.packages("ggplot2")
library(ggplot2)
```

It's also part of the `tidyverse`:

```r
install.packages("tidyverse")
library(tidyverse)
```

## 2. The Core Syntax

Every ggplot2 plot follows this pattern:

```r
ggplot(data = <DATA>, mapping = aes(<MAPPINGS>)) +
  <GEOM_FUNCTION>()
```

- `data` — your data frame
- `aes()` — aesthetic mappings: which columns map to x, y, color, size, etc.
- `geom_*()` — the type of plot (points, lines, bars, etc.)
- Layers are combined with `+`

Example using the built-in `mpg` dataset:

```r
ggplot(data = mpg, aes(x = displ, y = hwy)) +
  geom_point()
```

This plots engine displacement (`displ`) vs highway mileage (`hwy`) as a scatterplot.

## 3. Common Geoms

| Geom | Plot type |
|---|---|
| `geom_point()` | Scatterplot |
| `geom_line()` | Line chart |
| `geom_bar()` | Bar chart (counts) |
| `geom_col()` | Bar chart (given values) |
| `geom_histogram()` | Histogram |
| `geom_boxplot()` | Box plot |
| `geom_smooth()` | Trend line / regression |
| `geom_density()` | Density curve |
| `geom_area()` | Area chart |
| `geom_tile()` | Heatmap tiles |

Example: bar chart of counts

```r
ggplot(mpg, aes(x = class)) +
  geom_bar()
```

Example: line chart

```r
ggplot(economics, aes(x = date, y = unemploy)) +
  geom_line()
```

Example: histogram

```r
ggplot(mpg, aes(x = hwy)) +
  geom_histogram(binwidth = 2)
```

Example: box plot

```r
ggplot(mpg, aes(x = class, y = hwy)) +
  geom_boxplot()
```

## 4. Mapping Additional Aesthetics

Map extra variables to color, size, or shape to add dimensions:

```r
ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point()

ggplot(mpg, aes(x = displ, y = hwy, size = cyl)) +
  geom_point()

ggplot(mpg, aes(x = displ, y = hwy, color = class, shape = drv)) +
  geom_point()
```

**Aesthetic vs. fixed value:** put mappings *inside* `aes()`, fixed values *outside*:

```r
# Color varies by data (inside aes)
ggplot(mpg, aes(x = displ, y = hwy, color = class)) + geom_point()

# All points are blue (outside aes, fixed value)
ggplot(mpg, aes(x = displ, y = hwy)) + geom_point(color = "blue")
```

## 5. Combining Multiple Geoms (Layers)

```r
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth(method = "lm")
```

This overlays a scatterplot with a fitted regression line.

## 6. Faceting (Small Multiples)

Split one plot into a grid based on a categorical variable:

```r
# One variable
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  facet_wrap(~ class)

# Two variables (grid)
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  facet_grid(drv ~ cyl)
```

## 7. Titles, Labels, and Legends

```r
ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point() +
  labs(
    title = "Engine Size vs Fuel Efficiency",
    subtitle = "By vehicle class",
    x = "Engine displacement (L)",
    y = "Highway MPG",
    color = "Class"
  )
```

## 8. Scales (Axes, Colors)

```r
# Numeric axis limits
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  scale_x_continuous(limits = c(1, 7)) +
  scale_y_continuous(breaks = seq(10, 45, 5))

# Log scale
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  scale_y_log10()

# Custom color palette
ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point() +
  scale_color_brewer(palette = "Set2")

# Manual colors
ggplot(mpg, aes(x = class, fill = class)) +
  geom_bar() +
  scale_fill_manual(values = c("red", "blue", "green", "orange", "purple", "pink", "brown"))
```

## 9. Themes (Overall Appearance)

```r
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  theme_minimal()
```

Built-in themes: `theme_minimal()`, `theme_bw()`, `theme_classic()`, `theme_light()`, `theme_dark()`, `theme_void()`.

Customize specific elements:

```r
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 16, face = "bold"),
    axis.text = element_text(size = 10),
    legend.position = "bottom"
  )
```

## 10. Coordinate Flips and Adjustments

```r
# Horizontal bar chart
ggplot(mpg, aes(x = class)) +
  geom_bar() +
  coord_flip()

# Fixed aspect ratio
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  coord_fixed(ratio = 1)
```

## 11. Saving a Plot

```r
p <- ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point()

ggsave("myplot.png", plot = p, width = 8, height = 6, dpi = 300)
```

Supported formats: `.png`, `.pdf`, `.svg`, `.jpg`, and more, inferred from the file extension.

## 12. Full Example (Putting It Together)

```r
library(ggplot2)

ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point(size = 2, alpha = 0.7) +
  geom_smooth(method = "loess", se = FALSE, color = "black") +
  labs(
    title = "Fuel Efficiency vs Engine Size",
    x = "Engine Displacement (L)",
    y = "Highway MPG",
    color = "Vehicle Class"
  ) +
  scale_color_brewer(palette = "Dark2") +
  theme_minimal() +
  theme(legend.position = "right")

ggsave("fuel_efficiency.png", width = 8, height = 5, dpi = 300)
```

---

## Quick Reference

| Task | Code |
|---|---|
| Scatterplot | `geom_point()` |
| Line chart | `geom_line()` |
| Bar chart | `geom_bar()` / `geom_col()` |
| Histogram | `geom_histogram()` |
| Box plot | `geom_boxplot()` |
| Trend line | `geom_smooth()` |
| Facet by variable | `facet_wrap(~var)` |
| Titles/labels | `labs(title=, x=, y=)` |
| Change theme | `theme_minimal()`, etc. |
| Save plot | `ggsave("file.png")` |

**Next steps:** explore `geom_violin()`, `coord_polar()` (pie charts), `patchwork` (combining multiple plots), and `gganimate` (animated plots).

# ggplot2: Next Steps (Violin Plots, Pie Charts, Combining Plots, Animation)

This continues from the basic usage guide, covering `geom_violin()`, `coord_polar()`, combining multiple plots with `patchwork`, and animating plots with `gganimate`.

## 1. Violin Plots (`geom_violin`)

A violin plot shows the full distribution shape (like a mirrored density plot) instead of just quartiles like a boxplot.

```r
library(ggplot2)

ggplot(mpg, aes(x = class, y = hwy)) +
  geom_violin()
```

Combine with a boxplot or points for more detail:

```r
ggplot(mpg, aes(x = class, y = hwy, fill = class)) +
  geom_violin(alpha = 0.6) +
  geom_boxplot(width = 0.1, fill = "white") +
  theme_minimal() +
  theme(legend.position = "none") +
  labs(title = "Highway MPG Distribution by Class", x = "Class", y = "Highway MPG")
```

Add jittered raw data points on top:

```r
ggplot(mpg, aes(x = class, y = hwy, fill = class)) +
  geom_violin(alpha = 0.5) +
  geom_jitter(width = 0.1, alpha = 0.4) +
  theme_minimal() +
  theme(legend.position = "none")
```

## 2. Pie Charts with `coord_polar()`

ggplot2 has no dedicated `geom_pie()` — pie charts are made by taking a stacked bar chart and wrapping it around a polar coordinate system.

```r
# Prepare summarized data
class_counts <- as.data.frame(table(mpg$class))
names(class_counts) <- c("class", "count")

ggplot(class_counts, aes(x = "", y = count, fill = class)) +
  geom_col(width = 1) +
  coord_polar(theta = "y") +
  theme_void() +
  labs(title = "Vehicle Class Distribution", fill = "Class")
```

- `geom_col(width = 1)` creates a single stacked bar
- `coord_polar(theta = "y")` wraps the y-axis around into a circle
- `theme_void()` removes axis clutter, since it's not meaningful in a pie chart

**Donut chart variant** (hollow center):

```r
ggplot(class_counts, aes(x = 2, y = count, fill = class)) +
  geom_col(width = 1) +
  coord_polar(theta = "y") +
  xlim(0.5, 2.5) +
  theme_void()
```

Note: pie charts are generally discouraged in data visualization best practice (bar charts are easier to compare accurately) — use sparingly.

## 3. Combining Multiple Plots with `patchwork`

`patchwork` lets you arrange separate ggplot objects into one figure using simple `+`, `/`, and `()` operators.

```r
install.packages("patchwork")
library(patchwork)

p1 <- ggplot(mpg, aes(x = displ, y = hwy)) + geom_point()
p2 <- ggplot(mpg, aes(x = class)) + geom_bar()
p3 <- ggplot(mpg, aes(x = hwy)) + geom_histogram(binwidth = 2)

# Side by side
p1 + p2

# Stacked vertically
p1 / p2

# Grid layout: p1 on top, p2 and p3 side by side below
p1 / (p2 + p3)
```

Add shared titles/labels across the whole combined figure:

```r
(p1 + p2) / p3 +
  plot_annotation(title = "Vehicle Data Overview", tag_levels = "A")
```

`tag_levels = "A"` auto-labels each subplot "A", "B", "C" — handy for reports and papers.

Control relative sizes:

```r
p1 + p2 + plot_layout(widths = c(2, 1))
```

## 4. Animated Plots with `gganimate`

`gganimate` extends ggplot2 to render animations across a variable (commonly time).

```r
install.packages("gganimate")
install.packages("gifski")   # renderer for GIF output
library(gganimate)

ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point(size = 3) +
  labs(title = "Year: {closest_state}") +
  transition_states(year, transition_length = 2, state_length = 1) +
  ease_aes("linear")
```

Key functions:
- `transition_states(var, ...)` — step through discrete states (e.g., categories, years)
- `transition_time(var)` — smoothly interpolate over a continuous time variable
- `transition_reveal(var)` — progressively reveal a line/path over time
- `{closest_state}` / `{frame_time}` — placeholders you can use in `labs()` to show the current frame's value

Example: a line progressively drawing over time

```r
ggplot(economics, aes(x = date, y = unemploy)) +
  geom_line() +
  transition_reveal(date) +
  labs(title = "Unemployment Over Time")
```

Render and save as a GIF:

```r
anim <- ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point(size = 3) +
  transition_states(year, transition_length = 2, state_length = 1)

animate(anim, width = 600, height = 400, fps = 20, duration = 6, renderer = gifski_renderer())
anim_save("animated_plot.gif", animation = last_animation())
```

## 5. Putting It Together: A Combined Advanced Example

```r
library(ggplot2)
library(patchwork)

p_violin <- ggplot(mpg, aes(x = class, y = hwy, fill = class)) +
  geom_violin(alpha = 0.6) +
  theme_minimal() +
  theme(legend.position = "none") +
  labs(title = "Distribution by Class", x = NULL, y = "Highway MPG")

p_scatter <- ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point(size = 2, alpha = 0.7) +
  theme_minimal() +
  labs(title = "Displacement vs MPG", x = "Displacement (L)", y = "Highway MPG")

p_violin + p_scatter +
  plot_annotation(title = "Fuel Efficiency Analysis", tag_levels = "A")
```

---

## Quick Reference

| Task | Code |
|---|---|
| Violin plot | `geom_violin()` |
| Pie/donut chart | `geom_col()` + `coord_polar(theta="y")` |
| Combine plots side by side | `p1 + p2` (patchwork) |
| Stack plots vertically | `p1 / p2` (patchwork) |
| Animate over categories | `transition_states()` (gganimate) |
| Animate over continuous time | `transition_time()` (gganimate) |
| Save animation | `anim_save("file.gif")` |

**Further exploration:** `ggrepel` (non-overlapping text labels), `ggridges` (ridgeline plots), `plotly::ggplotly()` (turn any ggplot into an interactive web chart), and `ggthemes` (extra theme packs like Economist/FiveThirtyEight styles).
