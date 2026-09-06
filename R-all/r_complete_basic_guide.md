# R: Complete Basic Usage Guide

A concise but complete reference to get from zero to comfortable, professional-level R usage.

## Table of Contents

- [1. Setup](#1-setup)
- [2. Variables and Assignment](#2-variables-and-assignment)
- [3. Data Types](#3-data-types)
- [4. Vectors (the core building block)](#4-vectors-the-core-building-block)
- [5. Other Core Data Structures](#5-other-core-data-structures)
- [6. Control Flow](#6-control-flow)
- [7. Functions](#7-functions)
- [8. The `apply` Family (functional iteration)](#8-the-apply-family-functional-iteration)
- [9. String Manipulation](#9-string-manipulation)
- [10. Reading and Writing Data](#10-reading-and-writing-data)
- [11. Packages](#11-packages)
- [12. Data Manipulation with dplyr (industry standard)](#12-data-manipulation-with-dplyr-industry-standard)
- [13. Basic Statistics](#13-basic-statistics)
- [14. Plotting](#14-plotting)
- [15. Handling Missing Data](#15-handling-missing-data)
- [16. Writing Reusable Scripts (Professional Habits)](#16-writing-reusable-scripts-professional-habits)
- [17. Debugging & Help](#17-debugging--help)
- [18. R Markdown (Reports)](#18-r-markdown-reports)
- [Quick Reference Cheatsheet](#quick-reference-cheatsheet)
- [Path to "Professional" R](#path-to-professional-r)

## 1. Setup

```r
# Install R from https://cran.r-project.org
# Install RStudio (IDE) from https://posit.co/download/rstudio-desktop/
```

Run code in the **Console**, or write reusable code in a **script** (`.R` file) and run lines with `Ctrl/Cmd+Enter`.

## 2. Variables and Assignment

```r
x <- 5          # preferred assignment operator
y = 10          # also works, less idiomatic
x + y

name <- "Alice"
is_active <- TRUE
```

- `<-` is conventional in R (not `=`)
- R is dynamically typed — no need to declare types

## 3. Data Types

```r
class(5L)        # "integer"
class(5.5)       # "numeric" (double)
class("text")    # "character"
class(TRUE)      # "logical"
class(1+2i)      # "complex"
class(NULL)      # "NULL"
class(NA)        # "logical" (missing value)
```

## 4. Vectors (the core building block)

```r
v <- c(1, 2, 3, 4, 5)
v[1]              # 1 (indexing starts at 1, not 0)
v[2:4]            # subset a range
v[c(1,3)]         # subset by indices
v[v > 2]          # logical subsetting

length(v)
sum(v); mean(v); max(v); min(v); sort(v)

# Vectorized operations (no loop needed)
v * 2
v + c(10, 20, 30, 40, 50)
```

**Key idea: R is vectorized.** Operations apply element-wise automatically — avoid manual loops where possible.

## 5. Other Core Data Structures

```r
# List: mixed types, named elements
lst <- list(name = "Bob", age = 30, scores = c(90, 85))
lst$name
lst[["age"]]

# Matrix: 2D, single type
m <- matrix(1:6, nrow = 2, ncol = 3)
m[1, 2]

# Data frame: table, columns can be different types (most-used structure)
df <- data.frame(
  name = c("Alice", "Bob", "Carol"),
  age = c(25, 30, 35),
  active = c(TRUE, FALSE, TRUE)
)
df$age
df[1, ]        # first row
df[, "age"]    # age column
str(df)        # structure overview
summary(df)    # quick stats
```

## 6. Control Flow

```r
# if / else
if (x > 3) {
  print("big")
} else if (x == 3) {
  print("equal")
} else {
  print("small")
}

# for loop
for (i in 1:5) {
  print(i)
}

# while loop
i <- 0
while (i < 5) {
  i <- i + 1
}

# vectorized alternative to loops (preferred style)
sapply(1:5, function(i) i^2)
```

## 7. Functions

```r
square <- function(x) {
  return(x^2)
}
square(4)

# Default arguments
greet <- function(name, greeting = "Hello") {
  paste(greeting, name)
}
greet("Alice")
greet("Bob", "Hi")

# Multiple return values via a list
stats <- function(v) {
  list(mean = mean(v), sd = sd(v))
}
result <- stats(c(1,2,3,4,5))
result$mean
```

## 8. The `apply` Family (functional iteration)

```r
sapply(1:5, function(x) x^2)       # returns a vector
lapply(1:5, function(x) x^2)       # returns a list
apply(m, 1, sum)                   # apply over rows (1) or columns (2) of a matrix
mapply(function(x,y) x+y, 1:3, 4:6) # apply over multiple vectors in parallel
```

## 9. String Manipulation

```r
paste("Hello", "World")           # "Hello World"
paste0("Hello", "World")          # "HelloWorld" (no separator)
nchar("hello")                    # 5
toupper("hello"); tolower("HELLO")
substr("hello world", 1, 5)       # "hello"
strsplit("a,b,c", ",")            # split into list
gsub("a", "X", "banana")          # replace all: "bXnXnX"
sprintf("Value: %.2f", 3.14159)   # formatted string
grepl("lo", "hello")              # TRUE/FALSE pattern match
```

## 10. Reading and Writing Data

```r
# CSV
df <- read.csv("data.csv")
write.csv(df, "output.csv", row.names = FALSE)

# Excel (needs readxl / writexl packages)
library(readxl)
df <- read_excel("data.xlsx")

# RDS (R's native binary format, preserves types exactly)
saveRDS(df, "data.rds")
df <- readRDS("data.rds")
```

## 11. Packages

```r
install.packages("dplyr")   # install once
library(dplyr)               # load each session

# Essential packages to know:
# dplyr    - data manipulation
# ggplot2  - visualization
# tidyr    - reshaping data
# readr    - fast file reading
# stringr  - string manipulation
# purrr    - functional programming
# (all bundled together as "tidyverse")
install.packages("tidyverse")
```

## 12. Data Manipulation with dplyr (industry standard)

```r
library(dplyr)

df %>%
  filter(age > 25) %>%
  select(name, age) %>%
  arrange(desc(age)) %>%
  mutate(age_next_year = age + 1)
```

- `%>%` (or native pipe `|>`) chains operations left to right
- `filter()` — subset rows
- `select()` — subset columns
- `arrange()` — sort
- `mutate()` — add/modify columns
- `summarise()` + `group_by()` — aggregate

```r
df %>%
  group_by(active) %>%
  summarise(avg_age = mean(age), count = n())
```

## 13. Basic Statistics

```r
mean(v); median(v); sd(v); var(v)
cor(df$age, df$score)               # correlation
t.test(v1, v2)                      # t-test
lm(y ~ x, data = df)                # linear regression
summary(lm(y ~ x, data = df))       # regression details
```

## 14. Plotting

```r
# Base R (quick and dirty)
plot(df$age, df$score)
hist(df$age)
boxplot(df$score ~ df$active)

# ggplot2 (professional-grade, see separate ggplot2 tutorial)
library(ggplot2)
ggplot(df, aes(x = age, y = score)) + geom_point()
```

## 15. Handling Missing Data

```r
is.na(v)                    # check for NA
sum(is.na(v))                # count NAs
na.omit(df)                  # drop rows with any NA
mean(v, na.rm = TRUE)        # ignore NA in calculation
df$age[is.na(df$age)] <- 0   # replace NAs with 0
```

## 16. Writing Reusable Scripts (Professional Habits)

```r
# script.R
library(dplyr)

# 1. Load data
df <- read.csv("data.csv")

# 2. Clean
df <- df %>% filter(!is.na(age))

# 3. Transform
df <- df %>% mutate(age_group = ifelse(age >= 18, "adult", "minor"))

# 4. Analyze / summarize
summary_stats <- df %>% group_by(age_group) %>% summarise(count = n())

# 5. Output
write.csv(summary_stats, "summary.csv", row.names = FALSE)
```

Run non-interactively from the terminal:

```bash
Rscript script.R
```

## 17. Debugging & Help

```r
?mean               # open help page for a function
help(mean)           # same
example(mean)        # run example code from the docs

traceback()           # see the call stack after an error
debug(myfunction)     # step through a function line by line
print(x); str(x)      # inspect objects while debugging
```

## 18. R Markdown (Reports)

R Markdown combines code, output, and narrative text into one document (HTML, PDF, Word).

````
---
title: "My Report"
output: html_document
---

## Analysis

```{r}
summary(df)
```
````

Render with `rmarkdown::render("report.Rmd")` or the "Knit" button in RStudio.

---

## Quick Reference Cheatsheet

| Task | Code |
|---|---|
| Assign a value | `x <- 5` |
| Vector | `c(1,2,3)` |
| Data frame | `data.frame(col1=..., col2=...)` |
| Filter rows | `df %>% filter(cond)` |
| Select columns | `df %>% select(col1, col2)` |
| Sort | `df %>% arrange(col)` |
| Add column | `df %>% mutate(new = ...)` |
| Group + summarize | `df %>% group_by(x) %>% summarise(...)` |
| Read CSV | `read.csv("file.csv")` |
| Write CSV | `write.csv(df, "file.csv")` |
| Plot | `ggplot(df, aes(x,y)) + geom_point()` |
| Linear model | `lm(y ~ x, data=df)` |
| Handle NA | `na.omit()`, `na.rm=TRUE` |
| Run script | `Rscript script.R` |

## Path to "Professional" R

1. Master `dplyr` + `tidyr` for data wrangling
2. Master `ggplot2` for visualization
3. Learn R Markdown / Quarto for reproducible reports
4. Learn functions + the `apply`/`purrr` family to avoid repetitive code
5. Use version control (git) and organize projects with **RStudio Projects** (`.Rproj`)
6. Learn `testthat` for unit testing if writing packages
7. Read [Advanced R](https://adv-r.hadley.nz/) once comfortable with the basics
