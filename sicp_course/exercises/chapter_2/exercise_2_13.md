### **Exercise 2.13: Approximate Percentage Tolerance of Product of Intervals**

#### **Assumptions**
1. **Small percentage tolerances**: Let the intervals be positive and their tolerances small (e.g., < 10%).
2. **Interval representation**:
   - Let interval \( x \) be \( [x_c (1 - x_p), x_c (1 + x_p)] \), where:
     - \( x_c \) = center value,
     - \( x_p \) = percentage tolerance (e.g., 0.05 for 5%).
   - Similarly, interval \( y = [y_c (1 - y_p), y_c (1 + y_p)] \).

#### **Product of Two Intervals**
The product \( z = x \times y \) has bounds:
\[
z_{\text{lower}} = x_c (1 - x_p) \times y_c (1 - y_p) \approx x_c y_c (1 - x_p - y_p),
\]
\[
z_{\text{upper}} = x_c (1 + x_p) \times y_c (1 + y_p) \approx x_c y_c (1 + x_p + y_p),
\]
where we neglect the small \( x_p y_p \) term (since \( x_p, y_p \) are small).

Thus, the product interval is approximately:
\[
z \approx [x_c y_c (1 - (x_p + y_p)), x_c y_c (1 + (x_p + y_p))].
\]

#### **Percentage Tolerance of the Product**
The tolerance of \( z \) is:
\[
z_p \approx x_p + y_p.
\]

**Conclusion**:
For small tolerances, the **percentage tolerance of the product** is approximately the **sum of the individual tolerances**.

---

### **Lem E. Tweakit’s Complaint: Different Results for Parallel Resistors**

#### **Two Algebraically Equivalent Formulas**
1. **Formula 1**:
   \[
   \text{par1}(r_1, r_2) = \frac{r_1 r_2}{r_1 + r_2}.
   \]
2. **Formula 2**:
   \[
   \text{par2}(r_1, r_2) = \frac{1}{\frac{1}{r_1} + \frac{1}{r_2}}.
   \]

#### **Alyssa’s Interval Implementations**
```scheme
(define (par1 r1 r2)
  (div-interval (mul-interval r1 r2)
                (add-interval r1 r2)))

(define (par2 r1 r2)
  (let ((one (make-interval 1 1)))
    (div-interval one
                  (add-interval (div-interval one r1)
                               (div-interval one r2)))))
```

#### **Why Different Results?**
1. **Interval arithmetic is not distributive**:
   - \( \frac{r_1 r_2}{r_1 + r_2} \) and \( \frac{1}{\frac{1}{r_1} + \frac{1}{r_2}} \) are mathematically equivalent, but **interval operations introduce dependencies** that cause different overapproximations.
   - Each operation (addition, division, multiplication) compounds the approximation error.

2. **Example**:
   Let \( r_1 = [1, 2] \) (100% tolerance) and \( r_2 = [1, 2] \).
   - **par1**:
     \[
     \frac{[1, 2] \times [1, 2]}{[1, 2] + [1, 2]} = \frac{[1, 4]}{[2, 4]} = [0.25, 2].
     \]
   - **par2**:
     \[
     \frac{1}{\frac{1}{[1, 2]} + \frac{1}{[1, 2]}} = \frac{1}{[0.5, 1] + [0.5, 1]} = \frac{1}{[1, 2]} = [0.5, 1].
     \]
   - **Discrepancy**: `par1` gives \([0.25, 2]\), while `par2` gives \([0.5, 1]\).

3. **Cause**:
   - `par1` multiplies first, leading to a **wider intermediate interval** (\([1, 4]\)).
   - `par2` avoids multiplying intervals and keeps dependencies tighter.

#### **Which Version is Better?**
- **`par2` is more accurate** because it minimizes intermediate overapproximation.
- **`par1` overestimates uncertainty** due to early multiplication.

---

### **Key Takeaways**
1. **Product of intervals**: For small tolerances, the tolerance of the product is approximately the sum of the input tolerances.
2. **Interval arithmetic**:
   - Algebraically equivalent formulas can yield different results due to dependency problems.
   - Operations should be arranged to **minimize intermediate overapproximation** (e.g., `par2` is better than `par1`).
3. **Engineering implications**:
   - Use formulas that preserve dependencies (e.g., avoid multiplying intervals early).
   - Prefer **symbolic simplification** before numerical evaluation.

This explains why Lem observed different results—it’s a fundamental limitation of interval arithmetic, not a bug in Alyssa’s code.
