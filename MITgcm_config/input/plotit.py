import numpy as np
import matplotlib.pyplot as plt
from myutils import *

from xmitgcm import open_mdsdataset

import datetime as dt
refdate = dt.datetime(2004,2,8)

myrun = '/Users/mlosch/mlosch/ANTXXI-3/MITgcm_config/run'
ds = open_mdsdataset(myrun,prefix = ['diags3D','diags2D','GGL90diags'],
                     ref_date = refdate)
