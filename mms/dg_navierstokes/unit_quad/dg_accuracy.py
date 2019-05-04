#!/usr/bin/env python

## \file order_of_accuracy.py
#  \brief Python script for computing order of accuracy using MMS cases in SU2.
#  \author Thomas D. Economon, Edwin van der Weide
#  \version 1.0.

import os, time
import subprocess as sp
from numpy import *
from collections import OrderedDict
from matplotlib import pyplot as plt
from matplotlib import mlab

# dpi for figures
my_dpi = 100

# set the legend tags for each config
legends = ["p=1", "p=2", "p=3", "p=4", "p=5"]

# number of mesh elements for NxN quad meshes
meshParam = [2,4,8,16,32]

# number of DOFs per element.
nDOFsPerElem = [4, 9, 16, 25, 36]

###############################################################################
# End user parameter selection. Begin execution below.
###############################################################################

# brief error checking
if len(nDOFsPerElem) != len(legends):
  print("Check lengths of input lists for nDOFsPerElem and legends.")
  raise SystemExit

for iMesh in range(len(meshParam)-1):
  if (meshParam[iMesh+1])/(meshParam[iMesh]) != 2:
    print("Script requires mesh size N to increase by a factor of 2. Please check list of sizes.")
    raise SystemExit

# some extra labels for plotting
symb = ['s','o','d','^','*']
colo = ['blue','green','orange','red','brown']

# set up a dictionary to hold the results
runs_dict = []

# set up an array to hold the relative element size
h = zeros(len(meshParam)*len(legends))
hDG = zeros(len(meshParam)*len(legends))

# print initial statement about number of cases
print("Evaluating " + str(len(meshParam)*len(legends)) + " MMS cases.")

# loop over all meshes in the grid study
for case in range(len(meshParam)*len(legends)):

  # set the correct number for iConfig
  iConfig = int(case / len(meshParam))

  # determine the polynomial degree
  polDegree = iConfig + 1
  
  # set the correct number for iMesh
  iMesh = case % len(meshParam)
  
  # compute the relative element size for this mesh
  # take the polynomial degree into account.
  h[case] = meshParam[-1]/(meshParam[iMesh]*float(polDegree))

  # determine the total number of DOFs. The sqrt (in 2D)
  # presents the 1D value for a grid convergence study.
  nDOFsTot = meshParam[iMesh]*meshParam[iMesh]*nDOFsPerElem[iConfig]
  hDG[case] = 1.0/sqrt(float(nDOFsTot))

  # determine the name of the output file.
  filename = "SU2_DG_n" + str(meshParam[iMesh]) + "_p" + str(polDegree) + ".out"

  # parse the console output file to extract the final computed error
  file = open(filename)
  for line in file:
    if "Global Error Analysis" in line:
      result = {}
      counter = 0
      for subline in file:
        if "|" in subline and ":" in subline:
          tokens = subline.replace('\n','').replace(' ','').replace('[','').replace(']','').split('|')
          for val in range(0,size(tokens)):
            name, var = tokens[val].partition(":")[::2]
            result[name.replace('.','').strip().lower()] = float(var)
          result['count'] = case
        counter = counter + 1
        if counter > 10:
          break
      if len(runs_dict) == 0:
        runs_dict.append(result)
      else:
        found = False
        for entry in runs_dict:
          if entry["count"] == result["count"]:
            found = True
            for k in entry.keys():
              if k != "count":
                entry[k] = result[k]
        if not found:
          runs_dict.append(result)

  print("Case " + str(case+1) + " finished.")

  # end loop over console output

# end loop over grids

print("Computing order of accuracy and creating figures.")

# Set the spacing used for the plotting.
# hh = h
hh = hDG

# Determine the minimum and maximum value of hh used for plotting.
hhMin = 0.8*min(hh[:])
hhMax = 2.0*max(hh[:])

# post processing the data for easier plotting
rmserrorrho  = []
rmserrorrhou = []
rmserrorrhov = []
rmserrorrhoe = []
maxerrorrho  = []
maxerrorrhou = []
maxerrorrhov = []
maxerrorrhoe = []
orderrho     = []
orderrhou    = []
orderrhov    = []
orderrhoe    = []
elemsize     = []


ii = 0
minrms = 1e6
maxrms = 0
for entry in runs_dict:
  rmserrorrho.append(float(entry['rmserrorrho']))
  rmserrorrhou.append(float(entry['rmserrorrhou']))
  rmserrorrhov.append(float(entry['rmserrorrhov']))
  rmserrorrhoe.append(float(entry['rmserrorrhoe']))
  maxerrorrho.append(float(entry['maxerrorrho']))
  maxerrorrhou.append(float(entry['maxerrorrhou']))
  maxerrorrhov.append(float(entry['maxerrorrhov']))
  maxerrorrhoe.append(float(entry['maxerrorrhoe']))
  if ii % len(meshParam) > 0:
    orderrho.append(log(rmserrorrho[-2]/rmserrorrho[-1])/log(2))
    orderrhou.append(log(rmserrorrhou[-2]/rmserrorrhou[-1])/log(2))
    orderrhov.append(log(rmserrorrhov[-2]/rmserrorrhov[-1])/log(2))
    orderrhoe.append(log(rmserrorrhoe[-2]/rmserrorrhoe[-1])/log(2))
    elemsize.append(h[ii])
  if rmserrorrhoe[-1] > maxrms:
    maxrms = rmserrorrhoe[-1]
  if rmserrorrhoe[-1] < minrms:
    minrms = rmserrorrhoe[-1]
  ii += 1

# build slope 2 and slope 6 lines for comparison
x6 = linspace(min(hh[:]),max(hh[:]), 20)
y6 = 0.5*minrms*(x6/x6[0])**6.0

x2 = linspace(min(hh[:]),max(hh[:]), 20)
y2 = 2.0*maxrms*(x2/x2[-1])**2.0

# Plot and save an eps image for error analysis
plt.clf()
plt.figure(figsize=(800/my_dpi, 600/my_dpi), dpi=my_dpi)

# add slope 2 and 6
plt.loglog(x6,y6,linestyle='-', marker='', color='black',linewidth = 1.5, markersize=6, label=r'Slope 6')
plt.loglog(x2,y2,linestyle='--', marker='', color='black',linewidth = 1.5, markersize=6, label=r'Slope 2')

# loop over all cases
for case in range(len(legends)):

  # set the coorect number for iConfig
  iBeg = case*len(meshParam)
  iEnd = iBeg + len(meshParam)

  plt.loglog(hh[iBeg:iEnd],rmserrorrhoe[iBeg:iEnd],linestyle='', marker=symb[case], color=colo[case], linewidth = 1.5, markersize=9, label=legends[case])

plt.ylim([0.5*min(rmserrorrhoe[:]),5.0*max(rmserrorrhoe[:])])
plt.xlim([hhMin,hhMax])
plt.xlabel(r'1/Sqrt(nDOFs)', fontsize=20)
plt.ylabel(r'RMS Error [rho E]', fontsize=20)
#plt.title(r'Some Title', fontsize=12)
plt.legend(loc='best',fontsize=16)
for label in plt.gca().get_xticklabels() + plt.gca().get_yticklabels():
  label.set_fontsize(13)
plt.grid('on')
plt.gcf().subplots_adjust(left=0.15)
plt.gcf().subplots_adjust(bottom=0.13)
plt.savefig('slope_DG.eps',format='eps',dpi=my_dpi*4)

# Determine the minimum and maximum value of hh used for plotting.
hhMin = 0.8*min(elemsize[:])
hhMax = 2.0*max(elemsize[:])

# Plot and save an eps image for order of accuracy
plt.clf()
plt.figure(figsize=(800/my_dpi, 600/my_dpi), dpi=my_dpi)

# loop over all cases
for case in range(len(legends)):

  # set the coorect number for iConfig
  iBeg = case*(len(meshParam)-1)
  iEnd = iBeg + len(meshParam) - 1

  # plot the order of accuracy
  plt.semilogx(elemsize[iBeg:iEnd],orderrhoe[iBeg:iEnd],linestyle='-', marker=symb[case], color=colo[case], linewidth = 1.5, markersize=9, label=legends[case])

plt.ylim([0.5,6.5])
plt.xlim([hhMin,hhMax])
plt.xlabel(r'Relative Element Size', fontsize=20)
plt.ylabel(r'Order of Accuracy [rho E]', fontsize=20)
plt.legend(loc='best',fontsize=16)
for label in plt.gca().get_xticklabels() + plt.gca().get_yticklabels():
  label.set_fontsize(13)
plt.grid('on')
plt.gcf().subplots_adjust(left=0.15)
plt.gcf().subplots_adjust(bottom=0.13)
plt.savefig('accuracy.eps',format='eps',dpi=my_dpi*4)
