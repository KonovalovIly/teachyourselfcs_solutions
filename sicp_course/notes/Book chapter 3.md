# **Word list:**
- modular
- objects
- streams
- environment model
- delayed evaluation 
- state variables
- local state variables 
- assignment operator
- referentially transparent
- imperative programming


# 3. Modularity, Objects and State
[[Lecture 5A]]
We will look at two different data organization for large system. Object oriented and stream oriented 
- 3.1 Assignment and local state
    If we talking about objects , we now that they have state.
    - 3.1.1 Local state variables 
	    We can use set! for updating value inside functions for easy state management.
    - 3.1.2 The Benefits of Introducing Assignment
		In some ways inner function incapsulate inner logic inside the function
    - 3.1.3 The Costs of Introducing Assignment
	    It way more complex than functional. Because functions no more return the same result 
-  3.2 The Environment Model of Evaluation
	How variables stored in environment, and how we can shadowed variables from upper environment. 
	- 3.2.1 The Rules of Evaluation
		Structure of creating variable in environment.
	- 3.2.2 Applying Simple Procedures
		We can use variable and operations in upper environment level.
	- 3.2.3 Frames as Repository of Local State
		How local states stored in this environment structure.
	- 3.2.4 Internal Definitions
		Examples of what seen from inner environment
- 3.3 Modeling with Mutable Data
	[[Lecture 5B]]
	Mutation on pairs
	- 3.3.1 Mutable List Structure
		Described how using set-car and set-cdr to mutate data
	- 3.3.2 Representing Queues
		Representing queue depend on pair mutation with pointer on start and end
	- 3.3.3 Representing Tables
		Representing tables like Hash Table 
	- 3.3.4 A Simulator for Digital Circuits
		This chapter about simulation logical gates in our program. How usually we can construct logical boxes in huge program.
	- 3.3.5 Propagation of Constraints
		Building unidirectional data flow operations.
- 3.4 Concurrency: Time Is of the Essence
	Building separated things because of concurrent computations.
	- 3.4.1 The Nature of Time in Concurrent Systems
		Why it matter build programs depend on concurrency
	- 3.4.2 Mechanisms for Controlling Concurrency
		Serializer, mutex semaphore and other mechanism for controlling concurrency 
- 3.5 Stream
	[[Lecture 6A]]
	What we can use for really long operations on the list
	- 3.5.1 Streams Are Delayed Lists
		Describe advantages streams on the list and how we can build streams using pair
	- 3.5.2 Infinite Streams
		Eratosthenes sieve algorithm 
	- 3.5.3 Exploiting the Stream Paradigm
		The **stream paradigm** enables elegant, modular, and efficient signal processing
	- 3.5.4 Streams and Delayed Evaluation
		We can circle steam to them self but we should use delay for evaluation 
	- 3.5.5 Modularity of Functional Programs and Modularity of Objects
		Advantages of stream and objects 