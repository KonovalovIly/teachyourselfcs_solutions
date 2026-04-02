# Chapter 3  Machine-Level Representation of Programs
[[Practice Problems 3]]
In this chapter we cover our knowledge about machine-level code. It is important because of reverse engineering skills and how you can avoid attacks on your code 
	3.1 A Historical Perspective
		How x86 architecture grow from history perspective.
	3.2 Program Encodings
		What happened when we use gcc compiler
		3.2.1 Machine-Level Code
			How code stored in memory and what it can do
		3.2.2 Code Examples 
			Example of disassembling simple mul program
		3.2.3 Notes on Formatting
			Some description about example code
	3.3 Data Formats
		Different data formats and how much memory is they take.
	3.4 Accessing Information
		In x86 processors type have 16 registers like in RISK
		3.4.1 Operand Specifiers
			Base operands with registers and memory access
		3.4.2 Data Movement Instructions
			Base instructions for moving data between registers and memory
		3.4.3 Data Movement Example
			Example c code for look at move operations
		3.4.4 Pushing and Popping Stack Data
			Operations on stack
	3.5 Arithmetic and Logical Operations
		Simple operations for data manipulation
		3.5.1 Load Effective Address
			Complicated function witch make calculations and do move operation
		3.5.2 Unary and Binary Operations
			Operations where source and destination is the same place
		3.5.3 Shift Operations
			Left and right shift operations
		3.5.4 Discussion
			Some discussion about two-compliment numbers
		3.5.5 Special Arithmetic Operations
			Multiply function for 128 bit result
	3.6 Control
		We introduced in conditional executions
		3.6.1 Condition Codes
			Condition codes for flags. And compare and test instructions
		3.6.2 Accessing the Condition Codes
			Operations after compare for setting bit into register depend on flag
		3.6.3 Jump Instructions
			Set of instructions witch change line execution flow 
		3.6.4 Jump Instruction Encodings
			How labels in final linking executing to result bits
		3.6.5 Implementing Conditional Branches with Conditional Control
			We can change the flow of program executing. Make branching and conditional states
		3.6.6 Implementing Conditional Branches with Conditional Moves
			Another way to implement conditions is process both variance and after it with cmov command compute right decision.
		3.6.7 Loops
			How we can create loops in assembler using cycles
		3.6.8 Switch Statements
			Better way to do multiple if else expressions
	3.7 Procedures
		Procedures is help for us to split program on logical parts
		3.7.1 The Run-Time Stack
			What stored in stack
		3.7.2 Control Transfer
			How we can call procedures and return back control
		3.7.3 Data Transfer
			How we can pass data into another procedure
		3.7.4 Local Storage on the Stack
			When we need to provide pointer to some variable we can put this one in stack
		3.7.5 Local Storage in Registers
			We have callee and caller saved registers. Callee saved registers you need to store at start of your procedures and restore after. Caller saved only before calling another procedures
		3.7.6 Recursive Procedures
			How we can call procedure inside itself
	3.8 Array Allocation and Access
		Chapter about array implementation in machine code
		3.8.1 Basic Principles
			We allocate n \* m memory. N items count, m single element size
		3.8.2 Pointer Arithmetic
			How we can access elements if we just have start point
		3.8.3 Nested Arrays
			Array Inside Array 
		3.8.4 Fixed-Size Arrays
			Вest practice for array creation
		3.8.5 Variable-Size Arrays
			Best practice for optimization compile time created arrays
	3.9 Heterogeneous Data Structures
		How structures stored in memory
		3.9.1 Structures
			How we hold structures in memory
		3.9.2 Unions
			We can use unions for creating 
		3.9.3 Data Alignment
			In most part of processors recommended to use align data that have gaps between little fields and large. 
	3.10 Combining Control and Data in Machine-Level Programs
		How data control and data communicate
		3.10.1 Understanding Pointers
			What is pointers and how we can use them in C
		3.10.2 Life in the Real World: Using the gdb Debugger
			Debugging C programms
		3.10.3 Out-of-Bounds Memory References and Buffer Overflow
			What may happened if we will point Out-of-Bounds array
		3.10.4 Thwarting Buffer Overflow Attacks
			Three ways to thwarting buffer overflow attack 
		3.10.5 Supporting Variable-Size Stack Frames
			How supported Variable-Size feature
	3.11 Floating-Point Code
		For floating point operations we have another sets of registers
		3.11.1 Floating-Point Movement and Conversion Operations
			How we can move floating point values into int registers and back
		3.11.2 Floating-Point Code in Procedures
			How they passed in arguments and as return value
		3.11.3 Floating-Point Arithmetic Operations
			Arithmetic operations for floating point
		3.11.4 Defining and Using Floating-Point Constants
			We cant create float values like immediate values. We need to allocate in memory these values for low order and high order
		3.11.5 Using Bitwise Operations in Floating-Point Code
			Bitwise operations
		3.11.6 Floating-Point Comparison Operations
			Jump operations the same like for integers, comparation different.
		3.11.7 Observations about Floating-Point Code
			Conclusion about floating point
	3.12 Summary
		We unhide realization how code from c look in machine code level.