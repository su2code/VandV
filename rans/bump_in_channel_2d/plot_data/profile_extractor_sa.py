#!/usr/bin/env python

## \file profile_extractor_sa.py
#  \brief Python script for extracting a slice (1D) from an SU2 ASCII restart (CSV) for a 2D cartesian grid.
#  \author Thomas D. Economon
#  \version 1.0.

import os, time
from numpy import *
from matplotlib import pyplot as plt
from matplotlib import mlab

# dpi
my_dpi = 100

# Output format for images (png or eps)
fileIn  = 'solution_1409x641_sa.csv'
fileOut = 'profile_1409x641_sa.csv'

# X location for a vertical slice (extract all y-values at this x)
x = 0.75

# Load the SU2 ASCII restart files containing all quantities
data = mlab.csv2rec(fileIn, comments='#', skiprows=0, checkrows=0)

# Count the number of points found in our slice
count = 0
for point in range(len(data.x[:])):
  if data.x[point] > (x-1e-5) and data.x[point] < (x+1e-5):
    count += 1

# Create arrays to hold the slice data
su2_x = zeros(count)
su2_y = zeros(count)
su2_m = zeros(count)
su2_v = zeros(count)

# Extract the data for the slice only
count = 0
for point in range(len(data.x[:])):
  if data.x[point] > (x-1e-5) and data.x[point] < (x+1e-5):
    su2_m[count] = data.eddy_viscosity[point]
    su2_v[count] = data.momentum_x[point]/data.density[point]
    su2_x[count] = data.x[point]
    su2_y[count] = data.y[point]
    count += 1

# Write the data to a new, smaller CSV file for postprocessing later
# convert the history file into a true csv file and load
profile = open(fileOut,"w")
profile.write('"x","y","m","v"\n')
for point in range(count):
  line = str(su2_x[point]) + ", " + str(su2_y[point]) + ", " + str(su2_m[point]) + ", " + str(su2_v[point]) + "\n"
  profile.write(line)
profile.close()
