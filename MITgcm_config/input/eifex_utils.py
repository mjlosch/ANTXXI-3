import numpy as np
import sys
from scipy.io import loadmat

def read_timeline(matfile='../../timeline.mat'):

    data = loadmat(matfile,simplify_cells=True)

    return data['timeline']

def read_antxxi3(matfile='../../CTD/antxxi3.mat'):

    data = loadmat(matfile,simplify_cells=True)
    # create and return a list of stations
    stations = []
    for mydata in data['data']:
        stations.append(mydata)

    return stations

def get_eifex_stations():

    stations = read_antxxi3('../../CTDall/antxxi3.mat')
    ik  =[]
    for k,stat in enumerate(stations):
        hr = stat['hours_since_jan01']
        if stat['lon'] < 5 and ~np.isnan(hr):
            ik.append(k)

    return [stations[k] for k in ik]

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

def create_grid(nx=42,ny=54):
    # define grid and return coordinates in an xarray dataset
    # define grid based on the following information from Losch et al (2014):
    # - coordinates of the south-west corner of the patch:
    #   (1d21m,-50d33m) ~ (1.35,-50.55)
    # length of one grid: 3.6km
    # lon and lat of the patch center: 2d15m,-49d24m
    # length of one degree longitude at equator: 111.321km
    # length of one degree latitude:  60 nm = 60*1.852km ~ 111.12 km
    # length of circumference at 49.4N: 111.12*cos(49.4*pi/180)
    # east-end longitude of the patch:
    #        42*3.6/(111.12*cos(49.4*pi/180))+1.35 ~ 3.44
    # north-end latitude of the patch: 54*3.6/111.12-50.55 ~ -48.80

    long = [1.35,3.44]
    latg = [-50.55,-48.80]

    xg = np.linspace(long[0],long[1],nx+1)
    yg = np.linspace(latg[0],latg[1],ny+1)
    xc = 0.5*(xg[:-1]+xg[1:])
    yc = 0.5*(yg[:-1]+yg[1:])

    # data take from Losch et al (2014)
    dz = np.asarray([ 10.0, 10.0, 10.0, 10.0, 10.0, 10.0, 10.0,
                      10.0, 10.0, 10.0, 10.0, 10.0, 10.0, 10.0, 10.0,
                      12.0, 16.5, 21.5, 25.0, 25.0, 25.0, 25.0, 25.0,
                      25.0, 25.0, 25.0, 25.0, 25.0, 25.0, 25.0])
    zg = -np.hstack([0,np.cumsum(dz)])
    zc = 0.5*zg[:-1]+0.5*zg[1:]

    import xarray as xr

    ds = xr.Dataset(
        data_vars=dict( dz=(["zc"], dz),
                       ),
        coords=dict( xc=("xc", xc), yc=("yc", yc),
                     xg=("xg", xg), yg=("yg", yg),
                     zc=("zc", zc), zg=("zg", zg),
                    ),
        attrs=dict(description="Grid coordinates for EIFEX"),
    )

    return ds
