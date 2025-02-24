## Script to plot fractional coverage over time of specific ice shelf

from pathlib import Path
import pandas as pd
import matplotlib.pyplot as plt

# grab paths of all images of specific ice shelf
pathlist = Path('Images/Larsen_C_ice_shelf').rglob('*Depth.tif')
dateTimeArray = []
coverageArray = []

for path in pathlist:
    # get data file and read date values
    pathstr = str(path.parent.joinpath('data.txt'))
    coveragePath = str(path.parent.joinpath('total_total_frac.txt'))
    with open(pathstr, 'r') as file:
        date = file.readlines()[3]
        dateTime = pd.to_datetime(date)
        dateTimeArray.append(dateTime)

    # read coverage data from data file
    with open(coveragePath, 'r') as file:
        coverage = file.readlines()[0].rsplit(' ')[0]
        coverageArray.append(float(coverage))

# plotting functions for seasonal fractional coverage graphs
pandasDict = {'fractional coverage': coverageArray}
dataframe = pd.DataFrame(data=pandasDict, index=dateTimeArray)
series = pd.to_numeric(pd.Series(coverageArray, index=pd.Series(dateTimeArray))).sort_index()
series.plot(style='.')
plt.title('Larsen C Fractional Coverage')
plt.xlabel("Date")
plt.ylabel("Fraction")
plt.show()
