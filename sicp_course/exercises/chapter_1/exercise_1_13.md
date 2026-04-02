We proceed by **mathematical induction**.

---

### **Base Cases**
1. **For \( n = 0 \):**
$$
\text{Fib}(0) = 0, \quad \frac{\phi^0 - \psi^0}{\sqrt{5}} = \frac{1 - 1}{\sqrt{5}} = 0 \quad \text{(holds)}.
$$
2. **For \( n = 1 \):**
$$
   \text{Fib}(1) = 1, \quad \frac{\phi^1 - \psi^1}{\sqrt{5}} = \frac{\frac{1 + \sqrt{5}}{2} - \frac{1 - \sqrt{5}}{2}}{\sqrt{5}} = \frac{\sqrt{5}}{\sqrt{5}} = 1 \quad \text{(holds)}.
   $$

---

### **Inductive Step**
**Assume** the formula holds for \( n = k \) and \( n = k-1 \):
$$
\text{Fib}(k) = \frac{\phi^k - \psi^k}{\sqrt{5}}, \quad \text{Fib}(k-1) = \frac{\phi^{k-1} - \psi^{k-1}}{\sqrt{5}}.
$$
**Show** it holds for \( n = k+1 \):
$$
\text{Fib}(k+1) = \text{Fib}(k) + \text{Fib}(k-1) = \frac{\phi^k - \psi^k}{\sqrt{5}} + \frac{\phi^{k-1} - \psi^{k-1}}{\sqrt{5}}.
$$
Simplify:
$$
{Fib}(k+1) = \frac{\phi^{k-1}(\phi + 1) - \psi^{k-1}(\psi + 1)}{\sqrt{5}}.$$

But ( \phi )  and ( \psi )  satisfy   ( x^2 = x + 1 ), so:

$$\phi + 1 = \phi^2, \quad \psi + 1 = \psi^2.
$$
Thus:
$$
\text{Fib}(k+1) = \frac{\phi^{k+1} - \psi^{k+1}}{\sqrt{5}} \quad \text{(QED)}.

$$

