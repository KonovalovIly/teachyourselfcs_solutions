# Topics
🔄 Stream programming enables on-demand computation of infinite data sequences.
⚙️ The Sieve of Eratosthenes elegantly demonstrates prime number streams via recursion and filtering.
➕ Element-wise stream operations allow defining complex sequences like Fibonacci numbers.
⏳ Lazy evaluation with delayed stream processing resolves recursive definitions and dependency issues.
🌀 Normal-order evaluation permits elegant lazy computations but complicates iteration and state management.
🧩 Pure functional programming models avoid side effects yet face challenges modeling state and concurrency.
🔀 Handling concurrent streams, such as bank transactions, requires mechanisms like fair merging to manage timing.

# Summary
The lecture explores the principles and applications of stream programming within signal processing and functional programming paradigms. Central to stream programming is decoupling the order of expression evaluation from actual computation, enabling the creation and manipulation of potentially infinite streams that produce elements on demand. The professor demonstrates this by constructing infinite integer streams via recursion, filtering them (e.g., removing multiples of seven), and generating prime numbers through the Sieve of Eratosthenes. This showcases the power of lazy evaluation, where computation happens only when results are needed, creating elegant and efficient data structures.

Beyond element-wise access, the lecture introduces operations on entire streams, such as element-wise addition and scaling, facilitating the definition of complex infinite streams like Fibonacci sequences. The professor highlights the challenges of recursive definitions, especially when handling integrals or differential equations, and proposes the introduction of delays (lazy evaluation) to manage these complexities. He suggests that transforming the language to treat all procedures as streams, with deferred argument evaluation, could simplify the management of self-referential and dependent computations.

The lecture also delves into evaluation strategies—normal-order versus applicative-order—and their impact on program behavior and state management. Normal-order evaluation, which defers computation until necessary, simplifies expression of infinite structures and lazy computations, as exemplified by the language Miranda. However, this approach complicates iterative constructs, state handling, and debugging, especially in the presence of side effects, making it unsuitable for interactive or imperative-style programming.

A discussion on purely functional programming emphasizes its mathematical purity and avoidance of synchronization issues but acknowledges difficulties in managing local state and side effects. Through examples like random number generation and bank account simulations, the lecture illustrates how functional programming can model state using streams and modular design.

Finally, the professor addresses the complexity of real-world concurrent scenarios (e.g., joint bank accounts with multiple users), where transaction timing and order affect system behavior. The need for techniques such as “fair merge” of transaction streams highlights the ongoing tension between delayed evaluation and managing stateful, side-effecting objects in functional programming. The lecture concludes acknowledging that while extensions to functional languages can partially address these challenges, they remain open problems in computer science.

## Sieve of Eratosthenes
``` lisp
(define (sieve s)
	(cons-stream
		(head s)
		(sieve 
			(filter
				(lambda (x)
					(not (divisible? x (head s)))
				)
				(tail s)
			)
			
		)
	)
)

(define primes 
	(sieve (integers-from 2))
)
```


Function what add s1 and s2
``` lisp
(define (add-streams s1 s2)
	(cond 
		((empty-stream? s1) s2)
		((empty-stream? s2) s1)
		(else
			(cons-stream
				(+ (head s1) (head s2)
					(add-streams (tail s1) (tail s2))
				)
			)
		)
	)
)
```


## Integral

![](https://i.imgur.com/aTrNo3a.png)


Normal-order evaluation Vs applicative-order

Normal-order means what function doesn\`t evaluate when it called. It evaluate only in the moment when we need result of that function. We can store many functions, we can put functions inside other functions. And result all of the manipulation was applied then we call them. 

Functional programming
Always get a result a function when we call them. 

# Key Insights
🔍 Lazy Evaluation Enables Efficient Stream Processing: By separating the order of computation from expression order, lazy evaluation allows defining infinite streams without immediate evaluation. This approach saves computation and memory, making streams a powerful abstraction for representing unbounded data, such as numbers or primes.
🎯 Recursive Definitions Require Careful Management: Defining streams recursively, especially for signals or differential equations, can lead to infinite loops or premature evaluation. Introducing delays to defer stream computation until necessary solves this, enabling self-referential definitions that are otherwise problematic in strict languages.
⚖️ Trade-offs Between Evaluation Strategies: Normal-order evaluation supports lazy computations and infinite data structures but complicates stateful programming, increasing the proliferation of deferred computations (“promises”) and making debugging harder. Conversely, applicative-order (eager) evaluation simplifies reasoning about state but lacks the elegance of infinite, on-demand structures.
🔄 Functional Programming’s Dual Nature for State: Pure functional languages avoid mutable state and side effects, providing a clean mathematical framework. However, modeling real-world stateful scenarios—such as sequences of transactions—demands inventive designs like streams and modularity to simulate state evolution without assignment.
🔃 Concurrency and Timing Complicate Functional Models: Multi-user interactions and asynchronous events require mechanisms to merge event streams fairly and maintain consistent state despite non-deterministic ordering, exposing fundamental tensions in purely functional models of time and state.
🤝 Potential Language Evolution to Simplify Lazy Streams: Proposing that all procedures behave as streams with deferred argument evaluation could unify programming paradigms, easing management of recursive and dependent streams in complex systems by implicitly handling delays and evaluation timing.
⚠️ Side Effects Challenge Laziness and State Control: Integration of side effects with lazy evaluation introduces unpredictability, complicating debugging and program correctness. This limitation suggests functional languages may need restricted or specialized mechanisms to handle effects in the presence of lazy computation.
