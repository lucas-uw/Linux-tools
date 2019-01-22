#!/usr/bin/env python

import numpy as np
import netCDF4 as nc
import sys

var = sys.argv[1]
year = sys.argv[2]
days = int(sys.argv[3])

infile = 'annual_files/PRISM.daily.%s.%s.nc' % (var, year)

rootgroup = nc.Dataset(infile,'a',format='NETCDF4')
time = rootgroup.variables['time']
time[:] = np.arange(days)*1.0
rootgroup.close()
