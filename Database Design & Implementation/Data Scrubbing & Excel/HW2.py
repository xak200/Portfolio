import re
print ("start")
f = open("titanic.txt", "r")
p = re.compile(r"\t")

fileData2DList = []
foundHeadings = False
numColumns = 0;

for line in f:
    if foundHeadings == False:        
        if line.find("PassengerId") == 0:
            foundHeadings = True
        elif foundHeadings == False:
            continue
    lineData = []
    currentSearchPosition = 0
    iterator = p.finditer(line)
    
    for match in iterator:
        #will terminate before last column(embarked) by design
        span = match.span()
        startIndex = span[0]
        endIndex = span[1]
        data = line[currentSearchPosition:startIndex]
        if data == "Pclass":
            data = "Passenger class"
        if data == "SibSp":
            data = "# of siblings/spouses"
        if data == "Parch":
            data = "# of parents/children"
        lineData.append(data)
        numColumns = len(lineData)
        currentSearchPosition = endIndex
    fileData2DList.append(lineData)
f.close()

#drop "ticket" & "cabin" data
newFileData2DList = [];
for row in fileData2DList:
    newLineData = [];
    for col in range(0, numColumns):
        if not ((col == 8) or (col == 10)):
           newLineData.append(row[col])
    newFileData2DList.append(newLineData);


#CONVERT TO CSV

f = open("titanic.csv", "w")

for lineData in newFileData2DList:
    thisLineWithCommas = ",".join(lineData) 
    thisLineWithCommas = thisLineWithCommas + "\n" 
    f.write(thisLineWithCommas)
    
f.close();
print("end")
