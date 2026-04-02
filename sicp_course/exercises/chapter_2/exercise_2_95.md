## 🧠 **Why This Matters**

This exercise demonstrates a **key limitation** of the polynomial GCD algorithm (Euclidean algorithm with `div-terms`) when applied directly:

- The algorithm assumes all operations are in a **field of coefficients** (e.g., rational numbers).
- But if you're working over **integers**, then **division may introduce fractions**, and those can cause the GCD computation to fail or return incorrect results.
- This problem shows up when computing the GCD of two polynomials whose common factor includes integer-coefficient terms.

---

## 🔧 Step-by-Step Execution

### 1. **Define Polynomials**

Assuming your system supports sparse polynomials:

```scheme
(define p1 (make-polynomial 'x '((2 1) (1 2) (0 1)))) ; x² + 2x + 1
(define p2 (make-polynomial 'x '((2 11) (0 7))))      ; 11x² + 7
(define p3 (make-polynomial 'x '((1 13) (0 5))))      ; 13x + 5
```

### 2. **Multiply to Form Q1 and Q2**

```scheme
(define q1 (mul p1 p2)) ; Q1 = P1 * P2
(define q2 (mul p1 p3)) ; Q2 = P1 * P3
```

Resulting expressions:

- $ Q1 = (x^2 + 2x + 1)(11x^2 + 7) = 11x^4 + 22x^3 + 18x^2 + 14x + 7 $
- $ Q2 = (x^2 + 2x + 1)(13x + 5) = 13x^3 + 31x^2 + 21x + 5 $

### 3. **Compute GCD of Q1 and Q2**

Now call:

```scheme
(greatest-common-divisor q1 q2)
```

You expect this to return $ P1 = x^2 + 2x + 1 $, but it doesn’t!

Instead, you get something like:

```scheme
(polynomial x ((2 1/143) (1 2/143) (0 1/143)))
```

Or even worse, the GCD algorithm might **fail entirely** because it tries to divide non-divisible terms.

---

## 📌 Why It Fails: A Hand-Walkthrough

Let’s walk through the **GCD algorithm** manually.

We compute $ GCD(Q1, Q2) $ using Euclidean steps:

### Step 1: Divide Q1 by Q2

Q1 is degree 4, Q2 is degree 3 → division is possible.

Leading term: $ \frac{11x^4}{13x^3} = \frac{11}{13}x $

So quotient starts with $ \frac{11}{13}x $, and we multiply back into Q2:

$$
\frac{11}{13}x \cdot Q2 = \frac{11}{13}x \cdot (13x^3 + 31x^2 + 21x + 5) = 11x^4 + \text{(lower terms)}
$$

Subtracting this from Q1 gives a new remainder.

But now the remainder contains **fractions**, and these interfere with later divisions.

Eventually, the algorithm fails to recognize that $ P1 $ is the actual GCD.

---

## 🧮 Key Insight

The **standard Euclidean algorithm for polynomials** works only when:

- Coefficients come from a **field**, like real or rational numbers.
- But here, coefficients are **integers**, and the algorithm introduces **rational coefficients**, which are not simplified back to integers.

So, the computed GCD ends up being a **scalar multiple** of the true GCD — e.g., $ \frac{1}{143} \cdot P1 $ — or the algorithm fails outright.

---

## ✅ Solution Strategy (Optional Enhancement)

To fix this, you could:

- Use **pseudo-division** instead of regular polynomial division, which avoids introducing fractions.
- Multiply by appropriate powers of leading coefficients to keep everything in integers.
- Implement a version of the **primitive Euclidean algorithm** for integer polynomials.

This is explored further in Exercise 2.96.

---

## ✅ Summary

| Concept | Explanation |
|--------|-------------|
| Goal | Compute GCD(Q1, Q2), where Q1 = P1·P2, Q2 = P1·P3 |
| Expected GCD | P1 = x² + 2x + 1 |
| Actual Result | Not P1 — typically a scalar multiple or failure |
| Reason | Integer-only arithmetic leads to fractional intermediate terms during division |
| Fix | Use pseudo-division (Exercise 2.96) to stay within integer domain |
