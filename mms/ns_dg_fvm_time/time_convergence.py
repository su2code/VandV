#!/usr/bin/env python

## \file time_convergence.py
#  \brief Python script for evaluating time convergence in SU2
#  \author Corey Murphey
#  \version 7.2.1 "Blackbird"
#

import os, time
import subprocess as sp
from numpy import *
import pandas as pd
from collections import OrderedDict
import matplotlib as mpl
mpl.use('Agg')
from matplotlib import pyplot as plt
from matplotlib import mlab

# number or ranks to use with mpi
nRank = 2

# These are the commands to run SU2 with mpi and to alter the timestep size 
# within the SU2 configuration files.
# The configuration files rely on a quad mesh (square.su2)
commands = ["mpirun -np %s SU2_CFD " % (nRank), "./update_ts.py"]

# if you want to change the mesh parameters, you may do so here: 
# number of mesh nodes for NxN tria and quad meshes
meshParam_n = 33
meshParam_m = 33
meshCommand = ["./create_grid_quad.py"] #.create_grid_tria.py for triangular mesh
# call the grid generator for this mesh size
sp.call(meshCommand[0]+" -n %s -m %s" % (meshParam_n, meshParam_m), shell=True)

# SU2 config file name (change these for other cases). N.B., these must be unsteady flow simulations
fnames = ["lam_mms_dg_unst.cfg", "lam_mms_jst_unst.cfg","lam_mms_roe_lim_unst.cfg", 
          "lam_mms_roe_unst.cfg", "lam_mms_roe_wls_unst.cfg"]

# list of variables from the current solver to plot
variables = ["rho", "rhou", "rhov", "rhoe"]

# set the legend tags for each config
legends = ["DG", "JST", "ROE+LIM","ROE+GG", "ROE+WLS"]

# set the filenames for our output files
filename = "SU2.out"

# set the timestep sizes for time-dependent simulation
ts = [1e-10, 1e-9, 1e-8, 1e-7, 1e-6]

# set the TIME_MARCHING scheme for time-dependent simulation [TIME_STEPPING, 
# DUAL_TIME_STEPPING-1ST_ORDER, DUAL_TIME_STEPPING-2ND_ORDER]
tm = ["TIME_STEPPING", "DUAL_TIME_STEPPING-1ST_ORDER", "DUAL_TIME_STEPPING-2ND_ORDER"]
tm_labels = ["TS", "Dual-1st Order", "Dual-2nd Order"]

###############################################################################
# End user parameter selection. Begin execution below.
###############################################################################

# brief error checking
if len(commands) != 2 or len(fnames) != len(legends):
  print("Check lengths of input lists for commands, configs, and legends.")
  raise SystemExit

# some extra labels for plotting
symb = ['s','o','d','^','*']
colo = ['blue','green','orange','red', 'yellow']

# set up an array to hold the relative element size
t = zeros(len(ts)*len(fnames))

# print initial statement about number of cases
print("Running " + str(len(ts)*len(fnames)*len(tm)) + " MMS cases.")

result = [] 
# loop over all meshes in the grid study
i_s = 0
for j in range(len(fnames)):
  # set the correct number for iConfig
  iConfig = j
  for k in range(len(tm)):
    for m in range(len(ts)):

      # set the correct number for iTS
      iTS = m
      
      # build the command to change the time step in the .cfg files
      commandGrid = commands[1]+" -f %s -t %s -m %s" % (fnames[iConfig],ts[iTS], tm[k])

      # call the config file generator for the time step
      sp.call(commandGrid,shell=True)

      # build the SU2 command for this particular time step
      commandSU2 = commands[0]+fnames[iConfig]+" > "+filename

      # call SU2 to run the calculation
      sp.call(commandSU2,shell=True)

      # # parse the history file to extract the final computed error

      result.append(pd.read_csv("history.csv"))
      print("Case " + str(i_s+1) + " finished.")
      i_s+=1

# plot the results of all cases
print("\nPlotting the cases.\n")
###############################################################################
# End execution. Plot rms[Rhos] for each time step
###############################################################################
#initialize figures
fig1, ax1 = plt.subplots()
fig2, ax2 = plt.subplots()
fig3, ax3 = plt.subplots()
fig4, ax4 = plt.subplots()

# Plot Rhos vs. Time Step for each method
i_s = 0
for j in range(len(fnames)):
  ax1.cla()
  ax2.cla()
  ax3.cla()
  ax4.cla()
  for k in range(len(tm)):
    for m in range(len(ts)):
      #Plot Rho vs. Time Step size for each method
      if m == 0:
        labels = tm_labels[k] 
        ax1.plot(ts[m], result[i_s].iloc[:, [3]].mean(), marker=symb[k],
                color=colo[k], linewidth=1.5, markersize=9, label=labels)
        ax2.plot(ts[m], result[i_s].iloc[:, [4]].mean(), marker=symb[k],
                 color=colo[k], linewidth=1.5, markersize=9, label=labels)
        ax3.plot(ts[m], result[i_s].iloc[:, [5]].mean(), marker=symb[k],
                 color=colo[k], linewidth=1.5, markersize=9, label=labels)
        ax4.plot(ts[m], result[i_s].iloc[:, [6]].mean(), marker=symb[k],
                 color=colo[k], linewidth=1.5, markersize=9, label=labels)
      else :
        ax1.plot(ts[m], result[i_s].iloc[:, [3]].mean(), marker=symb[k],
                 color=colo[k], linewidth=1.5, markersize=9)
        ax2.plot(ts[m], result[i_s].iloc[:, [4]].mean(), marker=symb[k],
                 color=colo[k], linewidth=1.5, markersize=9)
        ax3.plot(ts[m], result[i_s].iloc[:, [5]].mean(), marker=symb[k],
                 color=colo[k], linewidth=1.5, markersize=9)
        ax4.plot(ts[m], result[i_s].iloc[:, [6]].mean(), marker=symb[k],
                 color=colo[k], linewidth=1.5, markersize=9)

      ax1.set_xlabel("Time Step", fontsize=8)
      ax1.set_ylabel(result[i_s].columns.values[3], fontsize=8)
      ax1.set_xscale("log")
      ax1.tick_params(axis='both', labelsize=8)
      # ax1.set_yscale("log")
      ax1.legend(loc="center left", bbox_to_anchor=(.9, 0.5), prop={'size': 6})
      ax1.set_title(legends[j])
      plt.tight_layout()
      fig1.savefig((result[i_s].columns.values[3][9:12])+"_"+legends[j]+".png")

      ax2.set_xlabel("Time Step", fontsize=8)
      ax2.set_ylabel(result[i_s].columns.values[4], fontsize=8)
      ax2.set_xscale("log")
      ax2.tick_params(axis='both', labelsize=8)
      # ax1.set_yscale("log")
      ax2.legend(loc="center left", bbox_to_anchor=(.9, 0.5), prop={'size': 6})
      ax2.set_title(result[i_s].columns.values[4])
      plt.tight_layout()
      fig2.savefig((result[i_s].columns.values[4][9:13])+"_"+legends[j]+".png")

      ax3.set_xlabel("Time Step", fontsize=8)
      ax3.set_ylabel(result[i_s].columns.values[5], fontsize=8)
      ax3.set_xscale("log")
      ax3.tick_params(axis='both', labelsize=8)
      # ax1.set_yscale("log")
      ax3.legend(loc="center left", bbox_to_anchor=(.9, 0.5), prop={'size': 6})
      ax3.set_title(result[i_s].columns.values[5])
      plt.tight_layout()
      fig3.savefig((result[i_s].columns.values[5][9:13])+"_"+legends[j]+".png")

      ax4.set_xlabel("Time Step", fontsize=8)
      ax4.set_ylabel(result[i_s].columns.values[6], fontsize=8)
      ax4.set_xscale("log")
      ax4.tick_params(axis='both', labelsize=8)
      # ax1.set_yscale("log")
      ax4.legend(loc="center left", bbox_to_anchor=(.9, 0.5), prop={'size': 6})
      ax4.set_title(result[i_s].columns.values[6])
      plt.tight_layout()
      fig4.savefig((result[i_s].columns.values[6][9:13])+"_"+legends[j]+".png")

      i_s+=1

# Plot Rhos vs. Time Step for each method
i_s = 0
ax1.cla()
ax2.cla()
ax3.cla()
ax4.cla()
for j in range(len(fnames)):
  for k in range(len(tm)):
    for m in range(len(ts)):
      #Plot Rho vs. Time Step size for each method
      if m == 0:
        labels = legends[j] + ": "+ tm_labels[k]
        ax1.plot(ts[m], result[i_s].iloc[:, [3]].mean(), marker=symb[k],
                 color=colo[j], linewidth=1.5, markersize=9, label=labels)
        ax2.plot(ts[m], result[i_s].iloc[:, [4]].mean(), marker=symb[k],
                 color=colo[j], linewidth=1.5, markersize=9, label=labels)
        ax3.plot(ts[m], result[i_s].iloc[:, [5]].mean(), marker=symb[k],
                 color=colo[j], linewidth=1.5, markersize=9, label=labels)
        ax4.plot(ts[m], result[i_s].iloc[:, [6]].mean(), marker=symb[k],
                 color=colo[j], linewidth=1.5, markersize=9, label=labels)
      else:
        ax1.plot(ts[m], result[i_s].iloc[:, [3]].mean(), marker=symb[k],
                 color=colo[j], linewidth=1.5, markersize=9)
        ax2.plot(ts[m], result[i_s].iloc[:, [4]].mean(), marker=symb[k],
                 color=colo[j], linewidth=1.5, markersize=9)
        ax3.plot(ts[m], result[i_s].iloc[:, [5]].mean(), marker=symb[k],
                 color=colo[j], linewidth=1.5, markersize=9)
        ax4.plot(ts[m], result[i_s].iloc[:, [6]].mean(), marker=symb[k],
                 color=colo[j], linewidth=1.5, markersize=9)

      ax1.set_xlabel("Time Step", fontsize=8)
      ax1.set_ylabel(result[i_s].columns.values[3], fontsize=8)
      ax1.set_xscale("log")
      ax1.tick_params(axis='both', labelsize=8)
      # ax1.set_yscale("log")
      ax1.legend(loc="center left", bbox_to_anchor=(.9, 0.5), prop={'size': 6})
      ax1.set_title(result[i_s].columns.values[3])
      plt.tight_layout()
      fig1.savefig((result[i_s].columns.values[3][9:12])+".png")

      ax2.set_xlabel("Time Step", fontsize=8)
      ax2.set_ylabel(result[i_s].columns.values[4], fontsize=8)
      ax2.set_xscale("log")
      ax2.tick_params(axis='both', labelsize=8)
      # ax1.set_yscale("log")
      ax2.legend(loc="center left", bbox_to_anchor=(.9, 0.5), prop={'size': 6})
      ax2.set_title(result[i_s].columns.values[4])
      plt.tight_layout()
      fig2.savefig((result[i_s].columns.values[4][9:13])+".png")

      ax3.set_xlabel("Time Step", fontsize=8)
      ax3.set_ylabel(result[i_s].columns.values[5], fontsize=8)
      ax3.set_xscale("log")
      ax3.tick_params(axis='both', labelsize=8)
      # ax1.set_yscale("log")
      ax3.legend(loc="center left", bbox_to_anchor=(.9, 0.5), prop={'size': 6})
      ax3.set_title(result[i_s].columns.values[5])
      plt.tight_layout()
      fig3.savefig((result[i_s].columns.values[5][9:13])+".png")

      ax4.set_xlabel("Time Step", fontsize=8)
      ax4.set_ylabel(result[i_s].columns.values[6], fontsize=8)
      ax4.set_xscale("log")
      ax4.tick_params(axis='both', labelsize=8)
      # ax1.set_yscale("log")
      ax4.legend(loc="center left", bbox_to_anchor=(.9, 0.5), prop={'size': 6})
      ax4.set_title(result[i_s].columns.values[6])
      plt.tight_layout()
      
      i_s+=1

# Plot the time series 
m_ind = arange(0,len(tm)*len(ts)*len(fnames),len(ts))

ax1.cla()
ax2.cla()
ax3.cla()
ax4.cla()
for j in range(len(fnames)):
  for k in range(len(tm)):
    for i in m_ind:
      ax1.plot(result[i].iloc[:, [0]], result[i].iloc[:, [3]], marker=symb[k],
               color=colo[j], linewidth=1.5, markersize=9, label=legends[j] + ": " + tm_labels[k])
      ax2.plot(result[i+1].iloc[:, [0]], result[i+1].iloc[:, [3]], marker=symb[k],
               color=colo[j], linewidth=1.5, markersize=9, label=legends[j] + ": " + tm_labels[k])
      ax3.plot(result[i+2].iloc[:, [0]], result[i+2].iloc[:, [3]], marker=symb[k],
               color=colo[j], linewidth=1.5, markersize=9, label=legends[j] + ": " + tm_labels[k])
      ax4.plot(result[i+3].iloc[:, [0]], result[i+3].iloc[:, [3]], marker=symb[k],
               color=colo[j], linewidth=1.5, markersize=9, label=legends[j] + ": " + tm_labels[k])

      ax1.set_xlabel("Time Iter", fontsize=8)
      ax1.set_ylabel(result[i_s].columns.values[3], fontsize=8)
      ax1.tick_params(axis='both', labelsize=8)
      ax1.legend(loc="center left", bbox_to_anchor=(.9, 0.5), prop={'size': 6})
      ax1.set_title(result[i_s].columns.values[3] + "TS: " + str(ts[0]))
      plt.tight_layout()
      fig1.savefig((result[i_s].columns.values[3][9:12])+"_"+str(ts[0])+"_ts.png")

      ax2.set_xlabel("Time Iter", fontsize=8)
      ax2.set_ylabel(result[i_s].columns.values[3], fontsize=8)
      ax2.tick_params(axis='both', labelsize=8)
      ax2.legend(loc="center left", bbox_to_anchor=(.9, 0.5), prop={'size': 6})
      ax2.set_title(result[i_s].columns.values[3] + "TS: " + str(ts[1]))
      plt.tight_layout()
      fig2.savefig((result[i_s].columns.values[3][9:13]) +
                   "_"+str(ts[1])+"_ts.png")

      ax3.set_xlabel("Time Iter", fontsize=8)
      ax3.set_ylabel(result[i_s].columns.values[3], fontsize=8)
      ax3.tick_params(axis='both', labelsize=8)
      ax3.legend(loc="center left", bbox_to_anchor=(.9, 0.5), prop={'size': 6})
      ax3.set_title(result[i_s].columns.values[3] + "TS: " + str(ts[2]))
      plt.tight_layout()
      fig3.savefig((result[i_s].columns.values[3][9:13]) +
                   "_"+str(ts[2])+"_ts.png")

      ax4.set_xlabel("Time Iter", fontsize=8)
      ax4.set_ylabel(result[i_s].columns.values[3], fontsize=8)
      ax4.tick_params(axis='both', labelsize=8)
      ax4.legend(loc="center left", bbox_to_anchor=(.9, 0.5), prop={'size': 6})
      ax4.set_title(result[i_s].columns.values[3] + "TS: " + str(ts[3]))
      plt.tight_layout()
      fig4.savefig((result[i_s].columns.values[3][9:13]) +
                   "_"+str(ts[3])+"_ts.png")
