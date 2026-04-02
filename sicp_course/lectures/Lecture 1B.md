# Topics
- Substitution Model 🧼
- Sum of square 🟥
- Evaluation ➕
- Conditional 
- primitive operations
- Intuition
- Recursion
- Iteration
- Circle drawing 🔴
- Fibonacci
- The Tower of Hanoi
# Detail
```lisp
(define (sos x y)
	(+ (sq x) (sq y)))
	
(define (sq x)
	(* x x))
```

Kings of expressions:
	Numbers
	Symbols
	Lambda-expressions
	Definitions
	Conditionals
	Combinations

### Substitution Rule

To evaluate an application
Evaluate the operator to get procedure
Evaluate the operands to get arguments
	Apply the procedure to the arguments
		Copy the body of the procedure. substituting the arguments supplied for formal parameters of the procedure
	Evaluate the ruling new body

sos - procedure
(+ (sq x) (sq y))) - body of procedure
(sq x) - operand

```Lisp
(if 
	<Predicate> 
	<Consequent>
	<Alternative>
)
```

### Conditionals

To elevation an If expression:
	Evaluate the predicate expression
		If it yields TRUE:
			evaluate the consequent expression
		otherwise:
			evaluate the alternative expression


### Iteration 
Time = O(x)
Space = O(1)

### Recursion
Time = O(x)
Space = O(x)

```lisp
(define (fib N)
	(if (< N 2) 
		N
		(+ (fib (- N 1)
			(fib(- N 2))))
	)
)
```

Time complexity = O(fib(N))
Space complexity = O(N)

### The Towers of Hanoi
The base case of this problem is to move n high tower from spike called from to spike called too, with help by spike called spare.

```lisp
	(define (move N from to spare)
		(cond ((= N 0) "Done")
			(else 
				(move (- 1 N) from spare to)
				(print move from to)
				(move (- 1 N) spare to from)
			)
		)
	)
```

