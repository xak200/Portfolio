package zzLinker;

import java.util.List;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.LineNumberReader;
import java.util.LinkedList;
import java.util.Scanner;
import java.lang.Integer;

public class linker {
	static String[][] symbolTable = new String[256][4]; //[0] symbol, [1] address, [2] error message, [3] module number
	static int symbolTableRow = 0;

	static String[][] memoryMap = new String[512][2]; //instruction map
	static int memoryMapCount = 0;
	static int baseAddress = 0;
	static int relativeAddress; //offset
	static List<String> globalUseList = new LinkedList<String>(); //contains all symbols encountered
	static List<String> moduleUsedList = new LinkedList<String>();

	static int passNumber = 1;
	static int moduleNumber = 1;
	static int totalInstr = 0;

	static int lineNum = 0;
	static int lineOffset = 0;
	static String currentLine = null;

	static LineNumberReader lineReader;
	static Scanner lineScanner;

	public static void main(String[] args) throws Exception {
		File inputFile;
		String path;
		inputFile = new File(args[0]);
		path = inputFile.getAbsolutePath();
		File input = new File(path);
		//	System.out.println(input.toString());
		pass_one(input);
		pass_two(input);
	}

	private static void pass_one(File in) throws Exception {
		parse(in);
		System.out.println("Symbol Table");
		for (int i = 0; i < symbolTableRow; i++) {
			if (symbolTable[i][2] != null) {
				System.out.println(symbolTable[i][0] + "=" + symbolTable[i][1] + "  " + symbolTable[i][2]);
			}
			else {
				System.out.println(symbolTable[i][0] + "=" + symbolTable[i][1]);
			}
		}
	}

	private static void pass_two(File in) throws Exception {
		passNumber = 2;
		baseAddress = 0;
		moduleNumber = 1;
		parse(in);
		System.out.println("Memory Map");
		for (int i = 0; i < memoryMapCount; i++) {
			if (memoryMap[i][1] != null) {
				System.out.println(String.format("%03d", i) + ": " + String.format("%04d", Integer.parseInt(memoryMap[i][0])) + " " + memoryMap[i][1]);
			}
			else {
				System.out.println(String.format("%03d", i) + ": " + String.format("%04d", Integer.parseInt(memoryMap[i][0])));
			}
		}
		for (int i = 0; i < symbolTableRow; i++) {
			String symbol = symbolTable[i][0];
			if (!(globalUseList.contains(symbol))) {
				System.out.println("Warning: Module " + symbolTable[i][3] + ": " + symbol + " was defined but never used");
			}
		}
	}

	private static void parseError(int errcode, String token) throws IOException { 
		String[] errstr = {
				"NUM_EXPECTED",  // Number expect
				"SYM_EXPECTED", // Symbol Expected
				"ADDR_EXPECTED", // Addressing Expected
				"SYM_TOLONG", // Symbol Name is to long 
				"TO_MANY_DEF_IN_MODULE", //>16
				"TO_MANY_USE_IN_MODULE", // > 16
		"TO_MANY_INSTR" };//total num_instr exceeds memory size (512)
		lineNum = lineReader.getLineNumber();
		if (currentLine == null) {
			lineOffset = 1;
		}
		else {
			if (token == null) {
				lineOffset = currentLine.length();
			}
			else {
				lineOffset = currentLine.indexOf(token) + 1;
			}
		}
		System.out.printf("Parse Error line %d offset %d: %s\n", lineNum, lineOffset, errstr[errcode]); 
	}

	private static boolean refillLineScannerIfNeeded() throws IOException {
		while (true) {
			if (lineScanner.hasNext()) {
				return true;
			}
			else {
				currentLine = lineReader.readLine();
				if (currentLine != null) {
					lineScanner = new Scanner(currentLine);
				}
				else {
					return false;
				}
			}
		}
	}

	private static void parse(File in) throws Exception {
		lineReader = new LineNumberReader(new FileReader(in));
		while ((currentLine = lineReader.readLine()) != null) {
			lineScanner = new Scanner(currentLine);
			refillLineScannerIfNeeded();
			createModule();
		}
	}

	private static void createModule() throws IOException {
		readDefList();
		List<String> useList = readUseList();
		globalUseList.addAll(useList);
		readInstList(useList);
		moduleNumber++;
	}

	private static void readDefList() throws IOException {
		int numDefs = 0;
		String token = null;
		refillLineScannerIfNeeded();
		if (lineScanner.hasNextInt()) {
			numDefs = lineScanner.nextInt();
		}
		else {
			if (lineScanner.hasNext()) {
				token = lineScanner.next();
			}
			parseError(0, token);
			System.exit(0);
		}
		if (numDefs > 16) {
			parseError(4, Integer.toString(numDefs));
			System.exit(0);
		}
		for (int i = 0; i < numDefs; i++) {
			readDefs();
		}
	}

	private static void readDefs() throws IOException {
		String definedSymbol = null;
		String token = null;
		refillLineScannerIfNeeded();
		if (lineScanner.hasNext()) {
			definedSymbol = lineScanner.next();
		}
		else {
			parseError(1, null);
			System.exit(0);
		}
		refillLineScannerIfNeeded();
		if (lineScanner.hasNextInt()) {
			relativeAddress = lineScanner.nextInt();
		}
		else {
			if (lineScanner.hasNext()) {
				token = lineScanner.next();
			}
			parseError(0, token);
			System.exit(0);
		}
		if (passNumber == 1) {
			boolean check = checkSymbolInTable(definedSymbol);
			if (check == true) {
				symbolTable[findSymbolInTable(definedSymbol)][2] = "Error: This variable is multiple times defined; first value used";
			}
			else {
				symbolTable[symbolTableRow][0] = definedSymbol;
				symbolTable[symbolTableRow][1] = Integer.toString(relativeAddress + baseAddress);
				symbolTable[symbolTableRow][3] = Integer.toString(moduleNumber);
				symbolTableRow++;
			}
		}
	}

	private static List<String> readUseList() throws IOException {
		int numUse = 0;
		String token = null;
		List<String> useList = new LinkedList<String>();
		refillLineScannerIfNeeded();
		if (lineScanner.hasNextInt()) {
			numUse = lineScanner.nextInt();
		}
		else {
			if (lineScanner.hasNext()) {
				token = lineScanner.next();
			}
			parseError(0, token);
			System.exit(0);
		}
		if (numUse > 16) {
			parseError(5, Integer.toString(numUse));
			System.exit(0);
		}
		String symbol;
		for (int i = 0; i < numUse; i++) {
			symbol = readUse();
			useList.add(i, symbol);
		}
		return useList;
	}

	private static String getSymbol() throws IOException {
		String tmpSymbol = null;
		if (lineScanner.hasNext()) {
			tmpSymbol = lineScanner.next();
		}
		else {
			parseError(1, null);
			System.exit(0);
		}
		if (Character.isLetter(tmpSymbol.charAt(0))) {
			if (tmpSymbol.length() > 16) {
				parseError(3, tmpSymbol);
				System.exit(0);
			}
			return tmpSymbol;
		}
		else {
			parseError(1, tmpSymbol);
			System.exit(0);
		}
		return tmpSymbol;
	}

	private static String readUse() throws IOException {
		String symbol = null;
		refillLineScannerIfNeeded();
		symbol = getSymbol();
		return symbol;
	}

	private static boolean checkSymbolInTable(String symbol) {
		for (int i = 0; i < symbolTableRow; i++) {
			if ((symbolTable[i][0].compareTo(symbol) == 0) && (symbolTable[i][1] != null)) {
				return true;
			}
		}
		return false;
	}

	private static int findSymbolInTable(String symbol) {
		int i;
		for (i = 0; i < symbolTableRow; i++) {
			if ((symbolTable[i][0].compareTo(symbol) == 0)) {
				break;
			}
		}
		return i;
	}

	private static void readInstList(List<String> useList) throws IOException {
		int numInst = 0;
		String token = null;
		refillLineScannerIfNeeded();
		if (lineScanner.hasNextInt()) {
			numInst = lineScanner.nextInt();
			totalInstr += numInst;
		}
		else {
			if (lineScanner.hasNext()) {
				token = lineScanner.next();
			}
			parseError(1, token);
			System.exit(0);
		}
		if (totalInstr > 512) {
			parseError(6, Integer.toString(numInst));
			System.exit(0);
		}
		if (passNumber == 1) {
			for (int i = 0; i < symbolTableRow; i++) {
				if (Integer.parseInt(symbolTable[i][1]) > (baseAddress + numInst)) {
					System.out.println("Warning: Module " + moduleNumber + ": " + symbolTable[i][0] + " to big " + symbolTable[i][1] + " (max=" + (numInst - 1) + ") assume zero relative");
					symbolTable[i][1] = Integer.toString(baseAddress);
				}
			}
		}
		for (int i = 0; i < numInst; i++) {
			readInst(useList, numInst);
		}
		if (passNumber == 2) {
			for (int i = 0; i < useList.size(); i++) {
				String symbol = useList.get(i);
				if (!(moduleUsedList.contains(symbol))) {
					System.out.println("Warning: Module " + moduleNumber + ": " + symbol + " appeared in the uselist but was not actually used");
				}
			}
		}
		baseAddress = baseAddress + numInst;
	}

	private static void readInst(List<String> useList, int numInst) throws IOException {
		String instructionType = null;
		String token = null;
		int instr = 0;
		refillLineScannerIfNeeded();
		if (lineScanner.hasNext()) {
			instructionType = lineScanner.next();
		}
		else {
			parseError(2, null);
			System.exit(0);
		}
		refillLineScannerIfNeeded();
		if (lineScanner.hasNextInt()) {
			instr = lineScanner.nextInt();
		}
		else {
			if (lineScanner.hasNext()) {
				token = lineScanner.next();
			}
			parseError(0, token);
			System.exit(0);
		}
		if (passNumber == 2) {
			int operand = instr % 1000; //get operand from instruction
			int opcode = instr / 1000; //get opcode from instruction
			if (instructionType.compareTo("I") == 0) {
				if (instr / 1000 >= 10) {
					memoryMap[memoryMapCount][1] = "Error: Illegal immediate value; treated as 9999"; //error #10
					instr = 9999;
				}
				memoryMap[memoryMapCount][0] = Integer.toString(instr); //immediate case, no change to address
			}
			else if (instructionType.compareTo("A") == 0) {
				if (operand > 512) {
					memoryMap[memoryMapCount][1] = "Error: Absolute address exceeds machine size; zero used";
					instr = opcode * 1000;
				}
				memoryMap[memoryMapCount][0] = Integer.toString(instr); //absolute case, no change to address
			}
			else if (instructionType.compareTo("R") == 0) {
				if (operand > numInst) {
					memoryMap[memoryMapCount][1] = "Error: Relative address exceeds module size; zero used";
					instr = opcode * 1000;
				}
				if (instr / 1000 >= 10) {
					memoryMap[memoryMapCount][1] = "Error: Illegal opcode; treated as 9999"; //error #11
					instr = 9999;
				}
				else {
					instr = instr + baseAddress;
				}
				memoryMap[memoryMapCount][0] = Integer.toString(instr); //relative case, absolute address = relative + base
			}
			else if (instructionType.compareTo("E") == 0) {
				if (instr / 1000 >= 10) {
					memoryMap[memoryMapCount][1] = "Error: Illegal opcode; treated as 9999"; //error #11
					instr = 9999;
				}
				else {
					String operandSymbol = null;
					if (operand > useList.size() - 1) {
						memoryMap[memoryMapCount][1] = "Error: External address exceeds length of uselist; treated as immediate";
						memoryMap[memoryMapCount][0] = Integer.toString(instr); 
					}
					else {
						operandSymbol = useList.get(operand); //get symbol in index[operand] of useList	
						moduleUsedList.add(operandSymbol);
						if (checkSymbolInTable(operandSymbol) == false) {
							memoryMap[memoryMapCount][1] = "Error: " + operandSymbol + " is not defined; zero used"; //error #3
							operand = 0;
							memoryMap[memoryMapCount][0] = Integer.toString((opcode * 1000) + operand);
						}
						else {
							for (int i = 0; i < symbolTableRow; i++) {
								if (operandSymbol.compareTo(symbolTable[i][0]) == 0) { //look for symbol's global address in symbolTable
									operand = Integer.parseInt(symbolTable[i][1]);
									memoryMap[memoryMapCount][0] = Integer.toString((opcode * 1000) + operand);
								}
							}
						}
					}
				}
			}
			memoryMapCount++;
		}
	}
}
