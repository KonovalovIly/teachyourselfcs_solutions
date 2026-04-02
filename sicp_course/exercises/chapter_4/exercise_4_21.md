### Solutions to Exercise 4.21

#### Part a: Factorial and Fibonacci Implementations

1. **Factorial Verification**:
   The given expression correctly computes factorials through self-application:

   ```scheme
   ((lambda (n)
      ((lambda (fact) (fact fact n))
       (lambda (ft k)
         (if (= k 1)
             1
             (* k (ft ft (- k 1)))))))
    10)  ; => 3628800 (10!)
   ```

2. **Fibonacci Implementation**:
   Here's the analogous Fibonacci implementation:

   ```scheme
   ((lambda (n)
      ((lambda (fib) (fib fib n))
       (lambda (fb k)
         (if (<= k 2)
             1
             (+ (fb fb (- k 1)) (fb fb (- k 2)))))))
    10)  ; => 55 (10th Fibonacci)
   ```

#### Part b: Mutual Recursion Implementation

The completed mutual recursion solution:

```scheme
(define (f x)
  ((lambda (even? odd?)
     (even? even? odd? x))
   (lambda (ev? od? n)
     (if (= n 0)
         true
         (od? ev? od? (- n 1))))
   (lambda (ev? od? n)
     (if (= n 0)
         false
         (ev? ev? od? (- n 1))))))
```

### Key Insights

1. **Self-Application Pattern**:
   - Procedures receive themselves as arguments
   - Enables recursion without `letrec` or named procedures
   - Works because lambda abstractions create closures

2. **Mutual Recursion**:
   - Each procedure takes both functions as arguments
   - Passes them along in recursive calls
   - Maintains reference to both functions

3. **Evaluation Order**:
   - The outer lambda immediately applies the functions
   - Inner lambdas handle the actual logic
   - All calls maintain proper function references

### How It Works

For the Fibonacci example:
1. The outer lambda takes `n`
2. The inner `fib` lambda gets applied to itself and `n`
3. Each recursive call passes `fib` to itself
4. The base case stops the recursion

For the mutual recursion:
1. Both `even?` and `odd?` are defined as lambdas
2. Each takes references to both functions
3. They call each other by passing along these references
4. The initial call kicks off the evaluation

This technique demonstrates the power of lambda calculus and self-application in implementing recursion without relying on special forms or definitions.
