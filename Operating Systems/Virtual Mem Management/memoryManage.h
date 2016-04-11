/*
 * memoryManage.h
 *
 *  Created on: Jul 10, 2015
 *      Author: xariak
 */

#ifndef MEMORYMANAGE_H_
#define MEMORYMANAGE_H_

#include <iostream>
#include <fstream>
#include <sstream>
#include <iomanip>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <list>
#include <string>
#include <stdio.h>
#include <string.h>
#include <array>
#include <stdint.h>
using namespace std;


int randNumber; //size of random value array
int* randVals; //random value array
int ofs; //random number array index
int numFrames;
int numInstruction;
bool outputOperations; //O
bool outputFinalPageTable; //P
bool outputFinalFrameTable; //F
bool outputSummary; //S
bool outputPageTable; //p
bool outputFrameTable; //f
bool outputAging; //a

int* frameTable;
list<int> freeFrameList;
list<int> pagedInList;

struct pageTableEntry  {
     bool PRESENT:1;
     bool MODIFIED:1;
     bool REFERENCED:1;
     bool PAGEDOUT:1;
     unsigned frameIndex:6;
     unsigned lastTouchedAtInstruction:22;
     uint32_t agingCounter;
};
pageTableEntry pageTable[64];

struct statistics {
	int numUnmaps;
	int numMaps;
	int numIns;
	int numOuts;
	int numZeros;
};


class mmu {
public:
	statistics stats;
	void unmap(int pageNum, int frameNum);
	void out(int pageNum, int frameNum);
	void in(int pageNum, int frameNum);
	void zero(int frameNum);
	void processInstruction(int rw, int page);
	virtual void map(int pageNum, int frameNum);
	virtual int numFrameToReplace();
	virtual void initializeMmuMemberVariables();
	void printOperation(string operation, int pageNum, int frameNum);
	void printPageTable();
	void printFrameTable();
	void printSummary();
	void printAging();
};
mmu *myMmu;

class nruReplace : public mmu {
	public:
	int nruArray[4][64];
	int numFrameToReplace();
};

class lruReplace : public mmu {
	public:
	int numFrameToReplace();
};

class randomReplace : public mmu {
	public:
	int numFrameToReplace();
};

class fifoReplace : public mmu {
	public:
	void map(int pageNum, int frameNum);
	int numFrameToReplace();
};

class secondChanceReplace : public mmu {
	public:
	void map(int pageNum, int frameNum);
	int numFrameToReplace();
};

class clockPhysReplace : public mmu {
	public:
	int physHand;
	void initializeMmuMemberVariables();
	int numFrameToReplace();
};

class clockVirtReplace : public mmu {
public:
	int virtHand;
	void initializeMmuMemberVariables();
	int numFrameToReplace();
};

class agingPhysReplace : public mmu {
	public:
	int numFrameToReplace();
};

class agingVirtReplace : public mmu {
	public:
	int numFrameToReplace();
};


#endif /* MEMORYMANAGE_H_ */
