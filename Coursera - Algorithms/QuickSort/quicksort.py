def fileIntoArray(filePath):
    f = open(filePath, 'r')
    data = []
    for line in f:
        line = line.replace('\r', '')
        line = line.replace('\n', '')
        data.append(line)
    return data

def quicksort(array, comparisons):
    n = len(array)
    if n == 0 or n == 1:
        return (array, 0)
    else:
        pivot, pIndex = choosePivot(array)
        array, newP = partitionArrayAroundPivot(array, pivot, pIndex)
        left = array[:newP-1]
        right = array[newP:]
        left1, leftComparisons = quicksort(left, comparisons)
        right1, rightComparisons = quicksort(right, comparisons)
        comparisons += len(array) - 1
        array[:newP - 1] = left1
        array[newP:] = right1
        comparisons += leftComparisons + rightComparisons
    return (array, comparisons)

def partitionArrayAroundPivot(array, pivot, pIndex):
    i = pIndex + 1
    for j in range(pIndex + 1, len(array)):
        if int(array[j]) < int(pivot):
            temp = array[j]
            array[j] = array[i]
            array[i] = temp
            i += 1
    temp2 = array[pIndex]
    array[pIndex] = array[i - 1]
    array[i - 1] = temp2
    return (array, i)

#pivot is first element
'''def choosePivot(array):
    return (array[0], 0)'''

#pivit is last element
'''def choosePivot(array):
    last = array[len(array)-1]
    temp = array[0]
    array[0] = last
    array[len(array)-1] = temp
    return (array[0], 0)'''

def choosePivot(array):
    options = []
    first = array[0]
    if len(array) % 2 == 0:
        k = len(array)/2
        middle = array[k-1]
    else:
        k = len(array) / 2
        middle = array[k]
    last = array[len(array)-1]
    options.append(int(first))
    options.append(int(middle))
    options.append(int(last))
    options = sorted(options)
    pivot = options[1]
    pivotIndex = array.index(str(pivot))
    temp = array[0]
    array[0] = str(options[1])
    array[pivotIndex] = temp
    return (array[0], 0)

def runAll():
    array = fileIntoArray('../Files/QuickSort.txt')
    comparisons = 0
    sorted, totalComparisons = quicksort(array, comparisons)
    print sorted
    print totalComparisons

runAll()