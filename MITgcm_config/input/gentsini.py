import numpy as np
import sys

import xarray as xr

import scipy.io as sio
from scipy.interpolate import griddata

from eifex_utils import *
# load grid
ds=xr.open_dataset('grid.nc')

lonc,latc = np.meshgrid(ds.lon,ds.lat)
zc = ds.depth.values

# get dimensions for convenience
nx,ny,nz = ds.x.size,ds.y.size,ds.z.size

g = create_grid()
# lonc,latc = np.meshgrid(g.xc,g.yc)
# zc = g.zc.values
# # get dimensions for convenience
# nx,ny,nz = g.xc.size,g.yc.size,g.zc.size

# define a function that does the actual gridding because we need to
# deal with nans in the output
def do_griddata(xy0,fld,xy):
    uc = griddata(xy0, fld, xy, method='cubic', rescale=True)
    # deal with nans in uc by extrapolating the gridded field
    xyn = np.where(~np.isnan(uc))
    un = griddata((xy[0][xyn],xy[1][xyn]), uc[xyn], xy, method = 'nearest')
    return np.where(np.isnan(uc),un,uc)

def do_interp1d(xp,tp,xi):
    it = np.where(tp!=-999)[0]
    ti = np.interp(xi,xp[it],tp[it])
    return ti

# load data from old mat-file
timeline = read_timeline()
data = read_antxxi3('../../CTDall/antxxi3.mat')

# select stations in grid and do vertical interpolation
theta = [] #np.nan*np.ones((nz,len(data)))
salt  = [] # np.copy(theta)
lon = []
lat = []
tloc = []

for k,stat in enumerate(data):
    if timeline['inGrid'][k]==5:
        lon.append(stat['lon'])
        lat.append(stat['lat'])
        # tmp = stat['time']
        # if tmp[1]==1:
        #     ndays = 0
        # elif tmp[1] == 2:
        #     ndays = 31
        # elif tmp[2] == 3:
        #     ndays = 31+29
        # else:
        #     error('unknown month')

        # tloc.append(tmp[0]+ndays+(tmp[3]+tmp[4]/60)/24)
        prestmp = stat['pres'].astype('>f8')
        [pt,itu] = np.unique(prestmp,return_index=True)
        theta.append(do_interp1d(pt,stat['theta'][itu],-zc))
        salt.append(do_interp1d(pt,stat['salt'][itu],-zc))

theta = np.asarray(theta).T
salt  = np.asarray(salt).T

# horizontal interpolation
xy = (lonc,latc)
tini = np.zeros((nz,ny,nx))
sini = np.zeros((nz,ny,nx))
for k in range(nz):
    tini[k,:,:] = do_griddata((lon,lat),theta[k,:].ravel(),xy)
    sini[k,:,:] = do_griddata((lon,lat),salt[k,:].ravel(),xy)
