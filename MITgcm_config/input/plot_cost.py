#!/usr/bin/env python
# -*- coding: iso-8859-15 -*-
######################## -*- coding: utf-8 -*-
"""Usage: plot_cost.py INPUTFILE(S)

plot cost function contributions from INPUTFILE(S), assuming that they
are costfunction????
"""

import sys
import numpy as np
import matplotlib.pyplot as plt
from getopt import gnu_getopt as getopt
from glob import glob

# try:
#     optlist,args = getopt(sys.argv[1:], ':', ['verbose'])
#     assert len(args) > 0
# except (AssertionError):
#     sys.exit(__doc__)

# cf_files = args

cf_files = glob("costfunction*")
# in place sorting
cf_files.sort()

cfnames=['fc','f_theta','f_salt','f_uvel','f_vvel',
         'f_obcsn','f_obcss','f_obcsw','f_obcse',
         'f_xx_sflux','f_xx_hflux','f_xx_tauu','f_xx_tauv',
         'f_xx_theta','f_xx_salt']

for cfnam in cfnames:
    exec("%s=[]"%cfnam)

cmdstr = "append(float(lineparts[-2].replace('D','e')))"
for file in cf_files:
    with open(file,encoding='utf8') as file_object:
        data = [line.strip('\n') for line in file_object.readlines()]
        print(file)
        for line in data:
            lineparts = line.split()
            for cfnam in cfnames:
                if lineparts[0]==cfnam or lineparts[0]==cfnam[2:]:
                    # print("%s.%s"%(cfnam,cmdstr))
                    exec("%s.%s"%(cfnam,cmdstr))

# only keep iteration output (removing simulations that lead to an
# increase of fc)
if True:
    index=[]
    ff = np.copy(fc)
    fm = ff[0]
    for k in range(1,len(ff)):
        if ff[k]>fm:
            # record position
            index.append(k)
        else:
            fm=ff[k]

    # now we know when fc did not decrease; drop list entries starting
    # from the end
    for ii in index[::-1]:
        for cfnam in cfnames:
            # drop list entries
            exec("del %s[ii]"%cfnam)

fig, ax = plt.subplots(1,1)

itrs = np.arange(len(fc))
fc0 = fc[0]

ax.plot(itrs,np.asarray(fc)/fc0,'-',
        label='total cost',linewidth=2)
ax.plot(itrs,(np.asarray(f_theta)+np.asarray(f_salt))/fc0,'--',
        label='T/S-data',linewidth=2)
ax.plot(itrs,(np.asarray(f_uvel)+np.asarray(f_vvel))/fc0,'-.',
        label='U/V-data',linewidth=2)

ax.plot(itrs[1:],(np.asarray(f_xx_theta)+np.asarray(f_xx_salt))[1:]/fc0,
        '--',label='inital conditions')
ax.plot(itrs[1:],(np.asarray(f_xx_hflux)+np.asarray(f_xx_sflux))[1:]/fc0,
                  '--',label='buoyancy flux')

ax.plot(itrs[1:],(np.asarray(f_xx_tauu)+np.asarray(f_xx_tauv))[1:]/fc0,
        ':',label='wind stress')

ax.plot(itrs[1:],(np.asarray(f_obcsn)+
                  np.asarray(f_obcss)+
                  np.asarray(f_obcse)+
                  np.asarray(f_obcsw))[1:]/fc0,'-',
        label='open boundaries')

#ax.set_yscale('log'); ax.set_ylim([1e-15,2])
ax.legend()
ax.grid()
ax.set_xlabel('simulation number')
ax.set_ylabel('normalized cost function')

plt.show()
