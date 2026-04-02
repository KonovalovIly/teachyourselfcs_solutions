### **Exercise 2.63: Binary Tree to List Conversion**

#### **Given Procedures**
```scheme
;; Method 1: Append-based
(define (tree->list-1 tree)
  (if (null? tree)
      '()
      (append (tree->list-1 (left-branch tree))
              (cons (entry tree)
                    (tree->list-1 (right-branch tree)))))

;; Method 2: Accumulator-based
(define (tree->list-2 tree)
  (define (copy-to-list tree result-list)
    (if (null? tree)
        result-list
        (copy-to-list (left-branch tree)
                      (cons (entry tree)
                            (copy-to-list (right-branch tree)
                                          result-list))))
  (copy-to-list tree '()))
```

---

### **Part A: Do They Produce the Same Result?**

#### **Observation**
- Both procedures perform an **in-order traversal** of the binary tree.
- **Output**: A sorted list of elements (since the input is a binary search tree).

#### **Verification**
For any binary search tree, both methods produce **identical results**.
**Example** (from Figure 2.16 in SICP):
```scheme
(define tree '(7 (3 (1 () ()) (5 () ())) (9 () (11 () ()))))
(tree->list-1 tree)  ; => (1 3 5 7 9 11)
(tree->list-2 tree)  ; => (1 3 5 7 9 11)
```
**Conclusion**: Yes, they produce the same result for every valid binary tree.

---

### **Part B: Order of Growth Comparison**

#### **1. `tree->list-1` (Append-Based)**
- **`append` is O(n)** for lists of length `n`.
- For a balanced tree with `n` nodes:
  - At each level, `append` combines lists of size `~n/2`.
  - Recurrence relation:
    \[
    T(n) = 2T(n/2) + O(n)
    \]
  - **Time complexity**: **Θ(n log n)** (from the Master Theorem).

#### **2. `tree->list-2` (Accumulator-Based)**
- Uses **tail recursion** with an accumulator (`result-list`).
- Each `cons` operation is **O(1)**.
- Visits each node exactly once.
- **Time complexity**: **Θ(n)** (linear time).

#### **Comparison**
| Method          | Time Complexity | Reason                          |
|-----------------|-----------------|---------------------------------|
| `tree->list-1`  | Θ(n log n)      | Cost of `append` at each level  |
| `tree->list-2`  | Θ(n)            | Single traversal, O(1) `cons`   |

**Winner**: `tree->list-2` grows more slowly (linear vs. linearithmic).

---

### **Key Takeaways**
1. **Same Output**: Both methods correctly produce an in-order list.
2. **Efficiency**:
   - `tree->list-1` is slower due to `append` overhead.
   - `tree->list-2` is optimal (Θ(n)) for balanced trees.
3. **Practical Use**:
   - Prefer the accumulator-based method (`tree->list-2`) for performance-critical applications.

### **Why It Matters**
- Demonstrates how **algorithm design** (e.g., avoiding `append`) can improve asymptotic performance.
- Highlights the power of **tail recursion** and accumulators.
