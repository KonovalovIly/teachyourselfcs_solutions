
# **Word list:**
- computational process
- data
- program
- programming languages
- bugs, glitches
- debug
- recursion equations
- interpreter
- procedures
- expression
- evaluating
- combinations
- operands, operator
- arguments
- prefix notation
- variable, value
- define
- environment
- recursive
- tree accumulation
- clauses
- recursive process
- linear recursive process
- iterative process
- tail-recursive
- tree recursion
- congruent modulo
# 1. Building Abstractions with Procedures
Start of this Chapter tell us about programming and why we use Lisp in this book
- 1.1 The elements of Programming
	[[Lecture 1A]]
	Tell about parts witch build programming language 
	- 1.1.1 Expressions
		Lisp used prefix notation
	- 1.1.2 Naming and the Environment
		Key word define make connection between variable and value 
	- 1.1.3 Evaluating Combinations
		How procedures used tree accumulation
	- 1.1.4 Compound Procedures
		We can define functions like this: (define ({name} {variable}) {body})
	- 1.1.5 The substitution model for procedure application
		How compound procedures work inside
	- 1.1.6 Conditional expressions and predicates
		We can use *cond* and *if else* special words for building conditional expressions.
	- 1.1.7 Example: Square roots by newton method
		How search square root used iteration.
	- 1.1.8 Procedures as Black-Box abstraction
		All procedures needed to be black box. We need only input, process inside procedure not important. 
- 1.2 Procedures and the Processes They Generate
	[[Lecture 1B]]
	At 1.1 we learned the basic rules, starting from now we will learn patterns, use cases and so on.
	- 1.2.1 Linear Recursion and Iteration
		We can use two ways to define iteration. One is recursive processing when stack grow and shrimp. And the second iterative processing, it is just iteration without stack manipulation.
	- 1.2.2 Tree Recursion
		Simple example of tree recursion is Fibonacci numbers.
		Tree recursion when functions invoke itself more then one times.
		Describes how we can use tree recursion for counting change.
	- 1.2.3 Orders of Growth
		How we can represent complex and recourse usage from mathematic
	- 1.2.4 Exponentiation
		Example of optimization on exponentiation computing via iterating 
	- 1.2.5 Greatest Common Divisors 
		Euclid algorithm for GCD
	- 1.2.6 Example: Testing for Primality
		Fermat test for funding Primary number
- 1.3 Formulating Abstractions with Higher-Order Procedures
	[[Lecture 2A]]
	When function return or enter another function it called high-ordered functions
	1.3.1 Procedures of arguments
		We can pass function to argument in other function and use them inside
	1.3.2 Constructing procedures using lambda
		Using lambda and let for more readable code
	1.3.3 Procedures as General Method
		Examples of using higher-order functions
	1.3.4 Procedures as Returned value
		Some procedures may return another procedures