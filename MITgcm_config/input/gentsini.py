import numpy as np
import sys

import xarray as xr

import scipy.io as sio
from scipy.interpolate import griddata

from eifex_utils import *
if False:
    # load grid
    ds=xr.open_dataset('grid.nc')
    lonc,latc = np.meshgrid(ds.lon,ds.lat)
    long,latg = lonc,latc
    # get dimensions for convenience
    nx,ny,nz = ds.x.size,ds.y.size,ds.z.size
    zc = ds.depth.values
else:
    # alternatively create grid
    from eifex_utils import create_grid
    g = create_grid()
    lonc,latc = np.meshgrid(g.xc,g.yc)
    long,latg = np.meshgrid(g.xg[:-1],g.yg[:-1])
    zc = g.zc.values
    # get dimensions for convenience
    nx,ny,nz = g.xc.size,g.yc.size,g.zc.size

# define a function that does the actual gridding because we need to
# deal with nans in the output
def do_griddata(xy0,fld,xy):
    uc = griddata(xy0, fld, xy, method='linear', rescale=True)
    # deal with nans in uc by extrapolating the gridded field
    xyn = np.where(~np.isnan(uc))
    un = griddata((xy[0][xyn],xy[1][xyn]), uc[xyn], xy, method = 'nearest')
    return uc #np.where(np.isnan(uc),un,uc)

def do_interp1d(xp,tp,xi):
    it = np.where(tp!=-999)[0]
    ti = np.interp(xi,xp[it],tp[it])
    return ti

# load data from old mat-file
timeline = read_timeline()
data = read_antxxi3('../../CTDall/antxxi3.mat')

# select stations in grid and do vertical interpolation
theta = []
salt  = []
lon = []
lat = []
tloc = []

for k,stat in enumerate(data):
    if timeline['inGrid'][k]==5:
        lon.append(stat['lon'])
        lat.append(stat['lat'])
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

if False:
    # write initial and bc fields
    writefield('Tpy.init',tini)
    writefield('Spy.init',sini)

    writefield('tpybcn',tini[:,-1,:])
    writefield('tpybcs',tini[:,0,:])
    writefield('tpybce',tini[:,:,-1])
    writefield('tpybcw',tini[:,:,0])

    writefield('spybcn',sini[:,-1,:])
    writefield('spybcs',sini[:,0,:])
    writefield('spybce',sini[:,:,-1])
    writefield('spybcw',sini[:,:,0])

if False:
    import matplotlib.pyplot as plt
    k=0
    plt.clf()
    cm = plt.pcolormesh(g.xg,g.yg,(tini[k,:,:]))
    plt.contour(lonc,latc,(tini[k,:,:]),levels=10,colors='k',linewidths=0.5)
    plt.colorbar(cm)
    plt.plot(lon,lat,'kx')
