### **Exercise 2.65: Θ(n) `union-set` and `intersection-set` for Balanced Binary Trees**

#### **Key Insights from Previous Exercises**
1. **Exercise 2.63**:
   - `tree->list-2` converts a balanced tree to a sorted list in **Θ(n)** time.
2. **Exercise 2.64**:
   - `list->tree` converts a sorted list to a balanced tree in **Θ(n)** time.

#### **Strategy**
1. **Convert trees to sorted lists** (Θ(n)).
2. **Merge lists** (Θ(n) for union/intersection).
3. **Convert the result back to a balanced tree** (Θ(n)).

---

### **1. Union of Two Balanced Trees**
```scheme
(define (union-set-tree tree1 tree2)
  (list->tree
    (union-sorted-lists
      (tree->list-2 tree1)
      (tree->list-2 tree2))))

(define (union-sorted-lists list1 list2)
  (cond ((null? list1) list2)
        ((null? list2) list1)
        ((= (car list1) (car list2))
         (cons (car list1)
               (union-sorted-lists (cdr list1) (cdr list2))))
        ((< (car list1) (car list2))
         (cons (car list1)
               (union-sorted-lists (cdr list1) list2)))
        (else
         (cons (car list2)
               (union-sorted-lists list1 (cdr list2))))))
```

#### **Steps**
1. Convert `tree1` and `tree2` to sorted lists (Θ(n)).
2. Merge lists while skipping duplicates (Θ(n)).
3. Convert the merged list back to a balanced tree (Θ(n)).

**Total Time**: Θ(n).

---

### **2. Intersection of Two Balanced Trees**
```scheme
(define (intersection-set-tree tree1 tree2)
  (list->tree
    (intersection-sorted-lists
      (tree->list-2 tree1)
      (tree->list-2 tree2))))

(define (intersection-sorted-lists list1 list2)
  (cond ((or (null? list1) (null? list2)) '())
        ((= (car list1) (car list2))
         (cons (car list1)
               (intersection-sorted-lists (cdr list1) (cdr list2))))
        ((< (car list1) (car list2))
         (intersection-sorted-lists (cdr list1) list2))
        (else
         (intersection-sorted-lists list1 (cdr list2)))))
```

#### **Steps**
1. Convert `tree1` and `tree2` to sorted lists (Θ(n)).
2. Traverse both lists to collect common elements (Θ(n)).
3. Convert the result back to a balanced tree (Θ(n)).

**Total Time**: Θ(n).

---

### **Complexity Analysis**
| Step                     | Time  |
|--------------------------|-------|
| `tree->list-2` (x2)      | Θ(n)  |
| Merge sorted lists       | Θ(n)  |
| `list->tree`             | Θ(n)  |
| **Total**                | Θ(n)  |

---

### **Example**
**Input Trees**:
```scheme
(define tree1 '(3 (1 () ()) (5 () ())))
(define tree2 '(4 (2 () ()) (6 () ())))
```

**Union**:
```scheme
(union-set-tree tree1 tree2)
; => '(3 (1 () (2 () ())) (5 (4 () ()) (6 () ())))
```
**Visualization**:
```
      3
     / \
    1   5
     \ / \
     2 4 6
```

**Intersection** (no common elements):
```scheme
(intersection-set-tree tree1 tree2)
; => '()
```

---

### **Why This Works**
1. **Balanced Trees → Sorted Lists**:
   - In-order traversal (`tree->list-2`) preserves order and runs in Θ(n).
2. **Sorted Lists → Efficient Merge**:
   - Union/intersection on sorted lists is Θ(n) (single pass).
3. **Sorted List → Balanced Tree**:
   - `list->tree` recursively splits the list at the midpoint (Θ(n)).

### **Key Takeaway**
By combining:
1. Fast conversions between trees and lists (Exercises 2.63–2.64),
2. Linear-time merge operations on sorted lists,

we achieve **Θ(n)** set operations on balanced trees, a significant improvement over the Θ(n²) versions for unordered lists. This is optimal for immutable functional data structures.
