# data-all
repo to play around data manipulation, graph, reporting and etls using various tools

# # Gnuplot: A Basic Tutorial

Gnuplot is a free, command-line plotting program used to visualize functions and data. It's lightweight, scriptable, and widely used in scientific/engineering work (and it's a natural fit for a homelab or Linux box).

## 1. Install Gnuplot

```bash
# Debian/Ubuntu
sudo apt install gnuplot

# Fedora
sudo dnf install gnuplot

# macOS (Homebrew)
brew install gnuplot
```

Launch it by typing:

```bash
gnuplot
```

You'll get an interactive prompt: `gnuplot>`

## 2. Plot a Simple Function

```gnuplot
plot sin(x)
```

Gnuplot opens a window and plots `sin(x)`. You can plot multiple functions at once:

```gnuplot
plot sin(x), cos(x)
```

## 3. Set the Plot Range

```gnuplot
set xrange [-10:10]
set yrange [-2:2]
plot sin(x)
```

## 4. Add Titles and Labels

```gnuplot
set title "Sine Wave"
set xlabel "x"
set ylabel "sin(x)"
plot sin(x) title "sin(x)"
```

## 5. Plot Data from a File

Say you have a file `data.txt`:

```
1 2.1
2 3.9
3 6.2
4 7.8
5 10.1
```

Plot it with:

```gnuplot
plot "data.txt" with linespoints
```

- `using 1:2` lets you pick which columns to plot (default is 1:2).
- `with lines`, `with points`, `with linespoints` control the style.

Example with custom columns and style:

```gnuplot
plot "data.txt" using 1:2 with points pointtype 7 title "My Data"
```

## 6. Plot Multiple Data Sets Together

```gnuplot
plot "data1.txt" with lines title "Set 1", \
     "data2.txt" with lines title "Set 2"
```

(The `\` lets you continue the command on the next line.)

## 7. Save Output to a File (instead of a window)

```gnuplot
set terminal png
set output "plot.png"
plot sin(x)
```

Common terminals: `png`, `pdf`, `svg`, `jpeg`. After setting the terminal, run `replot` or re-issue `plot` to render to the file.

## 8. Use a Script File

Instead of typing commands interactively, save them in a `.gp` or `.plt` file:

```gnuplot
# myplot.gp
set title "My Data"
set xlabel "Time"
set ylabel "Value"
set grid
plot "data.txt" with linespoints title "Measurements"
```

Run it with:

```bash
gnuplot myplot.gp
```

Add `pause -1` at the end of the script if you want the window to stay open (interactive terminals only).

## 9. Other Useful Commands

| Command | Purpose |
|---|---|
| `set grid` | Adds a grid to the plot |
| `set logscale y` | Log scale on the y-axis |
| `set key top left` | Positions the legend |
| `reset` | Resets all settings to default |
| `show variables` | Lists defined variables |
| `help <topic>` | Built-in help, e.g. `help plot` |

## 10. Quick Example: Full Workflow

```gnuplot
set terminal png size 800,600
set output "sine_wave.png"
set title "Sine Function"
set xlabel "x"
set ylabel "sin(x)"
set grid
plot sin(x) with lines linewidth 2 title "sin(x)"
```

Run with `gnuplot script.gp` and you'll get `sine_wave.png` in your working directory.

---

# Gnuplot: Advanced Tutorial

This builds on the basics (functions, data files, terminals, styling) and covers techniques for real analysis work: multiplots, 3D surfaces, curve fitting, statistics, loops, and publication-quality output.

## 1. Multiplot Layouts

Combine several plots into one figure:

```gnuplot
set multiplot layout 2,2 title "Sensor Overview"

set title "Temperature"
plot "data.txt" using 1:2 with lines

set title "Humidity"
plot "data.txt" using 1:3 with lines

set title "Pressure"
plot "data.txt" using 1:4 with lines

set title "Wind Speed"
plot "data.txt" using 1:5 with lines

unset multiplot
```

`layout rows,cols` auto-arranges the grid. You can also manually position each plot with `set origin` and `set size` for non-uniform layouts.

## 2. 3D Plots with `splot`

```gnuplot
set xrange [-5:5]
set yrange [-5:5]
splot sin(sqrt(x**2 + y**2))
```

For a smooth shaded surface instead of a wireframe:

```gnuplot
set pm3d
set hidden3d
set isosamples 50,50
splot sin(sqrt(x**2 + y**2)) with pm3d
```

Rotate the view:

```gnuplot
set view 60, 30
```

## 3. Contour and Heatmap Plots

```gnuplot
set contour base
set cntrparam levels 10
unset surface
set view map
splot sin(x)*cos(y) with lines
```

For a heatmap from a data file (matrix format):

```gnuplot
set view map
set pm3d at b
splot "matrix_data.txt" matrix with pm3d
```

Add a color legend:

```gnuplot
set palette rgbformulae 33,13,10
set colorbox
```

## 4. Curve Fitting

Gnuplot can fit data to a function using nonlinear least squares.

```gnuplot
f(x) = a*x + b
fit f(x) "data.txt" using 1:2 via a, b
plot "data.txt" using 1:2 with points title "Data", f(x) title "Fit"
```

After fitting, check `a`, `b`, and their errors:

```gnuplot
print a, b
```

Fit results (including standard errors and correlation) are also written to `fit.log` by default.

For weighted fits (with error bars in column 3):

```gnuplot
fit f(x) "data.txt" using 1:2:3 via a, b
```

## 5. Statistics on Data

```gnuplot
stats "data.txt" using 2 name "Y"
print Y_mean, Y_stddev, Y_max, Y_min
```

This computes mean, standard deviation, min/max, and more — useful before deciding on plot ranges or normalization.

## 6. Loops and Automation

### `do for` loops

Plot multiple files in a loop:

```gnuplot
files = "run1.txt run2.txt run3.txt"
plot for [f in files] f using 1:2 with lines title f
```

Numeric loop example — generate 5 output images:

```gnuplot
do for [i=1:5] {
    set output sprintf("frame_%02d.png", i)
    plot sprintf("data_%d.txt", i) with lines
}
```

`sprintf` works like C's printf for building filenames/titles dynamically.

## 7. Error Bars

```gnuplot
plot "data.txt" using 1:2:3 with yerrorbars title "Measured"
```

Column 3 here is the error magnitude. For asymmetric errors, use `xyerrorbars` with 4–6 columns depending on the format (`help errorbars` for exact column layouts).

## 8. Histograms

```gnuplot
set style data histograms
set style histogram cluster gap 1
set style fill solid border -1
set boxwidth 0.9
plot "sales.txt" using 2:xtic(1) title "Q1", \
     "" using 3 title "Q2"
```

## 9. Custom Styles, Colors, and Line Types

Define reusable line styles:

```gnuplot
set style line 1 linecolor rgb "#0060ad" linewidth 2 pointtype 7 pointsize 1.5
set style line 2 linecolor rgb "#dd181f" linewidth 2 pointtype 5

plot "data.txt" using 1:2 with linespoints linestyle 1 title "Series A", \
     "data.txt" using 1:3 with linespoints linestyle 2 title "Series B"
```

## 10. Annotations: Labels, Arrows, and Objects

```gnuplot
set label "Peak" at 5,10 point pointtype 7
set arrow from 3,3 to 5,10 head filled
set object 1 rect from 2,2 to 4,4 fillcolor rgb "yellow" fillstyle transparent solid 0.3
plot "data.txt" with lines
```

## 11. Data Blocks (Inline Data Without a File)

```gnuplot
$MyData << EOD
1 2
2 4
3 9
4 16
EOD

plot $MyData using 1:2 with linespoints
```

Great for quick tests or self-contained scripts you want to share without external files.

## 12. Publication-Quality Output

```gnuplot
set terminal pdfcairo enhanced font "Helvetica,12" size 6,4
set output "figure.pdf"
set title "Results"
set xlabel "Time (s)"
set ylabel "Amplitude"
set key outside right
set grid
plot "data.txt" using 1:2 with lines linewidth 2 title "Signal"
set output
```

`enhanced` enables text formatting (subscripts, superscripts, Greek letters via `{/Symbol a}`, etc.). Always finish with `set output` (no filename) to flush and close the file.

## 13. Running Gnuplot Non-Interactively

Run a one-off command from the shell:

```bash
gnuplot -e "set terminal png; set output 'out.png'; plot sin(x)"
```

Or persist a session after running a script (useful for interactive follow-up):

```bash
gnuplot -persist myscript.gp
```

## 14. Piping Data Through External Tools

Gnuplot can read from a shell command instead of a file:

```gnuplot
plot "< awk '{print $1, $2*2}' data.txt" with lines
```

This lets you preprocess data on the fly with `awk`, `sed`, `sort`, etc. without creating intermediate files.

## 15. Animations (GIF)

```gnuplot
set terminal gif animate delay 20
set output "animation.gif"
do for [i=0:50] {
    plot sin(x + i*0.1) with lines
}
set output
```

---

## Quick Reference: Useful Settings

| Command | Effect |
|---|---|
| `set logscale xy` | Log scale on both axes |
| `set size ratio -1` | Equal aspect ratio |
| `set datafile separator ","` | Parse CSV files |
| `set autoscale` | Reset to auto axis ranges |
| `set encoding utf8` | Proper UTF-8 label rendering |
| `unset key` | Hide the legend |

**Where to go next:** look into `set style function`, gnuplot's `system()` call for shelling out mid-script, and combining gnuplot with cron jobs for automated report generation.


# Gnuplot: Working with Data

This tutorial focuses specifically on getting real data into gnuplot — reading files, selecting columns, handling different formats, cleaning/transforming data, and combining multiple datasets.

## 1. The Basic Data File Format

Gnuplot expects whitespace-separated columns by default:

```
# time  temperature  humidity
1       20.1         45
2       21.4         44
3       22.0         43
4       21.8         46
```

Lines starting with `#` are comments and ignored. Blank lines separate "blocks" of data (useful for multi-dataset files, see §7).

Plot it:

```gnuplot
plot "sensor.txt" using 1:2 with linespoints title "Temp"
```

## 2. Selecting Columns with `using`

```gnuplot
plot "sensor.txt" using 1:3 title "Humidity"       # columns 1 and 3
plot "sensor.txt" using 1:($2*1.8+32) title "Temp (F)"  # transform on the fly
```

You can do arithmetic directly in `using`, reference columns as `$1`, `$2`, etc., and even build conditional expressions:

```gnuplot
# Only plot points where humidity > 44
plot "sensor.txt" using 1:($3>44 ? $2 : 1/0)
```

`1/0` produces an undefined value, which gnuplot simply skips — a common trick for filtering data inline.

## 3. CSV and Other Delimiters

```gnuplot
set datafile separator ","
plot "data.csv" using 1:2 with lines
```

Reset to whitespace afterward if needed:

```gnuplot
set datafile separator whitespace
```

## 4. Skipping Header Rows

If row 1 is a text header (not a `#` comment):

```gnuplot
plot "data.csv" using 1:2 every ::1 with lines
```

`every ::1` starts at row index 1 (0-indexed), skipping the header row.

## 5. Using Column Headers as Titles

If the first line has column names, you can auto-label:

```gnuplot
set key autotitle columnhead
plot "data.csv" using 1:2, "" using 1:3
```

## 6. The `every` Keyword (Subsetting Rows)

```gnuplot
plot "data.txt" every 2 using 1:2          # every 2nd point
plot "data.txt" every ::10::50 using 1:2   # rows 10 through 50
plot "data.txt" every 5::0::100            # every 5th row, from 0 to 100
```

Useful for large files where you don't need every point rendered.

## 7. Multiple Datasets in One File (Index Blocks)

If a file has several datasets separated by blank lines:

```
1 10
2 12
3 14

1 5
2 6
3 8
```

Select which block with `index`:

```gnuplot
plot "multi.txt" index 0 using 1:2 title "Set A", \
     "multi.txt" index 1 using 1:2 title "Set B"
```

## 8. Plotting Time Series (Dates)

```gnuplot
set xdata time
set timefmt "%Y-%m-%d"
set format x "%b %d"
plot "timeseries.txt" using 1:2 with lines
```

Data file example:

```
2026-01-01  10.2
2026-01-02  11.5
2026-01-03  9.8
```

For timestamps with time-of-day:

```gnuplot
set timefmt "%Y-%m-%d %H:%M:%S"
set format x "%H:%M"
```

## 9. Handling Missing/Bad Data

Gnuplot treats blank lines as breaks and skips lines where the requested columns aren't valid numbers. To explicitly mark missing values in a file, use a symbol like `NaN` or `?`:

```
1 10
2 ?
3 14
```

```gnuplot
set datafile missing "?"
plot "data.txt" using 1:2 with linespoints
```

## 10. Combining Data from Multiple Files

```gnuplot
plot "file1.txt" using 1:2 with lines title "Site A", \
     "file2.txt" using 1:2 with lines title "Site B", \
     "file3.txt" using 1:2 with lines title "Site C"
```

## 11. Summary Statistics Before Plotting

Always worth checking your data's shape first:

```gnuplot
stats "data.txt" using 2 name "Y" nooutput
set yrange [Y_min*0.9 : Y_max*1.1]
plot "data.txt" using 1:2 with lines
```

`nooutput` suppresses the printed summary while still setting the `Y_*` variables.

## 12. Preprocessing Data with Shell Pipes

Instead of editing the file, filter/transform it inline:

```gnuplot
# Only rows where column 2 > 100, using awk
plot "< awk '$2>100' data.txt" using 1:2 with points

# Sort by column 1
plot "< sort -n -k1 data.txt" using 1:2 with lines
```

## 13. Matrix / Grid Data (for heatmaps)

If your data is a 2D grid (rows = y, columns = x, values = z):

```gnuplot
set view map
set pm3d at b
splot "grid.txt" matrix with pm3d
```

For (x, y, z) triplets instead of matrix form:

```gnuplot
splot "points.txt" using 1:2:3 with pm3d
```

(Ensure blank lines separate rows of the grid for `splot` in non-matrix mode — gnuplot needs this to know the grid structure.)

## 14. Practical Example: Full Workflow

```gnuplot
set datafile separator ","
set datafile missing "NA"
set key autotitle columnhead
set xdata time
set timefmt "%Y-%m-%d"
set format x "%b %d"
set xlabel "Date"
set ylabel "Value"
set grid
set terminal pngcairo size 900,500
set output "report.png"

stats "readings.csv" using 2 name "V" nooutput
set yrange [V_min*0.95:V_max*1.05]

plot "readings.csv" using 1:2 every ::1 with linespoints title "Reading"
set output
```

This handles a CSV with a header row, missing values marked `NA`, date-based x-axis, auto-scaled y-range based on actual data, and saves to a PNG — a realistic pipeline for real-world logs or exported spreadsheets.

---

## Quick Reference

| Task | Syntax |
|---|---|
| Pick columns | `using 1:2` |
| Transform a column | `using 1:($2*2)` |
| CSV files | `set datafile separator ","` |
| Skip header row | `every ::1` |
| Subset rows | `every N` or `every ::start::end` |
| Multiple blocks in one file | `index N` |
| Missing values | `set datafile missing "?"` |
| Dates on x-axis | `set xdata time` + `set timefmt` |
| Filter/transform via shell | `"< awk ... file.txt"` |


