import random

#########
#begin setup
def fileIntoVerticesArray(filePath):
    f = open(filePath)
    data = []
    for line in f:
        vertices = []
        line = line.strip().split()
        for vertex in line:
            vertices.append(vertex)
        data.append(vertices)
    return data

def verticesArrayIntoDict(array):
    edgeArray = {}
    for a in array:
        edgeList = []
        count = 0
        for item in a:
            if count == 0:
                key = item
            else:
                edgeList.append(item)
            edgeArray[key] = edgeList
            count += 1
    return edgeArray
#########

def graphContractions(dict, joinedVertices):
    if len(dict) <= 2:
        return (dict, joinedVertices)
    else:
        edgeToContract = chooseRandomEdge(dict)
        dict, joinedVertices = contractEdge(edgeToContract, dict, joinedVertices)
        d, j = graphContractions(dict, joinedVertices)
        return (d, j)

def chooseRandomEdge(dict):
    edge = []
    f = random.sample(dict, 1)
    first = f[0]
    # l = len((dict[first]))
    s = random.sample(dict[first], 1)
    second = s[0]
    edge.append(first)
    edge.append(second)
    return edge

def contractEdge(edge, dict, joinedVertices):
    # print edge
    # print dict
    jv = []
    jv.append(edge[1])
    #########
    #keep track of vertices that have been fused together by contractions
    if joinedVertices.has_key(edge[0]):
        joinedVertices[edge[0]].append(edge[1])
    else:
         joinedVertices[edge[0]] = jv
    #########
    #########
    #change all instances of deleted vertices to preserved vertex
    for f in dict[edge[1]]:
        while edge[1] in dict[f]:
            dict[f].remove(edge[1])
            dict[f].append(edge[0])
    #########
    #########
    #merge vertices' connecting vertices
    for d in dict[edge[1]]:
        dict[edge[0]].append(d)
    del dict[edge[1]]               #delete one of merged vertices
    #########
    #########
    #remove self loop
    for e in edge:
        while e in dict[edge[0]]:
            dict[edge[0]].remove(e)
    #########
    #print dict
    return (dict, joinedVertices)

def runAll():
    joinedVertices = {}                 #dictionary to keep track of vertices of contracted edges
    vertices = fileIntoVerticesArray('../Files/kargerMinCut.txt')
    edges = verticesArrayIntoDict(vertices)
    dict, joinedVertices = graphContractions(edges, joinedVertices)
    k = dict.keys()
    return len(dict[k[0]])

def runABunch():
    results = []
    for i in range(1000):
        result = runAll()
        results.append(result)
    print min(results)

runAll()
runABunch()