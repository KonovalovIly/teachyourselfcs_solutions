### **Exercise 2.14: Demonstrating Lem's Observation**

To show that Lem is correct, we will:
1. Define intervals with **small percentage tolerances** (e.g., ~1-5%).
2. Compute expressions like `A/A` and `A/B` using both **interval arithmetic** and **exact arithmetic**.
3. Compare the results in **center-percent form** to see how uncertainty propagates.

---

### **1. Setup: Center-Percent Intervals**
First, we define helper functions from Exercise 2.12:
```scheme
(define (make-center-percent c p)
  (let ((w (* c (/ p 100.0))))
    (make-interval (- c w) (+ c w))))

(define (center i)
  (/ (+ (lower-bound i) (upper-bound i)) 2))

(define (percent i)
  (* 100.0 (/ (width i) (center i))))

(define (width i)
  (/ (- (upper-bound i) (lower-bound i)) 2))
```

---

### **2. Testing `A/A` vs `A/B`**
#### **Case 1: A/A (Should Ideally Be 1 ± 0%)**
Let \( A = 100 \pm 1\% = [99, 101] \).
- **Exact value**: \( A/A = 1 \) (0% tolerance).
- **Interval arithmetic**:
  ```scheme
  (define A (make-center-percent 100 1))
  (div-interval A A)
  ```
  - Bounds: \([99/101, 101/99] \approx [0.9802, 1.0202]\).
  - **Center**: \( \approx 1.0002 \).
  - **Tolerance**: \( \approx 2.00\% \).

**Observation**:
Interval arithmetic overestimates the tolerance (2% vs 0%). This is because it treats the two \( A \)'s as **independent intervals**, losing correlation.

#### **Case 2: A/B (Uncorrelated Intervals)**
Let \( A = 100 \pm 1\% \), \( B = 50 \pm 2\% \).
- **Exact value**: \( A/B = 2 \pm \sqrt{1^2 + 2^2}\% \approx 2 \pm 2.24\% \) (error propagation).
- **Interval arithmetic**:
  ```scheme
  (define B (make-center-percent 50 2))
  (div-interval A B)
  ```
  - Bounds: \([99/51, 101/49] \approx [1.9412, 2.0612]\).
  - **Center**: \( \approx 2.0012 \).
  - **Tolerance**: \( \approx 3.00\% \).

**Observation**:
The tolerance (3%) is close to the theoretical sum (1% + 2% = 3%), as expected for uncorrelated intervals.

---

### **3. Comparing `par1` and `par2`**
Let \( r_1 = 100 \pm 1\% \), \( r_2 = 100 \pm 1\% \).
#### **Formula 1 (`par1`):**
\[
\text{par1} = \frac{r_1 r_2}{r_1 + r_2}
\]
- **Interval arithmetic**:
  - \( r_1 r_2 = [99 \times 99, 101 \times 101] = [9801, 10201] \).
  - \( r_1 + r_2 = [198, 202] \).
  - \( \text{par1} = [9801/202, 10201/198] \approx [48.5198, 51.5202] \).
  - **Center**: \( \approx 50.02 \).
  - **Tolerance**: \( \approx 3.00\% \).

#### **Formula 2 (`par2`):**
\[
\text{par2} = \frac{1}{\frac{1}{r_1} + \frac{1}{r_2}}
\]
- **Interval arithmetic**:
  - \( 1/r_1 = [1/101, 1/99] \approx [0.009901, 0.010101] \).
  - \( 1/r_1 + 1/r_2 \approx [0.019802, 0.020202] \).
  - \( \text{par2} = [1/0.020202, 1/0.019802] \approx [49.500, 50.500] \).
  - **Center**: \( 50.00 \).
  - **Tolerance**: \( \approx 1.00\% \).

**Observation**:
- `par1` overestimates tolerance (3% vs theoretical 1% for correlated resistors).
- `par2` gives the correct tolerance (1%), as it preserves dependency between \( r_1 \) and \( r_2 \).

---

### **4. Why Does This Happen?**
- **Dependency Problem**:
  Interval arithmetic assumes **worst-case independence** between intervals. In `A/A`, the same interval appears twice, but interval arithmetic treats them as independent, leading to overestimation.
- **Algebraic Reformulation**:
  `par2` avoids multiplying intervals directly, reducing overapproximation.

---

### **5. General Behavior**
| Expression | Exact Tolerance | Interval Arithmetic Tolerance | Overestimation? |
|------------|------------------|--------------------------------|------------------|
| \( A/A \)  | 0%               | ~2%                            | Yes              |
| \( A/B \)  | ~2.24%           | ~3%                            | Slight           |
| `par1`     | 1%               | 3%                             | Yes              |
| `par2`     | 1%               | 1%                             | No               |

---

### **Key Takeaways**
1. **Interval arithmetic overestimates uncertainty** when variables are correlated (e.g., `A/A`).
2. **Algebraic equivalence ≠ computational equivalence**:
   `par1` and `par2` are mathematically identical but yield different results due to dependency handling.
3. **Prefer formulas that preserve correlations**:
   `par2` is better because it avoids unnecessary interval products.

Lem is right—Alyssa’s system gives different results for equivalent formulas, and the choice of formulation matters!

**Recommendation**:
For reliable interval arithmetic, use symbolic simplification (like `par2`) to minimize overapproximation.
