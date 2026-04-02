# **Word list:**
- Metalinguistic abstraction
- normal-order evaluation
- nondeterministic computing
- logic-programming
- metacircular
- syntax

# 4.  Metalinguistic Abstraction
In this chapter we will implement our dialect for scheme
	4.1 The Metacircular Evaluator
		[[Lecture 7A]]
		Metacircular is evaluator witch written on the same language that it.
		4.1.1 The Core of the Evaluator
			Implementation of eval and apply functions
		4.1.2 Representing Expressions
			Other expressions for eval
		4.1.3 Evaluator Data Structures
			Understanding environments is crucial for managing scope and state in interpreters and compilers.
		4.1.4 Running the Evaluator as a Program
			This section demonstrates how to turn the theoretical evaluator into a practical tool.
		4.1.5 Data as Programs 
			Lisp’s homoiconicity (code == data) enables powerful reflective and metaprogramming capabilities.
		4.1.6 Internal Definitions
			Proper handling of internal definitions reveals subtleties in lexical scoping and evaluation order.
		4.1.7 Separating Syntactic Analysis from Execution
			Optimizing interpreters involves separating parsing/analysis from execution to avoid redundant work.
	4.2 Variations on a Scheme — Lazy Evaluation
	    [[Lecture 7B]]
	    We will look at laziness interpretation in our scheme dialect
		4.2.1 Normal Order and Applicative Ord
		    Scheme is applicative order language, but what advantages of using normal order language.
		4.2.2 An Interpreter with Lazy Evaluation 
		    How implement lazy evaluation 
		4.2.3 Streams as Lazy Lists
		    We can build streams on a lambda functions
	4.3 Variations on a Scheme — Nondeterministic Computing
    	We will build nondeterministic function arc in our interpreter
		4.3.1 Amb and Search 
		    amb it is tool from scheme for nondeterministic (random) choice 
		4.3.2 Examples of Nondeterministic Program
		    Two examples of usage, first basic program for finding some case. And natural language parser
		4.3.3 Implementing the amb Evaluator 
		    Implementing of amb features in our dialect
	4.4 Logic Program
		[[Lecture 8A]]
		[[Lecture 8B]]
		We will build query language based on contemporary logic programming languages
		4.4.1 Deductive Information Retrieval 
			Base overview on a query language 
		4.4.2 How the Query System Works
		    Frames flow in query system
		4.4.3 Is Logic Programming Mathematical Logic? 
		    On the first view they look same, but they affect different 
		4.4.4 Implementing the Query System 
		    Let's implement query lang in lisp
			4.4.4.1 The Driver Loop and Instantiation
			    Infinite loop for evaluating command
			4.4.4.2 The Evaluator
				Evaluation part which separate queries and process them 
			4.4.4.3 Finding Assertions by Pattern Matching
			    Using pattern matching for equally data - query 
			4.4.4.4 Rules and Unification
			    Unifications for new rules
			4.4.4.5 Maintaining the Data Base
			    Storing in streams by key
			4.4.4.6 Stream Operations 
			    New streams operations
			4.4.4.7 Query Syntax Procedure
			    Additional procedures
			4.4.4.8 Frames and Bindings
			    Description of frames