#!/usr/bin/python

import numpy as np
import netCDF4 as nc
import sys

year = sys.argv[1]
days = int(sys.argv[2])

infile = 'annual_files/PRISM.'+year+'.nc'

rootgroup = nc.Dataset(infile,'a',format='NETCDF4')
time = rootgroup.variables['time']
time[:] = np.arange(days)*1.0
rootgroup.close()
