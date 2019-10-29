#!/usr/bin/env python

## \file order_of_accuracy.py
#  \brief Python script for computing order of accuracy using MMS cases in SU2.
#  \author Thomas D. Economon
#  \version 6.2.0 "Falcon"
#
# The current SU2 release has been coordinated by the
# SU2 International Developers Society <www.su2devsociety.org>
# with selected contributions from the open-source community.
#
# The main research teams contributing to the current release are:
#  - Prof. Juan J. Alonso's group at Stanford University.
#  - Prof. Piero Colonna's group at Delft University of Technology.
#  - Prof. Nicolas R. Gauger's group at Kaiserslautern University of Technology.
#  - Prof. Alberto Guardone's group at Polytechnic University of Milan.
#  - Prof. Rafael Palacios' group at Imperial College London.
#  - Prof. Vincent Terrapon's group at the University of Liege.
#  - Prof. Edwin van der Weide's group at the University of Twente.
#  - Lab. of New Concepts in Aeronautics at Tech. Institute of Aeronautics.
#
# Copyright 2012-2019, Francisco D. Palacios, Thomas D. Economon,
#                      Tim Albring, and the SU2 contributors.
#
# SU2 is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# SU2 is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with SU2. If not, see <http://www.gnu.org/licenses/>.

import os, time
import subprocess as sp
from numpy import *
from collections import OrderedDict
import matplotlib as mpl
mpl.use('Agg')
from matplotlib import pyplot as plt
from matplotlib import mlab

# dpi for figures
my_dpi = 100

# number or ranks to use
nRank = 4

# these are the commands for the SU2 and mesh generation runs
# user can switch between quad and tria meshes by changing the script
commands = ["mpirun -n %s SU2_CFD " % (nRank), "./create_grid_quad.py"]

# SU2 config file name
fnames = ["lam_mms_fds.cfg","lam_mms_fds_lim.cfg","lam_mms_wls.cfg","lam_mms_jst.cfg"]

# list of variables from the current solver to plot
variables = ["p", "u", "v"]

# set the legend tags for each config
legends = ["FDS+GG", "FDS+GG+LIM", "FDS+WLS", "JST+GG"]

# set the filenames for our output files
filename = "SU2.out"

# number of mesh nodes for NxN tria and quad meshes
meshParam = [9,17,33,65,129,257]

# output format for images (png or eps)
imgfrm = 'png'

###############################################################################
# End user parameter selection. Begin execution below.
###############################################################################

# brief error checking
if len(commands) != 2 or len(fnames) != len(legends):
  print( "Check lengths of input lists for commands, configs, and legends.")
  raise SystemExit

for iMesh in range(len(meshParam)-1):
  if (meshParam[iMesh+1]-1)/(meshParam[iMesh]-1) != 2:
    print( "Script requires mesh size N to increase by a factor of 2. Please check list of sizes.")
    raise SystemExit

# some extra labels for plotting
symb = ['s','o','d','^']
colo = ['blue','green','orange','red']

# set up a dictionary to hold the results
runs_dict = []

# set up an array to hold the relative element size
h = zeros(len(meshParam)*len(fnames))

# print initial statement about number of cases
print( "Running " + str(len(meshParam)*len(fnames)) + " MMS cases.")

# loop over all meshes in the grid study
for case in range(len(meshParam)*len(fnames)):

  # set the coorect number for iConfig
  iConfig = case / len(meshParam)
  
  # set the correct number for iMesh
  iMesh = case % len(meshParam)
  
  # compute the relative element size for this mesh
  h[case] = (int(meshParam[-1])-1)/(int(meshParam[iMesh])-1)
  
  # build the command to create the mesh
  commandGrid = commands[1]+" -n %s -m %s" % (meshParam[iMesh],meshParam[iMesh])

  # call the grid generator for this mesh size
  sp.call(commandGrid,shell=True)

  # build the SU2 command
  commandSU2 = commands[0]+fnames[int(iConfig)]+" > "+filename

  # call SU2 to run the calculation
  sp.call(commandSU2,shell=True)

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

  print( "Case " + str(case+1) + " finished.")

  # end loop over console output

# end loop over grids

print( "Computing order of accuracy and creating figures.")

# loop over all cases
for ivar in range(len(variables)):
  
  # set the correct variable string
  var = variables[ivar]
  rmstag = "rmserror%s" % (var)
  maxtag = "maxerror%s" % (var)

  # post processing the data for easier plotting
  rmserror = []
  maxerror = []
  orderrms = []
  ordermax = []
  elemsize = []

  ii = 0
  minrms = 1e6
  maxrms = 0
  minmax = 1e6
  maxmax = 0
  for entry in runs_dict:
    rmserror.append(float(entry[rmstag]))
    maxerror.append(float(entry[maxtag]))
    if ii % len(meshParam) > 0:
      orderrms.append(log(rmserror[-2]/rmserror[-1])/log(2))
      ordermax.append(log(maxerror[-2]/maxerror[-1])/log(2))
      elemsize.append(h[ii])
    if ii % len(meshParam) == len(meshParam)-1:
      if rmserror[-1] > maxrms:
        maxrms = rmserror[-1]
      if maxerror[-1] > maxmax:
        maxmax = maxerror[-1]
    if rmserror[-1] < minrms:
      minrms = rmserror[-1]
    if maxerror[-1] < minmax:
      minmax = maxerror[-1]
    ii += 1

  # print the observed order of accuracy
  print( "\n\nObserved order of accuracy for "+var+" equation\n")
  print( "h         RMS Order        Max Order")
  print( "------------------------------------")
  for val in range(len(elemsize)):
    print( str(elemsize[val])+"   "+str(orderrms[val])+"   "+str(ordermax[val]))

  # build slope 1 and slope 2 lines for comparison
  x2 = linspace(1e-1, 100.0, 20)
  y2 = minrms*(x2)**2.0

  x1 = linspace(1e-1, 100.0, 20)
  y1 = maxrms*(x1)**1.0

  # Plot and save an image for rms error analysis
  plt.clf()
  plt.figure(figsize=(800/my_dpi, 600/my_dpi), dpi=my_dpi)

  # add slope 1 and 2 lines
  plt.loglog(x2,y2,linestyle='-', marker='', color='black',linewidth = 1.5, markersize=6, label=r'Slope 2')
  plt.loglog(x1,y1,linestyle='--', marker='', color='black',linewidth = 1.5, markersize=6, label=r'Slope 1')

  # loop over all cases
  for case in range(len(fnames)):
    
    # set the coorect number for iConfig
    iBeg = case*len(meshParam)
    iEnd = iBeg + len(meshParam)

    plt.loglog(h[iBeg:iEnd],rmserror[iBeg:iEnd],linestyle='', marker=symb[case], color=colo[case], linewidth = 1.5, markersize=9, label=legends[case])

  plt.ylim([0.5*min(rmserror[:]),5.0*max(rmserror[:])])
  plt.xlim([0.8,22.0])
  plt.xlabel(r'Relative Element Size', fontsize=20)
  plt.ylabel(r'RMS Error [%s]' %(var), fontsize=20)
  plt.legend(loc='best',fontsize=16)
  for label in plt.gca().get_xticklabels() + plt.gca().get_yticklabels():
    label.set_fontsize(13)
  plt.grid('on')
  plt.gcf().subplots_adjust(left=0.15)
  plt.gcf().subplots_adjust(bottom=0.13)
  plt.savefig('slope_rms_%s.png'%(var),format=imgfrm,dpi=my_dpi*4)

  # Plot and save an eps image for order of accuracy
  plt.clf()
  plt.figure(figsize=(800/my_dpi, 600/my_dpi), dpi=my_dpi)

  # loop over all cases
  for case in range(len(fnames)):
    
    # set the coorect number for iConfig
    iBeg = case*(len(meshParam)-1)
    iEnd = iBeg + len(meshParam) - 1
    
    # plot the order of accuracy
    plt.semilogx(elemsize[iBeg:iEnd],orderrms[iBeg:iEnd],linestyle='-', marker=symb[case], color=colo[case], linewidth = 1.5, markersize=9, label=legends[case])

  plt.ylim([-0.5,3.5])
  plt.xlim([0.8,22.0])
  plt.xlabel(r'Relative Element Size', fontsize=20)
  plt.ylabel(r'Order of Accuracy (RMS) [%s]'%(var), fontsize=20)
  plt.legend(loc='best',fontsize=16)
  for label in plt.gca().get_xticklabels() + plt.gca().get_yticklabels():
    label.set_fontsize(13)
  plt.grid('on')
  plt.gcf().subplots_adjust(left=0.15)
  plt.gcf().subplots_adjust(bottom=0.13)
  plt.savefig('accuracy_rms_%s.png'%(var),format=imgfrm,dpi=my_dpi*4)

  # build slope 1 and slope 2 lines for comparison
  x2 = linspace(1e-1, 100.0, 20)
  y2 = minmax*(x2)**2.0

  x1 = linspace(1e-1, 100.0, 20)
  y1 = maxmax*(x1)**1.0

  # Plot and save an image for max error analysis
  plt.clf()
  plt.figure(figsize=(800/my_dpi, 600/my_dpi), dpi=my_dpi)

  # add slope 1 and 2 lines
  plt.loglog(x2,y2,linestyle='-', marker='', color='black',linewidth = 1.5, markersize=6, label=r'Slope 2')
  plt.loglog(x1,y1,linestyle='--', marker='', color='black',linewidth = 1.5, markersize=6, label=r'Slope 1')

  # loop over all cases
  for case in range(len(fnames)):
    
    # set the coorect number for iConfig
    iBeg = case*len(meshParam)
    iEnd = iBeg + len(meshParam)
    
    plt.loglog(h[iBeg:iEnd],maxerror[iBeg:iEnd],linestyle='', marker=symb[case], color=colo[case], linewidth = 1.5, markersize=9, label=legends[case])

  plt.ylim([0.5*min(maxerror[:]),5.0*max(maxerror[:])])
  plt.xlim([0.8,22.0])
  plt.xlabel(r'Relative Element Size', fontsize=20)
  plt.ylabel(r'Max Error [%s]' %(var), fontsize=20)
  plt.legend(loc='best',fontsize=16)
  for label in plt.gca().get_xticklabels() + plt.gca().get_yticklabels():
    label.set_fontsize(13)
  plt.grid('on')
  plt.gcf().subplots_adjust(left=0.15)
  plt.gcf().subplots_adjust(bottom=0.13)
  plt.savefig('slope_max_%s.png'%(var),format=imgfrm,dpi=my_dpi*4)

  # Plot and save an eps image for order of accuracy
  plt.clf()
  plt.figure(figsize=(800/my_dpi, 600/my_dpi), dpi=my_dpi)

  # loop over all cases
  for case in range(len(fnames)):
    
    # set the coorect number for iConfig
    iBeg = case*(len(meshParam)-1)
    iEnd = iBeg + len(meshParam) - 1
    
    # plot the order of accuracy
    plt.semilogx(elemsize[iBeg:iEnd],ordermax[iBeg:iEnd],linestyle='-', marker=symb[case], color=colo[case], linewidth = 1.5, markersize=9, label=legends[case])

  plt.ylim([-0.5,3.5])
  plt.xlim([0.8,22.0])
  plt.xlabel(r'Relative Element Size', fontsize=20)
  plt.ylabel(r'Order of Accuracy (Max) [%s]'%(var), fontsize=20)
  plt.legend(loc='best',fontsize=16)
  for label in plt.gca().get_xticklabels() + plt.gca().get_yticklabels():
    label.set_fontsize(13)
  plt.grid('on')
  plt.gcf().subplots_adjust(left=0.15)
  plt.gcf().subplots_adjust(bottom=0.13)
  plt.savefig('accuracy_max_%s.png'%(var),format=imgfrm,dpi=my_dpi*4)
