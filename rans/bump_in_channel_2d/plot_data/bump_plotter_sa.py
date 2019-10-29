#!/usr/bin/env python

## \file bump_plotter.py
#  \brief Python script for post-processing the turbulent 2D bump-in-channel SA solution.
#  \author Thomas D. Economon
#  \version 1.0.

import os, time
from numpy import *
from matplotlib import pyplot as plt
from matplotlib import mlab

# dpi
my_dpi = 100

# Output format for images (png or eps)
imgfrm = 'png'

# Some other constants from the bump case needed for non-dim.
a     = 347.223789508
a2    = a*a
mu    = 1.84592e-05
rho   = 0.797432
u_inf = 69.4448

# Load the residual history files
h4 = mlab.csv2rec("history_0089x041_sa.csv", comments='#', skiprows=0, checkrows=0)
h3 = mlab.csv2rec("history_0177x081_sa.csv", comments='#', skiprows=0, checkrows=0)
h2 = mlab.csv2rec("history_0353x161_sa.csv", comments='#', skiprows=0, checkrows=0)
h1 = mlab.csv2rec("history_0705x321_sa.csv", comments='#', skiprows=0, checkrows=0)
h0 = mlab.csv2rec("history_1409x641_sa.csv", comments='#', skiprows=0, checkrows=0)

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
plt.title(r'Residual Convergence for a Turbulent 2D Bump-in-Channel (SA)', fontsize=12)
plt.legend([r'89x41',r'177x81',r'353x161',r'705x321',r'1409x641'],loc=1,fontsize=16)
for label in plt.gca().get_xticklabels() + plt.gca().get_yticklabels():
  label.set_fontsize(13)
plt.grid('on')
plt.gcf().subplots_adjust(left=0.18)
plt.gcf().subplots_adjust(bottom=0.13)
plt.savefig('bump_residual_convergence_sa.%s'%(imgfrm),format=imgfrm,dpi=my_dpi*4)

# Load the grid convergence data for the integrated quantities
cfl3d = mlab.csv2rec("cfl3d_gridconv_sa.csv", comments='#', skiprows=0, checkrows=0)
fun3d = mlab.csv2rec("fun3d_gridconv_sa.csv", comments='#', skiprows=0, checkrows=0)

# Pull the final drag values from the history files
# We use the same meshes as the NASA cases, so copy the mesh spacing
su2_cl = zeros(5)
su2_cl[4] = h4.cl[-1]
su2_cl[3] = h3.cl[-1]
su2_cl[2] = h2.cl[-1]
su2_cl[1] = h1.cl[-1]
su2_cl[0] = h0.cl[-1]
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

# Plot the lift grid convergence
plt.clf()
plt.figure(figsize=(800/my_dpi, 600/my_dpi), dpi=my_dpi)
plt.plot(cfl3d.h[:],cfl3d.c_l[:],linestyle='-', marker='s', color='green',linewidth = 1.5, markersize=6)
plt.plot(fun3d.h[:],fun3d.c_l[:],linestyle='-.', marker='o', color='red',linewidth = 1.5, markersize=6)
plt.plot(su2_h[:],su2_cl[:],linestyle='--', marker='^', color='blue',linewidth = 1.5, markersize=6)
plt.ylim([0.024,0.0255])
plt.xlim([0.0,0.012])
plt.xlabel(r'$h = \sqrt{1/N}$', fontsize=20)
plt.ylabel(r'$C_l$', fontsize=20)
plt.title(r'Lift Grid Convergence for a Turbulent 2D Bump-in-Channel (SA)', fontsize=12)
plt.legend([r'CFL3D',r'FUN3D',r'SU2'],loc=3,fontsize=16)
for label in plt.gca().get_xticklabels() + plt.gca().get_yticklabels():
  label.set_fontsize(13)
plt.grid('on')
plt.gcf().subplots_adjust(left=0.18)
plt.gcf().subplots_adjust(bottom=0.13)
plt.savefig('bump_cl_gridconv_sa.%s'%(imgfrm),format=imgfrm,dpi=my_dpi*4)

# Plot the drag grid convergence
plt.clf()
plt.figure(figsize=(800/my_dpi, 600/my_dpi), dpi=my_dpi)
plt.plot(cfl3d.h[:],cfl3d.c_d[:],linestyle='-', marker='s', color='green',linewidth = 1.5, markersize=6)
plt.plot(fun3d.h[:],fun3d.c_d[:],linestyle='-.', marker='o', color='red',linewidth = 1.5, markersize=6)
plt.plot(su2_h[:],su2_cd[:],linestyle='--', marker='^', color='blue',linewidth = 1.5, markersize=6)
plt.ylim([0.0034,0.0044])
plt.xlim([0.0,0.012])
plt.xlabel(r'$h = \sqrt{1/N}$', fontsize=20)
plt.ylabel(r'$C_d$', fontsize=20)
plt.title(r'Drag Grid Convergence for a Turbulent 2D Bump-in-Channel (SA)', fontsize=12)
plt.legend([r'CFL3D',r'FUN3D',r'SU2'],loc=2,fontsize=16)
for label in plt.gca().get_xticklabels() + plt.gca().get_yticklabels():
  label.set_fontsize(13)
plt.grid('on')
plt.gcf().subplots_adjust(left=0.18)
plt.gcf().subplots_adjust(bottom=0.13)
plt.savefig('bump_cd_gridconv_sa.%s'%(imgfrm),format=imgfrm,dpi=my_dpi*4)

# Load the surface data for the bump on all grids
cf4_data = mlab.csv2rec("surface_0089x041_sa.csv", comments='#', skiprows=0, checkrows=0)
cf3_data = mlab.csv2rec("surface_0177x081_sa.csv", comments='#', skiprows=0, checkrows=0)
cf2_data = mlab.csv2rec("surface_0353x161_sa.csv", comments='#', skiprows=0, checkrows=0)
cf1_data = mlab.csv2rec("surface_0705x321_sa.csv", comments='#', skiprows=0, checkrows=0)
cf0_data = mlab.csv2rec("surface_1409x641_sa.csv", comments='#', skiprows=0, checkrows=0)

su2_cf = zeros(5)
for point in range(len(cf4_data.x[:])):
  if cf4_data.x[point] > 0.6321974 and  cf4_data.x[point] < 0.6321976:
    cf = sqrt(cf4_data.skin_friction_coefficient_x[point]*cf4_data.skin_friction_coefficient_x[point] + cf4_data.skin_friction_coefficient_y[point]*cf4_data.skin_friction_coefficient_y[point])
    if (cf > 0.0):
      su2_cf[4] = cf

for point in range(len(cf3_data.x[:])):
  if cf3_data.x[point] > 0.6321974 and  cf3_data.x[point] < 0.6321976:
    cf = sqrt(cf3_data.skin_friction_coefficient_x[point]*cf3_data.skin_friction_coefficient_x[point] + cf3_data.skin_friction_coefficient_y[point]*cf3_data.skin_friction_coefficient_y[point])
    if (cf > 0.0):
      su2_cf[3] = cf

for point in range(len(cf2_data.x[:])):
  if cf2_data.x[point] > 0.6321974 and  cf2_data.x[point] < 0.6321976:
    cf = sqrt(cf2_data.skin_friction_coefficient_x[point]*cf2_data.skin_friction_coefficient_x[point] + cf2_data.skin_friction_coefficient_y[point]*cf2_data.skin_friction_coefficient_y[point])
    if (cf > 0.0):
        su2_cf[2] = cf

for point in range(len(cf1_data.x[:])):
  if cf1_data.x[point] > 0.6321974 and  cf1_data.x[point] < 0.6321976:
    cf = sqrt(cf1_data.skin_friction_coefficient_x[point]*cf1_data.skin_friction_coefficient_x[point] + cf1_data.skin_friction_coefficient_y[point]*cf1_data.skin_friction_coefficient_y[point])
    if (cf > 0.0):
      su2_cf[1] = cf

for point in range(len(cf0_data.x[:])):
  if cf0_data.x[point] > 0.6321974 and  cf0_data.x[point] < 0.6321976:
    cf = sqrt(cf0_data.skin_friction_coefficient_x[point]*cf0_data.skin_friction_coefficient_x[point] + cf0_data.skin_friction_coefficient_y[point]*cf0_data.skin_friction_coefficient_y[point])
    if (cf > 0.0):
      su2_cf[0] = cf

# Plot the Cf comparison
plt.clf()
plt.figure(figsize=(800/my_dpi, 600/my_dpi), dpi=my_dpi)
plt.plot(cfl3d.h[:],cfl3d.c_f63[:],linestyle='-', marker='s', color='green',linewidth = 1.5, markersize=6)
plt.plot(fun3d.h[:],fun3d.c_f63[:],linestyle='-.', marker='o', color='red',linewidth = 1.5, markersize=6)
plt.plot(su2_h[:],su2_cf[:],linestyle='--', marker='^', color='blue',linewidth = 1.5, markersize=6)
plt.ylim([0.0049,0.0054])
plt.xlim([0.0,0.012])
plt.xlabel(r'$h = \sqrt{1/N}$', fontsize=20)
plt.ylabel(r'$C_f$ @ $x = 0.6321975$', fontsize=20)
plt.title(r'Skin Friction Grid Convergence for a Turbulent 2D Bump-in-Channel (SA)', fontsize=12)
plt.legend([r'CFL3D',r'FUN3D',r'SU2'],loc=1,fontsize=16)
for label in plt.gca().get_xticklabels() + plt.gca().get_yticklabels():
  label.set_fontsize(13)
plt.grid('on')
plt.gcf().subplots_adjust(left=0.18)
plt.gcf().subplots_adjust(bottom=0.13)
plt.savefig('bump_cf_0p63_gridconv_sa.%s'%(imgfrm),format=imgfrm,dpi=my_dpi*4)

for point in range(len(cf4_data.x[:])):
  if cf4_data.x[point] > 0.74999 and  cf4_data.x[point] < 0.75001:
    cf = sqrt(cf4_data.skin_friction_coefficient_x[point]*cf4_data.skin_friction_coefficient_x[point] + cf4_data.skin_friction_coefficient_y[point]*cf4_data.skin_friction_coefficient_y[point])
    if (cf > 0.0):
      su2_cf[4] = cf

for point in range(len(cf3_data.x[:])):
  if cf3_data.x[point] > 0.74999 and  cf3_data.x[point] < 0.75001:
    cf = sqrt(cf3_data.skin_friction_coefficient_x[point]*cf3_data.skin_friction_coefficient_x[point] + cf3_data.skin_friction_coefficient_y[point]*cf3_data.skin_friction_coefficient_y[point])
    if (cf > 0.0):
      su2_cf[3] = cf

for point in range(len(cf2_data.x[:])):
  if cf2_data.x[point] > 0.74999 and  cf2_data.x[point] < 0.75001:
    cf = sqrt(cf2_data.skin_friction_coefficient_x[point]*cf2_data.skin_friction_coefficient_x[point] + cf2_data.skin_friction_coefficient_y[point]*cf2_data.skin_friction_coefficient_y[point])
    if (cf > 0.0):
        su2_cf[2] = cf

for point in range(len(cf1_data.x[:])):
  if cf1_data.x[point] > 0.74999 and  cf1_data.x[point] < 0.75001:
    cf = sqrt(cf1_data.skin_friction_coefficient_x[point]*cf1_data.skin_friction_coefficient_x[point] + cf1_data.skin_friction_coefficient_y[point]*cf1_data.skin_friction_coefficient_y[point])
    if (cf > 0.0):
      su2_cf[1] = cf

for point in range(len(cf0_data.x[:])):
  if cf0_data.x[point] > 0.74999 and  cf0_data.x[point] < 0.75001:
    cf = sqrt(cf0_data.skin_friction_coefficient_x[point]*cf0_data.skin_friction_coefficient_x[point] + cf0_data.skin_friction_coefficient_y[point]*cf0_data.skin_friction_coefficient_y[point])
    if (cf > 0.0):
      su2_cf[0] = cf

# Plot the Cf comparison
plt.clf()
plt.figure(figsize=(800/my_dpi, 600/my_dpi), dpi=my_dpi)
plt.plot(cfl3d.h[:],cfl3d.c_f75[:],linestyle='-', marker='s', color='green',linewidth = 1.5, markersize=6)
plt.plot(fun3d.h[:],fun3d.c_f75[:],linestyle='-.', marker='o', color='red',linewidth = 1.5, markersize=6)
plt.plot(su2_h[:],su2_cf[:],linestyle='--', marker='^', color='blue',linewidth = 1.5, markersize=6)
plt.ylim([0.0058,0.0064])
plt.xlim([0.0,0.012])
plt.xlabel(r'$h = \sqrt{1/N}$', fontsize=20)
plt.ylabel(r'$C_f$ @ $x = 0.75$', fontsize=20)
plt.title(r'Skin Friction Grid Convergence for a Turbulent 2D Bump-in-Channel (SA)', fontsize=12)
plt.legend([r'CFL3D',r'FUN3D',r'SU2'],loc=1,fontsize=16)
for label in plt.gca().get_xticklabels() + plt.gca().get_yticklabels():
  label.set_fontsize(13)
plt.grid('on')
plt.gcf().subplots_adjust(left=0.18)
plt.gcf().subplots_adjust(bottom=0.13)
plt.savefig('bump_cf_0p75_gridconv_sa.%s'%(imgfrm),format=imgfrm,dpi=my_dpi*4)

for point in range(len(cf4_data.x[:])):
  if cf4_data.x[point] > 0.8678024 and  cf4_data.x[point] < 0.8678026:
    cf = sqrt(cf4_data.skin_friction_coefficient_x[point]*cf4_data.skin_friction_coefficient_x[point] + cf4_data.skin_friction_coefficient_y[point]*cf4_data.skin_friction_coefficient_y[point])
    if (cf > 0.0):
      su2_cf[4] = cf

for point in range(len(cf3_data.x[:])):
  if cf3_data.x[point] > 0.8678024 and  cf3_data.x[point] < 0.8678026:
    cf = sqrt(cf3_data.skin_friction_coefficient_x[point]*cf3_data.skin_friction_coefficient_x[point] + cf3_data.skin_friction_coefficient_y[point]*cf3_data.skin_friction_coefficient_y[point])
    if (cf > 0.0):
      su2_cf[3] = cf

for point in range(len(cf2_data.x[:])):
  if cf2_data.x[point] > 0.8678024 and  cf2_data.x[point] < 0.8678026:
    cf = sqrt(cf2_data.skin_friction_coefficient_x[point]*cf2_data.skin_friction_coefficient_x[point] + cf2_data.skin_friction_coefficient_y[point]*cf2_data.skin_friction_coefficient_y[point])
    if (cf > 0.0):
        su2_cf[2] = cf

for point in range(len(cf1_data.x[:])):
  if cf1_data.x[point] > 0.8678024 and  cf1_data.x[point] < 0.8678026:
    cf = sqrt(cf1_data.skin_friction_coefficient_x[point]*cf1_data.skin_friction_coefficient_x[point] + cf1_data.skin_friction_coefficient_y[point]*cf1_data.skin_friction_coefficient_y[point])
    if (cf > 0.0):
      su2_cf[1] = cf

for point in range(len(cf0_data.x[:])):
  if cf0_data.x[point] > 0.8678024 and  cf0_data.x[point] < 0.8678026:
    cf = sqrt(cf0_data.skin_friction_coefficient_x[point]*cf0_data.skin_friction_coefficient_x[point] + cf0_data.skin_friction_coefficient_y[point]*cf0_data.skin_friction_coefficient_y[point])
    if (cf > 0.0):
      su2_cf[0] = cf

# Plot the Cf comparison
plt.clf()
plt.figure(figsize=(800/my_dpi, 600/my_dpi), dpi=my_dpi)
plt.plot(cfl3d.h[:],cfl3d.c_f87[:],linestyle='-', marker='s', color='green',linewidth = 1.5, markersize=6)
plt.plot(fun3d.h[:],fun3d.c_f87[:],linestyle='-.', marker='o', color='red',linewidth = 1.5, markersize=6)
plt.plot(su2_h[:],su2_cf[:],linestyle='--', marker='^', color='blue',linewidth = 1.5, markersize=6)
plt.ylim([0.0026,0.00315])
plt.xlim([0.0,0.012])
plt.xlabel(r'$h = \sqrt{1/N}$', fontsize=20)
plt.ylabel(r'$C_f$ @ $x = 0.8678025$', fontsize=20)
plt.title(r'Skin Friction Grid Convergence for a Turbulent 2D Bump-in-Channel (SA)', fontsize=12)
plt.legend([r'CFL3D',r'FUN3D',r'SU2'],loc=1,fontsize=16)
for label in plt.gca().get_xticklabels() + plt.gca().get_yticklabels():
  label.set_fontsize(13)
plt.grid('on')
plt.gcf().subplots_adjust(left=0.18)
plt.gcf().subplots_adjust(bottom=0.13)
plt.savefig('bump_cf_0p87_gridconv_sa.%s'%(imgfrm),format=imgfrm,dpi=my_dpi*4)

# Load the skin friction coefficient along the bump for the 1409x641 grid
su2_x    = zeros(len(cf0_data.x[:]))
su2_cf   = zeros(len(cf0_data.x[:]))
cfl3d_cf = mlab.csv2rec("cfl3d_cf_bump_sa.csv", comments='#', skiprows=0, checkrows=0)
fun3d_cf = mlab.csv2rec("fun3d_cf_bump_sa.csv", comments='#', skiprows=0, checkrows=0)

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
plt.ylim([0.00,0.008])
plt.xlim([0.0,1.5])
plt.xlabel(r'$x$', fontsize=20)
plt.ylabel(r'$C_f$', fontsize=20)
plt.title(r'Skin Friction Coefficient on 1409x641 2D Bump-in-Channel Grid (SA)', fontsize=12)
plt.legend([r'CFL3D',r'FUN3D',r'SU2'],loc=1,fontsize=16)
for label in plt.gca().get_xticklabels() + plt.gca().get_yticklabels():
  label.set_fontsize(13)
plt.grid('on')
plt.gcf().subplots_adjust(left=0.18)
plt.gcf().subplots_adjust(bottom=0.13)
plt.savefig('bump_cf_profile_sa.%s'%(imgfrm),format=imgfrm,dpi=my_dpi*4)

# Load the pressure coefficient along the bump for the 1409x641 grid
su2_x    = zeros(len(cf0_data.x[:]))
su2_cp   = zeros(len(cf0_data.x[:]))
cfl3d_cp = mlab.csv2rec("cfl3d_cp_bump_sa.csv", comments='#', skiprows=0, checkrows=0)
fun3d_cp = mlab.csv2rec("fun3d_cp_bump_sa.csv", comments='#', skiprows=0, checkrows=0)

for point in range(len(cf0_data.x[:])):
  su2_cp[point] = cf0_data.pressure_coefficient[point]
  su2_x[point]  = cf0_data.x[point]

# Plot the Cp comparison
plt.clf()
plt.figure(figsize=(800/my_dpi, 600/my_dpi), dpi=my_dpi)
plt.plot(cfl3d_cp.x[:],cfl3d_cp.cp[:],linestyle='-', marker='', color='green',linewidth = 1.5, markersize=6)
plt.plot(fun3d_cp.x[:],fun3d_cp.cp[:],linestyle='-.', marker='', color='red',linewidth = 1.5, markersize=6)
plt.plot(su2_x[:],su2_cp[:],linestyle='--', marker='', color='blue',linewidth = 1.5, markersize=6)
plt.ylim([-0.8,0.4])
plt.xlim([0.0,1.5])
plt.gca().invert_yaxis()
plt.xlabel(r'$x$', fontsize=20)
plt.ylabel(r'$C_p$', fontsize=20)
plt.title(r'Pressure Coefficient on 1409x641 2D Bump-in-Channel Grid (SA)', fontsize=12)
plt.legend([r'CFL3D',r'FUN3D',r'SU2'],loc=1,fontsize=16)
for label in plt.gca().get_xticklabels() + plt.gca().get_yticklabels():
  label.set_fontsize(13)
plt.grid('on')
plt.gcf().subplots_adjust(left=0.18)
plt.gcf().subplots_adjust(bottom=0.13)
plt.savefig('bump_cp_profile_sa.%s'%(imgfrm),format=imgfrm,dpi=my_dpi*4)

# Load various quantities for comparing slices at x = 0.75 on the 1409x641 grid.
cf0_data = mlab.csv2rec("profile_1409x641_sa.csv", comments='#', skiprows=0, checkrows=0)
cfl3d_mu = mlab.csv2rec("cfl3d_eddy_visc_sa.csv", comments='#', skiprows=0, checkrows=0)
fun3d_mu = mlab.csv2rec("fun3d_eddy_visc_sa.csv", comments='#', skiprows=0, checkrows=0)
cfl3d_v  = mlab.csv2rec("cfl3d_velocity_sa.csv", comments='#', skiprows=0, checkrows=0)

# Plot the eddy viscosity comparison
plt.clf()
plt.figure(figsize=(800/my_dpi, 600/my_dpi), dpi=my_dpi)
plt.plot(cfl3d_mu.mut[:],cfl3d_mu.y[:],linestyle='-', marker='', color='green',linewidth = 1.5, markersize=6)
plt.plot(fun3d_mu.mut[:],fun3d_mu.y[:],linestyle='-.', marker='', color='red',linewidth = 1.5, markersize=6)
plt.plot(cf0_data.m[:]/mu,cf0_data.y[:],linestyle='--', marker='', color='blue',linewidth = 1.5, markersize=6)
plt.ylim([0.05,0.065])
plt.xlim([0.0,100.0])
plt.xlabel(r'$\mu_t / \mu_{\infty}$ @ $x = 0.75$', fontsize=20)
plt.ylabel(r'$y$', fontsize=20)
plt.title(r'Non-dim. Eddy Viscosity on 1409x641 2D Bump-in-Channel Grid (SA)', fontsize=12)
plt.legend([r'CFL3D',r'FUN3D',r'SU2'],loc=1,fontsize=16)
for label in plt.gca().get_xticklabels() + plt.gca().get_yticklabels():
  label.set_fontsize(13)
plt.grid('on')
plt.gcf().subplots_adjust(left=0.18)
plt.gcf().subplots_adjust(bottom=0.13)
plt.savefig('bump_eddy_profile_sa.%s'%(imgfrm),format=imgfrm,dpi=my_dpi*4)

# Plot the velocity profile
plt.clf()
plt.figure(figsize=(800/my_dpi, 600/my_dpi), dpi=my_dpi)
plt.plot(cfl3d_v.u[:],cfl3d_v.y_y0[:],linestyle='-', marker='', color='green',linewidth = 1.5, markersize=6)
plt.plot(cf0_data.v[:]/u_inf,cf0_data.y[:]-0.05,linestyle='--', marker='', color='blue',linewidth = 1.5, markersize=6)
plt.ylim([0.0,0.04])
plt.xlim([0.0,1.4])
plt.xlabel(r'$u / u_{\infty}$ @ $x = 0.75$', fontsize=20)
plt.ylabel(r'$y - 0.05$', fontsize=20)
plt.title(r'Non-dim. Velocity on 1409x641 2D Bump-in-Channel Grid (SA)', fontsize=12)
plt.legend([r'CFL3D',r'SU2'],loc=2,fontsize=16)
for label in plt.gca().get_xticklabels() + plt.gca().get_yticklabels():
  label.set_fontsize(13)
plt.grid('on')
plt.gcf().subplots_adjust(left=0.18)
plt.gcf().subplots_adjust(bottom=0.13)
plt.savefig('bump_vel_profile_sa.%s'%(imgfrm),format=imgfrm,dpi=my_dpi*4)

