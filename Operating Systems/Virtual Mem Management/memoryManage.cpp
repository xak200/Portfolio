/*
 * memoryManage.cpp
 *
 *  Created on: Jul 10, 2015
 *      Author: xariak
 */

#include "memoryManage.h"

void mmu::printOperation(string operation, int pageNum, int frameNum) {
	if (outputOperations == true) {
		if (operation.compare("ZERO") == 0) {
			cout << numInstruction << ": " << operation << setw(13-operation.length())
														<< setfill(' ') << frameNum << endl;
		}
		else {
			cout << numInstruction << ": " << operation << setw(9-operation.length())
														<< setfill(' ') << pageNum << "   " << frameNum << endl;
		}
	}
}

void mmu::printPageTable() {
	for (int i = 0; i < 64; i++) {
		if (pageTable[i].PRESENT == false) {
			if (pageTable[i].PAGEDOUT == false) {
				cout << "*";
			}
			else { //pagedout = true
				cout << "#";
			}
		}
		else { //valid, present is true
			cout << i << ":";
			if (pageTable[i].REFERENCED == true) {
				cout << "R";
			}
			else {
				cout << "-";
			}
			if (pageTable[i].MODIFIED == true) {
				cout << "M";
			}
			else {
				cout << "-";
			}
			if (pageTable[i].PAGEDOUT == true) {
				cout << "S";
			}
			else {
				cout << "-";
			}
		}
		cout << " ";
	}
	cout << endl;
}

void mmu::printAging() {
	if (outputAging == true) {
		for (int i = 0; i < numFrames; i++) {
			if (frameTable[i] != 64) { //not mapped in
				printf("%d:%x ", i, pageTable[frameTable[i]].agingCounter);
			}
		}
	}
}

void mmu::printFrameTable() {
	for (int i = 0; i < numFrames; i++) {
		if (frameTable[i] == 64) { //not mapped in
			cout << "*" << " ";
		}
		else { //assume 0-63
			cout << frameTable[i] << " ";
		}
	}
	if (outputAging == true) {
		cout << " || ";
		printAging();
	}
	cout << endl;
}

void mmu::printSummary() {
	long long costUnMap = (stats.numMaps + stats.numUnmaps) * 400;
	long long costInOut = (stats.numIns + stats.numOuts) * 3000;
	long long costZero = stats.numZeros * 150;
	long long totalCost = costUnMap + costInOut + costZero + numInstruction;
	printf("SUM %d U=%d M=%d I=%d O=%d Z=%d ===> %llu\n",
			numInstruction, stats.numUnmaps, stats.numMaps, stats.numIns, stats.numOuts,
			stats.numZeros, totalCost);
}

void mmu::processInstruction(int rw, int page) {
	int frameToUse;
	if (outputOperations == true) {
		cout << "==> inst: " << rw << " " << page << endl;
	}
	if (pageTable[page].PRESENT == true) {
		pageTable[page].lastTouchedAtInstruction = numInstruction;
	}
	else if (!(freeFrameList.empty())) {
		frameToUse = freeFrameList.front();
		freeFrameList.pop_front();
		zero(frameToUse);
		map(page, frameToUse);
	}
	else {
		frameToUse = numFrameToReplace();
		unmap(frameTable[frameToUse], frameToUse);
		if (pageTable[frameTable[frameToUse]].MODIFIED == true) {
			out(frameTable[frameToUse], frameToUse);
		}
		if (pageTable[page].PAGEDOUT == true) {
			in(page, frameToUse);
		}
		else { //first access or not pagedout
			zero(frameToUse);
		}
		map(page, frameToUse);
	}
	if (rw == 1) {
		pageTable[page].MODIFIED = true;
	}
	pageTable[page].REFERENCED = true;
	numInstruction++; //determine instruction count
	if (outputPageTable == true) {
		printPageTable();
	}
	if (outputFrameTable == true) {
		printFrameTable();
	}
}

void readInputFile(char* ifName) {
	ifstream inputFile (ifName);
	int rw, page;
	string a;
	string line;
	char b[1024];
	if (inputFile.is_open()) {
		while (true) {
			getline(inputFile, line);
			if (inputFile.eof()) {
				break;
			}
			stringstream linestream(line);
			a = linestream.peek();
			if (a.compare("#") == 0) {
				linestream >> b;
			}
			else { //next instruction or EOF
				linestream >> rw >> page;
				if ((page >= 0) && (page <=63)) {
					myMmu->processInstruction(rw, page);
				}
			}
		}
		inputFile.close();
	}
	else {
		cout << "Error opening file";
	}
}

void readRandFile(char* rfName) {
	ifstream randFile (rfName);
	if (randFile.is_open()) {
		randFile >> randNumber; //first int is count of random numbers
		randVals = new int[randNumber];
		for (int i = 0; i < randNumber; i++) {
			randFile >> randVals[i];
		}
		randFile.close();
	}
	else {
		cout << "Error opening file\n";
	}
}

int myRandom(int frames) {
	int random = randVals[ofs] % frames;
	ofs++;
	if (ofs == randNumber) {
		ofs = 0;
	}
	return random;
}

void initializeGlobalVariables() {
	numFrames = 32;
	numInstruction = 0;
	outputOperations = false;
	outputFinalPageTable = false;
	outputFinalFrameTable = false;
	outputSummary = false;
	outputPageTable = false;
	outputFrameTable = false;
	outputAging = false;
	for (int i = 0; i < 64; i++) {
		pageTable[i].PAGEDOUT = false;
		pageTable[i].PRESENT = false;
		pageTable[i].agingCounter = 0;
	}
}

void mmu::initializeMmuMemberVariables() {
	stats.numUnmaps = 0;
	stats.numMaps = 0;
	stats.numIns = 0;
	stats.numOuts = 0;
	stats.numZeros = 0;
	frameTable = new int[numFrames];
	for (int i = 0; i < numFrames; i++) {
		frameTable[i] = 64; //initialize to 64, not mapped
		freeFrameList.push_back(i); //push numframes item onto freeframelist
	}
}

void clockVirtReplace::initializeMmuMemberVariables() {
	mmu::initializeMmuMemberVariables();
	virtHand = 0;
}

void clockPhysReplace::initializeMmuMemberVariables() {
	mmu::initializeMmuMemberVariables();
	physHand = 0;
}

int mmu::numFrameToReplace() {
	return 0;
}

void mmu::unmap(int pageNum, int frameNum) {
	pageTable[pageNum].PRESENT = false;
	printOperation("UNMAP", pageNum, frameNum);
	stats.numUnmaps++;
}

void mmu::out(int pageNum, int frameNum) {
	pageTable[pageNum].PAGEDOUT = true;
	pageTable[pageNum].MODIFIED = false;
	printOperation("OUT", pageNum, frameNum);
	stats.numOuts++;
}

void mmu::in(int pageNum, int frameNum) {
	printOperation("IN", pageNum, frameNum);
	stats.numIns++;
}

void mmu::map(int pageNum, int frameNum) {
	frameTable[frameNum] = pageNum;
	pageTable[pageNum].frameIndex = frameNum;
	pageTable[pageNum].lastTouchedAtInstruction = numInstruction;
	pageTable[pageNum].PRESENT = true;
	printOperation("MAP", pageNum, frameNum);
	stats.numMaps++;
}

void fifoReplace::map(int pageNum, int frameNum) {
	mmu::map(pageNum, frameNum);
	pagedInList.push_back(frameNum);
}

void secondChanceReplace::map(int pageNum, int frameNum) {
	mmu::map(pageNum, frameNum);
	pagedInList.push_back(frameNum);
}

void mmu::zero(int frameNum) {
	printOperation("ZERO", 0, frameNum);
	stats.numZeros++;
}

int lruReplace::numFrameToReplace() {
	int frameNum = 0;
	int smallestInstruction = pageTable[frameTable[0]].lastTouchedAtInstruction;
	for (int i = 0; i < numFrames; i++) {
		if (pageTable[frameTable[i]].lastTouchedAtInstruction < smallestInstruction) {
			smallestInstruction = pageTable[frameTable[i]].lastTouchedAtInstruction;
			frameNum = i;
		}
	}
	return frameNum;
}

int nruReplace::numFrameToReplace() {
	//for every valid page entry
	int counter = (stats.numUnmaps + 1) % 10;
	int i0 = 0, i1 = 0, i2 = 0, i3 = 0; //class counters
	for (int i = 0; i < 64; i++) {
		//set up nruArray
		if (pageTable[i].PRESENT == true) {
			if (pageTable[i].REFERENCED == true) {
				if (pageTable[i].MODIFIED == true) { //class 3
					nruArray[3][i3++] = i;
				}
				else { //class 2
					nruArray[2][i2++] = i;
				}
			}
			else {
				if (pageTable[i].MODIFIED == true) { //class 1
					nruArray[1][i1++] = i;
				}
				else { //class 0
					nruArray[0][i0++] = i;
				}
			}
		}
	}
	if ((counter == 0) && (stats.numUnmaps != 0)) {
		/*reset the REFERENCED bits every 10th page replacement request before you implement
				the replacement operation.*/
		for (int i = 0; i < 64; i++) {
			pageTable[i].REFERENCED = false;
		}
	}
	if (i0 > 0) {
		return pageTable[nruArray[0][myRandom(i0)]].frameIndex;
	}
	else if (i1 > 0) {
		return pageTable[nruArray[1][myRandom(i1)]].frameIndex;
	}
	else if (i2 > 0) {
		return pageTable[nruArray[2][myRandom(i2)]].frameIndex;
	}
	else if (i3 > 0) {
		return pageTable[nruArray[3][myRandom(i3)]].frameIndex;
	}
	else {
		cout << "Didn't find candidate. Exiting." << endl;
		exit(1);
	}
}

int fifoReplace::numFrameToReplace() {
	int frameToReplace;
	frameToReplace = pagedInList.front();
	pagedInList.pop_front();
	return frameToReplace;
}

int secondChanceReplace::numFrameToReplace() {
	/*If reference bit is 0, throw the page out
?    If reference bit is 1
?    Reset the reference bit to 0
?    Move page to the tail of the list ?
    Continue search for a free page*/
	while (true) {
		int frameToReplace = pagedInList.front();
		if (pageTable[frameTable[frameToReplace]].REFERENCED == false) {
			pagedInList.pop_front();
			return frameToReplace;
		}
		else { //ref bit is true
			pageTable[frameTable[frameToReplace]].REFERENCED = false;
			pagedInList.pop_front();
			pagedInList.push_back(frameToReplace);
		}
	}
}

int randomReplace::numFrameToReplace() {
	return myRandom(numFrames);
}

int clockPhysReplace::numFrameToReplace() {
	/*"clock" hands points to next page to replace
	 * if r = 0, replace page
	 * if r = 1, set r = 0 and advance clock hand*/
	int frameToReplace;
	while (true) {
		if (physHand == numFrames) {
			physHand = 0;
		}
		if (pageTable[frameTable[physHand]].REFERENCED == false) {
			frameToReplace = physHand;
			physHand++;
			return frameToReplace;
		}
		else { //ref bit is true
			pageTable[frameTable[physHand]].REFERENCED = false;
			physHand++;
		}
	}
}

int clockVirtReplace::numFrameToReplace() {
	/*"clock" hands points to next page to replace
	 * if r = 0, replace page
	 * if r = 1, set r = 0 and advance clock hand*/
	while (true) {
		if (virtHand == 64) {
			virtHand = 0;
		}
		if (pageTable[virtHand].PRESENT == true) {
			if (pageTable[virtHand].REFERENCED == false) {
				return pageTable[virtHand++].frameIndex;
			}
			else { //ref bit is true
				pageTable[virtHand++].REFERENCED = false;
			}
		}
		else {
			virtHand++;
		}
	}
}

int agingPhysReplace::numFrameToReplace() {
	int frameNum = 0;
	int smallestCounter = 0xffffffff; //max possible
	for (int i = 0; i < numFrames; i++) {
		pageTable[frameTable[i]].agingCounter >>= 1;
		if (pageTable[frameTable[i]].REFERENCED == true) {
			pageTable[frameTable[i]].agingCounter |= 1 << 31;
			pageTable[frameTable[i]].REFERENCED = false;
		}
	}
	//find smallest agingCounter among pages present
	for (int i = 0; i < numFrames; i++) {
		if (pageTable[frameTable[i]].PRESENT == true) {
			if (pageTable[frameTable[i]].agingCounter < smallestCounter) {
				smallestCounter = pageTable[frameTable[i]].agingCounter;
				frameNum = i;
			}
		}
	}
	pageTable[frameTable[frameNum]].agingCounter = 0;
	if (pageTable[frameTable[frameNum]].PRESENT == false) {
		cout << "Couldn't find valid page." << endl;
	}
	return frameNum;
}

int agingVirtReplace::numFrameToReplace() {
	/* On every call, look at each page.
	Shift the counter right 1 bit (divide its value by 2)
	If the Reference Bit is set... Set the most-significant bit
	Clear the Referenced Bit. */
	int pageNum = 0;
	int smallestCounter = 0xffffffff; //max possible
	for (int i = 0; i < 64; i++) {
		if (pageTable[i].PRESENT == true) {
			if (outputAging == true) {
				printf("%d:%x ", i, pageTable[i].agingCounter);
			}
			pageTable[i].agingCounter >>= 1;
			if (pageTable[i].REFERENCED == true) {
				pageTable[i].agingCounter |= 1 << 31;
				pageTable[i].REFERENCED = false;
			}
		}
		else { //page not present, reinitialize counter
			pageTable[i].agingCounter = 0;
		}
	}
	//find smallest agingCounter among pages present
	for (int i = 0; i < 64; i++) {
		if (pageTable[i].PRESENT == true) {
			if (pageTable[i].agingCounter < smallestCounter) {
				smallestCounter = pageTable[i].agingCounter;
				pageNum = i;
			}
		}
	}
	if (pageTable[pageNum].PRESENT == false) {
		cout << "Couldn't find valid page." << endl;
	}
	return pageTable[pageNum].frameIndex;
}


int main (int argc, char **argv) {
	char *sValue = NULL;
	int c;

	initializeGlobalVariables();
	lruReplace tmpReplace;
	myMmu = &tmpReplace;
	opterr = 0;
	while ((c = getopt (argc, argv, "a:o:f:")) != -1) {
		sValue = optarg;
		string str(sValue);
		switch (c)
		{
		case 'a':
			if (strcmp(sValue, "l") == 0) {
				lruReplace tmpReplace;
				myMmu = &tmpReplace;
			}
			else if (strcmp(sValue, "r") == 0) {
				randomReplace tmpReplace;
				myMmu = &tmpReplace;
			}
			else if (strcmp(sValue, "f") == 0) {
				fifoReplace tmpReplace;
				myMmu = &tmpReplace;
			}
			else if (strcmp(sValue, "s") == 0) {
				secondChanceReplace tmpReplace;
				myMmu = &tmpReplace;
			}
			else if (strcmp(sValue, "c") == 0) {
				clockPhysReplace tmpReplace;
				myMmu = &tmpReplace;
			}
			else if (strcmp(sValue, "a") == 0) {
				agingPhysReplace tmpReplace;
				myMmu = &tmpReplace;
			}
			else if (strcmp(sValue, "N") == 0) {
				nruReplace tmpReplace;
				myMmu = &tmpReplace;
			}
			else if (strcmp(sValue, "X") == 0) {
				clockVirtReplace tmpReplace;
				myMmu = &tmpReplace;
			}
			else if (strcmp(sValue, "Y") == 0) {
				agingVirtReplace tmpReplace;
				myMmu = &tmpReplace;
			}
			break;
		case 'o':
			if (str.find("O") != string::npos) {
				outputOperations = true;
			}
			if (str.find("P") != string::npos) {
				outputFinalPageTable = true;
			}
			if (str.find("F") != string::npos) {
				outputFinalFrameTable = true;
			}
			if (str.find("S") != string::npos) {
				outputSummary = true;
			}
			if (str.find("p") != string::npos) {
				outputPageTable = true;
			}
			if (str.find("f") != string::npos) {
				outputFrameTable = true;
			}
			if (str.find("a") != string::npos) {
				outputAging = true;
			}
			break;
		case 'f':
			numFrames = atoi(sValue);
			break;
		case '?':
			if (optopt == 's')
				fprintf (stderr, "Option -%c requires an argument.\n", optopt);
			else if (isprint (optopt))
				fprintf (stderr, "Unknown option `-%c'.\n", optopt);
			else
				fprintf (stderr, "Unknown option character `\\x%x'.\n", optopt);
			return 1;
		default:
			abort ();
		}
	}
	myMmu->initializeMmuMemberVariables();
	readRandFile(argv[argc - 1]);
	readInputFile(argv[argc - 2]);

	if (outputFinalPageTable == true) {
		myMmu->printPageTable();
	}
	if (outputFinalFrameTable == true) {
		myMmu->printFrameTable();
	}
	if (outputSummary == true) {
		myMmu->printSummary();
	}
	return 0;
}
