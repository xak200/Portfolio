def fileIntoArray(filePath):
    f = open(filePath, 'r')
    data = []
    for line in f:
        line = line.replace('\n', '')
        data.append(line)
    return data

def sortAndCount(array):
    length = len(array)
    if length == 0 or length == 1:
        return (array, 0)
    else:
        (leftSorted, leftInv) = sortAndCount(array[:length/2]) #left
        (rightSorted, rightInv) = sortAndCount(array[length/2:]) #right
        (arraySorted, splitInv) = mergeAndCountSplitInv(leftSorted, rightSorted)
        return (arraySorted, leftInv + rightInv + splitInv)

def mergeAndCountSplitInv(left, right):
    sorted = []
    i = 0
    j = 0
    inversions = 0
    count = len(left) + len(right)
    for k in range(0, count):
        if j==len(right):
            sorted.append(left[i])
            i += 1
        elif i==len(left):
            sorted.append(right[j])
            j += 1
        elif int(left[i]) < int(right[j]):
            sorted.append(left[i])
            i += 1
        elif int(right[j]) < int(left[i]):
            sorted.append(right[j])
            j += 1
            inversions += len(left)-i
    return (sorted, inversions)

def runAll():
    array = fileIntoArray('../Files/IntegerArray.txt')
    (a,b) = sortAndCount(array)
    print b
runAll()