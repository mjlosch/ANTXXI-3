import numpy as np
import sys
from scipy.io import loadmat

def read_timeline(matfile='../../timeline.mat'):

    data = loadmat(matfile,simplify_cells=True)

    return data['timeline']

def read_antxxi3(matfile='../../CTD/antxxi3.mat'):

    data = loadmat(matfile)
    stations = []
    for mydata in data['data']:
        stations.append(mydata[0])

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
