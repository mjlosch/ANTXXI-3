import os, sys
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.colors as colors
import cmocean.cm as cmo
import cartopy.crs as ccrs

from xmitgcm import open_mdsdataset

import datetime as dt

from eifex_utils import *

refdate = dt.datetime(2001,1,1)
startdate = dt.datetime(2004,2,8)
delta_t = 300.
ndays=39

# stations = read_antxxi3('../../CTDall/antxxi3.mat')
# lons=[]
# lats=[]
# dats=[]
# ik  =[]
# for k,stat in enumerate(stations):
#     hr = stat['hours_since_jan01']
#     if stat['lon'] < 5 and ~np.isnan(hr):
#         ik.append(k)
#         dats.append(refdate + dt.timedelta(hours=hr))
#         lons.append(stat['lon'])
#         lats.append(stat['lat'])
# eifex_stations = [stations[k] for k in ik]

# eifex_stations = get_eifex_stations()
# mydate = []
# for stat in eifex_stations:
#     hr = stat['hours_since_jan01']
#     mydate.append( refdate + dt.timedelta(hours=int(hr)) )

# tl = read_timeline()
# mydate = []
# for hr in tl['hours_since_jan01']:
#     mydate.append( refdate + dt.timedelta(hours=int(hr)) )

bdir='..'
runs = ['run00','run_opt']
myruns = []
for r in runs:
    myruns.append(os.path.join(bdir,r))

with open(os.path.join(myruns[-1],'data.optim')) as fn:
    for line in fn:
        if 'optimcycle' in line:
            it=line.split('=')[-1].replace(',\n','')

names= ['first guess','iteration %s'%it]

ds = []
for myrun in myruns:
    ds.append(
        open_mdsdataset(myrun,prefix = ['diags3D','diags2D','GGL90diags'],
                        delta_t = delta_t, ref_date = startdate)
    )

# load observations/initial conditions
nz,ny,nx=ds[0].maskC.shape
t0 = readfield(os.path.join(bdir,'input/theta.init'),
               [nz,ny,nx],'float64')
s0 = readfield(os.path.join(bdir,'input/salt.init'),
               [nz,ny,nx],'float64')

# projection
proj=ccrs.Mercator()
kz = 2

myslice = slice(-10,-1)
#myslice = slice(0,10)
k=0
fig, axs = plt.subplots(2,3,figsize=(11,8),
                        sharex=True,sharey=True,
                        layout='constrained',
                        subplot_kw={'projection': proj})

hm = []

theta_kwargs = {'norm': colors.Normalize(vmin=3.4,vmax=6),
                'cmap': cmo.thermal, 'transform': ccrs.PlateCarree()}
hm.append(axs[0,0].pcolormesh(ds[k].XG,ds[k].YG,t0[kz,:,:], **theta_kwargs))
axs[0,0].set_title('initial conditions')
for k, ax in enumerate(axs[0,1:]):
    theta = ds[k].THETA.isel(time=myslice,Z=kz).mean(dim='time')
    hm.append(ax.pcolormesh(ds[k].XG,ds[k].YG,theta, **theta_kwargs))
    ax.set_title(names[k])

salt_kwargs = {'norm': colors.Normalize(vmin=33.8,vmax=33.93),
               'cmap': cmo.haline, 'transform': ccrs.PlateCarree()}
hm.append(axs[1,0].pcolormesh(ds[k].XG,ds[k].YG,s0[kz,:,:], **salt_kwargs))
for k, ax in enumerate(axs[1,1:]):
    salt = ds[k].SALT.isel(time=myslice,Z=kz).mean(dim='time')
    hm.append(ax.pcolormesh(ds[k].XG,ds[k].YG,salt, **salt_kwargs))

# add nice axes labels
from cartopy.mpl.ticker import LongitudeFormatter, LatitudeFormatter
lon_formatter = LongitudeFormatter(dms=True,auto_hide=True)
lat_formatter = LatitudeFormatter(dms=True,auto_hide=True)
for ax in axs[:,0]:
    ax.set_yticks([-50,-49],crs=ccrs.PlateCarree())
    ax.set_yticks(np.linspace(-51,-48,10)[2:-3],minor=True,
                  crs=ccrs.PlateCarree())
    ax.yaxis.set_major_formatter(lat_formatter)
    ax.yaxis.set_minor_formatter(lat_formatter)

for ax in axs[1,:]:
    ax.set_xticks([2,3],crs=ccrs.PlateCarree())
    ax.set_xticks(np.linspace(1,4,10)[2:-2],minor=True,
                  crs=ccrs.PlateCarree())
    ax.xaxis.set_major_formatter(lon_formatter)
    ax.xaxis.set_minor_formatter(lon_formatter)

for ax in axs.ravel():
    gl = ax.gridlines(draw_labels=False,
                      xlocs = [2,3],
                      ylocs = [-50,-49],
                      crs=ccrs.PlateCarree()) #linetype = '--')

plt.colorbar(hm[0],ax=axs[0,:],orientation='vertical',
             label=r'theta / $^\circ$C',extend='both')
plt.colorbar(hm[3],ax=axs[1,:],orientation='vertical',
             label='salinity',extend='both')

if myslice.start<0:
    ststr = "time averages over last days %i to %i, at Z = %5.1f m"%(
        ndays+myslice.start+1, ndays+myslice.stop+1, ds[0].Z[kz])
else:
    ststr = "time averages over days %i to %i, at Z = %5.1f m"%(
        myslice.start+1, myslice.stop, ds[0].Z[kz])
plt.suptitle(ststr)

plt.show()
