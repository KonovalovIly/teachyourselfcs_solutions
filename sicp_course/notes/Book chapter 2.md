
# **Word list:**
- data abstraction
- compound data
- conventional interfaces
- symbolic expressions
- data- directed programming
- selectors
- constrictors
- pair
- abstraction barriers
- conventional interfaces.
- frame coordinate map
- stratified design
- quote
- type-tag and contents
- dispatching on type
- data- directed programming

# 2. Building abstractions with data
[[Lecture 2B]]
In this chapter we will know how use functions as glue for combining data in more complex representation
- 2.1 Introduction to Data Abstraction
	In our programs, we need to manipulate data not like concrete something, but like abstract one!
	- 2.1.1 Example: Arithmetic Operations for Rational Numbers
		Creating basic data structure for rational numbers using pair
	- 2.1.2 Abstract Barrier
		We use abstraction barrier for easy code maintaining.
	- 2.1.3 What Is Meant by Data?
		Data is just lambda function under the hood
	- 2.1.4 Extended Exercise: Interval Arithmetic
		Example of using data structures for interval integers
- 2.2 Hierarchical Data and the Closure Property
	[[Lecture 3A]]
	We have different ways to construct compound data of multiple cons.
	- 2.2.1 Representing Sequences
		Sequence is chains of pairs with last null element. But we can use another form for represent that things, list key word.
	- 2.2.2 Hierarchical Structures
		As another data structure, we can use tree. It is list of lists with root and leaves
	- 2.2.3 Sequences as Conventional Interfaces
		Operation on tree and leaf's as sequences
	- 2.2.4 Example: A Picture Language
		Example of how abstraction barriers work in programming. This example was builded up on picture language 
- 2.3 Symbolic Data
		[[Lecture 3B]]
		Ability to work with symbolic data
	- 2.3.1 Quotation
		For using symbols as data we needed to add quoter before structure
	- 2.3.2 Example: Symbolic Differentiation
		[[Lecture 4A]]
		Describes how we can write program to solve deriv problem, and how we can construct program for correct output
	- 2.3.3 Example: Representing Sets
	    How we can implement set, in some different ways, and why it is important.
	- 2.3.4 Example: Huffman Encoding Trees
	    Example of simple encoding for low memory usage 
- 2.4 Multiple Representations for Abstract Data
		[[Lecture 4B]]
		How we can create functions for different data type using tags
	- 2.4.1 Representations for Complex Numbers
		When we design complex programs  with many developers whey can build this implementation on different base of arithmetic operations. And without generic types it will be hard to coordinate with each other.
	- 2.4.2 Tagged data
		Its basically pair of tag and content. And in generic functions we just extract tag and decide what we should do.
	- 2.4.3 Data-Directed Programming and Additivity
		How we can manage all functions in table system for easy usage
- 2.5 Systems with Generic Operations
		In this chapter we will use the same idea not only to define operations that are generic over different representations but also to define operations that are generic over different kinds of arguments. How we construct different operation under one interface 
	- 2.5.1 Generic Arithmetic Operations
		Under the hood of generic put
	- 2.5.2 Combining Data of Different Types
		Hierarchical structure in inheritance of generic types
	- 2.5.3 Example: Symbolic Algebra
		How we can implement polynomial operations