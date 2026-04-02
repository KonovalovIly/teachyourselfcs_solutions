### Environment Diagram for `(memo-fib 3)`

Let's analyze the computation step by step, showing the environment structure:

1. **Initial Setup**:
   ```
   Global Env:
     memoize: <procedure>
     memo-fib: <memoized procedure> (with env E1)
     E1: f: <original fib procedure>
         table: initially empty
   ```

2. **First Call: (memo-fib 3)**:
   - Checks table for 3 → not found
   - Computes (+ (memo-fib 2) (memo-fib 1))
   - Table after computation: {3: 2}

3. **Recursive Call: (memo-fib 2)**:
   - Checks table for 2 → not found
   - Computes (+ (memo-fib 1) (memo-fib 0))
   - Table updates: {2: 1, 3: 2}

4. **Base Cases**:
   - (memo-fib 1) → returns 1 (stores in table)
   - (memo-fib 0) → returns 0 (stores in table)

5. **Final Table State**:
   ```
   E1's table: {0: 0, 1: 1, 2: 1, 3: 2}
   ```

### Why O(n) Time Complexity

1. **Memoization Effect**:
   - Each Fibonacci number from 0 to n is computed exactly once
   - Subsequent lookups take constant time

2. **Computation Pattern**:
   - For (memo-fib n), it computes:
     - (memo-fib (- n 1)) → new computation
     - (memo-fib (- n 2)) → already cached
   - Forms a linear chain of n computations

3. **Visualization**:
   ```
   (memo-fib 3)
   ├── (memo-fib 2)*
   │   ├── (memo-fib 1)* → cached after first call
   │   └── (memo-fib 0)* → cached after first call
   └── (memo-fib 1) → retrieved from cache
   ```
   (* indicates first computation and caching)

### Why `(memoize fib)` Wouldn't Work

1. **Problem with Direct Memoization**:
   ```scheme
   (define memo-fib (memoize fib))
   ```
   - The original `fib` calls itself (non-memoized version)
   - Memoization only happens at the top level
   - Recursive calls bypass the memoization table

2. **Execution Pattern**:
   - (memo-fib 3) checks table → computes (fib 3)
     - (fib 3) calls (fib 2) and (fib 1) directly
     - These internal calls aren't memoized
   - Results in O(φⁿ) time like original fib

3. **Environment Diagram Difference**:
   ```
   Global Env:
     fib: <original procedure>
     memo-fib: <memoized wrapper> (env E1)
     E1: f: fib
         table: only stores top-level calls
   ```
   - Internal fib calls don't go through memo-fib
   - No caching of intermediate results

### Correct Approach Requirements

For proper memoization:
1. Recursive calls must go through the memoized procedure
2. The procedure must call its memoized self, not the original
3. Hence the need for the self-referential definition:
   ```scheme
   (define memo-fib
     (memoize (lambda (n)
                (cond ((= n 0) 0)
                      ((= n 1) 1)
                      (else (+ (memo-fib (- n 1))
                               (memo-fib (- n 2))))))))
   ```

### Key Insights

1. **Memoization Benefit**:
   - Transforms O(φⁿ) → O(n) time complexity
   - Uses O(n) space to store results

2. **Implementation Critical**:
   - Must ensure all recursive calls are memoized
   - Self-referential definition is crucial

3. **Visualizing Growth**:
   - Without proper memoization: tree recursion (exponential)
   - With proper memoization: linear chain of computations

This analysis shows why the specific implementation pattern is necessary for achieving the O(n) performance improvement in the Fibonacci computation.
