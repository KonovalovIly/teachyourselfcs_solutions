# Chapter 7 Linking
[[Practice Problems 7]]
What linking process is
7.1 Compiler Drivers
	Arguments for compiler to control linking
7.2 Static Linking
	Applying to your code anouther libraries
7.3 Object Files
	What ELF relocatable object file is
7.4 Relocatable Object Files
	What contains in this file
7.5 Symbols and Symbol Tables
	Important information for linker for distinguish functions
7.6 Symbol Resolution
	How symbols link work
	7.6.1 How Linkers Resolve Duplicate Symbol Names
		How linker play around same names in different modules
	7.6.2 Linking with Static Libraries
		Commands for linking static libraries
	7.6.3 How Linkers Use Static Libraries to Resolve References
		Algorithm of evaluating links
7.7 Relocation
	After all information grouped linker starting relocation sections in one file
	7.7.1 RelocationEntries
		How relocation entry store information
	7.7.2 RelocatingSymbolReferences
		How is the algorithm of relocation work
7.8 Executable Object Files
	What executable file contain
7.9 Loading Executable Object Files
	Loading executable file in virtual memory
7.10 Dynamic Linking with Shared Libraries
	Difference between static and dynamic linking
7.11 LoadingandLinkingSharedLibraries from Applications
	The way that we can use dynamic libraries
7.12 Position-Independent Code (PIC)
	Dynamic libraries stored in PLT and GOT
7.13 Library Interpositioning
	We can replace the lib call to our function call to trace metrics
	7.13.1 Compile-Time Interpositioning
		Usage in compile time
	7.13.2 Link-Time Interpositioning
		Wrap argument
	7.13.3 Run-TimeInterpositioning
		Replacing for dynamic linking
7.14 Tools for Manipulating Object Files
	Command for linker management
7.15 Summary
	Different linking phases and how it can be useful