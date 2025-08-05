import numpy as np
import sys

import xarray as xr

import scipy.io as sio
from scipy.interpolate import griddata

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

# we know that there are 5 stream function layers
zstrf = - np.asarray([ 25., 75., 125., 175., 225.])
n = len(zstrf)
for k in range(n):
    fname = '../../ADCP/eddy2_strf_layer%i.mat'%(k+1)
    a = sio.loadmat(fname)
    alon = a['alon']
    alat = a['alat']
    if k == 0:
        ustrf = np.zeros((n,alat.shape[0],alat.shape[1]))
        vstrf = np.zeros((n,alat.shape[0],alat.shape[1]))

    ustrf[k,:,:] = a['u']
    vstrf[k,:,:] = a['v']

x = alon.ravel()
y = alat.ravel()
xy = (x,y)

# horizontal interpolation
xyu = (long,latc)
xyv = (lonc,latg)

# define a function that does the actual gridding because we need to
# deal with nans in the output
def do_griddata(xy0,fld,xy):
    uc = griddata(xy0, fld, xy, method='cubic', rescale=True)
    # deal with nans in uc by extrapolating the gridded field
    xyn = np.where(~np.isnan(uc))
    un = griddata((xy[0][xyn],xy[1][xyn]), uc[xyn], xy, method = 'nearest')
    return np.where(np.isnan(uc),un,uc)

u0 = np.zeros((n,ny,nx))
v0 = np.zeros((n,ny,nx))
for k in range(n):
    u0[k,:,:] = do_griddata(xy,ustrf[k,:,:].ravel(),xyu)
    v0[k,:,:] = do_griddata(xy,vstrf[k,:,:].ravel(),xyv)

# vertical interpolation
uini = np.zeros((nz,ny,nx))
vini = np.zeros((nz,ny,nx))
for i in range(nx):
    for j in range(ny):
        uini[:,j,i] = np.interp(-zc, -zstrf, u0[:,j,i])
        vini[:,j,i] = np.interp(-zc, -zstrf, v0[:,j,i])

def writefield(fname,data):
    """Call signatures::

    writefield(filename, numpy.ndarray)

    Write unblocked binary data with big endian byte ordering.
    """

    fid = open(fname,"wb")

    if sys.byteorder == 'little':
        data.byteswap(False).tofile(fid)
    else:
        data.tofile(fid)

    fid.close()


if False:
    writefield('Upy.init',uini)
    writefield('Vpy.init',vini)

    writefield('upybcn',uini[:,-1,:])
    writefield('upybcs',uini[:,0,:])
    writefield('upybce',uini[:,:,-1])
    writefield('upybcw',uini[:,:,0])

    writefield('vpybcn',vini[:,-1,:])
    writefield('vpybcs',vini[:,0,:])
    writefield('vpybce',vini[:,:,-1])
    writefield('vpybcw',vini[:,:,0])


if False:
    import matplotlib.pyplot as plt
    k=0
    fld2d=uini[k,:,:]
    plt.clf()
    cm = plt.pcolormesh(g.xg,g.yg,fld2d)
    plt.contour(g.xc,g.yc,fld2d,levels=10,colors='k',linewidths=0.5)
    plt.colorbar(cm)
    plt.plot(x,y,'kx')
