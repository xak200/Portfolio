# Operating Systems

Linker Lab:

This assignment uses Java to implement a two-pass linker. The program takes one input parameter which is the name of an input 
file to be processed. We assume a target machine with the following properties: (a) word addressable, (b) addressable memory of 
512 words, and (c) each word consisting of 4 decimal digits. The input to the linker is a file containing a sequence of tokens. 
The linker processes the input twice: 
- pass 1 parses the input and verifies the correct syntax and determines the base address for each module and the absolute 
address for each defined symbol, storing the latter in a symbol table. 
- pass 2 again parses the input and uses the base addresses and the symbol table entries created in pass one to generate 
the actual output by relocating relative addresses and resolving external references.


-----------------


Virtual Memory Management Lab:

This assignment uses C++ to implement/simulate the virtual memory operations that map a virtual address space comprised of 
virtual pages onto physical page frames. The size of the virtual space is 64 virtual pages. The number of physical page frames 
varies and is specified by an option, but is assumed to have to support up to 64 frames. The input to your program will be a 
sequence of “instructions” and optional comment line. 

I implemented seven algorithms:
- NRU (Not recently used)
- LRU (Least recently used)
- Random
- FIFO
- Second Chance
- Clock
- Aging