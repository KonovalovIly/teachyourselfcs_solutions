#### **1. Recursive Factorial**
**Code**:
```scheme
(define (factorial n)
  (if (= n 1)
      1
      (* n (factorial (- n 1)))))
```

**Environment Structure for `(factorial 6)`**:
1. **Global Environment**:
   - `factorial`: → `(lambda (n) ...)`
2. **Recursive Calls** (each creates a new frame):
   - `(factorial 6)` → `E1`: `n = 6`
     - Waits for `(factorial 5)`.
   - `(factorial 5)` → `E2`: `n = 5`
     - Waits for `(factorial 4)`.
   - ...  
   - `(factorial 1)` → `E6`: `n = 1`
     - Returns `1`.
   - Unwinds: `(* 2 1)` → `(* 3 2)` → ... → `(* 6 120)` → `720`.

**Visualization**:
```
Global
│
├─ factorial
└─ E1 (n=6) → E2 (n=5) → E3 (n=4) → ... → E6 (n=1)
   (Pending (* n ...))    (Pending (* n ...)) 
```

**Key Points**:
- **Space Complexity**: O(n) (linear due to deferred operations).
- **Frames**: Grow with `n` (stack frames accumulate).

---

#### **2. Iterative Factorial**
**Code**:
```scheme
(define (factorial n)
  (fact-iter 1 1 n))

(define (fact-iter product counter max-count)
  (if (> counter max-count)
      product
      (fact-iter (* counter product)
                 (+ counter 1)
                 max-count)))
```

**Environment Structure for `(factorial 6)`**:
1. **Global Environment**:
   - `factorial`: → `(lambda (n) (fact-iter 1 1 n))`
   - `fact-iter`: → `(lambda (product counter max-count) ...)`
2. **Iterative Calls** (tail-recursive, reuse frame):
   - `(factorial 6)` → Calls `(fact-iter 1 1 6)` in `E1`.
   - `(fact-iter 1 1 6)` → `E1`: `product=1, counter=1, max-count=6`
     - Updates: `product=1`, `counter=2`.
   - `(fact-iter 1 2 6)` → Same `E1` (tail call optimized).
     - Updates: `product=2`, `counter=3`.
   - ...  
   - `(fact-iter 720 7 6)` → Returns `720`.

**Visualization**:
```
Global
│
├─ factorial
├─ fact-iter
└─ E1 (product, counter, max-count) 
   (Reused for each iteration)
```

**Key Points**:
- **Space Complexity**: O(1) (constant space, single frame reused).
- **Tail Recursion**: No deferred operations; state passed via arguments.

---

### **Comparison**
| Feature          | Recursive Factorial          | Iterative Factorial          |
|------------------|-------------------------------|-------------------------------|
| **Frames**       | O(n) (grows with `n`)         | O(1) (single frame reused)    |
| **State**        | Stored in pending operations  | Passed explicitly in args     |
| **Efficiency**   | Less efficient (stack usage)  | More efficient (tail call)    |

### **Why It Matters**
- **Recursive**: Simpler to write but limited by stack depth.
- **Iterative**: Scalable for large `n` (Scheme optimizes tail calls).

This shows how **environment structures** differ even when computing the same result! 🔄