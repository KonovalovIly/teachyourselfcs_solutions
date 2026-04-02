### **Exercise 2.67: Decoding a Huffman-Encoded Message**

#### **Given Definitions**
1. **Huffman Tree**:
   ```scheme
   (define sample-tree
     (make-code-tree
       (make-leaf 'A 4)
       (make-code-tree
         (make-leaf 'B 2)
         (make-code-tree
           (make-leaf 'D 1)
           (make-leaf 'C 1)))))
   ```
   **Structure**:
   ```
         •
        / \
       A   •
          / \
         B   •
            / \
           D   C
   ```
   - **Weights**: A=4, B=2, D=1, C=1.
   - **Encoding**:
     - `A`: `0`
     - `B`: `10`
     - `D`: `110`
     - `C`: `111`

2. **Encoded Message**:
   ```scheme
   (define sample-message '(0 1 1 0 0 1 0 1 0 1 1 1 0))
   ```

---

### **Decoding Process**
We use the `decode` procedure (from SICP Section 2.3.4) to traverse the tree:
1. Start at the root.
2. Follow `0` for left branch, `1` for right branch.
3. When a leaf is reached, record its symbol and restart at the root.

#### **Step-by-Step Decoding**
| Bits Consumed | Path           | Current Node | Decoded Symbol |
|---------------|----------------|--------------|-----------------|
| `0`           | Left           | Leaf `A`     | `A`             |
| `1 1 0`       | Right → Right → Left | Leaf `D`    | `D`             |
| `0`           | Left           | Leaf `A`     | `A`             |
| `1 0`         | Right → Left   | Leaf `B`     | `B`             |
| `1 0`         | Right → Left   | Leaf `B`     | `B`             |
| `1 1 1 0`     | Right → Right → Right → Left | Leaf `C` | `C`             |

**Decoded Message**: `'(A D A B B C)`

---

### **Verification**
- **Encoded Message**: `0 110 0 10 10 1110`
  - `0` → `A`
  - `110` → `D`
  - `0` → `A`
  - `10` → `B` (x2)
  - `1110` → `C` (trailing `0` is unused)

---

### **Final Answer**
```scheme
(decode sample-message sample-tree)
; => (A D A B B C)
```
