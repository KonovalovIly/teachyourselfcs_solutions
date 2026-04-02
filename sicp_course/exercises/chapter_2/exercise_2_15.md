### **Exercise 2.15: Is Eva Lu Ator Correct About `par2` Being Better?**

**Short Answer**:
**Yes, Eva is correct.** `par2` produces tighter (more accurate) error bounds than `par1` because it avoids repeating uncertain variables in the computation, which reduces overestimation of uncertainty in interval arithmetic.

---

### **Detailed Explanation**

#### **1. The Core Problem: Dependency in Interval Arithmetic**
Interval arithmetic treats **each occurrence of a variable as independent**, even if they represent the same physical quantity. This leads to:
- **Overestimation of uncertainty**: When a variable appears multiple times (e.g., `A/A` or `par1`), the calculation assumes worst-case independence, widening the result interval unnecessarily.
- **Tighter bounds when variables are not repeated**: If no uncertain variable is repeated (e.g., `par2`), the calculation preserves correlations and gives more accurate bounds.

#### **2. Example: `par1` vs. `par2` for Parallel Resistors**
Let \( r_1 = r_2 = 100 \pm 1\% = [99, 101] \).

##### **`par1`: Repeats Uncertain Variables**
\[
\text{par1} = \frac{r_1 \times r_2}{r_1 + r_2}
\]
- **Step 1**: \( r_1 \times r_2 = [99, 101] \times [99, 101] = [9801, 10201] \).
  (Width explodes due to repeated multiplication.)
- **Step 2**: \( r_1 + r_2 = [99, 101] + [99, 101] = [198, 202] \).
- **Result**: \([9801/202, 10201/198] \approx [48.52, 51.52]\).
  **Tolerance**: ~3% (overestimates the true 1% tolerance).

##### **`par2`: No Repeated Uncertain Variables**
\[
\text{par2} = \frac{1}{\frac{1}{r_1} + \frac{1}{r_2}}
\]
- **Step 1**: \( 1/r_1 = [1/101, 1/99] \approx [0.0099, 0.0101] \).
- **Step 2**: \( 1/r_1 + 1/r_2 \approx [0.0198, 0.0202] \).
- **Result**: \([1/0.0202, 1/0.0198] \approx [49.50, 50.50]\).
  **Tolerance**: ~1% (matches the true tolerance).

#### **3. Why `par2` is Better**
- **No repeated variables**: The uncertain quantities \( r_1 \) and \( r_2 \) appear only once each in `par2`, avoiding artificial widening of bounds.
- **Preserves correlations**: The algebraic structure of `par2` implicitly accounts for dependencies between terms.
- **Tighter error bounds**: The result is closer to the theoretical uncertainty propagation.

#### **4. General Rule (Eva’s Insight)**
A formula will produce **tighter error bounds** in interval arithmetic if:
1. **No uncertain variable is repeated** (e.g., avoid \( A/A \)).
2. **Uncertain variables appear linearly** (e.g., \( A + B \) is better than \( A \times B \) if possible).
3. **Avoid early multiplication/division of intervals** (e.g., `par2` delays division until the end).

#### **5. Counterexample: `A/A` vs. `1`**
- **Exact value**: \( A/A = 1 \) (0% tolerance).
- **Interval arithmetic**: \( A/A \) gives \([0.98, 1.02]\) for \( A = 100 \pm 1\% \), introducing 2% artificial tolerance.
  This happens solely due to repeated variables.

---

### **Conclusion: Eva is Right**
- **`par2` is better** because it avoids repeating uncertain variables, yielding tighter and more realistic error bounds.
- **`par1` is worse** because it repeats \( r_1 \) and \( r_2 \), causing interval arithmetic to overestimate uncertainty.
- **Engineers should prefer formulas like `par2`** when using interval arithmetic to minimize false uncertainty.

**Key Takeaway**:
In interval arithmetic, **how you write the formula matters**. Eliminating repeated variables improves accuracy.
