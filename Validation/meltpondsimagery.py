## Script to calculate depth and coverage statistics for all images in dataset of specific ice sheet

from pathlib import Path
import tifffile as tf
import numpy as np

pathlist = Path('Images').rglob('*.tif')
for path in pathlist:
    pathstr = str(path)
    # check if image has depth data, if so, average over lakes and image
    if 'Average_Red_And_Panchromatic' in pathstr:
        print(pathstr)
        image = tf.imread(pathstr)
        lakeAvg = np.average(image[image >= 1])
        allAvg = np.average(image[image != -1])
        resFilePath = str(path.parent.joinpath('data.txt'))
        with open(resFilePath, "a") as resFile:
            resFile.write(str(lakeAvg) + ' average lake depth\n' + str(allAvg) + ' average depth everywhere\n')

    # check if image has lake coverage data, if so, calculate fractional coverage
    if 'All_Masks' in pathstr:
        image = tf.imread(pathstr)
        lakePix = image[image == 1]
        notLakePix = image[image == 0]
        coverage = len(lakePix) / len(notLakePix)
        if 1 not in image:
            coverage = 0.0
        resFilePath = str(path.parent.joinpath('data.txt'))
        with open(resFilePath, "w") as resFile:
            resFile.write(str(coverage) + ' actual fractional coverage\n')

# save data of image to data file
metaPathList = Path('Images').rglob('*MTL.txt')
for path in metaPathList:
    metaPathstr = str(path)
    metaResFilePath = str(path.parent.joinpath('data.txt'))
    with open(metaPathstr, "r") as fp:
        date = str(fp.readlines()[23]).rsplit(' ', 1)[-1]
    print(date)
    with open(metaResFilePath, "a" ) as resFile:
        resFile.write(date)