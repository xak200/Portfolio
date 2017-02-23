import datetime
import sys
import threading
if __name__ == '__main__':
    sys.setrecursionlimit(2 ** 20)
    threading.stack_size(2 ** 26)
    thread = threading.Thread()
    thread.start()

#create dictionary with key = INT tail node; values = LIST head node(s), LIST backwards node(s), BOOL explored, INT finishing time, INT leader
def handleFile(filePath):
    with open(filePath) as f:
        nodeList = {}
        for line in f:
            if line == '\n':
                continue
            else:
                u, v = line.split()
                u = int(u)
                v = int(v)
                #forward
                if (nodeList.has_key(u)):
                    nodeList[u][0].append(v)
                else:
                    uValueList = [[], [], False, 0, 0]
                    uValueList[0].append(v)
                    nodeList[u] = uValueList
                # backward
                if (nodeList.has_key(v)):
                    nodeList[v][1].append(u)
                else:
                    vValueList = [[], [], False, 0, 0]
                    vValueList[1].append(u)
                    nodeList[v] = vValueList
    return nodeList

def SCC(nodeDict):
    leaders = {}
    t = 0
    for i in reversed(nodeDict.keys()):
        if nodeDict[i][2] == False:
            newDict, t = DFSfirst(nodeDict, i, t)
    finishTimes = sorted(newDict.items(), key=lambda e: e[1][3])
    for j in reversed(finishTimes):
        count = 0
        if newDict[j[0]][2] == True:
            s = j[0]
            dict, leaders, count = DFSsecond(newDict, j[0], s, leaders, count)
    l = sorted(leaders.values(), reverse=True)
    print l[:5]

def DFSfirst(dict, i, t):
    dict[i][2] = True
    stack = []
    stack.append(i)
    while len(stack) != 0:
        #if top of stack has unvisited edge:
            #push vertex and mark visited
        top = stack[len(stack)-1]
        #find first unvisited vertex
        k = findUnvisited(dict, top, True)
        if k == -1:
            node = stack.pop()
            t += 1
            dict[node][3] = t
        else:
            stack.append(k)
            dict[k][2] = True
    return (dict, t)

def DFSsecond(dict, i, s, leaders, count):
    dict[i][2] = False
    dict[i][4] = s
    stack = []
    stack.append(i)
    count += 1
    leaders[s] = count
    while len(stack) != 0:
        top = stack[len(stack) - 1]
        dict[top][4] = s
        # find first unvisited vertex
        k = findUnvisited(dict, top, False)
        if k == -1:
            node = stack.pop()
        else:
            stack.append(k)
            dict[k][2] = False
            count += 1
            leaders[s] = count
    return (dict, leaders, count)

def findUnvisited(dict, top, first):
    if first:
        check = False
        index = 1
    else:
        check = True
        index = 0
    vertices = dict[top][index]
    for v in vertices:
        if dict[v][2] == check:
            return v
        else:
            continue
    return -1            #all vertices visited

def runAll():
    nodeDict = handleFile('../Files/SCC.txt')
    SCC(nodeDict)

runAll()