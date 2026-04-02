# **Word list:**


# 5.  Computing with Register Machines
We will implement Lisp on a register machine. And build decoder from lisp to instructions set.
	5.1 Designing Register Machines
	    Firstly we will design register machine
		[[Lecture 9A]]
		5.1.1 Language for Describing Register Machines
			First iteration of Lisp assembler
		5.1.2 Abstraction in Machine Design 
			Example of usage machine abstraction
		5.1.3 Subroutines 
			Store command line in register for next usage when you exit from subroutine
		5.1.4 Using a Stack to Implement Recursion 
			For saving arguments and pointer to label we use stack than recursion happened
		5.1.5 Instruction Summary
			Summary of lisp assembly
	5.2 A Register-Machine Simulator 
		Simulator of Lisp machine inside Lisp
		[[Lecture 9B]]
		5.2.1 The Machine Model
			Implementation of Lisp machine simulator 
		5.2.2 The Assembler 
			Assembler for simulator to machine code
		5.2.3 Generating Execution Procedures for Instruction
			Implementation of Assembler
		5.2.4 Monitoring Machine Performance 
			One of advantages using such simulator is opportunity to measure stack and register performance 
	5.3 Storage Allocation and Garbage Collection 
		[[Lecture 10A]]
		We will look at memory model and implementation of garbage collector
		5.3.1 Memory as Vectors
		    Memory system depend on vectors
		5.3.2 Maintaining the Illusion of Infinite Memory
	5.4 The Explicit-Control Evaluator 
		[[Lecture 10B]]
		We will implement interpretator for register machine 
		5.4.1 The Core of the Explicit-Control Evaluator
		    Eval apply function which separate input code on chunk's 
		5.4.2 Sequence Evaluation and Tail Recursion
		    How evaluate sequences and execute tail recursion
		5.4.3 Conditionals, Assignments, and Definitions
		    How this things holded in interpretator 
		5.4.4 Running the Evaluator
			Running the Evaluator
	5.5 Compilation
		Why compilation is more efficient than interpretation and what are its advantages
		5.5.1 Structure of the Compiler
			Structure overview
		5.5.2 Compiling Expressions
			How we process expressions
		5.5.3 Compiling Combinations
			Compiling function calls and managing operands
		5.5.4 Combining Instruction Sequences
			Combining instruction sequences efficiently
		5.5.5 An Example of Compiled Code
			Example: compiling a recursive factorial function
		5.5.6 Lexical Addressing
			Improving performance with lexical variable access
		5.5.7 Interfacing Compiled Code to the Evaluator
			Bridging compiled and interpreted code