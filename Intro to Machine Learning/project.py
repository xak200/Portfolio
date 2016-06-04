import numpy as np
import csv

def readFile(filename):
    f = open(filename, 'r')
    count = 0
    featureCount = 0
    countJETlines = 0
    newListFile = []
    featureNameList = []
    for line in f:
        line = line.replace(' ', '')
        newLine = line.split(',')
        last = len(newLine) - 1
        newLine[last] = newLine[last].strip()       #strip newline character
        for item in newLine:
            if (featureCount >= 50) and (featureCount <= 63):
                featureNameList.append(item)
            featureCount += 1
        if (newLine[0] == 'JET'):
            newListFile.append(newLine)
            countJETlines += 1
        count += 1
    print(featureNameList)
    f.close()
    return (newListFile, countJETlines, featureNameList)

def splitFeaturesAndLabels(data):
    features = []
    labels = []
    rmagIndex = 32
    aminIndex = 33
    kappaIndex = 34
    deltaIndex = 36
    magStartIndex = 50
    magEndIndex = 63
    for featureVector in data:
        count = 0
        labelItems = []
        featureItems = []
        for item in featureVector:
            if (count == rmagIndex) or (count == aminIndex) or (count == kappaIndex) or (count == deltaIndex):
                labelItems.append(item)
            #edited for magnetic features only. just else if all features
            #magnetic features are from index 50-63
            elif (count >= magStartIndex) and (count <= magEndIndex):
                featureItems.append(item)
                #print(featureItems)
            count += 1
        labels.append(labelItems)
        features.append(featureItems)
    return (features, labels)

def identifyDiscreteAndContinuous(features, featureNameList):
    featureNameCount = 0
    newFeatures = []
    #features[0] is first feature vector
    for item in features[0]:
        tuple = []
        #hazard if not blank in other feature vector which contains discrete value
        #not an issue with this data set, because findMeansModesAndMaxes never errored out
        if (item == ''):
            tuple.append(featureNameList[featureNameCount])
            tuple.append('continuous')
            tuple.append(0)                 #num non-blank fields
            tuple.append(0.0)               #mean start
            tuple.append(0.0)               #max start
        else:
            try:
                f = float(item)
                tuple.append(featureNameList[featureNameCount])
                tuple.append('continuous')
                tuple.append(0)                 #num non-blank fields
                tuple.append(0.0)               #mean start
                tuple.append(0.0)               #max start
            except ValueError:
                tuple.append(featureNameList[featureNameCount])
                tuple.append('discrete')
                tuple.append({})
                tuple.append('mode')
        featureNameCount += 1
        newFeatures.append(tuple)
    return (newFeatures)


def populateMissingData(features, featureMetaData):
    #replace missing data with candidates
    for feature in features:
        count = 0
        for item in feature:
            if (item == ''):
                feature[count] = featureMetaData[count][3]
            count += 1


#for discrete, find mode & update featurenamelist to include count and value options
#for continuous, find avg
def findMeansModesAndMaxes(features, featureMetaData):
    for feature in features:
        count = 0
        for item in feature:
            #if continuous, add to aggregate
            if (featureMetaData[count][1] == 'continuous'):
                if (item != ''):
                    featureMetaData[count][3] += float(item)
                    featureMetaData[count][2] += 1
                    if (float(item) > float(featureMetaData[count][4])):
                        featureMetaData[count][4] = float(item)
            #else if discrete, add to dictionary
            else:
                if (item in featureMetaData[count][2]):
                    value = featureMetaData[count][2][item]
                    value += 1
                    featureMetaData[count][2][item] = value
                else:
                    if (item != ''):
                        #if item is blank, never adds to dictionary -- so blank space will never be mode
                        featureMetaData[count][2][item] = 1
            count += 1
    for identified in featureMetaData:
        if (identified[1] == 'continuous'):
            if (identified[2] == 0):
                identified[3] = 0
            else:
                identified[3] = (identified[3] / identified[2])
        else:                   #find modes for missing discrete fields
            identified[3] = max(identified[2], key=lambda i: identified[2][i])


def normalizeData(features, featureMetaData):
    newFeatureMatrix = []
    for feature in features:
        newFeatureRow = []
        itemCount = 0
        for item in feature:
            #convert each continuous feature to be between 0 and 1
            if (featureMetaData[itemCount][1] == 'continuous'):
                if (featureMetaData[itemCount][4] != 0):
                    newFeatureRow.append(float(item) / featureMetaData[itemCount][4])
                else:
                    newFeatureRow.append(0.0)
            #convert each discrete feature into n binary columns
            else:
                for option in featureMetaData[itemCount][2]:
                    if (item == option):
                        newFeatureRow.append(1)
                    else:
                        newFeatureRow.append(0)
            itemCount += 1
        newFeatureMatrix.append(newFeatureRow)
    return newFeatureMatrix


def createExpandedFieldnames(featureMetaData):
    count = 0
    fieldNames = []
    for feature in featureMetaData:
        if (feature[1] == 'continuous'):
            fieldNames.append(feature[0])
        else:               #discrete
            for option in feature[2]:
                fieldNames.append(feature[0] + '-' + str(option))
        count += 1
    return(fieldNames)


def writeDataToFile(fieldNames, newFeatureMatrix):
    #with open('tokamakData.csv', 'w') as csvfile:
    with open('tokamakMagneticData.csv', 'w') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(fieldNames)
        for row in newFeatureMatrix:
            writer.writerow(row)


def writeLabelsToFile(labels):
    #with open('tokamakLabels.csv', 'w') as csvfile:
    with open('tokamakMagneticLabels.csv', 'w') as csvfile:
        writer = csv.writer(csvfile)
        for row in labels:
            writer.writerow(row)


def prepareData(filename):
    data, JETlineCount, featureNameList = readFile(filename)
    #separate features and labels
    features, labels = splitFeaturesAndLabels(data)
    featureMetaData = identifyDiscreteAndContinuous(features, featureNameList)
    #find candidates for population
    findMeansModesAndMaxes(features, featureMetaData)
    #fill in missing data with avgs for continuous & modes for discrete
    populateMissingData(features, featureMetaData)
    newFeatureMatrix = normalizeData(features, featureMetaData)
    fieldNames = createExpandedFieldnames(featureMetaData)
    #print(labels)
    #print(newFeatureMatrix)
    writeDataToFile(fieldNames, newFeatureMatrix)
    writeLabelsToFile(labels)

prepareData('ASP-db1.csv')