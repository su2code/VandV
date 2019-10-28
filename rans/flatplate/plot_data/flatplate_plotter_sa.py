#!/usr/bin/env python

# \file flatplate_plotter_sa.py
#  \brief Python script for post-processing the turbulent 2D flat plate (SA) solution.
#  \author Thomas D. Economon
#  \version 1.0.

import os, time
from numpy import *
from matplotlib import pyplot as plt
from matplotlib import mlab

# dpi
my_dpi = 100

# output format for images (png or eps)
imgfrm = 'png'

# Load the residual history files
h4 = mlab.csv2rec("history_035x025_sa.csv", comments='#', skiprows=0, checkrows=0)
h3 = mlab.csv2rec("history_069x049_sa.csv", comments='#', skiprows=0, checkrows=0)
h2 = mlab.csv2rec("history_137x097_sa.csv", comments='#', skiprows=0, checkrows=0)
h1 = mlab.csv2rec("history_273x193_sa.csv", comments='#', skiprows=0, checkrows=0)
h0 = mlab.csv2rec("history_545x385_sa.csv", comments='#', skiprows=0, checkrows=0)

# Plot the residual histories
plt.clf()
plt.figure(figsize=(800/my_dpi, 600/my_dpi), dpi=my_dpi)
plt.plot(h4.inner_iter[:],h4.rmsrho[:],linestyle='-',  marker='', color='green',  linewidth = 2.0, markersize=6)
plt.plot(h3.inner_iter[:],h3.rmsrho[:],linestyle='-.', marker='', color='red',    linewidth = 2.0, markersize=6)
plt.plot(h2.inner_iter[:],h2.rmsrho[:],linestyle='--', marker='', color='blue',   linewidth = 2.0, markersize=6)
plt.plot(h1.inner_iter[:],h1.rmsrho[:],linestyle='-',  marker='', color='orange', linewidth = 2.0, markersize=6)
plt.plot(h0.inner_iter[:],h0.rmsrho[:],linestyle='-.', marker='', color='black',  linewidth = 2.0, markersize=6)
plt.xlabel(r'Iteration', fontsize=20)
plt.ylabel(r'$log_{10}(R_{\rho})$', fontsize=20)
plt.title(r'Residual Convergence for a Turbulent Flat Plate (SA)', fontsize=12)
plt.legend([r'35x25',r'69x49',r'137x97',r'273x193',r'545x385'],loc=1,fontsize=16)
for label in plt.gca().get_xticklabels() + plt.gca().get_yticklabels():
  label.set_fontsize(13)
plt.grid('on')
plt.gcf().subplots_adjust(left=0.18)
plt.gcf().subplots_adjust(bottom=0.13)
plt.savefig('flatplate_residual_convergence_sa.%s'%(imgfrm),format=imgfrm,dpi=my_dpi*4)

# Load the grid convergence data for the integrated quantities
cfl3d = mlab.csv2rec("cfl3d_gridconv_sa.csv", comments='#', skiprows=0, checkrows=0)
fun3d = mlab.csv2rec("fun3d_gridconv_sa.csv", comments='#', skiprows=0, checkrows=0)

# Pull the final drag values from the history files
# We use the same meshes as the NASA cases, so copy the mesh spacing
su2_cd = zeros(5)
su2_cd[4] = h4.cd[-1]
su2_cd[3] = h3.cd[-1]
su2_cd[2] = h2.cd[-1]
su2_cd[1] = h1.cd[-1]
su2_cd[0] = h0.cd[-1]
su2_h = zeros(5)
su2_h[4] = fun3d.h[4]
su2_h[3] = fun3d.h[3]
su2_h[2] = fun3d.h[2]
su2_h[1] = fun3d.h[1]
su2_h[0] = fun3d.h[0]

# Plot the drag grid convergence
plt.clf()
plt.figure(figsize=(800/my_dpi, 600/my_dpi), dpi=my_dpi)
plt.plot(cfl3d.h[:],cfl3d.c_d[:],linestyle='-', marker='s', color='green',linewidth = 1.5, markersize=6)
plt.plot(fun3d.h[:],fun3d.c_d[:],linestyle='-.', marker='o', color='red',linewidth = 1.5, markersize=6)
plt.plot(su2_h[:],su2_cd[:],linestyle='--', marker='^', color='blue',linewidth = 1.5, markersize=6)
plt.ylim([0.0028,0.0029])
plt.xlim([0.0,0.03])
plt.xlabel(r'$h = \sqrt{1/N}$', fontsize=20)
plt.ylabel(r'$C_d$', fontsize=20)
plt.title(r'Drag Grid Convergence Comparison for a Turbulent Flat Plate (SA)', fontsize=12)
plt.legend([r'CFL3D',r'FUN3D',r'SU2'],loc=3,fontsize=16)
for label in plt.gca().get_xticklabels() + plt.gca().get_yticklabels():
  label.set_fontsize(13)
plt.grid('on')
plt.gcf().subplots_adjust(left=0.18)
plt.gcf().subplots_adjust(bottom=0.13)
plt.savefig('flatplate_cd_gridconv_sa.%s'%(imgfrm),format=imgfrm,dpi=my_dpi*4)

# Load the skin friction coefficient for plate location x = 0.97
su2_cf = zeros(5)
cf4_data = mlab.csv2rec("surface_035x025_sa.csv", comments='#', skiprows=0, checkrows=0)
cf3_data = mlab.csv2rec("surface_069x049_sa.csv", comments='#', skiprows=0, checkrows=0)
cf2_data = mlab.csv2rec("surface_137x097_sa.csv", comments='#', skiprows=0, checkrows=0)
cf1_data = mlab.csv2rec("surface_273x193_sa.csv", comments='#', skiprows=0, checkrows=0)
cf0_data = mlab.csv2rec("surface_545x385_sa.csv", comments='#', skiprows=0, checkrows=0)

for point in range(len(cf4_data.x[:])):
  if cf4_data.x[point] > 0.97 and  cf4_data.x[point] < 0.9701:
    cf = sqrt(cf4_data.skin_friction_coefficient_x[point]*cf4_data.skin_friction_coefficient_x[point] + cf4_data.skin_friction_coefficient_y[point]*cf4_data.skin_friction_coefficient_y[point])
    if (cf > 0.0):
      su2_cf[4] = cf

for point in range(len(cf3_data.x[:])):
  if cf3_data.x[point] > 0.97 and  cf3_data.x[point] < 0.9701:
    cf = sqrt(cf3_data.skin_friction_coefficient_x[point]*cf3_data.skin_friction_coefficient_x[point] + cf3_data.skin_friction_coefficient_y[point]*cf3_data.skin_friction_coefficient_y[point])
    if (cf > 0.0):
      su2_cf[3] = cf

for point in range(len(cf2_data.x[:])):
  if cf2_data.x[point] > 0.97 and  cf2_data.x[point] < 0.9701:
    cf = sqrt(cf2_data.skin_friction_coefficient_x[point]*cf2_data.skin_friction_coefficient_x[point] + cf2_data.skin_friction_coefficient_y[point]*cf2_data.skin_friction_coefficient_y[point])
    if (cf > 0.0):
      su2_cf[2] = cf

for point in range(len(cf1_data.x[:])):
  if cf1_data.x[point] > 0.97 and  cf1_data.x[point] < 0.9701:
    cf = sqrt(cf1_data.skin_friction_coefficient_x[point]*cf1_data.skin_friction_coefficient_x[point] + cf1_data.skin_friction_coefficient_y[point]*cf1_data.skin_friction_coefficient_y[point])
    if (cf > 0.0):
      su2_cf[1] = cf

for point in range(len(cf0_data.x[:])):
  if cf0_data.x[point] > 0.97 and  cf0_data.x[point] < 0.9701:
    cf = sqrt(cf0_data.skin_friction_coefficient_x[point]*cf0_data.skin_friction_coefficient_x[point] + cf0_data.skin_friction_coefficient_y[point]*cf0_data.skin_friction_coefficient_y[point])
    if (cf > 0.0):
      su2_cf[0] = cf

# Plot the Cf comparison
plt.clf()
plt.figure(figsize=(800/my_dpi, 600/my_dpi), dpi=my_dpi)
plt.plot(cfl3d.h[:],cfl3d.c_f97[:],linestyle='-', marker='s', color='green',linewidth = 1.5, markersize=6)
plt.plot(fun3d.h[:],fun3d.c_f97[:],linestyle='-.', marker='o', color='red',linewidth = 1.5, markersize=6)
plt.plot(su2_h[:],su2_cf[:],linestyle='--', marker='^', color='blue',linewidth = 1.5, markersize=6)
plt.ylim([0.00268,0.00278])
plt.xlim([0.0,0.03])
plt.xlabel(r'$h = \sqrt{1/N}$', fontsize=20)
plt.ylabel(r'$C_f$ @ $x = 0.97$', fontsize=20)
plt.title(r'Skin Friction Grid Convergence Comparison for a Turbulent Flat Plate (SA)', fontsize=12)
plt.legend([r'CFL3D',r'FUN3D',r'SU2'],loc=2,fontsize=16)
for label in plt.gca().get_xticklabels() + plt.gca().get_yticklabels():
  label.set_fontsize(13)
plt.grid('on')
plt.gcf().subplots_adjust(left=0.18)
plt.gcf().subplots_adjust(bottom=0.13)
plt.savefig('flatplate_cf_0p97_gridconv_sa.%s'%(imgfrm),format=imgfrm,dpi=my_dpi*4)


# Load the skin friction coefficient along the plate for the 545x385 grid
su2_x    = zeros(len(cf0_data.x[:]))
su2_cf   = zeros(len(cf0_data.x[:]))
cfl3d_cf = mlab.csv2rec("cfl3d_cf_545x385_sa.csv", comments='#', skiprows=0, checkrows=0)
fun3d_cf = mlab.csv2rec("fun3d_cf_545x385_sa.csv", comments='#', skiprows=0, checkrows=0)

for point in range(len(cf0_data.x[:])):
  cf = sqrt(cf0_data.skin_friction_coefficient_x[point]*cf0_data.skin_friction_coefficient_x[point] + cf0_data.skin_friction_coefficient_y[point]*cf0_data.skin_friction_coefficient_y[point])
  su2_cf[point] = cf
  su2_x[point]  = cf0_data.x[point]

# Plot the Cf comparison
plt.clf()
plt.figure(figsize=(800/my_dpi, 600/my_dpi), dpi=my_dpi)
plt.plot(cfl3d_cf.x[:],cfl3d_cf.cf[:],linestyle='-', marker='', color='green',linewidth = 1.5, markersize=6)
plt.plot(fun3d_cf.x[:],fun3d_cf.cf[:],linestyle='-.', marker='', color='red',linewidth = 1.5, markersize=6)
plt.plot(su2_x[:],su2_cf[:],linestyle='--', marker='', color='blue',linewidth = 1.5, markersize=6)
plt.ylim([0.002,0.006])
plt.xlim([0.0,2.0])
plt.xlabel(r'$x$', fontsize=20)
plt.ylabel(r'$C_f$', fontsize=20)
plt.title(r'Skin Friction Coefficient on 545x385 Flat Plate Grid (SA)', fontsize=12)
plt.legend([r'CFL3D',r'FUN3D',r'SU2'],loc=1,fontsize=16)
for label in plt.gca().get_xticklabels() + plt.gca().get_yticklabels():
  label.set_fontsize(13)
plt.grid('on')
plt.gcf().subplots_adjust(left=0.18)
plt.gcf().subplots_adjust(bottom=0.13)
plt.savefig('flatplate_cf_profile_sa.%s'%(imgfrm),format=imgfrm,dpi=my_dpi*4)

