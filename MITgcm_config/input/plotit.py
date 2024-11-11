import os, sys
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.colors as colors
import cmocean.cm as cmo

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

fig, axs = plt.subplots(2,3,figsize=(12,8),
                        sharex=True,sharey=True,layout='constrained')

kz = 2
hm = []
myslice = slice(-10,-1)
#myslice = slice(0,10)
k=0
theta_kwargs = {'norm': colors.Normalize(vmin=3.4,vmax=6),
                'cmap': cmo.thermal}
hm.append(axs[0,0].pcolormesh(ds[k].XG,ds[k].YG,t0[kz,:,:],
                              **theta_kwargs))
axs[0,0].set_title('initial conditions')
for k, ax in enumerate(axs[0,1:]):
    theta=ds[k].THETA.isel(time=myslice,Z=kz).mean(dim='time')
    hm.append(ax.pcolormesh(ds[k].XG,ds[k].YG,theta, **theta_kwargs))
    ax.set_title(names[k])

salt_kwargs = {'norm': colors.Normalize(vmin=33.8,vmax=33.93),
               'cmap': cmo.haline}
hm.append(axs[1,0].pcolormesh(ds[k].XG,ds[k].YG,s0[kz,:,:],
                             **salt_kwargs))
axs[1,0].set_title('initial conditions')
for k, ax in enumerate(axs[1,1:]):
    salt=ds[k].SALT.isel(time=myslice,Z=kz).mean(dim='time')
    hm.append(ax.pcolormesh(ds[k].XG,ds[k].YG,salt, **salt_kwargs))

plt.colorbar(hm[0],ax=axs[0,:],orientation='vertical',
             label=r'theta / $^\circ$C')
plt.colorbar(hm[2],ax=axs[1,:],orientation='vertical',
             label='salinity')

plt.suptitle('time average over last ten days, at Z = %f m'%(ds[0].Z[kz]))

plt.show()
