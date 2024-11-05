import numpy as np

from myutils import *

import xarray as xr

nx,ny,nz = 42,54,30

prec='float64'

H = -500.*np.ones((ny,nx))

writefield('flat_bottom.bin',H.astype(prec))

writefield('wt_ones.data',np.ones((nz,ny,nx),dtype=prec))

ds=xr.open_dataset('../../output_tmp/grid.nc')

# data taken from Losch et al 2014,
zc = np.asarray(
    [5.00, 15.00, 25.00, 35.00, 45.00, 55.00, 65.00,  75.00, 85.00, 95.00,
     105.00, 115.00, 125.00, 135.00, 145.00, 156.00, 170.25,
     189.25, 212.50, 237.50, 262.50, 287.50, 312.50, 337.50,
     362.50, 387.50, 412.50, 437.50, 462.50,  487.50])

tmp = np.asarray([0.2834, 0.0396, 10.0,
                  0.2000, 0.0200, 10.0,
                  0.2000, 0.0200, 10.0,
                  0.2000, 0.0200, 10.0,
                  0.2000, 0.0200, 10.0,
                  0.2000, 0.0200, 10.0,
                  0.2000, 0.0200, 10.0,
                  0.2000, 0.0200, 10.0,
                  0.2048, 0.0200, 10.0,
                  0.2000, 0.0200, 10.0,
                  0.2622, 0.0200, 10.0,
                  0.4424, 0.0200, 10.0,
                  0.4786, 0.0200, 10.0,
                  0.4881, 0.0214, 10.0,
                  0.5862, 0.0268, 10.0,
                  0.6418, 0.0340, 10.0,
                  0.6012, 0.0370, 10.0,
                  0.4528, 0.0362, 10.0,
                  0.2000, 0.0258, 10.0,
                  0.2000, 0.0222, 10.0,
                  0.2000, 0.0320, 10.0,
                  0.2084, 0.0478, 10.0,
                  0.3688, 0.0716, 10.0,
                  0.3330, 0.0728, 10.0,
                  0.3320, 0.0702, 10.0,
                  0.2566, 0.0568, 10.0,
                  0.2252, 0.0388, 10.0,
                  0.2234, 0.0372, 10.0,
                  0.2000, 0.0278, 10.0,
                  0.2000, 0.0264, 10.0])

sigt = tmp[::3]
sigs = tmp[1::3]
sigu = tmp[2::3]

# or from Ying's file
zc = -ds.depth.values

zg = [0]
for k in range(len(zc)):
    zg.append(zg[k]+(zc[k]-zg[k])*2)

dz = np.diff(np.asarray(zg))

print(' sigt = ', [sig for sig in sigt])
print(' sigs = ', [sig for sig in sigs])

print(' dxSpacing = %f,'%np.diff(ds.lon).mean())
print(' dySpacing = %f,'%np.diff(ds.lat).mean())

print(' xgOrigin = %f,'%(ds.lon[0].values-0.5*np.diff(ds.lon).mean()))
print(' ygOrigin = %f,'%(ds.lat[0].values-0.5*np.diff(ds.lat).mean()))
print(' delR = ', [dd for dd in dz])

# weights and errors

# for the cost function terms with model-data comparisions we need
# store the uncertainties, (i.e. in units of the corresponding fields)
s = '100., -999.\n'
ascii = s.encode('ascii')

with open('data.err','wb') as f:
    # dummy header
    f.write(ascii)
    for k in range(len(sigt)):
        s = '%f %f %f\n'%(sigt[k],sigs[k],sigu[k]/100.)
        f.write(s.encode('ascii'))

tmpfld = np.ones((nz,ny,nx))
for k in range(len(sigt)):
    tmpfld[k,:,:]=sigt[k] #(1./sigt[k])**2

writefield('sigma_theta.bin',tmpfld.astype(prec))
writefield("weights_theta.bin",1./tmpfld.astype(prec)**2)

tmpfld = np.ones((nz,ny,nx))
for k in range(len(sigt)):
    tmpfld[k,:,:]=sigs[k] #(1./sigs[k])**2

writefield('sigma_salt.bin',tmpfld.astype(prec))
writefield("weights_salt.bin",1./tmpfld.astype(prec)**2)

tmpfld = np.ones((nz,ny,nx))
for k in range(len(sigt)):
    tmpfld[k,:,:]=sigu[k]/100. #(100./sigu[k])**2

writefield('sigma_vel.bin',tmpfld.astype(prec))

writefield('weights_diffkr.bin',np.ones((ny,nx),dtype=prec)/1e-10)

# for the cost function penalty terms for the control variables we
# need store the weighs = 1/uncertainties^2, (i.e. in 1/units^2)

# errors
fnames = ['sflux','hflux','tau']
errs   = [2.e-9, 2.0, 0.02]
for k,fn in enumerate(fnames):
    writefield("weights_%s.bin"%fn,(np.ones((ny,nx))/errs[k]**2).astype(prec))
