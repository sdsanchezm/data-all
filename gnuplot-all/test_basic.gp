# Basic Gnuplot Test Script

set terminal png size 800,600
set output 'test_output.png'

set title 'Basic Gnuplot Test' font ',14'
set xlabel 'X Axis' font ',12'
set ylabel 'Y Axis' font ',12'
set grid

# Plot a simple sine wave
plot sin(x) title 'sin(x)' linewidth 2, \
     cos(x) title 'cos(x)' linewidth 2

set output