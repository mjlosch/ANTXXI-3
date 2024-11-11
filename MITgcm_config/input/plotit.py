import os, sys
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.colors as colors
import cmocean.cm as cmo
import cartopy.crs as ccrs

from xmitgcm import open_mdsdataset

import datetime as dt

def readfield(fname,dims,datatype):
    """Call signatures::

    readfield(filename, dims, numpy.datatype)

    Read unblocked binary data with dimentions "dims".
    """

    try:
        fid = open(fname,"rb")
    except:
        sys.exit( fname+": no such file or directory")

    v   = np.fromfile(fid, datatype)
    fid.close()

    if sys.byteorder == 'little': v.byteswap(True)

    if   len(v) == np.prod(dims):     v = v.reshape(dims)
    elif len(v) == np.prod(dims[1:]): v = v.reshape(dims[1:])
    else:
        errstr = (  "dimensions do not match: \n len(data) = " + str(len(v))
                  + ", but prod(dims) = " + str(np.prod(dims)) )
        raise RuntimeError(errstr)

    return v

refdate = dt.datetime(2004,2,8)

bdir='..'
runs = ['run00','run_opt']
names= ['first guess','iteration 125']
myruns = []
for r in runs:
    myruns.append(os.path.join(bdir,r))

ds = []
for myrun in myruns:
    ds.append(
        open_mdsdataset(myrun,prefix = ['diags3D','diags2D','GGL90diags'],
                        ref_date = refdate)
    )

# load observations/initial conditions
nz,ny,nx=ds[0].maskC.shape
t0 = readfield(os.path.join(bdir,'input/theta.init'),
               [nz,ny,nx],'float64')
s0 = readfield(os.path.join(bdir,'input/salt.init'),
               [nz,ny,nx],'float64')

proj=ccrs.Mercator()
kz = 2
hm = []
myslice = slice(-10,-1)
#myslice = slice(0,10)
k=0
theta_kwargs = {'norm': colors.Normalize(vmin=3.4,vmax=6),
                'cmap': cmo.thermal, 'transform': ccrs.PlateCarree()}

fig, axs = plt.subplots(2,3,figsize=(11,8),
                        sharex=True,sharey=True,
                        layout='constrained',
                        subplot_kw={'projection': proj})

hm.append(axs[0,0].pcolormesh(ds[k].XG,ds[k].YG,t0[kz,:,:],
                              **theta_kwargs))
axs[0,0].set_title('initial conditions')
for k, ax in enumerate(axs[0,1:]):
    theta=ds[k].THETA.isel(time=myslice,Z=kz).mean(dim='time')
    hm.append(ax.pcolormesh(ds[k].XG,ds[k].YG,theta, **theta_kwargs))
    ax.set_title(names[k])

salt_kwargs = {'norm': colors.Normalize(vmin=33.8,vmax=33.93),
               'cmap': cmo.haline, 'transform': ccrs.PlateCarree()}
hm.append(axs[1,0].pcolormesh(ds[k].XG,ds[k].YG,s0[kz,:,:],
                             **salt_kwargs))
for k, ax in enumerate(axs[1,1:]):
    salt=ds[k].SALT.isel(time=myslice,Z=kz).mean(dim='time')
    hm.append(ax.pcolormesh(ds[k].XG,ds[k].YG,salt, **salt_kwargs))


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

plt.suptitle('time average over last ten days, at Z = %f m'%(
    ds[0].Z[kz]))

plt.show()
