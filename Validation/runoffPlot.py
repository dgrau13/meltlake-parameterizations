import netCDF4 as nc
import matplotlib.pyplot as plt
# from osgeo import gdal
import numpy as np
import pandas as pd
import math

# choose racmo set to analyze, can be changed
RACMO_RU = nc.Dataset('CON_data\\runoff_monthlyS_ANT27_CONsettings_197901_201812.nc')

# extract runoff and timeseries values
ameryTimeseries = RACMO_RU.variables['runoff'][:, 0, 150:160, 190:210]
ameryTimeseries[ameryTimeseries == 0] = np.nan
ameryTimeseriesMean = np.nanmean(ameryTimeseries.reshape(480, 200), axis=1)

date = pd.Timestamp('1950-01-01')
newDate = [(date + pd.Timedelta(x, unit='d')) for x in (RACMO_RU.variables['time'][:])]

amerySeries = pd.Series(ameryTimeseriesMean, index=pd.Series(newDate))

print(amerySeries)
print(amerySeries.index)

timeBounds = pd.date_range("1979-06-01", periods=41, freq="365.25D")
print(len(timeBounds))

# calculate running sum per timeseries of runoff values
timeIndex = 0
meanHelper = 0
amerySummed = []
for run in amerySeries:
    if (not math.isnan(run)):
        while (amerySeries[amerySeries == run].index[0] > timeBounds[timeIndex]):
            timeIndex = timeIndex + 1
            amerySummed.append(meanHelper)
            meanHelper = 0
        meanHelper = meanHelper + run

amerySummed.append(meanHelper)
print(amerySummed)
print(len(amerySummed))

# convert into correct units
ameryDepth = np.multiply(amerySummed, 1/1000)

pd.Series(ameryDepth, index=timeBounds).to_csv('amery_depth.csv')

plotSummedAmerySeries = pd.Series(amerySummed, index=timeBounds)
plotSummedAmerySeries.plot(style='.')
plt.title("Total Seasonal Runoff Values in Amery Ice Shelf")
plt.ylabel("kg m^-2")
plt.xlabel("time")
plt.show()

