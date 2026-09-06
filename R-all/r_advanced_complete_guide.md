# R: Complete Guide (Expanded) — From Basics to Professional Use

A comprehensive reference covering core language mechanics, data wrangling, functional programming, OOP, error handling, performance, testing, and reporting.

## Table of Contents

- [1. Setup & Workflow](#1-setup--workflow)
- [2. Variables, Assignment, and Environments](#2-variables-assignment-and-environments)
- [3. Data Types & Coercion](#3-data-types--coercion)
- [4. Vectors (Deep Dive)](#4-vectors-deep-dive)
- [5. Factors (Categorical Data)](#5-factors-categorical-data)
- [6. Lists, Matrices, Arrays, Data Frames](#6-lists-matrices-arrays-data-frames)
- [7. Control Flow (Full Set)](#7-control-flow-full-set)
- [8. Functions (Advanced)](#8-functions-advanced)
- [9. The `apply` / `purrr` Functional Family](#9-the-apply--purrr-functional-family)
- [10. Error Handling](#10-error-handling)
- [11. String Manipulation (Base + stringr)](#11-string-manipulation-base--stringr)
- [12. Dates and Times](#12-dates-and-times)
- [13. Data Import/Export (Expanded)](#13-data-importexport-expanded)
- [14. dplyr — Full Data Manipulation Toolkit](#14-dplyr--full-data-manipulation-toolkit)
- [15. tidyr — Reshaping Data](#15-tidyr--reshaping-data)
- [16. Statistics & Modeling](#16-statistics--modeling)
- [17. Object-Oriented Programming in R](#17-object-oriented-programming-in-r)
- [18. Performance & Profiling](#18-performance--profiling)
- [19. Parallel Processing](#19-parallel-processing)
- [20. Unit Testing (testthat)](#20-unit-testing-testthat)
- [21. Building an R Package (Overview)](#21-building-an-r-package-overview)
- [22. R Markdown / Quarto Reports](#22-r-markdown--quarto-reports)
- [23. Shiny (Interactive Web Apps)](#23-shiny-interactive-web-apps)
- [Quick Reference Cheatsheet](#quick-reference-cheatsheet)
- [Path to Professional R](#path-to-professional-r)

---

## 1. Setup & Workflow

```r
# Install R: https://cran.r-project.org
# Install RStudio: https://posit.co/download/rstudio-desktop/
```

**RStudio Projects** (`.Rproj`) keep working directory, history, and settings scoped per-project — always use one instead of loose scripts.

```r
getwd()                 # current working directory
setwd("~/myproject")    # change it (avoid in scripts — use projects/here instead)

install.packages("here")
library(here)
here("data", "file.csv")   # builds a path relative to project root, portable across machines
```

---

## 2. Variables, Assignment, and Environments

```r
x <- 5              # standard assignment
5 -> x               # right assignment (rare, but valid)
x <<- 5              # superassignment — assigns in the parent/global environment (used inside functions)
assign("x", 5)       # programmatic assignment

ls()                 # list objects in current environment
rm(x)                # remove an object
rm(list = ls())      # clear entire environment (use with caution)
```

---

## 3. Data Types & Coercion

```r
class(5L)         # "integer"
class(5.5)        # "numeric"
class("a")        # "character"
class(TRUE)       # "logical"
class(1+2i)       # "complex"
class(factor("a")) # "factor"

# Coercion
as.numeric("5")
as.character(5)
as.integer(5.9)     # 5 (truncates)
as.logical("TRUE")

# Type checking
is.numeric(5); is.character("a"); is.na(NA); is.null(NULL)
```

**Special values:** `NA` (missing), `NULL` (absent/empty), `NaN` (not a number, e.g. `0/0`), `Inf`/`-Inf`.

---

## 4. Vectors (Deep Dive)

```r
v <- c(1, 2, 3, 4, 5)
names(v) <- c("a","b","c","d","e")
v["b"]                     # named indexing

seq(1, 10, by = 2)          # 1 3 5 7 9
seq_len(5)                  # 1 2 3 4 5
rep(c(1,2), times = 3)      # 1 2 1 2 1 2
rep(c(1,2), each = 3)       # 1 1 1 2 2 2

rev(v)                      # reverse
which(v > 2)                 # indices where condition is true
which.max(v); which.min(v)
any(v > 4); all(v > 0)
%in%                         # membership: 3 %in% v
setdiff(v, c(1,2)); union(v, c(6,7)); intersect(v, c(2,3))
```

### Recycling

```r
c(1,2,3,4) + c(1,2)   # recycles shorter vector: 2 4 4 6
```

---

## 5. Factors (Categorical Data)

```r
f <- factor(c("low","high","medium"), levels = c("low","medium","high"), ordered = TRUE)
levels(f)
as.integer(f)          # underlying integer codes
f[1] < f[2]             # TRUE — ordered comparison works
table(f)                # frequency count
```

Factors are essential for statistical modeling (categorical predictors) and plotting order control.

---

## 6. Lists, Matrices, Arrays, Data Frames

```r
lst <- list(a = 1, b = "text", c = c(1,2,3))
lst$c[2]
lst[["a"]]
lst[c("a","b")]          # subset multiple elements, returns a list

m <- matrix(1:6, nrow = 2)
t(m)                     # transpose
m %*% t(m)                # matrix multiplication
dim(m); nrow(m); ncol(m)

arr <- array(1:24, dim = c(2,3,4))  # 3D array
arr[1,2,3]

df <- data.frame(x = 1:3, y = c("a","b","c"), stringsAsFactors = FALSE)
nrow(df); ncol(df); dim(df)
colnames(df); rownames(df)
df[order(df$x, decreasing = TRUE), ]   # sort a data frame
rbind(df, data.frame(x=4, y="d"))       # add row
cbind(df, z = c(TRUE,FALSE,TRUE))       # add column
```

---

## 7. Control Flow (Full Set)

```r
# switch statement
result <- switch("b",
  a = "Apple",
  b = "Banana",
  c = "Cherry",
  "Unknown"     # default
)

# repeat loop with break
i <- 0
repeat {
  i <- i + 1
  if (i >= 5) break
}

# next (skip iteration)
for (i in 1:5) {
  if (i == 3) next
  print(i)
}

# ifelse — vectorized single-line conditional
ifelse(v > 2, "high", "low")
```

---

## 8. Functions (Advanced)

```r
f <- function(x, y = 2, ...) {
  extra <- list(...)
  x^y
}
f(3)                # 9
f(3, 3)              # 27
f(3, z = "ignored")  # extra args caught by ...

# Anonymous / lambda functions
sapply(1:5, \(x) x^2)          # R >= 4.1 shorthand
sapply(1:5, function(x) x^2)   # traditional form

# Closures: functions that capture their environment
make_counter <- function() {
  count <- 0
  function() {
    count <<- count + 1
    count
  }
}
counter <- make_counter()
counter(); counter()   # 1, 2 — state persists between calls

# Recursion
factorial <- function(n) if (n <= 1) 1 else n * factorial(n - 1)
```

---

## 9. The `apply` / `purrr` Functional Family

```r
sapply(1:5, function(x) x^2)         # simplifies to vector/matrix
lapply(1:5, function(x) x^2)         # always returns a list
vapply(1:5, function(x) x^2, numeric(1))  # like sapply but with type safety
mapply(function(x,y) x+y, 1:3, 4:6)  # multiple vectors in parallel
apply(m, 1, sum)                      # rows(1)/columns(2) of a matrix

# purrr (tidyverse equivalent, more consistent)
library(purrr)
map(1:5, ~ .x^2)               # like lapply, returns list
map_dbl(1:5, ~ .x^2)           # returns numeric vector
map2_dbl(1:3, 4:6, ~ .x + .y)  # parallel map over two vectors
```

---

## 10. Error Handling

```r
result <- tryCatch({
  stop("Something went wrong")
}, error = function(e) {
  message("Caught error: ", e$message)
  NA
}, warning = function(w) {
  message("Caught warning: ", w$message)
  NA
}, finally = {
  message("This always runs")
})

# Custom warnings/errors
warning("This is a warning")
stop("This is a fatal error")

# Assertions
stopifnot(x > 0, is.numeric(x))
```

---

## 11. String Manipulation (Base + stringr)

```r
# Base R
sprintf("%s is %d years old", "Bob", 30)
trimws("  hi  ")             # remove whitespace
format(3.14159, nsmall = 2)  # "3.14"

# stringr (tidyverse, more consistent API)
library(stringr)
str_length("hello")
str_detect("hello world", "world")     # TRUE/FALSE
str_extract("abc123", "[0-9]+")         # "123"
str_replace("abc", "a", "X")            # first match
str_replace_all("banana", "a", "X")     # all matches
str_split("a,b,c", ",")
str_pad("5", width = 3, pad = "0")      # "005"
str_trim(" hi ")
str_to_upper("hi"); str_to_lower("HI"); str_to_title("hello world")
```

### Regular Expressions

```r
grepl("^[A-Z]", c("Apple","banana"))     # starts with uppercase
regmatches("abc123def", regexpr("[0-9]+", "abc123def"))  # "123"
```

---

## 12. Dates and Times

```r
Sys.Date(); Sys.time()

d <- as.Date("2026-01-15")
format(d, "%B %d, %Y")     # "January 15, 2026"
d + 30                      # add 30 days

library(lubridate)          # tidyverse date package (much easier)
ymd("2026-01-15")
mdy("01/15/2026")
today(); now()
d2 <- ymd("2026-03-01")
d2 - d                       # difference in days
interval(d, d2) / days(1)    # numeric day count
wday(d, label = TRUE)         # day of week
```

---

## 13. Data Import/Export (Expanded)

```r
# readr (faster, tidyverse-consistent)
library(readr)
df <- read_csv("data.csv")           # faster + better type guessing than read.csv
write_csv(df, "out.csv")

# Excel
library(readxl); library(writexl)
df <- read_excel("data.xlsx", sheet = "Sheet1")
write_xlsx(df, "out.xlsx")

# JSON
library(jsonlite)
data <- fromJSON("data.json")
write_json(df, "out.json")

# Databases (DBI + a driver, e.g. RSQLite/RPostgres)
library(DBI)
con <- dbConnect(RSQLite::SQLite(), "mydb.sqlite")
dbWriteTable(con, "mytable", df)
dbGetQuery(con, "SELECT * FROM mytable WHERE age > 25")
dbDisconnect(con)
```

---

## 14. dplyr — Full Data Manipulation Toolkit

```r
library(dplyr)

df %>%
  filter(age > 25, active == TRUE) %>%
  select(name, age, -id) %>%          # -id excludes a column
  rename(full_name = name) %>%
  mutate(age_group = case_when(
    age < 18 ~ "minor",
    age < 65 ~ "adult",
    TRUE ~ "senior"
  )) %>%
  arrange(desc(age)) %>%
  distinct(full_name, .keep_all = TRUE) %>%
  slice_head(n = 10)

# Aggregation
df %>%
  group_by(age_group) %>%
  summarise(
    count = n(),
    avg_age = mean(age),
    .groups = "drop"
  )

# Joins
inner_join(df1, df2, by = "id")
left_join(df1, df2, by = "id")
right_join(df1, df2, by = "id")
full_join(df1, df2, by = "id")
anti_join(df1, df2, by = "id")    # rows in df1 with NO match in df2
```

---

## 15. tidyr — Reshaping Data

```r
library(tidyr)

# Wide to long
pivot_longer(df, cols = c(jan, feb, mar), names_to = "month", values_to = "value")

# Long to wide
pivot_wider(df, names_from = month, values_from = value)

# Split / combine columns
separate(df, col = full_name, into = c("first","last"), sep = " ")
unite(df, col = full_name, first, last, sep = " ")

# Handle missing values
drop_na(df)
replace_na(df, list(age = 0))
fill(df, age, .direction = "down")   # forward-fill missing values
```

---

## 16. Statistics & Modeling

```r
# Descriptive
mean(v); median(v); sd(v); var(v); IQR(v); quantile(v, c(0.25, 0.75))

# Hypothesis testing
t.test(v1, v2)
chisq.test(table(df$group, df$outcome))
wilcox.test(v1, v2)          # non-parametric alternative to t-test

# ANOVA
aov_model <- aov(score ~ group, data = df)
summary(aov_model)

# Linear regression
model <- lm(y ~ x1 + x2, data = df)
summary(model)
predict(model, newdata = data.frame(x1 = 5, x2 = 10))
confint(model)

# Logistic regression (generalized linear model)
glm_model <- glm(outcome ~ x1 + x2, data = df, family = binomial)
summary(glm_model)

# Correlation matrix
cor(df[, c("x1","x2","y")])
```

---

## 17. Object-Oriented Programming in R

R has three main OOP systems:

### S3 (simple, most common)

```r
new_animal <- function(name, sound) {
  structure(list(name = name, sound = sound), class = "animal")
}
speak <- function(x) UseMethod("speak")
speak.animal <- function(x) paste(x$name, "says", x$sound)

a <- new_animal("Dog", "Woof")
speak(a)
```

### S4 (stricter, formal classes — used in Bioconductor etc.)

```r
setClass("Animal", representation(name = "character", sound = "character"))
setGeneric("speak", function(x) standardGeneric("speak"))
setMethod("speak", "Animal", function(x) paste(x@name, "says", x@sound))

a <- new("Animal", name = "Cat", sound = "Meow")
speak(a)
```

### R6 (mutable, reference-class style, closest to typical OOP languages)

```r
install.packages("R6")
library(R6)

Animal <- R6Class("Animal",
  public = list(
    name = NULL,
    sound = NULL,
    initialize = function(name, sound) {
      self$name <- name
      self$sound <- sound
    },
    speak = function() paste(self$name, "says", self$sound)
  )
)
a <- Animal$new("Bird", "Tweet")
a$speak()
```

---

## 18. Performance & Profiling

```r
system.time({ Sys.sleep(1) })          # basic timing

library(microbenchmark)
microbenchmark(
  loop = for(i in 1:1000) i^2,
  vectorized = (1:1000)^2,
  times = 100
)

library(profvis)
profvis({
  # code to profile
  x <- rnorm(1e6)
  mean(x)
})
```

**Performance tips:**
- Prefer vectorized operations over `for` loops
- Preallocate vectors/lists (`vector("numeric", n)`) instead of growing them in a loop
- Use `data.table` for very large datasets (much faster than `data.frame`/`dplyr` at scale)

```r
library(data.table)
dt <- data.table(x = 1:1e6, y = rnorm(1e6))
dt[x > 500000, .(avg = mean(y)), by = .(group = x %% 10)]
```

---

## 19. Parallel Processing

```r
library(parallel)
detectCores()

cl <- makeCluster(4)
result <- parLapply(cl, 1:10, function(x) x^2)
stopCluster(cl)

# Simpler: mclapply (Mac/Linux only, not Windows)
mclapply(1:10, function(x) x^2, mc.cores = 4)
```

---

## 20. Unit Testing (testthat)

```r
library(testthat)

test_that("addition works", {
  expect_equal(2 + 2, 4)
  expect_true(5 > 3)
  expect_error(stop("fail"))
})
```

Standard project structure for a package: tests live in `tests/testthat/test-*.R`, run via `devtools::test()`.

---

## 21. Building an R Package (Overview)

```r
install.packages("devtools")
library(devtools)

create_package("mypackage")   # scaffold a new package
use_r("myfunction")            # create R/myfunction.R
document()                     # generate documentation from roxygen2 comments
load_all()                     # simulate loading the package
check()                        # run CRAN-style checks
```

Roxygen2 documentation comment style:

```r
#' Add two numbers
#'
#' @param x A number
#' @param y A number
#' @return The sum of x and y
#' @export
add <- function(x, y) x + y
```

---

## 22. R Markdown / Quarto Reports

````
---
title: "Analysis Report"
output: html_document
---

## Summary

```{r, echo=FALSE, message=FALSE}
library(dplyr)
summary(df)
```

## Plot

```{r}
plot(df$x, df$y)
```
````

Render: `rmarkdown::render("report.Rmd")` or the "Knit" button.

**Quarto** (`.qmd`) is the modern successor supporting R, Python, and Julia in the same framework — worth learning if starting fresh.

---

## 23. Shiny (Interactive Web Apps)

```r
library(shiny)

ui <- fluidPage(
  sliderInput("n", "Number of points:", 1, 100, 50),
  plotOutput("plot")
)

server <- function(input, output) {
  output$plot <- renderPlot({
    plot(1:input$n, (1:input$n)^2)
  })
}

shinyApp(ui, server)
```

---

## Quick Reference Cheatsheet

| Task | Code |
|---|---|
| Assign | `x <- 5` |
| Vector | `c(1,2,3)` |
| Named list | `list(a=1, b=2)` |
| Data frame | `data.frame(x=1:3, y=c("a","b","c"))` |
| Filter rows | `df %>% filter(cond)` |
| Add/modify column | `df %>% mutate(new = ...)` |
| Group + aggregate | `df %>% group_by(x) %>% summarise(...)` |
| Reshape wide→long | `pivot_longer(...)` |
| Join tables | `left_join(df1, df2, by="id")` |
| String match | `str_detect(x, "pattern")` |
| Regex extract | `str_extract(x, "[0-9]+")` |
| Date parsing | `ymd("2026-01-15")` |
| Linear model | `lm(y ~ x, data=df)` |
| Custom class (S3) | `structure(list(...), class="myclass")` |
| Error handling | `tryCatch(..., error=function(e) ...)` |
| Unit test | `expect_equal(a, b)` |
| Render report | `rmarkdown::render("file.Rmd")` |
| Run script | `Rscript script.R` |

## Path to Professional R

1. **Data wrangling mastery** — `dplyr`, `tidyr`, `data.table` for scale
2. **Visualization** — `ggplot2` end-to-end (see dedicated tutorials)
3. **Reproducibility** — RStudio Projects, `renv` for package version locking, R Markdown/Quarto
4. **Software engineering habits** — functions over copy-paste, `testthat`, version control (git)
5. **Performance** — vectorization, `data.table`/`dtplyr` for big data, profiling with `profvis`
6. **Packaging** — turn reusable code into an installable package with `devtools` + `roxygen2`
7. **Read**: [R for Data Science](https://r4ds.hadley.nz/) → [Advanced R](https://adv-r.hadley.nz/) → [R Packages](https://r-pkgs.org/)
