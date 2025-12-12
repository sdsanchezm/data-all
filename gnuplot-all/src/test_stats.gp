# Statistics Test Script for students2.csv

set terminal png size 1000,600
set output 'stats_output.png'

set title 'Exam1 Scores - Statistical Analysis' font ',14'
set xlabel 'Student Index' font ',12'
set ylabel 'Score' font ',12'
set grid
set yrange [0:100]
set style data linespoint

# Specify comma as field separator for CSV
set datafile separator ','

# Calculate statistics
stats 'students2.csv' skip 1 using 3 name "exam"

# Plot the data
plot 'students2.csv' skip 1 using 0:3 title 'Exam1 Scores' linewidth 2 pointtype 7 pointsize 1.0, \
     exam_mean title sprintf('Mean: %.2f', exam_mean) linewidth 2 linecolor rgb "#ff0000"

# Print statistics to console
print sprintf("===== Exam1 Statistics =====")
print sprintf("Mean: %.2f", exam_mean)
print sprintf("Median: %.2f", exam_median)
print sprintf("Min: %.2f", exam_min)
print sprintf("Max: %.2f", exam_max)
print sprintf("StdDev: %.2f", exam_stddev)
print sprintf("Total Records: %d", exam_records)

set output