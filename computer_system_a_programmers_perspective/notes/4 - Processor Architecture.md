# Chapter 4  Processor Architecture
[[Practice Problems 4]]
We will have close look at hardware system, implement our own like x86-64. Look closer at pipelining and ISA 
4.1 The Y86-64 Instruction Set Architecture
	Base instruction set what we need 
	4.1.1 Programmer-Visible State
		Same registers set and they functionals
	4.1.2 Y86-64 Instructions
		Base sets of instructions which we will implement
	4.1.3 Instruction Encoding
		How instructions convert to machine code. And they encoding
	4.1.4 Y86-64 Exceptions
		Status codes which shows to us how program executing correct or not
	4.1.5 Y86-64 Programs
		Example of program 
	4.1.6 Some Y86-64 Instruction Details
		Convention about push operation order
4.2 Logic Design and the Hardware Control Language HCL
	Close look at HCL, and hardware level
	4.2.1 Logic Gates
		Smallest part of processor
	4.2.2 Combinational Circuits and HCL Boolean Expressions
		How we can combine gates for new behavior
	4.2.3 Word-Level Combinational Circuits and HCL Integer Expressions
		Switch case for word combination
	4.2.4 Set Membership
		If we need to compare with multiple nums we can use in {1, 2} structure
	4.2.5 Memory and Clocking
		How we can store memory and access them
4.3 Sequential Y86-64 Implementations
	Our first processer implementation will be just sequential.
	4.3.1 Organizing Processing into Stages
		Mechanism of decoding instructions
	4.3.2 SEQ Hardware Structure
		Abstract structure of our processor 
	4.3.3 SEQ Timing
		How processor will work by stages of cycle
	4.3.4 SEQ Stage Implementations
		Superficial look at seq processor 
4.4 General Principles of Pipelining
	What is pipelining?
	4.4.1 Computational Pipelines
		Throughput will increase when we use pipeline
	4.4.2 A Detailed Look at Pipeline Operation
		Close look at stages in pipelining
	4.4.3 Limitations of Pipelining
		Negative sides of pipelining
	4.4.4 Pipelining a System with Feedback
		Feedback after processing stage
4.5 Pipelined Y86-64 Implementations
	How pipeline fit in our system
	4.5.1 SEQ+: Rearranging the Computation Stages
		We need move PC stage to start
	4.5.2 Inserting Pipeline Registers
		After each stage we put registers
	4.5.3 Rearranging and Relabeling Signals
		Feedback system
	4.5.4 Next PC Prediction
		How our pc should get new line of code for fatcher
	4.5.5 Pipeline Hazards
		Data hazards on write solved by forwarding and for read bubbling and forwarding. Control hazards bubbling and predicting what should be next. And if we miss predict we should throw away it part
	4.5.6 Exception Handling
		We define order for error handling
	4.5.7 PIPE Stage Implementations
		We implement stages for PIPE
	4.5.8 Pipeline Control Logic
		We add handler for bubbling and stall 
	4.5.9 Performance Analysis
	4.5.10 Unfinished Business
4.6 Summary
	4.6.1 Y86-64 Simulators