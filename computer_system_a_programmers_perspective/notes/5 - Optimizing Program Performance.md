# Chapter 5  Optimizing Program Performance
[[Practice Problems 5]]
We should take care about optimization of program because it may tragically decrease our performance
5.1 Capabilities and Limitations of Optimizing Compilers
	Compiler has flags for optimizations but it isn't godlike and cant optimize some cases
5.2 Expressing Program Performance
	How we measure performance of program 
5.3 Program Example
	Example of list data structure and how optimization flag increase performance
5.4 Eliminating Loop Inefficiencies
	Show us tragically decreasing performance when we use loop nesting 
5.5 Reducing Procedure Calls
    If you want improve performance by accessing elements directly by pointer it may do opposite, decrease performance.
5.6 Eliminating Unneeded Memory References
    We can go away from writing to memory at every loop
5.7 Understanding Modern Processors
    Modern Processors has instruction-level parallelism.
    5.7.1 Overall Operation
        Two independent units (execute and instruction control) separate the responsibility
    5.7.2 Functional Unit Performance 
        Each Operation may have own execution unit for optimizing. And work of circuit designers is choose the right amount of this units.
    5.7.3 An Abstract Model Of Processor Operation 
        On data flow example of comp4 function we watched why it has this latency
5.8 Loop Enrolling
    At most cases it  not improve performance. And compiler can apply loop Enrolling at 3 level of optimization
5.9 Enhancing Parallelism
    Way to improve performance by parallelism 
    5.9.1 Multiple Accumulator
        We can accumulate different loop enrolling in different variables
    5.9.2 Re association Transformation
		Another way to optimize read / write from disk is change priority of operation 1 we make operation between memory values after with register.
5.10 Summary of Results for Optimizing Combining Code
	What we achieve by optimization
5.11 Some Limiting Factors
	When we reach the limit
	5.11.1 Register Spilling
		We have only 16 register and some of them special. It mean that is no improving performance by loop enrolling more than 10 because of stack operation with accumulator values
	5.11.2 Branch Prediction and Misprediction Penalties
		Sometimes we just lose performance by misprediction
5.12 Understanding Memory Performance
	How important memory performance in optimization 
	5.12.1 Load Performance
		Less load is better
	5.12.2 Store Performance
		How we should optimize store operation
5.13 Life in the Real World: Performance Improvement Techniques
	Advice that should attract your attention
5.14 Identifying and Eliminating Performance Bottlenecks
	How we can find bottlenecks 
	5.14.1 Program Profiling
		What we can use for help us
	5.14.2 Using a Profiler to Guide Optimization
		How we can fix issues
5.15 Summary
	We cover why we should attract our attention on performance in era when compiler can optimize your code