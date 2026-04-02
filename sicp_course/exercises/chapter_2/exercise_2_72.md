### **Exercise 2.72: Time Complexity of Huffman Encoding**

#### **Key Observations**
1. **General Case Complexity**:
   - The time to encode a symbol depends on:
     - The depth of the symbol in the Huffman tree (code length).
     - The cost of searching the symbol list at each node.
   - For a balanced tree: **O(log n)** per symbol.
   - For an imbalanced tree: **O(n)** in the worst case.

2. **Special Case (Exponential Frequencies from Ex. 2.71)**:
   - The Huffman tree is **maximally imbalanced** (a "comb").
   - Most frequent symbol: Depth = 1.
   - Least frequent symbol: Depth = \(n-1\).

---

### **1. Encoding the Most Frequent Symbol**
- **Code Length**: 1 bit (`0`).
- **Steps**:
  1. Check if the symbol is in the root's right subtree (no).
  2. Return `0`.
- **Time Complexity**: **O(1)** (constant time).

#### **Why?**
- The most frequent symbol is always the **first comparison** at the root node.

---

### **2. Encoding the Least Frequent Symbol**
- **Code Length**: \(n-1\) bits (all `1`s).
- **Steps**:
  1. At each of the \(n-1\) nodes:
     - Search the symbol list (size \(\leq n\)).
     - Traverse right (`1`).
  2. Final step: Confirm the symbol at the leaf.
- **Time Complexity**: **O(n²)**.

#### **Breakdown**:
- **Symbol List Searches**:
  At each of \(n-1\) nodes, search a symbol list of size \(\leq n\) (using `memq` → O(n) per search).
  Total: \((n-1) \times O(n) = O(n²)\).

- **Tree Traversal**:
  \(n-1\) steps (linear in \(n\)).

- **Total**: Dominated by \(O(n²)\) from symbol searches.

---

### **3. Comparison with Balanced Trees**
| Symbol Type       | Imbalanced Tree (Ex. 2.71) | Balanced Tree |
|-------------------|----------------------------|---------------|
| Most Frequent     | O(1)                       | O(log n)      |
| Least Frequent    | O(n²)                      | O(n log n)    |

---

### **Why This Matters**
1. **Worst-Case Scenario**:
   - The exponential frequency distribution creates the **least efficient** Huffman tree for rare symbols.
   - Symbol list searches dominate the time.

2. **Practical Implications**:
   - Huffman coding is **optimal for message length** but **not always for encoding speed**.
   - For skewed distributions, cache symbol-to-code mappings to avoid O(n²) searches.

---

### **Final Answer**
For the special case in Exercise 2.71:
- **Most frequent symbol**: **O(1)** (constant time).
- **Least frequent symbol**: **O(n²)** (quadratic time).

The quadratic cost comes from repeated symbol list searches in an imbalanced tree. For general trees, the complexity depends on the balance and symbol distribution.
