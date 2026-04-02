### **Understanding Interval Width**

The **width** of an interval \([a, b]\) is defined as half the difference between its upper and lower bounds:

\[
\text{width} = \frac{b - a}{2}
\]

This measures the **uncertainty** or **error margin** in the interval. For example:
- The interval \([2, 4]\) has a width of \(\frac{4 - 2}{2} = 1\).
- The interval \([-1, 5]\) has a width of \(\frac{5 - (-1)}{2} = 3\).

---

### **1. Width of Sum and Difference of Intervals**
#### **a) Sum of Two Intervals**
Let’s consider two intervals:
\[
x = [a, b], \quad y = [c, d]
\]
Their sum is:
\[
x + y = [a + c, b + d]
\]
The width of the sum is:
\[
\text{width}(x + y) = \frac{(b + d) - (a + c)}{2} = \frac{(b - a) + (d - c)}{2} = \text{width}(x) + \text{width}(y)
\]
So, the width of the sum **depends only on the widths of the input intervals**.

**Example**:
- \(x = [1, 3]\) (width = 1)
- \(y = [4, 6]\) (width = 1)
- \(x + y = [5, 9]\) (width = 2, which is \(1 + 1\)).

#### **b) Difference of Two Intervals**
The difference is:
\[
x - y = [a - d, b - c]
\]
The width of the difference is:
\[
\text{width}(x - y) = \frac{(b - c) - (a - d)}{2} = \frac{(b - a) + (d - c)}{2} = \text{width}(x) + \text{width}(y)
\]
Again, the width of the difference **depends only on the widths of the input intervals**.

**Example**:
- \(x = [1, 3]\) (width = 1)
- \(y = [2, 4]\) (width = 1)
- \(x - y = [-3, 1]\) (width = 2, which is \(1 + 1\)).

---

### **2. Width of Product and Quotient of Intervals**
#### **a) Product of Two Intervals**
The product of two intervals is more complex. The bounds of the product depend on the signs of the intervals. For example:
\[
x = [a, b], \quad y = [c, d]
\]
The product \(x \times y\) has bounds determined by combinations of \(a, b, c, d\):
\[
x \times y = \left[ \min(ac, ad, bc, bd), \max(ac, ad, bc, bd) \right]
\]
The width of the product **cannot** be expressed purely in terms of \(\text{width}(x)\) and \(\text{width}(y)\)—it depends on the actual bounds.

**Example 1** (Same widths, different products):
- \(x = [1, 3]\) (width = 1)
- \(y = [2, 4]\) (width = 1)
- \(x \times y = [2, 12]\) (width = 5).

- \(x' = [-3, -1]\) (width = 1)
- \(y' = [2, 4]\) (width = 1)
- \(x' \times y' = [-12, -2]\) (width = 5).

**Example 2** (Same widths, different results):
- \(x = [0, 2]\) (width = 1)
- \(y = [0, 2]\) (width = 1)
- \(x \times y = [0, 4]\) (width = 2).

- \(x' = [-1, 1]\) (width = 1)
- \(y' = [-1, 1]\) (width = 1)
- \(x' \times y' = [-1, 1]\) (width = 1).

Here, the width of the product **varies even when input widths are the same**.

#### **b) Quotient of Two Intervals**
The quotient \(x / y\) is defined as:
\[
x / y = x \times \left[ \frac{1}{d}, \frac{1}{c} \right] \quad \text{(assuming \(y\) does not contain 0)}
\]
Again, the width of the quotient **depends on the actual bounds**, not just the widths.

**Example**:
- \(x = [1, 3]\) (width = 1)
- \(y = [1, 2]\) (width = 0.5)
- \(x / y = [0.5, 3]\) (width = 1.25).

- \(x' = [1, 3]\) (width = 1)
- \(y' = [2, 4]\) (width = 1)
- \(x' / y' = [0.25, 1.5]\) (width = 0.625).

Here, the width of the quotient **changes even when input widths are fixed**.

---

### **Conclusion**
- **Sum/Difference**: The width of the result depends **only on the widths of the input intervals**.
  \[
  \text{width}(x \pm y) = \text{width}(x) + \text{width}(y)
  \]
- **Product/Quotient**: The width of the result **cannot** be determined solely from the widths of the inputs—it depends on their actual bounds.

This shows that **linear operations (addition/subtraction) preserve width additivity**, while **nonlinear operations (multiplication/division) do not**.
