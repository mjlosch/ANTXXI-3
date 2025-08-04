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
    # define grid based on the following information:
    # coordinates of the south-west corner of the patch: 1d21m,-50d33m
    # length of one grid: 3.6km
    # lon and lat of the patch center: 2d15m,-49d24m
    # length of one degree longitude at equator: 111.321km
    # length of one degree latitude: 111.0km
    # length of circumference at 49.4N: 111.321*cos(49.4)
    # east-end longitude of the patch: 42*3.6/(111.321*cos(49.4))+1.35
    # north-end latitude of the patch: 54*3.6/111-50.55

    # lonc = [  1.3166,  3.4871]; lonc = (lonc(1):diff(lonc)/(nx-1):lonc(2))';
    # latc = [-50.6027,-48.7902]; latc = (latc(1):diff(latc)/(ny-1):latc(2))';

    # lonb = [1.35,3.445]
    # latb = np.array([-50.55,-48.80])

    # from Grid5 coordinates:
    # lon = np.array([1.3168833333333334, 3.4863])
    # lat = np.array([-50.602516666666666,-48.79633333333334])
    # this works
    lonb = np.array([1.33, 3.45])
    latb = np.array([-50.59,-48.80])
    #
    xc = np.linspace(lonb[0],lonb[1],nx)
    yc = np.linspace(latb[0],latb[1],ny)

    lon_dc = np.diff(lonb)[0]/(nx-1)
    lat_dc = np.diff(latb)[0]/(ny-1)
    xg = np.linspace(lonb[0]-0.5*lon_dc,lonb[1]+0.5*lon_dc,nx+1)
    yg = np.linspace(latb[0]-0.5*lat_dc,latb[1]+0.5*lat_dc,ny+1)

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
