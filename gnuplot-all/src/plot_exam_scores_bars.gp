# Configuration
datafile = '../datasources/students.csv'
outdir = '../out'
width = 1200
height = 700

# Terminal settings
set terminal png size width,height

# Specify comma as field separator for CSV
set datafile separator ','

# Calculate statistics for each exam
stats datafile skip 1 using 3 name "exam1"
stats datafile skip 1 using 4 name "exam2"
stats datafile skip 1 using 5 name "exam3"
stats datafile skip 1 using 6 name "final"

# Define common settings
set grid ytics lt 0 lw 1 lc rgb '#cccccc'
set xtics rotate by 45 right font ',8'
set ytics font ',8'
set yrange [40:100]
set style data histograms
set style histogram clustered gap 1
set style fill solid 0.75 border

# ===== Exam 1 Graph =====
set output outdir . '/exam1_scores.png'
set title 'Exam 1 Scores' font ',12' textcolor rgb '#333333'
set xlabel 'Student Index' font ',10'
set ylabel 'Score' font ',10'
set key top left font ',9'
plot datafile skip 1 using 3:xticlabels(1) title sprintf('Exam 1 (Mean: %.2f)', exam1_mean) lc rgb "#1f77b4"

# ===== Exam 2 Graph =====
set output outdir . '/exam2_scores.png'
set title 'Exam 2 Scores' font ',12' textcolor rgb '#333333'
set xlabel 'Student Index' font ',10'
set ylabel 'Score' font ',10'
set key top left font ',9'
plot datafile skip 1 using 4:xticlabels(1) title sprintf('Exam 2 (Mean: %.2f)', exam2_mean) lc rgb "#ff7f0e"

# ===== Exam 3 Graph =====
set output outdir . '/exam3_scores.png'
set title 'Exam 3 Scores' font ',12' textcolor rgb '#333333'
set xlabel 'Student Index' font ',10'
set ylabel 'Score' font ',10'
set key top left font ',9'
plot datafile skip 1 using 5:xticlabels(1) title sprintf('Exam 3 (Mean: %.2f)', exam3_mean) lc rgb "#2ca02c"

# ===== Final Exam Graph =====
set output outdir . '/final_scores.png'
set title 'Final Exam Scores' font ',12' textcolor rgb '#333333'
set xlabel 'Student Index' font ',10'
set ylabel 'Score' font ',10'
set key top left font ',9'
plot datafile skip 1 using 6:xticlabels(1) title sprintf('Final Exam (Mean: %.2f)', final_mean) lc rgb "#d62728"

# ===== Combined Comparison Graph =====
set output outdir . '/all_exams_comparison.png'
set title 'Student Exam Scores Comparison' font ',12' textcolor rgb '#333333'
set xlabel 'Student Index' font ',10'
set ylabel 'Score' font ',10'
set key outside right top font ',9'
plot datafile skip 1 using 3 title sprintf('Exam 1 (Mean: %.2f)', exam1_mean) lc rgb "#1f77b4", \
     datafile skip 1 using 4 title sprintf('Exam 2 (Mean: %.2f)', exam2_mean) lc rgb "#ff7f0e", \
     datafile skip 1 using 5 title sprintf('Exam 3 (Mean: %.2f)', exam3_mean) lc rgb "#2ca02c", \
     datafile skip 1 using 6 title sprintf('Final Exam (Mean: %.2f)', final_mean) lc rgb "#d62728"

# Print statistics to console
print sprintf("===== Exam Statistics =====")
print sprintf("Exam 1 - Mean: %.2f, Min: %.2f, Max: %.2f, StdDev: %.2f", exam1_mean, exam1_min, exam1_max, exam1_stddev)
print sprintf("Exam 2 - Mean: %.2f, Min: %.2f, Max: %.2f, StdDev: %.2f", exam2_mean, exam2_min, exam2_max, exam2_stddev)
print sprintf("Exam 3 - Mean: %.2f, Min: %.2f, Max: %.2f, StdDev: %.2f", exam3_mean, exam3_min, exam3_max, exam3_stddev)
print sprintf("Final  - Mean: %.2f, Min: %.2f, Max: %.2f, StdDev: %.2f", final_mean, final_min, final_max, final_stddev)

set output