import os
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.colors as colors

from xmitgcm import open_mdsdataset

import datetime as dt
refdate = dt.datetime(2004,2,8)

bdir='..'
runs = ['run00','run84']
names= ['first guess','iteration 84']
myruns = []
for r in runs:
    myruns.append(os.path.join(bdir,r))

ds = []
for myrun in myruns:
    ds.append(
        open_mdsdataset(myrun,prefix = ['diags3D','diags2D','GGL90diags'],
                        ref_date = refdate)
    )

fig, axs = plt.subplots(2,2,figsize=(9,9),
                        sharex=True,sharey=True) #,layout='constrained')

kz = 2
hm = []
myslice = slice(-10,-1)
for k, ax in enumerate(axs[0,:]):
    theta=ds[k].THETA.isel(time=myslice,Z=kz).mean(dim='time')
    hm.append(ax.pcolormesh(ds[k].XG,ds[k].YG,theta,
                            norm=colors.Normalize(vmin=3.4,vmax=6)))
    ax.set_title(names[k])

for k, ax in enumerate(axs[1,:]):
    salt=ds[k].SALT.isel(time=myslice,Z=kz).mean(dim='time')
    hm.append(ax.pcolormesh(ds[k].XG,ds[k].YG,salt,
                            norm=colors.Normalize(vmin=33.8,vmax=33.93)))


plt.colorbar(hm[0],ax=axs[0,:],orientation='vertical',
             label=r'theta /$ ^\circ$C')
plt.colorbar(hm[2],ax=axs[1,:],orientation='vertical',
             label='salinity')

plt.suptitle('time average over last ten days, at Z = %f m'%(ds[0].Z[kz]))

plt.show()
